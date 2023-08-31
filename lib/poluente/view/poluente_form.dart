import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/poluente/poluente.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PoluenteForm extends StatefulWidget {
  const PoluenteForm({super.key});

  @override
  State<StatefulWidget> createState() => _PoluenteFormState();
}

class _PoluenteFormState extends State<PoluenteForm> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final _validator = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de poluentes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: BlocListener<PoluenteBloc, PoluenteState>(
        bloc: BlocProvider.of<PoluenteBloc>(context),
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          switch (state.status) {
            case PoluenteStatus.added || PoluenteStatus.updated:
              messenger.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Poluente salvo com sucesso.',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            case PoluenteStatus.deleted:
              messenger
                  .showSnackBar(
                    const SnackBar(
                      width: 500,
                      behavior: SnackBarBehavior.floating,
                      content: const Text(
                        'Poluente excluído com sucesso.',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  )
                  .closed
                  .then((reason) => Navigator.pop(context));
            case PoluenteStatus.error:
              messenger.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Ocorreu um Erro!!! Tente novamente mais tarde.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            default:
          }
        },
        child: BlocBuilder<PoluenteBloc, PoluenteState>(
          bloc: BlocProvider.of<PoluenteBloc>(context),
          builder: (context, state) {
            return Column(
              children: [
                (state.isBusy) ? LinearProgressIndicator() : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Form(
                        key: _validator,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Gerenciamento adequado da'
                                ' monitorização, controle e mitigação'
                                ' das diferentes fontes de emissão'
                                ' de poluentes'),
                            _NameInput(_validator),
                            _SizeInput(),
                            _SolutionInput(),
                            _DateInput(),
                          ]
                              .map(
                                (widget) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: widget,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<PoluenteBloc, PoluenteState>(
        bloc: BlocProvider.of<PoluenteBloc>(context),
        builder: (context, state) {
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: (state.isBusy || !state.isValid)
                ? null
                : () {
                    if (_validator.currentState!.validate()) {
                      if (state.poluente.isEmpty) {
                        BlocProvider.of<PoluenteBloc>(context)
                            .add(AddPoluente(state.poluente));
                      } else {
                        BlocProvider.of<PoluenteBloc>(context)
                            .add(UpdatePoluente(state.poluente));
                      }
                    }
                  },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BlocBuilder<PoluenteBloc, PoluenteState>(
        bloc: BlocProvider.of<PoluenteBloc>(context),
        builder: (context, state) {
          final _dipacthDelete = () => BlocProvider.of<PoluenteBloc>(context)
              .add(DeletePoluente(state.poluente));
          return BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ButtonBar(
                  children: [
                    ElevatedButton.icon(
                      onPressed: (state.isBusy ||
                              !state.isValid ||
                              state.poluente.isEmpty)
                          ? null
                          : () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: const Text('Tem certeza que deseja'
                                      ' excluir este poluente?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancelar'),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'Excluir');
                                        _dipacthDelete();
                                      },
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput(GlobalKey<FormState> validator)
      : this._validator = validator;

  final GlobalKey<FormState> _validator;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoluenteBloc, PoluenteState>(
      bloc: BlocProvider.of<PoluenteBloc>(context),
      builder: (context, state) {
        return TextFormField(
          autofocus: true,
          enabled: !state.isBusy && state.isValid,
          initialValue: state.poluente.name,
          onChanged: (name) {
            state.poluente.name = name;
            _validator.currentState!.validate();
          },
          validator: (name) => name!.isEmpty ? 'Nome obrigatório' : null,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Nome',
            hintText: 'Nome do poluente',
            helperText: 'Poluentes do ar, da água, químicos e biológicos',
          ),
        );
      },
    );
  }
}

class _SizeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoluenteBloc, PoluenteState>(
      bloc: BlocProvider.of<PoluenteBloc>(context),
      builder: (context, state) {
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          initialValue: (state.poluente.size ?? '').toString(),
          onChanged: (size) => state.poluente.size = int.parse(size),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Quantidade',
            hintText: 'Quantidade do poluente',
            helperText: 'Quantidade de poluente gerado, coletado e tratado',
          ),
        );
      },
    );
  }
}

class _SolutionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoluenteBloc, PoluenteState>(
      bloc: BlocProvider.of<PoluenteBloc>(context),
      builder: (context, state) {
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          initialValue: state.poluente.solution ?? '',
          onChanged: (solution) => state.poluente.solution = solution,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Tratamento',
            hintText: 'Tratamento para o poluente',
            helperText: 'Planos e estratégias para mitigar os'
                ' efeitos da poluição',
          ),
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    return BlocBuilder<PoluenteBloc, PoluenteState>(
      bloc: BlocProvider.of<PoluenteBloc>(context),
      builder: (context, state) {
        try {
          _controller.text =
              DateFormat.yMMMMd('pt_BR').format(state.poluente.date!);
        } catch (exception) {}
        return TextFormField(
          enabled: !state.isBusy && state.isValid,
          readOnly: true,
          controller: _controller,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.date_range),
            labelText: 'Data',
            hintText: 'Data de conclusão',
            helperText: 'Data de conclusão para tratamento do poluente',
          ),
          onTap: () async {
            final now = state.poluente.date ?? DateTime.now();
            state.poluente.date = await showDatePicker(
              context: context,
              locale: Locale('pt', 'BR'),
              initialDate: now,
              firstDate: DateTime(now.year - 5),
              lastDate: DateTime(now.year + 5),
            );
            try {
              _controller.text =
                  DateFormat.yMMMMd('pt_BR').format(state.poluente.date!);
            } catch (exception) {}
          },
        );
      },
    );
  }
}

import 'package:database_repository/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/poluente/poluente.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PoluentesPage extends StatefulWidget {
  const PoluentesPage({super.key});

  @override
  State<StatefulWidget> createState() => _PoluentesPageState();
}

class _PoluentesPageState extends State<PoluentesPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    BlocProvider.of<PoluentesBloc>(context).add(ListAllPoluentes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de poluentes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: BlocListener<PoluentesBloc, PoluentesState>(
        bloc: BlocProvider.of<PoluentesBloc>(context),
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();
          switch (state.status) {
            case PoluentesStatus.error:
              messenger.showSnackBar(
                const SnackBar(
                  width: 500,
                  behavior: SnackBarBehavior.floating,
                  content: const Text(
                    'Erro inesperado!!! Tenter novamente mais tarde.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            default:
          }
        },
        child: BlocBuilder<PoluentesBloc, PoluentesState>(
          bloc: BlocProvider.of<PoluentesBloc>(context),
          builder: (context, state) {
            switch (state.status) {
              case PoluentesStatus.loading:
                return const LinearProgressIndicator();
              case PoluentesStatus.loaded:
                if (state.poluentes!.isEmpty) {
                  return const Center(
                    child: const Text('A lista de poluentes está vazia.'),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (constext, index) => const Divider(),
                  itemCount: state.poluentes!.length,
                  itemBuilder: (constext, index) {
                    String date = '';
                    try {
                      date = DateFormat.yMMMMd('pt_BR')
                          .format(state.poluentes![index].date!);
                    } catch (exception) {}
                    return ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text(state.poluentes![index].name[0]),
                        ),
                      ),
                      title: Text(state.poluentes![index].name),
                      subtitle: Text(date),
                      trailing:
                          Text((state.poluentes![index].size ?? '').toString()),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<PoluentesPage>(
                          builder: (_) => BlocProvider.value(
                            value: PoluenteBloc(
                                user:
                                    BlocProvider.of<PoluentesBloc>(context).user,
                                poluente: state.poluentes![index]),
                            child: PoluenteForm(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              default:
                return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<PoluentesPage>(
              builder: (_) => BlocProvider.value(
                value: PoluenteBloc(
                    user: BlocProvider.of<PoluentesBloc>(context).user,
                    poluente: Poluente.empty),
                child: PoluenteForm(),
              ),
            ),
          );
        },
      ),
    );
  }
}

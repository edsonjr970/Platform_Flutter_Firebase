part of 'poluente_bloc.dart';

sealed class PoluenteEvent {
  const PoluenteEvent();
}

final class AddPoluente extends PoluenteEvent {
  const AddPoluente(this.poluente);
  final Poluente poluente;
}

final class UpdatePoluente extends PoluenteEvent {
  const UpdatePoluente(this.poluente);
  final Poluente poluente;
}

final class DeletePoluente extends PoluenteEvent {
  const DeletePoluente(this.poluente);
  final Poluente poluente;
}

part of 'poluentes_bloc.dart';

sealed class PoluentesEvent {
  const PoluentesEvent();
}

final class ListAllPoluentes extends PoluentesEvent {
  const ListAllPoluentes();
}

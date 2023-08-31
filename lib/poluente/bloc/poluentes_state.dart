part of 'poluentes_bloc.dart';

enum PoluentesStatus { initial, loading, loaded, changed, error }

final class PoluentesState extends Equatable {
  const PoluentesState._({required this.status, this.poluentes, this.error});

  const PoluentesState.initial() : this._(status: PoluentesStatus.initial);

  const PoluentesState.loading() : this._(status: PoluentesStatus.loading);

  const PoluentesState.loaded({required List<Poluente>? poluentes})
      : this._(status: PoluentesStatus.loaded, poluentes: poluentes);

  const PoluentesState.changed({required List<Poluente>? poluentes})
      : this._(status: PoluentesStatus.changed, poluentes: poluentes);

  const PoluentesState.error({required Object error})
      : this._(status: PoluentesStatus.error, error: error);

  final PoluentesStatus status;
  final List<Poluente>? poluentes;
  final Object? error;

  @override
  List<Object> get props => [status];
}

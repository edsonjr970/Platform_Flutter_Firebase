part of 'poluente_bloc.dart';

enum PoluenteStatus {
  initial,
  adding,
  added,
  updating,
  updated,
  deleting,
  deleted,
  error
}

final class PoluenteState extends Equatable {
  const PoluenteState._(
      {required this.status, required this.poluente, this.error});

  const PoluenteState.initial({required Poluente poluente})
      : this._(status: PoluenteStatus.initial, poluente: poluente);

  const PoluenteState.adding({required Poluente poluente})
      : this._(status: PoluenteStatus.adding, poluente: poluente);

  const PoluenteState.added({required Poluente poluente})
      : this._(status: PoluenteStatus.added, poluente: poluente);

  const PoluenteState.updating({required Poluente poluente})
      : this._(status: PoluenteStatus.updating, poluente: poluente);

  const PoluenteState.updated({required Poluente poluente})
      : this._(status: PoluenteStatus.updated, poluente: poluente);

  const PoluenteState.deleting({required Poluente poluente})
      : this._(status: PoluenteStatus.deleting, poluente: poluente);

  const PoluenteState.deleted({required Poluente poluente})
      : this._(status: PoluenteStatus.deleted, poluente: poluente);

  const PoluenteState.error({required Poluente poluente, required Object error})
      : this._(status: PoluenteStatus.error, poluente: poluente, error: error);

  final PoluenteStatus status;
  final Poluente poluente;
  final Object? error;

  bool get isBusy {
    if (this.status
        case PoluenteStatus.adding ||
            PoluenteStatus.updating ||
            PoluenteStatus.deleting) return true;
    return false;
  }

  bool get isValid => this.status != PoluenteStatus.deleted;

  @override
  List<Object> get props => [status, poluente];
}

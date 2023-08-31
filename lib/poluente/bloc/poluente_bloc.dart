import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'poluente_event.dart';
part 'poluente_state.dart';

class PoluenteBloc extends Bloc<PoluenteEvent, PoluenteState> {
  PoluenteBloc(
      {required User user,
      required Poluente poluente,
      PoluenteRepository? poluenteRepository})
      : user = user,
        _poluenteRepository = poluenteRepository ?? PoluenteRepository(),
        super(PoluenteState.initial(poluente: poluente)) {
    on<AddPoluente>((event, emit) async {
      emit(PoluenteState.adding(poluente: event.poluente));
      emit(await _poluenteRepository
          .add(userId: user.id, poluente: event.poluente)
          .then(
        (poluente) {
          return PoluenteState.added(poluente: poluente);
        },
        onError: (error, stackTrace) {
          print(error);
          return PoluenteState.error(poluente: event.poluente, error: error);
        },
      ));
    });
    on<UpdatePoluente>((event, emit) async {
      emit(PoluenteState.updating(poluente: event.poluente));
      emit(await _poluenteRepository
          .update(userId: user.id, poluente: event.poluente)
          .then(
        (result) {
          return PoluenteState.updated(poluente: event.poluente);
        },
        onError: (error, stackTrace) {
          print(error);
          return PoluenteState.error(poluente: event.poluente, error: error);
        },
      ));
    });
    on<DeletePoluente>((event, emit) async {
      emit(PoluenteState.deleting(poluente: event.poluente));
      emit(await _poluenteRepository
          .delete(userId: user.id, poluente: event.poluente)
          .then(
        (result) {
          return PoluenteState.deleted(poluente: event.poluente);
        },
        onError: (error, stackTrace) {
          print(error);
          return PoluenteState.error(poluente: event.poluente, error: error);
        },
      ));
    });
  }

  final User user;
  final PoluenteRepository _poluenteRepository;
}

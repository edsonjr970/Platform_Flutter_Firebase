import 'package:authentication_repository/authentication_repository.dart';
import 'package:database_repository/database_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'poluentes_event.dart';
part 'poluentes_state.dart';

class PoluentesBloc extends Bloc<PoluentesEvent, PoluentesState> {
  PoluentesBloc({required User user, PoluenteRepository? poluenteRepository})
      : user = user,
        _poluenteRepository = poluenteRepository ?? PoluenteRepository(),
        super(PoluentesState.initial()) {
    on<ListAllPoluentes>((event, emit) async {
      emit(PoluentesState.loading());
      final listAll = _poluenteRepository.listAll(userId: user.id);
      listAll.listen(
        (poluentes) {
          emit(PoluentesState.changed(poluentes: poluentes));
        },
        onError: (error, stackTrace) {
          print(error);
          return PoluentesState.error(error: error);
        },
      );
      await emit.forEach(
        listAll,
        onData: (List<Poluente> poluentes) {
          return PoluentesState.loaded(poluentes: poluentes);
        },
        onError: (error, stackTrace) {
          print(error);
          return PoluentesState.error(error: error);
        },
      );
    });
  }

  final User user;
  final PoluenteRepository _poluenteRepository;
}

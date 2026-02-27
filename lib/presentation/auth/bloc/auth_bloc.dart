import 'package:task28_02/app_export.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Step 1: Login and get token
      final token = await _authRepository.login(event.username, event.password);

      // Step 2: Fetch user profile (hardcoded id = 1)
      final user =
          await _authRepository.fetchUser(AppConstants.hardcodedUserId);

      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitial());
  }
}

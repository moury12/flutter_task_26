import 'package:task28_02/app_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        getIt<AuthRepository>(),
      ),
      child: MaterialApp(
        title: 'Daraz Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF85606), // Daraz orange/red
            primary: const Color(0xFFF85606),
            secondary: const Color(0xFFF85606),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F4F4),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF85606),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF85606),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

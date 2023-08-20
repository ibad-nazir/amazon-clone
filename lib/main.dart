import 'package:ecomerceapp/Common/widgets/bottom_nav.dart';
import 'package:ecomerceapp/constants/global_variable.dart';
import 'package:ecomerceapp/features/admin/screens/admin_screens.dart';
import 'package:ecomerceapp/provider/user_provider.dart';
import 'package:ecomerceapp/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/services/auth_service.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black54)),
        colorScheme:
            const ColorScheme.light(primary: GlobalVariables.secondaryColor),
        // useMaterial3: true,
      ),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? Provider.of<UserProvider>(context).user.type == 'user'
              ? const BottomNavBar()
              : const AdminScreen()
          : const LoginScreen(),
    );
  }
}

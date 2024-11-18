import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/message/message_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load message when page initializes
    context.read<MessageBloc>().add(LoadMessage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate to login page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clean Architecture Demo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoaded) {
                return Text(
                  state.message,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
} 
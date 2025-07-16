import 'package:flutter/material.dart';

import 'mixin/home_view_mixin.dart';

// HomeView is a class that contains the view for the home screen.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  @override
  Widget build(BuildContext context) {
    // ListenableBuilder rebuilds its child widget when the viewModel notifies listeners.
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Home (ChangeNotifier)')),
          body: Center(
            child: Text(
              'Counter: ${viewModel.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: viewModel.increment,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

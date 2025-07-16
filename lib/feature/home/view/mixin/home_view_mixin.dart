import 'package:flutter/material.dart';

import '../../view_model/home_view_model.dart';
import '../home_view.dart';

/// Mixin for the HomeView.
/// This is a good place to handle view-specific logic that is not part of the
/// business logic in the ViewModel, such as AnimationControllers,
/// TextEditingControllers, or ScrollControllers.
/// It also manages the lifecycle of the ViewModel.
mixin HomeViewMixin on State<HomeView> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}

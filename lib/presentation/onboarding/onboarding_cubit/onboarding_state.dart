part of 'onboarding_cubit.dart';

@immutable
abstract class OnboardingState {}

class OnboardingInitialState extends OnboardingState {}
class OnboardingGoNextState extends OnboardingState {}
class OnboardingGoPreviousState extends OnboardingState {}
class OnboardingOnPageChangedState extends OnboardingState {}


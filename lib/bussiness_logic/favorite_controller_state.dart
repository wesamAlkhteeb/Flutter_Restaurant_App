part of 'favorite_controller_cubit.dart';

@immutable
abstract class FavoriteControllerState {}

class FavoriteControllerDone extends FavoriteControllerState{}
class FavoriteControllerLoading extends FavoriteControllerState{}
class FavoriteControllerError extends FavoriteControllerState{}
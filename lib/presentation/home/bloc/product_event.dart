import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final String? category;

  const FetchProducts({this.category});

  @override
  List<Object?> get props => [category];
}

class RefreshProducts extends ProductEvent {
  final String? category;

  const RefreshProducts({this.category});

  @override
  List<Object?> get props => [category];
}

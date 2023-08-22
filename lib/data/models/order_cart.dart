class OrderModel {
  String nameUser, date, totalPrice, state , idOrder;
  OrderModel({
    required this.idOrder,
    required this.nameUser,
    required this.date,
    required this.totalPrice,
    required this.state,
  });

  @override
  String toString() {
    return 'OrderModel{nameUser: $nameUser, date: $date, totalPrice: $totalPrice, state: $state}';
  }
}

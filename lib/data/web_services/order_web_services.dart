
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rest_app/bussiness_logic/order_controller_cubit.dart';
import 'package:rest_app/data/models/cart_model.dart';
import 'package:rest_app/data/models/meal_order_model.dart';
import 'package:rest_app/data/models/order_cart.dart';
import 'package:rest_app/data/notification_id/load_token.dart';
import 'package:rest_app/services/firebase_messageing_services.dart';
import 'package:rest_app/services/storage_services.dart';

class OrderWebServices {
  String idUser = "id_user";
  String idOrder = "id_order";
  String idRestaurant = "id_restaurant";
  String date = "date";
  String stateOrder = "state_order";
  String nameMeal = "name_meal";
  String numberOfMeal = "number_of_price";
  String totalPrice = "total_price";
  String imageMeal = "image_meal";

  String orderCollection = "Order";
  String detailOrderCollection = "DetailOrder";
  String userCollection = "User";

  Future<String> addOrder({required CartModel cartModel}) async {
    try {
      final lastOrder = await FirebaseFirestore.instance
          .collection("Order")
          .where(idUser,
              isEqualTo: StorageServices.getInstance()
                  .loadData(key: TokenKeyStorage()))
          .where(idRestaurant, isEqualTo: cartModel.idRestaurant)
          .get();
      if(lastOrder.docs.isNotEmpty){
        return "you sent order . you can delete last order and re-order ❌";
      }
      double sum = 0;
      for (int i = 0; i < cartModel.allOrder.length; i++) {
        sum += (double.parse(cartModel.allOrder[i].numberOfMeal) *
            double.parse(cartModel.allOrder[i].priceOneMeal));
      }
      final order =
          await FirebaseFirestore.instance.collection(orderCollection).add({
        idUser: StorageServices.getInstance().loadData(key: TokenKeyStorage()),
        date: Timestamp.now(),
        stateOrder: NewOrderState().state,
        idRestaurant: cartModel.idRestaurant,
        totalPrice: sum.toStringAsFixed(2),
      });
      for (int i = 0; i < cartModel.allOrder.length; i++) {
        final a = await FirebaseFirestore.instance
            .collection(detailOrderCollection)
            .add({
          idOrder: order.id,
          nameMeal: cartModel.allOrder[i].nameMeal,
          imageMeal: cartModel.allOrder[i].imageUri,
          numberOfMeal: cartModel.allOrder[i].numberOfMeal,
        });
      }
      final a = await FirebaseFirestore.instance
          .collection("User")
          .where("id",
              isEqualTo: StorageServices.getInstance()
                  .loadData(key: TokenKeyStorage()))
          .get();
      FirebaseMessagingServices.instance().sendNotification(
        title:
            StorageServices.getInstance().loadData(key: UsernameKeyStorage())!,
        body: "order from ${a.docs[0].data()["username"]}",
        loadToken: LoadToken(id: cartModel.idRestaurant),
      );
    } catch (e) {
      return "";
    }
    return "your order has been sent.";
  }

  Future<List<OrderModel>> getOrdersForChief() async {
    List<OrderModel> ordersList = [];
    try {
      final orders = await FirebaseFirestore.instance
          .collection(orderCollection)
          .where(
            idRestaurant,
            isEqualTo:
                StorageServices.getInstance().loadData(key: TokenKeyStorage()),
          )
          .get();
      for (int i = 0; i < orders.docs.length; i++) {
        Timestamp d = orders.docs[i][date];
        ordersList.add(
          OrderModel(
            idOrder: orders.docs[i].id,
            nameUser: (await FirebaseFirestore.instance
                    .collection(userCollection)
                    .where("id", isEqualTo: orders.docs[i][idUser])
                    .get())
                .docs[0]["username"],
            date:
                " ${d.toDate().year} / ${d.toDate().month} / ${d.toDate().day} ",
            totalPrice: orders.docs[i][totalPrice],
            state: orders.docs[i][stateOrder],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    return ordersList;
  }

  Future<List<OrderModel>> getOrdersForUser() async {
    List<OrderModel> ordersList = [];
    try {
      final orders = await FirebaseFirestore.instance
          .collection(orderCollection)
          .where(
            idUser,
            isEqualTo:
                StorageServices.getInstance().loadData(key: TokenKeyStorage()),
          )
          .get();
      for (int i = 0; i < orders.docs.length; i++) {
        Timestamp d = orders.docs[i][date];
        ordersList.add(
          OrderModel(
            idOrder: orders.docs[i].id,
            nameUser: (await FirebaseFirestore.instance
                    .collection(userCollection)
                    .where("id", isEqualTo: orders.docs[i][idRestaurant])
                    .get())
                .docs[0]["username"],
            date:
                " ${d.toDate().year} / ${d.toDate().month} / ${d.toDate().day} ",
            totalPrice: orders.docs[i][totalPrice],
            state: orders.docs[i][stateOrder],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    return ordersList;
  }

  Future<List<MealOrderModel>> getDetailOrder({required String idOrder}) async {
    List<MealOrderModel> mealOrderList = [];
    try {
      final detailOrder = await FirebaseFirestore.instance
          .collection(detailOrderCollection)
          .where(this.idOrder, isEqualTo: idOrder)
          .get();
      for (int i = 0; i < detailOrder.docs.length; i++) {
        mealOrderList.add(
          MealOrderModel(
            name: detailOrder.docs[i][nameMeal],
            pieces: detailOrder.docs[i][numberOfMeal],
            image: detailOrder.docs[i][imageMeal],
          ),
        );
      }
    } catch (e) {}
    return mealOrderList;
  }

  Future<void> changeState(
      {required OrderState orderState, required String idOrder}) async {
    try {
      final order = await FirebaseFirestore.instance
          .collection(orderCollection)
          .doc(idOrder)
          .get();
      String state = order[stateOrder];
      String message = "";
      if (state.contains(FinishOrderState().state) &&
          orderState is AcceptOrderState) {
        message = "please give me some time.";
      } else if (state.contains(NewOrderState().state) &&
          orderState is AcceptOrderState) {
        message = "order is Accepted";
      } else if (state.contains(AcceptOrderState().state) &&
          orderState is FinishOrderState) {
        message = "order is Finish";
      }
      await FirebaseFirestore.instance
          .collection(orderCollection)
          .doc(idOrder)
          .update({stateOrder: orderState.state});
      FirebaseMessagingServices.instance().sendNotification(
        title: "State Order",
        body: message,
        loadToken: LoadToken(id: order["id_user"]),
      );
    } catch (e) {}
  }

  Future deleteOrder({required String idOrder}) async {
    try {
      String state = (await FirebaseFirestore.instance
          .collection(orderCollection)
          .doc(idOrder)
          .get())[stateOrder];
      String message = "";

      final mealsOrder = await FirebaseFirestore.instance
          .collection(detailOrderCollection)
          .where(this.idOrder, isEqualTo: idOrder)
          .get();
      if (state.contains(NewOrderState().state)) {
        final order = await FirebaseFirestore.instance.collection(orderCollection).doc(idOrder).get();
        FirebaseMessagingServices.instance().sendNotification(
          title: "state order",
          body: StorageServices.getInstance().loadData(key: TypeKeyStorage())=="User"?"sorry to cancel .":"sorry we can't preparing",
          loadToken: LoadToken(
              id:
              (await FirebaseFirestore.instance.collection(orderCollection).doc(idOrder).get()).data()![StorageServices.getInstance().loadData(key: TypeKeyStorage())=="User"?idRestaurant:idUser]
          ),
        );
      }
      for (int i = 0; i < mealsOrder.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection(detailOrderCollection)
            .doc(mealsOrder.docs[i].id)
            .delete();
      }
      await FirebaseFirestore.instance
          .collection(orderCollection)
          .doc(idOrder)
          .delete();

    } catch (e) {
      print(e);
    }
  }
}

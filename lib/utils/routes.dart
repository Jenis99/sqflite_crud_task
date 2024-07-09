import 'package:get/get.dart';
import 'package:sqlite_crud_operation_task/module/product_module/view/add_product_screen.dart';
import 'package:sqlite_crud_operation_task/module/product_module/view/all_product_screen.dart';
import 'package:sqlite_crud_operation_task/module/product_module/view/product_detail_screen.dart';

mixin Routes {
  static const defaultTransition = Transition.downToUp;
  static const String allProductScreen = '/allProductScreen';
  static const String addProductScreen = '/addProductScreen';
  static const String productDetailScreen = '/productDetailScreen';
  static List<GetPage<dynamic>> appPages = [
    GetPage<dynamic>(
      name: allProductScreen,
      page: () => AllProductScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: addProductScreen,
      page: () => AddProductScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: productDetailScreen,
      page: () => ProductDetailScreen(),
      transition: defaultTransition,
    ),
  ];
}

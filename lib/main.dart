import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud_operation_task/module/product_module/view/all_product_screen.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/d_b_helper.dart';

import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.allProductScreen,
      getPages: Routes.appPages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

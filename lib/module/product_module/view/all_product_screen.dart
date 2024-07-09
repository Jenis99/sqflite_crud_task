import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud_operation_task/module/product_module/controller/product_controller.dart';
import 'package:sqlite_crud_operation_task/module/product_module/model/product_model.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/product_service.dart';
import 'package:sqlite_crud_operation_task/module/product_module/view/product_detail_screen.dart';
import 'package:sqlite_crud_operation_task/utils/routes.dart';

class AllProductScreen extends StatelessWidget {
  AllProductScreen({super.key});

  final ProductController productController = Get.put(ProductController());

  final String tempImg =
      "https://media.istockphoto.com/id/1300459022/photo/natural-organic-spa-cosmetic-products-set-with-eucalyptus-leaves-top-view-herbal-skincare.jpg?s=612x612&w=0&k=20&c=_xkB2_OnFqzJKVdDCeNCPeMp4jwLTsSQy2VvRloiPgk=";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Product Screen"),
          actions: [const Icon(Icons.search).paddingOnly(right: 15)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.toNamed(Routes.addProductScreen);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<List<ProductModel>>(
          stream: ProductService.instance.productListObserver,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  // childAspectRatio: 0.76,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final ProductModel productModel = snapshot.data?[index] ?? ProductModel();
                  return commonProductBox(productModel);
                },
              );
            } else {
              return Center(
                child: Text("There is no product added"),
              );
            }
          },
        ));
  }

  Widget commonProductBox(ProductModel productModelData) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => ProductDetailScreen(
              productModel: productModelData,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(productModelData.productImg ?? ""),
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                )),
            Text(
              productModelData.productName ?? "",
              style: TextStyle(overflow: TextOverflow.ellipsis),
              maxLines: 1,
            ).paddingSymmetric(horizontal: 20),
          ],
        ),
      ),
    );
  }
}

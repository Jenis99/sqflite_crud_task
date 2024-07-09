import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_crud_operation_task/module/product_module/model/product_model.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/d_b_helper.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();

  factory ProductService() => _instance;

  static ProductService get instance => _instance;

  ProductService._internal();

  final productListSink = PublishSubject<List<ProductModel>>();

  Stream<List<ProductModel>> get productListObserver => productListSink.stream;
  static DatabaseHelper databaseHelper = DatabaseHelper.instance;

  // A method that retrieves all the notes from the Notes table.
  Future<List<ProductModel>> getAllProductData() async {
    // Get a reference to the database.
    final db = await databaseHelper.database;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    List<Map<String, dynamic>> list = await db.query(DatabaseHelper.productTable, orderBy: '${DatabaseHelper.productId} ASC');
    List<ProductModel> productModelList = list.map((json) {
      print("getAllProductData called $json");
      return ProductModel.fromJson(json);
    }).toList();
    productListSink.add(productModelList);
    return productModelList;
  }

  // Serach note by Id
  Future<ProductModel> read(int id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.productTable,
      where: '${DatabaseHelper.productId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ProductModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final db = await databaseHelper.database;

    await db.insert(DatabaseHelper.productTable, product.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    getAllProductData();
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await databaseHelper.database;

    var res =
        await db.update(DatabaseHelper.productTable, product.toJson(), where: '${DatabaseHelper.productId} = ?', whereArgs: [product.productId]);
    getAllProductData();
    return res;
  }

  Future<void> deleteProduct(int id) async {
    final db = await databaseHelper.database;
    try {
      await db.deleteProduct(DatabaseHelper.productTable, where: "${DatabaseHelper.productId} = ?", whereArgs: [id]);
      getAllProductData();
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

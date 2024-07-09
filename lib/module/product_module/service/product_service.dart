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
    // Convert the List<Map<String, dynamic> into a List<Note>.
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

  // Define a function that inserts notes into the database
  Future<void> addProduct(ProductModel product) async {
    // Get a reference to the database.
    final db = await databaseHelper.database;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(DatabaseHelper.productTable, product.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    getAllProductData();
  }

  // Define a function to update a note
  Future<int> updateProduct(ProductModel product) async {
    print("updateProduct call ${product.toJson()}");
    print("updateProduct call ${product?.productId}");
    // Get a reference to the database.
    final db = await databaseHelper.database;

    // Update the given Note.
    var res = await db.update(DatabaseHelper.productTable, product.toJson(),
        // Ensure that the Note has a matching id.
        where: '${DatabaseHelper.productId} = ?',
        // Pass the Note's id as a whereArg to prevent SQL injection.
        whereArgs: [product.productId]);
    getAllProductData();
    return res;
  }

  // Define a function to delete a note
  Future<void> delete(int id) async {
    // Get a reference to the database.
    final db = await databaseHelper.database;
    try {
      // Remove the Note from the database.
      await db.delete(DatabaseHelper.productTable,
          // Use a `where` clause to delete a specific Note.
          where: "${DatabaseHelper.productId} = ?",
          // Pass the Dog's id as a whereArg to prevent SQL injection.
          whereArgs: [id]);
      getAllProductData();
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future close() async {
    final db = await databaseHelper.database;
    db.close();
  }
}

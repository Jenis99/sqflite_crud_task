import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/product_service.dart';

class ProductController extends GetxController {
  TextEditingController productNameController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final Rx<XFile> selectedFile = XFile("").obs;

  @override
  void onInit() {
    ProductService.instance.getAllProductData();
    super.onInit();
  }

  Future pickImage(bool isCamera) async {
    selectedFile.value = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery) ?? XFile("");
    // final XFile? photo = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    print("pickImageFromCamera called --- ${selectedFile.value.path}");
  }

  clearCacheData() {
    selectedFile.value = XFile("");
    productNameController.clear();
  }
}

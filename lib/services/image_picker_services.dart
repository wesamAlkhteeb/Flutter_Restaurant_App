import 'package:image_picker/image_picker.dart';

class ImagePickerServices {
  static ImagePickerServices? imagePickerServices;

  ImagePicker? imagePicker;

  ImagePickerServices._(){
    imagePicker = ImagePicker();
  }

  static ImagePickerServices getInstance() {
    return (
        imagePickerServices = imagePickerServices ?? ImagePickerServices._());
  }

  Future<String> getImageGallery() async {
    XFile? file = await imagePicker!.pickImage(
        source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
    if (file == null) {
      return "";
    }
    return file.path;
  }


  Future<String> getImageCamera() async {
    XFile? file = await imagePicker!.pickImage(
      source: ImageSource.camera, maxHeight: 300, maxWidth: 300,);
    if (file == null) {
      return "";
    }
    return file.path;
    ;
  }

}
import 'package:image_picker/image_picker.dart';
import 'package:teslo_shop/feature/shared/domain/services/image_service.dart';

class ImageServiceImpl extends ImageService {
  final ImagePicker picker = ImagePicker();
  @override
  Future<String?> selectPhoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return image.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;

    return photo.path;
  }
}

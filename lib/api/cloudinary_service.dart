import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // Khởi tạo CloudinaryPublic với thông tin của bạn.
  // Lưu ý: Bạn cần tạo một "upload preset" trong tài khoản Cloudinary của mình.
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    "your_cloud_name",
    "your_upload_preset",
    cache: false,
  );

  /// Hàm upload ảnh.
  /// [imagePath] là đường dẫn file ảnh trên thiết bị.
  /// Nếu upload thành công, trả về URL của ảnh.
  Future<String> uploadImage(String imagePath) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image, // Sử dụng hằng số với chữ in hoa
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      rethrow;
    }
  }
}

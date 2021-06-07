import 'package:photopuzzle/generated/json/base/json_convert_content.dart';
import 'package:photopuzzle/model/photo_entity.dart';
import 'package:photopuzzle/model/search_photo_entity.dart';
import 'dio/dio_manager.dart';

class PhotoResponsibility {
  static final PhotoResponsibility _instance = PhotoResponsibility._internal();

  factory PhotoResponsibility() => _instance;

  PhotoResponsibility._internal();

  Future<List<PhotoEntity>> fetchPhotos(
      {required int page, int? per_page, String? order_by}) async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'per_page': per_page ?? 10,
      'order_by': order_by ?? 'position'
    };

    var response = await DioManager().get('/photos', params: params);
    List<PhotoEntity> list = JsonConvert.fromJsonAsT(response);
    return list;
  }

  Future<List<PhotoEntity>> searchPhotos(
      {required int page,
      required String query,
      int? per_page,
      String? order_by}) async {
    if (query == '') {
      Map<String, dynamic> params = <String, dynamic>{
        'page': page,
        'per_page': per_page ?? 10,
        'order_by': order_by ?? 'position'
      };

      var response = await DioManager().get('/photos', params: params);
      List<PhotoEntity> list = JsonConvert.fromJsonAsT(response);
      return list;
    } else {
      Map<String, dynamic> params = <String, dynamic>{
        'page': page,
        'query': query,
        'per_page': per_page ?? 10,
        'order_by': order_by ?? 'position'
      };

      var response = await DioManager().get('/search/photos', params: params);
      SearchPhotoEntity  searchPhotoEntity = JsonConvert.fromJsonAsT(response);

      return searchPhotoEntity.results;
    }
  }
}
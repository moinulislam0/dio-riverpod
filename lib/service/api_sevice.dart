import 'package:dio/dio.dart';
import 'package:my_dio_app/model/post_models.dart';

class Apiservice {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-type': 'application/json'},
    ),
  );
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      final List<dynamic> data = response.data;

      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await _dio.post("/posts", data: post.toJson());
      return PostModel.fromJson(response.data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PostModel> updatePost(int id, PostModel post) async {
    try {
      final response = await _dio.put("/posts/$id", data: post.toJson());
      return PostModel.fromJson(response.data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> deletePost(int id) async {
    try {
      await _dio.delete("/posts/$id");
      return true;
    } catch (e) {
      throw e.toString();
    }
  }
}

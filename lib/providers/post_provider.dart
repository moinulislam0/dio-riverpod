import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_dio_app/model/post_models.dart';
import 'package:my_dio_app/service/api_sevice.dart';

// Service Provider
final apiServiceProvider = Provider<Apiservice>((ref) => Apiservice());

// State Class
class PostState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;

  PostState({this.posts = const [], this.isLoading = false, this.error});

  PostState copyWith({List<PostModel>? posts, bool? isLoading, String? error}) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier Class
class PostNotifier extends StateNotifier<PostState> {
  final Apiservice _apiservice;

  PostNotifier(this._apiservice) : super(PostState()) {
    getPosts();
  }

  Future<void> getPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _apiservice.getPosts();
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createPost(String title, String body) async {
    state = state.copyWith(isLoading: true);
    try {
      final newPost = PostModel(userId: 1, title: title, body: body);
      final createdPost = await _apiservice.createPost(newPost);

      state = state.copyWith(
        posts: [createdPost, ...state.posts],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deletePost(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _apiservice.deletePost(id);
      final updatedList = state.posts.where((p) => p.id != id).toList();
      state = state.copyWith(posts: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updatedPost(int id, String title, String body) async {
    state = state.copyWith(isLoading: true);
    try {
      final postToUpdate = PostModel(
        userId: 1,
        id: id,
        title: title,
        body: body,
      );

      PostModel finalUpdatedPost;

      if (id > 100) {
        await Future.delayed(const Duration(milliseconds: 500));
        finalUpdatedPost = postToUpdate;
      } else {
        finalUpdatedPost = await _apiservice.updatePost(id, postToUpdate);
      }

      final updatedList = state.posts.map((post) {
        return post.id == id ? finalUpdatedPost : post;
      }).toList();

      state = state.copyWith(posts: updatedList, isLoading: false);
    } catch (e) {
      print("Update Error: $e");
      state = state.copyWith(isLoading: false, error: "Update Failed: $e");
    }
  }
}

// Provider
final postNotifierProvider = StateNotifierProvider<PostNotifier, PostState>((
  ref,
) {
  return PostNotifier(ref.read(apiServiceProvider));
});

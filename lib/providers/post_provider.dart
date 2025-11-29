import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_dio_app/model/post_models.dart';
import 'package:my_dio_app/service/api_sevice.dart';

final apiServiceProvider = Provider<Apiservice>((ref) => Apiservice());

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

class PostNotifier extends StateNotifier<PostState> {
  final Apiservice _apiservice;
  PostNotifier(this._apiservice) : super(PostState()) {
    getPosts();
  }

  Future<void> getPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _apiservice.getPosts();
      state = state.copyWith(posts: posts, isLoading: false,);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createPost(String title, String body) async {
    state = state.copyWith(isLoading: true);
    try {
      final newPost = PostModel(userId: 1, title: title, body: body);
      final createPost = await _apiservice.createPost(newPost);
      state = state.copyWith(
        posts: [...state.posts, createPost],
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

  Future<void> updatedPost(int id, String title, String body) async {}
}

final postNotifierProvider = StateNotifierProvider<PostNotifier, PostState>((
  ref,
) {
  return PostNotifier(ref.read(apiServiceProvider));
});

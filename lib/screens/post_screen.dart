import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dio_app/providers/post_provider.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riverpod CRUD"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(postNotifierProvider.notifier).getPosts();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),

      body: Builder(
        builder: (context) {
          if (state.isLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.posts.isEmpty) {
            return Center(child: Text("error ${state.error}"));
          }
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return ListTile(
                title: Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(post.body),
                trailing: IconButton(
                  onPressed: () {
                    ref
                        .read(postNotifierProvider.notifier)
                        .deletePost(post.id!);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: "Body1"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  bodyController.text.isNotEmpty) {
                ref
                    .read(postNotifierProvider.notifier)
                    .createPost(titleController.text, bodyController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

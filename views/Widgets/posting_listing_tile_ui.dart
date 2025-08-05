import 'package:flutter/material.dart';
import 'package:service_app/model/posting_model.dart';

class PostingListingTileUi extends StatefulWidget {
  final PostingModel? posting;

  PostingListingTileUi({super.key, this.posting});

  @override
  State<PostingListingTileUi> createState() => _PostingListingTileUiState();
}

class _PostingListingTileUiState extends State<PostingListingTileUi> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();
    posting = widget.posting;

    // Debug prints
    print("Posting name: ${posting?.name}");
    print("Posting images: ${posting?.displayImages}");
  }

  @override
  Widget build(BuildContext context) {
    if (posting == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            posting!.name ?? 'No Name',
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: AspectRatio(
          aspectRatio: 3 / 2,
          child: (posting!.displayImages != null &&
                  posting!.displayImages!.isNotEmpty)
              ? Image(
                  image: posting!.displayImages!.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, color: Colors.red);
                  },
                )
              : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
        ),
      ),
    );
  }
}

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:service_app/model/posting_model.dart';

class PostingGridTileUi extends StatefulWidget {
  final PostingModel? posting;
  
  const PostingGridTileUi({super.key, this.posting, ImageProvider<Object>? image});

  @override
  State<PostingGridTileUi> createState() => _PostingGridTileUiState();
}

class _PostingGridTileUiState extends State<PostingGridTileUi> {
  late PostingModel? posting;
  bool _isLoading = true;

  Future<void> _loadImage() async {
    if (posting == null) return;
    
    try {
      await posting!.getFirstImageFromStorage();
    } catch (e) {
      debugPrint("Error loading image: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadImage());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3/2,
          child: _buildImageContainer(),
        ),
        _buildTextInfo("${posting?.type ?? ''}- ${posting?.city ?? ''},${posting?.country ?? ''}"),
        _buildTextInfo(posting?.name ?? ''),
        _buildTextInfo("\$${posting?.price?.toStringAsFixed(2) ?? '0.00'}/ night"),
        _buildRatingBar(),
      ],
    );
  }

  Widget _buildImageContainer() {
    if (_isLoading) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (posting?.displayImages?.isEmpty ?? true) {
      return Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.broken_image)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: posting!.displayImages!.first,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextInfo(String text) {
    return Text(
      text,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRatingBar() {
    return Row(
      children: [
        RatingBar.readOnly(
          size: 28,
          maxRating: 5,
          initialRating: posting?.getCurrentRating() ?? 0,
          filledIcon: Icons.star,
          emptyIcon: Icons.star_border,
          filledColor: Colors.yellow,
        )
      ],
    );
  }
}
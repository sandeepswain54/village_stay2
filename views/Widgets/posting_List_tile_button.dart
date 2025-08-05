import 'package:flutter/material.dart';

class PostingTileButton extends StatelessWidget {
  const PostingTileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height/11.8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add),
        Text("Post Your Service",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        )),
      ],
    ),
    
    );
  }
}
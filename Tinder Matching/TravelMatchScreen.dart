import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class TravelMatchScreen extends StatefulWidget {
  @override
  _TravelMatchScreenState createState() => _TravelMatchScreenState();
}

class _TravelMatchScreenState extends State<TravelMatchScreen> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];

  final List<Map<String, String>> profiles = [
    {
      "name": "Elias Moreau",
      "age": "34",
      "location": "France",
      "desc": "Architect with a love for minimalist design and red wine.",
      "image":
          "https://images.unsplash.com/photo-1599566150163-29194dcaad36"
    },
    {
      "name": "Sophie Nguyen",
      "age": "28",
      "location": "Vietnam",
      "desc": "Loves nature retreats, yoga and cultural travel.",
      "image":
          "https://images.unsplash.com/photo-1552058544-f2b08422138a"
    },
  ];

  @override
  void initState() {
    for (var profile in profiles) {
      _swipeItems.add(SwipeItem(
        content: profile,
        likeAction: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("You liked ${profile["name"]}")));
        },
        nopeAction: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("You skipped ${profile["name"]}")));
        },
        superlikeAction: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Super liked ${profile["name"]}")));
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Travel Matches")),
      body: Column(
        children: [
          Expanded(
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (context, index) {
                final p = _swipeItems[index].content as Map<String, String>;
                return Card(
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          p["image"]!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${p["name"]}, ${p["age"]}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              Text(p["desc"]!,
                                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No more matches.")));
              },
              itemChanged: (item, index) {},
              upSwipeAllowed: true,
              fillSpace: true,
            ),
          ),
        ],
      ),
    );
  }
}

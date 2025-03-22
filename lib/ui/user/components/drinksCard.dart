import 'package:flutter/material.dart';

class DrinksCard extends StatefulWidget {
  final String drinkName;
  final String imageUrl;
  final String? tool;
  final String? origin;
  final String? caffeine;
  final String? description;
  final String? ingredient;

  const DrinksCard({
    super.key,
    required this.drinkName,
    required this.imageUrl,
    this.tool,
    this.origin,
    this.caffeine,
    this.ingredient,
    this.description,
  });

  @override
  State<DrinksCard> createState() => _DrinksCardState();
}

class _DrinksCardState extends State<DrinksCard> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 17.0, bottom: 20.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          width: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 180,
                      height: 150,
                      child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.drinkName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.description ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

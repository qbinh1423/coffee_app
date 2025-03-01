import 'package:flutter/material.dart';

class BeansCard extends StatefulWidget {
  final String beanName;
  final String imageUrl;
  final String? altitude;
  final String? climate;
  final String? caffeine;
  final String? description;

  const BeansCard({
    super.key,
    required this.beanName,
    required this.imageUrl,
    this.altitude,
    this.climate,
    this.caffeine,
    this.description,
  });

  @override
  State<BeansCard> createState() => _BeansCardState();
}

class _BeansCardState extends State<BeansCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 17.0, bottom: 25.0),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 180,
                  height: 150,
                  child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.beanName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.info),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

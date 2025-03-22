import 'package:coffee_app/ui/admin/pages/drink/editDrink.dart';
import 'package:flutter/material.dart';

class DrinkCardAdmin extends StatefulWidget {
  final String drinkName;
  final String imageUrl;
  final String? tool;
  final String? origin;
  final String? caffeine;
  final String? description;
  final String? ingredient;

  const DrinkCardAdmin({
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
  State<DrinkCardAdmin> createState() => _DrinkCardAdminState();
}

class _DrinkCardAdminState extends State<DrinkCardAdmin> {
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
                      widget.drinkName,
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDrink(
                              drinkName: widget.drinkName,
                              imageUrl: widget.imageUrl,
                              origin: widget.origin ?? '',
                              tool: widget.tool ?? '',
                              ingredient: widget.ingredient ?? '',
                              caffeine: widget.caffeine ?? '',
                              description: widget.description ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: const Text(
                                "Are you sure you want to delete this drink?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
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

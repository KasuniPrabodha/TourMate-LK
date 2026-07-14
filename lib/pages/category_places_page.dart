import 'package:final_project/reuse/network_place_images.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/category_model.dart';
import 'package:final_project/data/home_data.dart';
import 'package:final_project/pages/place_detail_page.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';

class CategoryPlacesPage extends StatelessWidget {
  final CategoryModel category;
  const CategoryPlacesPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final places = destinations.where((d) => d.category == category.title).toList();

    return Scaffold(
      // CHANGED: added persistent tab bar (Home tab, since categories are reached from Home)
      bottomNavigationBar: const CustomTabBar(currentIndex: 0),
      appBar: AppBar(
        title: Text(
          category.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: places.isEmpty
            ? const Center(child: Text("No places added for this category yet."))
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceDetailPage(place: place)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                            child: NetworkPlaceImage(fileName: place.coverImage, width: 90, height: 90, fit: BoxFit.cover),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(place.place, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.yellow, size: 15),
                                      const SizedBox(width: 4),
                                      Text(place.rate.toString(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(place.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.chevron_right, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
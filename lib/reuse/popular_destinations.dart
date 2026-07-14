import 'package:final_project/reuse/network_place_images.dart';
import 'package:flutter/material.dart';

class PopularDestinations extends StatelessWidget {
  final String coverImage;
  final String place;
  final double rate;
  final String description;
  const PopularDestinations({super.key, required this.coverImage, required this.place, required this.rate, required this.description});

  @override
  Widget build(BuildContext context) {
    // CHANGED: width removed (was fixed 120) — now fills whatever width
    // its parent Expanded gives it. Height stays fixed since that doesn't
    // cause horizontal overflow.
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: NetworkPlaceImage(fileName: coverImage, width: double.infinity, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              place,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.star, color: Colors.yellow, size: 15),
                ),
                Text(rate.toString(), style: const TextStyle(color: Color.fromARGB(255, 121, 121, 121), fontSize: 12, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color.fromARGB(255, 121, 121, 121), fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

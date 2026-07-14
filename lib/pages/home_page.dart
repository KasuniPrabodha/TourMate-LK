import 'package:flutter/material.dart';
import 'package:final_project/reuse/main_square.dart';
import 'package:final_project/reuse/popular_destinations.dart';
import 'package:final_project/reuse/custom_tab_bar.dart';
import 'package:final_project/data/home_data.dart';
import 'package:final_project/pages/category_places_page.dart';
import 'package:final_project/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<List<T>> _chunk<T>(List<T> list, int size) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += size) {
      chunks.add(
        list.sublist(i, i + size > list.length ? list.length : i + size),
      );
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    final destinationRows = _chunk(destinations, 3);
    final categoryRows = _chunk(categories, 4);

    return Scaffold(
      bottomNavigationBar: const CustomTabBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // CHANGED: greeting now shows the signed-in user's first
                // name, fetched from Firestore (saved during signup),
                // instead of a hardcoded name.
                Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder<String>(
                    future: AuthService().getCurrentUserFirstName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data;
                      final greeting = name != null
                          ? "Hello $name 👋"
                          : "Hello 👋";
                      return Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        color: Color(0xFF134a26),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // CHANGED: category squares now use Expanded + fixed gaps
                // instead of fixed widths + spaceBetween, so 4 squares
                // always fit any screen width without overflowing.
                for (var row in categoryRows) ...[
                  Row(
                    children: [
                      for (int i = 0; i < row.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoryPlacesPage(category: row[i]),
                                ),
                              );
                            },
                            child: MainSquare(
                              squareColor: row[i].squareColor,
                              iconColor: row[i].iconColor,
                              title: row[i].title,
                              myIcon: row[i].myIcon,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10),
                ],

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Destinations",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        color: Color(0xFF134a26),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // CHANGED: same Expanded + gap pattern for destination cards
                for (var row in destinationRows) ...[
                  Row(
                    children: [
                      for (int i = 0; i < row.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: PopularDestinations(
                            coverImage: row[i].coverImage,
                            place: row[i].place,
                            rate: row[i].rate,
                            description: row[i].description,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

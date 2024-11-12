import 'package:flutter/material.dart';
import 'package:flutter_application_task1/pages/edit_profile.dart'; // Corrected import for edit_profile
import '../model/LoginRequest_model.dart'; // This seems unnecessary as it's not used, can be removed if not needed

// Circle class to hold image URL and title
class Circle {
  final String imageUrl;
  final String title;

  Circle({required this.imageUrl, required this.title});
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Circle> circles = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchCirclesData() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<Circle> fetchedData = [
      Circle(
          imageUrl: 'assets/2.png',
          title: "Lita shared a new plan in Experiences"),
      Circle(imageUrl: 'assets/3.png', title: 'Harry shared images in canvas'),
      Circle(
          imageUrl: 'assets/4.png',
          title: 'Zyan added Night Out Plan in to-do'),
    ];

    setState(() {
      circles.addAll(fetchedData);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCirclesData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchCirclesData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => edit_profile(
          name: "Ali",
          email: "ali12@gmail.com",
        ),
      ),

      //issue not fetch the login name
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Welcome to the Dashboard!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: _navigateToEditProfile,
                  child: Image.asset(
                    'assets/1.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: circles.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: circles.length,
                    itemBuilder: (context, index) {
                      final circle = circles[index];

                      return Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white12
                              .withOpacity(0.8), // Off-white background color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical:
                                8.0), // Add some spacing between containers
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Dynamic image
                              Image.asset(
                                circle.imageUrl, // Get image from Circle object
                                width: 100,
                                height: 100,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    circle
                                        .title, // Get title from Circle object
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

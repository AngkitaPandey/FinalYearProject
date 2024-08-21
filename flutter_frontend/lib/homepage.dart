import 'package:flutter/material.dart';
import 'createhome1.dart';

void main() {
  runApp(const HolidayHomeSwapApp());
}

class HolidayHomeSwapApp extends StatelessWidget {
  const HolidayHomeSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holiday Home Swap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      // routes: {
      //   '/createhome1': (context) => const CreateHome1(),
      //   '/createhome2': (context) => const CreateHome2(),
      // },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Hides the AppBar
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a home',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Create Your Home Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create your home',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Create your home to get started on HomeSwap',
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Createhome page when the button is pressed
                        // Navigator.pushNamed(context, '/createhome1');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateHome1()), // Navigate to the Createhome page when the button is pressed
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Homes You May Like
              // const Text(
              //   'Homes you may like',
              //   style: TextStyle(
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.only(
                    top: 2.0, bottom: 6.0), // Add a top margin
                child: const Text(
                  'Homes you may like',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height:
                    300.0, // Adjusted height to accommodate text below image
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      width: 200.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150.0, // Adjusted height for the image
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/apartment_france.jpg'), // Replace with your image
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Stack(
                              children: [
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8.0,
                                  left: 8.0,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/Greece.jpg'), // Replace with your image
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            "Melissa's home",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const Text(
                            "Magny-Le-Hongre, France",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                          const Text(
                            "House | 4 sleeps",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                          const Text(
                            "90 GP/night",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const Text(
                            "★ 5.0",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              //Members looking for an exchange near you
              Container(
                margin: const EdgeInsets.only(
                    top: 2.0, bottom: 6.0), // Add a top margin
                child: const Text(
                  'Members looking for an exchange near you',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height:
                    300.0, // Adjusted height to accommodate text below image
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      width: 200.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150.0, // Adjusted height for the image
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/france_home.jpg'), // Replace with your image
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Stack(
                              children: [
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8.0,
                                  left: 8.0,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/Greece.jpg'), // Replace with your image
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            "Melissa's home",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const Text(
                            "Magny-Le-Hongre, France",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                          const Text(
                            "House | 4 sleeps",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                          const Text(
                            "90 GP/night",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const Text(
                            "★ 5.0",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Exchanges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        // Adding this theme customization
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

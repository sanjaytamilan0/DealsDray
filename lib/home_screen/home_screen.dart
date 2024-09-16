import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskproject/home_screen/reverpod/home_screen_data_notifer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _homeData();
  }

  Future<void> _homeData() async {
    await Future.delayed(const Duration(seconds: 5));
    ref.read(homeProvider.notifier).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final homeNotifier = ref.watch(homeProvider);
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarousel(ref),
            _buildKYCReminder(),
            _buildCategoryIcons(ref),
            _buildExclusiveOffers(ref),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        backgroundColor: Colors.red, // Customize the button color if needed
        tooltip: 'Chat',
        child: const Text('Chat'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const Icon(Icons.menu),
      title: SizedBox(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search here',
            suffixIcon: const Icon(Icons.search),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding if needed
              child: Image.asset(
                'assets/icon.png',
                width: 24, // Adjust width if needed
                height: 24, // Adjust height if needed
                fit: BoxFit.cover,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        )
        ,
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
      ],
      backgroundColor: Colors.white,
      elevation: 20,
    );
  }

  Widget _buildCarousel(WidgetRef ref) {
    final homeNotifier = ref.watch(homeProvider);

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9,
      ),
      items: homeNotifier.banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(banner.banner),
                  fit: BoxFit.fill,
                  onError: (exception, stackTrace) {
                    // Handle image loading error
                  },
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildKYCReminder() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'KYC Pending',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
              'You need to provide the required documents for your account activation.'),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Click Here'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcons(WidgetRef ref) {
    final category = ref.watch(homeProvider);

    return SizedBox(
      height: 100,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0, // Aspect ratio of each item (width / height)
        ),
        itemCount: category.categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryItem(ref, index);
        },
      ),
    );
  }

  Widget _buildCategoryItem(WidgetRef ref, int index) {
    final category = ref.watch(homeProvider);
    final categorylist = category.categories[index];
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[100],
          backgroundImage: NetworkImage(categorylist.icon),
          radius: 25,
        ),
        const SizedBox(height: 5),
        Text(categorylist.label),
      ],
    );
  }

  Widget _buildExclusiveOffers(WidgetRef ref) {
    final homeNotifier = ref.watch(homeProvider);

    return Container(
      color: Colors.greenAccent,
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EXCLUSIVE FOR YOU', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homeNotifier.products.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildProductCard(ref, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(WidgetRef ref, int index) {
    final homeNotifier = ref.watch(homeProvider);
    final product = homeNotifier.products[index];
    return Card(
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            color: Colors.grey[300],
            child: Image.network(product.icon, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.label),
                Text(product.offer, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.diamond), label: 'Premium'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.red,
    );
  }
}

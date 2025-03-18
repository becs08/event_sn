import 'package:flutter/material.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/event_card.dart';
import '../../../../data/models/event.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Lutte',
    'Concerts',
    'Football',
    'Basket',
    'Culture'
  ];

  // Données statiques pour les événements
  final List<Event> _events = [
    Event(
      id: '1',
      title: 'Lutte: Combat ABC vs XYZ',
      description: 'Combat ABC contre XYZ à l\'Arène National',
      date: DateTime(2025, 3, 14, 16, 0),
      location: 'Arène National du Sénégal',
      imageUrl: 'assets/images/lutte1.jpg',
      price: 5000,
      rating: 4, category: '', organizerId: '',
    ),
    Event(
      id: '2',
      title: 'Concert: Youssou Ndour',
      description: 'Concert live de Youssou Ndour',
      date: DateTime(2025, 3, 20, 20, 0),
      location: 'Grand Théâtre de Dakar',
      imageUrl: 'assets/images/concert1.jpg',
      price: 10000,
      rating: 3, category: '', organizerId: '',
    ),
    Event(
      id: '3',
      title: 'Football: Sénégal vs Cameroun',
      description: 'Match de qualification pour la CAN',
      date: DateTime(2025, 4, 5, 18, 0),
      location: 'Stade Léopold Sédar Senghor',
      imageUrl: 'assets/images/football1.jpg',
      price: 3000,
      rating: 5, category: '', organizerId: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EventSn',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: List.generate(
                  _categories.length,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategoryIndex == index,
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(
                        color: _selectedCategoryIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Event List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildEventListItem(
                      title: 'Event ${_categories[0]} ${index + 1}',
                      rating: event.rating,
                      imageUrl: event.imageUrl,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildEventListItem({
    required String title,
    required int rating,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/event_detail');
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 160,
                height: 160,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.purple,
                          size: 20,
                        );
                      }),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Fév', 'Mars', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month];
  }
}
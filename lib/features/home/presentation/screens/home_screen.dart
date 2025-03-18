import 'package:flutter/material.dart';
import '../../../../shared/widgets/event_card.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../data/models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Populaire',
    'Lutte',
    'Concert',
    'Football',
    'Basket',
    'Culture'
  ];

  // Données statiques pour les événements populaires
  final List<Event> _popularEvents = [
    Event(
      id: '1',
      title: 'Lutte: Combat ABC vs XYZ',
      description: 'Combat ABC contre XYZ à l\'Arène National',
      date: DateTime(2025, 3, 14, 16, 0),
      location: 'Arène National du Sénégal',
      imageUrl: 'assets/images/preview.png',
      price: 5000, category: '', organizerId: '',
    ),
    Event(
      id: '2',
      title: 'Concert: Youssou Ndour',
      description: 'Concert live de Youssou Ndour',
      date: DateTime(2025, 3, 20, 20, 0),
      location: 'Grand Théâtre de Dakar',
      imageUrl: 'assets/images/concert1.jpg',
      price: 10000, category: '', organizerId: '',
    ),
    Event(
      id: '3',
      title: 'Lutte: Combat ABC vs XYZ',
      description: 'Combat ABC contre XYZ à l\'Arène National',
      date: DateTime(2025, 3, 14, 16, 0),
      location: 'Arène National du Sénégal',
      imageUrl: 'assets/images/lutte1.jpg',
      price: 5000, category: '', organizerId: '',
    ),
    Event(
      id: '4',
      title: 'Concert: Youssou Ndour',
      description: 'Concert live de Youssou Ndour',
      date: DateTime(2025, 3, 20, 20, 0),
      location: 'Grand Théâtre de Dakar',
      imageUrl: 'assets/images/concert1.jpg',
      price: 10000, category: '', organizerId: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'EventSn',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "À L'AFFICHE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Featured Event Card (Single)
                    _buildFeaturedEventCard(_popularEvents.first),

                    const SizedBox(height: 8),

                    // Event Rating
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_border,
                          color: Colors.purple,
                          size: 20,
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Concert Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CONCERT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/view_all');
                          },
                          child: const Text('Voir tout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(),
                    const SizedBox(height: 8),

                    // Lutte Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'LUTTE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/view_all');
                          },
                          child: const Text('Voir tout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(),
                    const SizedBox(height: 8),

                    // Football Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FOOTBALL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/view_all');
                          },
                          child: const Text('Voir tout'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Horizontal scrolling event list
                    _buildHorizontalEventList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFeaturedEventCard(Event event) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/event_detail');
      },
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Icon(Icons.image, size: 60, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildHorizontalEventList() {
    return SizedBox(
      height: 200, // Augmenté de 180 à 200px pour accommoder le contenu
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _popularEvents.length,
        itemBuilder: (context, index) {
          final event = _popularEvents[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/event_detail');
            },
            child: Container(
              width: 230,
              margin: const EdgeInsets.only(right: 16),
              child: EventCard(
                title: event.title,
                date: '${event.date.day} ${_getMonthName(event.date.month)}, ${event.date.year}',
                location: event.location,
                imageUrl: event.imageUrl,
              ),
            ),
          );
        },
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
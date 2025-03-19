import 'package:flutter/material.dart';
import '../../../../shared/widgets/event_card.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../data/models/event.dart';
import '../../../../data/services/event_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/featured_event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventService _eventService = EventService();
  int _selectedCategoryIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;

  // Données pour les événements
  List<Event> _featuredEvents = [];
  List<Event> _luttes = [];
  List<Event> _concerts = [];
  List<Event> _footballs = [];
  List<Event> _culturels = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Charger les événements à la une
      final featuredEvents = await _eventService.getFeaturedEvents();

      // Charger les événements par catégorie
      final luttes = await _eventService.getEventsByCategory('Lutte');
      final concerts = await _eventService.getEventsByCategory('Concert');
      final footballs = await _eventService.getEventsByCategory('Football');
      final culturels = await _eventService.getEventsByCategory('Culture');

      // Mettre à jour l'état
      if (mounted) {
        setState(() {
          _featuredEvents = featuredEvents;
          _luttes = luttes;
          _concerts = concerts;
          _footballs = footballs;
          _culturels = culturels;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur lors du chargement des événements: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Ajouter des événements de démonstration si nécessaire
  Future<void> _addSampleEvents() async {
    try {
      await _eventService.addSampleEvents();
      // Recharger les événements après l'ajout
      await _loadEvents();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événements de démonstration ajoutés avec succès!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout des événements: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? _buildErrorView()
            : _buildEventList(),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSampleEvents,
        child: const Icon(Icons.add),
        tooltip: 'Ajouter des événements de démonstration',
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Une erreur est survenue',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadEvents,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return Column(
      children: [
        _buildAppBar(),
        _buildCategorySelector(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadEvents,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Événement à la une
                  if (_featuredEvents.isNotEmpty) ...[
                    _buildSectionHeader("À L'AFFICHE", null),
                    const SizedBox(height: 16),
                    FeaturedEventCard(event: _featuredEvents.first),
                    const SizedBox(height: 24),
                  ],

                  // Section Lutte
                  if (_luttes.isNotEmpty) ...[
                    _buildSectionHeader('LUTTE', () {
                      Navigator.pushNamed(context, '/view_all', arguments: 'Lutte');
                    }),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(_luttes),
                    const SizedBox(height: 24),
                  ],

                  // Section Concert
                  if (_concerts.isNotEmpty) ...[
                    _buildSectionHeader('CONCERT', () {
                      Navigator.pushNamed(context, '/view_all', arguments: 'Concert');
                    }),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(_concerts),
                    const SizedBox(height: 24),
                  ],

                  // Section Football
                  if (_footballs.isNotEmpty) ...[
                    _buildSectionHeader('FOOTBALL', () {
                      Navigator.pushNamed(context, '/view_all', arguments: 'Football');
                    }),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(_footballs),
                    const SizedBox(height: 24),
                  ],

                  // Section Culture
                  if (_culturels.isNotEmpty) ...[
                    _buildSectionHeader('CULTURE', () {
                      Navigator.pushNamed(context, '/view_all', arguments: 'Culture');
                    }),
                    const SizedBox(height: 8),
                    _buildHorizontalEventList(_culturels),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
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
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['Populaire', 'Lutte', 'Concert', 'Football', 'Basket', 'Culture'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: List.generate(
          categories.length,
              (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: _selectedCategoryIndex == index,
              selectedColor: Colors.deepPurple,
              labelStyle: TextStyle(
                color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
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
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onSeeAllPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: const Text('Voir tout'),
          ),
      ],
    );
  }

  Widget _buildHorizontalEventList(List<Event> events) {
    return SizedBox(
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            child: EventCard(
              event: event,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/event_detail',
                  arguments: event.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
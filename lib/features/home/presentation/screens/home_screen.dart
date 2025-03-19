import 'package:flutter/material.dart';
import '../../../../shared/widgets/event_card.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../data/models/event.dart';
import '../../../../data/services/event_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/featured_event_card.dart';
import '../../../../shared/widgets/loading_indicator.dart';

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
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];
  List<Event> _featuredEvents = [];

  // Catégories prédéfinies
  final List<String> categories = ['Populaire', 'Lutte', 'Concert', 'Football', 'Basket', 'Culture'];

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
      // Charger tous les événements
      final allEvents = await _eventService.getAllEvents();

      // Charger les événements à la une
      final featuredEvents = await _eventService.getFeaturedEvents();

      // Mettre à jour l'état
      if (mounted) {
        setState(() {
          _allEvents = allEvents;
          _featuredEvents = featuredEvents;

          // Filtrer par la catégorie actuellement sélectionnée
          _filterEventsBySelectedCategory();

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

  // Méthode pour filtrer les événements en fonction de la catégorie sélectionnée
  void _filterEventsBySelectedCategory() {
    if (_selectedCategoryIndex == 0) {
      // "Populaire" - afficher tous les événements, mais triés par rating
      _filteredEvents = List.from(_allEvents);
      _filteredEvents.sort((a, b) => b.rating.compareTo(a.rating));

      // Limiter à 10 événements pour éviter un affichage trop long
      if (_filteredEvents.length > 10) {
        _filteredEvents = _filteredEvents.sublist(0, 10);
      }
    } else {
      // Autres catégories - filtrer par le nom de la catégorie
      final selectedCategory = categories[_selectedCategoryIndex];
      _filteredEvents = _allEvents
          .where((event) => event.category == selectedCategory)
          .toList();
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
            ? const LoadingIndicator(message: 'Chargement des événements...')
            : _errorMessage != null
            ? _buildErrorView()
            : _buildContent(),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSampleEvents,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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

  Widget _buildContent() {
    return Column(
      children: [
        _buildAppBar(),
        _buildCategorySelector(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadEvents,
            child: _selectedCategoryIndex == 0
                ? _buildHomeContent()
                : _buildCategoryContent(),
          ),
        ),
      ],
    );
  }

  // Contenu pour l'écran d'accueil (catégorie "Populaire")
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Événement à la une (si disponible)
          if (_featuredEvents.isNotEmpty) ...[
            _buildSectionHeader("À L'AFFICHE", null),
            const SizedBox(height: 16),
            FeaturedEventCard(event: _featuredEvents.first),
            const SizedBox(height: 24),
          ],

          // Recommandations / Populaires
          _buildSectionHeader('RECOMMANDÉS POUR VOUS', () {
            Navigator.pushNamed(context, '/view_all');
          }),
          const SizedBox(height: 8),
          _buildHorizontalEventList(_filteredEvents),
          const SizedBox(height: 24),

          // Sections par catégorie
          ...categories.skip(1).map((category) {
            final categoryEvents = _allEvents
                .where((event) => event.category == category)
                .toList();

            if (categoryEvents.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(category.toUpperCase(), () {
                  Navigator.pushNamed(context, '/view_all', arguments: category);
                }),
                const SizedBox(height: 8),
                _buildHorizontalEventList(categoryEvents),
                const SizedBox(height: 24),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Contenu pour une catégorie spécifique
  Widget _buildCategoryContent() {
    if (_filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Aucun événement trouvé dans la catégorie "${categories[_selectedCategoryIndex]}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la catégorie
          Text(
            categories[_selectedCategoryIndex].toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Grid de tous les événements de cette catégorie
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredEvents.length,
            itemBuilder: (context, index) {
              return EventCard(
                event: _filteredEvents[index],
                isCompact: true, // Utilisation du mode compact pour la grille
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/event_detail',
                    arguments: _filteredEvents[index].id,
                  );
                },
              );
            },
          ),
        ],
      ),
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
              color: Colors.deepPurple,
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
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
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
                      _filterEventsBySelectedCategory(); // Filtrer les événements après changement de catégorie
                    });
                  }
                },
              ),
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
      child: events.isEmpty
          ? const Center(
        child: Text('Aucun événement disponible dans cette catégorie'),
      )
          : ListView.builder(
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
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final int rating;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    this.rating = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Suppression de la hauteur fixe qui causait le débordement
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Pour que la colonne prenne le minimum d'espace
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 120, // Hauteur réduite de 130px à 120px
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6), // Padding réduit de 8px à 6px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13, // Taille de police réduite de 14px à 13px
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (rating > 0) ...[
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 12, // Taille des icônes réduite de 14px à 12px
                          );
                        }),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                // Mettre chaque information sur une ligne séparée au lieu de les mettre côte à côte
                _buildInfoRow(Icons.calendar_today, date),
                const SizedBox(height: 2), // Petit espacement entre les deux infos
                _buildInfoRow(Icons.location_on, location),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 10, color: Colors.grey),
        const SizedBox(width: 2),
        Expanded( // Ajout du widget Expanded pour s'assurer que le texte s'adapte à l'espace disponible
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
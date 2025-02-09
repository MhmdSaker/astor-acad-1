import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'grammar_practice_screen.dart';
import 'vocabulary_practice_screen.dart';
import 'listening_practice_screen.dart';
import '../services/progress_service.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressService>(
      builder: (context, progressService, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFF5A1A),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Practice',
                          style: TextStyle(
                            fontFamily: 'CraftworkGrotesk',
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPointsSummary(context, progressService),
                        const SizedBox(height: 32),
                        _buildPracticeCard(
                          context,
                          'Vocabulary',
                          'Learn new words and phrases',
                          Icons.book,
                          const Color(0xFF4CAF50),
                          progressService.getCategoryProgress('vocabulary'),
                          progressService.categoryPoints['vocabulary'] ?? 0,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VocabularyPracticeScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPracticeCard(
                          context,
                          'Grammar',
                          'Master sentence structures',
                          Icons.rule,
                          const Color(0xFF2F6FED),
                          progressService.getCategoryProgress('grammar'),
                          progressService.categoryPoints['grammar'] ?? 0,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GrammarPracticeScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPracticeCard(
                          context,
                          'Listening',
                          'Improve your listening skills',
                          Icons.headphones,
                          const Color(0xFFFFA726),
                          progressService.getCategoryProgress('listening'),
                          progressService.categoryPoints['listening'] ?? 0,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListeningPracticeScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPointsSummary(BuildContext context, ProgressService progressService) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPointsItem(
            'Total Points',
            '${progressService.totalPoints}',
            Icons.stars_rounded,
          ),
          _buildDivider(),
          _buildPointsItem(
            'Streak',
            '${progressService.currentStreak} days',
            Icons.local_fire_department_rounded,
          ),
          _buildDivider(),
          _buildPointsItem(
            'Level',
            '${_calculateOverallLevel(progressService)}',
            Icons.trending_up_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    double progress,
    int points,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$points pts',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).round()}% Complete',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  int _calculateOverallLevel(ProgressService progressService) {
    final grammarLevel = progressService.getLevelForCategory('grammar');
    final vocabularyLevel = progressService.getLevelForCategory('vocabulary');
    final listeningLevel = progressService.getLevelForCategory('listening');
    return ((grammarLevel + vocabularyLevel + listeningLevel) / 3).ceil();
  }
}

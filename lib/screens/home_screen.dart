import 'package:flutter/material.dart';
import 'dart:math';
import '../components/section_card.dart';
import '../screens/chat_screen.dart';
import '../screens/practice_screen.dart';
import 'games_screen.dart';
import '../screens/leaderboard_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../services/score_service.dart';
import '../screens/profile_screen.dart';
import '../screens/voice_chat_screen.dart';
import '../screens/level_progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLanguage = 'English';
  late ConfettiController _confettiController;
  bool _hasClaimedReward = false;
  int _streakDays = 14; // Current streak
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _loadRewardStatus();
    _loadPoints();
    // Refresh points every second
    Timer.periodic(const Duration(seconds: 1), (_) {
      _loadPoints();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadRewardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasClaimedReward = prefs.getBool('claimed_streak_reward') ?? false;
    });
  }

  Future<void> _loadPoints() async {
    if (!mounted) return;

    final gameScore = await ScoreService.getGameScore();
    final practiceScore = await ScoreService.getPracticeScore();

    setState(() {
      _totalPoints = gameScore + practiceScore;
    });
  }

  Future<void> _claimStreakReward() async {
    if (_hasClaimedReward) return;

    final prefs = await SharedPreferences.getInstance();
    await ScoreService.updatePracticeScore(_streakDays);

    setState(() {
      _hasClaimedReward = true;
    });

    await prefs.setBool('claimed_streak_reward', true);
    await _loadPoints(); // Reload total points

    _confettiController.play();

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Congratulations! +$_streakDays points added to your score!',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Word Rookie';
      case 2:
        return 'Language Scout';
      case 3:
        return 'Vocab Explorer';
      case 4:
        return 'Word Warrior';
      case 5:
        return 'Language Knight';
      case 6:
        return 'Grammar Guardian';
      case 7:
        return 'Syntax Sorcerer';
      case 8:
        return 'Word Wizard';
      case 9:
        return 'Language Legend';
      case 10:
        return 'Linguistic Lord';
      default:
        if (level > 10 && level <= 15) return 'Word Master';
        if (level > 15 && level <= 20) return 'Language Sage';
        if (level > 20 && level <= 25) return 'Vocab Virtuoso';
        if (level > 25) return 'Language God';
        return 'Word Rookie';
    }
  }

  int _calculateLevel() {
    // Base points needed for first level
    int basePoints = 100;
    // How much more points each level needs (20% increase per level)
    double increaseRate = 0.2;

    int currentPoints = _totalPoints;
    int level = 0;
    int pointsNeeded = basePoints;

    while (currentPoints >= pointsNeeded) {
      currentPoints -= pointsNeeded;
      level++;
      // Increase points needed for next level by 20%
      pointsNeeded = (basePoints * (1 + (increaseRate * level))).round();
    }

    return level + 1; // Add 1 since levels start at 1
  }

  double _calculateProgressToNextLevel() {
    int basePoints = 100;
    double increaseRate = 0.2;

    int currentPoints = _totalPoints;
    int level = 0;
    int pointsNeeded = basePoints;

    // Find current level's required points
    while (currentPoints >= pointsNeeded) {
      currentPoints -= pointsNeeded;
      level++;
      pointsNeeded = (basePoints * (1 + (increaseRate * level))).round();
    }

    // Calculate progress percentage to next level
    return currentPoints / pointsNeeded;
  }

  int _getPointsNeededForNextLevel() {
    int basePoints = 100;
    double increaseRate = 0.2;

    int currentPoints = _totalPoints;
    int level = 0;
    int pointsNeeded = basePoints;

    while (currentPoints >= pointsNeeded) {
      currentPoints -= pointsNeeded;
      level++;
      pointsNeeded = (basePoints * (1 + (increaseRate * level))).round();
    }

    return pointsNeeded - currentPoints;
  }

  Future<Map<String, int>> _getScoreBreakdown() async {
    final gameScore = await ScoreService.getGameScore();
    final practiceScore = await ScoreService.getPracticeScore();
    return {
      'games': gameScore,
      'practice': practiceScore,
      'total': gameScore + practiceScore,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0EB),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                      image: AssetImage('assets/profile.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: const Color(0xFFFF5A1A),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Robert Walker',
                                  style: TextStyle(
                                    color: const Color(0xFF141414),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LevelProgressScreen(
                                              totalPoints: _totalPoints,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            '${_getLevelName(_calculateLevel())} - Level ${_calculateLevel()}',
                                            style: TextStyle(
                                              color: const Color(0xFF141414)
                                                  .withOpacity(0.7),
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '(${_getPointsNeededForNextLevel()} pts to next)',
                                            style: TextStyle(
                                              color: const Color(0xFF141414)
                                                  .withOpacity(0.5),
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: const Color(0xFF141414)
                                                .withOpacity(0.5),
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A1A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final scores = await _getScoreBreakdown();
                              if (mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text(
                                      'Points Breakdown',
                                      style: TextStyle(
                                        color: Color(0xFF141414),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildScoreRow(
                                            'Games', scores['games']!),
                                        const SizedBox(height: 8),
                                        _buildScoreRow(
                                            'Practice', scores['practice']!),
                                        const Divider(),
                                        _buildScoreRow(
                                            'Total', scores['total']!,
                                            isTotal: true),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Color(0xFFFF5A1A),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 80),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.diamond_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatScore(_totalPoints),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Streak Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5A1A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '14 days on streak!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              5,
                              (index) => Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: index == 3
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.diamond_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${11 + index}D',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  _hasClaimedReward ? null : _claimStreakReward,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFFF5A1A),
                                disabledBackgroundColor:
                                    Colors.white.withOpacity(0.5),
                                disabledForegroundColor:
                                    const Color(0xFFFF5A1A).withOpacity(0.5),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _hasClaimedReward ? 'Claimed' : 'Get a reward',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Header with Leaderboard Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular languages',
                          style: TextStyle(
                            color: const Color(0xFF141414),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LeaderboardScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5A1A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.leaderboard,
                                  color: const Color(0xFFFF5A1A),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Leaderboard',
                                  style: TextStyle(
                                    color: Color(0xFFFF5A1A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildLanguageButton('assets/flags/unitedstates.png',
                              'English', selectedLanguage == 'English'),
                          _buildLanguageButton('assets/flags/spain.png',
                              'Spanish', selectedLanguage == 'Spanish'),
                          _buildLanguageButton('assets/flags/italy.png',
                              'Italian', selectedLanguage == 'Italian'),
                          _buildLanguageButton('assets/flags/germany.png',
                              'German', selectedLanguage == 'German'),
                          _buildLanguageButton('assets/flags/flag.png',
                              'French', selectedLanguage == 'French'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SectionCard(
                      title: 'Practice',
                      subtitle: 'Learn to say \'I can see you\' in French',
                      imagePath: 'assets/practice.jpg',
                      backgroundColor: const Color(0xFFE8F5E9),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PracticeScreen(),
                          ),
                        );
                      },
                    ),
                    SectionCard(
                      title: 'AI Chat',
                      subtitle:
                          'Chat with our AI to practice your language skills',
                      imagePath: 'assets/ai_chat.jpg',
                      backgroundColor: const Color(0xFFE3F2FD),
                      onTap: () {
                        // Add ripple effect
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening AI Chat...'),
                            duration: Duration(milliseconds: 500),
                            backgroundColor: Color(0xFFFF5A1A),
                          ),
                        );

                        // Navigate with fade transition
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ChatScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                        );
                      },
                    ),
                    SectionCard(
                      title: 'Games',
                      subtitle: 'Learn and play games at the same time',
                      imagePath: 'assets/games.jpg',
                      backgroundColor: const Color(0xFFFFF3E0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GamesScreen(),
                          ),
                        );
                      },
                    ),
                    SectionCard(
                      title: 'Voice Chat',
                      subtitle: 'Have a continuous voice conversation',
                      imagePath: 'assets/voice_chat.jpg',
                      backgroundColor: const Color(0xFFE3F2FD),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VoiceChatScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                Color(0xFFFF5A1A),
                Color(0xFF4CAF50),
                Color(0xFF2F6FED),
                Color(0xFFFFA726),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
      String flagPath, String language, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFFF7F0EB),
              title: Text(
                'Select Language',
                style: TextStyle(
                  color: const Color(0xFF141414),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'Would you like to switch to $language?',
                style: TextStyle(
                  color: const Color(0xFF141414),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Select'),
                ),
              ],
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: language == selectedLanguage
                  ? const Color(0xFFFF5A1A)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: ClipOval(
              child: Image.asset(
                flagPath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int points, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF141414),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.stars_rounded,
              color: const Color(0xFFFF5A1A),
              size: isTotal ? 20 : 16,
            ),
            const SizedBox(width: 4),
            Text(
              points.toString(),
              style: TextStyle(
                color: const Color(0xFF141414),
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatScore(int score) {
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}M';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}K';
    }
    return score.toString();
  }
}

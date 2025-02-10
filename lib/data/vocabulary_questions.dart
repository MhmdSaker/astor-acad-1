import '../models/practice_question.dart';

class VocabularyQuestions {
  static Map<String, List<PracticeQuestion>> questions = {
    'Beginner': [
      PracticeQuestion(
        question: 'Choose the correct meaning',
        word: 'House',
        meaning: 'A building for human habitation',
        options: [
          'A type of vehicle',
          'A building for living',
          'A kind of food',
          'A piece of furniture'
        ],
        correct: 1,
        level: 'Beginner',
      ),
      // Add more beginner questions...
    ],
    'Intermediate': [
      PracticeQuestion(
        question: 'What is the meaning of "Procrastinate"?',
        options: [
          'To delay',
          'To hurry',
          'To finish',
          'To start'
        ],
        correct: 0,
        level: 'Intermediate',
      ),
      // Add more intermediate questions...
    ],
    'Advanced': [
      PracticeQuestion(
        question: 'What is the meaning of "Ephemeral"?',
        options: [
          'Lasting forever',
          'Short-lived',
          'Important',
          'Meaningful'
        ],
        correct: 1,
        level: 'Advanced',
      ),
      // Add more advanced questions...
    ],
  };
} 
import '../models/practice_question.dart';

class GrammarQuestions {
  static Map<String, List<PracticeQuestion>> questions = {
    'Beginner': [
      PracticeQuestion(
        question: 'Choose the correct form:',
        sentence: 'She ___ to the store yesterday.',
        options: ['go', 'goes', 'went', 'gone'],
        correct: 2,
        level: 'Beginner',
      ),
      // Add more beginner questions...
    ],
    'Intermediate': [
      PracticeQuestion(
        question: 'Select the correct conditional:',
        options: [
          'If I am rich, I will travel',
          'If I were rich, I would travel',
          'If I was rich, I would travel',
          'If I am rich, I would travel'
        ],
        correct: 1,
        level: 'Intermediate',
      ),
      // Add more intermediate questions...
    ],
    'Advanced': [
      PracticeQuestion(
        question: 'Choose the correct subjunctive:',
        options: [
          'I suggest that he study',
          'I suggest that he studies',
          'I suggest that he studied',
          'I suggest that he has studied'
        ],
        correct: 0,
        level: 'Advanced',
      ),
      // Add more advanced questions...
    ],
  };
} 
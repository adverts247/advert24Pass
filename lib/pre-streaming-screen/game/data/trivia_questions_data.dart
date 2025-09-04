class TriviaQuestion {
  final String imageAsset;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  TriviaQuestion({
    required this.imageAsset,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

// Sample questions data
final List<TriviaQuestion> triviaQuestions = [
  TriviaQuestion(
    imageAsset: 'assets/images/eiffel_tower.jpeg',
    question: 'In which city is this famous landmark located?',
    options: ['London', 'Paris', 'Rome', 'Berlin'],
    correctAnswerIndex: 1,
    explanation:
        'The Eiffel Tower is located in Paris, France. It was completed in 1889.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/great_wall.jpeg',
    question: 'How long is the Great Wall of China approximately?',
    options: ['13,171 km', '8,851 km', '21,196 km', '5,500 km'],
    correctAnswerIndex: 0,
    explanation:
        'The Great Wall of China is approximately 13,171 kilometers (8,184 miles) long.',
  ),
  // Add more questions as needed
  TriviaQuestion(
    imageAsset: 'assets/images/northern_lights.jpeg',
    question: 'What causes the Aurora Borealis (Northern Lights)?',
    options: [
      'Solar wind particles colliding with atmospheric gases',
      'Light reflection from polar ice',
      'Atmospheric moisture crystallization',
      'Ground-based light pollution'
    ],
    correctAnswerIndex: 0,
    explanation:
        'The Aurora Borealis occurs when charged particles from the sun (solar wind) interact with gases in Earth\'s atmosphere, causing them to glow. Different colors appear based on which atmospheric gases are involved - oxygen produces green and red, while nitrogen creates blue and purple displays.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/monarch_butterfly.jpg',
    question: 'How far can Monarch butterflies migrate in a single generation?',
    options: [
      'Up to 100 kilometers',
      'Up to 500 kilometers',
      'Up to 4,000 kilometers',
      'Up to 50 kilometers'
    ],
    correctAnswerIndex: 2,
    explanation:
        'Monarch butterflies can migrate up to 4,000 kilometers (2,500 miles) from Canada to Mexico in a single generation. This remarkable journey is one of the longest known insect migrations, making them unique among butterfly species for their long-distance travel capabilities.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/taj_mahal.jpg',
    question: 'What was the primary reason for building the Taj Mahal?',
    options: [
      'As a military fortress',
      'As a memorial to Emperor Shah Jahan\'s wife',
      'As a palace for the royal family',
      'As a house of parliament'
    ],
    correctAnswerIndex: 1,
    explanation:
        'The Taj Mahal was built between 1632 and 1653 by Emperor Shah Jahan as a magnificent tomb for his beloved wife, Mumtaz Mahal. It represents the pinnacle of Mughal architecture and is considered one of the finest examples of architectural fusion between Islamic, Persian, Ottoman Turkish and Indian styles.',
  ),
];
// Add these questions to your existing triviaQuestions list
final List<TriviaQuestion> additionalQuestions = [
  TriviaQuestion(
    imageAsset: 'assets/images/northern_lights.jpg',
    question: 'What causes the Aurora Borealis (Northern Lights)?',
    options: [
      'Solar wind particles colliding with atmospheric gases',
      'Light reflection from polar ice',
      'Atmospheric moisture crystallization',
      'Ground-based light pollution'
    ],
    correctAnswerIndex: 0,
    explanation:
        'The Aurora Borealis occurs when charged particles from the sun (solar wind) interact with gases in Earth\'s atmosphere, causing them to glow. Different colors appear based on which atmospheric gases are involved - oxygen produces green and red, while nitrogen creates blue and purple displays.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/monarch_butterfly.jpg',
    question: 'How far can Monarch butterflies migrate in a single generation?',
    options: [
      'Up to 100 kilometers',
      'Up to 500 kilometers',
      'Up to 4,000 kilometers',
      'Up to 50 kilometers'
    ],
    correctAnswerIndex: 2,
    explanation:
        'Monarch butterflies can migrate up to 4,000 kilometers (2,500 miles) from Canada to Mexico in a single generation. This remarkable journey is one of the longest known insect migrations, making them unique among butterfly species for their long-distance travel capabilities.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/taj_mahal.jpg',
    question: 'What was the primary reason for building the Taj Mahal?',
    options: [
      'As a military fortress',
      'As a memorial to Emperor Shah Jahan\'s wife',
      'As a palace for the royal family',
      'As a house of parliament'
    ],
    correctAnswerIndex: 1,
    explanation:
        'The Taj Mahal was built between 1632 and 1653 by Emperor Shah Jahan as a magnificent tomb for his beloved wife, Mumtaz Mahal. It represents the pinnacle of Mughal architecture and is considered one of the finest examples of architectural fusion between Islamic, Persian, Ottoman Turkish and Indian styles.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/giant_sequoia.jpg',
    question: 'How old can Giant Sequoia trees live to be?',
    options: [
      'Up to 500 years',
      'Up to 1,000 years',
      'Up to 2,000 years',
      'Up to 3,000 years'
    ],
    correctAnswerIndex: 3,
    explanation:
        'Giant Sequoias can live up to 3,000 years old. The oldest known Giant Sequoia is over 2,700 years old. These magnificent trees can grow to heights of 300 feet (91 meters) and have bark that can be up to 3 feet (1 meter) thick, helping them survive forest fires.',
  ),
  TriviaQuestion(
    imageAsset: 'assets/images/starry_night.jpg',
    question:
        'In which facility was Van Gogh when he painted "The Starry Night"?',
    options: [
      'His home in Arles',
      'Saint-Paul-de-Mausole asylum',
      'Paris art studio',
      'Dutch countryside cottage'
    ],
    correctAnswerIndex: 1,
    explanation:
        'Vincent van Gogh painted "The Starry Night" in 1889 while he was staying at the Saint-Paul-de-Mausole asylum in France. The iconic swirling night sky was painted from memory during the day, as it was based on the view from his asylum room window, where he spent a year receiving treatment for his mental health.',
  ),
];

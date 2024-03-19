import 'dart:math';

class Cards {
  final String imagePaths;
  final int id;
  bool isMatched;
  bool isTapped;

  Cards({
    required this.imagePaths,
    required this.id,
    this.isMatched = false,
    this.isTapped = false,
  });
}

List<Cards> getRandomCards(int max) {
  List<String> imagePaths = [
    'assets/icons/cards/1.png',
    'assets/icons/cards/2.png',
    'assets/icons/cards/3.png',
    'assets/icons/cards/4.png',
    'assets/icons/cards/5.png',
    'assets/icons/cards/6.png',
    'assets/icons/cards/7.png',
    'assets/icons/cards/8.png',
    'assets/icons/cards/9.png',
    'assets/icons/cards/10.png',
    'assets/icons/cards/11.png',
    'assets/icons/cards/12.png',
    'assets/icons/cards/13.png',
    'assets/icons/cards/14.png',
    'assets/icons/cards/15.png',
    'assets/icons/cards/16.png',
    // Add more image paths as needed
  ];

  // Ensure there are enough images for the specified max
  assert(max % 2 == 0 && max ~/ 2 <= imagePaths.length);

  List<Cards> cards = [];
  for (int i = 0; i < max ~/ 2; i++) {
    // Pair specific images together
    cards.add(Cards(imagePaths: imagePaths[2 * i], id: i));
    cards.add(Cards(imagePaths: imagePaths[2 * i + 1], id: i));
  }

  return _shuffleCards(cards);
}

List<Cards> _shuffleCards(List<Cards> cards) {
  Random rng = Random();
  for (int i = cards.length - 1; i >= 1; --i) {
    int newIdx = rng.nextInt(i);
    Cards temp = cards[i];
    cards[i] = cards[newIdx];
    cards[newIdx] = temp;
  }
  return cards;
}

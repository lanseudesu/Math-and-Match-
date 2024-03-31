//cards design and pairings

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

List<Cards> getRandomCards(int max, {int start = 0, int? end}) {
  List<String> imagePaths =
      List.generate(66, (index) => 'assets/icons/cards/${index + 1}.png');

  assert(max % 2 == 0 && max ~/ 2 <= imagePaths.length);

  List<Cards> cards = [];
  //limit the loop to the specified start and end indices
  for (int i = start ~/ 2; i < (end != null ? end ~/ 2 : max ~/ 2); i++) {
    //pair specific images together
    cards.add(Cards(imagePaths: imagePaths[2 * i], id: i));
    cards.add(Cards(imagePaths: imagePaths[2 * i + 1], id: i));
  }

  return _shuffleCards(cards);
}

List<Cards> _shuffleCards(List<Cards> cards) {
  cards.shuffle();
  return cards;
}

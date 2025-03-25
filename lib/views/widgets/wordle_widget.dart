import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordleWidget extends StatefulWidget {
  const WordleWidget({super.key});

  @override
  State<WordleWidget> createState() => _WordleWidgetState();
}

class _WordleWidgetState extends State<WordleWidget> {
  final int _maxAttempts = 6;
  final int _wordLength = 5;
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];
  final String answer = "TRAIN"; // TODO: replace with randomly generated word
  int currentRow = 0;
  List<List<Color>> cellColors = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _maxAttempts * _wordLength; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
    resetColors();
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var con in controllers) {
      con.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_maxAttempts, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SizedBox(
            height: 60.0,
            width: 340.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _wordLength,
              itemBuilder: (context, colIndex) {
                int index = rowIndex * _wordLength + colIndex;
                return Row(
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        color: cellColors[rowIndex][colIndex],
                        border: Border.all(color: Colors.grey, width: 1.0),
                      ),
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        showCursor: false,
                        maxLength: 1,
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            return TextEditingValue(
                              text: newValue.text.toUpperCase(),
                              selection: newValue.selection,
                            );
                          }),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && value.length == 1) {
                            if (colIndex < _wordLength - 1) {
                              FocusScope.of(
                                context,
                              ).requestFocus(focusNodes[index + 1]);
                            } else {
                              checkWord();
                            }
                          } else if (value.isEmpty && colIndex > 0) {
                            FocusScope.of(
                              context,
                            ).requestFocus(focusNodes[index - 1]);
                            controllers[index].clear();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }

  void checkWord() {
    String guessedWord = '';
    for (int i = 0; i < _wordLength; i++) {
      guessedWord += controllers[currentRow * _wordLength + i].text;
    }

    if (guessedWord.length != _wordLength) return;

    Map<String, int> answerCharCounts = {};
    for (var char in answer.characters) {
      answerCharCounts[char] = (answerCharCounts[char] ?? 0) + 1;
    }

    for (int i = 0; i < _wordLength; i++) {
      if (guessedWord[i] == answer[i]) {
        cellColors[currentRow][i] = Colors.green;
        answerCharCounts[guessedWord[i]] =
            answerCharCounts[guessedWord[i]]! - 1;
      }
    }

    for (int i = 0; i < _wordLength; i++) {
      if (guessedWord[i] != answer[i] &&
          answer.contains(guessedWord[i]) &&
          (answerCharCounts[guessedWord[i]] ?? 0) > 0) {
        cellColors[currentRow][i] = Colors.yellow;
        answerCharCounts[guessedWord[i]] =
            answerCharCounts[guessedWord[i]]! - 1;
      } else if (cellColors[currentRow][i] == Colors.white) {
        cellColors[currentRow][i] = Colors.grey;
      }
    }

    setState(() {});

    if (guessedWord == answer) {
      currentRow++;
      showDialog(
        context: context,
        builder:
            (context) => gameOver(
              'Congratulations!',
              'You guessed the word in $currentRow attempt(s).',
            ),
      );
    } else {
      if (currentRow < _maxAttempts - 1) {
        currentRow++;
        FocusScope.of(
          context,
        ).requestFocus(focusNodes[currentRow * _wordLength]);
      } else {
        showDialog(
          context: context,
          builder:
              (context) =>
                  gameOver('Game over', 'The correct word was: $answer'),
        );
      }
    }
  }

  void resetColors() {
    cellColors = List.generate(
      _maxAttempts,
      (_) => List.generate(_wordLength, (_) => Colors.white),
    );
  }

  void resetGame() {
    setState(() {
      currentRow = 0;
      resetColors();
      for (var con in controllers) {
        con.clear();
      }
      FocusScope.of(context).unfocus();
    });
  }

  Widget gameOver(String text1, String text2) {
    return Center(
      child: SizedBox(
        height: 200.0,
        width: 300.0,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text1,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  text2,
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                  child: Text('Play again', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

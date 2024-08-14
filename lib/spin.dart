import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class SpinWheel extends StatefulWidget {
  const SpinWheel({super.key});

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>.seeded(0);
  int rewards = 0;
  List<String> selectedBets = [];
  int money = 100;
  final TextEditingController betAmountController = TextEditingController();
  bool isLocked = false;
  Timer? countdownTimer;
  int timeLeft = 30;

  List<int> items = [
    0,
    32,
    15,
    19,
    4,
    21,
    2,
    25,
    17,
    34,
    6,
    27,
    13,
    36,
    11,
    30,
    8,
    23,
    10,
    5,
    24,
    16,
    33,
    1,
    20,
    14,
    31,
    9,
    22,
    18,
    29,
    7,
    28,
    12,
    35,
    3,
    26
  ];

  @override
  void dispose() {
    selected.close();
    betAmountController.dispose();
    countdownTimer?.cancel();
    super.dispose();
  }

  void checkBetOutcome(int result) {
    int totalPayout = 0;
    int betAmount = int.tryParse(betAmountController.text) ?? 0;

    if (selectedBets.isNotEmpty && betAmount > 0) {
      for (String bet in selectedBets) {
        bool won = false;
        int payoutMultiplier = 0;

        switch (bet) {
          case '0':
            won = (result == 0);
            payoutMultiplier = 36;
            break;
          case '1-12':
            won = (result >= 1 && result <= 12);
            payoutMultiplier = 3;
            break;
          case '13-24':
            won = (result >= 13 && result <= 24);
            payoutMultiplier = 3;
            break;
          case '25-36':
            won = (result >= 25 && result <= 36);
            payoutMultiplier = 3;
            break;
          case 'Red':
            won = result != 0 && items.indexOf(result).isOdd;
            payoutMultiplier = 2;
            break;
          case 'Black':
            won = result != 0 && items.indexOf(result).isEven;
            payoutMultiplier = 2;
            break;
          case 'Odd':
            won = (result != 0 && result % 2 != 0);
            payoutMultiplier = 2;
            break;
          case 'Even':
            won = (result != 0 && result % 2 == 0);
            payoutMultiplier = 2;
            break;
        }

        if (won) {
          totalPayout += betAmount * payoutMultiplier;
        }
      }

      if (totalPayout > 0) {
        setState(() {
          money += totalPayout - (betAmount * selectedBets.length);
        });
        _showResultDialog(context, "Congratulations!", "You won \$${totalPayout - (betAmount * selectedBets.length)}");
      } else {
        setState(() {
          money -= betAmount * selectedBets.length;
        });
        _showResultDialog(context, "Better Luck Next Time!", "You lost \$${betAmount * selectedBets.length}");
      }
    }

    setState(() {
      selectedBets.clear();
      betAmountController.clear();
    });
  }

  void _showResultDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                  bottom: 20,
                ),
                margin: const EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 10),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      content,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void startTimer() {
    setState(() {
      isLocked = false;
      timeLeft = 30;
    });
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          isLocked = true;
          timer.cancel();
          selected.add(Fortune.randomInt(0, items.length));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final wheelSize = screenWidth * 0.8;
    final adjustedWheelSize = screenWidth > 650 ? 520.0 : wheelSize;
    final gridItemSize = screenWidth * 0.2;
    final coinSize = screenWidth > 650 ? 45.7 : 30.7;
    final fontSize = screenWidth > 650 ? 24.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.05),
                color: Colors.white,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Spin the Wheel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth > 650 ? 30 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Row(
                        children: [
                          Image.asset(
                            'images/coin.png',
                            width: coinSize,
                            height: coinSize,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$money',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: adjustedWheelSize,
                          width: adjustedWheelSize,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: adjustedWheelSize * 0.93,
                                child: FortuneWheel(
                                  selected: selected.stream,
                                  animateFirst: false,
                                  items: [
                                    for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                                      FortuneItem(
                                        child: Transform.rotate(
                                          angle: 1.57,
                                          child: Transform.translate(
                                            offset: Offset(0, -(adjustedWheelSize * 0.1)),
                                            child: Text(
                                              items[i].toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        style: FortuneItemStyle(
                                          borderColor: Colors.black,
                                          color: items[i] == 0
                                              ? Colors.green
                                              : i.isEven
                                                  ? Colors.black
                                                  : Colors.red,
                                          borderWidth: 2,
                                        ),
                                      ),
                                    },
                                  ],
                                  indicators: const [],
                                  onAnimationEnd: () {
                                    setState(() {
                                      rewards = items[selected.value];
                                    });
                                    checkBetOutcome(rewards);
                                  },
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'images/bordb.png',
                                    width: adjustedWheelSize,
                                    height: adjustedWheelSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (timeLeft > 0 && !isLocked)
                          Text(
                            'Time left: $timeLeft seconds',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (timeLeft == 30)
                          GestureDetector(
                            onTap: () {
                              startTimer();
                            },
                            child: Container(
                              height: constraints.maxHeight * 0.07,
                              width: constraints.maxWidth * 0.4,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.redAccent,
                                    Colors.orangeAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 5,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "S T A R T",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: gridItemSize * 3,
                          width: screenWidth * 0.9,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: screenWidth * 0.04,
                              mainAxisSpacing: screenWidth * 0.04,
                              childAspectRatio: 1,
                            ),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              String label;
                              String multiplier;
                              switch (index) {
                                case 0:
                                  label = '0';
                                  multiplier = 'x36';
                                  break;
                                case 1:
                                  label = '1-12';
                                  multiplier = 'x3';
                                  break;
                                case 2:
                                  label = '13-24';
                                  multiplier = 'x3';
                                  break;
                                case 3:
                                  label = '25-36';
                                  multiplier = 'x3';
                                  break;
                                case 4:
                                  label = 'Red';
                                  multiplier = 'x2';
                                  break;
                                case 5:
                                  label = 'Black';
                                  multiplier = 'x2';
                                  break;
                                case 6:
                                  label = 'Odd';
                                  multiplier = 'x2';
                                  break;
                                case 7:
                                  label = 'Even';
                                  multiplier = 'x2';
                                  break;
                                default:
                                  label = '';
                                  multiplier = '';
                              }

                              return GestureDetector(
                                onTap: isLocked
                                    ? null
                                    : () {
                                        setState(() {
                                          if (selectedBets.contains(label)) {
                                            selectedBets.remove(label);
                                          } else {
                                            if (label == '0') {
                                              selectedBets.clear();
                                            } else {
                                              if (label == 'Odd' && selectedBets.contains('Even')) {
                                                selectedBets.remove('Even');
                                              } else if (label == 'Even' && selectedBets.contains('Odd')) {
                                                selectedBets.remove('Odd');
                                              } else if (label == 'Red' && selectedBets.contains('Black')) {
                                                selectedBets.remove('Black');
                                              } else if (label == 'Black' && selectedBets.contains('Red')) {
                                                selectedBets.remove('Red');
                                              }

                                              if (label == '1-12' || label == '13-24' || label == '25-36') {
                                                List<String> selectedRangeBets = selectedBets.where((bet) => bet == '1-12' || bet == '13-24' || bet == '25-36').toList();

                                                if (selectedRangeBets.length == 2) {
                                                  selectedBets.remove(selectedRangeBets[0]);
                                                }
                                              }
                                            }

                                            selectedBets.add(label);
                                          }
                                        });
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedBets.contains(label) ? Colors.redAccent : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedBets.contains(label) ? Colors.black : Colors.grey,
                                      width: 2,
                                    ),
                                    boxShadow: selectedBets.contains(label)
                                        ? [
                                            BoxShadow(
                                              color: Colors.redAccent.withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        multiplier,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: TextField(
                            controller: betAmountController,
                            keyboardType: TextInputType.number,
                            enabled: !isLocked,
                            decoration: InputDecoration(
                                prefixIcon: Image.asset(
                                  'images/coin.png',
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                ),
                                hintText: 'Enter your bet amount',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8),
                                )),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

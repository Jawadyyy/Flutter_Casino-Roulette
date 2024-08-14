import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class RouletteApp extends StatelessWidget {
  RouletteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouletteScreen(),
    );
  }
}

class RouletteScreen extends StatelessWidget {
  RouletteScreen({super.key});

  final List<int> items = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        title: const Text('Roulette Game'),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildBottomSheet(context),
            );
          },
          child: const Text('Open Roulette'),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child: FortuneWheel(
                        animateFirst: false,
                        items: [
                          for (int i = 0; i < items.length; i++)
                            FortuneItem(
                              child: Transform.rotate(
                                angle: 1.57,
                                child: Transform.translate(
                                  offset: const Offset(0, -30),
                                  child: Text(
                                    items[i].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
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
                        ],
                        indicators: const [],
                      ),
                    ),
                    Positioned(
                      child: Image.asset(
                        'images/bordb.png',
                        width: 275,
                        height: 275,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total bet: 0', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text('My bet: 0', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  width: 375,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final labels = [
                        '0',
                        '1-12',
                        '13-24',
                        '25-36',
                        'Red',
                        'Black',
                        'Odd',
                        'Even'
                      ];
                      final multipliers = [
                        'x36',
                        'x3',
                        'x3',
                        'x3',
                        'x2',
                        'x2',
                        'x2',
                        'x2'
                      ];

                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                labels[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                multipliers[index],
                                style: const TextStyle(
                                  fontSize: 16,
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        'images/coin.png',
                        width: 20,
                        height: 20,
                      ),
                      hintText: 'Enter your bet amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:su_doku_uygulamasi/constants/dil.dart';
import 'package:su_doku_uygulamasi/constants/sabitler.dart';
import 'package:su_doku_uygulamasi/constants/sudokular.dart';

class SuDokuSayfasi extends StatefulWidget {
  const SuDokuSayfasi({super.key});

  @override
  State<SuDokuSayfasi> createState() => _SuDokuSayfasiState();
}

class _SuDokuSayfasiState extends State<SuDokuSayfasi> {
  final Box _sudokuKutu = Hive.box('sudoku');
  List _sudoku = [];
  final List<List<int>> ornekSoru = [
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
  ];
  late String _sudokuString;
  void _sudokuOlustur() {
    int gorulecekSayisi = sudokuSeviyeleri[
        _sudokuKutu.get('seviye', defaultValue: dil['seviye2'])]!;
    _sudokuString = sudokular[Random().nextInt(sudokular.length)];
    //618732954925148763347956128839267415571493682462815379784321596153689247296574831
    //ifadeyi 9 erli parçalara bölme
    _sudoku = List.generate(
      9,
      (i) => List.generate(
        9,
        (j) => int.tryParse(
            _sudokuString.substring(i * 9, (i + 1) * 9).split('')[j]),
      ),
    );
    int i = 0;
    //ekrana silerek yazı yazma
    while (i < 81 - gorulecekSayisi) {
      int x = Random().nextInt(9);
      int y = Random().nextInt(9);
      if (_sudoku[x][y] != 0) {
        print(_sudoku[x][y]);
        _sudoku[x][y] = 0;
        i++;
      }
    }

    print(_sudokuString);
    print(gorulecekSayisi);
  }

  @override
  void initState() {
    super.initState();
    _sudokuOlustur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dil['sudoku_title']),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              _sudokuKutu.get('seviye', defaultValue: dil['seviye2']),
            ),
            AspectRatio(
              aspectRatio: 1, //AspectRatio oranı korur, tam kare yaptık
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    for (int x = 0; x < 9; x++)
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  for (int y = 0; y < 9; y++)
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.all(1),
                                              color: Colors.blue,
                                              alignment: Alignment.center,
                                              child: Text(
                                                _sudoku[x][y].toString(),
                                              ),
                                            ),
                                          ),
                                          if (y == 2 || y == 5)
                                            const SizedBox(width: 2),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (x == 2 || x == 5) const SizedBox(height: 2),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  color: Colors.amber,
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  color: Colors.amber,
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    color: Colors.amber,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  color: Colors.amber,
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  color: Colors.amber,
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    color: Colors.amber,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 1; i < 10; i += 3)
                          Expanded(
                            child: Row(
                              children: [
                                for (int j = 0; j < 3; j++)
                                  Expanded(
                                    child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {},
                                      child: Card(
                                        shape: const CircleBorder(),
                                        color: Colors.amber,
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(3),
                                          child: Text(
                                            '${i + j}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

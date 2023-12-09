import 'dart:async';
import 'dart:convert';
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
  late Timer _sayac;
  List _sudoku = [], _sudokuHistory = [];
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
  bool _note = false;
  late String _sudokuString;
  void _sudokuOlustur() {
    int gorulecekSayisi = sudokuSeviyeleri[_sudokuKutu.get('seviye', defaultValue: dil['seviye2'])]!;
    _sudokuString = sudokular[Random().nextInt(sudokular.length)];
    _sudokuKutu.put('sudokuString', _sudokuString);
    //618732954925148763347956128839267415571493682462815379784321596153689247296574831
    //ifadeyi 9 erli parçalara bölme
    _sudoku = List.generate(
      9,
      (i) => List.generate(
        9,
        (j) => "e${_sudokuString.substring(i * 9, (i + 1) * 9).split('')[j]}",
      ),
    );
    int i = 0;
    //ekrana silerek yazı yazma
    while (i < 81 - gorulecekSayisi) {
      int x = Random().nextInt(9);
      int y = Random().nextInt(9);
      if (_sudoku[x][y] != '0') {
        print(_sudoku[x][y]);
        _sudoku[x][y] = '0';
        i++;
      }
    }
    _sudokuKutu.put('sudokuRows', _sudoku);
    _sudokuKutu.put('xy', '99');
    _sudokuKutu.put('ipucu', 3);
    _sudokuKutu.put('sure', 0);
    print(_sudokuString);
    print(gorulecekSayisi);
  }

  void _adimKaydet() {
    Map historyItem = {
      'sudokuRows': _sudokuKutu.get('sudokuRows'),
      'xy': _sudokuKutu.get('xy'),
      'ipucu': _sudokuKutu.get('ipucu'),
    };
    _sudokuHistory.add(jsonEncode(historyItem));

    _sudokuKutu.put('_sudokuHistory', _sudokuHistory);
  }

  @override
  void initState() {
    super.initState();
    if (_sudokuKutu.get('sudokuRows') == null) _sudokuOlustur();
    _sayac = Timer.periodic(const Duration(seconds: 1), (timer) {
      int sure = _sudokuKutu.get('sure');
      _sudokuKutu.put('sure', ++sure);
    });
  }

  @override
  void dispose() {
    if (_sayac != null && _sayac.isActive) _sayac.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dil['sudoku_title']),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
                child: ValueListenableBuilder<Box>(
                    valueListenable: _sudokuKutu.listenable(keys: ['sure']),
                    builder: (context, box, _) {
                      String sure = Duration(seconds: box.get('sure')).toString();
                      return Text(
                        sure.split('.').first,
                        style: const TextStyle(fontSize: 20),
                      );
                    })),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              _sudokuKutu.get('seviye', defaultValue: dil['seviye2']),
            ),
            AspectRatio(
              aspectRatio: 1, //AspectRatio oranı korur, tam kare yaptık
              child: ValueListenableBuilder<Box>(
                valueListenable: _sudokuKutu.listenable(keys: ['xy', 'sudokuRows']),
                builder: (context, box, widget) {
                  String xy = box.get('xy');
                  int xC = int.parse(xy.substring(0, 1)), yC = int.parse(xy.substring(1));
                  List sudokuRows = box.get('sudokuRows');
                  return Container(
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
                                                  color: xC == x && yC == y
                                                      ? Colors.green
                                                      : Colors.blue.withOpacity(xC == x || yC == y ? 0.4 : 1),
                                                  alignment: Alignment.center,
                                                  child: '${sudokuRows[x][y]}'.startsWith('e')
                                                      ? Text(
                                                          '${sudokuRows[x][y]}'.substring(1),
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 22),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            print('$x$y');
                                                            _sudokuKutu.put('xy', '$x$y');
                                                          },
                                                          child: Center(
                                                            child: '${sudokuRows[x][y]}'.length > 8
                                                                ? Column(
                                                                    children: [
                                                                      for (int i = 0; i < 9; i += 3)
                                                                        Expanded(
                                                                          child: Row(
                                                                            children: [
                                                                              for (int j = 0; j < 3; j++)
                                                                                Expanded(
                                                                                    child: Center(
                                                                                  child: Text(
                                                                                    '${sudokuRows[x][y]}'
                                                                                                .split('')[i + j] ==
                                                                                            '0'
                                                                                        ? ''
                                                                                        : '${sudokuRows[x][y]}'
                                                                                            .split('')[i + j],
                                                                                    style:
                                                                                        const TextStyle(fontSize: 10),
                                                                                  ),
                                                                                ))
                                                                            ],
                                                                          ),
                                                                        )
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    sudokuRows[x][y] != '0' ? sudokuRows[x][y] : '',
                                                                    style: const TextStyle(
                                                                      fontSize: 20,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              if (y == 2 || y == 5) const SizedBox(width: 2),
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
                  );
                },
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
                                  margin: const EdgeInsets.all(8),
                                  color: Colors.amber,
                                  child: InkWell(
                                    onTap: () {
                                      String xy = _sudokuKutu.get('xy');

                                      if (xy != '99') {
                                        int xC = int.parse(xy.substring(0, 1)), yC = int.parse(xy.substring(1));
                                        _sudoku[xC][yC] = '0';
                                        _sudokuKutu.put('sudokuRows', _sudoku);
                                        _adimKaydet();
                                      }
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete, color: Colors.black),
                                        Text(
                                          'Sil',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ValueListenableBuilder<Box>(
                                    valueListenable: _sudokuKutu.listenable(keys: ['ipucu']),
                                    builder: (context, box, widget) {
                                      return Card(
                                        margin: const EdgeInsets.all(8),
                                        color: Colors.amber,
                                        child: InkWell(
                                          onTap: () {
                                            String xy = box.get('xy');

                                            if (xy != '99' && box.get('ipucu') > 0) {
                                              int xC = int.parse(xy.substring(0, 1)), yC = int.parse(xy.substring(1));
                                              String cozumString = box.get('sudokuString');

                                              List cozumSudoku = List.generate(
                                                9,
                                                (i) => List.generate(
                                                  9,
                                                  (j) => cozumString.substring(i * 9, (i + 1) * 9).split('')[j],
                                                ),
                                              );
                                              if (_sudoku[xC][yC] != cozumSudoku[xC][yC]) {
                                                _sudoku[xC][yC] = cozumSudoku[xC][yC];
                                                box.put('sudokuRows', _sudoku);
                                                box.put('ipucu', box.get('ipucu') - 1);
                                                _adimKaydet();
                                              }
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.lightbulb, color: Colors.black),
                                                  Text(
                                                    ' : ${box.get('ipucu')}',
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              const Text(
                                                'İpucu',
                                                style: TextStyle(color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  color: _note ? Colors.amber.withOpacity(0.4) : Colors.amber,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _note = !_note;
                                      });
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.note_add, color: Colors.black),
                                        Text(
                                          'Not',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.all(8),
                                  color: Colors.amber,
                                  child: InkWell(
                                    onTap: () {
                                      if (_sudokuHistory.length > 1) {
                                        _sudokuHistory.removeLast();
                                        Map onceki = jsonDecode(_sudokuHistory.last);
                                        /* Map historyItem = {
                                          'sudokuRows': _sudokuKutu.get('sudokuRows'),
                                          'xy': _sudokuKutu.get('xy'),
                                          'ipucu': _sudokuKutu.get('ipucu'),
                                        };*/
                                        _sudokuKutu.put('sudokuRows', onceki['sudokuRows']);
                                        _sudokuKutu.put('xy', onceki['xy']);
                                        _sudokuKutu.put('ipucu', onceki['ipucu']);
                                        _sudokuKutu.put('_sudokuHistory', _sudokuHistory);
                                      }
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.undo, color: Colors.black),
                                        Text(
                                          'Geri Al',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
                                      onTap: () {
                                        String xy = _sudokuKutu.get('xy');

                                        if (xy != '99') {
                                          int xC = int.parse(xy.substring(0, 1)), yC = int.parse(xy.substring(1));
                                          if (!_note) {
                                            _sudoku[xC][yC] = '${i + j}';
                                          } else {
                                            if ('${_sudoku[xC][yC]}'.length < 8) _sudoku[xC][yC] = '000000000';

                                            _sudoku[xC][yC] = '${_sudoku[xC][yC]}'.replaceRange(
                                              i + j - 1,
                                              i + j,
                                              _sudoku[xC][yC] =
                                                  '${_sudoku[xC][yC]}'.substring(i + j - 1, i + j) == '${i + j}'
                                                      ? '0'
                                                      : '${i + j}',
                                            );
                                          }
                                          _sudokuKutu.put('sudokuRows', _sudoku);
                                          _adimKaydet();
                                        }
                                      },
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

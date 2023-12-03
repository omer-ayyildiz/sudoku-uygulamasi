import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:su_doku_uygulamasi/constants/dil.dart';
import 'package:su_doku_uygulamasi/constants/sabitler.dart';
import 'package:su_doku_uygulamasi/screen/sudoku_sayfasi.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  late Box _sudokuKutu;
  Future<Box> _kutuAc() async {
    _sudokuKutu = await Hive.openBox('sudoku');
    return await Hive.openBox('tamamlanan_sudokular');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dil['giris_title']),
        actions: [
          IconButton(
            onPressed: () {
              Box kutu = Hive.box('ayarlar');
              Hive.box('ayarlar').put('karanlik_tema',
                  !kutu.get('karanlik_tema', defaultValue: false));
            },
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton(
            onSelected: (deger) {
              if (_sudokuKutu.isOpen) {
                _sudokuKutu.put('seviye', deger);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SuDokuSayfasi()),
                );
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  value: dil['seviye_secim'],
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  enabled: false,
                  child: Text(dil['seviye_secim']),
                ),
                for (String k in sudokuSeviyeleri.keys)
                  PopupMenuItem(
                    value: k,
                    child: Text(k),
                  )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder<Box>(
        future: _kutuAc(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.data!.length == 0)
                    Text(
                      dil['tamamlanan_yok'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lobster(fontSize: 18),
                    ),
                  for (var eleman in snapshot.data!.values)
                    Center(child: Text('$eleman'))
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
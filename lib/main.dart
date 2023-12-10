import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:su_doku_uygulamasi/screen/giris_sayfasi.dart';

void main() async {
  await Hive.initFlutter('sudoku'); //sudoku klasörüne verileri kaydet- zorunlu değil

  //Box-> sql de veritabanları tablolara denk gelir
  await Hive.openBox('ayarlar');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('ayarlar').listenable(keys: ['karanlik_tema', 'dil']), //iki anahtarı dinle
      builder: (context, kutu, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: kutu.get('karanlik_tema', defaultValue: false) ? ThemeData.dark() : ThemeData.light(),
          /*  theme: ThemeData(
            textTheme: GoogleFonts.lobsterTextTheme(),
          ),*/
          home: const GirisSayfasi(),
        );
      },
    );
  }
}

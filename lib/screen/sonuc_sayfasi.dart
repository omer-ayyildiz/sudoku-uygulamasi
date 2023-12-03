import 'package:flutter/material.dart';
import 'package:su_doku_uygulamasi/constants/dil.dart';

class SonucSayfasi extends StatefulWidget {
  const SonucSayfasi({super.key});

  @override
  State<SonucSayfasi> createState() => _SonucSayfasiState();
}

class _SonucSayfasiState extends State<SonucSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: dil['giris_title'],
      ),
    );
  }
}

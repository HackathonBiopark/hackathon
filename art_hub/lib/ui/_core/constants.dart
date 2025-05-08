import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color preto = Color(0xFF000000);
  static const Color pretoOnix = Color(0xFF23272A);
  static const Color cinzaAzulado = Color(0xFF45484D);
  static const Color cinza = Color(0xFF767676);
  static const Color cinzaClaro = Color(0xFF9B9B9B);
  static const Color branco = Color.fromARGB(0, 255, 255, 255);
}

abstract class AppText {
  static const TextStyle titulo = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.cinzaAzulado);
  static const TextStyle texto =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black);
  static const TextStyle textoPequeno = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.cinza);
}

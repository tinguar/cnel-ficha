import 'package:url_launcher/url_launcher.dart';

class RegexUtils {
  static final RegExp numberR = RegExp(r'[0-9]');
}


// Método para lanzar la URL
Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'No se pudo abrir $url';
  }
}
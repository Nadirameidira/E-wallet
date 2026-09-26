/// Ubah angka jadi format Rupiah pake titik ribuan, contoh: 1234567 -> "1.234.567"
String formatRupiah(int amount) {
  final str = amount.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < str.length; i++) {
    final posFromRight = str.length - i;
    buffer.write(str[i]);
    if (posFromRight > 1 && posFromRight % 3 == 1) {
      buffer.write('.');
    }
  }

  return buffer.toString();
}

/*
 * MIT License
 *
 * Copyright (c) 2023 FORM08.COM s.r.o.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Project: Form08
 * Module: ac_dart
 * File: format.dart
 *
 */

import '../extensions/datetime_ext.dart';
import 'package:intl/intl.dart';

DateFormat _globalDF = DateFormat('E dd.MM.yyyy', 'cs_CZ');
DateFormat get globalDateFormat => _globalDF;
String formatDate(DateTime? date) => date == null ? '' : _globalDF.format(date);

DateFormat _globalSDF = DateFormat('EEEE, dd.MM.', 'cs_CZ');
DateFormat get globalShortDateFormat => _globalSDF;
String formatShortDate(DateTime? date) => date == null ? '' : _globalSDF.format(date);

DateFormat _globalBDF = DateFormat('dd.MM.yyyy', 'cs_CZ');
DateFormat get globalBirthdayFormat => _globalBDF;
String formatBirthday(DateTime? date) => date == null ? '' : _globalBDF.format(date);

DateFormat _globalTF = DateFormat.Hm();
DateFormat get globalTimeFormat => _globalTF;
String formatTime(DateTime? date) => date == null ? '' : _globalTF.format(date);

DateFormat _globalDTF = DateFormat('E dd.MM.yyyy HH:mm', 'cs_CZ');
DateFormat get globalDateTimeFormat => _globalDTF;
String formatDateTime(DateTime? date) => date == null ? '' : _globalDTF.format(date);

DateFormat _globalCsvDF = DateFormat('dd.MM.yyyy', 'cs_CZ');
DateFormat get csvDateFormat => _globalCsvDF;
String formatCsvDate(DateTime? date) => date == null ? '' : _globalCsvDF.format(date);
String formatPdfDate(DateTime? date) => date == null ? '' : _globalCsvDF.format(date);

String formatDateTimeRange(DateTime from, DateTime to) => from.trunc(DateTimeExt.unitDay) == to.trunc(DateTimeExt.unitDay)
    ? '${formatDateTime(from)} - ${formatTime(to)}'
    : '${formatDateTime(from)} - ${formatDateTime(to)}';

NumberFormat _globalCurrFmt = NumberFormat('#0.00', 'cs_CZ');
String formatPrice(num? price) => price == null ? '' : '${price.toStringAsFixed(2)} Kč';
String formatCsvPrice(num? price) => price == null ? '' : _globalCurrFmt.format(price);
String formatPdfPrice(num? price) => price == null ? '' : _globalCurrFmt.format(price);

NumberFormat _globalNumFmt = NumberFormat('#0.##', 'cs_CZ');
String formatNumber(num? number, [int decimals = 2]) => number == null ? '' : number.toStringAsFixed(decimals);
String formatCsvNumber(num? number) => number == null ? '' : _globalNumFmt.format(number);
String formatPdfNumber(num? number) => number == null ? '' : _globalNumFmt.format(number);

String formatDistance(num? distance, {String unit = 'm', double modulo = 1.0, int decimal = 2}) =>
    distance == null ? '' : '${(distance / modulo).toStringAsFixed(decimal)} $unit';

String formatLatitude(double lat) {
  return '${_formatLL(lat)}${lat < 0 ? 'S' : 'N'}';
}

String formatLongitude(double lng) {
  return '${_formatLL(lng)}${lng < 0 ? 'W' : 'E'}';
}

String _formatLL(double ll) {
  final value = ll.abs();
  final deg = value.floor();
  final min = ((value - deg) * 60).floor();
  final sec = (((value - deg) * 60 - min) * 60);
  return '$deg°$min\'${sec.toStringAsFixed(3)}"';
}

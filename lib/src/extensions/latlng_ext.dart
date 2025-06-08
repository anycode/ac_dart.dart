/*
 * Copyright 2025 Martin Edlman - Anycode <ac@anycode.dev>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:ac_dart/src/format/format_latlng.dart';
import 'package:latlong2/latlong.dart';

extension LatLngExt on LatLng {
  /// Parse [String] input into [gm.LatLng] object
  /// Input can be decimal degrees or composed degrees where minutes can be decimal or composed
  /// Latitude and longitude can be in any order and delimited by any separator (space, coma, colon, semicolon)
  /// other than digit, dot (decimal point) and 'N','S','E','W'
  /// Valid inputs are e.g.
  /// * 50.763849890N 16.3423545E
  /// * 50deg 30min 5.64324sec N, 16deg 12.3456min E
  /// * 50° 30' 5.65434" N, 16° 12' 8.2324235" E
  /// or any combination, e.g.
  /// * 50.763849890N;16deg 12.3456' E
  /// * 50° 30' 5.65434" N, 16deg 12.3456min E
  static LatLng? parse(String? input) {
    if (input == null) {
      return null;
    }
    // a-z non capturing groups
    // 1-E capturing groups
    //    deg                                                        min                                             sec
    //    a  1   b       b 1c            c  2   2d                  de  3   f       f 3g       g 4   4h             hi  5   j       j 5k       ki e a   6      6
    final llRegex = RegExp(
      r'''(?:(\d+(?:\.\d+)?)(?:\u00B0|deg)?|(\d+)(?:\u00B0\s*|deg\s+)(?:(\d+(?:\.\d+)?)(?:'|min)|(\d+)(?:'\s*|min\s+)(?:(\d+(?:\.\d+)?)(?:"|sec))?)?)\s*([NSEW])''',
      unicode: false,
      caseSensitive: false,
    );
    if (llRegex.hasMatch(input)) {
      var lat = 0.0;
      var lng = 0.0;
      llRegex.allMatches(input).forEach((match) {
        final ll = match[1] != null
            ? double.parse(match[1]!) // decimal degrees
            : int.parse(match[2]!) // degrees with optional minutes and seconds
                +
                (match[3] != null
                    ? double.parse(match[3]!) / 60 // decimal minutes
                    : int.parse(match[4]!) / 60 // minutes with optional seconds
                        +
                        (match[5] != null
                            ? double.parse(match[5]!) / 3600 // decimal seconds
                            : 0.0));
        switch (match[6]!) {
          case 'N':
            lat = ll;
            break;
          case 'S':
            lat = -ll;
            break;
          case 'E':
            lng = ll;
            break;
          case 'W':
            lng = -ll;
            break;
          default:
            break; // should not get here
        }
      });
      return LatLng(lat, lng);
    } else {
      return null;
    }
  }

  /// Format [LatLng] to string in DMS format
  /// Example:
  /// ```dart
  /// LatLng(50.763849890, 16.3423545).format(); // 50°45'49.86"N, 16°20'32.48"E
  /// ```
  String format() => '${FormatLatitude().formatDMS(latitude)} ${FormatLongitude().formatDMS(longitude)}';
}

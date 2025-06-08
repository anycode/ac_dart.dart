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

import '../extensions/datetime_ext.dart';
import '../format/format_datetime.dart';

/// Helper function to format date range specified by DateTime objects. If both are the same date,
/// output is formatted as "datetime from - time to". Otherwise, output is formatted as "datetime from - datetime to".
///
/// e.g.
/// ```dart
/// DateTime date1 = DateTime(2025, 1, 1, 10, 0, 0);
/// DateTime date2 = DateTime(2025, 1, 1, 14, 0, 0);
/// DateTime date3 = DateTime(2025, 2, 1, 18, 0, 0);
/// final fmt1 = formatDateTimeRange(date1, date2); // "01.01.2025 10:00 - 14:00"
/// final fmt2 = formatDateTimeRange(date1, date3); // "01.01.2025 10:00 - 01.02.2025 18:00"
/// ```
String formatDateTimeRange(DateTime from, DateTime to) => from.trunc(DateTimeExt.unitDay) == to.trunc(DateTimeExt.unitDay)
    ? '${formatDateTime(from)} - ${formatTime(to)}'
    : '${formatDateTime(from)} - ${formatDateTime(to)}';

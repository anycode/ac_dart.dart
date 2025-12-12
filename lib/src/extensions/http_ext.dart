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

import 'dart:io';

extension ContentTypeExt on ContentType {
  /// Content type representing application/error+json mime type
  static final errorJson = ContentType('application', 'error+json', charset: 'utf-8');

  /// Content type representing application/geo+json mime type
  static final geoJson = ContentType('application', 'geo+json', charset: 'utf-8');

  /// Content type representing text/csv mime type
  static final csv = ContentType('text', 'csv', charset: 'utf-8');

  /// Content type representing text/csv mime type with Windows-1250 encoding
  static final csvWin = ContentType('text', 'csv', charset: 'windows-1250');

  /// Content type representing application/pdf mime type
  static final pdf = ContentType('application', 'pdf');

  /// Content type representing application/zip mime type
  static final zip = ContentType('application', 'zip');

  /// Content type representing multipart/form-data mime type
  static final formData = ContentType('multipart', 'form-data');

  /// Content type representing application/x-www-form-urlencoded mime type
  static final formUrlEncoded = ContentType('application', 'x-www-form-urlencoded');

  /// Test whether the content type is a binary
  bool get isBinary => primaryType == 'image' ||
      primaryType == 'video' ||
      primaryType == 'audio' ||
      subType == 'octet-stream' ||
      subType == 'pdf' ||
      subType == 'zip';

  bool get isText => primaryType == 'text' ||
      primaryType == 'json' ||
      subType == 'xml' ||
      subType == 'json';

  bool equals(ContentType? other) {
    return primaryType == other?.primaryType &&
        subType == other?.subType &&
        parameters['charset'] == other?.parameters['charset'];

  }
}

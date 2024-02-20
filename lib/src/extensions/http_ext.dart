import 'dart:io';

extension ContentTypeExt on ContentType {
  /// Content type representing application/error+json mime type
  static final errorJson = ContentType('application', 'error+json', charset: 'utf-8');

  /// Content type representing text/csv mime type
  static final csv = ContentType('text', 'csv', charset: 'utf-8');

  /// Content type representing application/pdf mime type
  static final pdf = ContentType('application', 'pdf');

  /// Content type representing application/zip mime type
  static final zip = ContentType('application', 'zip');

  /// Content type representing multipart/form-data mime type
  static final formData = ContentType('multipart', 'form-data');

  /// Content type representing application/x-www-form-urlencoded mime type
  static final formUrlEncoded = ContentType('application', 'x-www-form-urlencoded');
}

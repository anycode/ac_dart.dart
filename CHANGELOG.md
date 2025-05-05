## 0.1.19

- Fix handling multiple loggers with same name

## 0.1.18

- Log failures in cron tasks

## 0.1.17

- Update dep on ac_ranges

## 0.1.16

- Use `ProductionFilter` to enable logging in non-development environments

## 0.1.15

- Remove extra \n from logger
- Add `formatLatLng(double, double)` function
- Move capitalize String extension method from ac_flutter

## 0.1.14

- Add missing documentation

## 0.1.13

- Fix clearing log files.
- Test if Content type is a text
- Simple event bus objects with extensions on `EventBus`

## 0.1.12

- Allow logging to console only (suitable for Flutter Web) by calling `DebugLogger.console()` factory constructor.

## 0.1.11

- Add extension getter `isBinary` to ContentType to check if content type is binary

## 0.1.10

- Update dependencies
- Update Dart SDK

## 0.1.9

- Add getter to return output of the logger.
- HEX converter to convert PgSQL hex bytea (byte array) to/from String
- Quarter (part of a year) converter. Can be represented as datetime as "YYYY-MM-01" or a String "YYYYqX" where X is number 1-4
- New ContentType for application/geo+json (Geo JSON)
- Extension to offer logging methods from `logging` package logger, to allow easier transition.

## 0.1.8

- Added cron extension which logs start and finish of the tasks to 'cronjob.log' file
- Added content type for CSV with Windows 1250 encoding
- Fixed `DateTime.format()` methods signatures
- Extended `DebugLogger` with optional 'id' tag.
- Date/Time and date range converters with support for PgSql annotations
- Added numeric converter (for converting numeric values read from PgSQL)

## 0.1.7

- ColorConverter moved to `ac_flutter`

## 0.1.6

- Generally available public release

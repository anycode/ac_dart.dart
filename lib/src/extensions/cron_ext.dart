import 'package:cron/cron.dart';
import 'package:uuid/uuid.dart';

import '../logger/debug_logger.dart';

extension CronExt on Cron {
  /// Logger for cron jobs.
  ///
  /// It uses [DebugLogger] with a unique prefix for each instance.
  /// The prefix is the first 8 characters of a UUID v1.
  static final logger = DebugLogger(
    name: 'cronjob',
    printer: DebugPrinter(prefix: Uuid().v1().toString().substring(0, 8)),
  );

  /// Schedules a task and logs the start and end of execution. It's almost the same like [schedule] method,
  /// takes one extra argument to identify the task in logs.
  void logSchedule(Schedule schedule, Task task, [String taskName = 'unnamed']) {
    logger.i('Cron task $taskName scheduled to ${schedule.format()}');
    this.schedule(schedule, () async {
      logger.i('Cron task $taskName scheduled to ${schedule.format()} started at ${DateTime.now()}');
      try {
        final result = await task.call();
        if (result is Future) {
          result.then((value) {
            logger.i('Cron task $taskName scheduled to ${schedule.format()} finished at ${DateTime.now()} with result $value');
          });
        } else {
          logger.i('Cron task $taskName scheduled to ${schedule.format()} finished at ${DateTime.now()} with result $result');
        }
      } catch(e,st) {
        logger.f('Cron task $taskName scheduled to ${schedule.format()} failed at ${DateTime.now()}', error: e, stackTrace: st);
      }
    });
  }
}

extension ScheduleExt on Schedule {
  /// Formats the schedule to a human-readable string.
  ///
  /// It returns a string with the following format:
  /// `months: <months>, weekdays: <weekdays>, days: <days>, hours: <hours>, minutes: <minutes>`
  /// If all values are present, it will use `*` instead of the list of values.
  String format() {
    return 'months: ${(months?.length == 12 ? '*' : months) ?? '*'}, '
        'weekdays: ${(weekdays?.length == 7 ? '*' : weekdays) ?? '*'}, '
        'days: ${(days?.length == 31 ? '*' : days) ?? '*'}, '
        'hours: ${(hours?.length == 24 ? '*' : hours) ?? '*'}, '
        'minutes: ${(minutes?.length == 60 ? '*' : minutes) ?? '*'}';
  }
}

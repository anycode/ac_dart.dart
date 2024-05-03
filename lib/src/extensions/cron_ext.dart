import 'package:cron/cron.dart';
import 'package:uuid/uuid.dart';

import '../logger/debug_logger.dart';

extension CronExt on Cron {
  static final logger = DebugLogger(
    name: 'cronjob',
    printer: DebugPrinter(prefix: Uuid().v1().toString().substring(0, 8)),
  );

  void logSchedule(Schedule schedule, Task task, [String taskName = 'unnamed']) {
    logger.i('Cron task $taskName scheduled to ${schedule.format()}');
    this.schedule(schedule, () {
      logger.i('Cron task $taskName scheduled to ${schedule.format()} started at ${DateTime.now()}');
      final result = task.call();
      if (result is Future) {
        result.then((value) {
          logger.i('Cron task $taskName scheduled to ${schedule.format()} finished at ${DateTime.now()} with result $value');
        });
      } else {
        logger.i('Cron task $taskName scheduled to ${schedule.format()} finished at ${DateTime.now()} with result $result');
      }
    });
  }
}

extension ScheduleExt on Schedule {
  String format() {
    return 'months: ${(months?.length == 12 ? '*' : months) ?? '*'}, '
        'weekdays: ${(weekdays?.length == 7 ? '*' : weekdays) ?? '*'}, '
        'days: ${(days?.length == 31 ? '*' : days) ?? '*'}, '
        'hours: ${(hours?.length == 24 ? '*' : hours) ?? '*'}, '
        'minutes: ${(minutes?.length == 60 ? '*' : minutes) ?? '*'}';
  }
}

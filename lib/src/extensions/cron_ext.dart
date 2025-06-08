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

import 'package:cron/cron.dart';

import '../logger/debug_logger.dart';

extension CronExt on Cron {

  /// Schedules a task and logs the start and end of execution. It's almost the same like [schedule] method,
  /// takes one extra argument to identify the task in logs.
  void logSchedule(Schedule schedule, Task task, {String taskName = 'unnamed', DebugLogger? logger}) {
    logger?.i('Cron task $taskName scheduled to ${schedule.format()}');
    this.schedule(schedule, () async {
      logger?.i('Cron task $taskName scheduled to ${schedule.format()} started at ${DateTime.now()}');
      try {
        final result = await task.call();
        if (result is Future) {
          result.then((value) {
            logger?.i('Cron task $taskName scheduled to ${schedule.format()} finished at ${DateTime.now()} with result $value');
          });
        } else {
          logger?.i('Cron task $taskName scheduled to ${schedule.format()} finished at ${DateTime.now()} with result $result');
        }
      } catch(e,st) {
        logger?.f('Cron task $taskName scheduled to ${schedule.format()} failed at ${DateTime.now()}', error: e, stackTrace: st);
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

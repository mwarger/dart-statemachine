// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library statemachine_test_jenkins;

import 'package:unittest/unittest.dart';
import 'statemachine_test.dart' as statemachine;

void main() {
  configure(new JenkinsConfiguration());
  statemachine.main();
}

class JenkinsConfiguration extends Configuration {

  void onInit() {
    print('<?xml version="1.0" encoding="UTF-8" ?>');
  }

  void onSummary(int passed, int failed, int errors, List<TestCase> results, String uncaughtError) {
    var totalTime = 0;
    for (var testcase in results) {
      totalTime += testcase.runningTime.inMilliseconds;
    }
    print('<testsuite name="All tests" tests="${results.length}" failures="$failed" errors="$errors" time="${totalTime / 1000.0}" timestamp="${new DateTime.now()}">');
    for (var testcase in results) {
      print('  <testcase id="${testcase.id}" name="${_xml(testcase.description)}" time="${testcase.runningTime.inMilliseconds / 1000.0}"> ');
      if (testcase.result == 'fail') {
        print('    <failure>${_xml(testcase.message)}</failure>');
      } else if (testcase.result == 'error') {
        print('    <error>${_xml(testcase.message)}</error>');
      }
      if (testcase.stackTrace != null && testcase.stackTrace != '') {
        print('    <system-err>${_xml(testcase.stackTrace)}</system-err>');
      }
      print('  </testcase>');
    }
    if (uncaughtError != null && uncaughtError != '') {
      print('  <system-err>${_xml(uncaughtError)}</system-err>');
    }
    print('</testsuite>');
  }

  void onDone(bool success) {
    // nothing to be done
  }

  String _xml(String string) {
    return string.replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }

}

import 'package:appium_driver/async_io.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

isPresent(SerializableFinder byValueKey, FlutterDriver driver,
    {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitFor(byValueKey, timeout: timeout);
    return true;
  } catch (exception) {
    return false;
  }
}

void main() {
  group('Covid Survey', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Empty Field', () async {
      final fnameText = find.byValueKey('fname');
      await driver.tap(fnameText); // acquire focus
      await driver.enterText(''); // enter text
      expect(await isPresent(find.byValueKey('submit'), driver), false);
    });

    test('Filled Field', () async {
      final fnameText = find.byValueKey('fname');
      final snameText = find.byValueKey('lname');

      await driver.tap(fnameText); // acquire focus
      await driver.enterText('Esra'); // enter text
      expect(await driver.getText(fnameText), "Esra");
      print('March 1 selected and tapped OK');

      await driver.tap(snameText); // acquire focus
      await driver.enterText('Nur'); // enter another piece of text
      expect(await driver.getText(snameText), "Nur");
      print('March 1 selected and tapped OK');

      final dateButton = find.byValueKey('dateField');
      await driver.tap(dateButton);
      await driver.tap(find.text('1'));
      await driver.tap(find.text('OK'));
      print('March 1 selected and tapped OK');

      final cityDropdown = find.byValueKey('cityDropdown');
      await driver.tap(cityDropdown);
      await driver.tap(find.text('Artvin'));

      final genderDropdown = find.byValueKey('genderDropdown');
      await driver.tap(genderDropdown);
      await driver.tap(find.text('Female'));

      final vaccineDropdown = find.byValueKey('vaccineDropdown');
      await driver.tap(vaccineDropdown);
      await driver.tap(find.text('Moderna'));

      final sideEffects = find.byValueKey('sideEffects');
      await driver.tap(sideEffects); // acquire focus
      await driver.enterText('Side Effecte tikladim'); // enter text

      expect(await isPresent(find.byValueKey('submit'), driver), true);

      final submit = find.byValueKey('submit');
      await driver.tap(submit); // acquire focus
    });
  });
}

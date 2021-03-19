# Covid Survey Form Verification

--> The project consists of the covid_survey folder which contains the whole Flutter project.<br />
--> The covid_survey folder contains the appium folder which has the JS based Appium test script.<br />

## Requirements for running the Flutter application:
--> Ensure that Flutter 1.22.6 is installed<br />
--> Execute `cd covid_survey` in the terminal<br />
--> Execute `flutter pub get` to get the packages in the terminal<br />
--> Execute `flutter run` in the covid  in the terminal<br />
--> NOTE: If using VS code for flutter then run `Run > Start without Debugging`<br />

## Requirements for running the test script:
--> Ensure that npm is installed<br />
--> `cd covid_survey` then `cd appium`
--> Execute `npm install`, `npm install -g appium`<br />
--> Verify appium installation: `npm install -g appium-doctor` followed by `appium-doctor --android` or `appium-doctor --ios`<br />
--> Execute `npm i -g appium-flutter-driver` <br />
-- Run the appium server `appium` <br />
--> Execute the test script `APPIUM_OS=android npm start` or `APPIUM_OS=ios npm start` in a separate terminal<br />
--> View the results in the logs.txt file<br />
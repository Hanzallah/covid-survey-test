const wdio = require('webdriverio');
const assert = require('assert');
const fs = require('fs');
const find = require('appium-flutter-finder');

function logger(testName, messages){
  fs.appendFileSync('logs.txt', "------------------------------------------------------\n>> " + testName + "\n");

  for (var e in messages){
    fs.appendFileSync('logs.txt', "-- "+ messages[e] +"\n");
  }
}

const osSpecificOps = process.env.APPIUM_OS === 'android' ? {
  platformName: 'Android',
  deviceName: 'SM A705FN',
  app: __dirname +  '/../build/app/outputs/apk/debug/app-debug.apk',
}: process.env.APPIUM_OS === 'ios' ? {
  platformName: 'iOS',
  platformVersion: '12.2',
  deviceName: 'iPhone X',
  noReset: true,
  app: __dirname +  '/../ios/Runner.zip',

} : {};

const opts = {
  port: 4723,
  capabilities: {
    ...osSpecificOps,
    automationName: 'Flutter'
  }
};

(async () => {
  console.log('Initial app testing')
  const driver = await wdio.remote(opts);
  assert.strictEqual(await driver.execute('flutter:checkHealth'), 'ok');
  await driver.execute('flutter:clearTimeline');
  await driver.execute('flutter:forceGC');

  // empty fields test /////////////////////////////////////////////////////////
  var logs = [];
  await driver.elementSendKeys(find.byValueKey('fname'), '');
  await driver.elementSendKeys(find.byValueKey('lname'), '');
  await driver.elementClick(find.byValueKey('cityDropdown'));
  await driver.elementClick(find.byText('Artvin'));
  try {
    // send button
    await driver.execute('flutter:waitFor', find.byValueKey('submit'), {});
    await driver.elementClick(find.byValueKey('submit'));
    logs.push("Send button was clicked");
    logs.push("TEST FAILED");
  }
  catch(err) {
    logs.push("Send button did not appear");
    logs.push("TEST PASSED");
  }

  logger('Empty fields test', logs);

  // Incorrect fields test /////////////////////////////////////////////////////////
  var logs = [];
  await driver.elementSendKeys(find.byValueKey('fname'), '172hhh');
  await driver.elementSendKeys(find.byValueKey('lname'), 'bf29ff$');

  try {
    // send button
    await driver.execute('flutter:waitFor', find.byValueKey('submit'), {});
    await driver.elementClick(find.byValueKey('submit'));
    logs.push("Send button was clicked");
    logs.push("TEST FAILED");
  }
  catch(err) {
    logs.push("Send button did not appear");
    logs.push("TEST PASSED");
  }

  logger('Incorrect fields test', logs);

  // Incorrect birth date test /////////////////////////////////////////////////////////
  var logs = [];
  await driver.elementClick(find.byValueKey('dateField'));
  var today = new Date();
  await driver.elementClick(find.byText(String(today.getDate()+1)));
  await driver.elementClick(find.byText('OK'));
  var today = new Date();
  
  try {
    // send button
    await driver.execute('flutter:waitFor', find.byValueKey('submit'), {});
    await driver.elementClick(find.byValueKey('submit'));
    logs.push("Send button was clicked");
    logs.push("TEST FAILED");
  }
  catch(err) {
    logs.push("Send button did not appear");
    logs.push("TEST PASSED");
  }

  logger('Incorrect birth date test', logs);


  // Successful submit test /////////////////////////////////////////////////////////
  var logs = [];
  // Clear and enter correct names
  await driver.elementClear(find.byValueKey('fname'));
  await driver.elementClear(find.byValueKey('lname'));
  await driver.elementSendKeys(find.byValueKey('fname'), 'John');
  await driver.elementSendKeys(find.byValueKey('lname'), 'Doe');

  // Choose day
  await driver.elementClick(find.byValueKey('dateField'));
  var today = new Date();
  await driver.elementClick(find.byText(String(today.getDate())));
  await driver.elementClick(find.byText('OK'));

  // Choose city
  await driver.elementClick(find.byValueKey('cityDropdown'));
  await driver.elementClick(find.byText('Artvin'));

  // Choose gender
  await driver.elementClick(find.byValueKey('genderDropdown'));
  await driver.elementClick(find.byText('Male'));

  // Choose vaccine
  await driver.elementClick(find.byValueKey('vaccineDropdown'));
  await driver.elementClick(find.byText('Moderna'));

  // Enter side effects
  await driver.elementClear(find.byValueKey('sideEffects'));
  await driver.elementSendKeys(find.byValueKey('sideEffects'), 'Not Applicable');

  // Submit
  try {
    // send button
    await driver.execute('flutter:waitFor', find.byValueKey('submit'));
    await driver.elementClick(find.byValueKey('submit'));
    logs.push("Send button was clicked");
    logs.push("TEST PASSED");
  }
  catch(err) {
    logs.push("Send button did not appear");
    logs.push("TEST FAILED");
  }

  logger('Successful submission test', logs);


  // Switch context /////////////////////////////////////////////////////////
  var logs = [];
  await driver.elementClear(find.byValueKey('fname'));
  await driver.elementClear(find.byValueKey('lname'));
  await driver.elementSendKeys(find.byValueKey('fname'), 'Jane');
  await driver.elementSendKeys(find.byValueKey('lname'), 'Maybe');

  await driver.switchContext('NATIVE_APP');
  await driver.background(0.7);
  await driver.switchContext('FLUTTER');

  try{
    assert.strictEqual(await driver.getElementText(find.byValueKey('fname')), 'Jane');
    assert.strictEqual(await driver.getElementText(find.byValueKey('lname')), 'Maybe');
    logs.push("Context Switched and text remained in fields");
    logs.push("TEST PASSED");
  }
  catch(err) {
    logs.push("Context switch did not work and text fields changed");
    logs.push("TEST FAILED");
  }

  logger('Context switch test', logs);

  // Orientation test /////////////////////////////////////////////////////////
  var logs = [];
  await driver.elementClick(find.byValueKey('orientation'));
  // Clear and enter correct names
  await driver.elementClear(find.byValueKey('fname'));
  await driver.elementClear(find.byValueKey('lname'));
  await driver.elementSendKeys(find.byValueKey('fname'), 'John');
  await driver.elementSendKeys(find.byValueKey('lname'), 'Doe');

  await driver.execute('flutter:scrollIntoView',find.byValueKey('dateField'), {alignment: 0.1})

  // Choose day
  await driver.elementClick(find.byValueKey('dateField'));
  var today = new Date();
  await driver.elementClick(find.byText(String(today.getDate())));
  await driver.elementClick(find.byText('OK'));

  await driver.execute('flutter:scrollIntoView',find.byValueKey('cityDropdown'), {alignment: 0.1})  

  // Choose city
  await driver.elementClick(find.byValueKey('cityDropdown'));
  await driver.elementClick(find.byText('Adana'));

  await driver.execute('flutter:scrollIntoView',find.byValueKey('genderDropdown'), {alignment: 0.1})  

  // Choose gender
  await driver.elementClick(find.byValueKey('genderDropdown'));
  await driver.elementClick(find.byText('Male'));

  await driver.execute('flutter:scrollIntoView',find.byValueKey('vaccineDropdown'), {alignment: 0.1})  

  // Choose vaccine
  await driver.elementClick(find.byValueKey('vaccineDropdown'));
  await driver.elementClick(find.byText('Moderna'));

  await driver.execute('flutter:scrollIntoView',find.byValueKey('sideEffects'), {alignment: 0.1})  

  // Enter side effects
  await driver.elementClear(find.byValueKey('sideEffects'));
  await driver.elementSendKeys(find.byValueKey('sideEffects'), 'Not Applicable');

  await driver.execute('flutter:scrollIntoView',find.byValueKey('submit'), {alignment: 0.1})  

  await driver.elementClick(find.byValueKey('orientation'));

  // Submit
  try {
    // send button
    await driver.execute('flutter:waitFor', find.byValueKey('submit'));
    await driver.elementClick(find.byValueKey('submit'));
    logs.push("Send button was clicked with changed orientation");
    logs.push("TEST PASSED");
  }
  catch(err) {
    logs.push("Send button did not appear with changed orientation");
    logs.push("TEST FAILED");
  }

  logger('Orientation change', logs);


  driver.deleteSession();
})();

//   //Enter login page
//   await driver.execute('flutter:waitFor', find.byValueKey('loginBtn'));
//   await driver.elementSendKeys(find.byValueKey('emailTxt'), 'test@gmail.com')
//   await driver.elementSendKeys(find.byValueKey('passwordTxt'), '123456')
//   await driver.elementClick(find.byValueKey('loginBtn'));

//   //Enter home page
//   await driver.execute('flutter:waitFor', find.byValueKey('homeGreetingLbl'));
//   assert.strictEqual(await driver.getElementText(find.byValueKey('homeGreetingLbl')), 'Welcome to Home Page');

//   //Enter Page1
//   await driver.elementClick(find.byValueKey('page1Btn'));
//   await driver.execute('flutter:waitFor', find.byValueKey('page1GreetingLbl'));
//   assert.strictEqual(await driver.getElementText(find.byValueKey('page1GreetingLbl')), 'Page1');
//   await driver.elementClick(find.byValueKey('page1BackBtn'));

//   //Enter Page2
//   await driver.elementClick(find.byValueKey('page2Btn'));
//   await driver.execute('flutter:waitFor', find.byValueKey('page2GreetingLbl'));
//   assert.strictEqual(await driver.getElementText(find.byValueKey('page2GreetingLbl')), 'Page2');
//   await driver.switchContext('NATIVE_APP');
//   await driver.back();
//   await driver.switchContext('FLUTTER');

//   //Logout application
//   await driver.elementClick(find.byValueKey('logoutBtn'));
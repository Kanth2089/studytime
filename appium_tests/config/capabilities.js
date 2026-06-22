exports.androidCaps = {
    platformName: 'Android',
    'appium:deviceName': 'Android Emulator',
    'appium:automationName': 'UiAutomator2',
    'appium:app': './android/app/build/outputs/apk/debug/app-debug.apk', // Path to Flutter/Android APK
    'appium:appPackage': 'com.example.studyt',
    'appium:appActivity': 'com.example.studyt.MainActivity',
    'appium:autoGrantPermissions': true
};

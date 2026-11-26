import os
import pathlib
import re

manifest = pathlib.Path('android/app/src/main/AndroidManifest.xml')
text = manifest.read_text()
if 'permission.CAMERA' not in text:
    text = text.replace(
        '</manifest>',
        '    <uses-permission android:name="android.permission.CAMERA" />\\n</manifest>'
    )
    manifest.write_text(text)
print('manifest OK')

# Use the GitHub Actions run number so each generated APK can update an
# already-installed version instead of being rejected as the same versionCode.
gradle = pathlib.Path('android/app/build.gradle')
if gradle.exists():
    run_number = max(2, int(os.environ.get('GITHUB_RUN_NUMBER', '2')))
    gradle_text = gradle.read_text()
    updated, count = re.subn(r'(?m)(\\bversionCode\\s+)\\d+', rf'\\g<1>{run_number}', gradle_text, count=1)
    if count:
        gradle.write_text(updated)
        print(f'versionCode set to {run_number}')
    else:
        print('versionCode declaration not found; leaving Gradle file unchanged')

import pathlib
p = pathlib.Path('android/app/src/main/AndroidManifest.xml')
t = p.read_text()
if 'permission.CAMERA' not in t:
    t = t.replace('</manifest>', '    <uses-permission android:name="android.permission.CAMERA" />\n</manifest>')
    p.write_text(t)
print('manifest OK')

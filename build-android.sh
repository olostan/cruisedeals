flutter build apk --release
cd build
rm app-rel.apk
# zipalign -v -p 4 app.apk app-rel.apk
 /usr/local/opt/android-sdk/build-tools/25.0.1/apksigner sign --ks ../my-release-key.jks app-rel.apk

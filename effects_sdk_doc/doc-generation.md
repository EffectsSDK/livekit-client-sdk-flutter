# Generate doc

For Windows: enable developer mode [activate-developer-mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development#activate-developer-mode)  
   
Enable git symlinks
```cmd
git config --global core.symlinks true
```

Enable git symlinks locally if the repo is cloned already
```cmd
git config --local core.symlinks true
```

Export individual types that required documentation in the separated [livekit_client.dart](lib/livekit_client.dart).
If there is new types, add them into [livekit_client.dart](lib/livekit_client.dart).

Doc generation:
```cmd
cd effects_sdk_doc
dart pub get
dart doc --validate-links .
```

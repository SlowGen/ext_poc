{{flutter_js}}
{{flutter_build_config}}

// the below loader ensures that the local copy of canvasKit is used
// and there is no attempt to download it. Attempting to download it
// will cause the extension to fail as remote resources are blocked

_flutter.loader.load({
    config: {
        canvasKitBaseUrl: "canvaskit/"
    },
});

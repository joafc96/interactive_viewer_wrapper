# interactive_viewer_wrapper

A widget based on Flutter's Interactive Viewer that helps widgets pinch zoom, double tap zoom, and return to its initial size when required.
This package is based on the recent Interactive Viewer that Flutter introduced since version 1.20.
The package is designed for zooming in on any widgets.

## Installation

Add this to your `pubspec.yaml` dependencies:

```
interactive_viewer_wrapper: ^0.0.1
```

## How to use

Add the widget to your app like this (It automatically takes the size of the image you pass to it):

```dart
InteractiveViewerWrapper(
          onScaleChanged: (scale) {},
          child: childWidget,
        ),
```
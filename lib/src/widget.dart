import 'package:flutter/material.dart';

class InteractiveViewerWrapper extends StatefulWidget {
  static const Duration defaultScaleDuration = Duration(milliseconds: 600);

  /// [child] The child to be displayed
  final Widget child;

  /// [minScale] Minimum scale factor
  final double minScale;

  /// [maxScale] Maximum scale factor
  final double maxScale;

  /// [scaleDuration] The duration of the scale animation
  final Duration scaleDuration;

  /// [curve] The curve of the scale animation
  final Curve curve;

  /// [onScaleChanged] Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(double)? onScaleChanged;

  const InteractiveViewerWrapper({
    super.key,
    required this.child,
    this.minScale = 1.0,
    this.maxScale = 2.5,
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.scaleDuration = defaultScaleDuration,
    this.onScaleChanged,
  });

  @override
  State<InteractiveViewerWrapper> createState() =>
      _InteractiveViewerWrapperState();
}

class _InteractiveViewerWrapperState extends State<InteractiveViewerWrapper>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;

  double get _scale => _transformationController.value.getMaxScaleOnAxis();

 // Animation controller for the double tap gesture (Interactive viewer handles the rest scale and pan animation)
  late final AnimationController _animationController;

  // Zoom animation tween which is a MAtrix4
  Animation<Matrix4>? _zoomAnimation;

  // Tap down details
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    _transformationController = TransformationController();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    )..addListener(() {
        _transformationController.value = _zoomAnimation!.value;
      });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    // Check if transformation controller value transformation is identity or not.
    // If it is identity perform calculation for zoom,
    // Else perform calculation to reset the zoom back to identity.
    final newValue = _transformationController.value.isIdentity()
        ? _applyZoom()
        : _revertZoom();

    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: newValue,
    ).animate(
      CurveTween(curve: widget.curve).animate(_animationController),
    );

    // Forward the animation controller and then call the onChanged callback.
    _animationController.forward(from: 0).then((value) {
      widget.onScaleChanged?.call(_scale);
    });
  }

// Returns the transformed (zoomed) version of widget
  Matrix4 _applyZoom() {
    final tapPosition = _doubleTapDetails!.localPosition;
    final translationCorrection = widget.maxScale - 1;
    final zoomed = Matrix4.identity()
      ..translate(
        -tapPosition.dx * translationCorrection,
        -tapPosition.dy * translationCorrection,
      )
      ..scale(widget.maxScale);
    return zoomed;
  }

// Returns the identity matrix i.e the untransformed widget itself.
  Matrix4 _revertZoom() => Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: widget.child,
          onInteractionEnd: (scaleEndDetails) {
            widget.onScaleChanged?.call(_scale);
          },
        ),
      ),
    );
  }
}

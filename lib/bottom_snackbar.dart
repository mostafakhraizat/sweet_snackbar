import 'package:flutter/material.dart';
import 'package:sweet_snackbar/top_bounce.dart';

OverlayEntry? _previousEntry;

/// Displays a widget that will be passed to [child] parameter above the current
/// contents of the app, with transition animation
///
/// The [child] argument is used to pass widget that you want to show
///
/// The [showOutAnimationDuration] argument is used to specify duration of
/// enter transition
///
/// The [hideOutAnimationDuration] argument is used to specify duration of
/// exit transition
///
/// The [displayDuration] argument is used to specify duration displaying
///
/// The [additionalBottomPadding] argument is used to specify amount of top
/// padding that will be added for SafeArea values
///
/// The [onTap] callback of [BottomSnackBar]
///
/// The [overlayState] argument is used to add specific overlay state.
/// If you will not pass it, it will try to get the current overlay state from
/// passed [BuildContext]
void showBottomSnackBar(
    BuildContext context,
    Widget child, {
      Duration showOutAnimationDuration = const Duration(milliseconds: 300),
      Duration hideOutAnimationDuration = const Duration(milliseconds: 200),
      Duration displayDuration = const Duration(milliseconds: 2000),
      double additionalBottomPadding = 16.0,
      VoidCallback? onTap,
      OverlayState? overlayState,
      double leftPadding = 16,
      double rightPadding = 16,
    }) async {
  overlayState ??= Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return BottomSnackBar(
        child: child,
        onDismissed: () {
          overlayEntry.remove();
          _previousEntry = null;
        },
        showOutAnimationDuration: showOutAnimationDuration,
        hideOutAnimationDuration: hideOutAnimationDuration,
        displayDuration: displayDuration,
        additionalBottomPadding: additionalBottomPadding,
        onTap: onTap,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
      );
    },
  );

  _previousEntry?.remove();
  overlayState?.insert(overlayEntry);
  _previousEntry = overlayEntry;
}

/// Widget that controls all animations
class BottomSnackBar extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;
  final showOutAnimationDuration;
  final hideOutAnimationDuration;
  final displayDuration;
  final additionalBottomPadding;
  final VoidCallback? onTap;
  final double leftPadding;
  final double rightPadding;

  BottomSnackBar({
    Key? key,
    required this.child,
    required this.onDismissed,
    required this.showOutAnimationDuration,
    required this.hideOutAnimationDuration,
    required this.displayDuration,
    required this.additionalBottomPadding,
    this.onTap,
    this.leftPadding = 16,
    this.rightPadding = 16,
  }) : super(key: key);

  @override
  _BottomSnackBarState createState() => _BottomSnackBarState();
}

class _BottomSnackBarState extends State<BottomSnackBar>
    with SingleTickerProviderStateMixin {
  late Animation offsetAnimation;
  late AnimationController animationController;
  double? topPosition;

  @override
  void initState() {
    topPosition = widget.additionalBottomPadding;
    _setupAndStartAnimation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(0, 1.0),
      end: Offset(0.0, 0.0),
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
        reverseCurve: Curves.linearToEaseOut,
      ),
    )..addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(widget.displayDuration);
        if (mounted) {
          animationController.reverse();
          setState(() {
            topPosition = 0;
          });
        }
      }

      if (status == AnimationStatus.dismissed) {
        widget.onDismissed.call();
      }
    });

    if (mounted) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.hideOutAnimationDuration * 1.5,
      curve: Curves.ease,
      bottom: topPosition,
      left: widget.leftPadding,
      right: widget.rightPadding,
      child: SlideTransition(
        position: offsetAnimation as Animation<Offset>,
        child: SafeArea(
          child: TapBounceContainer(
            onTap: () {
              if (mounted) {
                widget.onTap?.call();
                animationController.reverse();
              }
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
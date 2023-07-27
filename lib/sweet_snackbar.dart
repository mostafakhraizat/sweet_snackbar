library sweet_snackbar;

import 'dart:math';

import 'package:flutter/material.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;
  final Widget icon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final int iconRotationAngle;
  final List<BoxShadow> boxShadow;
  final BorderRadius borderRadius;
  final double iconPositionTop;
  final double iconPositionLeft;
  final EdgeInsetsGeometry messagePadding;
  final double textScaleFactor;
  final double? closeIconLeftPadding;
  final Widget? closeIcon;

  const CustomSnackBar.success({
    Key? key,
    required this.message,
    required this.borderRadius,
    required this.boxShadow,
    this.closeIcon,
    this.closeIconLeftPadding,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.check_circle,
      color: Colors.white,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 0,
    this.iconPositionTop = -0,
    this.iconPositionLeft = -0,
    this.backgroundColor = const Color(0xff00E676),
    this.textScaleFactor = 1.0,
  });
    CustomSnackBar.normal({
    Key? key,
    required this.message,
    this.closeIcon,
    this.closeIconLeftPadding,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 0),
    this.icon = const Icon(
      Icons.info_outline,
      size: 20,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 0,
    this.iconPositionTop = -0,
    this.iconPositionLeft = -0,
    this.backgroundColor = Colors.grey,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  const CustomSnackBar.info({
    Key? key,
    required this.message,
    this.closeIcon,
    this.closeIconLeftPadding,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.info_outline,
      color: Colors.white,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 0,
    this.iconPositionTop = -0,
    this.iconPositionLeft = -0,
    this.backgroundColor = const Color(0xff2196F3),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  const CustomSnackBar.error({
    Key? key,
    required this.message,
    this.closeIcon,
    this.closeIconLeftPadding,

    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.warning,
      color: Colors.white,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 0,
    this.iconPositionTop = -0,
    this.iconPositionLeft = -0,
    this.backgroundColor = const Color(0xffff5252),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 52,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: widget.boxShadow,
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: widget.iconPositionTop,
            left: widget.iconPositionLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              height: 55,
              child: Transform.rotate(
                angle: widget.iconRotationAngle * pi / 180,
                child: widget.icon,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: widget.messagePadding,
              child: Text(
                widget.message,
                style: theme.textTheme.bodyText2?.merge(
                  widget.textStyle,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textScaleFactor: widget.textScaleFactor,
              ),
            ),
          ),

          Positioned(
              right: widget.closeIconLeftPadding??22,
              child: widget.closeIcon??Icon(Icons.close,))

        ],
      ),
    );
  }
}

const kDefaultBoxShadow = const [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0.0, 8.0),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

const kDefaultBorderRadius = const BorderRadius.all(Radius.circular(12));
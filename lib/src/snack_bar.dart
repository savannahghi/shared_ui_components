import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';

import 'package:shared_ui_components/src/constants.dart';
import 'package:shared_ui_components/src/snack_bar_action.dart';

/// PLEASE DON'T DELETE. A BETTER IMPLEMENTATION WILL BE INTRODUCED BASED ON THIS FILE.

// ignore: todo
// TODO(vincent): We should check if the given text and actions are going to fit on
// one line or not, and if they are, use the single-line layout, and if not, use
// the multi-line layout, https://github.com/flutter/flutter/issues/32782
// See https://material.io/components/snackbars#specs, 'Longer Action Text' does
// not match spec.

/// A lightweight message with an optional action which briefly displays at the
/// bottom of the screen.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=zpO6n_oZWw0}
///
/// To display a snack bar, call `Scaffold.of(context).showSnackBar()`, passing
/// an instance of [SnackBar] that describes the message.
///
/// To control how long the [SnackBar] remains visible, specify a [duration].
///
/// A SnackBar with an action will not time out when TalkBack or VoiceOver are
/// enabled. This is controlled by [AccessibilityFeatures.accessibleNavigation].
///

// ignore: avoid_implementing_value_types
class SILSnackBar extends StatefulWidget implements SnackBar {
  /// Creates a snack bar.
  ///
  /// The [content] argument must be non-null. The [elevation] must be null or
  /// non-negative.
  const SILSnackBar({
    Key? key,
    required this.content,
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.padding,
    this.width,
    this.shape,
    this.behavior,
    this.action,
    this.onAction,
    this.title,
    required this.type,
    this.duration = snackBarDisplayDuration,
    this.animation,
    this.onVisible,
  })  : assert(elevation == null || elevation >= 0.0),
        assert(
          margin == null || behavior == SnackBarBehavior.floating,
          'Margin can only be used with floating behavior',
        ),
        assert(
          width == null || behavior == SnackBarBehavior.floating,
          'Width can only be used with floating behavior',
        ),
        assert(
          width == null || margin == null,
          'Width and margin can not be used together',
        ),
        super(key: key);

  /// snackbar title
  final String? title;

  /// The primary content of the snack bar.
  ///
  /// Typically a [Text] widget.
  @override
  final Widget content;

  /// snackbar type
  final SnackBarType type;

  /// The snack bar's background color. If not specified it will use
  /// [SnackBarThemeData.backgroundColor] of [ThemeData.snackBarTheme]. If that
  /// is not specified it will default to a dark variation of
  /// [ColorScheme.surface] for light themes, or [ColorScheme.onSurface] for
  /// dark themes.
  @override
  final Color? backgroundColor;

  /// The z-coordinate at which to place the snack bar. This controls the size
  /// of the shadow below the snack bar.
  ///
  /// Defines the card's [Material.elevation].
  ///
  /// If this property is null, then [SnackBarThemeData.elevation] of
  /// [ThemeData.snackBarTheme] is used, if that is also null, the default value
  /// is 6.0.
  @override
  final double? elevation;

  /// Empty space to surround the snack bar.
  ///
  /// This property is only used when [behavior] is [SnackBarBehavior.floating].
  /// It can not be used if [width] is specified.
  ///
  /// If this property is null, then the default is
  /// `EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0)`.
  @override
  final EdgeInsetsGeometry? margin;

  /// The amount of padding to apply to the snack bar's content and optional
  /// action.
  ///
  /// If this property is null, then the default depends on the [behavior] and
  /// the presence of an [action]. The start padding is 24 if [behavior] is
  /// [SnackBarBehavior.fixed] and 16 if it is [SnackBarBehavior.floating]. If
  /// there is no [action], the same padding is added to the end.
  @override
  final EdgeInsetsGeometry? padding;

  /// The width of the snack bar.
  ///
  /// If width is specified, the snack bar will be centered horizontally in the
  /// available space. This property is only used when [behavior] is
  /// [SnackBarBehavior.floating]. It can not be used if [margin] is specified.
  ///
  /// If this property is null, then the snack bar will take up the full device
  /// width less the margin.
  @override
  final double? width;

  /// The shape of the snack bar's [Material].
  ///
  /// Defines the snack bar's [Material.shape].
  ///
  /// If this property is null then [SnackBarThemeData.shape] of
  /// [ThemeData.snackBarTheme] is used. If that's null then the shape will
  /// depend on the [SnackBarBehavior]. For [SnackBarBehavior.fixed], no
  /// overriding shape is specified, so the [SnackBar] is rectangular. For
  /// [SnackBarBehavior.floating], it uses a [RoundedRectangleBorder] with a
  /// circular corner radius of 4.0.
  @override
  final ShapeBorder? shape;

  /// This defines the behavior and location of the snack bar.
  ///
  /// Defines where a [SnackBar] should appear within a [Scaffold] and how its
  /// location should be adjusted when the scaffold also includes a
  /// [FloatingActionButton] or a [BottomNavigationBar]
  ///
  /// If this property is null, then [SnackBarThemeData.behavior] of
  /// [ThemeData.snackBarTheme] is used. If that is null, then the default is
  /// [SnackBarBehavior.fixed].
  @override
  final SnackBarBehavior? behavior;

  /// (optional) An action that the user can take based on the snack bar.
  ///
  /// For example, the snack bar might let the user undo the operation that
  /// prompted the snackbar. Snack bars can have at most one action.
  ///
  /// The action should not be "dismiss" or "cancel".
  @override
  final SnackBarAction? action;

  final SILSnackBarAction? onAction;

  /// The amount of time the snack bar should be displayed.
  ///
  /// Defaults to 4.0s.  ///

  @override
  final Duration duration;

  /// The animation driving the entrance and exit of the snack bar.
  @override
  final Animation<double>? animation;

  /// Called the first time that the snackbar is visible within a [Scaffold].
  @override
  final VoidCallback? onVisible;

  // API for Scaffold.showSnackBar():

  /// Creates an animation controller useful for driving a snack bar's entrance and exit animation.
  static AnimationController createAnimationController(
      {required TickerProvider vsync}) {
    return AnimationController(
      duration: snackBarTransitionDuration,
      debugLabel: 'SnackBar',
      vsync: vsync,
    );
  }

  /// Creates a copy of this snack bar but with the animation replaced with the given animation.
  ///
  /// If the original snack bar lacks a key, the newly created snack bar will
  /// use the given fallback key.
  @override
  SILSnackBar withAnimation(Animation<double> newAnimation,
      {Key? fallbackKey}) {
    return SILSnackBar(
      key: key ?? fallbackKey,
      content: content,
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      behavior: behavior,
      type: type,
      action: action,
      onAction: onAction,
      duration: duration,
      animation: newAnimation,
      onVisible: onVisible,
    );
  }

  @override
  State<SILSnackBar> createState() => _SILSnackBarState();

  @override
  // TODO: implement dismissDirection
  DismissDirection get dismissDirection => throw UnimplementedError();
}

class _SILSnackBarState extends State<SILSnackBar> {
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    widget.animation!.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void didUpdateWidget(SILSnackBar oldWidget) {
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation!.removeStatusListener(_onAnimationStatusChanged);
      widget.animation!.addStatusListener(_onAnimationStatusChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation!.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.dismissed:
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        if (widget.onVisible != null && !_wasVisible) {
          widget.onVisible!();
        }
        _wasVisible = true;
    }
  }

  Map<String, dynamic> _snackBarMetaData() {
    final bool hasTitle = widget.title != null;
    switch (widget.type) {
      case SnackBarType.success:
        return <String, dynamic>{
          'icon': MdiIcons.checkCircleOutline,
          'title': hasTitle ? widget.title : 'Success',
          'color': const Color(0xff58b395),
        };
      case SnackBarType.danger:
        return <String, dynamic>{
          'icon': Icons.warning_amber_outlined,
          'title': hasTitle ? widget.title : 'Error!',
          'color': Colors.red,
        };
      case SnackBarType.warning:
        return <String, dynamic>{
          'icon': Icons.error_outline,
          'title': hasTitle ? widget.title : 'Warning',
          'color': Colors.orange[600]
        };
      default:
        return <String, dynamic>{
          'icon': MdiIcons.informationOutline,
          'title': hasTitle ? widget.title : 'Info',
          'color': Colors.blue[800]
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    assert(widget.animation != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final SnackBarThemeData snackBarTheme = theme.snackBarTheme;
    final bool isThemeDark = theme.brightness == Brightness.dark;

    // SnackBar uses a theme that is the opposite brightness from
    // the surrounding theme.
    final Brightness brightness =
        isThemeDark ? Brightness.light : Brightness.dark;
    final Color themeBackgroundColor = isThemeDark
        ? colorScheme.onSurface
        : Color.alphaBlend(
            colorScheme.onSurface.withOpacity(0.80), colorScheme.surface);
    final ThemeData inverseTheme = ThemeData(
      brightness: brightness,
      backgroundColor: themeBackgroundColor,
      colorScheme: ColorScheme(
        primary: colorScheme.onPrimary,
        primaryVariant: colorScheme.onPrimary,
        // For the button color, the spec says it should be primaryVariant, but for
        // backward compatibility on light themes we are leaving it as secondary.
        secondary:
            isThemeDark ? colorScheme.primaryVariant : colorScheme.secondary,
        secondaryVariant: colorScheme.onSecondary,
        surface: colorScheme.onSurface,
        background: themeBackgroundColor,
        error: colorScheme.onError,
        onPrimary: colorScheme.primary,
        onSecondary: colorScheme.secondary,
        onSurface: colorScheme.surface,
        onBackground: colorScheme.background,
        onError: colorScheme.error,
        brightness: brightness,
      ),
      snackBarTheme: snackBarTheme,
    );

    final TextStyle contentTextStyle =
        (snackBarTheme.contentTextStyle ?? inverseTheme.textTheme.subtitle1)!;
    final SnackBarBehavior snackBarBehavior =
        widget.behavior ?? snackBarTheme.behavior ?? SnackBarBehavior.fixed;
    final bool isFloatingSnackBar =
        snackBarBehavior == SnackBarBehavior.floating;
    final double horizontalPadding = isFloatingSnackBar ? 16.0 : 24.0;

    final CurvedAnimation heightAnimation =
        CurvedAnimation(parent: widget.animation!, curve: snackBarHeightCurve);

    final CurvedAnimation fadeInAnimation =
        CurvedAnimation(parent: widget.animation!, curve: snackBarFadeInCurve);

    final CurvedAnimation fadeOutAnimation = CurvedAnimation(
      parent: widget.animation!,
      curve: snackBarFadeOutCurve,
      reverseCurve: const Threshold(0.0),
    );

    final Map<String, dynamic> snackBarMetaData = _snackBarMetaData();

    final Color backgroundColor = snackBarMetaData['color'] as Color;

    /// holds snackbar title, icon and action button
    ///
    final Widget snackBarHeader = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(snackBarMetaData['icon'] as IconData),
              size15HorizontalSizedBox,
              DefaultTextStyle(
                style: contentTextStyle,
                child: Text(
                  snackBarMetaData['title'] as String,
                  style: TextThemes.heavySize18Text(),
                ),
              ),
            ],
          ),

          /// action button
          /// should not be used to cancel or dismiss the snackbar
          if (widget.onAction != null)
            ButtonTheme(
              textTheme: ButtonTextTheme.accent,
              minWidth: 64.0,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: widget.onAction!,
            ),
        ],
      ),
    );

    Widget snackBar = Container(
      constraints: const BoxConstraints(
        maxHeight: 120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          snackBarHeader,
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.95),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: DefaultTextStyle(
              style: contentTextStyle,
              child: widget.content,
            ),
          ),
        ],
      ),
    );

    if (!isFloatingSnackBar) {
      snackBar = SafeArea(
        top: false,
        child: snackBar,
      );
    }

    final ShapeBorder shape = (widget.shape ??
        snackBarTheme.shape ??
        (isFloatingSnackBar
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
            : null))!;

    snackBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        shape: shape,
        color: Colors.transparent,
        child: Theme(
          data: inverseTheme,
          child: mediaQueryData.accessibleNavigation
              ? snackBar
              : FadeTransition(
                  opacity: fadeOutAnimation,
                  child: snackBar,
                ),
        ),
      ),
    );

    if (isFloatingSnackBar) {
      const double topMargin = 5.0;
      const double bottomMargin = 10.0;
      // If width is provided, do not include horizontal margins.
      if (widget.width != null) {
        snackBar = Container(
          margin: const EdgeInsets.only(top: topMargin, bottom: bottomMargin),
          width: widget.width,
          child: snackBar,
        );
      } else {
        const double horizontalMargin = 15.0;
        snackBar = Padding(
          padding: widget.margin ??
              const EdgeInsets.fromLTRB(
                horizontalMargin,
                topMargin,
                horizontalMargin,
                bottomMargin,
              ),
          child: snackBar,
        );
      }
      snackBar = SafeArea(
        top: false,
        bottom: false,
        child: snackBar,
      );
    }

    snackBar = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        ScaffoldMessenger.of(context)
            .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      },
      child: Dismissible(
        key: const Key('dismissible'),
        direction: DismissDirection.down,
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          ScaffoldMessenger.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        },
        child: snackBar,
      ),
    );

    Widget snackBarTransition;
    if (mediaQueryData.accessibleNavigation) {
      snackBarTransition = snackBar;
    } else if (isFloatingSnackBar) {
      snackBarTransition = FadeTransition(
        opacity: fadeInAnimation,
        child: snackBar,
      );
    } else {
      snackBarTransition = AnimatedBuilder(
        animation: heightAnimation,
        builder: (BuildContext context, Widget? child) {
          return Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: heightAnimation.value,
            child: child,
          );
        },
        child: snackBar,
      );
    }

    return ClipRect(child: snackBarTransition);
  }
}

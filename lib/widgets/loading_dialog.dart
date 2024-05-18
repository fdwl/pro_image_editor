import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../utils/theme_functions.dart';
import 'platform_circular_progress_indicator.dart';

class LoadingDialog {
  String _msg = '';
  dynamic state;

  bool _isVisible = false;
  bool _isDisposed = false;

  set msg(String message) {
    _msg = message;
    if (state != null) {
      state(() {});
    }
  }

  /// Displays a loading dialog in the given [context].
  ///
  /// - `message` is an optional parameter to customize the loading message.
  /// - `isDismissible` determines if the dialog can be dismissed.
  /// - `theme` is the theme data for styling the dialog.
  /// - `imageEditorTheme` is the theme specific to the image editor.
  /// - `designMode` specifies the design mode for the image editor.
  /// - `i18n` provides internationalization support.
  ///
  /// Returns a [Future] that completes when the dialog is dismissed.
  show(
    BuildContext context, {
    String? message,
    bool isDismissible = kDebugMode,
    ThemeData? theme,
    required ProImageEditorConfigs configs,
  }) async {
    theme ??= configs.theme ?? Theme.of(context);

    if (message == null) {
      msg = configs.i18n.various.loadingDialogMsg;
    } else {
      msg = message;
    }
    _isVisible = true;

    final content = PopScope(
      canPop: isDismissible,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          state = setState;
          return Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: FittedBox(
                      child: PlatformCircularProgressIndicator(
                        designMode: configs.designMode,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _msg,
                    style: platformTextStyle(
                      context,
                      configs.designMode,
                    ).copyWith(
                      fontSize: 16,
                      color:
                          configs.imageEditorTheme.loadingDialogTheme.textColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
    return showAdaptiveDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        if (_isDisposed && context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.of(context).pop();
          });
        }
        return configs.designMode == ImageEditorDesignModeE.cupertino
            ? CupertinoTheme(
                data: CupertinoTheme.of(context).copyWith(
                  brightness: theme!.brightness,
                  primaryColor: theme.brightness == Brightness.dark
                      ? configs.imageEditorTheme.loadingDialogTheme
                          .cupertinoPrimaryColorDark
                      : configs.imageEditorTheme.loadingDialogTheme
                          .cupertinoPrimaryColorLight,
                  textTheme: CupertinoTextThemeData(
                    textStyle: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? configs.imageEditorTheme.loadingDialogTheme
                              .cupertinoPrimaryColorDark
                          : configs.imageEditorTheme.loadingDialogTheme
                              .cupertinoPrimaryColorLight,
                    ),
                  ),
                ),
                child: CupertinoAlertDialog(
                  content: content,
                ),
              )
            : Theme(
                data: theme!,
                child: AlertDialog(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  content: content,
                ),
              );
      },
    );
  }

  /// Hides the loading dialog.
  hide(BuildContext context) {
    if (_isVisible) {
      Navigator.pop(context);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isDisposed = true;
    });
  }
}

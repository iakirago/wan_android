part of 'view_state_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.statusCode,
    this.message,
    this.detail,
    this.onRetry,
  });

  CustomErrorWidget.withViewError(
    ViewError viewError, {
    super.key,
    this.onRetry,
  })  : statusCode = viewError.statusCode,
        message = viewError.message,
        detail = viewError.detail;

  final int? statusCode;
  final String? message;
  final String? detail;
  final VoidCallback? onRetry;

  bool get isDisconnected => statusCode == -2;

  String get errorImage {
    switch (statusCode) {
      case -1:
      case -2:
        return Assets.ASSETS_IMAGES_TIMEOUT_PNG;
      case 400:
      case 403:
        return Assets.ASSETS_IMAGES_400_PNG;
      case 404:
        return Assets.ASSETS_IMAGES_404_PNG;
      case 500:
      case 503:
        return Assets.ASSETS_IMAGES_500_PNG;
      default:
        return Assets.ASSETS_IMAGES_UNKNOWN_ERROR_PNG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kStyleUint4,
          vertical: kStyleUint4 * 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              errorImage,
              width: 120,
            ),
            Text(
              isDisconnected
                  ? S.of(context).networkException
                  : message ?? S.of(context).unknownError,
              style: context.theme.textTheme.titleSmall,
            ),
            Gap(
              size: GapSize.small,
            ),
            Text(
              isDisconnected
                  ? S.of(context).networkExceptionMsg
                  : detail ?? S.of(context).unknownErrorMsg,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyMedium,
            ),
            if (onRetry != null)
              Gap(
                size: GapSize.big,
              ),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ),
                  ),
                ),
                child: Text(S.of(context).retry),
              ),
          ],
        ),
      ),
    );
  }
}

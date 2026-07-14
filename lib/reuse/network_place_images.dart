import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Loads a place photo from a public GitHub repo via the jsdelivr CDN,
// instead of bundling every photo inside the app as a local asset. This is
// what actually shrinks the app's install size — images are downloaded on
// demand (and cached) rather than shipped inside the APK.
class NetworkPlaceImage extends StatelessWidget {
  final String fileName; // e.g. "hp1.jpg" — must match the filename in the repo, exact case
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkPlaceImage({
    super.key,
    required this.fileName,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  // IMPORTANT: replace these 2 values with your own GitHub username and
  // the repo name where you uploaded hp1.jpg ... hp91.jpg (at the repo
  // root). jsdelivr serves any public GitHub repo's files as a free CDN —
  // no account, no card, no limits for this kind of usage.
  static const String _githubUser = 'KasuniPrabodha';
  static const String _githubRepo = 'tourmate-images';
  static const String _branch = 'main'; // change to 'master' if that's your default branch

  String get _url {
    return 'https://cdn.jsdelivr.net/gh/$_githubUser/$_githubRepo@$_branch/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: memCacheWidth/Height tells Flutter to decode the image at
    // this pixel size, not its full original size. Your source photos are
    // ~6000x4000px (multiple MB each) — without this, decoding several of
    // those at once in a scrolling list can exhaust phone memory and make
    // the whole app freeze. We ask for roughly 2x the display size (for
    // sharpness on high-DPI screens) capped at a sane max.
    final targetWidth = width != null && width!.isFinite ? (width! * 2).round().clamp(100, 1200) : null;
    final targetHeight = height != null && height!.isFinite ? (height! * 2).round().clamp(100, 1200) : null;

    final image = CachedNetworkImage(
      imageUrl: _url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: targetWidth,
      memCacheHeight: targetHeight,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
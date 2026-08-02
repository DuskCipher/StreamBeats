import 'package:streambeats/core/theme/app_theme.dart';
import 'package:streambeats/utils/load_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class SquareImgCard extends StatefulWidget {
  final String imgPath;
  final String? fallbackImgPath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String? tag;
  final bool isWide;
  final bool isList;

  const SquareImgCard({
    super.key,
    required this.imgPath,
    this.fallbackImgPath,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isWide = false,
    this.tag,
    this.isList = true,
  });

  @override
  State<SquareImgCard> createState() => _SquareImgCardState();
}

class _SquareImgCardState extends State<SquareImgCard> {
  bool _pressed = false;

  bool get _isInteractive => widget.onTap != null;

  void _setPressed(bool value) {
    if (!_isInteractive || _pressed == value) return;
    setState(() => _pressed = value);
  }

  void _onTapDown(TapDownDetails _) => _setPressed(true);
  void _onTapUp(TapUpDetails _) => _setPressed(false);
  void _onTapCancel() => _setPressed(false);

  @override
  Widget build(BuildContext context) {
    final double cardW = widget.isWide ? 240 : 155;
    const double cardH = 170;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: _isInteractive ? _onTapDown : null,
        onTapUp: _isInteractive ? _onTapUp : null,
        onTapCancel: _isInteractive ? _onTapCancel : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _pressed ? 0.85 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: cardW,
                height: cardH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    LoadImageCached(
                      imageUrl: widget.imgPath,
                      fallbackUrl: widget.fallbackImgPath,
                      fit: BoxFit.cover,
                    ),

                    // Gradient overlay (bottom half dark)
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.20),
                              Colors.black.withValues(alpha: 0.78),
                            ],
                            stops: const [0.35, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Top-left tag badge (e.g. "MIX")
                    if (widget.tag != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.30),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.isList
                                    ? MingCute.playlist_2_line
                                    : MingCute.eye_2_line,
                                size: 11,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.tag!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Bottom: title + subtitle text overlaid on image
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Default_Theme.secondoryTextStyle.merge(
                              const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (widget.subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Default_Theme.secondoryTextStyle.merge(
                                TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.72),
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

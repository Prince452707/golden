import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HeroVideoWidget extends StatefulWidget {
  final BoxFit fit;
  final Alignment alignment;

  const HeroVideoWidget({
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.bottomCenter,
  });

  @override
  State<HeroVideoWidget> createState() => _HeroVideoWidgetState();
}

class _HeroVideoWidgetState extends State<HeroVideoWidget> {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset(
        'assets/gemini_generated_video_8563143a.mp4',
      );
      _controller = controller;

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0.0);
      await controller.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Video player initialization note: $e');
      if (mounted) {
        setState(() {
          _hasVideoError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVideoOrFallback();
  }

  Widget _buildVideoOrFallback() {
    if (_isVideoInitialized && _controller != null && !_hasVideoError) {
      final size = _controller!.value.size;
      final videoWidth = size.width > 0 ? size.width : 720.0;
      final videoHeight = size.height > 0 ? size.height : 1280.0;

      return SizedBox.expand(
        child: FittedBox(
          fit: widget.fit,
          alignment: widget.alignment,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: videoWidth,
            height: videoHeight,
            child: VideoPlayer(_controller!),
          ),
        ),
      );
    }

    // Clean asset fallback full width with clean box fit
    return Image.asset(
      'assets/home_podium_feathered.png',
      fit: widget.fit,
      alignment: widget.alignment,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }
}

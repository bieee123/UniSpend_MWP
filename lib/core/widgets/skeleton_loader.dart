import 'package:flutter/material.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.margin = const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;
  final bool hasCard;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(16),
    this.hasCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          Widget item = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const SizedBox(height: 8),
              SkeletonLoader(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLoader(
                    height: 20,
                    width: 80,
                  ),
                  SkeletonLoader(
                    height: 24,
                    width: 60,
                  ),
                ],
              ),
            ],
          );

          if (hasCard) {
            item = Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: item,
              ),
            );
          }

          return item;
        },
      ),
    );
  }
}

class AnimatedSkeleton extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const AnimatedSkeleton({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<AnimatedSkeleton> createState() => _AnimatedSkeletonState();
}

class _AnimatedSkeletonState extends State<AnimatedSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 2).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Shimmer(
          animation: _animation,
          child: widget.child,
        );
      },
    );
  }
}

class Shimmer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const Shimmer({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + animation.value, 0),
              end: Alignment(animation.value, 0),
              colors: [
                Colors.black12,
                Colors.white,
                Colors.black12,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}
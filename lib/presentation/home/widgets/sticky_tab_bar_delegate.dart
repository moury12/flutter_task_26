import 'package:task28_02/app_export.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}

import 'package:task28_02/app_export.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('No products found.')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppConstants.gridCrossAxisCount,
          childAspectRatio: AppConstants.gridChildAspectRatio,
          mainAxisSpacing: AppConstants.gridMainSpacing,
          crossAxisSpacing: AppConstants.gridCrossSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }
}

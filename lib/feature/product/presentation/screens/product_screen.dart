import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/product/presentation/providers/product_provider.dart';
import 'package:teslo_shop/feature/product/products.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: productState.isLoading
          ? const _LoadingFullView()
          : productState.product == null
              ? _ProductNotFoudView(productId)
              : _ProductView(product: productState.product!),
    );
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(product.title),
    );
  }
}

class _ProductNotFoudView extends StatelessWidget {
  final String productId;
  const _ProductNotFoudView(this.productId);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Text('Not found product: $productId'),
      ),
    );
  }
}

class _LoadingFullView extends StatelessWidget {
  const _LoadingFullView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/feature/product/products.dart';
import 'package:teslo_shop/feature/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nuevos productos'),
        onPressed: () {
          context.push(PathParameter.productPathByNew);
        },
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ConsumerState<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<_ProductsView> {
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      final currentPosition = controller.position.pixels;
      final maxPosition = controller.position.maxScrollExtent;

      if (currentPosition + 400 > maxPosition) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: RefreshIndicator(
          onRefresh: ref.read(productsProvider.notifier).refresh,
          child: SizedBox.expand(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MasonryView(
                    listOfItem: productsState.products,
                    numberOfColumn: size.width > 800 ? 3 : 2,
                    itemRadius: 0,
                    itemBuilder: (item) {
                      if (item.runtimeType != Product) return const SizedBox();
                      final product = item as Product;

                      ///*Product Item
                      return GestureDetector(
                          onTap: () => context
                              .go(PathParameter.productPathById(product.id)),
                          child: _ProductItem(product: product));
                    },
                  ),

                  ///*Loading next page indicator
                  SizedBox(
                    height: 150,
                    child: productsState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        product.images.isEmpty
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.asset('assets/images/no-image.jpg',
                    fit: BoxFit.cover))
            : ClipRect(
                clipBehavior: Clip.hardEdge,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/loaders/bottle-loader.gif',
                  image: product.images.first,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/no-image.jpg');
                  },
                ),
              ),
        Text(product.title),
      ],
    );
  }
}

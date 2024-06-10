import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/product/presentation/providers/product_form_provider.dart';

import 'package:teslo_shop/feature/product/products.dart';
import 'package:teslo_shop/feature/shared/infraestructure/services/image_service_impl.dart';
import 'package:teslo_shop/feature/shared/shared.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));
    ref.listen(
      productProvider(productId),
      (previous, next) {
        if (next.notification == null) return;

        _showSnackbar(context, next.notification.toString());
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
        actions: [
          IconButton(
              onPressed: () async {
                final photoPath = await ImageServiceImpl().takePhoto();
                if (photoPath == null) return;

                ref
                    .read(productFormProvider(productId).notifier)
                    .updateProductImage(photoPath);
              },
              icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(
            onPressed: () async {
              final photoPath = await ImageServiceImpl().selectPhoto();
              if (photoPath == null) return;

              ref
                  .read(productFormProvider(productId).notifier)
                  .updateProductImage(photoPath);
            },
            icon: const Icon(Icons.photo_library_outlined),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: productState.isLoading
          ? const LoadingFullView()
          : productState.product == null &&
                  productId != PathParameter.newProduct
              ? _ProductNotFoudView(productId)
              : GestureDetector(
                  onTap: FocusScope.of(context).unfocus,
                  child: _ProductView(productId: productId),
                ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Guardar'),
        icon: const Icon(Icons.save_outlined),
        isExtended: true,
        onPressed: () async {
          await ref
              .read(productFormProvider(productId).notifier)
              .postProduct()
              .then((save) {
            if (save) return _showSnackbar(context, 'Producto actualizado');

            final validForm = ref
                .read(productFormProvider(productId).notifier)
                .isValidPayload();
            if (validForm) return;

            _showSnackbar(context, 'Validar campos del formulario');
          });
        },
      ),
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

class _ProductView extends ConsumerWidget {
  final String productId;

  const _ProductView({required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final productFormState = ref.watch(productFormProvider(productId));

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productFormState.images),
        ),
        const SizedBox(height: 10),
        Text(
          productFormState.title.value,
          style: textStyles.titleSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        _ProductInformation(productId: productId),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final String productId;
  const _ProductInformation({required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productFormState = ref.watch(productFormProvider(productId));
    final productFormNotifier =
        ref.read(productFormProvider(productId).notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            required: productFormState.title.isRequired,
            initialValue: productFormState.title.value,
            onChanged: productFormNotifier.onTitleChange,
            errorMessage: productFormState.title.titleError(),
          ),
          CustomProductField(
            label: 'Slug',
            required: productFormState.slug.isRequired,
            initialValue: productFormState.slug.value,
            onChanged: productFormNotifier.onSlugChange,
            errorMessage: productFormState.slug.slugError(),
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            required: productFormState.price.isRequired,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormState.price.value,
            onChanged: productFormNotifier.onPriceChange,
            errorMessage: productFormState.price.priceError(),
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              Text('Extras'),
              Icon(Icons.star, color: Colors.red, size: 8),
            ],
          ),
          _SizeSelector(
            selectedSizes: productFormState.sizes,
            productId: productId,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
              selectedGender: productFormState.gender, productId: productId),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            required: productFormState.stock.isRequired,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormState.stock.value,
            onChanged: productFormNotifier.onStockChange,
            errorMessage: productFormState.stock.stockError(),
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productFormState.description,
            onChanged: productFormNotifier.onDescriptionChange,
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productFormState.tags.join(', '),
            onChanged: (value) {
              final tags = value.split(', ').toList();
              productFormNotifier.onTagsChange(tags);
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends ConsumerWidget {
  final String productId;
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  const _SizeSelector({required this.productId, required this.selectedSizes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        final sizes = newSelection.map((value) => value.toString()).toList();
        ref.read(productFormProvider(productId).notifier).onSizesChange(sizes);
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends ConsumerWidget {
  final String productId;
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector(
      {required this.productId, required this.selectedGender});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productNotifier = ref.read(productFormProvider(productId).notifier);
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          final gender = newSelection.first;
          productNotifier.onGenderChange(gender);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.map((imageItem) {
        if (imageItem.isEmpty) {
          return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child:
                  Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover));
        }

        late final ImageProvider imageProvider;

        if (imageItem.contains('http')) {
          imageProvider = NetworkImage(imageItem);
        } else {
          imageProvider = FileImage(File(imageItem));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FadeInImage(
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              image: imageProvider,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/no-image.jpg');
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

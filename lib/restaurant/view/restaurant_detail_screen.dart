import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/utils/pagination_utils.dart';
import 'package:delivery_app/product/widget/product_card.dart';
import 'package:delivery_app/rating/component/rating_card.dart';
import 'package:delivery_app/rating/model/rating_model.dart';
import 'package:delivery_app/rating/provider/rating_provier.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final RestaurantModel pItem;
  const RestaurantDetailScreen(
      {super.key, required this.pItem, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantRatingProvider(widget.id).notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return DefaultLayout(
        title: widget.pItem.name,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            renderTop(model: state),
            if (state is! RestaurantDetailModel) renderLoading(),
            if (state is RestaurantDetailModel) renderDetail(model: state),
            if (state is RestaurantDetailModel) renderLabel(),
            if (state is RestaurantDetailModel) renderProduct(model: state),
            if (ratingsState is CursorPagination<RatingModel>)
              renderRatings(models: ratingsState.data)
          ],
        ));
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => RatingCard.fromModel(model: models[index]),
            childCount: models.length),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate(List.generate(
                3,
                (index) => SkeletonParagraph(
                      style: const SkeletonParagraphStyle(lines: 5),
                    )))));
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestuarantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}

SliverToBoxAdapter renderDetail({required RestaurantDetailModel model}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        model.detail,
        style: const TextStyle(fontSize: 12, color: BDOY_TEXT_COLOR),
      ),
    ),
  );
}

SliverToBoxAdapter renderLabel() {
  return const SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text("메뉴",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    ),
  );
}

SliverList renderProduct({required RestaurantDetailModel model}) {
  return SliverList(
      delegate: SliverChildBuilderDelegate(
    (context, index) {
      return ProductCard(product: model.products[index]);
    },
    childCount: model.products.length,
  ));
}

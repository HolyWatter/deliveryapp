import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/utils/pagination_utils.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:delivery_app/restaurant/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(
        restaurantProvider.notifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 완전 처음 로딩일 때
    if (data is CursorPaginationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }
    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = data as CursorPagination;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 14,
            );
          },
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                      child: data is CursorPaginationFetchingMore
                          ? const CircularProgressIndicator()
                          : const Text("데이터가 없습니다. ㅜㅜ")));
            }

            final pItem = cp.data[index];

            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          RestaurantDetailScreen(pItem: pItem, id: pItem.id)));
                },
                child: RestuarantCard.fromModel(model: pItem));
          },
        ));
  }
}

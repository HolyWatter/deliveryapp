import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider = Provider.family(
  (ref, id) {
    final state = ref.watch(restaurantProvider);

    if (state is! CursorPagination) {
      return null;
    }

    return state.data.firstWhere((element) => element.id == id);
  },
);

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required super.repository});

  // @override
  // Future<void> paginate({
  //   int fetchCount = 20,
  //   //추가로 데이터를 더 가져올 것인지?
  //   //true - 데이터 더 가져옴, false - 새로고침
  //   bool fetchMore = false,
  //   //강제로 다시 로딩
  //   bool forceRefetch = false,
  // }) async {
  //   try {
  //     //다섯 가지 유형
  //     //State의 상태
  //     // 1) CursorPagination - 정상적으로 데이터가 있는 상태
  //     // 2) CursorPaginationLoading - 데이터가 로딩 중인 상태 (현재 캐시 없음)
  //     // 3) CursorPaginationError - 에러가 있는 상태
  //     // 4) CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져올때
  //     // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

  //     // 바로 반환해야하는 상황
  //     // 1) hasMore = false 데이터가 더 없을 때
  //     // 2) 로딩중 - fetchMore : true
  //     //  fetchMore가 아닐 때 - 새로고침의 의도가 있을 때
  //     if (state is CursorPagination && !forceRefetch) {
  //       final pState = state as CursorPagination;
  //       if (!pState.meta.hasMore) {
  //         return;
  //       }
  //     }
  //     final isLoading = state is CursorPaginationLoading;
  //     final isRefetching = state is CursorPaginationRefetching;
  //     final isFetchingMore = state is CursorPaginationFetchingMore;

  //     if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
  //       return;
  //     }

  //     PaginationParams paginationParams = PaginationParams(
  //       count: fetchCount,
  //     );
  //     if (fetchMore) {
  //       final pState = state as CursorPagination;

  //       state =
  //           CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

  //       paginationParams = paginationParams.copyWith(
  //         after: pState.data.last.id,
  //       );
  //     }
  //     // 데이터를 처음부터 가져오는 상황
  //     else {
  //       if (state is CursorPagination && !forceRefetch) {
  //         final pState = state as CursorPagination;

  //         state =
  //             CursorPaginationRefetching(meta: pState.meta, data: pState.data);
  //       } else {
  //         state = CursorPaginationLoading();
  //       }
  //     }

  //     final resp =
  //         await repository.paginate(paginationParams: paginationParams);

  //     if (state is CursorPaginationFetchingMore) {
  //       final pState = state as CursorPaginationFetchingMore;
  //       state = resp.copyWith(data: [...pState.data, ...resp.data]);
  //     } else {
  //       state = resp;
  //     }
  //   } catch (e) {
  //     state = CursorPaginationError(message: e.toString());
  //   }
  // }

  void getDetail({
    required String id,
  }) async {
    if (state is! CursorPagination) {
      await paginate();
    }
    // state 가 CursorPagination 이 아닐 때
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final res = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? res : e)
            .toList());
  }
}

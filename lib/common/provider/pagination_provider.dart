import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
import 'package:delivery_app/common/respository/base_pagination_repository.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<U extends IBasePaginationRepository>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading());

  Future<void> paginate({
    int fetchCount = 20,
    //추가로 데이터를 더 가져올 것인지?
    //true - 데이터 더 가져옴, false - 새로고침
    bool fetchMore = false,
    //강제로 다시 로딩
    bool forceRefetch = false,
  }) async {
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );
      if (fetchMore) {
        final pState = state as CursorPagination;

        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state =
              CursorPaginationRefetching(meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: e.toString());
    }
  }

  getDetail({
    required String id,
  }) async {
    if (state is! CursorPagination) {
      await paginate();
    }
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

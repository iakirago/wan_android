part of 'provider.dart';

abstract class BaseRefreshListViewNotifier<T>
    extends StateNotifier<RefreshListViewState<T>> {
  BaseRefreshListViewNotifier(
    super.state, {
    this.initialPageNum = 1,
    this.pageSize = 20,
  });

  final int initialPageNum;

  final int pageSize;

  Future<bool> initData() {
    if (state != RefreshListViewState<T>.loading()) {
      state = RefreshListViewState<T>.loading();
    }

    return refresh();
  }

  Future<bool> refresh() async {
    try {
      final RefreshListViewStateData<T> data = await loadData(
        pageNum: initialPageNum,
        pageSize: pageSize,
      );

      onCompleted(data.list);

      state = RefreshListViewState<T>(
        pageNum: data.pageNum,
        isLastPage: data.isLastPage,
        list: data.list,
      );

      return true;
    } catch (e, s) {
      onError(e, s);

      return false;
    }
  }

  Future<RefreshListViewStateData<T>> loadData({
    required int pageNum,
    required int pageSize,
  });

  void onCompleted(List<T> data) {}

  Future<LoadingMoreStatus?> loadMore() {
    return state.whenOrNull<Future<LoadingMoreStatus?>>(
          (int pageNum, bool isLastPage, List<T> list) async {
            try {
              /// Prevent no data state not being set on initialization
              if (isLastPage) {
                return LoadingMoreStatus.noData;
              }

              if (initialPageNum != 0) {
                pageNum += 1;
              }

              final RefreshListViewStateData<T> data = await loadData(
                pageNum: pageNum,
                pageSize: pageSize,
              );

              onCompleted(data.list);

              state = RefreshListViewState<T>(
                pageNum: data.pageNum,
                isLastPage: data.isLastPage,
                list: <T>[...list, ...data.list],
              );

              return data.isLastPage
                  ? LoadingMoreStatus.noData
                  : LoadingMoreStatus.completed;
            } catch (e) {
              return LoadingMoreStatus.failed;
            }
          },
        ) ??
        Future<LoadingMoreStatus?>.value();
  }

  @override
  ErrorListener get onError => (Object e, StackTrace? s) {
        state = RefreshListViewState<T>.error(e, s ?? StackTrace.current);
      };
}

enum LoadingMoreStatus {
  loading,
  completed,
  noData,
  failed,
}

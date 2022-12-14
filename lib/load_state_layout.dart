import 'package:flutter/material.dart';

/// 描述：四种视图状态
enum LayoutState { success, error, loading, empty }

///布局样式
enum LayoutStyle { only, stack }

///布局控制器
class LayoutController extends ChangeNotifier {
  LayoutState _layoutState;

  LayoutState get layoutState {
    return _layoutState;
  }

  set layoutState(LayoutState layoutState) {
    _layoutState = layoutState;
    notifyListeners();
  }

  LayoutController({LayoutState? layoutState})
      : _layoutState = layoutState ?? LayoutState.loading;
}

///
/// ///页面加载状态，默认为加载中
//   LayoutController layoutController =
//       LayoutController(layoutState: LayoutState.loading);
///
/// 更改状态
///
///
/// LoadStateLayout(
//      layoutController: layoutController,
//        errorRetry: () {
//           layoutController.layoutState = LayoutState.loading;
//         },
//               successWidget: const Text("正文"),
//     ),
///根据不同状态来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final LayoutController layoutController; //页面状态
  final LayoutStyle? layoutStyle; //设置布局样式
  final Widget successWidget; //成功视图
  final Widget? loadingView; //loading视图
  final Widget? errorWidget; //错误视图
  final Widget? emptyWidget; //空视图
  final VoidCallback? emptyRetry; //空事件处理
  final VoidCallback? errorRetry; //错误事件处理

  const LoadStateLayout({
    Key? key,
    required this.layoutController, //默认为加载状态
    required this.successWidget,
    this.layoutStyle = LayoutStyle.only,
    this.loadingView,
    this.errorWidget,
    this.emptyWidget,
    this.emptyRetry,
    this.errorRetry,
  }) : super(key: key);

  @override
  State createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {
  @override
  void initState() {
    super.initState();
    widget.layoutController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.layoutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.layoutController.layoutState == LayoutState.error) {
            widget.errorRetry?.call();
          }
          if (widget.layoutController.layoutState == LayoutState.empty) {
            widget.emptyRetry?.call();
          }
        },
        child: _buildWidget);
  }

  ///根据不同状态来显示不同的视图
  Widget get _buildWidget {
    if (widget.layoutStyle == LayoutStyle.only) {
      switch (widget.layoutController.layoutState) {
        case LayoutState.error:
          return widget.errorWidget ?? _errorView;
        case LayoutState.loading:
          return widget.loadingView ?? _loadingView;
        case LayoutState.empty:
          return widget.emptyWidget ?? _emptyView;
        default:
          return widget.successWidget;
      }
    } else {
      return Stack(
        children: [
          widget.successWidget,
          if (widget.layoutController.layoutState == LayoutState.error)
            widget.errorWidget ?? _errorView,
          if (widget.layoutController.layoutState == LayoutState.loading)
            widget.loadingView ?? _loadingView,
          if (widget.layoutController.layoutState == LayoutState.empty)
            widget.emptyWidget ?? _emptyView
        ],
      );
    }
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      alignment: Alignment.center,
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0x88000000),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[CircularProgressIndicator(), Text('正在加载')],
        ),
      ),
    );
  }

  ///错误视图
  Widget get _errorView {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Icon(Icons.network_wifi, color: Colors.green),
          Text("网络错误"),
          Text(
            '刷新',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  ///数据为空的视图
  Widget get _emptyView {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Icon(Icons.hourglass_empty, color: Colors.green),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('暂无数据'),
          )
        ],
      ),
    );
  }
}

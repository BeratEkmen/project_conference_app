import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToTopWidget extends StatefulWidget {
  ScrollController _scrollController;

  ScrollToTopWidget(this._scrollController);

  @override
  _ScrollToTopWidgetState createState() => _ScrollToTopWidgetState();
}

class _ScrollToTopWidgetState extends State<ScrollToTopWidget>
    with SingleTickerProviderStateMixin {
  bool _show = false;

  @override
  void initState() {
    widget._scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget._scrollController.removeListener(() {});
    super.dispose();
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void scrollToTop() {
    final topOffset = widget._scrollController.position.minScrollExtent;
    widget._scrollController.animateTo(
      topOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  void _scrollListener() {
    if (widget._scrollController.offset >
        widget._scrollController.position.minScrollExtent + 500.0) {
      showBottomBar();
    } else if (widget._scrollController.offset ==
        widget._scrollController.position.minScrollExtent) {
      hideBottomBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedOpacity(
            opacity: !_show ? 0 : 1,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: size.height * 0.01, horizontal: size.width * 0.005),
              height: size.height * 0.065,
              width: size.width * 0.11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.grey,
              ),
              child: Center(
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      scrollToTop();
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_up),
                ),
              ),
            ),
          );
  }
}

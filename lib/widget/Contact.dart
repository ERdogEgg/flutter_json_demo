import 'package:flutter/material.dart';

typedef void OnTouchCallback(int index);

class Contact extends StatefulWidget {
  final List data;
  final double suspensionHeight;
  final double itemHeight;

  Contact({this.data, this.suspensionHeight = 20.0, this.itemHeight = 40.0});

  @override
  State createState() {
    return new _ContactState();
  }
}

class _ContactState extends State<Contact> {
  ScrollController scrollController = new ScrollController();
  List<String> indexTagList = new List();
  List userList = new List();
  int defaultIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      double i = scrollController.offset.toDouble();
      int index = _computerIndex(i);
      setState(() {
        defaultIndex = index;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _initIndexBarData() {
    indexTagList.clear();
    widget.data?.forEach((v) {
      indexTagList.add(v['title'].toString().toUpperCase());
    });
  }

  int _computerIndex(double position) {
    if (widget.data != null) {
      for (int i = 0; i < widget.data.length - 1; i++) {
        double pre = _computerIndexPosition(i);
        double next = _computerIndexPosition(i + 1);
        if (position > pre && position < next) {
          return i;
        }
      }
    }
    return 0;
  }

  double _computerIndexPosition(int index) {
    int n = 0;
    if (widget.data != null) {
      for (int i = 0; i < index; i++) {
        n += (widget.data[i]['userList'].length).toInt();
      }
    }
    return n * (widget.suspensionHeight + widget.itemHeight) +
        widget.suspensionHeight;
  }

  void _initUserData() {
    userList.clear();
    widget.data?.forEach((user) {
      userList.add(user);
    });
  }

  void _onTouchCallback(int index) {
    scrollController.jumpTo(_computerIndexPosition(index)
        .clamp(.0, scrollController.position.maxScrollExtent));
    setState(() {
      defaultIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _initIndexBarData();
    _initUserData();
    Widget indexBar = new IndexBar(
      data: indexTagList,
      onTouchCallback: _onTouchCallback,
    );

    return new Stack(
      children: <Widget>[
        new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Text(
                  indexTagList.isNotEmpty
                      ? '${indexTagList[defaultIndex]}'
                      : "A",
                  textScaleFactor: 1.2,
                ),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                  left: 16.0,
                ),
                height: 40.0,
              ),
              new Expanded(
                  child: new ListView.builder(
                itemBuilder: (context, index) {
                  return new Column(
                    children: <Widget>[
                      Offstage(
                        child: new Container(
                          child: new Text(
                            "${userList[index]['title'].toString().toUpperCase()}",
                          ),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 16.0),
                          height: widget.suspensionHeight,
                        ),
                        offstage: false,
                      ),
                      new UserList(
                        userList: userList[index]['userList'],
                        itemHeight: widget.itemHeight,
                      )
                    ],
                  );
                },
                itemCount: userList.length,
                controller: scrollController,
              ))
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: new Container(
            alignment: Alignment.center,
            width: 30.0,
            child: indexBar,
          ),
        ),
      ],
    );
  }
}

class UserList extends StatefulWidget {
  final List userList;
  final double itemHeight;

  UserList({this.userList, this.itemHeight});

  @override
  State createState() {
    return new _UserListState();
  }
}

class _UserListState extends State<UserList> {
  List<Widget> children = new List();

  void _initUserData() {
    children.clear();
    widget.userList?.forEach((v) {
      children.add(new UserDetail(
        userDetail: v,
        itemHeight: widget.itemHeight,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    _initUserData();
    return new Column(
      children: children,
    );
  }
}

class UserDetail extends StatefulWidget {
  final Map userDetail;
  final double itemHeight;

  UserDetail({this.userDetail, this.itemHeight});

  @override
  State createState() {
    return new _UserDetailState();
  }
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {},
      child: new Container(
        child: new ListTile(
          title: new Text("${widget.userDetail['name']}"),
        ),
        height: widget.itemHeight,
      ),
    );
  }
}

class IndexBar extends StatefulWidget {
  final List<String> data;
  final OnTouchCallback onTouchCallback;

  IndexBar({this.data, this.onTouchCallback});

  @override
  State createState() {
    return new _IndexBarState();
  }
}

class _IndexBarState extends State<IndexBar> {
  List<Widget> children = new List();

  void _createWidget() {
    children.clear();
    widget.data?.forEach((v) {
      children.add(SizedBox(
        child: new Text(
          '$v',
          style: new TextStyle(
            fontSize: 18.0,
          ),
        ),
        height: 20.0,
      ));
    });
  }

  void _triggerTouch(int index) {
    if (widget.onTouchCallback != null) {
      widget.onTouchCallback(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    _createWidget();
    return new GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        int offset = details.globalPosition.dy.toInt();
        RenderBox rb = context.findRenderObject();
        int top = rb.localToGlobal(Offset.zero).dy.toInt();
        _triggerTouch(((offset - top) / 20).floor());
      },
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

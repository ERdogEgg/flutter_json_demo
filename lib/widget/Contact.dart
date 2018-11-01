import 'package:flutter/material.dart';

typedef void OnTouchCallback(int index);

class Contact extends StatefulWidget {
  final List data;

  Contact({this.data});

  @override
  State createState() {
    return new _ContactState();
  }
}

class _ContactState extends State<Contact> {
  ScrollController scrollController = new ScrollController();
  List<String> indexTagList = new List();
  List userList = new List();

  void _initIndexBarData() {
    indexTagList.clear();
    widget.data?.forEach((v) {
      indexTagList.add(v['title'].toString().toUpperCase());
    });
  }

  void _initUserData() {
    userList.clear();
    widget.data?.forEach((user) {
      userList.add(user);
    });
  }

  void _onTouchCallback(int index) {
    print(index);
    scrollController.jumpTo(index * 20.0);
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
                child: new Text('111111'),
              ),
              new Expanded(
                  child: new ListView.builder(
                itemBuilder: (context, index) {
                  return new Column(
                    children: <Widget>[
                      Offstage(
                        child: new Container(
                          child: new Text(
                            "${userList[index]['title']}",
                          ),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 16.0),
                        ),
                        offstage: false,
                      ),
                      new UserList(
                        userList: userList[index]['userList'],
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

  UserList({this.userList});

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

  UserDetail({this.userDetail});

  @override
  State createState() {
    return new _UserDetailState();
  }
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text("${widget.userDetail['name']}"),
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
        _triggerTouch(((offset - top) / 20).ceil());
      },
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

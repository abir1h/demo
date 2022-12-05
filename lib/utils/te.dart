import 'package:flutter/material.dart';



class te extends StatefulWidget {


  @override
  _teState createState() => _teState();
}

class _teState extends State<te> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver:  SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      pinned: true,
                      title: Text('fee'),
                      expandedHeight: 500,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(tabs: [Tab(text: 'Tab A'), Tab(text: 'Tab B')]),
                    Colors.blue,
                  ),
                  pinned: false,
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                NestedTabs('A'),
                NestedTabs('B'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// This class is to handle the main tabs (Tab A & Tab B)
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._color);

  TabBar _tabBar;
  final Color _color;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: _color,
      alignment: Alignment.center,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class NestedTabs extends StatelessWidget {
  final String mainTabName;
  NestedTabs(this.mainTabName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: Container(
          color: Colors.blue,
          alignment: Alignment.bottomCenter,
          child: TabBar(
            tabs: [
              Tab(text: 'Tab $mainTabName-1'),
              Tab(text: 'Tab $mainTabName-2')
            ],
          ),
        ),
      ),
      body: TabBarView(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 500,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  width: 200,
                  color: Colors.black45,
                  child: Center(child: Text('Index ${index}')));
            },
          ),
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 500,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  width: 200,
                  color: Colors.black45,
                  child: Center(child: Text('Index ${index}')));
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RemCardsNavBar extends StatefulWidget {
  final List<RemCardsNavBarButton> children;
  final Function(int) onTap;
  const RemCardsNavBar({Key key, this.children, this.onTap})
      : super(key: key);

  @override
  State<RemCardsNavBar> createState() => _RemCardsNavBarState();
}

class _RemCardsNavBarState extends State<RemCardsNavBar> {
  int _selectedIndex = 0;

  List<Widget> _items() {
    List<Widget> items = [];
    for (int i = 0; i < widget.children.length; i++) {
      var child = widget.children[i];
      items.add(Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _selectedIndex == i ? Colors.amber : Colors.white,
            ),
            child: (child is RemCardsNavBarImageButton)
                ? TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = i;
                  });
                  widget.onTap(i);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(child.assetURL, height: 50, width: 50,),
                ))
                : (child is RemCardsNavBarIconButton)
                ? IconButton(
              icon: child.icon,
              color: _selectedIndex == i
                  ? Colors.green
                  : Colors.blueGrey,
              tooltip: child.title,
              onPressed: () {
                setState(() {
                  _selectedIndex = i;
                });
                widget.onTap(i);
              },
            )
                : const Text('ERROR DRAWING NAV BAR')),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Row(
        children: _items(),
      ),
    );
  }
}

class RemCardsNavBarButton {
  final String title;
  bool _active = false;

  bool isActive() => _active;
  void setActiveState(bool state) {
    _active = state;
  }

  RemCardsNavBarButton({this.title});
}

class RemCardsNavBarImageButton extends RemCardsNavBarButton {
  final String assetURL;
  RemCardsNavBarImageButton({ String title, this.assetURL}):super(title: title);
}

class RemCardsNavBarIconButton extends RemCardsNavBarButton {
  final Icon icon;
  RemCardsNavBarIconButton({ String title, this.icon}):super(title: title);
}

import 'package:flutter/material.dart';

import 'dropdonw_item.dart';

class CustomDropdown extends StatefulWidget {
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double borderRadiusDropDown;
  final String initialSelectedValue;
  final List<String> items;
  final double itemHeight;
  final double dropHeight;
  final IconData icon1;
  final IconData icon2;
  final void Function(dynamic selectedValue) onChangeValue;
  final bool isMultiSelect;
  const CustomDropdown(
      {Key key,
      this.borderRadiusDropDown = 0,
      this.margin = const EdgeInsets.symmetric(horizontal: 32),
      this.borderRadius = 5,
      this.initialSelectedValue = 'data',
      @required this.items,
      this.itemHeight = 20,
      @required this.onChangeValue,
      this.icon1 = Icons.expand_more,
      this.icon2 = Icons.expand_less,
      this.dropHeight = 100,
      this.isMultiSelect = false})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool get isDropdownOpened => floatingDropdownOverlay != null;
  OverlayEntry floatingDropdownOverlay;
  bool isOpen = false;
  String _selectedValue;
  LayerLink layerLink = LayerLink();
  List<String> valuesMultiSelected = [];
  @override
  void initState() {
    super.initState();
    actionKey = LabeledGlobalKey(widget.initialSelectedValue);
    _selectedValue = widget.initialSelectedValue;
  }

  @override
  void dispose() {
    floatingDropdownOverlay?.remove();
    floatingDropdownOverlay = null;
    isOpen = false;
    super.dispose();
  }

  //BoxRender to show
  void findDropDownAction() {
    RenderBox renderBox =
        actionKey.currentContext.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    var offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  //Overlay function call
  OverlayEntry _floatingDropDownOverlayBuilder(
      void Function(String selectedValue) onTap) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        top: yPosition,
        width: width,
        child: CompositedTransformFollower(
          offset: Offset(0.0, widget.itemHeight + 25),
          link: layerLink,
          child: DropDown(
            isMultiSelect: widget.isMultiSelect,
            dropHeight: widget.dropHeight,
            itemHeight: widget.itemHeight,
            selectedValue: _selectedValue,
            items: widget.items,
            onTap: onTap,
            icon: widget.icon2,
            borderRadius: widget.borderRadius,
          ),
        ),
      );
    });
  }

  //Overlay remove
  void _removeOverlay() {
    floatingDropdownOverlay?.remove();
    floatingDropdownOverlay = null;
    setState(() {
      isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: CompositedTransformTarget(
        link: layerLink,
        child: GestureDetector(
          key: actionKey,
          //Action to activate ovelay over the button
          onTap: () {
            if (isDropdownOpened) {
              setState(_removeOverlay);
            } else {
              findDropDownAction();
              floatingDropdownOverlay =
                  _floatingDropDownOverlayBuilder((selectedValue) {
                setState(() {
                  _removeOverlay();
                  if (widget.isMultiSelect) {
                    if (!valuesMultiSelected.contains(selectedValue))
                      valuesMultiSelected.add(selectedValue);
                    widget.onChangeValue(valuesMultiSelected);
                  } else {
                    _selectedValue = selectedValue;
                  }
                  widget.onChangeValue(_selectedValue);
                });
              });
              Overlay.of(context).insert(floatingDropdownOverlay);
              setState(() {
                isOpen = true;
              });
            }
          },
          child: Container(
            height: widget.itemHeight * 1.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadiusDropDown),
              color: Colors.white,
            ),
            child: Material(
              clipBehavior: Clip.hardEdge,
              color: Colors.white,
              elevation: 1,
              borderRadius: BorderRadius.circular(3),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                height: widget.itemHeight * 1.5,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Label',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    Row(
                      mainAxisAlignment: widget.isMultiSelect
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.isMultiSelect) ...[
                          for (var i in valuesMultiSelected)
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    i,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        valuesMultiSelected.remove(i);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(40)),
                            )
                        ] else ...[
                          Text(
                            _selectedValue.replaceFirst(_selectedValue[0],
                                _selectedValue[0].toUpperCase()),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                        Expanded(child: Container()),
                        Icon(
                          isOpen ? widget.icon2 : widget.icon1,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  final double itemHeight;
  final double dropHeight;
  final double borderRadius;
  final String selectedValue;
  final bool isMultiSelect;
  final icon;
  final List<String> items;

  final void Function(String selectedValue) onTap;

  DropDown(
      {Key key,
      @required this.itemHeight,
      @required this.items,
      @required this.onTap,
      @required this.selectedValue,
      @required this.icon,
      @required this.dropHeight,
      @required this.borderRadius,
      this.isMultiSelect = false})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            height: widget.dropHeight,
            child: Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (widget.isMultiSelect) {
                          widget.onTap(widget.items[index]);
                        } else {
                          widget.onTap(widget.items[index]);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DropDownItem(
                          itemHeight: widget.itemHeight,
                          text: widget.items[index],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

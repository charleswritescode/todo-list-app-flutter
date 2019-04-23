import 'package:flutter/material.dart';

class TodoListSort extends StatelessWidget {

  final SortingParam sortingParam;
  final String order;
  final Function(SortingParam param, String order) onSortChanged;

  const TodoListSort({Key key, this.sortingParam, this.order, this.onSortChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: <Widget>[
            Text("Sorted by ${sortingParam.fieldName}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            GestureDetector(
              child: Padding(padding: EdgeInsets.all(16),
              child:  Icon(order == "ASC" ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,),),
              onTap: () {
                onSortChanged(sortingParam, order == "ASC" ? "DESC" : "ASC");
              },
            )],
        ),
      ),
    );
  }

}

class SortingParam {
  final String fieldId;
  final String fieldName;

  SortingParam(this.fieldId, this.fieldName);
}
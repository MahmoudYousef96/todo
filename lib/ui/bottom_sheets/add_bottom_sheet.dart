import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c7_sat/model/todo_dm.dart';
import 'package:todo_c7_sat/providers/listProvider.dart';
import 'package:todo_c7_sat/utils/Constants.dart';

class AddBottomSheet extends StatefulWidget {

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  GlobalKey<FormState> myKey= GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String title = "";
  String description = "";

  late ListProvider listProvider;
  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: myKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12,),
            Text("Add new Task", textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Title",
              ),
              validator: (text){
                if(text == null || text.trim().isEmpty) {
                   return "Please enter title";
                }
              },
              onChanged: (text){
                title = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Description",
              ),
              validator: (text){
                if(text == null || text.trim().isEmpty) {
                  return "Please enter title";
                }
              },
              onChanged: (text){
               description = text;
              },
              minLines: 3,
              maxLines: 4 ,
            ),
            SizedBox(height: 24,),
            Text("Select date", textAlign: TextAlign.start,style: Theme.of(context).textTheme.displayMedium,),
            InkWell(
                onTap: (){
                  showMyDatePicker();
                },
                child: Text("${selectedDate.year}/ ${selectedDate.month} / ${selectedDate.day}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall,)),
            Spacer(),
            Container(
                margin: EdgeInsets.all(12),
                child: ElevatedButton(onPressed: (){

                  addOnClick();
                }, child: Text("Add")))
          ],
        ),
      ),
    );
  }

  void showMyDatePicker() async {
   selectedDate =  await showDatePicker(context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
   )??DateTime.now();
  }

  void addOnClick() {
    if(! myKey.currentState!.validate()) return ;
    var todosCollection  = FirebaseFirestore.instance.collection(TodoDM.collecteionName);
     var emptyDoc = todosCollection.doc(); // create empty doc to get id from it
     emptyDoc.set({
      idKey: emptyDoc.id, // use id generated by firestore
      titleKey: title,
      descriptionKey: description,
      dateTimeKey: selectedDate.millisecondsSinceEpoch,
      isDoneKey: false
    }).timeout(Duration(milliseconds: 500), onTimeout: (){
      listProvider.fetchTodosFromFireStore(); ///refresh
       Navigator.pop(context);/// to close bottom sheet
     });
  }
}

import 'package:flutter/material.dart';
import 'package:project2/db/user_services.dart';

class dbtest extends StatefulWidget {
  @override
  _dbtest createState() => _dbtest();
}

class _dbtest extends State<dbtest> {
  var db = new UserService(); // CALLS FUTURE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Of users'),
      ),
      body: FutureBuilder<List>(
        future: db.getAllUsers(),
        //initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, int position) {
                    final item = snapshot.data![position];
                    //get your item data here ...
                    return Card(
                      child: ListTile(
                        title: Text("Employee Name: " +
                            snapshot.data![position].row[1]),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

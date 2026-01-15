import 'package:attendancewithqrwp/database/db_helper.dart';
import 'package:attendancewithqrwp/model/attendance.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DbHelper dbHelper = DbHelper();
  Future<List<Attendance>>? attendances;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    if (mounted) {
      setState(() {
        attendances = dbHelper.getAttendances();
      });
    }
  }

  SingleChildScrollView dataTable(List<Attendance> attendances) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'NAME',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'DATE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'TIME',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'TYPE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'LOCATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: attendances
              .map(
                (attendance) => DataRow(
                  cells: [
                    DataCell(
                      Text(attendance.name!),
                    ),
                    DataCell(
                      Text(attendance.date!),
                    ),
                    DataCell(
                      Text(attendance.time!),
                    ),
                    DataCell(
                      Text(attendance.type!),
                    ),
                    DataCell(
                      Text(attendance.location!),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Expanded list() {
    return Expanded(
      child: FutureBuilder(
        future: attendances,
        builder: (context, snapshot) {
          if (null == snapshot.data || !snapshot.hasData) {
            return const Center(child: Text("No Data Found"));
          }

          if (snapshot.hasData) {
            return dataTable(snapshot.data!);
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          list(),
        ],
      ),
    );
  }
}

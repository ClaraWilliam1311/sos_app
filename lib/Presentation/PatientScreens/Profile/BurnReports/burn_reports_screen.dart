import 'package:flutter/material.dart';
import 'package:sos_app/Presentation/PatientScreens/Profile/BurnReports/specific_report_screen.dart';
import 'package:sos_app/Presentation/Styles/colors.dart';
import 'package:sos_app/Presentation/Styles/fonts.dart';
import '../../../../Data/Models/ReportModel.dart';
import '../../../../Data/Models/patient.dart';

class BurnReportsScreen extends StatefulWidget {
  Patient patient;
  BurnReportsScreen({Key? key, required this.patient}) : super(key: key);

  @override
  State<BurnReportsScreen> createState() => _BurnReportsScreenState();
}

List<Report> reports = [];

class _BurnReportsScreenState extends State<BurnReportsScreen> {
  _getReports() async {
    reports = await GetReports(widget.patient, context);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReports();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64.5,
        title: const Text('Burn Reports',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: back,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reports.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: white,
                        child: ListTile(
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  const Text(
                                    "Degree:",
                                    style: TextStyle(
                                      fontSize: contentFont,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "    ${reports[index].burnDegree}",
                                    style: const TextStyle(
                                      fontSize: contentFont,
                                      color: Colors.grey,
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  const Text(
                                    "Date:",
                                    style: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: contentFont,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "       ${reports[index].date}",
                                    style: const TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: contentFont,
                                      color: Colors.grey,
                                    ),
                                  )
                                ]),
                              ]),
                          trailing: const Icon(
                            Icons.navigate_next_outlined,
                            size: 30,
                            color: black,
                          ),
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpecificReportScreen(
                                      report: reports[index]),
                                ));
                            if (result == "refresh") {
                              _getReports();
                            }
                          },
                        )),
                  );
                })),
      ),
    );
  }
}

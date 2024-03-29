import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/Data/Models/AnswerModel.dart';
import 'package:sos_app/Data/Models/QuestionAnswerModel.dart';
import 'package:sos_app/Data/Models/QuestionModel.dart';
import '../../Styles/colors.dart';
import '../../Styles/fonts.dart';
import '../Home/Community/specific_question_screen.dart';

class CommunityHistoryScreen extends StatefulWidget {
  const CommunityHistoryScreen({super.key});

  @override
  State<CommunityHistoryScreen> createState() => _CommunityHistoryScreenState();
}

var id;
List<Question> questions = [];
List<QuestionAnswer> qa = [];
bool _questionsFlag = false, _qaFlag = false;

SliverAppBar showSliverAppBar(String screenTitle) {
  return const SliverAppBar(
    backgroundColor: primaryColor,
    floating: true,
    pinned: true,
    snap: false,
    centerTitle: true,
    title: Text(
      'Q/A History',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    ),
    bottom: TabBar(
      tabs: [
        Tab(
          text: 'Questions',
        ),
        Tab(
          text: 'Answers',
        )
      ],
    ),
  );
}

class _CommunityHistoryScreenState extends State<CommunityHistoryScreen> {
  _getQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("Id");
    questions = await GetPatientQuestions(id);
    _questionsFlag = true;
    setState(() {});
  }

  _getAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("Id");
    qa = await GetAnswersWithQuestion(id);
    _qaFlag = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getQuestions();
    _getAnswers();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: back,
        body: DefaultTabController(
            length: 2,
            child: TabBarView(children: [
              CustomScrollView(slivers: [
                showSliverAppBar('Q/A History'),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        child: _questionsFlag == true
                            ? questions.length != 0
                                ? SingleChildScrollView(
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            for (var i = 0;
                                                i < questions.length;
                                                i++)
                                              Card(
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  elevation: 7,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  color: containerColor,
                                                  child: InkWell(
                                                      highlightColor:
                                                          hoverColor,
                                                      onTap: () async {
                                                        var result =
                                                            await Navigator
                                                                .push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SpecificQuestionScreen(
                                                                    question:
                                                                        questions[
                                                                            i],
                                                                  )),
                                                        );
                                                        if (result ==
                                                            "refresh") {
                                                          _getQuestions();
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Stack(
                                                            children: <Widget>[
                                                              Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                              NetworkImage(questions[i].patientImage),
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          radius:
                                                                              28,
                                                                        ),
                                                                        Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(' ${questions[i].patientName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                              Text(questions[i].date, style: const TextStyle(fontSize: 15, color: Color.fromARGB(153, 58, 58, 58))),
                                                                            ]),
                                                                        const Spacer(),
                                                                        IconButton(
                                                                          color:
                                                                              Colors.red,
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                30,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                              useSafeArea: false,
                                                                              context: context,
                                                                              barrierColor: splashBack,
                                                                              builder: (ctx) => AlertDialog(
                                                                                content: const Text("Are you sure, you want to delete this question?",
                                                                                    style: TextStyle(
                                                                                      fontSize: contentFont,
                                                                                    )),
                                                                                actions: [
                                                                                  Row(
                                                                                    children: [
                                                                                      //btn cancel
                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: OutlinedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(ctx);
                                                                                            },
                                                                                            child: const Text(
                                                                                              "Cancel",
                                                                                              style: TextStyle(
                                                                                                color: primaryColor,
                                                                                                fontSize: contentFont,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),

                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: MaterialButton(
                                                                                            elevation: 6.0,
                                                                                            color: Colors.redAccent,
                                                                                            onPressed: () async {
                                                                                              var result = await DeleteQuestion(
                                                                                                questionId: questions[i].questionId,
                                                                                                context: context,
                                                                                              );
                                                                                              if (result == "deleted") {
                                                                                                _getQuestions();
                                                                                                _getAnswers();
                                                                                              }
                                                                                            },
                                                                                            child: const Text(
                                                                                              'Sure',
                                                                                              style: TextStyle(
                                                                                                color: white,
                                                                                                fontSize: contentFont,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            242,
                                                                            235,
                                                                            235),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            const EdgeInsets.all(7.0),
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        child:
                                                                            Text(
                                                                          questions[i].content.length > 50
                                                                              ? "${questions[i].content.substring(0, 50)}.."
                                                                              : questions[i].content,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.5,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ]),
                                                            ]),
                                                      )))
                                          ],
                                        ),
                                      )
                                    ]),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                25, 2, 25, 5)),
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          size: 100,
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          height: size.height / 40,
                                        ),
                                        const Text(
                                          'There is no Questions',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  )
                            : const Center(
                                child: CircularProgressIndicator(),
                              )),
                  ]),
                )
              ]),
              CustomScrollView(slivers: [
                showSliverAppBar('Q/A History'),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        child: _qaFlag == true
                            ? qa.length != 0
                                ? SingleChildScrollView(
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            for (var i = 0; i < qa.length; i++)
                                              Card(
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  elevation: 7,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  color: containerColor,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage: NetworkImage(qa[
                                                                            i]
                                                                        .question
                                                                        ?.patientImage),
                                                                    backgroundColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    radius: 28,
                                                                  ),
                                                                  Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            ' ${qa[i].question!.patientName}',
                                                                            style:
                                                                                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                        Text(
                                                                            qa[i]
                                                                                .question!
                                                                                .date,
                                                                            style:
                                                                                const TextStyle(fontSize: 15, color: Color.fromARGB(153, 58, 58, 58))),
                                                                      ]),
                                                                  const Spacer(),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        242,
                                                                        235,
                                                                        235),
                                                              ),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        7.0),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  qa[i]
                                                                      .question!
                                                                      .content,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Column(
                                                                children: <
                                                                    Widget>[
                                                                  Column(
                                                                    children: [
                                                                      const Divider(
                                                                        color: Colors
                                                                            .black,
                                                                        height:
                                                                            3,
                                                                        thickness:
                                                                            1,
                                                                        indent:
                                                                            10,
                                                                        endIndent:
                                                                            10,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundImage: NetworkImage(qa[i].answer!.userImage),
                                                                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                                                              radius: 24,
                                                                            ),
                                                                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                              Text(" ${qa[i].answer!.UserName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                              Text(qa[i].answer!.role, style: const TextStyle(fontSize: 15, color: Color.fromARGB(153, 58, 58, 58))),
                                                                            ]),
                                                                            const Spacer(),
                                                                            IconButton(
                                                                              icon: const Icon(
                                                                                Icons.delete,
                                                                                size: 30,
                                                                              ),
                                                                              color: Colors.red,
                                                                              onPressed: () {
                                                                                showDialog(
                                                                                  useSafeArea: false,
                                                                                  context: context,
                                                                                  barrierColor: splashBack,
                                                                                  builder: (ctx) => AlertDialog(
                                                                                    content: const Text("Are you sure, you want to delete this answer?",
                                                                                        style: TextStyle(
                                                                                          fontSize: contentFont,
                                                                                        )),
                                                                                    actions: [
                                                                                      Row(
                                                                                        children: [
                                                                                          //btn cancel
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: OutlinedButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(ctx);
                                                                                                },
                                                                                                child: const Text(
                                                                                                  "Cancel",
                                                                                                  style: TextStyle(
                                                                                                    color: primaryColor,
                                                                                                    fontSize: contentFont,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),

                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: MaterialButton(
                                                                                                elevation: 6.0,
                                                                                                color: Colors.redAccent,
                                                                                                onPressed: () async {
                                                                                                  var result = await DeleteAnswer(answerId: qa[i].answer!.answerId, context: context, questionId: qa[i].question!.questionId);
                                                                                                  if (result == "deleted") {
                                                                                                    _getQuestions();
                                                                                                    _getAnswers();
                                                                                                  }
                                                                                                },
                                                                                                child: const Text(
                                                                                                  'Sure',
                                                                                                  style: TextStyle(
                                                                                                    color: white,
                                                                                                    fontSize: contentFont,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              const EdgeInsets.all(5.0),
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10.0)),
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                242,
                                                                                235,
                                                                                235),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                const EdgeInsets.all(7.0),
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Text(
                                                                              "${qa[i].answer!.content}",
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                letterSpacing: 0.5,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black45,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ])))
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                25, 2, 25, 5)),
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          size: 100,
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          height: size.height / 40,
                                        ),
                                        const Text(
                                          'There is no Answers',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  )
                            : const Center(
                                child: CircularProgressIndicator(),
                              )),
                  ]),
                )
              ]),
            ])));
  }
}

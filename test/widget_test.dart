import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:course_test_app/screens/course_page/bloc/course_bloc.dart';
import 'package:course_test_app/screens/course_page/course_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<MockTestCourseBloc>()])
class MockTestCourseBloc extends MockBloc<CourseEvent, CourseState>
    implements CourseBloc {}

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets('loads the course page', (tester) async {
    var courseBloc = CourseBloc();
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => courseBloc,
        child: const CoursePage(),
      ),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(Duration(seconds: 75));
  });
}

import 'dart:io';

import 'package:course_test_app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../model/course_model.dart';
import 'bloc/course_bloc.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late VideoPlayerController videoController;
  int selectedIndex = 0;

  late CourseModel courseModel;

  bool isLoading = true;
  bool isError = false;

  ///memiliki isi yang sama dengan downloadingProgress
  List<DownloadingModel> downloadingIndex = [];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    context.read<CourseBloc>().add(CourseStarted());
    super.initState();
  }

  ///Jika output -1 maka tidak ada
  ///
  /// Mencari index yang dimasukkan apakah index tersebut sedang melakukan download
  int getProgressIndex(int searchIndex) {
    int index = -1;
    for (int i = 0; i < downloadingIndex.length; i++) {
      if (downloadingIndex[i].index == searchIndex) {
        index = i;
        break;
      }
    }
    return index;
  }

  SliverList tabBarSliverList() {
    if (tabController.index == 0) {
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        var curriculum = courseModel.curriculum[index];
        var selectedCourse = selectedIndex == index;
        var currentDownloadIndex = 0;
        var isDownloading = getProgressIndex(index) != -1;

        ///Check downloading progress index
        double progress = 0;
        //Jika index sedang mendownload, cek progres
        if (downloadingIndex.isNotEmpty) {
          currentDownloadIndex = getProgressIndex(index);
          if (currentDownloadIndex != -1) {
            progress = downloadingIndex[currentDownloadIndex].progress;
          }
        }
        if (curriculum.type == Types.SECTION) {
          return Container(
            color: Colors.grey[300],
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  curriculum.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${curriculum.duration} Menit',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )
              ],
            ),
          );
        } else if (curriculum.type == Types.UNIT) {
          return Material(
            color: selectedCourse ? Colors.blue[50] : Colors.white,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  //Jika file sudah didownload, gunakan file
                  if (curriculum.filePath.isNotEmpty) {
                    videoController =
                        VideoPlayerController.file(File(curriculum.filePath));
                  } else {
                    videoController = VideoPlayerController.networkUrl(
                        Uri.parse(curriculum.onlineVideoLink));
                  }
                  videoController.initialize();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              curriculum.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                            Text(
                              '${curriculum.duration} Menit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    curriculum.filePath.isEmpty
                        ? !isDownloading
                            ? Material(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: InkWell(
                                  onTap: () {
                                    context.read<CourseBloc>().add(
                                        CourseDownloadVideo(
                                            index,
                                            curriculum.offlineVideoLink,
                                            curriculum.id));
                                    // context.read<CourseBloc>().add(
                                    //     CourseDownloadVideo(
                                    //         index,
                                    //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                                    //         curriculum.id));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Tonton offline',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 25,
                                width: 100,
                                child: LinearProgressIndicator(
                                  value: progress,
                                ),
                              )
                        : Row(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Tersimpan',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                              ),
                            IconButton(onPressed: (){
                              context.read<CourseBloc>().add(CourseDeleteVideo(curriculum.filePath, index));
                            }, icon: Icon(Icons.delete, color: Colors.red,)),
                          ],
                        )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      }, childCount: courseModel.curriculum.length));
    } else if (tabController.index == 1) {
      return SliverList(
          delegate: SliverChildListDelegate([Text('Isi Ikhtisar')]));
    } else {
      return SliverList(delegate: SliverChildListDelegate([Text('Lampiran')]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CourseLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is CourseLoaded) {
          setState(() {
            isLoading = false;
            courseModel = state.courseModel;
            for (int i = 0; i < courseModel.curriculum.length; i++) {
              if (courseModel.curriculum[i].onlineVideoLink.isNotEmpty) {
                selectedIndex = i;
                break;
              }
            }
            //Jika file sudah didownload, gunakan file
            if (courseModel.curriculum[selectedIndex].filePath.isNotEmpty) {
              videoController = VideoPlayerController.file(
                  File(courseModel.curriculum[selectedIndex].filePath));
            } else {
              videoController = VideoPlayerController.networkUrl(Uri.parse(
                  courseModel.curriculum[selectedIndex].onlineVideoLink));
            }
            videoController.initialize();
          });
        }
        if (state is CourseDownloading) {
          setState(() {
            if (getProgressIndex(state.downloadingIndex) == -1) {
              downloadingIndex.add(
                  DownloadingModel(state.downloadingIndex, state.progress));
            } else {
              var index = getProgressIndex(state.downloadingIndex);
              downloadingIndex[index].progress = state.progress;
            }
          });
        }
        if (state is CourseDownloaded) {
          setState(() {
            var downloadedIndex = getProgressIndex(state.index);
            downloadingIndex.removeAt(downloadedIndex);
            courseModel.curriculum[state.index].filePath = state.savedPath;
          });
        }
        if(state is CourseDeleted) {
          setState(() {
            courseModel.curriculum[state.deletedIndex].filePath = '';
            if(state.deletedIndex == selectedIndex){
              videoController = VideoPlayerController.networkUrl(Uri.parse(courseModel.curriculum[state.deletedIndex].onlineVideoLink));
              videoController.initialize();
            }
          });
        }
        if (state is CourseError) {
          setState(() {
            isError = true;
          });
        }
      },
      child: Scaffold(
        body: !isError
            ? !isLoading
                ? CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        floating: false,
                        snap: false,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.4,
                        leading: Icon(Icons.arrow_back),
                        title: Text(courseModel.courseName),
                        flexibleSpace: FlexibleSpaceBar(
                          background: SafeArea(
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: kToolbarHeight,
                                  top: kToolbarHeight + 10),
                              child: GestureDetector(
                                onTap: () {
                                  videoController.value.isPlaying
                                      ? videoController.pause()
                                      : videoController.play();
                                  setState(() {});
                                },
                                child: AspectRatio(
                                  aspectRatio:
                                      videoController.value.aspectRatio,
                                  child: Stack(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 22.5),
                                      child: VideoPlayer(videoController, key: Key('videoPlayer'),),
                                    ),
                                    Center(
                                      child: !(videoController.value.isPlaying)
                                          ? Container(
                                              child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white
                                                            .withOpacity(0.4)),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.blue,
                                                      size: 45,
                                                    )),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.play_circle,
                                                    color: Colors.white,
                                                    size: 70,
                                                  ),
                                                ),
                                              ],
                                            ))
                                          : Container(),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          courseModel
                                              .curriculum[selectedIndex].title,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        bottom: TabBar(controller: tabController, tabs: [
                          Tab(
                            text: 'Kurikulum',
                          ),
                          Tab(
                            text: 'Ikhtisar',
                          ),
                          Tab(
                            text: 'Lampiran',
                          )
                        ]),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 3),
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value:
                                      (int.parse(courseModel.progress) / 100),
                                  color: Colors.green,
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      courseModel.progress + '%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ))
                            ]),
                          )
                        ],
                      ),
                      tabBarSliverList()
                    ],
                  )
                : Center(child: CircularProgressIndicator())
            : Center(
                child: Text('An error occurred when loading data'),
              ),
      ),
    );
  }
}

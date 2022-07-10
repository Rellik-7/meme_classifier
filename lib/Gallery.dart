import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meme_classifier/TfliteModel2.dart';
import 'package:path_provider/path_provider.dart';

import 'package:photo_manager/photo_manager.dart';

class GridGallery extends StatefulWidget {
  final ScrollController? scrollCtr;

  const GridGallery({
    Key? key,
    this.scrollCtr,
  }) : super(key: key);

  @override
  _GridGalleryState createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  final List<Map> _mediaList = [];
  bool isloading = false;
  int currentPage = 0;
  int? lastPage;
  int no_of_selected = 0;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      // print(albums);
      // if (kDebugMode) {

      // }
      List<AssetEntity> media = await albums[0]
          .getAssetListPaged(size: 60, page: currentPage); //preloading files
      // if (kDebugMode) {
      //   print(media);
      // }
      List<Map> temp = [];
      for (var asset in media) {
        if (asset.type != AssetType.video) {
          temp.add({
            'widget': FutureBuilder(
              future:
                  asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
              //resolution of thumbnail
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            'selected': false,
            'file': await asset.file,
            'path': asset.relativePath,
            'id': asset.id,
            'confidence_Score': 0,
            'ismeme': false
          });
        }
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      PhotoManager.openSetting();

      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose images to classify'),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return false;
        },
        child: _mediaList.isEmpty || isloading == true
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                controller: widget.scrollCtr,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Stack(
                      children: [
                        Opacity(
                          child: _mediaList[index]['widget'],
                          opacity:
                              _mediaList[index]['selected'] == true ? 0.5 : 1,
                        ),
                        Center(
                            child: Container(
                                child: _mediaList[index]['selected'] == true
                                    ? Icon(Icons.check, size: 30)
                                    : null))
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _mediaList[index]['selected'] == false
                            ? no_of_selected++
                            : no_of_selected--;
                        _mediaList[index]['selected'] =
                            !_mediaList[index]['selected'];
                      });
                    },
                  );
                },
              ),
      ),
      floatingActionButton: no_of_selected != 0
          ? FloatingActionButton.extended(
              label: Text('Filter memes'),
              onPressed: () async {
                setState(() {
                  isloading = true;
                });

                List<Map> _selectedlist = [];
                _mediaList.forEach(
                  (element) {
                    if (element['selected']) {
                      _selectedlist.add(element);
                    }
                  },
                );
                print(_selectedlist);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TfliteModel(selectedlist: _selectedlist),
                  ),
                ).then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GridGallery(),
                    ),
                  );
                });

                setState(() {
                  isloading = false;
                });
              },
            )
          : null,
    );
  }
}

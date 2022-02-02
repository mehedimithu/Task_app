import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:task_app/controller/controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/constants/colors.dart';
import 'package:task_app/presentation/presentation.dart';

class ImageInfoScreen extends StatefulWidget {
  const ImageInfoScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _ImageInfoScreenState createState() => _ImageInfoScreenState();
}

class _ImageInfoScreenState extends State<ImageInfoScreen> {
  ImageInfoCubit? _imageInfoCubit;

  @override
  void initState() {
    _imageInfoCubit = context.read<ImageInfoCubit>();
    _imageInfoCubit?.getInfoDat(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: imageView(size),
    );
  }

  Widget imageView(size) {
    return BlocBuilder<ImageInfoCubit, ImageInfoState>(
      builder: (context, state) {
        if (state is ImageInfoLoading) {
          return _loadingIndicator();
        }
        else if (state is ImageInfoLoaded) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PhotoView.customChild(
              child: ImageLoader(
                imageUrl: state.imageModel.downloadUrl.toString(),
              ),
              childSize: const Size(500.0, 500.0),
              backgroundDecoration:
                  const BoxDecoration(color: TaskAppColors.kBlack300Color),
              customSize: size,
              enableRotation: true,
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.8,
              initialScale: PhotoViewComputedScale.covered,
            ),
          );
        }
        return _loadingIndicator();
      },
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
import 'package:flutter/material.dart';

List<String> imagesList = [
  'imagePath',
  'imagePath',
];

class SlideUpTransitionAnimation extends StatefulWidget {
  const SlideUpTransitionAnimation({super.key});

  @override
  State<SlideUpTransitionAnimation> createState() =>
      _SlideUpTransitionAnimationState();
}

class _SlideUpTransitionAnimationState
    extends State<SlideUpTransitionAnimation> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Image ${currentPageIndex + 1} title here'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView.builder(
          itemCount: imagesList.length,
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return PageViewItem(
              imagePath: imagesList[index],
            );
          },
        ),
      ),
    );
  }
}

class PageViewItem extends StatefulWidget {
  const PageViewItem({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<PageViewItem> createState() => _PageViewItemState();
}

class _PageViewItemState extends State<PageViewItem> {
  bool isExpanded = false;
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _opacity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.imagePath,
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          bottom: isExpanded ? 80 : 100,
          width: isExpanded ? width * 0.78 : width * 0.7,
          height: isExpanded ? height * 0.5 : height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Hero(
                  tag: 'titleHeroTag',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Title Here',
                          style: TextStyle(
                            height: 0,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Subtitle Here',
                          style: TextStyle(
                            fontSize: 12,
                            height: 0,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.045,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (context, index) => SizedBox(
                      width: width * 0.005,
                    ),
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: 'CircleTag$index',
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('imagePath'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          bottom: isExpanded ? 150 : 100,
          child: GestureDetector(
            onPanUpdate: (details) {
              //top
              if (details.delta.dy < 0) {
                setState(() {
                  _opacity = 1.0;
                  isExpanded = true;
                });
              }
              //bottom
              else if (details.delta.dy > 0) {
                setState(() {
                  _opacity = 0.0;
                  isExpanded = false;
                });
              }
            },
            onTap: () {
              if (!isExpanded) {
                setState(() {
                  isExpanded = true;
                });
                return;
              }
              Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                reverseTransitionDuration: const Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0, 0.5),
                  );
                  return FadeTransition(
                    opacity: curvedAnimation,
                    child: DetailView(
                      animation: animation,
                      imagePath: widget.imagePath,
                    ),
                  );
                },
              ));
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 15,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Hero(
                  tag: 'image',
                  child: Image.asset(
                     widget.imagePath,
                     height: height * 0.65,
                    width: width * 0.7,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key, required this.animation, required this.imagePath, });

  final Animation<double> animation;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'image',
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.asset(
               imagePath,
                fit: BoxFit.cover,
                height: 540,
                width: double.infinity,
              ),
            ),
          ),
          Hero(
            tag: 'titleHeroTag',
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title Here',
                        style: TextStyle(
                          height: 0,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'Subtitle Here',
                        style: TextStyle(
                          fontSize: 12,
                          height: 0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(
                      0.2,
                      1,
                      curve: Curves.easeInExpo,
                    ),
                  ),
                  child: child,
                );
              },
              child: ListView.separated(
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Hero(
                      tag: 'CircleTag$index',
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('imagePath'),
                      ),
                    ),
                    minLeadingWidth: 50,
                    title: const Text(
                      'Username',
                    ),
                    subtitle: const Text(
                      'Comment',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    trailing: const Text(
                      '12: 00 PM',
                      style: TextStyle(
                        color: Colors.black26,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

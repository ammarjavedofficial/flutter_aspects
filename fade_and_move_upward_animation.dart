import 'package:flutter/material.dart';

List<String> imageList = [
  'imagePath',
  'imagePath',
  'imagePath',
];

class FadeAndMoveUpWardAnimation extends StatefulWidget {
  const FadeAndMoveUpWardAnimation({super.key});

  @override
  State<FadeAndMoveUpWardAnimation> createState() => _FadeAndMoveUpWardAnimationState();
}

class _FadeAndMoveUpWardAnimationState extends State<FadeAndMoveUpWardAnimation> {
  int _currentPage = 0;

  PageController pageController = PageController(
    viewportFraction: 0.8,
  );

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackImageWidget(currentPage: _currentPage),
          BottomGradientWidget(),
          PageView.builder(
            controller: pageController,
            itemCount: imageList.length,
            onPageChanged: (value) {
              _currentPage = value;
              setState(() {});
            },
            itemBuilder: (context, index) {
              return PageViewItem(currentPage: _currentPage);
            },
          ),
        ],
      ),
    );
  }
}

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required int currentPage,
  }) : _currentPage = currentPage;

  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: ColoredBox(
            color: Colors.white,
            child: AnimatedContainer(
              padding: EdgeInsets.all(16),
              duration: Duration(milliseconds: 500),
              height: _currentPage == index ? 590 : 390,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 15,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      imageList[index],
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: _currentPage == index ? 500 : 350,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                        ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Colors.green.shade600),
                      minimumSize: MaterialStatePropertyAll(Size(50, 40))
                    ),
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                    ],
                  ),
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomGradientWidget extends StatelessWidget {
  const BottomGradientWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0001),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class BackImageWidget extends StatelessWidget {
  const BackImageWidget({
    super.key,
    required int currentPage,
  }) : _currentPage = currentPage;

  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Image.asset(
        imageList.elementAt(_currentPage),
        key: Key(imageList.elementAt(_currentPage)),
        fit: BoxFit.cover,
      ),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: child,
          ),
        );
      },
    );
  }
}

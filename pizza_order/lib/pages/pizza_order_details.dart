import 'package:flutter/material.dart';
import 'package:pizza_order/ingredient.dart';

const double _pizzaCartSize = 55;

class PizzaOrderDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PizzaOrderDetailsState();
  }
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "New Orleans Pizza",
            style: TextStyle(color: Colors.brown, fontSize: 24),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.brown,
                ))
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Column(
                  children: [
                    Expanded(flex: 3, child: _PizzaDetails()),
                    Expanded(flex: 2, child: _PizzaIngredients()),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 25,
                height: _pizzaCartSize,
                width: _pizzaCartSize,
                left:
                    MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
                child: _PizzaCartButton())
          ],
        ));
  }
}

class _PizzaDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PizzaDetailsState();
  }
}

class _PizzaDetailsState extends State<_PizzaDetails> with SingleTickerProviderStateMixin {
  List<Ingredient> _listIngredients = <Ingredient>[];
  int _total = 15;
  final _notifierFocused = ValueNotifier(false);
  AnimationController _animationController;
  List<Animation> _animationList = [

  ];
 BoxConstraints _pizzaContraints;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900)
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildIngredientWidget() {
      List<Widget> elements = [];
      if(_animationList.isNotEmpty) {
          for(int i=0; i < _listIngredients.length; i++){
            Ingredient ingredient = _listIngredients[i];
            for(int j=0; j < ingredient.positions.length; j++){
                  final animation = _animationList[i];
                  final position = ingredient.positions[j];
                  final positonX = position.dx;
                  final positonY = position.dy;
                  double fromX = 0.0, fromY = 0.0;
                  if(j<1) {

                  }
            }

            }
      }
      return SizedBox.fromSize();
  }

    void _buildIngredientAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0,0.8,curve: Curves.decelerate))
    );

    _animationList.add(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2,0.8,curve: Curves.decelerate))
    );

    _animationList.add(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4,1.0,curve: Curves.decelerate))
    );

    _animationList.add(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1,0.7,curve: Curves.decelerate))
    );

    _animationList.add(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3,1,curve: Curves.decelerate))
    );

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
            child: DragTarget<Ingredient>(
          onAccept: (ingredient) {
            print("onAccept");
            _notifierFocused.value = false;
            setState(() {
              _listIngredients.add(ingredient);
              _total++;
            });
            _buildIngredientAnimation();
            _animationController.forward(from: 0.0);
          },
          onWillAccept: (ingredient) {
            print("onWillAccept");
            _notifierFocused.value = true;
            for (Ingredient i in _listIngredients) {
              if (i.compare(ingredient)) {
                return false;
              }
            }
            return true;
          },
          onLeave: (ingredient) {
            print("onLeave");
            _notifierFocused.value = false;
          },
          builder: (context, list, rejects) {
            return LayoutBuilder(builder: (context, constraints) {
              _pizzaContraints = constraints;
              return Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _notifierFocused,
                  builder: (context,focused, _){
                      return  AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        height: focused
                            ? constraints.maxHeight
                            : constraints.maxHeight - 10,
                        child: Stack(
                          children: [
                            Image.asset("assets/pizza_order/dish.png"),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/pizza_order/pizza-1.png"),
                            )
                          ],
                        ),
                      );
                  },
                )
             );
            });
          },
        )),
        SizedBox(
          height: 5,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(Tween<Offset>(
                  begin: Offset(0.0, 0.0),
                  end: Offset(0.0, animation.value),
                )),
                child: child,
              ),
            );
          },
          child: Text(
            '\$$_total',
            key: UniqueKey(),
            style: TextStyle(
                color: Colors.brown, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        _buildIngredientWidget()
      ],
    );
  }
}

class _PizzaCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.withOpacity(0.5), Colors.orange]),
      ),
      child: Icon(
        Icons.shopping_cart_outlined,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class _PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ingredient.length,
        itemBuilder: (context, index) {
          return _PizzaIngredientItem(
            ingredient: ingredient[index],
          );
        });
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  final Ingredient ingredient;
  _PizzaIngredientItem({@required this.ingredient});
  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Container(
          height: 45,
          width: 45,
          decoration:
              BoxDecoration(color: Color(0xFFF5EED3), shape: BoxShape.circle),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              ingredient.image,
              fit: BoxFit.contain,
            ),
          )),
    );
    return Center(
      child: Draggable(
        data: ingredient,
        //feedback: child,
        feedback: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Colors.black26,
                offset: Offset(0.0,5.0),
                spreadRadius: 5.0
              )
            ]
          ),
          child: child,
        ),
        child: child,
      ),
    );
  }
}

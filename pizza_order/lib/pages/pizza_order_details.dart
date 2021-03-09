import 'package:flutter/material.dart';
import 'package:pizza_order/ingredient.dart';

const double _pizzaCartSize = 55;

class PizzaOrderDetails extends StatelessWidget {
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

class _PizzaDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: DragTarget<Ingredient>(
          onAccept: (ingredient){
            print("onAccept");
          },
          onWillAccept: (ingredient){
            print("onWillAccept");

          },
          onLeave: (ingredient){
            print("onLeave");
          },

          builder: (context, list, rejects) {
            return Stack(
              children: [
                Image.asset("assets/pizza_order/dish.png"),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset("assets/pizza_order/pizza-1.png"),
                )
              ],
            );
          },
        )),
        SizedBox(
          height: 5,
        ),
        Text(
          '\$13',
          style: TextStyle(
              color: Colors.brown, fontSize: 30, fontWeight: FontWeight.bold),
        )
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
    return Container(
      color: Colors.red,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ingredient.length,
          itemBuilder: (context, index) {
            return _PizzaIngredientItem(
              ingredient: ingredient[index],
            );
          }),
    );
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  final Ingredient ingredient;
  _PizzaIngredientItem({@required this.ingredient});
  @override
  Widget build(BuildContext context) {

    final child = Container(
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
        ));

    return Draggable(
      data: ingredient,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: child,
        ),
        feedback: child
    );

  }
}

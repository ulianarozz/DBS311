/*
Student1 Name: Uliana Rozzhyvaikina Student1 ID: 132294190
Student2 Name: Vishisht Akhileshkumar Gupta Student2 ID: 147208193
Student3 Name: Nisrein Hinnawi Student3 ID: 130223183
Date: 2020-12-1
Purpose: Assignment 2 - DBS311
*/

#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <occi.h>
#include <iomanip>
#include <cctype>


using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;
//header

int mainMenu();
void displayTitle();
int customerLogin(Connection* conn, int customerId);
int addToCart(Connection* conn, struct ShoppingCart cart[]);
double findProduct(Connection* conn, int product_id);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);



struct ShoppingCart {
	int product_id;
	double price;
	int quantity;
};

void displayTitle() {
	cout << "******************** Main Menu ********************\n"
		<< "1)\tLogin\n"
		<< "0)\tExit\n";
}

int mainMenu(void) {
	//menu option 1 or 0
	int choice = 0;
	do {
		displayTitle();
		if (choice != 0 && choice != 1) {
			cout << "You entered a wrong value. Enter an option (0-1): ";
		}
		else
			cout << "Enter an option (0-1): ";

		cin >> choice;
	} while (choice != 0 && choice != 1);

	return choice;
}
int customerLogin(Connection* conn, int customerId) {
	Statement* stmt = conn->createStatement();
	//using find_customer procedure 
	stmt->setSQL("BEGIN find_customer(:1, :2); END;");
	int result;
	stmt->setInt(1, customerId);
	stmt->registerOutParam(2, Type::OCCIINT, sizeof(result));
	//executing the procedure
	stmt->executeUpdate();
	result = stmt->getInt(2);
	conn->terminateStatement(stmt);
	return result;
}

int addToCart(Connection* conn, struct ShoppingCart cart[]) {
	cout << "-------------- Add Products to Cart --------------" << endl;
	for (int i = 0; i < 5; ++i) {
		int productId;
		int qty;
		ShoppingCart item;
		int choice;
		try {
			do { //searching prod ID
				cout << "Enter the product ID: ";
				cin >> productId;
				//checking if exists
				if (findProduct(conn, productId) == 0) {
					cout << "The product does not exist. Try again..." << endl;
				}
			} while ((findProduct(conn, productId) == 0));
			// calling fucntion find product that will return price
			cout << "Product Price: " << findProduct(conn, productId) << endl;
			cout << "Enter the product Quantity: ";
			cin >> qty;
			//set values into item
			item.product_id = productId;
			item.price = findProduct(conn, productId);
			item.quantity = qty;
			//set item into cart of i
			cart[i] = item;
		}
		catch (SQLException& sqlExcp) {

			cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();

		}

		if (i == 4) {
			return i + 1;
		}
		else {
			do {
				//adding new products if needed
				cout << "Enter 1 to add more products or 0 to check out: ";
				cin >> choice;
			} while (choice != 0 && choice != 1);
		}

		if (choice == 0) {
			return i + 1;
		}
	}
//	conn->terminateStatement(stmt);
}
double findProduct(Connection* conn, int product_id) {
	double price;
	Statement* stmt = conn->createStatement();
	try {
		//using find_product procedure
		stmt->setSQL("BEGIN find_product(:1, :2); END;");
		stmt->setInt(1, product_id);
		stmt->registerOutParam(2, Type::OCCIDOUBLE, sizeof(price));
		stmt->executeUpdate();
		//set the price
		price = stmt->getDouble(2);
	}
	catch (SQLException& sqlExcp) {
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
	
	conn->terminateStatement(stmt);
	if (price > 0) {
		// if price is ok return price
		return price;
	}
	else {
		return 0;
	}
}
void displayProducts(struct ShoppingCart cart[], int productCount) {
	if (productCount != 0) {
		double total = 0;
		cout << "------- Ordered Products ---------" << endl;
		//loop al the products fromt the array
		for (int i = 0; i < productCount; i++) {
			cout << "---Item " << i + 1 << endl;
			cout << "Product ID: " << cart[i].product_id << endl;
			cout << "Price: " << cart[i].price << endl;
			cout << "Quantity: " << cart[i].quantity << endl;
			total += cart[i].price * cart[i].quantity;
		}
		cout << "----------------------------------\nTotal: " << total << endl;
	}
}

int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount) {
	char opt;
	Statement* stmt = conn->createStatement();
	do {
		cout << "Would you like to checkout ? (Y / y or N / n) ";
		cin >> opt;

		if (opt != 'Y' && opt != 'y' && opt != 'N' && opt != 'n')
			cout << "Wrong input. Try again..." << endl;
	} while (opt != 'y' && opt != 'Y' && opt != 'n' && opt != 'N');
	if (opt == 'n' || opt == 'N') {
		cout << "The order is cancelled." << endl;
		return 0;
	}
	else {
		//if Y....
		try {
			//using ad_order procedure
			stmt->setSQL("BEGIN add_order(:1, :2); END;");
			int ord_id;
			stmt->setInt(1, customerId);
			stmt->registerOutParam(2, Type::OCCIINT, sizeof(ord_id));
			//execute procedure
			stmt->executeUpdate();
			ord_id = stmt->getInt(2);
			for (int i = 0; i < productCount; i++) {
				//using add_order_item procedure 
				stmt->setSQL("BEGIN add_order_item(:1, :2, :3, :4, :5); END;");
				//set all the values for each item 
				stmt->setInt(1, ord_id);
				stmt->setInt(2, i + 1);
				stmt->setInt(3, cart[i].product_id);
				stmt->setInt(4, cart[i].quantity);
				stmt->setDouble(5, cart[i].price);
				//execute the procedure
				stmt->executeUpdate();
			}
			cout << "The order is successfully completed." << endl;
		}
		catch (SQLException& sqlExcp) {
			cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
		}
		conn->terminateStatement(stmt);
	}
	return 1;
}





int main(void) {

	Environment* env = nullptr;
	Connection* conn = nullptr;
	string str;
	string user = "dbs311_203f28";
	string pass = "21056717";
	string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

	try {
		env = Environment::createEnvironment(Environment::DEFAULT);
		conn = env->createConnection(user, pass, constr);
		int choice;
		int customerId;
		do {
			//run the main menu
			choice = mainMenu();
			if (choice == 1) {
				cout << "Enter the customer ID: ";
				cin >> customerId;
				//check if customet exists by calling customer login
				if (customerLogin(conn, customerId) == 0) {
					cout << "The customer does not exist." << endl;
				}
				else {
					//if exist create the cart 
					ShoppingCart cart[5];
					int productCnt = addToCart(conn, cart);
					displayProducts(cart, productCnt);
					checkout(conn, cart, customerId, productCnt);
				}
			}
		} while (choice != 0);

		cout << "Good bye!..." << endl;

		env->terminateConnection(conn);
		Environment::terminateEnvironment(env);
	}
	catch (SQLException& sqlExcp) {
		cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
	}
	return 0;
}

/*PROCEDURES
CREATE OR REPLACE PROCEDURE find_customer(customerId IN NUMBER, found OUT NUMBER) AS
BEGIN
	SELECT COUNT(*)
	INTO found
	FROM customers
	WHERE customer_id = customerId;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		found := 0;
END;
/

-- find_product
CREATE OR REPLACE PROCEDURE find_product(productId IN NUMBER, price OUT products.list_price%TYPE) AS
BEGIN
	SELECT  list_price
	INTO    price
	FROM    products
	WHERE   product_id = productId;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		price := 0;
END;
/

-- add_order_item
CREATE OR REPLACE PROCEDURE add_order_item(orderId IN order_items.order_id%type,
										   itemId IN order_items.item_id%type,
										   productId IN order_items.product_id%type,
										   inQuantity IN order_items.quantity%type,
										   price IN order_items.unit_price%type) AS
BEGIN
	INSERT INTO order_items
	(order_id, item_id, product_id, quantity, unit_price)
	VALUES
	(orderId, itemId, productId, inQuantity, price);

END;
/

-- add_order
CREATE OR REPLACE PROCEDURE add_order(customerId IN NUMBER, new_order_id OUT NUMBER) AS
BEGIN
	SELECT  MAX(order_id)
	INTO    new_order_id
	FROM    orders;

	new_order_id := new_order_id + 1;

	INSERT INTO orders
	(order_id, customer_id, status, salesman_id, order_date)
	VALUES
	(new_order_id, customerId, 'Shipped', 56, SYSDATE);
END;

*/

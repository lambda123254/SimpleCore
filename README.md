# SimpleCore

SimpleCore is a simple Core Data library which provide simple function to Create, Read, Update, and Delete data. This library provides simple syntax which is very friendly to use by new programmer.

This library is not perfect and still in development, there are some features which were already implemented. This library meant for simple app.

Usable function:
1. Save data
2. Show data (first data, last data, and all data only)
3. Delete data
4. Get NSManagedObject data

Future function (in development):
1. Update data function

Supported Saved Data Type:
- String
- Integer
- Double
- Date
- Boolean

# Installation
1. In your app project go to your package dependencies
2. Click + Sign
3. Enter https://github.com/lambda123254/SimpleCore.git URL in search bar on top right of the menu
4. Click add package
5. Add this line on top of your desired controller "import SimpleCore"
6. Done

# Syntax
Before you use the library, make sure you already create an instance.
```
let simpleCore = SimpleCore(entity: "your entity name", coreData: "your core data name")
```


Showing Data
```
simpleCore.showData(option: "all") //to show all data
simpleCore.showData(option: "first") // to show first data
simpleCore.showData(option: "last") // to show last data

```
Get Data
```
for data in simpleCore.getData() {
  yourArray.append(yourStructClass(yourAttributes: data.value(forKey: "yourCoreDataAttributes"), .. )
}
// simpleCore.getData() returns NSManagedObject
```

Deleting Data
```
simpleCore.delete(option: "all", attr: "", value: "") -- to delete all data
simpleCore.delete(option: "single", attr: "your attribute name", value: "value which you want to delete") // to delete certain object where value is filled

```
Inserting Data
```
simpleCore.insert(into: "attribute1,attribute2,...", value: "value1,value2,...") -- to insert data

```



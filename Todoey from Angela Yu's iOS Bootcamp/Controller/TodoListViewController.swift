//
//  ViewController.swift
//  Todoey from Angela Yu's iOS Bootcamp
//
//  Created by Camilo L-Shide on 17/01/24.
//

import UIKit

class TodoListViewController : UITableViewController {
    
    var itemArray = [Item]() // We first create an itemArray of Item objects so both the title and the done status can be handled effectively.
    
    let defaults = UserDefaults.standard // This is how we create our UserDefaults object named defaults. It is a Singleton
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // That is how we create the Items.plist that will be used later to persist the data and populate the tableview.

    override func viewDidLoad() {
        
        super.viewDidLoad() // We should never forget about the good practice of calling the super implementation for viewDidLoad()
        
        loadItems() // A call to the method described at the bottomo of this file.
    }

    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count // The number of columns or cells in the table view is dictated by the number of elements on the array.
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Tipically this is the one to go for starting populating the cells shown on the TableView
        
        let item = itemArray[indexPath.row] // Since we use this itemArray[indexPath.row] in several ocations we simply put assign it to a constant named item.
        
        cell.textLabel?.text = item.title // We do use the title property of each Item element contained in the array for that to be the cell text.
        
        cell.accessoryType = item.done ? .checkmark : .none // We do use this line to either add or remove the mark accesory on the cell depending on the stautus of the Item object.
        
        return cell // This step is simply mandatory and that's how we allow the tableView to populate the cells as described above.
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // This line does change the done status to the opposite one of each element of the itemArray (Item type object)
        
        saveItems() // This call is super important, see the method description at the bottom of the file.
        
        tableView.deselectRow(at: indexPath, animated: true) // This line help us to remove the gray markdown of the cell a few moments after it is touched.
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // Reason why we create an UITextField Object is because we will use its properties to save the items introduced on the alert textfield.
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert) // We basically create the alert
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in // This closure is triggered as soon as the user clicks on the add item button located in the alert pop up
            
            let newItem = Item() // We neeed to create a new Item object so we can modify it and save into our .plist file with the lines shown below.
            
            newItem.title = textField.text! // Whatever the user types in the textfield now gets assigned to the title property of the Item object we just created above. Remember that by default the done property is set to false (not done state) whenever we create an instance of that class.
            
            self.itemArray.append(newItem) // Once the newItem is modified accordingly we save into the itemArray
            
            self.saveItems() // This call is super important as well, you can fin the method description at the bottom.

        }
        
        alert.addTextField { (alertTextField) in // This is how we add a textfield into the alert
            alertTextField.placeholder = "Create new item" // This is just for the default textfield placeholder
            textField = alertTextField // With this line we tell the compiler that the UITexField that the alert should use is the one declared above (in Line 62)
        }
        alert.addAction(action) // This line simply adds the action declared above into the alert so everything can work just fine.
        
        present(alert, animated: true, completion: nil) // With this line we simply make the alert visible on screen as soon as the add button is pressed by the user.
    }
    
    

    // MARK: -Model Manupulation Methods (This is where we encode and decode the itemArray)
    
    func saveItems(){
        
        let encoder = PropertyListEncoder() // Since we are working with a PList we do need a PropertyListEncoder() which we will call encoder.
        
        do {
            
            let data = try encoder.encode(itemArray) // With this line we try to encode the itemArray
            
            try data.write(to: dataFilePath!) // With this line we try to write the array into the plist file "Items.plist" we created in line 17
            
        }catch{
            
            print("Error enconding item array, \(error)") // This is simply for catching the error.
            
        }
        
        self.tableView.reloadData() // We know that this method calls all of the tableView methods responsible for creating the table.
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){ // With this we try to store the content of the Items.plist" we created in line 17 and assing it to a data constant. Remember that this should be the itemArray encoded by the saveItems() method
            
            let decoder = PropertyListDecoder() // Since we are working with a .plist file here we need a PropertyListDecoder()
            
            do{
                
                itemArray = try decoder.decode([Item].self, from: data) // In this line we try to assing the decoded data to the itemArray for that we pass as parameters of the decode methos the type we are expecting to get and the palce in which that can be found which is the data constant that will be filled with the content of the Items.plist in case that there is any
                
            } catch{
                print("Error decoding item array, \(error)") // We know that this method calls all of the tableView methods responsible for creating the table.
            }
        }
    }
}

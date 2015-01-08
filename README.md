DeserializableSwiftGenerator
============================

[JSONHelper](https://github.com/isair/JSONHelper) or [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) deserializable swift class generator.


![alt tag](https://raw.githubusercontent.com/cemolcay/DeserializableSwiftGenerator/master/ss.png)

generates deserializable swift classes from json string


Usage
=====

* JSONHelper <br> https://github.com/isair/JSONHelper#json-string-deserialization

* ObjectMapper <br> https://github.com/Hearst-DD/ObjectMapper#the-basics

generator creates `JSONHelper` & `ObjectMapper` deserializable swift classes <br>
from your response or request json strings  


Class Prefixes
--------------

If you want to add prefix to your generating classes just add prefix in parenthesis before class name.  
ex: (CO)LoginRequest


Extending Generator
===================

Generator has three main parts behind the scenes:

**SWJsonParser**  
  Serializes json string to `SWClass`es  
  
**SWClass** and **SWProperty**  
  These are hold the info about generating classes
  * class name
  * class supername
  * class properties
     * property name
     * property type
    

**SWGenerator**    
  you can subclass `SWGenerator` with `SWGeneratorProtocol` to create your generator.
  
    protocol SWGeneratorProtocol {
        var deserialzeProtocolName: String? {get}
        func generateClassBody (sw: SWClass) -> String
    }

**SWGeneratorView**  
  this is the ui  
  you need to add your new generator to `GenerateMethod` enum  
  
    enum GenerateMethod: Int {
      case JSONHelper     = 0
      case ObjectMapper   = 1
    }
  
  and lastly update `generate:` method's `switch` statement which initilizes the `SWGenertor` by selection from dropdown menu.   
    
    switch method {
      case .JSONHelper:
          gen = JSONHelperGenerator ()
          
      case .ObjectMapper:
          gen = ObjectMapperGenerator ()
    }


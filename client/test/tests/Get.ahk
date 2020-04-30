#include Test.class.ahk

class Get_Tests {

  run() {
    this.Test_1.run()
    this.Test_2.run()
    this.Test_3.run()
  }

  class Test_1 extends Test {
    static name := "Get one property"
    static function_name := "leya.get"

    test() {
      req := leya.get(TABLE_NAME, "kevgk", "age")

      if (req.data.age == "27") {
        this.pass()
      }
      else {
        this.fail()
      }
    }
  }

  class Test_2 extends Test {
    static name := "Get some properties"
    static function_name := "leya.get"

    test() {
      req := leya.get(TABLE_NAME, "kevgk", "name, role")

      if (req.data.name == "kevgk" && req.data.role == "developer") {
        this.pass()
      }
      else {
        this.fail()
      }
    }
  }

  class Test_3 extends Test {
    static name := "Get all properties"
    static function_name := "leya.get"

    test() {
      req := leya.get(TABLE_NAME, "kevgk", "*")

      if (req.data.age == "27" && req.data.role == "developer") {
        this.pass()
      }
      else {
        this.fail()
      }
    }
  }

}

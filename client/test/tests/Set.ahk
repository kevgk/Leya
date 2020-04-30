#include Test.class.ahk

class Set_Tests {

  run() {
    this.Test_1.run()
  }

  class Test_1 extends Test {
    static name := "Set one property"
    static function_name := "leya.set"

    test() {
      leya.set(TABLE_NAME, "kevgk", "age", 33)
      req := leya.get(TABLE_NAME, "kevgk", "age")

      if (req.data.age == 33) {
        this.pass()
      }
      else {
        this.fail()
      }
    }
  }

}

class Test {
  name := ""
  function_name := ""

  before() {
    leya.deleteTable(TABLE_NAME)
    leya.createTable(TABLE_NAME, "name, age, role")
    leya.createRow(TABLE_NAME, "kevgk")
    leya.set(TABLE_NAME, "kevgk", "age", 27)
    leya.set(TABLE_NAME, "kevgk", "role", "developer")
  }

  after() {
    leya.deleteTable(TABLE_NAME)
  }

  run() {
    this.before()
    this.test()
    this.after()
  }

  pass() {
    LV_Add(, "PASSED", this.function_name, this.name)
  }

  fail() {
    LV_Add("", "FAILED", this.function_name, this.name)
  }
}
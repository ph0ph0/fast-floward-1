pub contract Hello {

    

    pub fun sayHi(to name: String): String {
        let greeting = "Hi, ".concat(name)

        return greeting

    }

}
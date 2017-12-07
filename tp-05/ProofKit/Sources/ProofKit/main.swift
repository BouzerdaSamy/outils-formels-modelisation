import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let f1 = ((a && b) || !(a || c))
let f2 = !(a && (a || b || c))
let f3 = (a => b) || !(a && c)

print("Tests des DNF, CNF et NNF")
print("formule f1")
print ("forme négative NNF:")
print(f1.nnf)
print("Forme conjoctive CNF:")
print(f1.cnf)
print("Forme disjoctive DNF:")
print (f1.dnf)
print("formule f2")
print ("forme négative NNF:")
print(f2.nnf)
print("Forme conjoctive CNF:")
print(f2.cnf)
print("Forme disjoctive DNF:")
print(f2.dnf)
print("formule f3")
print ("forme négative NNF:")
print(f3.nnf)
print("Forme conjoctive CNF:")
print(f3.cnf)
print("Forme disjoctive DNF:")
print(f3.dnf)


/*
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let f = a && b
let f1 = !(a && (b || c))
let f2 = (a => b) || !(a && c)
let f3 = (!a || b && c) && a


print(f1.nnf)
print(f2.nnf)
print(f3.nnf)


let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)
*/

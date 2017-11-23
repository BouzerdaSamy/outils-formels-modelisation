import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.
<<<<<<< HEAD
    print("Exercice 4.1  (consigne: compter le nombre d'états dans un graphe de marquage à partir d'un seul noeud)")
    print(markingGraph.nombreEtats(input: markingGraph))
    print("\nExercice 4.2  (consigne: savoir si deux fumeurs peuvent fumer en même temps)")
    print(markingGraph.doubleFumeur(input: markingGraph))
    print("\nExercice 4.3  (consigne: savoir si'il est possible d'avoir deux fois le même ingrédients sur la table")
    print(markingGraph.doubleIngred(input: markingGraph))
=======
>>>>>>> ee6546874a27e95ab135b3a6cdedabe6c7b6641d
}

import PetriKit

public extension PTNet {
    // Transforme un marquage pour le graphe de couverture en un marquage tirable
    public func coverabilityToPTMarking(with marking : CoverabilityMarking, and p : [PTPlace]) -> PTMarking{
      var m : PTMarking = [:]

      for obj in p
      {
        let mark = correctValue(to : marking[obj]!)!
        m[obj] = mark
      }
      return m
    }

    // Transforme un marquage tirable en un marquage pour le graphe de couverture
    public func ptmarkingToCoverability(with marking: PTMarking, and p : [PTPlace]) ->CoverabilityMarking{
      var obj : CoverabilityMarking = [:]
      for val in p
      {
        obj[val] = .some(marking[val]!)
        if(500 < obj[val]!)
        {
          obj[val] = .omega
        }
      }
      return obj
    }

    // Permet de corriger les erreurs pouvant empêcher le tirage (présence du omega)
    public func correctValue(to t: Token) -> UInt? {
      if case .some(let value) = t {
        return value
      }
      else {
        return 1000
      }
    }

    // Vérfie si un noeud est contenu dans la liste
    public func verify(at marking : [CoverabilityMarking], to markingToAdd : CoverabilityMarking) -> Int
    {
      var value = 0
      for j in 0...marking.counter-1
      {
        if (marking[j] == markingToAdd)
        {
          value = 1
        }
        if (markingToAdd > marking[j])
        {
          value = j+2}
      }
      return value
    }

    // Permet l'ajout de omega en tant que token si nécessaire
    public func Omega(from comp : CoverabilityMarking, with marking : CoverabilityMarking, and p : [PTPlace])  -> CoverabilityMarking?
    {
      var obj = marking
      for t in p
      {
        if (comp[t]! < obj[t]!)
        {
          obj[t] = .omega
        }
      }
      return obj
    }

    public func coverabilityGraph(from marking0: CoverabilityMarking) -> CoverabilityGraph? {
        // Write here the implementation of the coverability graph generation.
        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.
        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into accounter to
        // evaluate your homework.
        // Transformation en array des set des transitions et places
        var currentTransitions = Array (transitions) // sort les valeurs de l'array
        currentTransitions.sort{$0.name < $1.name}
        let currentPlaces = Array(places)
        // Initialisation des valeurs
        var markingList : [CoverabilityMarking] = [marking0]
        var graphList : [CoverabilityGraph] = []
        var mark: CoverabilityMarking
        let finalGraph = CoverabilityGraph(marking: marking0, successors: [:])
        var counter = 0
        // Boucle principale qui s'arrête quand counter est supérieur à la taille de la liste des marquages
        while(counter < markingList.counter)
        {
          // Seconde boucle qui itère les transitions et créée les marquages du graphe de couverture
          for transition in currentTransitions{
            // Transforme le marquage en quelque chose de tirable
            let ptMarking = coverabilityToPTMarking(with: markingList[counter], and: currentPlaces)
            if let firedTran = transition.fire(from: ptMarking){
              // Reconvertit en marquage pour le graphe de couverture
              let convMarking = ptmarkingToCoverability(with: firedTran, and: currentPlaces)
              // // Crée le noeud du marquage
              let newNode = CoverabilityGraph(marking: convMarking, successors: [:])
              // Ajoute le nouveau noeud au successeur
              finalGraph.successors[transition] = newNode
            }
            // condition: si le successeur existe,
            if(finalGraph.successors[transition] != nil){
              // on ajoute son marquage à la variable mark
              mark = finalGraph.successors[transition]!.marking
              // On vérifie si il est contenu dans la liste
              let current = verify(at: markingList, to: mark)
              if (current != 1)
              {
                if (current > 1)
                {
                  mark = Omega(from : markingList[current-2], with : mark, and : currentPlaces)!
                }
                 // On ajoute le noeud à la première liste
                graphList.append(finalGraph)
                // On ajoute son marquage à la deuxième liste
                markingList.append(mark)
              }
            }
          }
          counter = counter + 1
        }
        return finalGraph
      }
}

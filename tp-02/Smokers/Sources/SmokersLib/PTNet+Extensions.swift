import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTtransitsition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTtransitsition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }



    public extension PTNet {
      public func markingGraph(from marking: PTMarking) -> MarkingGraph? {

          let marquageInitial = MarkingGraph(marking: marking)
          let transitions = self.transitions
          var marquageVisite : [MarkingGraph] = []
          var marquageAVisiter : [MarkingGraph] = [marquageInitial]



          while(!marquageAVisiter.isEmpty) {

              let marquageAct = marquageAVisiter.removeFirst()
              marquageVisite.append(marquageAct)

              for transit in transitions {

                  if let marquageNouveau = transit.fire(from: marquageAct.marking) {

                          if let noeudVisite = marquageVisite.first(where: { $0.marking == marquageNouveau }) {
                              marquageAct.successors[transit] = noeudVisite

                        } else {

                              let trouve = MarkingGraph(marking: marquageNouveau)
                              marquageAct.successors[transit] = trouve
                              if (!marquageAVisiter.contains(where: { $0.marking == trouve.marking})) {
                                  marquageAVisiter.append(trouve)
                              }
                      }
                  }
              }
          }
          return marquageInitial
      }
    }


    //Exercice 4.1  (consigne: compter le nombre d'états dans un graphe de marquage à partir d'un seul noeud)


    public func nombreEtats(input:MarkingGraph) -> Int{

      var marquageAVisiter: [MarkingGraph] = [input]
      var marquageVisite: [MarkingGraph] = []


      while let marquageActuel = marquageAVisiter.popLast(){

        marquageVisite.append(marquageActuel)
        for (_, successor) in marquageActuel.successors{

          if !marquageVisite.contains(where: {$0 === successor}) && !marquageAVisiter.contains(where: {$0 === successor}){
            marquageAVisiter.append(successor)
          }
        }
      }
      return marquageVisite.count
    }

      //Exercice 4.2  (consigne: savoir si deux fumeurs peuvent fumer en même temps)

    public func doubleFumeur(input:MarkingGraph) -> Bool{

      var marquageVisite: [MarkingGraph] = []
      var marquageAVisiter: [MarkingGraph] = [input]

      while let marquageActuel = marquageAVisiter.popLast(){

        marquageVisite.append(marquageActuel)
        for (place, jeton) in marquageActuel.marking{

            var nombresFumeurs = 0;
            for (place, jeton) in marquageActuel.marking {
                if (place.name == "s1" || place.name == "s2" || place.name == "s3"){
                    nombresFumeurs += Int(jeton)
            }
          }
            if (nombresFumeurs > 1) {
            return true
          }
        }
        for (_, successor) in marquageActuel.successors{
            if !marquageVisite.contains(where: {$0 === successor}) && !marquageAVisiter.contains(where: {$0 === successor}){
                marquageAVisiter.append(successor)
          }
        }
      }
      return false
    }

      //Exercice 4.3  (consigne: savoir si'il est possible d'avoir deux fois le même ingrédients sur la table

    public func doubleIngred(input:MarkingGraph) -> Bool{

      var marquageVisite: [MarkingGraph] = []
      var marquageAVisiter: [MarkingGraph] = [input]

      while let marquageActuel = marquageAVisiter.popLast(){

        marquageVisite.append(marquageActuel)
        for (place, jeton) in marquageActuel.marking{

            if place.name == "p" || place.name == "m" || place.name == "t"{
                if(jeton > 1){
                return true
            }
          }
        }
        for (_, successor) in marquageActuel.successors{
          if !marquageVisite.contains(where: {$0 === successor}) && !marquageAVisiter.contains(where: {$0 === successor}){
            marquageAVisiter.append(successor)
          }
        }
      }
      return false
    }

}

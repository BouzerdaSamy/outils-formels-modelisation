import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {

        let MarquageInit:MarkingGraph = MarkingGraph(marking: marking)
        var MarquageVisite:[MarkingGraph] = [MarquageInit]
        var MarquageAVisiter:[MarkingGraph] = [MarquageInit]



        while let currentMarquage = MarquageAVisiter.popLast(){
          MarquageVisite.append(currentMarquage)
          for transit in transitions{
            if let transitTiree = transit.fire(from: currentMarquage.marking){
              if let visited = MarquageVisite.first(where: {$0.marking == transitTiree}){
                currentMarquage.successors[transit] = visited
              } else{
                let MarquageDecouvert:MarkingGraph = MarkingGraph(marking: transitTiree)
                if !MarquageVisite.contains{$0 === MarquageDecouvert}{
                  currentMarquage.successors[transit] = MarquageDecouvert
                  MarquageAVisiter.append(MarquageDecouvert)
                }
              }
            }
          }
        }
        print("\(MarquageVisite)")
        return MarquageInit
    }

}

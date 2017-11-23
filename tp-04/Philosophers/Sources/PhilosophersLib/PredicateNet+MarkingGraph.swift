extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
        // Write your code here ...
        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.

        let depart = PredicateMarkingNode<T>(marking: marking) // Définition des variables initiales
        var noeudAVisiter: [PredicateMarkingNode<T>] = [depart]

        while(!noeudAVisiter.isEmpty){ //on boucle jusqu'à qu'il n'y ait plus de noeud à visiter
            let node = noeudAVisiter.popLast()!
            for thisTransition in transitions { //on boucle jusqu'à qu'il n'y ait plus de transitions dans le noeud courant
              node.successors[thisTransition] = [:]   // Définition des successeurs
              let binding: [PredicateTransition<T>.Binding] = thisTransition.fireableBingings(from: node.marking) //binding des transitions du marquage courant
              for contrainte in binding{  //on boucle jusqu'à qu'il n'y ait plus de contrainte dans le binding courant
                let nouveauMarquage = PredicateMarkingNode(marking: thisTransition.fire(from: node.marking, with:contrainte)!) // On tire la transition en utilisant le binding courant, la transition courante et le marquage courant
                for thisMarquage in depart{   //on reboucle jusqu'à qu'il n'y ait plus de marquage
                    if (PredicateNet.greater(nouveauMarquage.marking, thisMarquage.marking))  // On teste si le nouveau marquage est plus grand qu'un autre marquage quelconque de départ
                    {
                        return nil  // On retourne une valeur nulle (nil)
                    }
                }
                if let marquageVisite = depart.first(where:{PredicateNet.equals($0.marking, nouveauMarquage.marking)})   // on check si on a déjà été visité le marquage
                {
                    node.successors[thisTransition]![contrainte] = marquageVisite   // ajout du marquage au successeurs
                }else if(!noeudAVisiter.contains(where: { PredicateNet.equals($0.marking, nouveauMarquage.marking) })) {
                    noeudAVisiter.append(nouveauMarquage)  // Ajoute  du marquage à la liste des noeuds à visiter
                    node.successors[thisTransition]![contrainte] = nouveauMarquage // Ajoute  du marquage au successeurs
                }
              }
            }
        }
        return depart
    }
    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard tokens.filter({ $0 == t }).count == rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}

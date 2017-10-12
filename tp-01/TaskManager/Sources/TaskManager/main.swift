//Bouzerda Samy
//TP 1
//Outils formels de modélisation
import TaskManagerLib

// Ex 3
print("Ex 3")

let taskManager = createTaskManager()
// Importing tansitions and places from taskManager
let create = taskManager.transitions.first{$0.name == "create"}!
let spawn = taskManager.transitions.first{$0.name == "spawn"}!
let exec = taskManager.transitions.first{$0.name == "exec"}!
let success = taskManager.transitions.first{$0.name == "success"}!
let fail = taskManager.transitions.first{$0.name == "fail"}!

let taskPool = taskManager.places.first{$0.name == "taskPool"}!
let processPool = taskManager.places.first{$0.name == "processPool"}!
let inProgress = taskManager.places.first{$0.name == "inProgress"}!

// Executions that lead to a problem
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print("m1 (create) ",m1!)
let m2 = spawn.fire(from: m1!)
print("m2 (spawn) ",m2!)
let m3 = spawn.fire(from: m2!)
print("m3 (spawn)",m3!) // m1-m3 : Create 1 token in taskPool and 2 tokens in processPool
let m4 = exec.fire(from: m3!)
print("m4 (exec) ",m4!)
let m5 = exec.fire(from: m4!)
print("m5 (exec)",m5!) // m4-m5 : Two execution because 2 tokens
let m6 = success.fire(from: m5!)
print("m6 (success) ",m6!) // Successfull case
// There is a problem, one token left in inProgress
// It only can fail but task got deleleted from taskPool

//Ex 4
print("Ex 4")
let correctTaskManager = createCorrectTaskManager()
// Importing tansitions and places from correctTaskManager
let create2 = correctTaskManager.transitions.first{$0.name == "create"}!
let spawn2 = correctTaskManager.transitions.first{$0.name == "spawn"}!
let exec2 = correctTaskManager.transitions.first{$0.name == "exec"}!
let success2 = correctTaskManager.transitions.first{$0.name == "success"}!
let fail2 = correctTaskManager.transitions.first{$0.name == "fail"}!

let taskPool2 = correctTaskManager.places.first{$0.name == "taskPool"}!
let processPool2 = correctTaskManager.places.first{$0.name == "processPool"}!
let inProgress2 = correctTaskManager.places.first{$0.name == "inProgress"}!
let progression = correctTaskManager.places.first{$0.name == "progression"}!

// Executions showing how to solve the problem
let m11 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, progression: 0])
print("m1 (create) ",m11!)
let m12 = spawn2.fire(from: m11!)
print("m2 (spawn) ",m12!)
let m13 = spawn2.fire(from: m12!)
print("m3 (spawn)",m13!) // m1-m3 : m1-m3 : Like before, Create 1 token in taskPool and 2 tokens in processPool
let m14 = exec2.fire(from: m13!)
print("m4 (exec) ",m14!) // m4 : In this new case only one execution is possible
let m15 = success2.fire(from: m14!)
print("m5 (success) ",m15!) // Successfull case
let m16 = fail2.fire(from: m14!)
print("m5 (fail) ",m16!) // Failure case
// We correct the error by blocking the exucution to 1 task for 1 process
// by adding a new place "progression"
// So it's possible to do only one execution
// Successfull and failure case are used at the same level(right after "exec") to show each case after execution

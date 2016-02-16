//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Marco Monteiro on 1/12/15.
//  Copyright (c) 2015 Marco Monteiro. All rights reserved.
//

import Foundation

class CalculatorBrain: CustomStringConvertible
{
    
    //This enum is essential because the stack that keeps track of the buttons pressed stores ops. This enum lets both the multiplication symbol, and a number to be stored in teh same stack.
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case Symbol(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case PiOperation(String, ()-> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Symbol(let operand):
                    return operand
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .PiOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //Stores buttons pressed
    private var opStack = Array<Op>()
    
    private var knownOps = Dictionary<String, Op>()
    
    private var variableValues = Dictionary<String, Double>()
    
    
    //Used to print the operations at the top of the calculator
    var description: String {
        get {
            var newOpStack = opStack
            let (result, remainder) = setDescriptionHelper(newOpStack)
            if let output = result {
                return (output+"=")
            }
            return ""
        }
    }
    
    init () {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["cos"] = Op.UnaryOperation("cos") { cos($0) }
        knownOps["sin"] = Op.UnaryOperation("sin") { sin($0) }
        knownOps["∏"] = Op.PiOperation("∏") {return M_PI}
        knownOps["M"] = Op.Symbol("M")
    }
    
    var program: AnyObject { //guaranteed to be a PropertyList
        get {
            var returnValue = Array<String>()
            for op in opStack {
                returnValue.append(op.description)
            }
            return returnValue
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                   
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
            
        }
    }
    
    //This recursive function is the core of the calculator brain
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Symbol(let symbol) :
                if let value = variableValues[symbol] {
                    return (value, remainingOps)
                }
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        
                    }
                }
            case .PiOperation(_, let operation):
                return (operation(), remainingOps)
                
            }
        }
        return (nil, ops)
        
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
        
    }
    
    func pushOperand (operand: Double)  -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand (symbol:String) -> Double? {
        opStack.append(Op.Symbol(symbol))
        return evaluate()
        
    }
    
    func performOperation (symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func setVariableM (value: Double) {
        variableValues["M"]=value
    }
    
    func clear () {
        opStack.removeAll()
        variableValues.removeAll()
    }
    
    
    //This recrusive function is the core to printing out the operations so far in a proper syntax. It is very similar ot evaluate
    private func setDescriptionHelper(ops: [Op]) -> (result: String?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {

            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let operation,_):
                let operandEvaluation = setDescriptionHelper(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation + "("+"\(operand)"+")", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let operation,_):
                let op1Evaluation = setDescriptionHelper(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = setDescriptionHelper(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return ("("+"\(operand2)"+operation+"\(operand1)"+")", op2Evaluation.remainingOps)
                        
                    }
                }
            case .Symbol(let symbol):
                return (symbol,remainingOps)
            case .PiOperation(let operation,_):
                return ("∏", remainingOps)
                
            }
        }
        return (nil, ops)
        
    }
    
    
    
}
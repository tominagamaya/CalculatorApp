//
//  ViewController.swift
//  CalculatorApp
//
//  Created by maya tominaga on 2017/11/06.
//  Copyright © 2017年 maya tominaga. All rights reserved.
//

import UIKit
import Expression

class ViewController: UIViewController {
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ロードされた時点では式と答えのラベルを空にする
        formulaLabel.text = ""
        answerLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func inputFormula(_ sender: UIButton) {
        // Cと＝以外のボタンを押されたときに式を表示する
        guard let formulaText = formulaLabel.text else {
            return
        }
        guard let senderedText = sender.titleLabel?.text else {
            return
        }
        formulaLabel.text = formulaText + senderedText
    }    
    @IBAction func calculateAnswer(_ sender: UIButton) {
        guard let formulaText = formulaLabel.text else {
            return
        }
        let formula: String = formatFormula(formulaText)
        answerLabel.text = evalFormula(formula)
    }
    @IBAction func clearCalculation(_ sender: UIButton) {
        // Cボタンが押されたらクリアする
        formulaLabel.text = ""
        answerLabel.text = ""
    }
    
    private func formatFormula(_ formula: String) -> String {
        // 入力された整数に.0を追加する
        let formattedFormula: String = formula.replacingOccurrences(
            of: "(?<=^|[÷×\\+\\-\\(])([0-9]+)(?=[÷×\\+\\-\\)]|$)",
            with: "$1.0",
            options: NSString.CompareOptions.regularExpression,
            range: nil
            ).replacingOccurrences(of: "÷", with: "/").replacingOccurrences(of: "×", with: "*")
        return formattedFormula
    }
    
    private func evalFormula(_ formula: String) -> String {
        do {
            // 計算する
            let expression = Expression(formula)
            let answer = try expression.evaluate()
            return formatAnswer(String(answer))
        }catch{
            // 計算式が正しくなかった場合
            return "式を正しく入力してください"
        }
    }
    
    private func formatAnswer(_ answer: String) -> String {
        // 答えの小数点以下が0だった場合は0を削除して表示する
        let formattedAnswer: String = answer.replacingOccurrences(
            of: "\\.0$",
            with: "",
            options: NSString.CompareOptions.regularExpression,
            range: nil
        )
        return formattedAnswer
    }
}


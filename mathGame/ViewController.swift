import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var numOfQuestionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var aBtn: UIButton!
    @IBOutlet weak var bBtn: UIButton!
    @IBOutlet weak var cBtn: UIButton!
    @IBOutlet weak var dBtn: UIButton!
    @IBOutlet weak var playAgainButton: Button!
    
    //題數(都是從第一題開始)
    var numOfQuestion = 1
    //分數
    var score = 0
    //判斷是否能作答
    var canAnswer = true
    
    //算式array
    var operations = ["+","-","x","÷"]
    //答案array
    var answerList = [Int]()
    
    //正確答案選項
    var answer = 0
    //其他三個錯誤選項
    var option1 = 0
    var option2 = 0
    var option3 = 0
    
    //答對的次數
    var correctTime = 0
    //答錯的次數
    var wrongTime = 0
    //comboTime的次數
    var comboTime = 0
    
    //計時
    var timer = Timer()
    var time = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerImageView.isHidden = true
        playAgainButton.isHidden = true
        scoreLabel.text = "Score: \(score)"
        countdownTime()
        calculate()
    }
    
    //計算
    func calculate() {
        //判斷計算符號，直接從operations array中隨機取出
        switch operations[Int.random(in: 0...3)] {
        case "+":
            //避免相加超出三位數(相加最大值到999)
            var addNumber1 = Int.random(in: 200...499)
            var addNumber2 = Int.random(in: 200...500)
            questionLabel.text = "\(addNumber1) + \(addNumber2)"
            answer = addNumber1 + addNumber2
        case "-":
            //避免減出負數，所以minusNumber1 > minusNumber2
            var minusNumber1 = Int.random(in: 500...999)
            var minusNumber2 = Int.random(in: 1...500)
            questionLabel.text = "\(minusNumber1) - \(minusNumber2)"
            answer = minusNumber1 - minusNumber2
        case "x":
            var multiplyNumber1 = Int.random(in: 1...99)
            var multiplyNumber2 = Int.random(in: 1...9)
            questionLabel.text = "\(multiplyNumber1) x \(multiplyNumber2)"
            answer = multiplyNumber1 * multiplyNumber2
        case "÷":
            //除法則是用回推法，就能自動挑出無餘數的整數(如：15/3=5，則利用3*5得出被除數15)
            var divideNumber2 = Int.random(in: 10...20)
            answer = Int.random(in: 10...20)
            var divideNumber1 = divideNumber2 * answer
            questionLabel.text = "\(divideNumber1) ÷ \(divideNumber2)"
        default:
            break
        }
        setOperations()
        numOfQuestionLabel.text = "第\(numOfQuestion)題 / 10"
    }
    
    func setOperations() {
        //讓三個錯誤選項隨機整數
        option1 = Int.random(in: 1...999)
        option2 = Int.random(in: 1...999)
        option3 = Int.random(in: 1...999)
        //將答案、和三個錯誤選項加入answerLista array裡
        answerList = [answer,option1,option2,option3]
        //打亂answerList array
        answerList.shuffle()
        //放到對應的位置編號
        aBtn.setTitle("\(answerList[0])", for: .normal)
        bBtn.setTitle("\(answerList[1])", for: .normal)
        cBtn.setTitle("\(answerList[2])", for: .normal)
        dBtn.setTitle("\(answerList[3])", for: .normal)
    }
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        //若不能再作答了，就跳出
        if !canAnswer {
            return
        }
        
        //判斷是否選到正確答案
        if sender.currentTitle == String(answer) {
            answerImageView.isHidden = false
            answerImageView.image = UIImage(named: "correctAnswerImage")
            correctTime += 1
            comboTime += 1
            //判斷是否達到comboTime
            if comboTime >= 3 {
                score += 30
                resultLabel.text = "COMBO TIME!"
            }else{
                score += 10
            }
        }else{
            comboTime = 0
            resultLabel.text = ""
            answerImageView.isHidden = false
            answerImageView.image = UIImage(named: "wrongAnswerImage")
            score -= 10
            wrongTime += 1
        }
        
        //判斷是否滿10題
        if numOfQuestion < 10 {
            numOfQuestion += 1
            scoreLabel.text = "Score: \(score)"
            calculate()
        }else{
            showGrade()
            playAgainButton.isHidden = false
        }
    }
    
    //顯示分數
    func showGrade() {
        //先讓時間停止
        timer.invalidate()
        //不能再作答
        canAnswer = false
        scoreLabel.text = "Score: \(score)"
        resultLabel.text = """
            結束！
            \(numOfQuestion)題內答對\(correctTime)次，答錯\(wrongTime)次
            """
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        canAnswer = true
        score = 0
        questionLabel.text = ""
        numOfQuestion = 1
        wrongTime = 0
        correctTime = 0
        comboTime = 0
        numOfQuestionLabel.text = "第\(numOfQuestion)題 / 10"
        answerImageView.isHidden = true
        scoreLabel.text = "Score: \(score)"
        resultLabel.text = ""
        calculate()
        setOperations()
        countdownTime()
        updateTimer()
        playAgainButton.isHidden = true
    }
    
    //倒數
    func countdownTime() {
        time = 21
        //讓最一開始宣告的timer停止
        timer.invalidate()
        //再宣告出新的timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //更新計時器
    @objc func updateTimer() {
        time -= 1
        if time != 0 {
            timeLabel.text = String(time)
        }else{
            //時間到了，未做完，showGrade()
            numOfQuestion -= 1
            timer.invalidate()
            timeLabel.text = "0"
            playAgainButton.isHidden = false
            showGrade()
        }
    }
}


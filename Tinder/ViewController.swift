//
//  ViewController.swift
//  Tinder
//
//  Created by 日向野卓也 on 2018/08/13.
//  Copyright © 2018年 takuya.higano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var basicCard: UIView!
  @IBOutlet weak var likeImageView: UIImageView!
  
  @IBOutlet weak var person1: UIView!
  @IBOutlet weak var person2: UIView!
  @IBOutlet weak var person3: UIView!
  @IBOutlet weak var person4: UIView!
  
  
  var centerOfCard:CGPoint!
  var people = [UIView]()
  var selectedCardCount: Int = 0
  
  let name = ["ほのか", "あかね", "みほ", "カルロス"]
  var likeName = [String]()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    centerOfCard = basicCard.center
    people.append(person1)
    people.append(person2)
    people.append(person3)
    people.append(person4)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func resetCard() {
    basicCard.center = self.centerOfCard
    basicCard.transform = .identity
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PushList" {
        let vc = segue.destination as! ListViewController
        vc.likeName = likeName
    }
  }

  @IBAction func likeButtonTapped(_ sender: UIButton) {
    UIView.animate(withDuration: 0.2, animations: {
      self.resetCard()
      self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 500, y: self.people[self.selectedCardCount].center.y)
    })
    likeImageView.alpha = 0
    likeName.append(name[selectedCardCount])
    selectedCardCount += 1
    if selectedCardCount >= people.count {
      performSegue(withIdentifier: "PushList", sender: self)
    }
    
    
  }
  
  @IBAction func dislikeButtonTapped(_ sender: UIButton) {
    
    UIView.animate(withDuration: 0.2, animations: {
      self.resetCard()
      self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 500, y: self.people[self.selectedCardCount].center.y)
    })
    likeImageView.alpha = 0
    selectedCardCount += 1
    if selectedCardCount >= people.count {
      // セグエの実行
      performSegue(withIdentifier: "PushList", sender: self)
    }
    
  }
  
  @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
    let card = sender.view!
    // スワイプした度合い（位置情報）を定数に格納
    let point = sender.translation(in: view)
    
    card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
    people[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
    // 角度を変える
    let xFromCenter = card.center.x - view.center.x
    card.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * 0.785)
    people[selectedCardCount].transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 2) * 0.785)
    
    if xFromCenter > 0 {
      likeImageView.image = #imageLiteral(resourceName: "good")
      likeImageView.alpha = 1
      likeImageView.tintColor = UIColor.red
    } else if xFromCenter < 0 {
      likeImageView.image = #imageLiteral(resourceName: "bad")
      likeImageView.alpha = 1
      likeImageView.tintColor = UIColor.blue
    }
    
    if sender.state == UIGestureRecognizerState.ended {
      // 大きく左にスワイプした場合の処理
      if card.center.x < 75 {
        UIView.animate(withDuration: 0.2, animations: {
            self.resetCard()
            self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x - 250, y: self.people[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0
        selectedCardCount += 1
        if selectedCardCount >= people.count {
            // セグエの実行
            performSegue(withIdentifier: "PushList", sender: self)
        }
        return
        
        // 大きく右にスワイプした場合の処理
      } else if card.center.x > self.view.frame.width - 75 {
        UIView.animate(withDuration: 0.2, animations: {
          self.resetCard()
          self.people[self.selectedCardCount].center = CGPoint(x: self.people[self.selectedCardCount].center.x + 250, y: self.people[self.selectedCardCount].center.y)
        })
        likeImageView.alpha = 0
        likeName.append(name[selectedCardCount])
        selectedCardCount += 1
        if selectedCardCount >= people.count {
            performSegue(withIdentifier: "PushList", sender: self)
        }
        return
      }
      
      // もとに戻る処理
      UIView.animate(withDuration: 0.2, animations: {
        self.resetCard()
        self.people[self.selectedCardCount].center = self.centerOfCard
        self.people[self.selectedCardCount].transform = .identity
      })
      likeImageView.alpha = 0
    }
  }
}

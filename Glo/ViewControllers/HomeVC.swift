//
//  HomeVC.swift
//  Glo
//
//  Created by Kevin on 3/8/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit
import KeychainAccess

class HomeVC: UIViewController {
    
    private var viewModel: HomeViewModel! {
        didSet {
            setViews()
        }
    }
    
    @IBOutlet var selectedBoardbutton: UIButton!
    @IBOutlet var columnScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AuthManager.authenticate { [weak self] success, error in
            guard let strongSelf = self else { return }
            
            // User not authenticated, display auth view
            if error != nil {
                DispatchQueue.main.async {
                    strongSelf.performSegue(withIdentifier: "Authenticate", sender: self)
                }
            // User is authenticated, get data
            } else {
                strongSelf.loadBoards()
            }
        }
        columnScrollView.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "Authenticate":
            let dest = segue.destination as! AuthVC
            dest.authDelegate = self
        case "CardDetails":
            let dest = segue.destination as! CardDetailsVC
            dest.savedCardDelegate = self
            dest.card = sender as? Card
        case "NewCard":
            print(pageControl.currentPage)
            let dest = segue.destination as! CardDetailsVC
            dest.savedCardDelegate = self
            dest.card = Card(id: nil, name: "Title", description: nil, labelIDs: [], assigneeIDs: [])
            dest.card.board = viewModel.getSelectedBoard()
            // We are checking that a column exists for this page in the "addCardAction" so the next line is safe
            dest.card.column = viewModel.getColumnsForSelectedBoard()[pageControl.currentPage]
        default:
            break
        }
    }
    
    @IBAction func addCardAction(_ sender: Any) {
        print(pageControl.currentPage)
        if pageControl.currentPage < viewModel.getColumnsForSelectedBoard().count {
            self.performSegue(withIdentifier: "NewCard", sender: self)
        } else {
            self.displayErrorAlertWithOK(title: "Error", message: "Cannot add card to board with no columns")
        }
    }
    
    
    @IBAction func changeBoardAction(_ sender: Any) {
        columnScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        let alert = UIAlertController(title: "Boards", message: nil, preferredStyle: .actionSheet)
        
        for (index, board) in viewModel.boards.enumerated() {
            let action = UIAlertAction(title: board.name, style: .default) { [weak self] action in
                guard let strongSelf = self else { return }
                strongSelf.loadCardsForSelectedBoard(index: index)
            }
            alert.addAction(action)
        }
        
        self.present(alert, animated: true)
    }
    
    private func loadCardsForSelectedBoard(index: Int) {
        self.showLoadingScreen(message: "Loading...") {
            self.viewModel.changeSelectedBoard(index: index) {
                self.dismiss(animated: true, completion:  nil)
                self.setViews()
            }
        }
    }
    
    private func loadBoards() {

        self.showLoadingScreen(message: "Loading Data") {
            GloNetworking.getBoards { [weak self] boards in
                guard let strongSelf = self else { return }
                
                strongSelf.viewModel = HomeViewModel(boards: boards)
                if boards.count > 0 {
                    strongSelf.viewModel.changeSelectedBoard(index: 0) {
                        strongSelf.dismiss(animated: true, completion:  nil)
                        strongSelf.setViews()
                    }
                }
            }
        }
    }
    
    
    private func setViews() {
        DispatchQueue.main.async {
            
            self.selectedBoardbutton.setTitle(self.viewModel.getNameForSelectedBoard(), for: .normal)
            let columns = self.createColumns()
            self.setupSlideScrollView(slides: columns)
            self.pageControl.numberOfPages = columns.count
        }
    }
    
    
    func setupSlideScrollView(slides : [ColumnView]) {
        columnScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count),
                                              height: columnScrollView.frame.height)
        columnScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i),
                                     y: 0,
                                     width: view.frame.width,
                                     height: columnScrollView.frame.height)
            columnScrollView.addSubview(slides[i])
        }
    }
    
    
    func createColumns() -> [ColumnView] {
        var columnViews: [ColumnView] = []
        for column in viewModel.getColumnsForSelectedBoard() {
            let columnView = Bundle.main.loadNibNamed("ColumnView", owner: self, options: nil)?.first as! ColumnView
            columnView.column = column
            columnView.selectedCardDelegate = self
            columnViews.append(columnView)
        }
        
        return columnViews
    }
}

extension HomeVC: GloAuthenticated {
    func wasAuthenticated() {
        loadBoards()
    }
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension HomeVC: SelectedCard {
    func selectedCard(card: Card) {
        self.performSegue(withIdentifier: "CardDetails", sender: card)
    }
}

extension HomeVC: SavedCard {
    func savedCard(card: Card) {
        self.viewModel.updateCard(card: card)
        self.setViews()
    }
    
    func savedNewCard(card: Card) {
        self.viewModel.addCard(card: card)
        self.setViews()
    }
}

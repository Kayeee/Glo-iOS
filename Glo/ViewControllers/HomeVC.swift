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
                strongSelf.loadData()
            }
        }
        columnScrollView.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Authenticate" {
            let dest = segue.destination as! AuthVC
            dest.authDelegate = self
        }
    }
    
    
    @IBAction func addCardAction(_ sender: Any) {
        print("Add Card Action")
    }
    
    
    @IBAction func changeBoardAction(_ sender: Any) {
        let alert = UIAlertController(title: "Boards", message: nil, preferredStyle: .actionSheet)
        
        for (index, board) in viewModel.boards.enumerated() {
            let action = UIAlertAction(title: board.name, style: .default) { action in
                self.viewModel.changeSelectedBoard(index: index)
                self.setViews()
            }
            alert.addAction(action)
        }
        
        self.present(alert, animated: true)
    }
    
    
    private func loadData() {
        self.showLoadingScreen(message: "Loading Data")
        
        GloNetworking.getBoards { [weak self] boards in
            guard let strongSelf = self else { return }
            
            strongSelf.dismiss(animated: true, completion: nil)
            strongSelf.viewModel = HomeViewModel(boards: boards)
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
        columnScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: columnScrollView.frame.height)
        columnScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            columnScrollView.addSubview(slides[i])
        }
    }
    
    
    func createColumns() -> [ColumnView] {
        var columnViews: [ColumnView] = []
        for column in viewModel.getColumnsForSelectedBoard() {
            let columnView = Bundle.main.loadNibNamed("ColumnView", owner: self, options: nil)?.first as! ColumnView
            columnView.column = column
            columnViews.append(columnView)
        }
        
        return columnViews
    }
}

extension HomeVC: GloAuthenticated {
    func wasAuthenticated() {
        loadData()
    }
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

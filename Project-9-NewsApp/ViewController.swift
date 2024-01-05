//
//  ViewController.swift
//  Project-9-NewsApp
//
//  Created by suhail on 22/09/23.
//

import UIKit
import SafariServices

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate  {
    
    @IBOutlet var tblNews: UITableView!{
        didSet{
            tblNews.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
        }
    }
    private let searchVC = UISearchController(searchResultsController: nil)
    var newsModel = [Article]()
    var viewModel = [NewsTableViewCellViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "News"
        tblNews.delegate = self
        tblNews.dataSource = self
        createSearchBar()
        
        APICaller.shared.getTopStories { result in
            switch result{
            case .success(let response):
                self.newsModel.append(contentsOf: response)
                self.viewModel = response.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? " No description", imageURL: URL(string: $0.urlToImage ?? "") )
                })
                DispatchQueue.main.async{
                    self.tblNews.reloadData()
                }
                
                break
            case .failure(let error):
                print(error)
            }
        }
    }

    func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        print(text)
        
        APICaller.shared.getSearchedHeadlines(with: text) { result in
            switch result{
            case .success(let response):
                self.newsModel.append(contentsOf: response)
                self.viewModel = response.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? " No description", imageURL: URL(string: $0.urlToImage ?? "") )
                })
                DispatchQueue.main.async{
                    self.tblNews.reloadData()
                }
                
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: viewModel[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = newsModel[indexPath.row].url
        
        guard let url = URL(string: urlString) else { return}
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

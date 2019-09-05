//
//  GenrePickerVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class GenrePickerVC: UIViewController {

    private var genreType: GenreType = .movie
    private var completion: ((_ selected: [Genre]) -> Void)
    private var selectedGenres = [Int: Genre]()
    private var genres: [Genre] = []

    private let genreView = GenrePickerView()

    private var didChangeSelection = false

    init(genreType: GenreType, completion: @escaping ((_ selected: [Genre]) -> Void), selected: [Genre]?) {
        self.genreType = genreType
        self.completion = completion
        if let selected = selected {
            for genre in selected {
                selectedGenres[genre.id] = genre
            }
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = genreView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        genres = genreType == .movie ? GenresData.getMovieGenres() : GenresData.getTVShowGenres()

        let tableView = genreView.tableView!
        tableView.register(GenreCell.self, forCellReuseIdentifier: GenreCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        genreView.doneBtn.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
    }

    @objc func doneAction(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)

        if didChangeSelection {
            var selected = [Genre]()
            for genre in selectedGenres.values {
                selected.append(genre)
            }
            completion(selected)
        }
    }
}


// MARK: - TableView DataSource & Delegate

extension GenrePickerVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let genre = genres[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreCell.reuseIdentifier, for: indexPath) as! GenreCell
        cell.set(name: genre.name, selected: selectedGenres[genre.id] != nil)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        didChangeSelection = true

        let genre = genres[indexPath.row]
        if let _ = selectedGenres[genre.id] {
            selectedGenres[genre.id] = nil
        } else {
            selectedGenres[genre.id] = genre
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

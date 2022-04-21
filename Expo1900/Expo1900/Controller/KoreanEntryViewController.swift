import UIKit

final class KoreanEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var koreanEntryTableView: UITableView!
    private var entries = [Entry]()
    private let cellIdentifier = "EntryCell"
    private let segueIdentifier = "SegueToDetail"
    private let parsingAssistant = ParsingAssistant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        koreanEntryTableView.delegate = self
        koreanEntryTableView.dataSource = self
        updateEntries()
    }
    
    private func updateEntries() {
        guard let decodedData: [Entry] = parsingAssistant.decodeContent(fileName: "items") else { return }
        entries = decodedData
    }
}

extension KoreanEntryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = entries[indexPath.row]
        guard let cell = self.koreanEntryTableView
            .dequeueReusableCell(withIdentifier: cellIdentifier,
                                            for: indexPath) as? KoreanEntryCell else {
            return UITableViewCell()
        }
        cell.configureCell(title: entry.name,
                           image: entry.imageName,
                           intro: entry.introduction)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = self.koreanEntryTableView.indexPath(for: cell) else { return }
            
            let entry = entries[indexPath.row]
            let entryDetailViewController = segue.destination as? EntryDetailViewController
            let detailContent = DetailContent(detailDescription: entry.description,
                                                      imageName: entry.imageName,
                                               koreanEntryTitle: entry.name)
            entryDetailViewController?.updateDetailContent(data: detailContent)
        }
    }
}



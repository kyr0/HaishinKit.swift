import AppKit
import Foundation

@available(macOS 14, *)
final class MenuViewController: NSViewController {
    @IBOutlet private weak var tableView: NSTableView! {
        didSet {
        }
    }

    struct Menu {
        let title: String
        let factory: () -> NSViewController
    }

    private lazy var menus: [Menu] = {
        var menus: [Menu] = [
            .init(title: "FLVAnalyzer", factory: { FLVAnalyzerViewController.getUIViewController() }),
            .init(title: "Ingest Test", factory: { CameraIngestViewController.getUIViewController() }),
            .init(title: "Playback Test", factory: { PlaybackViewController.getUIViewController() })
        ]
        menus.append(.init(title: "SCStream Ingest Test", factory: { SCStreamPublishViewController.getUIViewController() }))
        menus.append(.init(title: "Preference", factory: { PreferenceViewController.getUIViewController() }))
        return menus
    }()

    override func viewDidAppear() {
        super.viewDidAppear()
        let indexSet = NSIndexSet(index: 0)
        tableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
    }
}
@available(macOS 14, *)
extension MenuViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return menus.count
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else {
            return
        }
        guard let splitViewController = parent as? NSSplitViewController else {
            return
        }
        splitViewController.splitViewItems[1] = NSSplitViewItem(viewController: menus[tableView.selectedRow].factory())
    }
}
@available(macOS 14, *) 
extension MenuViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier, let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
            return nil
        }
        cellView.textField?.stringValue = menus[row].title
        return cellView
    }
}

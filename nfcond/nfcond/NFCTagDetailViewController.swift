import UIKit
import SnapKit

class NFCTagDetailViewController: UIViewController {
    
    // MARK: - Properties
    var tagInfo: [String: String] = [:]
    var records: [[String: String]] = [] // 存储记录数组
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .white
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        parseRecords()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "标签详细信息"
        
        // 设置导航栏左侧返回按钮
        let backButton = UIBarButtonItem(title: "菜单", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0) // 橙色
        navigationItem.leftBarButtonItem = backButton
        
        // 设置导航栏右侧保存按钮
        let saveButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0) // 橙色
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TagDetailCell.self, forCellReuseIdentifier: "TagDetailCell")
        tableView.register(RecordCell.self, forCellReuseIdentifier: "RecordCell")
    }
    
    private func parseRecords() {
        // 从tagInfo中解析记录
        if let url = tagInfo["url"], !url.isEmpty {
            var record: [String: String] = [:]
            if let contentType = tagInfo["contentType"] {
                if contentType == "文本" {
                    record["type"] = "Text"
                    record["value"] = url
                } else if contentType == "电话" {
                    record["type"] = "Tel"
                    record["value"] = url.replacingOccurrences(of: "tel:", with: "")
                } else if contentType == "网址" {
                    record["type"] = "URI"
                    record["value"] = url
                } else if contentType == "Email" {
                    record["type"] = "Email"
                    record["value"] = url.replacingOccurrences(of: "mailto:", with: "")
                } else if contentType == "短信" {
                    record["type"] = "SMS"
                    record["value"] = url.replacingOccurrences(of: "sms:", with: "")
                } else {
                    record["type"] = contentType
                    record["value"] = url
                }
                records.append(record)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        // 保存功能
        let alert = UIAlertController(title: "保存", message: "标签信息已保存", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension NFCTagDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 标签属性和记录
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5 // 标签类型、现有技术、序列号、大小、可写
        } else {
            return records.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagDetailCell", for: indexPath) as! TagDetailCell
            configureTagPropertyCell(cell, at: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
            configureRecordCell(cell, at: indexPath)
            return cell
        }
    }
    
    private func configureTagPropertyCell(_ cell: TagDetailCell, at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 标签类型
            cell.configure(
                icon: UIImage(systemName: "wave.3.left"),
                title: "标签类型",
                value1: tagInfo["tagType"] ?? "ISO 14443-4",
                value2: tagInfo["manufacturer"] ?? "Shanghai Fudan Microelectronics"
            )
        case 1:
            // 现有技术
            cell.configure(
                icon: UIImage(systemName: "info.circle"),
                title: "现有技术",
                value1: tagInfo["techType"] ?? "Type A, IsoDep",
                value2: nil
            )
        case 2:
            // 序列号
            cell.configure(
                icon: UIImage(systemName: "key"),
                title: "序列号",
                value1: tagInfo["serialNumber"] ?? "1D:66:D7:74:A5:00:00",
                value2: nil
            )
        case 3:
            // 大小
            cell.configure(
                icon: UIImage(systemName: "externaldrive.fill"),
                title: "大小",
                value1: tagInfo["size"] ?? "27字节",
                value2: nil
            )
        case 4:
            // 可写
            cell.configure(
                icon: UIImage(systemName: "arrow.triangle.2.circlepath"),
                title: "可写",
                value1: tagInfo["isWritable"] ?? "是",
                value2: nil
            )
        default:
            break
        }
    }
    
    private func configureRecordCell(_ cell: RecordCell, at indexPath: IndexPath) {
        let record = records[indexPath.row]
        let recordType = record["type"] ?? "Unknown"
        let recordValue = record["value"] ?? ""
        
        var iconName = "doc.text"
        switch recordType {
        case "Text":
            iconName = "doc.text"
        case "Tel":
            iconName = "phone.fill"
        case "URI", "网址":
            iconName = "safari"
        case "Email":
            iconName = "envelope.fill"
        case "SMS", "短信":
            iconName = "message.fill"
        default:
            iconName = "doc.text"
        }
        
        cell.configure(
            icon: UIImage(systemName: iconName),
            title: "记录 \(indexPath.row + 1) - \(recordType)",
            value: recordValue
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            // 点击记录时显示详情
            let record = records[indexPath.row]
            let alert = UIAlertController(
                title: "记录详情",
                message: "类型: \(record["type"] ?? "")\n内容: \(record["value"] ?? "")",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Custom Cells
class TagDetailCell: UITableViewCell {
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let value1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let value2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(value1Label)
        contentView.addSubview(value2Label)
        
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        value1Label.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        value2Label.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(value1Label.snp.bottom).offset(2)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(icon: UIImage?, title: String, value1: String, value2: String?) {
        iconImageView.image = icon
        titleLabel.text = title
        value1Label.text = value1
        value2Label.text = value2
        value2Label.isHidden = (value2 == nil)
    }
}

class RecordCell: UITableViewCell {
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(icon: UIImage?, title: String, value: String) {
        iconImageView.image = icon
        titleLabel.text = title
        valueLabel.text = value
    }
}

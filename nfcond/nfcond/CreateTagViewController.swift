//
//  CreateTagViewController.swift
//  nfcond
//
//  Created by zhouziyu on 2025/11/12.
//

import UIKit
import CoreNFC

class CreateTagViewController: UIViewController, NFCNDEFReaderSessionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 选择器选项
    let contentTypeOptions = ["网址", "文本"]
    let tagFormatOptions = ["NFC Data Exchange Format (NDEF)", "NFC Forum Type 2 Tag"]
    
    // 选择器
    let contentTypePickerView = UIPickerView()
    let tagFormatPickerView = UIPickerView()
    
    // 记录名称
    let recordNameLabel: UILabel = {
        let label = UILabel()
        label.text = "记录名称"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let recordNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入记录名称"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    // 内容类型
    let contentTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "内容类型"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let contentTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "选择内容类型"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    // 网址
    let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "网址"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入网址"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    // 文本内容
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "文本内容"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.placeholder = "输入文本内容"
        textView.borderStyle = .roundedRect
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    // 标签格式
    let tagFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "标签格式"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let tagFormatTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "选择标签格式"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    // 创建标签按钮
    let createTagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("创建标签", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // NFC会话
    var nfcSession: NFCNDEFReaderSession?
    
    // 选择的内容类型
    var selectedContentType = "网址"
    
    // 选择的标签格式
    var selectedTagFormat = "NFC Data Exchange Format (NDEF)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPickerViews()
        updateUIForContentType(selectedContentType)
        // 添加创建标签按钮的点击事件
        createTagButton.addTarget(self, action: #selector(createTagButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "创建标签"
        
        // 内容容器视图
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: createTagButton.topAnchor, constant: -20)
        ])
        
        // 记录名称
        contentView.addSubview(recordNameLabel)
        recordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            recordNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recordNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(recordNameTextField)
        recordNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordNameTextField.topAnchor.constraint(equalTo: recordNameLabel.bottomAnchor, constant: 10),
            recordNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recordNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recordNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 内容类型
        contentView.addSubview(contentTypeLabel)
        contentTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTypeLabel.topAnchor.constraint(equalTo: recordNameTextField.bottomAnchor, constant: 20),
            contentTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(contentTypeTextField)
        contentTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTypeTextField.topAnchor.constraint(equalTo: contentTypeLabel.bottomAnchor, constant: 10),
            contentTypeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentTypeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentTypeTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 网址
        contentView.addSubview(urlLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urlLabel.topAnchor.constraint(equalTo: contentTypeTextField.bottomAnchor, constant: 20),
            urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(urlTextField)
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 10),
            urlTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            urlTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 文本内容
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentTypeTextField.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // 标签格式
        contentView.addSubview(tagFormatLabel)
        tagFormatLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagFormatLabel.topAnchor.constraint(greaterThanOrEqualTo: urlTextField.bottomAnchor, constant: 20),
            tagFormatLabel.topAnchor.constraint(greaterThanOrEqualTo: textView.bottomAnchor, constant: 20),
            tagFormatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagFormatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(tagFormatTextField)
        tagFormatTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagFormatTextField.topAnchor.constraint(equalTo: tagFormatLabel.bottomAnchor, constant: 10),
            tagFormatTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagFormatTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagFormatTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 创建标签按钮
        view.addSubview(createTagButton)
        createTagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createTagButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createTagButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createTagButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createTagButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupPickerViews() {
        // 内容类型选择器
        contentTypePickerView.dataSource = self
        contentTypePickerView.delegate = self
        contentTypePickerView.tag = 0
        contentTypeTextField.inputView = contentTypePickerView
        
        // 标签格式选择器
        tagFormatPickerView.dataSource = self
        tagFormatPickerView.delegate = self
        tagFormatPickerView.tag = 2
        tagFormatTextField.inputView = tagFormatPickerView
        
        // 设置默认选择
        if let index = contentTypeOptions.firstIndex(of: selectedContentType) {
            contentTypePickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        if let index = tagFormatOptions.firstIndex(of: selectedTagFormat) {
            tagFormatPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0: return contentTypeOptions.count
        case 2: return tagFormatOptions.count
        default: return 0
        }
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0: return contentTypeOptions[row]
        case 2: return tagFormatOptions[row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            selectedContentType = contentTypeOptions[row]
            contentTypeTextField.text = selectedContentType
            updateUIForContentType(selectedContentType)
        case 2:
            selectedTagFormat = tagFormatOptions[row]
            tagFormatTextField.text = selectedTagFormat
        default:
            break
        }
    }
    
    // MARK: - UI Update Methods
    func updateUIForContentType(_ contentType: String) {
        // 隐藏所有内容类型相关的UI组件
        urlLabel.isHidden = true
        urlTextField.isHidden = true
        textLabel.isHidden = true
        textView.isHidden = true
        
        // 根据选择的内容类型显示相应的UI组件
        switch contentType {
        case "网址":
            urlLabel.isHidden = false
            urlTextField.isHidden = false
        case "文本":
            textLabel.isHidden = false
            textView.isHidden = false
        default:
            break
        }
    }
    
    // MARK: - NFC Methods
    func createNDEFMessage() -> NFCNDEFMessage? {
        var ndefRecords: [NFCNDEFPayload] = []
        
        switch selectedContentType {
        case "网址":
            guard let url = urlTextField.text else { return nil }
            let fullUrl: String
            // 默认添加https://前缀，如果已存在则不添加
            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                fullUrl = url
            } else {
                fullUrl = "https://" + url
            }
            
            if let urlData = fullUrl.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: fullUrl)!)!
                ndefRecords.append(record)
            }
            
        case "文本":
            guard let text = textView.text else { return nil }
            if let textData = text.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeTextPayload(string: text, locale: Locale.current)!
                ndefRecords.append(record)
            }
            
        default:
            break
        }
        
        guard !ndefRecords.isEmpty else { return nil }
        return NFCNDEFMessage(records: ndefRecords)
    }
    
    // 开始NFC会话
    func beginNFCSession() {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcSession?.alertMessage = "将标签靠近设备顶部"
        nfcSession?.begin()
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "未检测到标签")
            return
        }
        
        session.connect(to: tag) { [weak self] error in
            guard error == nil else {
                session.invalidate(errorMessage: "连接标签失败: \(error?.localizedDescription ?? "未知错误")")
                return
            }
            
            // 写入NDEF消息
            if let message = self?.createNDEFMessage() {
                tag.writeNDEF(message) { error in
                    guard error == nil else {
                        session.invalidate(errorMessage: "写入标签失败: \(error?.localizedDescription ?? "未知错误")")
                        return
                    }
                    
                    session.invalidate(errorMessage: "写入成功")
                }
            } else {
                session.invalidate(errorMessage: "无法创建NDEF消息")
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // 不需要实现这个方法，因为我们在写入标签
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // 处理会话无效的情况
    }
    
    // MARK: - Button Actions
    @objc func createTagButtonTapped() {
        // 开始NFC会话
        beginNFCSession()
    }
}

// 扩展UITextView以支持placeholder
extension UITextView {
    open override var placeholder: String? {
        get {
            return (self.viewWithTag(100) as? UILabel)?.text
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
            } else {
                let placeholderLabel = UILabel()
                placeholderLabel.text = newValue
                placeholderLabel.textColor = .lightGray
                placeholderLabel.tag = 100
                placeholderLabel.font = self.font
                placeholderLabel.sizeToFit()
                self.addSubview(placeholderLabel)
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                    placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
                ])
            }
        }
    }
}
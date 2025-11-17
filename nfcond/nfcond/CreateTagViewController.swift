//
//  CreateTagViewController.swift
//  nfcond
//
//  Created by zhouziyu on 2025/11/12.
//

import UIKit
import CoreNFC
import SnapKit

// NFCTagReaderSessionDelegate 

class CreateTagViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, NFCNDEFReaderSessionDelegate {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "创建标签"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .black
        return label
    }()
    
    private let contentMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "内容消息"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        return label
    }()
    
    private let contentTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "内容类型"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let contentTypeContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentTypeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "safari")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentTypeTextField: UITextField = {
        let textField = UITextField()
        textField.text = "网址"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.textAlignment = .left
        return textField
    }()
    
    private let contentTypeArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let contentTypePickerView = UIPickerView()
    private let contentTypeOptions = ["网址", "文本", "短信", "Email", "电话", "FaceTime", "FaceTime视频", "地图", "家庭"]
    private var selectedContentType = "网址"
    
    private let urlTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "网址类型"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let urlTypeContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let urlTypeTextField: UITextField = {
        let textField = UITextField()
        textField.text = "http"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let urlTypeArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let urlTypePickerView = UIPickerView()
    private let urlTypeOptions = ["http", "https"]
    private var selectedUrlType = "http"
    
    // 网址相关
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "网址"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入网址"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.borderStyle = .none
        return textField
    }()
    
    // 文本相关
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "文本内容"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    // 短信相关
    private let smsPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "电话号码"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let smsPhoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入电话号码"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let smsContentLabel: UILabel = {
        let label = UILabel()
        label.text = "短信内容"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let smsContentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入短信内容"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        return textField
    }()
    
    // Email相关
    private let emailRecipientLabel: UILabel = {
        let label = UILabel()
        label.text = "收件人"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let emailRecipientTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入邮箱地址"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let emailSubjectLabel: UILabel = {
        let label = UILabel()
        label.text = "主题"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let emailSubjectTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入邮件主题"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        return textField
    }()
    
    private let emailBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "正文"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let emailBodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    // 电话相关
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "电话号码"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入电话号码"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.keyboardType = .phonePad
        return textField
    }()
    
    // FaceTime相关
    private let faceTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "FaceTime"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let faceTimeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入电话号码或邮箱"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        return textField
    }()
    
    // 地图相关
    private let mapLabel: UILabel = {
        let label = UILabel()
        label.text = "地理位置"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let mapTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入地址或坐标"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        return textField
    }()
    
    // 家庭相关
    private let homeLabel: UILabel = {
        let label = UILabel()
        label.text = "家庭"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let homeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "家庭相关信息"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        return textField
    }()
    
    private let tagAttributesLabel: UILabel = {
        let label = UILabel()
        label.text = "标签属性"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        return label
    }()
    
    private let uniqueIdentifierLabel: UILabel = {
        let label = UILabel()
        label.text = "唯一标识"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let uniqueIdentifierValueLabel: UILabel = {
        let label = UILabel()
        label.text = UUID().uuidString
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let tagTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "标签类型"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let tagTypeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "U"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let tagFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "标签格式"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let tagFormatContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tagFormatTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Unknown"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let tagFormatArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tagFormatPickerView = UIPickerView()
    private let tagFormatOptions = ["Unknown", "NDEF", "Mifare"]
    private var selectedTagFormat = "Unknown"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPickerViews()
        // 设置初始内容类型对应的UI组件
        updateUIForContentType(selectedContentType)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "创建标签"
        
        // 添加返回按钮
        let backButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // 添加完成按钮
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        
        // 添加 ScrollView
        contentView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 大标题
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 内容消息
        contentView.addSubview(contentMessageLabel)
        contentMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 内容类型
        contentView.addSubview(contentTypeLabel)
        contentTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentMessageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 内容类型容器（图标+文字+箭头）
        contentView.addSubview(contentTypeContainerView)
        contentTypeContainerView.addSubview(contentTypeIcon)
        contentTypeContainerView.addSubview(contentTypeTextField)
        contentTypeContainerView.addSubview(contentTypeArrowImageView)
        
        contentTypeContainerView.snp.makeConstraints { make in
            make.top.equalTo(contentTypeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        contentTypeIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        contentTypeTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentTypeIcon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(contentTypeArrowImageView.snp.leading).offset(-10)
        }
        
        contentTypeArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        // 添加分隔线
        let contentTypeSeparator = UIView()
        contentTypeSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(contentTypeSeparator)
        contentTypeSeparator.snp.makeConstraints { make in
            make.top.equalTo(contentTypeTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 网址类型
        contentView.addSubview(urlTypeLabel)
        urlTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(urlTypeContainerView)
        urlTypeContainerView.addSubview(urlTypeTextField)
        urlTypeContainerView.addSubview(urlTypeArrowImageView)
        
        urlTypeContainerView.snp.makeConstraints { make in
            make.top.equalTo(urlTypeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        urlTypeTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(urlTypeArrowImageView.snp.leading).offset(-10)
        }
        
        urlTypeArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        // 添加分隔线
        let urlTypeSeparator = UIView()
        urlTypeSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(urlTypeSeparator)
        urlTypeSeparator.snp.makeConstraints { make in
            make.top.equalTo(urlTypeContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 网址
        contentView.addSubview(urlLabel)
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(urlTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(urlTextField)
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let urlSeparator = UIView()
        urlSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(urlSeparator)
        urlSeparator.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 文本内容
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        // 添加分隔线
        let textSeparator = UIView()
        textSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(textSeparator)
        textSeparator.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 短信 - 电话号码
        contentView.addSubview(smsPhoneNumberLabel)
        smsPhoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(smsPhoneNumberTextField)
        smsPhoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(smsPhoneNumberLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let smsPhoneNumberSeparator = UIView()
        smsPhoneNumberSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(smsPhoneNumberSeparator)
        smsPhoneNumberSeparator.snp.makeConstraints { make in
            make.top.equalTo(smsPhoneNumberTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 短信 - 内容
        contentView.addSubview(smsContentLabel)
        smsContentLabel.snp.makeConstraints { make in
            make.top.equalTo(smsPhoneNumberSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(smsContentTextField)
        smsContentTextField.snp.makeConstraints { make in
            make.top.equalTo(smsContentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let smsContentSeparator = UIView()
        smsContentSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(smsContentSeparator)
        smsContentSeparator.snp.makeConstraints { make in
            make.top.equalTo(smsContentTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // Email - 收件人
        contentView.addSubview(emailRecipientLabel)
        emailRecipientLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(emailRecipientTextField)
        emailRecipientTextField.snp.makeConstraints { make in
            make.top.equalTo(emailRecipientLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let emailRecipientSeparator = UIView()
        emailRecipientSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(emailRecipientSeparator)
        emailRecipientSeparator.snp.makeConstraints { make in
            make.top.equalTo(emailRecipientTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // Email - 主题
        contentView.addSubview(emailSubjectLabel)
        emailSubjectLabel.snp.makeConstraints { make in
            make.top.equalTo(emailRecipientSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(emailSubjectTextField)
        emailSubjectTextField.snp.makeConstraints { make in
            make.top.equalTo(emailSubjectLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let emailSubjectSeparator = UIView()
        emailSubjectSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(emailSubjectSeparator)
        emailSubjectSeparator.snp.makeConstraints { make in
            make.top.equalTo(emailSubjectTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // Email - 正文
        contentView.addSubview(emailBodyLabel)
        emailBodyLabel.snp.makeConstraints { make in
            make.top.equalTo(emailSubjectSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(emailBodyTextView)
        emailBodyTextView.snp.makeConstraints { make in
            make.top.equalTo(emailBodyLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        // 添加分隔线
        let emailBodySeparator = UIView()
        emailBodySeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(emailBodySeparator)
        emailBodySeparator.snp.makeConstraints { make in
            make.top.equalTo(emailBodyTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 电话 - 电话号码
        contentView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let phoneNumberSeparator = UIView()
        phoneNumberSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(phoneNumberSeparator)
        phoneNumberSeparator.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // FaceTime
        contentView.addSubview(faceTimeLabel)
        faceTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(faceTimeTextField)
        faceTimeTextField.snp.makeConstraints { make in
            make.top.equalTo(faceTimeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let faceTimeSeparator = UIView()
        faceTimeSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(faceTimeSeparator)
        faceTimeSeparator.snp.makeConstraints { make in
            make.top.equalTo(faceTimeTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 地图
        contentView.addSubview(mapLabel)
        mapLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(mapTextField)
        mapTextField.snp.makeConstraints { make in
            make.top.equalTo(mapLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let mapSeparator = UIView()
        mapSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(mapSeparator)
        mapSeparator.snp.makeConstraints { make in
            make.top.equalTo(mapTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 家庭
        contentView.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(homeTextField)
        homeTextField.snp.makeConstraints { make in
            make.top.equalTo(homeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let homeSeparator = UIView()
        homeSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(homeSeparator)
        homeSeparator.snp.makeConstraints { make in
            make.top.equalTo(homeTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 标签属性
        contentView.addSubview(tagAttributesLabel)
        tagAttributesLabel.snp.makeConstraints { make in
            make.top.equalTo(urlSeparator.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 唯一标识
        contentView.addSubview(uniqueIdentifierLabel)
        uniqueIdentifierLabel.snp.makeConstraints { make in
            make.top.equalTo(tagAttributesLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(uniqueIdentifierValueLabel)
        uniqueIdentifierValueLabel.snp.makeConstraints { make in
            make.top.equalTo(uniqueIdentifierLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let uniqueIdentifierSeparator = UIView()
        uniqueIdentifierSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(uniqueIdentifierSeparator)
        uniqueIdentifierSeparator.snp.makeConstraints { make in
            make.top.equalTo(uniqueIdentifierValueLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 标签类型
        contentView.addSubview(tagTypeLabel)
        tagTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(uniqueIdentifierSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(tagTypeValueLabel)
        tagTypeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(tagTypeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        // 添加分隔线
        let tagTypeSeparator = UIView()
        tagTypeSeparator.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        contentView.addSubview(tagTypeSeparator)
        tagTypeSeparator.snp.makeConstraints { make in
            make.top.equalTo(tagTypeValueLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 标签格式
        contentView.addSubview(tagFormatLabel)
        tagFormatLabel.snp.makeConstraints { make in
            make.top.equalTo(tagTypeSeparator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(tagFormatContainerView)
        tagFormatContainerView.addSubview(tagFormatTextField)
        tagFormatContainerView.addSubview(tagFormatArrowImageView)
        
        tagFormatContainerView.snp.makeConstraints { make in
            make.top.equalTo(tagFormatLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        tagFormatTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(tagFormatArrowImageView.snp.leading).offset(-10)
        }
        
        tagFormatArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        // 写入按钮
        let writeButton: UIButton = {
            let button = UIButton()
            button.setTitle("写入", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
            button.layer.cornerRadius = 22
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
            return button
        }()
        
        contentView.addSubview(writeButton)
        writeButton.snp.makeConstraints { make in
            make.top.equalTo(tagFormatContainerView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupPickerViews() {
        // 内容类型选择器
        contentTypePickerView.dataSource = self
        contentTypePickerView.delegate = self
        contentTypePickerView.tag = 0
        contentTypeTextField.inputView = contentTypePickerView
        
        // 网址类型选择器
        urlTypePickerView.dataSource = self
        urlTypePickerView.delegate = self
        urlTypePickerView.tag = 1
        urlTypeTextField.inputView = urlTypePickerView
        
        // 标签格式选择器
        tagFormatPickerView.dataSource = self
        tagFormatPickerView.delegate = self
        tagFormatPickerView.tag = 2
        tagFormatTextField.inputView = tagFormatPickerView
        
        // 设置默认选择
        if let index = contentTypeOptions.firstIndex(of: selectedContentType) {
            contentTypePickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        if let index = urlTypeOptions.firstIndex(of: selectedUrlType) {
            urlTypePickerView.selectRow(index, inComponent: 0, animated: false)
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
        case 1: return urlTypeOptions.count
        case 2: return tagFormatOptions.count
        default: return 0
        }
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0: return contentTypeOptions[row]
        case 1: return urlTypeOptions[row]
        case 2: return tagFormatOptions[row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            selectedContentType = contentTypeOptions[row]
            contentTypeTextField.text = selectedContentType
            // 根据选择的内容类型显示/隐藏相应的UI组件
            updateUIForContentType(selectedContentType)
        case 1:
            selectedUrlType = urlTypeOptions[row]
            urlTypeTextField.text = selectedUrlType
        case 2:
            selectedTagFormat = tagFormatOptions[row]
            tagFormatTextField.text = selectedTagFormat
        default:
            break
        }
    }
    
    // MARK: - UI Update Methods
    
    func updateUIForContentType(_ contentType: String) {
        // 更新图标
        var iconName = "safari"
        switch contentType {
        case "网址":
            iconName = "safari"
        case "文本":
            iconName = "doc.text"
        case "短信":
            iconName = "message"
        case "Email":
            iconName = "envelope"
        case "电话":
            iconName = "phone"
        case "FaceTime", "FaceTime视频":
            iconName = "video"
        case "地图":
            iconName = "map"
        case "家庭":
            iconName = "house"
        default:
            iconName = "safari"
        }
        contentTypeIcon.image = UIImage(systemName: iconName)
        
        // 更新文本字段
        contentTypeTextField.text = contentType
        // 隐藏所有内容类型相关的UI组件
        urlTypeLabel.isHidden = true
        urlTypeContainerView.isHidden = true
        urlLabel.isHidden = true
        urlTextField.isHidden = true
        
        textLabel.isHidden = true
        textView.isHidden = true
        
        smsPhoneNumberLabel.isHidden = true
        smsPhoneNumberTextField.isHidden = true
        smsContentLabel.isHidden = true
        smsContentTextField.isHidden = true
        
        emailRecipientLabel.isHidden = true
        emailRecipientTextField.isHidden = true
        emailSubjectLabel.isHidden = true
        emailSubjectTextField.isHidden = true
        emailBodyLabel.isHidden = true
        emailBodyTextView.isHidden = true
        
        phoneNumberLabel.isHidden = true
        phoneNumberTextField.isHidden = true
        
        faceTimeLabel.isHidden = true
        faceTimeTextField.isHidden = true
        
        mapLabel.isHidden = true
        mapTextField.isHidden = true
        
        homeLabel.isHidden = true
        homeTextField.isHidden = true
        
        // 根据选择的内容类型显示相应的UI组件
        switch contentType {
        case "网址":
            urlTypeLabel.isHidden = false
            urlTypeContainerView.isHidden = false
            urlLabel.isHidden = false
            urlTextField.isHidden = false
        case "文本":
            textLabel.isHidden = false
            textView.isHidden = false
        case "短信":
            smsPhoneNumberLabel.isHidden = false
            smsPhoneNumberTextField.isHidden = false
            smsContentLabel.isHidden = false
            smsContentTextField.isHidden = false
        case "Email":
            emailRecipientLabel.isHidden = false
            emailRecipientTextField.isHidden = false
            emailSubjectLabel.isHidden = false
            emailSubjectTextField.isHidden = false
            emailBodyLabel.isHidden = false
            emailBodyTextView.isHidden = false
        case "电话":
            phoneNumberLabel.isHidden = false
            phoneNumberTextField.isHidden = false
        case "FaceTime":
            faceTimeLabel.isHidden = false
            faceTimeTextField.isHidden = false
        case "地图":
            mapLabel.isHidden = false
            mapTextField.isHidden = false
        case "家庭":
            homeLabel.isHidden = false
            homeTextField.isHidden = false
        default:
            break
        }
    }
    
    // MARK: - NFC Methods
    
    func createNDEFMessage() -> NFCNDEFMessage? {
        var ndefRecords: [NFCNDEFPayload] = []
        
        switch selectedContentType {
        case "网址":
            guard let urlType = urlTypeTextField.text, let url = urlTextField.text else { return nil }
            let fullUrl: String
            switch urlType {
            case "http://":
                fullUrl = "http://" + url
            case "https://":
                fullUrl = "https://" + url
            case "ftp://":
                fullUrl = "ftp://" + url
            default:
                fullUrl = url
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
            
        case "短信":
            guard let phoneNumber = smsPhoneNumberTextField.text, let message = smsContentTextField.text else { return nil }
            let smsUri = "sms:\(phoneNumber)?body=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            if let smsData = smsUri.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: smsUri)!)!
                ndefRecords.append(record)
            }
            
        case "Email":
            guard let recipient = emailRecipientTextField.text, let subject = emailSubjectTextField.text, let body = emailBodyTextView.text else { return nil }
            let emailUri = "mailto:\(recipient)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            if let emailData = emailUri.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: emailUri)!)!
                ndefRecords.append(record)
            }
            
        case "电话":
            guard let phoneNumber = phoneNumberTextField.text else { return nil }
            let telUri = "tel:\(phoneNumber)"
            if let telData = telUri.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: telUri)!)!
                ndefRecords.append(record)
            }
            
        case "FaceTime":
            guard let faceTimeId = faceTimeTextField.text else { return nil }
            let faceTimeUri = "facetime:\(faceTimeId)"
            if let faceTimeData = faceTimeUri.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: faceTimeUri)!)!
                ndefRecords.append(record)
            }
            
        case "地图":
            guard let mapQuery = mapTextField.text else { return nil }
            let mapUri = "http://maps.apple.com/?q=\(mapQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            if let mapData = mapUri.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: URL(string: mapUri)!)!
                ndefRecords.append(record)
            }
            
        case "家庭":
            // 家庭类型的NDEF记录需要特殊处理，这里暂时使用文本类型
            guard let homeText = homeTextField.text else { return nil }
            if let homeData = homeText.data(using: .utf8) {
                let record = NFCNDEFPayload.wellKnownTypeTextPayload(string: homeText, locale: Locale.current)!
                ndefRecords.append(record)
            }
            
        default:
            return nil
        }
        
        return NFCNDEFMessage(records: ndefRecords)
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "未检测到NFC标签")
            return
        }
        
        session.connect(to: tag) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                session.invalidate(errorMessage: "连接NFC标签失败: \(error.localizedDescription)")
                return
            }
            
            // 准备NDEF消息 - 在主线程上调用UI方法
            DispatchQueue.main.async {
                guard let message = self.createNDEFMessage() else {
                    session.invalidate(errorMessage: "无法创建NDEF消息")
                    return
                }
                
                // 写入NDEF消息
                tag.writeNDEF(message) { error in
                    if let error = error {
                        session.invalidate(errorMessage: "写入NFC标签失败: \(error.localizedDescription)")
                    } else {
                        session.invalidate(errorMessage: "NFC标签写入成功")
                        // 写入成功后返回上一个页面
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            

        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // 检查是否是用户取消
        if let readerError = error as? NFCReaderError {
            if readerError.code == .readerSessionInvalidationErrorFirstNDEFTagRead {
                // 读取成功后自动关闭session，无需处理
                return
            }
        }
        
        // 其他错误
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "错误", message: "NFC标签操作失败: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // 这个方法是用于读取的，写入时不需要处理
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        // 这里可以添加保存配置的逻辑
        let alert = UIAlertController(title: "完成", message: "配置已保存", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func writeButtonTapped() {
        // 检查设备是否支持NFC
        if NFCNDEFReaderSession.readingAvailable {
            let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
            session.alertMessage = "将NFC标签靠近设备以写入数据"
            session.begin()
        } else {
            let alert = UIAlertController(title: "错误", message: "您的设备不支持NFC功能", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

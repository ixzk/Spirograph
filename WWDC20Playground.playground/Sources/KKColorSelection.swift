import UIKit

class KKColorSelection: UIView {
    
    public private(set) var currentColor: UIColor
    
    private static var colorCount = 20
    private var colors: [UIColor]
    
    override init(frame: CGRect) {
        currentColor = .black
        
        colors = []
        for _ in 0..<KKColorSelection.colorCount {
            colors.append(UIColor(red: CGFloat((arc4random() % 256)) / 255.0, green: CGFloat((arc4random() % 256)) / 255.0, blue: CGFloat((arc4random() % 256)) / 255.0, alpha: 1.0))
        }
        
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        addSubview(curColorView)
        addSubview(collectionView)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        
        let view = UICollectionView(frame: CGRect(x: 70, y: 0, width: self.frame.width - 80, height: 50), collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorSelectionCellID")
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var curColorView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.backgroundColor = currentColor
        
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KKColorSelection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentColor = colors[indexPath.row]
        curColorView.backgroundColor = currentColor
    }
}

extension KKColorSelection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KKColorSelection.colorCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorSelectionCellID", for: indexPath)

        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }
    
    
}

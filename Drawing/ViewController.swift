//
//  ViewController.swift
//  Drawing
//
//  Created by 荒谷瑞穂 on 2022/08/16.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
//        segmentedControl.selectedSegmentIndex = 0
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearTapped(sender: Any) {
        let drawView = DrawView()
            drawView.clear()
        }
        
        @IBAction func undoTapped(sender: Any) {
            let drawView = DrawView()
            drawView.undo()
        }
        
        @IBAction func colorChanged(sender: Any) {
            var c = UIColor.black
            switch segmentedControl.selectedSegmentIndex {
            case 1:
                c = UIColor.blue
                break
            case 2:
                c = UIColor.red
                break
            default:
                break
            }
            let drawView = DrawView()
            drawView.setDrawingColor(color: c)
        }
    
    @IBAction func cameraTapped(sender: UIButton) {
        showSourceSelection()
    }
    
    func showSourceSelection() {
        let alert = UIAlertController(title:"写真を選択", message: "ソースを選んでください", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (action: UIAlertAction!) in
            self.pickImage(sourceType: .camera)
        })
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action: UIAlertAction!) in
            self.pickImage(sourceType: .photoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (action: UIAlertAction!) in
            print("Pick canceled")
        })
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    func pickImage(sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // UIImageView 初期化
            let imageView = UIImageView(image:pickedImage)
            
            // スクリーンの縦横サイズを取得
            let screenWidth:CGFloat = view.frame.size.width
            let screenHeight:CGFloat = view.frame.size.height
            
            // 画像の縦横サイズを取得
            let imgWidth:CGFloat = pickedImage.size.width
            let imgHeight:CGFloat = pickedImage.size.height
            
            // 画像サイズをスクリーン幅に合わせる
            let scale:CGFloat = screenWidth / imgWidth
            let rect:CGRect = CGRect(x:0, y:0, width:imgWidth*scale, height:imgHeight*scale)
            
            // ImageView frame をCGRectで作った矩形に合わせる
            imageView.frame = rect
            
            // 画像の中心を画面の中心に設定
            imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
            
            self.view.addSubview(imageView)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


//
//  NavigationProtocols.swift
//  Keys2Home_Agent
//
//  Created by appsDev on 20/06/19.
//  Copyright © 2019 appsDev. All rights reserved.
//

import UIKit
import KYDrawerController
import Toast
import StoreKit
protocol NavigationBarItemsData {
    func leftItem(target:CustomiseViewController) ->UIBarButtonItem
    func rightItems(target:CustomiseViewController) ->[UIBarButtonItem]
    var title : String {get}
}
enum NavigationBarType {
    case SideMenu_Title_Filter(title:String)
    case SideMenu_Title(title:String)
    case Back_Title_Calendar(title:String)
    case Back_Title_Download(title:String)
    case Back_Title_Camera(title:String)
    case Back_Title(title:String)
}
extension NavigationBarType : NavigationBarItemsData {
    func leftItem(target: CustomiseViewController) -> UIBarButtonItem {
        switch self {
        case .SideMenu_Title_Filter:
            let btn = UIBarButtonItem.init(image: UIImage.init(named: "menu_bar"), style: .done, target: target, action: #selector(target.navigationBarSideMenuAction))
            btn.tintColor = UIColor.white
            return btn
        case .SideMenu_Title:
            let btn = UIBarButtonItem.init(image: UIImage.init(named: "menu_bar"), style: .done, target: target, action: #selector(target.navigationBarSideMenuAction))
            btn.tintColor = UIColor.white
            return btn
        case .Back_Title_Calendar:
            let btn = UIBarButtonItem.init()
            btn.tintColor = UIColor.white
            btn.title = "Back".localised
            return btn
        case .Back_Title_Download:
            let btn = UIBarButtonItem.init()
            btn.tintColor = UIColor.white
            btn.title = "Back".localised
            return btn
        case .Back_Title:
            let btn = UIBarButtonItem.init()
            btn.tintColor = UIColor.white
            btn.title = "Back".localised
            return btn
        case .Back_Title_Camera:
            let btn = UIBarButtonItem.init()
            btn.tintColor = UIColor.white
            btn.title = "Back".localised
            return btn
        }
    }
    func rightItems(target: CustomiseViewController) -> [UIBarButtonItem] {
        switch self {
        case .SideMenu_Title_Filter:
            let btn = UIBarButtonItem.init(image: UIImage.init(named: "filter"), style: .done, target: target, action: #selector(target.navigationBarFilterAction))
            btn.tintColor = UIColor.white
            return [btn]
        case .SideMenu_Title:
            return []
        case .Back_Title:
            return []
        case .Back_Title_Calendar:
            let btn = UIBarButtonItem.init(image: UIImage.init(named: "calender"), style: .done, target: target, action: #selector(target.navigationBarCalendarAction))
            btn.tintColor = UIColor.white
            return [btn]
        case .Back_Title_Download:
            let btn = UIBarButtonItem.init(image: UIImage.init(named: "download"), style: .done, target: target, action: #selector(target.navigationBarDownloadAction))
            btn.tintColor = UIColor.white
            return [btn]
        case .Back_Title_Camera:
            let btn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "camra"), style: .done, target: target, action: #selector(target.navigationBarCameraAction))
            btn.tintColor = UIColor.white
            return [btn]
        }
    }
    var title: String {
        switch self {
        case .SideMenu_Title_Filter(let title):
            return title
        case .SideMenu_Title(let title):
            return title
        case .Back_Title(let title):
            return title
        case .Back_Title_Calendar(let title):
            return title
        case .Back_Title_Download(let title):
            return title
        case .Back_Title_Camera(let title):
            return title
        }
    }
}
protocol NavigationBarActions {
    func navigationBarSideMenuAction()
    func navigationBarFilterAction()
    func navigationBarDownloadAction()
    func navigationBarCameraAction()
    func navigationBarCalendarAction()
}
class CustomiseViewController : UIViewController, NavigationBarActions {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setTransparentNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    func setUpNagigationBar(_ type : NavigationBarType) {
        switch type {

        case .SideMenu_Title_Filter:
            let search = UISearchController(searchResultsController: nil)
            search.searchResultsUpdater = self
            search.searchBar.setStyleColor(.white)
            navigationItem.searchController = search
            navigationItem.leftBarButtonItem = type.leftItem(target: self)
            navigationItem.rightBarButtonItem = type.rightItems(target: self).first
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationItem.title = type.title
            
            break
        case .SideMenu_Title:
            navigationItem.leftBarButtonItem = type.leftItem(target: self)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationItem.title = type.title
            break
        case .Back_Title_Calendar:
            navigationItem.backBarButtonItem = type.leftItem(target: self)
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = type.rightItems(target: self).first
            navigationItem.title = type.title
            navigationController?.navigationBar.tintColor = UIColor.white
            break
        case .Back_Title_Download:
            navigationItem.backBarButtonItem = type.leftItem(target: self)
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = type.rightItems(target: self).first
            navigationItem.title = type.title
            navigationController?.navigationBar.tintColor = UIColor.white
            break
        case .Back_Title:
            navigationItem.backBarButtonItem = type.leftItem(target: self)
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            navigationItem.title = type.title
            navigationController?.navigationBar.tintColor = UIColor.white
            break
        case .Back_Title_Camera:
            navigationItem.backBarButtonItem = type.leftItem(target: self)
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = type.rightItems(target: self).first
            navigationItem.title = type.title
            navigationController?.navigationBar.tintColor = UIColor.white
            break
        }
    }
    // Thsese are the side Drawer asction which is used in the navigation bar view. I am using KYDrawerController for side menu
    @objc func navigationBarSideMenuAction() {
        if let vc = self.navigationController?.parent as? KYDrawerController {
            vc.setDrawerState(.opened, animated: true)
        }
        if let vc = (self.navigationController?.parent as? KYDrawerController)?.drawerViewController as? SideDrawerVC {
            vc.selectedActionType = { [weak self](type) -> () in
                guard let this = self else {return}
                switch type {
                case .Home:
                    this.drawerHomeAction()
                    break
                case .Profile:
                    this.drawerProfileAction()
                    break
                case .Setting:
                    this.drawerSettingAction()
                    break
                case .HolidayList:
                    this.drawerHolidayListAction()
                case .RateUs:
                    this.drawerRateUsAction()
                    break
                case .ContactUs:
                    this.drawerContactUsAction()
                    break
                case .LogOut:
                    this.drawerLogOutAction()
                    break
                case .AboutUs:
                    this.drawerAboutUsAction()
                }
            }
        }
    }
    func drawerHomeAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    func drawerProfileAction() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String.init(describing: ProfileVC.self)) else { return  }
        navigationController?.pushViewController(vc, animated: false)
    }
    func drawerSettingAction() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String.init(describing: SettingsVC.self)) else { return  }
        navigationController?.pushViewController(vc, animated: false)
    }
    func drawerHolidayListAction() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String.init(describing: HolidaysListVC.self)) else { return  }
        navigationController?.pushViewController(vc, animated: false)
    }
    func drawerRateUsAction() {
        SKStoreReviewController.requestReview()
    }
    func drawerAboutUsAction() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String.init(describing: AboutUsVC.self)) else { return  }
        navigationController?.pushViewController(vc, animated: false)
    }
    func drawerContactUsAction() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String.init(describing: ContactUsVC.self)) else { return  }
        navigationController?.pushViewController(vc, animated: false)
    }
    @objc func navigationBarCameraAction() {}
    func drawerLogOutAction() {
        let alert = UIAlertController(title: "Alert!".localised, message: "Do you really want to logout?".localised, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes".localised, style: .default, handler: { [weak self](action) in
            AppSettings.hasLogIn = false
            UserData.Name  = ""
            UserData.Image = ""
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let initialViewController  =  self?.storyboard?.instantiateViewController(withIdentifier: "logInNav") as! UINavigationController
            appDelegate.window?.rootViewController =  nil
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        })
        let action2 = UIAlertAction(title: "No".localised, style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func navigationBarFilterAction() {}
    @objc func navigationBarDownloadAction() {}
    @objc func navigationBarCalendarAction() {}
}
extension UIViewController {
    func showBrokenRules(message:String){
        self.view.makeToast(message, duration: 2.0, position: CSToastPositionBottom)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func showProgressHUD() {
        let progressHUD = LottieProgressHUD.shared
        view.addSubview(progressHUD)
        progressHUD.show()
    }
    func hideProgressHUD() {
        let progressHUD = LottieProgressHUD.shared
        progressHUD.hide()
        progressHUD.removeFromSuperview()
    }
    @objc func dismissKeyboard() {
        DispatchQueue.main.async {[weak self] in
            self?.view.endEditing(true)
        }
    }
}
// MARK: MVVM Global View Model Observer for start and stop LoadingIndicator and Show Error in Toast
struct BrokenRule {
    var propertyName :String
    var message :String
}
// Implemented by all view models
protocol ViewModel {
    var brokenRules :[BrokenRule] { get set}
    var isValid :Bool { mutating get }
    var showAlertClosure: (() -> ())? { get set }
    var updateLoadingStatus: (() -> ())? { get set }
    var didFinishFetch: (() -> ())? { get set }
    var error: Error? { get set }
    var isLoading: Bool { get set }
}
extension CustomiseViewController {
    func setViewModelObserver(model:ViewModel){
        var viewModel = model
        viewModel.updateLoadingStatus = { [weak self] in
            let _ = viewModel.isLoading ? self?.showProgressHUD() : self?.hideProgressHUD()
        }
        viewModel.showAlertClosure = { [weak self] in
            if let error = viewModel.error {
                print(error.localizedDescription)
                self?.view.makeToast(error.localizedDescription, duration: 2.0, position: CSToastPositionBottom)
            }
        }
    }
}
// Yon can find below code in my next repositor Present View Controller Transitions. Only import that class in project
extension CustomiseViewController : UIViewControllerTransitioningDelegate {
    //Mark Custom present view controller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionPresentationAnimator.init(ispresenting: false, style: .Right)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionPresentationAnimator.init(ispresenting: true, style: .Left)
    }
}
extension CustomiseViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
// Override this method in the particular class where search is used
extension CustomiseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}

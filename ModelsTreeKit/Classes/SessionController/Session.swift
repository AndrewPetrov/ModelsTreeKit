//
//  Session.swift
//  SessionSwift
//
//  Created by aleksey on 10.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public typealias SessionCompletionParams = [String: AnyObject]

protocol SessionDelegate: class {
  
  func sessionDidPrepareToShowRootRepresenation(_ session: Session) -> Void
  func session(_ session: Session, didCloseWithParams params: Any?) -> Void
  func sessionDidOpen(_ session: Session) -> Void
  func sessionNeedsSave(_ session: Session) -> Void
  
}

open class Session: Model {
  
  public var services: ServiceLocator!
  public var credentials: SessionCredentials?
  
  private weak var controller: SessionDelegate?
  
  public required init() {
    super.init(parent: nil)
  }
  
  public required init(archivationProxy: ArchivationProxy) {
    super.init(parent: nil)
  }
  
  public required init(params: SessionCompletionParams) {
    super.init(parent: nil)
    credentials = SessionCredentials(params: params)
  }
  
  public required init(parent: Model?) {
    super.init(parent: parent)
  }
  
  open func sessionDidLoad() {}
  
  func openWithController(_ controller: SessionController) {
    self.controller = controller
    self.services.takeOff()
    self.controller?.sessionDidOpen(self)
    self.controller?.sessionDidPrepareToShowRootRepresenation(self)
    sessionDidLoad()
  }
  
  public func closeWithParams(_ params: Any?) {
    sessionWillClose()
    services.prepareToClose()
    controller?.session(self, didCloseWithParams: params)
  }
  
  public func save() {
    controller?.sessionNeedsSave(self)
  }
  
  func refresh(withParams params: SessionCompletionParams) {
    credentials = SessionCredentials(params: params)
  }
  
}


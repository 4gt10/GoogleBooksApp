//
//  Router.swift
//  CDEK
//
//  Created by Artur Chernov on 08/02/2018.
//

import LightRoute

protocol Router {
    
    var transitionHandler: TransitionHandler! { get set }
}

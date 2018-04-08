//
//  BookDetailsRoutable.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import LightRoute

protocol BookDetailsRoutable: Router {
    
    func openDetails(withViewModel: VolumeViewModel)
}

extension BookDetailsRoutable {
    
    func openDetails(withViewModel viewModel: VolumeViewModel) {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.bookDetails()),
            to: BookDetailsModuleInput.self
        )
        .to(preferred: .navigationController(style: .push))
        .then { moduleInput in
            moduleInput.configure(withViewModel: viewModel)
        }
    }
}

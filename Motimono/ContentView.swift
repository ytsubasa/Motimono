//


import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        BelongingsSiuationListView()
    }
}

#Preview {
    ContentView()
}
//


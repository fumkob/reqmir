import ReqmirProtocol
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Reqmir")
                .font(.largeTitle)
            Text("Protocol version \(ReqmirProtocol.version)")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

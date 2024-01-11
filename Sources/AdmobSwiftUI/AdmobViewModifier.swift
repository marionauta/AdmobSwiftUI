import GoogleMobileAds
import SwiftUI

public extension View {
    func withAdmob() -> some View {
        modifier(AdmobViewModifier())
    }
}

private struct AdmobViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                await GADMobileAds.sharedInstance().start()
            }
    }
}

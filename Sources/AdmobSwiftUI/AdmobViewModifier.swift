#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif
import SwiftUI

public extension View {
    func withAdmob() -> some View {
        #if canImport(GoogleMobileAds)
        modifier(AdmobViewModifier())
        #else
        self
        #endif
    }
}

#if canImport(GoogleMobileAds)
private struct AdmobViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                await GADMobileAds.sharedInstance().start()
            }
    }
}
#endif

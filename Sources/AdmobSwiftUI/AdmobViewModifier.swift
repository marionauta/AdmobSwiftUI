#if !os(visionOS)
import GoogleMobileAds
#endif
import SwiftUI

public extension View {
    func withAdmob() -> some View {
        #if os(visionOS)
        self
        #else
        modifier(AdmobViewModifier())
        #endif
    }
}

#if !os(visionOS)
private struct AdmobViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                await GADMobileAds.sharedInstance().start()
            }
    }
}
#endif

import SwiftUI
import UIKit

enum AppTab: String, CaseIterable {
    case home = "Home"
    case compass = "Compass"
    case profile = "Profile"

    var symbol: String {
        switch self {
        case .home: "sparkles"
        case .compass: "location.north.line"
        case .profile: "person.crop.circle"
        }
    }
}

enum SearchStage: String {
    case activeSearch
    case matchFound
    case timeCoordinationOpen
    case userVotedWaiting
    case sharedTimeFound
    case dateBeingPlanned
    case datePlanReady

    var title: String {
        switch self {
        case .activeSearch: "Live search"
        case .matchFound: "Match found"
        case .timeCoordinationOpen: "Coordinate time"
        case .userVotedWaiting: "Waiting for Ava"
        case .sharedTimeFound: "Shared time found"
        case .dateBeingPlanned: "Planning date"
        case .datePlanReady: "Date plan ready"
        }
    }

    var subtitle: String {
        switch self {
        case .activeSearch: "Swipe experiences to sharpen what QDate should plan."
        case .matchFound: "Ava matches your date energy and availability."
        case .timeCoordinationOpen: "Pick the times that feel right."
        case .userVotedWaiting: "Your choices are saved. QDate is waiting for Ava."
        case .sharedTimeFound: "You both aligned on Sunday evening."
        case .dateBeingPlanned: "QDate is assembling the reservation, route, and plan."
        case .datePlanReady: "Your real-world date is ready."
        }
    }
}

struct DemoUser {
    var name: String
    var age: Int
    var city: String
    var vibe: String
    var bio: String
    var interests: [String]
    var favorites: [String]
    var bucketList: [String]
    var prompts: [String]
}

struct DateExperience: Identifiable, Equatable {
    let id: String
    let title: String
    let category: String
    let location: String
    let budget: String
    let description: String
    let symbol: String
    let colors: [Color]
}

struct ActiveMatch {
    var name: String
    var age: Int
    var city: String
    var compatibility: [String]
    var sharedVibes: [String]
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let day: String
    let time: String
    let note: String
    var partnerStatus: PartnerSlotStatus
}

enum PartnerSlotStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case unavailable = "Busy"

    var color: Color {
        switch self {
        case .pending: .gray
        case .accepted: QTheme.success
        case .unavailable: QTheme.warning
        }
    }
}

@MainActor
final class DemoStore: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var stage: SearchStage = .activeSearch
    @Published var readinessScore: Double = 42
    @Published var selectedExperienceIndex = 0
    @Published var likedExperienceIDs: Set<String> = []
    @Published var dislikedExperienceIDs: Set<String> = []
    @Published var selectedTimeSlotIDs: Set<UUID> = []
    @Published var selectedBudget = "Premium"
    @Published var selectedGender = "Women"
    @Published var minAge = 25.0
    @Published var maxAge = 34.0
    @Published var autosaveEnabled = true
    @Published var notificationsEnabled = true
    @Published var backupContact = "Text me first"
    @Published var showFilters = false
    @Published var showExperienceDetails: DateExperience?
    @Published var showTimeCoordination = false
    @Published var showProfileEditor = false
    @Published var showPhotoEditor = false

    let user = DemoUser(
        name: "Chris",
        age: 29,
        city: "Hamburg",
        vibe: "Curious, warm, decisive",
        bio: "Looking for intentional dates that feel easy, thoughtful, and a little cinematic.",
        interests: ["design", "deep talks", "coffee walks", "live music", "founder energy"],
        favorites: ["natural wine", "quiet bars", "city lights"],
        bucketList: ["midnight harbor walk", "learn salsa", "weekend in Lisbon"],
        prompts: [
            "Perfect first date: something planned well enough that we can be spontaneous.",
            "Green flag: someone who follows through.",
            "I am happiest when a conversation gets real without becoming heavy."
        ]
    )

    let match = ActiveMatch(
        name: "Ava",
        age: 28,
        city: "Hamburg",
        compatibility: [
            "Both prefer intentional first dates over endless texting.",
            "Shared Sunday evening availability.",
            "High overlap on calm venues, food, and city walks."
        ],
        sharedVibes: ["low-pressure", "romantic", "curated", "offline-first"]
    )

    let experiences: [DateExperience] = [
        DateExperience(
            id: "jazz",
            title: "Listening Room",
            category: "Music",
            location: "St. Pauli",
            budget: "Premium",
            description: "A quiet jazz set, two reserved seats, and a short walk after the encore.",
            symbol: "music.mic",
            colors: [Color(red: 0.30, green: 0.12, blue: 0.92), Color(red: 0.95, green: 0.20, blue: 0.62)]
        ),
        DateExperience(
            id: "wine",
            title: "Natural Wine Hour",
            category: "Drinks",
            location: "Schanze",
            budget: "Medium",
            description: "A small table, one guided flight, and conversation prompts that do not feel forced.",
            symbol: "wineglass",
            colors: [Color(red: 0.57, green: 0.13, blue: 0.72), Color(red: 0.18, green: 0.60, blue: 0.88)]
        ),
        DateExperience(
            id: "harbor",
            title: "Harbor Glow Walk",
            category: "Walk",
            location: "HafenCity",
            budget: "Light",
            description: "A scenic route, warm drinks, and one good place to stop if the chemistry is there.",
            symbol: "water.waves",
            colors: [Color(red: 0.05, green: 0.20, blue: 0.60), Color(red: 0.48, green: 0.21, blue: 1.0)]
        ),
        DateExperience(
            id: "chef",
            title: "Counter Dinner",
            category: "Food",
            location: "Eimsbuettel",
            budget: "Premium",
            description: "Two seats at the chef counter where the plan feels special without becoming stiff.",
            symbol: "fork.knife",
            colors: [Color(red: 0.18, green: 0.07, blue: 0.28), Color(red: 0.93, green: 0.39, blue: 0.28)]
        ),
        DateExperience(
            id: "gallery",
            title: "After-Hours Gallery",
            category: "Culture",
            location: "Altona",
            budget: "Medium",
            description: "A compact exhibition, one shared favorite piece, and a reservation nearby.",
            symbol: "photo.artframe",
            colors: [Color(red: 0.11, green: 0.32, blue: 0.68), Color(red: 0.76, green: 0.35, blue: 0.96)]
        )
    ]

    @Published var timeSlots: [TimeSlot] = [
        TimeSlot(day: "Friday", time: "19:30", note: "Drinks first, flexible dinner after", partnerStatus: .pending),
        TimeSlot(day: "Saturday", time: "18:00", note: "Early dinner and walk", partnerStatus: .unavailable),
        TimeSlot(day: "Sunday", time: "19:00", note: "Best fit for both calendars", partnerStatus: .accepted)
    ]

    var currentExperience: DateExperience? {
        guard selectedExperienceIndex < experiences.count else { return nil }
        return experiences[selectedExperienceIndex]
    }

    var hasEnoughSignal: Bool {
        likedExperienceIDs.count + dislikedExperienceIDs.count >= 3 || readinessScore >= 76
    }

    var isCompassLocked: Bool {
        stage != .activeSearch && stage != .matchFound
    }

    func swipeCurrent(liked: Bool) {
        guard let experience = currentExperience else { return }
        if liked {
            likedExperienceIDs.insert(experience.id)
            readinessScore = min(100, readinessScore + 13)
            Haptics.success()
        } else {
            dislikedExperienceIDs.insert(experience.id)
            readinessScore = min(100, readinessScore + 8)
            Haptics.light()
        }
        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            selectedExperienceIndex += 1
        }
    }

    func revealMatch() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            readinessScore = max(readinessScore, 86)
            stage = .matchFound
        }
        Haptics.success()
    }

    func openTimeCoordination() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .timeCoordinationOpen
            showTimeCoordination = true
        }
    }

    func submitTimes() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .userVotedWaiting
            showTimeCoordination = false
        }
        Haptics.success()
    }

    func simulateSharedTime() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .sharedTimeFound
        }
    }

    func startPlanning() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            stage = .dateBeingPlanned
        }
    }

    func finishPlan() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
            stage = .datePlanReady
        }
        Haptics.success()
    }
}

enum QTheme {
    static let plum = Color(red: 0.09, green: 0.04, blue: 0.16)
    static let midnight = Color(red: 0.03, green: 0.02, blue: 0.08)
    static let violet = Color(red: 0.58, green: 0.25, blue: 1.0)
    static let electric = Color(red: 0.76, green: 0.39, blue: 1.0)
    static let rose = Color(red: 1.0, green: 0.28, blue: 0.52)
    static let text = Color.white
    static let muted = Color.white.opacity(0.68)
    static let success = Color(red: 0.34, green: 0.95, blue: 0.66)
    static let warning = Color(red: 1.0, green: 0.60, blue: 0.28)
}

enum Haptics {
    @MainActor
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @MainActor
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

struct ContentView: View {
    @StateObject private var store = DemoStore()

    var body: some View {
        MainShell()
            .environmentObject(store)
            .preferredColorScheme(.dark)
    }
}

struct MainShell: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                GlassHeader()
                    .padding(.horizontal, 18)
                    .padding(.top, 12)

                Group {
                    switch store.selectedTab {
                    case .home:
                        HomeScreen()
                    case .compass:
                        CompassScreen()
                    case .profile:
                        ProfileScreen()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack {
                Spacer()
                GlassTabBar()
                    .padding(.horizontal, 18)
                    .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $store.showFilters) {
            FilterSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $store.showExperienceDetails) { experience in
            ExperienceDetailSheet(experience: experience)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $store.showTimeCoordination) {
            TimeCoordinationSheet()
        }
        .sheet(isPresented: $store.showProfileEditor) {
            ProfileEditSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $store.showPhotoEditor) {
            PhotoEditSheet()
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [QTheme.midnight, QTheme.plum, Color(red: 0.05, green: 0.02, blue: 0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(QTheme.violet.opacity(0.28))
                .frame(width: 360, height: 360)
                .blur(radius: 90)
                .offset(x: -160, y: -260)

            Circle()
                .fill(QTheme.rose.opacity(0.20))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: 180, y: 220)
        }
    }
}

struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    let glow: Bool
    @ViewBuilder var content: Content

    init(cornerRadius: CGFloat = 28, glow: Bool = false, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.glow = glow
        self.content = content()
    }

    var body: some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color.white.opacity(0.07))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.42), Color.white.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: glow ? QTheme.violet.opacity(0.38) : Color.black.opacity(0.28), radius: glow ? 30 : 18, x: 0, y: 16)
            }
    }
}

struct GlassButton: View {
    let title: String
    let symbol: String?
    var prominent = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 15, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                Capsule(style: .continuous)
                    .fill(prominent ? QTheme.violet.opacity(0.62) : Color.white.opacity(0.10))
                    .background(.ultraThinMaterial, in: Capsule(style: .continuous))
                    .overlay(Capsule(style: .continuous).stroke(Color.white.opacity(0.20), lineWidth: 1))
                    .shadow(color: prominent ? QTheme.violet.opacity(0.35) : .clear, radius: 20, y: 10)
            }
        }
        .buttonStyle(.plain)
    }
}

struct GlassIconButton: View {
    let symbol: String
    var tint: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 48, height: 48)
                .background {
                    Circle()
                        .fill(Color.white.opacity(0.10))
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                }
        }
        .buttonStyle(.plain)
    }
}

struct GlassHeader: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("QDate")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text(store.stage.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(QTheme.muted)
                }

                Spacer()

                StagePill(stage: store.stage)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
    }
}

struct StagePill: View {
    let stage: SearchStage

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(stage == .datePlanReady ? QTheme.success : QTheme.electric)
                .frame(width: 8, height: 8)
            Text(stage == .activeSearch ? "LIVE" : "DEMO")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(QTheme.violet.opacity(0.28), in: Capsule())
    }
}

struct GlassTabBar: View {
    @EnvironmentObject private var store: DemoStore
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                        store.selectedTab = tab
                    }
                    Haptics.light()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.symbol)
                        if store.selectedTab == tab {
                            Text(tab.rawValue)
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                    .foregroundStyle(store.selectedTab == tab ? .white : Color.white.opacity(0.62))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background {
                        if store.selectedTab == tab {
                            Capsule()
                                .fill(QTheme.violet.opacity(0.45))
                                .matchedGeometryEffect(id: "activeTab", in: namespace)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background {
            Capsule()
                .fill(Color.white.opacity(0.08))
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.34), radius: 24, y: 14)
        }
    }
}

struct HomeScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                StageHero()

                switch store.stage {
                case .activeSearch:
                    ActiveSearchView()
                case .matchFound, .timeCoordinationOpen:
                    MatchCockpit()
                case .userVotedWaiting:
                    WaitingForMatchView()
                case .sharedTimeFound:
                    SharedTimeFoundView()
                case .dateBeingPlanned:
                    DateBeingPlannedView()
                case .datePlanReady:
                    DatePlanReadyView()
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 112)
        }
    }
}

struct StageHero: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 30, glow: store.stage == .datePlanReady) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(store.stage.title)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text(store.stage.subtitle)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Image(systemName: store.stage == .datePlanReady ? "checkmark.seal.fill" : "wand.and.stars")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(QTheme.electric)
                }

                JourneyTimeline()
            }
            .padding(20)
        }
    }
}

struct JourneyTimeline: View {
    @EnvironmentObject private var store: DemoStore
    private let stages: [SearchStage] = [.activeSearch, .matchFound, .timeCoordinationOpen, .userVotedWaiting, .dateBeingPlanned, .datePlanReady]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(stages.indices, id: \.self) { index in
                Capsule()
                    .fill(index <= currentIndex ? QTheme.electric : Color.white.opacity(0.14))
                    .frame(height: 5)
            }
        }
        .accessibilityLabel("Date journey progress")
    }

    private var currentIndex: Int {
        switch store.stage {
        case .activeSearch: 0
        case .matchFound: 1
        case .timeCoordinationOpen: 2
        case .userVotedWaiting, .sharedTimeFound: 3
        case .dateBeingPlanned: 4
        case .datePlanReady: 5
        }
    }
}

struct ActiveSearchView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            ReadinessCard()

            HStack {
                Text("Swipe date ideas")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                GlassIconButton(symbol: "slider.horizontal.3") {
                    store.showFilters = true
                }
            }

            ExperienceSwipeDeck()

            if store.hasEnoughSignal {
                ProfileQuestionStack()
                GlassButton(title: "Reveal Curated Match", symbol: "heart.circle.fill", prominent: true) {
                    store.revealMatch()
                }
            } else {
                GuidanceTasks()
            }
        }
    }
}

struct ReadinessCard: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Match readiness")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                        Text("QDate learns from date ideas, not chat noise.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    Text("\(Int(store.readinessScore))%")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(QTheme.electric)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.10))
                        Capsule()
                            .fill(LinearGradient(colors: [QTheme.violet, QTheme.rose], startPoint: .leading, endPoint: .trailing))
                            .frame(width: proxy.size.width * max(0.04, store.readinessScore / 100))
                            .shadow(color: QTheme.violet.opacity(0.55), radius: 12)
                    }
                }
                .frame(height: 10)

                HStack(spacing: 8) {
                    MetricPill(value: "\(store.likedExperienceIDs.count)", label: "liked")
                    MetricPill(value: "\(store.dislikedExperienceIDs.count)", label: "skipped")
                    MetricPill(value: store.hasEnoughSignal ? "ready" : "learning", label: "status")
                }
            }
            .padding(18)
        }
    }
}

struct MetricPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.58))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct ExperienceSwipeDeck: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            ForEach(Array(store.experiences.enumerated().reversed()), id: \.element.id) { index, experience in
                if index >= store.selectedExperienceIndex && index < store.selectedExperienceIndex + 3 {
                    ExperienceCard(
                        experience: experience,
                        isTop: index == store.selectedExperienceIndex
                    )
                    .scaleEffect(index == store.selectedExperienceIndex ? 1 : 0.94 - CGFloat(index - store.selectedExperienceIndex) * 0.03)
                    .offset(y: CGFloat(index - store.selectedExperienceIndex) * 14)
                    .zIndex(Double(store.experiences.count - index))
                }
            }

            if store.currentExperience == nil {
                GlassCard(cornerRadius: 28) {
                    VStack(spacing: 14) {
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.system(size: 42))
                            .foregroundStyle(QTheme.electric)
                        Text("Enough signal collected")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                        Text("QDate has what it needs to move from search into a curated match.")
                            .font(.system(size: 14))
                            .foregroundStyle(QTheme.muted)
                            .multilineTextAlignment(.center)
                    }
                    .padding(28)
                    .frame(maxWidth: .infinity, minHeight: 420)
                }
            }
        }
        .frame(height: 360)
    }
}

struct ExperienceCard: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let experience: DateExperience
    let isTop: Bool
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(LinearGradient(colors: experience.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay {
                    Image(systemName: experience.symbol)
                        .font(.system(size: 130, weight: .thin))
                        .foregroundStyle(.white.opacity(0.18))
                        .offset(x: 76, y: -96)
                }
                .overlay {
                    LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .center, endPoint: .bottom)
                }

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(experience.category, systemImage: "sparkle")
                    Spacer()
                    Text(experience.budget)
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white.opacity(0.84))

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text(experience.title)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text(experience.location)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(QTheme.electric)
                    Text(experience.description)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 12) {
                    GlassIconButton(symbol: "xmark", tint: QTheme.warning) {
                        store.swipeCurrent(liked: false)
                    }
                    GlassButton(title: "Details", symbol: "info.circle") {
                        store.showExperienceDetails = experience
                    }
                    GlassIconButton(symbol: "heart.fill", tint: QTheme.rose) {
                        store.swipeCurrent(liked: true)
                    }
                }
            }
            .padding(22)

            SwipeIndicator(title: "LIKE", color: QTheme.success, opacity: max(0, dragOffset.width / 120))
                .rotationEffect(.degrees(-12))
                .offset(x: 22, y: -310)

            SwipeIndicator(title: "PASS", color: QTheme.warning, opacity: max(0, -dragOffset.width / 120))
                .rotationEffect(.degrees(12))
                .offset(x: 210, y: -310)
        }
        .frame(height: 360)
        .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 34, style: .continuous).stroke(Color.white.opacity(0.20), lineWidth: 1))
        .shadow(color: QTheme.violet.opacity(0.28), radius: 26, y: 18)
        .offset(dragOffset)
        .rotationEffect(.degrees(reduceMotion ? 0 : Double(dragOffset.width / 22)))
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard isTop else { return }
                    dragOffset = value.translation
                }
                .onEnded { value in
                    guard isTop else { return }
                    if value.translation.width > 105 {
                        store.swipeCurrent(liked: true)
                    } else if value.translation.width < -105 {
                        store.swipeCurrent(liked: false)
                    }
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.78)) {
                        dragOffset = .zero
                    }
                }
        )
    }
}

struct SwipeIndicator: View {
    let title: String
    let color: Color
    let opacity: Double

    var body: some View {
        Text(title)
            .font(.system(size: 28, weight: .black, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(color, lineWidth: 3))
            .opacity(min(1, opacity))
            .scaleEffect(0.92 + min(1, opacity) * 0.12)
    }
}

struct ProfileQuestionStack: View {
    var body: some View {
        GlassCard(cornerRadius: 24, glow: true) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Profile clarity unlocked")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(.white)
                PromptRow(question: "What makes a first date feel safe?", answer: "Clear plan, warm tone, easy exit.")
                PromptRow(question: "What should QDate avoid?", answer: "Crowded bars and endless texting.")
            }
            .padding(18)
        }
    }
}

struct PromptRow: View {
    let question: String
    let answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(QTheme.muted)
            Text(answer)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct GuidanceTasks: View {
    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Improve match readiness")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                GuidanceRow(symbol: "heart.text.square", title: "Swipe 3 date ideas", detail: "Helps QDate understand your ideal setting.")
                GuidanceRow(symbol: "calendar.badge.clock", title: "Confirm availability", detail: "Needed before a match can become a plan.")
            }
            .padding(18)
        }
    }
}

struct GuidanceRow: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(QTheme.electric)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(QTheme.muted)
            }
        }
    }
}

struct MatchCockpit: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            GlassCard(cornerRadius: 30, glow: true) {
                VStack(spacing: 18) {
                    HStack(spacing: 16) {
                        AvatarOrb(name: store.user.name, symbol: "person.fill", color: QTheme.violet)
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(QTheme.rose)
                        AvatarOrb(name: store.match.name, symbol: "person.fill", color: QTheme.rose)
                    }

                    VStack(spacing: 6) {
                        Text("You and \(store.match.name), \(store.match.age)")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Text("QDate found a high-intent match in \(store.match.city).")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(QTheme.muted)
                    }

                    VStack(spacing: 10) {
                        ForEach(store.match.compatibility, id: \.self) { reason in
                            CompatibilityReason(text: reason)
                        }
                    }
                }
                .padding(20)
            }

            TimelineCard()

            GlassButton(
                title: store.stage == .timeCoordinationOpen ? "Edit Time Choices" : "Coordinate Availability",
                symbol: "calendar.badge.clock",
                prominent: true
            ) {
                store.openTimeCoordination()
            }
        }
    }
}

struct AvatarOrb: View {
    let name: String
    let symbol: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.28))
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.26), lineWidth: 1))
                    .shadow(color: color.opacity(0.35), radius: 20, y: 8)
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 86, height: 86)
            Text(name)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

struct CompatibilityReason: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(QTheme.success)
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.82))
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct TimelineCard: View {
    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Date journey")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                TimelineRow(done: true, title: "Preferences learned", detail: "Date ideas and readiness signal collected.")
                TimelineRow(done: true, title: "Match confirmed", detail: "Ava fits your intent and vibe.")
                TimelineRow(done: false, title: "Coordinate time", detail: "Choose shared availability.")
                TimelineRow(done: false, title: "QDate plans", detail: "Venue, route, meeting point, and plan.")
            }
            .padding(18)
        }
    }
}

struct TimelineRow: View {
    let done: Bool
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(done ? QTheme.success : QTheme.muted)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(QTheme.muted)
            }
            Spacer()
        }
    }
}

struct WaitingForMatchView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            GlassCard(cornerRadius: 28) {
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.checkmark")
                        .font(.system(size: 46, weight: .semibold))
                        .foregroundStyle(QTheme.electric)
                    Text("Your times are saved")
                        .font(.system(size: 25, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("QDate is waiting for Ava to confirm a shared window. You can still edit your choices.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(QTheme.muted)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 12) {
                        GlassButton(title: "Edit Times", symbol: "pencil") {
                            store.openTimeCoordination()
                        }
                        GlassButton(title: "Simulate Reply", symbol: "bolt.fill", prominent: true) {
                            store.simulateSharedTime()
                        }
                    }
                }
                .padding(24)
            }
        }
    }
}

struct SharedTimeFoundView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            PlanningTicket(title: "Shared time found", status: "Sunday 19:00", detail: "Ava accepted your strongest slot. QDate can now plan the actual date.")
            GlassButton(title: "Let QDate Plan It", symbol: "wand.and.stars", prominent: true) {
                store.startPlanning()
            }
        }
    }
}

struct DateBeingPlannedView: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(spacing: 18) {
            PlanningTicket(title: "Planning in progress", status: "Reservation route venue", detail: "QDate is choosing a venue, meeting point, route, and the right first-date pacing.")
            GlassCard(cornerRadius: 22) {
                VStack(alignment: .leading, spacing: 12) {
                    PlanProgressRow(done: true, title: "Shared time locked")
                    PlanProgressRow(done: true, title: "Experience preference selected")
                    PlanProgressRow(done: false, title: "Venue confirmation")
                    PlanProgressRow(done: false, title: "Meeting point")
                }
                .padding(18)
            }
            GlassButton(title: "Show Final Plan", symbol: "checkmark.seal.fill", prominent: true) {
                store.finishPlan()
            }
        }
    }
}

struct PlanningTicket: View {
    let title: String
    let status: String
    let detail: String

    var body: some View {
        GlassCard(cornerRadius: 28, glow: true) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(title)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "ticket.fill")
                        .foregroundStyle(QTheme.electric)
                }
                Text(status)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(QTheme.success)
                Text(detail)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(QTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(22)
        }
    }
}

struct PlanProgressRow: View {
    let done: Bool
    let title: String

    var body: some View {
        HStack {
            Image(systemName: done ? "checkmark.circle.fill" : "circle.dotted")
                .foregroundStyle(done ? QTheme.success : QTheme.electric)
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .bold))
            Spacer()
        }
    }
}

struct DatePlanReadyView: View {
    @EnvironmentObject private var store: DemoStore
    @State private var expanded = false

    var body: some View {
        VStack(spacing: 18) {
            GlassCard(cornerRadius: 34, glow: true) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("QDate Pass")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(QTheme.electric)
                            Text("Sunday Date With \(store.match.name)")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(QTheme.rose)
                    }

                    VStack(spacing: 12) {
                        PlanField(symbol: "calendar", label: "Date", value: "Sunday, June 7")
                        PlanField(symbol: "clock", label: "Time", value: "19:00")
                        PlanField(symbol: "mappin.and.ellipse", label: "Meeting point", value: "HafenCity coffee kiosk")
                        PlanField(symbol: "sparkles", label: "Plan", value: "Harbor glow walk plus reserved natural wine table")
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Countdown")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(QTheme.muted)
                            Text("1 day 6 hours")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        GlassIconButton(symbol: "square.and.arrow.up") {}
                    }
                }
                .padding(22)
            }

            GlassCard(cornerRadius: 22) {
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            expanded.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Why this match works")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                            Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        }
                        .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    if expanded {
                        ForEach(store.match.compatibility, id: \.self) { reason in
                            CompatibilityReason(text: reason)
                        }
                    }
                }
                .padding(18)
            }
        }
    }
}

struct PlanField: View {
    let symbol: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(QTheme.electric)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                Text(value)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct CompassScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                if store.isCompassLocked {
                    LockedBanner()
                }

                PreferenceSection(title: "Date budget", locked: store.isCompassLocked) {
                    ChipPicker(options: ["Light", "Medium", "Premium"], selection: $store.selectedBudget, locked: store.isCompassLocked)
                }

                PreferenceSection(title: "Desired match", locked: store.isCompassLocked) {
                    ChipPicker(options: ["Women", "Men", "Non-binary", "Open"], selection: $store.selectedGender, locked: store.isCompassLocked)
                }

                PreferenceSection(title: "Age range", locked: store.isCompassLocked) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(Int(store.minAge))")
                            Spacer()
                            Text("\(Int(store.maxAge))")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        Slider(value: $store.minAge, in: 21...40)
                            .disabled(store.isCompassLocked)
                        Slider(value: $store.maxAge, in: 24...46)
                            .disabled(store.isCompassLocked)
                    }
                }

                PreferenceSection(title: "Weekly availability", locked: store.isCompassLocked) {
                    AvailabilityGrid(locked: store.isCompassLocked)
                }

                PreferenceSection(title: "Safety and planning", locked: false) {
                    ChipPicker(options: ["Text me first", "Share itinerary", "Call backup"], selection: $store.backupContact, locked: false)
                    Toggle("Autosave preference changes", isOn: $store.autosaveEnabled)
                        .tint(QTheme.violet)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 112)
        }
    }
}

struct LockedBanner: View {
    var body: some View {
        GlassCard(cornerRadius: 22, glow: true) {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(QTheme.electric)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Compass locked")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Preferences are frozen while QDate coordinates this match.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(QTheme.muted)
                }
                Spacer()
            }
            .padding(16)
        }
    }
}

struct PreferenceSection<Content: View>: View {
    let title: String
    let locked: Bool
    @ViewBuilder var content: Content

    var body: some View {
        GlassCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    if locked {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(QTheme.muted)
                    }
                }
                content
                    .opacity(locked ? 0.58 : 1)
            }
            .padding(18)
        }
    }
}

struct ChipPicker: View {
    let options: [String]
    @Binding var selection: String
    let locked: Bool

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 98), spacing: 10)], spacing: 10) {
            ForEach(options, id: \.self) { option in
                Button {
                    guard !locked else { return }
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                        selection = option
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(selection == option ? QTheme.violet.opacity(0.55) : Color.white.opacity(0.08), in: Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(selection == option ? 0.34 : 0.10), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .disabled(locked)
            }
        }
    }
}

struct AvailabilityGrid: View {
    let locked: Bool
    private let rows = [
        ("Fri", "19:30", true),
        ("Sat", "18:00", false),
        ("Sun", "19:00", true),
        ("Tue", "20:00", true)
    ]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.0) { row in
                HStack {
                    Text(row.0)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 42, alignment: .leading)
                    Text(row.1)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(QTheme.muted)
                    Spacer()
                    Text(row.2 ? "Open" : "Blocked")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(row.2 ? QTheme.success : QTheme.warning)
                }
                .padding(12)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
}

struct ProfileScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ProfileHeader()
                    ProfileSection(title: "Vibe") {
                        Text(store.user.vibe)
                            .profileText()
                    }
                    ProfileSection(title: "Favorites") {
                        TagWrap(tags: store.user.favorites)
                    }
                    ProfileSection(title: "Interests") {
                        TagWrap(tags: store.user.interests)
                    }
                    ProfileSection(title: "Bucket list") {
                        TagWrap(tags: store.user.bucketList)
                    }
                    ProfileSection(title: "About") {
                        Text(store.user.bio)
                            .profileText()
                    }
                    ProfileSection(title: "Dating prompts") {
                        VStack(spacing: 10) {
                            ForEach(store.user.prompts, id: \.self) { prompt in
                                Text(prompt)
                                    .profileText()
                                    .padding(12)
                                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                    }
                    SettingsLinks()
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 112)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ProfileHeader: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 30, glow: true) {
            VStack(spacing: 16) {
                Button {
                    store.showPhotoEditor = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [QTheme.violet, QTheme.rose], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 118, height: 118)
                            .shadow(color: QTheme.violet.opacity(0.40), radius: 30, y: 12)
                        Image(systemName: "person.fill")
                            .font(.system(size: 46, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)

                VStack(spacing: 5) {
                    Text("\(store.user.name), \(store.user.age)")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text(store.user.city)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(QTheme.muted)
                }

                GlassButton(title: "Edit Profile", symbol: "pencil", prominent: true) {
                    store.showProfileEditor = true
                }
            }
            .padding(22)
        }
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
        }
    }
}

extension Text {
    func profileText() -> some View {
        self.font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Color.white.opacity(0.82))
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct TagWrap: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 94), spacing: 8)], spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.09), in: Capsule())
            }
        }
    }
}

struct SettingsLinks: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(spacing: 4) {
                NavigationLink {
                    AccountSettingsScreen()
                } label: {
                    SettingsRow(symbol: "person.badge.key", title: "Account settings")
                }
                NavigationLink {
                    AppSettingsScreen()
                } label: {
                    SettingsRow(symbol: "switch.2", title: "App settings")
                }
                NavigationLink {
                    SupportFAQScreen()
                } label: {
                    SettingsRow(symbol: "questionmark.circle", title: "Support and FAQ")
                }
                Toggle("Notifications", isOn: $store.notificationsEnabled)
                    .tint(QTheme.violet)
                    .foregroundStyle(.white)
                    .padding(12)
            }
            .padding(6)
        }
    }
}

struct SettingsRow: View {
    let symbol: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(QTheme.electric)
                .frame(width: 28)
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(QTheme.muted)
        }
        .padding(12)
        .contentShape(Rectangle())
    }
}

struct AccountSettingsScreen: View {
    var body: some View {
        SettingsDetailScreen(title: "Account") {
            DetailLine(title: "Demo user", value: "Chris")
            DetailLine(title: "Email", value: "demo@qdate.app")
            DetailLine(title: "Privacy", value: "Local mock state")
        }
    }
}

struct AppSettingsScreen: View {
    var body: some View {
        SettingsDetailScreen(title: "App") {
            DetailLine(title: "Theme", value: "Liquid Glass dark")
            DetailLine(title: "Haptics", value: "Enabled")
            DetailLine(title: "Autosave", value: "On")
        }
    }
}

struct SupportFAQScreen: View {
    var body: some View {
        SettingsDetailScreen(title: "Support") {
            DetailLine(title: "What does QDate plan?", value: "Time, place, route, and date flow.")
            DetailLine(title: "Is this production?", value: "No, hackathon demo state only.")
            DetailLine(title: "Can I cancel?", value: "A future version would support this.")
        }
    }
}

struct SettingsDetailScreen<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(title)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    GlassCard(cornerRadius: 22) {
                        VStack(spacing: 10) {
                            content
                        }
                        .padding(18)
                    }
                }
                .padding(20)
            }
        }
    }
}

struct DetailLine: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(QTheme.muted)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 8)
    }
}

struct FilterSheet: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 20) {
                Text("Date filters")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                PreferenceSection(title: "Budget tier", locked: false) {
                    ChipPicker(options: ["Light", "Medium", "Premium"], selection: $store.selectedBudget, locked: false)
                }
                PreferenceSection(title: "Categories", locked: false) {
                    TagWrap(tags: ["Music", "Food", "Walk", "Culture", "Drinks"])
                }
                Spacer()
                GlassButton(title: "Apply Filters", symbol: "checkmark", prominent: true) {
                    store.showFilters = false
                }
            }
            .padding(20)
        }
    }
}

struct ExperienceDetailSheet: View {
    let experience: DateExperience

    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 18) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(LinearGradient(colors: experience.colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 210)
                    .overlay {
                        Image(systemName: experience.symbol)
                            .font(.system(size: 90, weight: .thin))
                            .foregroundStyle(.white.opacity(0.28))
                    }
                Text(experience.title)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("\(experience.category) \(experience.location) \(experience.budget)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(QTheme.electric)
                Text(experience.description)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(QTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(20)
        }
    }
}

struct TimeCoordinationSheet: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Coordinate time")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Select every slot that works. Ava's status updates as QDate coordinates.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    GlassIconButton(symbol: "xmark") {
                        store.showTimeCoordination = false
                        dismiss()
                    }
                }

                VStack(spacing: 12) {
                    ForEach(store.timeSlots) { slot in
                        TimeSlotRow(slot: slot, selected: store.selectedTimeSlotIDs.contains(slot.id)) {
                            if store.selectedTimeSlotIDs.contains(slot.id) {
                                store.selectedTimeSlotIDs.remove(slot.id)
                            } else {
                                store.selectedTimeSlotIDs.insert(slot.id)
                            }
                        }
                    }
                }

                Spacer()

                HStack(spacing: 12) {
                    GlassButton(title: "Decline All", symbol: "xmark") {
                        store.selectedTimeSlotIDs.removeAll()
                    }
                    GlassButton(title: "Submit Times", symbol: "paperplane.fill", prominent: true) {
                        if store.selectedTimeSlotIDs.isEmpty, let accepted = store.timeSlots.first(where: { $0.partnerStatus == .accepted }) {
                            store.selectedTimeSlotIDs.insert(accepted.id)
                        }
                        store.submitTimes()
                    }
                }
            }
            .padding(20)
        }
    }
}

struct TimeSlotRow: View {
    let slot: TimeSlot
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            GlassCard(cornerRadius: 22, glow: selected) {
                HStack(spacing: 14) {
                    Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(selected ? QTheme.success : QTheme.muted)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(slot.day) \(slot.time)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text(slot.note)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    Text(slot.partnerStatus.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(slot.partnerStatus.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(slot.partnerStatus.color.opacity(0.14), in: Capsule())
                }
                .padding(16)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ProfileEditSheet: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 18) {
                Text("Edit profile")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                DetailLine(title: "Vibe", value: store.user.vibe)
                DetailLine(title: "Bio", value: "Mock editable in demo")
                Spacer()
                GlassButton(title: "Save Mock Changes", symbol: "checkmark", prominent: true) {
                    store.showProfileEditor = false
                }
            }
            .padding(20)
        }
    }
}

struct PhotoEditSheet: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 18) {
                Text("Photo editor")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("Demo-safe mock. No camera or library access required.")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(QTheme.muted)
                    .multilineTextAlignment(.center)
                GlassButton(title: "Use Current Photo", symbol: "person.crop.circle", prominent: true) {
                    store.showPhotoEditor = false
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    ContentView()
}

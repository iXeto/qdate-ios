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

}

enum VibeDimension: String, CaseIterable, Identifiable {
    case decisionStyle
    case outlook
    case socialEnergy
    case planningStyle
    case orderStyle

    var id: String { rawValue }

    var title: String {
        switch self {
        case .decisionStyle: "Heart or Head"
        case .outlook: "Pessimist or Optimist"
        case .socialEnergy: "Introvert or Extrovert"
        case .planningStyle: "Planner or Spontaneous"
        case .orderStyle: "Chaotic or Tidy"
        }
    }

    var options: [String] {
        switch self {
        case .decisionStyle: ["Heart", "Head"]
        case .outlook: ["Pessimist", "Optimist"]
        case .socialEnergy: ["Introvert", "Extrovert"]
        case .planningStyle: ["Planner", "Spontaneous"]
        case .orderStyle: ["Chaotic", "Tidy"]
        }
    }

    var displayLabel: String {
        switch self {
        case .decisionStyle: "Decisions"
        case .outlook: "Outlook"
        case .socialEnergy: "Social energy"
        case .planningStyle: "Planning"
        case .orderStyle: "Environment"
        }
    }
}

struct ProfileVibe: Equatable {
    var decisionStyle = "Heart"
    var outlook = "Optimist"
    var socialEnergy = "Introvert"
    var planningStyle = "Spontaneous"
    var orderStyle = "Tidy"

    var selectedValues: [String] {
        VibeDimension.allCases.map { selection(for: $0) }
    }

    func selection(for dimension: VibeDimension) -> String {
        switch dimension {
        case .decisionStyle: decisionStyle
        case .outlook: outlook
        case .socialEnergy: socialEnergy
        case .planningStyle: planningStyle
        case .orderStyle: orderStyle
        }
    }

    mutating func setSelection(_ value: String, for dimension: VibeDimension) {
        switch dimension {
        case .decisionStyle: decisionStyle = value
        case .outlook: outlook = value
        case .socialEnergy: socialEnergy = value
        case .planningStyle: planningStyle = value
        case .orderStyle: orderStyle = value
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
    var favoriteArtist: String
    var favoriteSong: String
    var favoriteMovie: String
    var favoriteFood: String
    var favoriteDestination: String
    var favoriteBook: String
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

struct ProfilePromptDefinition: Identifiable, Hashable {
    let id: String
    let question: String
    let answers: [String]
}

struct ProfileQuestionSlot: Identifiable {
    let id = UUID()
    var questionID: String?
    var selectedAnswers: Set<String> = []
}

struct ProfileEditContext: Identifiable {
    let id: String
    let title: String
}

struct QuestionEditContext: Identifiable {
    let id: UUID
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

enum Weekday: String, CaseIterable, Identifiable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monday: "Monday"
        case .tuesday: "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday: "Thursday"
        case .friday: "Friday"
        case .saturday: "Saturday"
        case .sunday: "Sunday"
        }
    }

    var shortTitle: String {
        switch self {
        case .monday: "Mon"
        case .tuesday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        case .sunday: "Sun"
        }
    }
}

struct AvailabilityTimeSlot: Identifiable, Equatable {
    let id: UUID
    var weekday: Weekday
    var startTime: Date
    var endTime: Date

    init(
        id: UUID = UUID(),
        weekday: Weekday,
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int
    ) {
        self.id = id
        self.weekday = weekday
        let calendar = Calendar.current
        self.startTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: .now) ?? .now
        self.endTime = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: .now) ?? .now
    }

    var formattedRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) – \(formatter.string(from: endTime))"
    }
}

enum DateFilterCatalog {
    static let tiers = ["Light", "Medium", "Premium"]

    static let categoriesByTier: [String: [String]] = [
        "Light": [
            "Café meetup",
            "Nature experience",
            "Museums",
            "Sightseeing",
            "Viewpoints",
            "Food & drinks",
            "Other"
        ],
        "Medium": [
            "Museums",
            "Cinema",
            "Action",
            "Sightseeing",
            "Other"
        ],
        "Premium": [
            "Museums",
            "Theatre",
            "Opera",
            "Action",
            "Sightseeing",
            "Other"
        ]
    ]

    static var allCategories: [String] {
        var seen = Set<String>()
        var result: [String] = []
        for tier in tiers {
            for category in categoriesByTier[tier] ?? [] where seen.insert(category).inserted {
                result.append(category)
            }
        }
        return result
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
    @Published var appliedBudgetTiers: Set<String> = Set(DateFilterCatalog.tiers)
    @Published var appliedFilterCategories: Set<String> = Set(DateFilterCatalog.allCategories)
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
    @Published var showAvailabilityEditor = false
    @Published var showPhotoEditor = false
    @Published var editingProfileSection: ProfileEditContext?
    @Published var editingQuestionSlot: QuestionEditContext?
    @Published var profileVibe = ProfileVibe()
    @Published var aboutText = "Looking for intentional dates that feel easy, thoughtful, and a little cinematic."
    @Published var favoriteArtist = "Daft Punk"
    @Published var favoriteSong = "Get Lucky"
    @Published var favoriteMovie = "Interstellar"
    @Published var favoriteFood = "Sushi"
    @Published var favoriteDestination = "Tokyo"
    @Published var favoriteBook = "The Hobbit"
    @Published var interests = ["🎨 Art galleries", "🗣️ Deep talks", "🚶 Long walks", "🎶 Concerts", "🧠 Personal growth"]
    @Published var biggestWish = "Build a life that feels spacious, brave, and shared with the right person."
    @Published var bucketExperiences = [
        "Take a spontaneous train trip with no fixed plan",
        "Watch sunrise after a great night out",
        "Host a long dinner for friends and future friends"
    ]
    @Published var childhoodDream = "Architect"
    @Published var currentPath = "Founder building relationship technology"
    @Published var profileQuestionSlots = Array(repeating: ProfileQuestionSlot(), count: 5)
    @Published var weeklyAvailability: [AvailabilityTimeSlot] = [
        AvailabilityTimeSlot(weekday: .friday, startHour: 19, startMinute: 30, endHour: 22, endMinute: 0),
        AvailabilityTimeSlot(weekday: .sunday, startHour: 19, startMinute: 0, endHour: 21, endMinute: 0),
        AvailabilityTimeSlot(weekday: .tuesday, startHour: 20, startMinute: 0, endHour: 22, endMinute: 0)
    ]

    let user = DemoUser(
        name: "Chris",
        age: 29,
        city: "Hamburg",
        vibe: "Heart · Optimist · Introvert · Spontaneous · Tidy",
        bio: "Looking for intentional dates that feel easy, thoughtful, and a little cinematic.",
        interests: [],
        favoriteArtist: "Daft Punk",
        favoriteSong: "Get Lucky",
        favoriteMovie: "Interstellar",
        favoriteFood: "Sushi",
        favoriteDestination: "Tokyo",
        favoriteBook: "The Hobbit",
        bucketList: [],
        prompts: []
    )

    let profilePromptDefinitions: [ProfilePromptDefinition] = [
        ProfilePromptDefinition(
            id: "communication",
            question: "How would you describe your communication style?",
            answers: ["Direct and honest", "Calm and thoughtful", "Casual and humorous", "Deep and reflective", "Curious and questioning", "Depends on the situation"]
        ),
        ProfilePromptDefinition(
            id: "opinions",
            question: "How do you deal with differing opinions?",
            answers: ["I enjoy discussing things", "I listen first", "I try to find common ground", "I tend to avoid conflict", "It depends on the topic"]
        ),
        ProfilePromptDefinition(
            id: "newpeople",
            question: "When you meet new people, are you more likely to be...?",
            answers: ["Immediately open", "Reserved at first", "Quiet, but interested", "Quickly talkative when the vibe is right", "Very situation-dependent"]
        ),
        ProfilePromptDefinition(
            id: "important",
            question: "What is most important to you in other people?",
            answers: ["Honesty", "Empathy", "Humor", "Reliability", "Openness", "Self-reflection", "Calmness", "Loyalty"]
        ),
        ProfilePromptDefinition(
            id: "openup",
            question: "How easy is it for you to open up to new people?",
            answers: ["Very easy", "Quickly, if the vibe is right", "Rather slowly", "I need several meetings", "It depends on the person"]
        ),
        ProfilePromptDefinition(
            id: "difficult",
            question: "What do you sometimes find difficult with new connections?",
            answers: ["Making the first move", "Small talk", "Opening up right away", "Honestly saying what I think", "Keeping in touch", "None of these, actually"]
        ),
        ProfilePromptDefinition(
            id: "changed",
            question: "How much have you changed in recent years?",
            answers: ["Hardly at all", "A little", "Quite a lot", "A lot", "I am currently in the middle of changing"]
        ),
        ProfilePromptDefinition(
            id: "groups",
            question: "What role do you usually take on in groups?",
            answers: ["I start conversations", "I listen a lot", "I bring in humor", "I keep the group together", "I observe at first", "I adapt flexibly"]
        ),
        ProfilePromptDefinition(
            id: "connection",
            question: "What makes a good connection for you?",
            answers: ["Honest communication", "Mutual trust", "Shared humor", "Similar values", "Deep conversations", "Ease / lightness", "Reliability"]
        ),
        ProfilePromptDefinition(
            id: "selfimage",
            question: "How would you describe your self-image?",
            answers: ["I am rather self-confident", "I am rather self-critical", "I am a mix of both", "It strongly depends on the situation"]
        ),
        ProfilePromptDefinition(
            id: "people",
            question: "I get along well with people who...",
            answers: ["communicate honestly", "have a lot of humor", "are calm and relaxed", "think deeply", "are open and curious", "don't take themselves too seriously"]
        )
    ]

    init() {
        profileQuestionSlots = (0..<5).map { _ in ProfileQuestionSlot() }
    }

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
            category: "Theatre",
            location: "St. Pauli",
            budget: "Premium",
            description: "A quiet jazz set, two reserved seats, and a short walk after the encore.",
            symbol: "music.mic",
            colors: [Color(red: 0.30, green: 0.12, blue: 0.92), Color(red: 0.95, green: 0.20, blue: 0.62)]
        ),
        DateExperience(
            id: "wine",
            title: "Natural Wine Hour",
            category: "Other",
            location: "Schanze",
            budget: "Medium",
            description: "A small table, one guided flight, and conversation prompts that do not feel forced.",
            symbol: "wineglass",
            colors: [Color(red: 0.57, green: 0.13, blue: 0.72), Color(red: 0.18, green: 0.60, blue: 0.88)]
        ),
        DateExperience(
            id: "harbor",
            title: "Harbor Glow Walk",
            category: "Nature experience",
            location: "HafenCity",
            budget: "Light",
            description: "A scenic route, warm drinks, and one good place to stop if the chemistry is there.",
            symbol: "water.waves",
            colors: [Color(red: 0.05, green: 0.20, blue: 0.60), Color(red: 0.48, green: 0.21, blue: 1.0)]
        ),
        DateExperience(
            id: "chef",
            title: "Counter Dinner",
            category: "Action",
            location: "Eimsbuettel",
            budget: "Premium",
            description: "Two seats at the chef counter where the plan feels special without becoming stiff.",
            symbol: "fork.knife",
            colors: [Color(red: 0.18, green: 0.07, blue: 0.28), Color(red: 0.93, green: 0.39, blue: 0.28)]
        ),
        DateExperience(
            id: "gallery",
            title: "After-Hours Gallery",
            category: "Museums",
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

    var filteredExperiences: [DateExperience] {
        experiences.filter { experience in
            appliedBudgetTiers.contains(experience.budget) &&
            appliedFilterCategories.contains(experience.category)
        }
    }

    var currentExperience: DateExperience? {
        guard selectedExperienceIndex < filteredExperiences.count else { return nil }
        return filteredExperiences[selectedExperienceIndex]
    }

    var hasNoMatchingExperiences: Bool {
        filteredExperiences.isEmpty
    }

    func applyFilters(budgetTiers: Set<String>, categories: Set<String>) {
        appliedBudgetTiers = budgetTiers
        appliedFilterCategories = categories
        selectedExperienceIndex = 0
    }

    func availabilitySlot(for weekday: Weekday) -> AvailabilityTimeSlot? {
        weeklyAvailability.first { $0.weekday == weekday }
    }

    func addAvailabilitySlot(for weekday: Weekday) {
        guard availabilitySlot(for: weekday) == nil else { return }
        weeklyAvailability.append(
            AvailabilityTimeSlot(weekday: weekday, startHour: 18, startMinute: 0, endHour: 20, endMinute: 0)
        )
    }

    func removeAvailabilitySlot(for weekday: Weekday) {
        weeklyAvailability.removeAll { $0.weekday == weekday }
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

    /// Signature gradient used for brand marks and prominent accents.
    static let brandGradient = LinearGradient(
        colors: [electric, violet, rose],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [violet, rose],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Soft tint poured into Liquid Glass surfaces to keep the dark, foggy mood.
    static let glassTint = Color(red: 0.10, green: 0.06, blue: 0.20)
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
                .presentationDetents([.large])
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
        .fullScreenCover(isPresented: $store.showAvailabilityEditor) {
            WeeklyAvailabilityEditScreen()
        }
        .sheet(item: $store.editingProfileSection) { context in
            ProfileEditSheet(context: context)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $store.editingQuestionSlot) { context in
            QuestionSlotEditSheet(slotID: context.id)
                .presentationDetents([.large])
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
            .glassEffect(
                glow ? .regular.tint(QTheme.violet.opacity(0.22)) : .regular.tint(QTheme.glassTint.opacity(0.35)),
                in: .rect(cornerRadius: cornerRadius)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.40), Color.white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
                    .allowsHitTesting(false)
            }
            .shadow(
                color: glow ? QTheme.violet.opacity(0.40) : Color.black.opacity(0.30),
                radius: glow ? 32 : 18,
                x: 0,
                y: 16
            )
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
            .padding(.vertical, 15)
            .contentShape(Capsule(style: .continuous))
        }
        .buttonStyle(.plain)
        .glassEffect(
            prominent
                ? .regular.tint(QTheme.violet.opacity(0.55)).interactive()
                : .regular.interactive(),
            in: .capsule
        )
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(Color.white.opacity(prominent ? 0.28 : 0.16), lineWidth: 0.8)
                .allowsHitTesting(false)
        }
        .shadow(color: prominent ? QTheme.violet.opacity(0.42) : .clear, radius: 20, y: 10)
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
                .frame(width: 50, height: 50)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .overlay {
            Circle()
                .strokeBorder(Color.white.opacity(0.16), lineWidth: 0.8)
                .allowsHitTesting(false)
        }
    }
}

struct GlassHeader: View {
    @State private var showHelp = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("QDate")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .tracking(-0.5)
                        .foregroundStyle(QTheme.brandGradient)
                        .shadow(color: QTheme.violet.opacity(0.45), radius: 12, x: 0, y: 3)

                    HStack(spacing: 5) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(QTheme.electric)
                        Text("Hamburg")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(QTheme.muted)
                    }
                }

                Spacer()

                Button {
                    showHelp = true
                    Haptics.light()
                } label: {
                    Image(systemName: "questionmark")
                        .font(.system(size: 17, weight: .black))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.16), lineWidth: 0.8)
                        .allowsHitTesting(false)
                }
                .accessibilityLabel("QDate help")
            }
            .padding(.horizontal, 22)
            .padding(.top, 6)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.10), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .top)
        }
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [Color.white.opacity(0.18), Color.white.opacity(0.02)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
        }
        .sheet(isPresented: $showHelp) {
            QDateHelpSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct QDateHelpSheet: View {
    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 18) {
                Text("How QDate works")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                HelpRow(symbol: "sparkles", title: "Search stays active", detail: "QDate learns from date ideas and readiness signals.")
                HelpRow(symbol: "heart.circle", title: "No endless chat", detail: "The concierge moves promising matches toward a real plan.")
                HelpRow(symbol: "calendar.badge.clock", title: "Hamburg demo", detail: "This prototype is seeded around local date planning.")

                Spacer()
            }
            .padding(22)
        }
    }
}

struct HelpRow: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(QTheme.electric)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(QTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct GlassTabBar: View {
    @EnvironmentObject private var store: DemoStore
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let selected = store.selectedTab == tab
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                        store.selectedTab = tab
                    }
                    Haptics.light()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: tab.symbol)
                            .font(.system(size: 16, weight: .semibold))
                            .symbolVariant(selected ? .fill : .none)
                        if selected {
                            Text(tab.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .fixedSize()
                                .transition(.opacity.combined(with: .scale(scale: 0.7)))
                        }
                    }
                    .foregroundStyle(selected ? .white : Color.white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        if selected {
                            Capsule(style: .continuous)
                                .fill(QTheme.accentGradient)
                                .shadow(color: QTheme.violet.opacity(0.55), radius: 12, y: 4)
                                .matchedGeometryEffect(id: "activeTab", in: namespace)
                        }
                    }
                    .contentShape(Capsule(style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .glassEffect(.regular.tint(QTheme.glassTint.opacity(0.4)), in: .capsule)
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
                .allowsHitTesting(false)
        }
        .shadow(color: Color.black.opacity(0.38), radius: 26, y: 16)
    }
}

struct HomeScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
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
            ForEach(Array(store.filteredExperiences.enumerated().reversed()), id: \.element.id) { index, experience in
                if index >= store.selectedExperienceIndex && index < store.selectedExperienceIndex + 3 {
                    ExperienceCard(
                        experience: experience,
                        isTop: index == store.selectedExperienceIndex
                    )
                    .scaleEffect(index == store.selectedExperienceIndex ? 1 : 0.94 - CGFloat(index - store.selectedExperienceIndex) * 0.03)
                    .offset(y: CGFloat(index - store.selectedExperienceIndex) * 14)
                    .zIndex(Double(store.filteredExperiences.count - index))
                }
            }

            if store.currentExperience == nil {
                GlassCard(cornerRadius: 28) {
                    VStack(spacing: 14) {
                        Image(systemName: store.hasNoMatchingExperiences ? "line.3.horizontal.decrease.circle" : "sparkles.rectangle.stack")
                            .font(.system(size: 42))
                            .foregroundStyle(QTheme.electric)
                        Text(store.hasNoMatchingExperiences ? "No matches for these filters" : "Enough signal collected")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                        Text(store.hasNoMatchingExperiences
                             ? "Try another budget tier or category to see more date ideas."
                             : "QDate has what it needs to move from search into a curated match.")
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
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 86, height: 86)
                    .glassEffect(.regular.tint(color.opacity(0.45)), in: .circle)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.28), lineWidth: 0.8)
                            .allowsHitTesting(false)
                    }
                    .shadow(color: color.opacity(0.40), radius: 20, y: 8)
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
                    WeeklyAvailabilityEditor(locked: store.isCompassLocked)
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

struct ChipMultiPicker: View {
    let options: [String]
    @Binding var selection: Set<String>
    let locked: Bool
    var minimumSelection = 1

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 98), spacing: 10)], spacing: 10) {
            ForEach(options, id: \.self) { option in
                let isSelected = selection.contains(option)
                Button {
                    guard !locked else { return }
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                        if isSelected {
                            guard selection.count > minimumSelection else { return }
                            selection.remove(option)
                        } else {
                            selection.insert(option)
                        }
                    }
                } label: {
                    Text(option)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(isSelected ? QTheme.violet.opacity(0.55) : Color.white.opacity(0.08), in: Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(isSelected ? 0.34 : 0.10), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .disabled(locked)
            }
        }
    }
}

struct FilterCategoryChip: View {
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selected ? QTheme.violet.opacity(0.48) : Color.white.opacity(0.08), in: Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(selected ? 0.34 : 0.10), lineWidth: 1))
        }
        .buttonStyle(.plain)
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

struct WeeklyAvailabilityEditor: View {
    @EnvironmentObject private var store: DemoStore
    let locked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(spacing: 0) {
                ForEach(Array(Weekday.allCases.enumerated()), id: \.element.id) { index, weekday in
                    AvailabilitySummaryRow(weekday: weekday)

                    if index < Weekday.allCases.count - 1 {
                        Divider()
                            .overlay(Color.white.opacity(0.08))
                    }
                }
            }
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            if !locked {
                Button {
                    store.showAvailabilityEditor = true
                } label: {
                    Label("Edit availability", systemImage: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(QTheme.electric)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct AvailabilitySummaryRow: View {
    @EnvironmentObject private var store: DemoStore
    let weekday: Weekday

    var body: some View {
        HStack(spacing: 12) {
            Text(weekday.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 96, alignment: .leading)

            if let slot = store.availabilitySlot(for: weekday) {
                Text(slot.formattedRange)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer(minLength: 8)
                Circle()
                    .fill(QTheme.success)
                    .frame(width: 8, height: 8)
            } else {
                Text("Unavailable")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(QTheme.muted)
                Spacer(minLength: 8)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

struct WeeklyAvailabilityEditScreen: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedWeekday: Weekday = .monday

    private var selectedSlotIndex: Int? {
        store.weeklyAvailability.firstIndex { $0.weekday == selectedWeekday }
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Edit availability")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Choose a day, then add or update one time slot.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    GlassIconButton(symbol: "xmark") {
                        close()
                    }
                }

                Text("Select day")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(QTheme.muted)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Weekday.allCases) { weekday in
                            let isSelected = selectedWeekday == weekday
                            let hasSlot = store.availabilitySlot(for: weekday) != nil

                            Button {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                    selectedWeekday = weekday
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Text(weekday.shortTitle)
                                        .font(.system(size: 14, weight: .bold))
                                    Circle()
                                        .fill(hasSlot ? QTheme.success : Color.white.opacity(0.18))
                                        .frame(width: 6, height: 6)
                                }
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(isSelected ? QTheme.violet.opacity(0.55) : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.white.opacity(isSelected ? 0.34 : 0.10), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                GlassCard(cornerRadius: 22) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(selectedWeekday.title)
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundStyle(.white)

                        if let index = selectedSlotIndex {
                            AvailabilitySlotEditor(
                                startTime: $store.weeklyAvailability[index].startTime,
                                endTime: $store.weeklyAvailability[index].endTime
                            )

                            Button {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                    store.removeAvailabilitySlot(for: selectedWeekday)
                                }
                            } label: {
                                Label("Remove slot", systemImage: "trash")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(QTheme.warning)
                            }
                            .buttonStyle(.plain)
                        } else {
                            Text("No availability set for this day.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(QTheme.muted)

                            GlassButton(title: "Add time slot", symbol: "plus.circle.fill", prominent: true) {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                    store.addAvailabilitySlot(for: selectedWeekday)
                                }
                            }
                        }
                    }
                    .padding(18)
                }

                Spacer()

                GlassButton(title: "Done", symbol: "checkmark", prominent: true) {
                    close()
                }
            }
            .padding(20)
        }
    }

    private func close() {
        store.showAvailabilityEditor = false
        dismiss()
    }
}

struct AvailabilitySlotEditor: View {
    @Binding var startTime: Date
    @Binding var endTime: Date

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("Start")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                    .frame(width: 42, alignment: .leading)
                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(QTheme.electric)
                    .onChange(of: startTime) { _, newStart in
                        if endTime <= newStart {
                            endTime = Calendar.current.date(byAdding: .hour, value: 2, to: newStart) ?? newStart
                        }
                    }
                Spacer()
            }

            HStack(spacing: 12) {
                Text("End")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                    .frame(width: 42, alignment: .leading)
                DatePicker("", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(QTheme.electric)
                Spacer()
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct ProfileScreen: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ProfileHeader()
                    EditableProfileSection(title: "Vibe", editID: "vibe") {
                        VibeCardContent(vibe: store.profileVibe)
                    }
                    EditableProfileSection(title: "Favorites", editID: "favorites") {
                        FavoritesCardContent()
                    }
                    EditableProfileSection(title: "Interests", editID: "interests") {
                        TagWrap(tags: store.interests)
                    }
                    EditableProfileSection(title: "Bucket List", editID: "bucket") {
                        BucketListCardContent()
                    }
                    EditableProfileSection(title: "Career / Life Path", editID: "career") {
                        CareerLifePathContent()
                    }
                    EditableProfileSection(title: "About You", editID: "about") {
                        Text(store.aboutText)
                            .profileText()
                    }
                    ProfileQuestionCards()
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

                GlassButton(title: "Edit Photo", symbol: "camera.fill", prominent: true) {
                    store.showPhotoEditor = true
                }
            }
            .padding(22)
        }
    }
}

struct EditableProfileSection<Content: View>: View {
    @EnvironmentObject private var store: DemoStore
    let title: String
    let editID: String
    @ViewBuilder var content: Content

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        store.editingProfileSection = ProfileEditContext(id: editID, title: title)
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(Color.white.opacity(0.10), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Edit \(title)")
                }
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
        }
    }
}

struct VibeCardContent: View {
    let vibe: ProfileVibe

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(VibeDimension.allCases) { dimension in
                FavoriteRow(label: dimension.displayLabel, value: vibe.selection(for: dimension))
            }
        }
    }
}

struct VibeEditor: View {
    @Binding var vibe: ProfileVibe

    var body: some View {
        VStack(spacing: 14) {
            ForEach(VibeDimension.allCases) { dimension in
                GlassCard(cornerRadius: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(dimension.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(QTheme.muted)
                        ChipPicker(
                            options: dimension.options,
                            selection: binding(for: dimension),
                            locked: false
                        )
                    }
                    .padding(16)
                }
            }
        }
    }

    private func binding(for dimension: VibeDimension) -> Binding<String> {
        Binding(
            get: { vibe.selection(for: dimension) },
            set: { vibe.setSelection($0, for: dimension) }
        )
    }
}

struct FavoritesCardContent: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            FavoriteRow(label: "Artist", value: store.favoriteArtist)
            FavoriteRow(label: "Song", value: store.favoriteSong)
            FavoriteRow(label: "Movie", value: store.favoriteMovie)
            FavoriteRow(label: "Food", value: store.favoriteFood)
            FavoriteRow(label: "Travel Destination", value: store.favoriteDestination)
            FavoriteRow(label: "Book", value: store.favoriteBook)
        }
    }
}

struct FavoriteRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(QTheme.muted)
            Spacer()
            Text(value.isEmpty ? "Not specified" : value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct BucketListCardContent: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProfileQuestionValue(question: "Biggest wish for the future", value: store.biggestWish)

            VStack(alignment: .leading, spacing: 8) {
                Text("Three things I would like to experience")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(QTheme.muted)

                ForEach(Array(store.bucketExperiences.enumerated()), id: \.offset) { index, value in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .black))
                            .foregroundStyle(QTheme.electric)
                            .frame(width: 18)
                        Text(value)
                            .profileText()
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
    }
}

struct CareerLifePathContent: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProfileQuestionValue(question: "As a child, I wanted to become", value: store.childhoodDream)
            ProfileQuestionValue(question: "What I do today", value: store.currentPath)
        }
    }
}

struct ProfileQuestionValue: View {
    let question: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(question)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(QTheme.muted)
            Text(value.isEmpty ? "Add an answer" : value)
                .profileText()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ProfileQuestionCards: View {
    @EnvironmentObject private var store: DemoStore

    var body: some View {
        GlassCard(cornerRadius: 22) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("QDate Questions")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Choose up to five personality cards. Each card can have multiple answers.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(QTheme.muted)
                }

                VStack(spacing: 10) {
                    ForEach(store.profileQuestionSlots.indices, id: \.self) { index in
                        QuestionSlotCard(slot: store.profileQuestionSlots[index], index: index)
                    }
                }
            }
            .padding(18)
        }
    }
}

struct QuestionSlotCard: View {
    @EnvironmentObject private var store: DemoStore
    let slot: ProfileQuestionSlot
    let index: Int

    var body: some View {
        Button {
            store.editingQuestionSlot = QuestionEditContext(id: slot.id)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(slot.questionID == nil ? Color.white.opacity(0.09) : QTheme.violet.opacity(0.32))
                        .frame(width: 34, height: 34)
                    Text("\(index + 1)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(definition?.question ?? "Choose a question")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                    if slot.selectedAnswers.isEmpty {
                        Text("Tap to select a prompt and answers")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    } else {
                        TagWrap(tags: Array(slot.selectedAnswers).sorted())
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                    .padding(.top, 5)
            }
            .padding(14)
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var definition: ProfilePromptDefinition? {
        store.profilePromptDefinitions.first { $0.id == slot.questionID }
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
    @Environment(\.dismiss) private var dismiss
    @State private var draftBudgetTiers: Set<String> = []
    @State private var draftCategories: Set<String> = []

    private var isValid: Bool {
        !draftBudgetTiers.isEmpty && !draftCategories.isEmpty
    }

    private var sortedSelectedTiers: [String] {
        DateFilterCatalog.tiers.filter { draftBudgetTiers.contains($0) }
    }

    var body: some View {
        ZStack {
            AppBackground()
            VStack(alignment: .leading, spacing: 16) {
                Text("Date filters")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        PreferenceSection(title: "Budget tier", locked: false) {
                            ChipMultiPicker(
                                options: DateFilterCatalog.tiers,
                                selection: $draftBudgetTiers,
                                locked: false,
                                minimumSelection: 1
                            )
                        }

                        if sortedSelectedTiers.isEmpty {
                            Text("Select at least one budget tier to see categories.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(QTheme.muted)
                        } else {
                            ForEach(sortedSelectedTiers, id: \.self) { tier in
                                PreferenceSection(title: "\(tier) categories", locked: false) {
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 116), spacing: 8)], spacing: 8) {
                                        ForEach(DateFilterCatalog.categoriesByTier[tier] ?? [], id: \.self) { category in
                                            FilterCategoryChip(
                                                title: category,
                                                selected: draftCategories.contains(category)
                                            ) {
                                                withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                                    if draftCategories.contains(category) {
                                                        draftCategories.remove(category)
                                                    } else {
                                                        draftCategories.insert(category)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if !isValid {
                    Text("Pick at least one budget tier and one category.")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(QTheme.warning)
                }

                GlassButton(title: "Apply Filters", symbol: "checkmark", prominent: true) {
                    store.applyFilters(budgetTiers: draftBudgetTiers, categories: draftCategories)
                    store.showFilters = false
                    dismiss()
                }
                .opacity(isValid ? 1 : 0.45)
                .disabled(!isValid)
            }
            .padding(20)
        }
        .onAppear {
            draftBudgetTiers = store.appliedBudgetTiers
            draftCategories = store.appliedFilterCategories
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
    @Environment(\.dismiss) private var dismiss
    let context: ProfileEditContext

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("Edit \(context.title)")
                            .font(.system(size: 30, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Spacer()
                        GlassIconButton(symbol: "xmark") {
                            store.editingProfileSection = nil
                            dismiss()
                        }
                    }

                    editorContent

                    GlassButton(title: "Done", symbol: "checkmark", prominent: true) {
                        store.editingProfileSection = nil
                        dismiss()
                    }
                }
                .padding(20)
            }
        }
    }

    @ViewBuilder
    private var editorContent: some View {
        switch context.id {
        case "vibe":
            VibeEditor(vibe: $store.profileVibe)
        case "about":
            GlassTextEditor(title: "About You", text: $store.aboutText, axis: .vertical)
        case "favorites":
            FavoritesEditor(
                artist: $store.favoriteArtist,
                song: $store.favoriteSong,
                movie: $store.favoriteMovie,
                food: $store.favoriteFood,
                destination: $store.favoriteDestination,
                book: $store.favoriteBook
            )
        case "interests":
            CategorizedInterestPicker(selectedInterests: $store.interests)
        case "bucket":
            GlassTextEditor(title: "Biggest wish for the future", text: $store.biggestWish, axis: .vertical)
            ForEach(0..<3, id: \.self) { index in
                GlassTextEditor(title: "\(index + 1)", text: bindingForBucketExperience(index), axis: .vertical)
            }
        case "career":
            GlassTextEditor(title: "As a child, I wanted to become", text: $store.childhoodDream, axis: .vertical)
            GlassTextEditor(title: "What I do today", text: $store.currentPath, axis: .vertical)
        default:
            Text("Nothing to edit")
                .profileText()
        }
    }

    private func bindingForBucketExperience(_ index: Int) -> Binding<String> {
        Binding(
            get: {
                guard store.bucketExperiences.indices.contains(index) else { return "" }
                return store.bucketExperiences[index]
            },
            set: { newValue in
                guard store.bucketExperiences.indices.contains(index) else { return }
                store.bucketExperiences[index] = newValue
            }
        )
    }
}

struct GlassTextEditor: View {
    let title: String
    @Binding var text: String
    var axis: Axis = .vertical

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(QTheme.muted)
                TextField(title, text: $text, axis: axis)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(axis == .vertical ? 2...5 : 1...1)
                    .padding(12)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(16)
        }
    }
}

struct FavoritesEditor: View {
    @Binding var artist: String
    @Binding var song: String
    @Binding var movie: String
    @Binding var food: String
    @Binding var destination: String
    @Binding var book: String

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 14) {
                FavoriteEditField(title: "Artist", text: $artist)
                FavoriteEditField(title: "Song", text: $song)
                FavoriteEditField(title: "Movie", text: $movie)
                FavoriteEditField(title: "Food", text: $food)
                FavoriteEditField(title: "Travel Destination", text: $destination)
                FavoriteEditField(title: "Book", text: $book)
            }
            .padding(16)
        }
    }
}

struct FavoriteEditField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(QTheme.muted)
            TextField("Enter favorite \(title.lowercased())", text: $text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .textFieldStyle(.plain)
        }
    }
}

struct EditableTagList: View {
    let title: String
    @Binding var tags: [String]
    let suggestions: [String]

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 14) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(QTheme.muted)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 116), spacing: 8)], spacing: 8) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button {
                            if tags.contains(suggestion) {
                                tags.removeAll { $0 == suggestion }
                            } else {
                                tags.append(suggestion)
                            }
                        } label: {
                            Text(suggestion)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(tags.contains(suggestion) ? QTheme.violet.opacity(0.48) : Color.white.opacity(0.08), in: Capsule())
                                .overlay(Capsule().stroke(Color.white.opacity(tags.contains(suggestion) ? 0.34 : 0.10), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct InterestCategory: Identifiable {
    let id = UUID()
    let title: String
    let interests: [String]
}

struct CategorizedInterestPicker: View {
    @Binding var selectedInterests: [String]
    private let maxSelection = 20
    private let categories: [InterestCategory] = [
        InterestCategory(title: "Sports & Movement", interests: ["🏃 Running", "🏋️ Gym", "🧘 Yoga", "🚴 Cycling", "🥾 Hiking", "🧗 Climbing", "🏊 Swimming", "⚽ Football", "🎾 Tennis", "🏀 Basketball", "🏐 Volleyball", "🛹 Skateboarding", "🥊 Boxing", "💃 Dancing", "🚶 Long walks"]),
        InterestCategory(title: "Outdoors & Nature", interests: ["🌲 Nature walks", "🏕️ Camping", "🌊 Beach days", "🌅 Sunsets", "🪴 Houseplants", "🐶 Dogs", "🐱 Cats", "🐾 Animal lover", "🌿 Gardening", "🧺 Picnics", "🚣 Kayaking", "🏔️ Mountains"]),
        InterestCategory(title: "Food & Drinks", interests: ["☕ Coffee", "🍵 Tea", "🍷 Wine tasting", "🍹 Cocktails", "🍸 Mocktails", "🍕 Pizza", "🍣 Sushi", "🍝 Italian food", "🌮 Street food", "🧁 Baking", "👨‍🍳 Cooking", "🥐 Brunch", "🌱 Vegetarian food", "🌶️ Spicy food"]),
        InterestCategory(title: "Culture & Going Out", interests: ["🎬 Movies", "📺 Series", "🎭 Theatre", "🎤 Stand up comedy", "🎶 Concerts", "🎧 Festivals", "🖼️ Museums", "📚 Bookstores", "🎨 Art galleries", "🕺 Nightlife", "🎲 Board games", "🧩 Quiz nights", "🎳 Bowling"]),
        InterestCategory(title: "Music", interests: ["🎧 Playlists", "🎸 Indie music", "🎤 Pop music", "🎹 Jazz", "🎧 Electronic music", "🎸 Rock", "🤘 Metal", "🎼 Classical music", "🎵 New music", "🎙️ Podcasts"]),
        InterestCategory(title: "Creative & Personal", interests: ["📸 Photography", "🎨 Painting", "✍️ Writing", "🧶 DIY projects", "🪡 Fashion", "🧵 Thrifting", "🎥 Filmmaking", "🎮 Gaming", "🧠 Learning new things", "🗣️ Deep talks", "😂 Memes"]),
        InterestCategory(title: "Travel & Adventure", interests: ["✈️ Travel", "🧳 City trips", "🏝️ Weekend getaways", "🚗 Road trips", "🗺️ Hidden gems", "🏛️ Historic places", "🌍 Different cultures", "🏨 Boutique hotels", "🚆 Train trips", "🧭 Spontaneous plans"]),
        InterestCategory(title: "Lifestyle & Values", interests: ["🧘 Self care", "🛁 Spa days", "🕯️ Slow mornings", "🧼 Clean living", "🌱 Sustainability", "🤝 Volunteering", "🧑‍🤝‍🧑 Community events", "🧘 Meditation", "🧠 Personal growth", "🏡 Cozy nights in"])
    ]

    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Interests")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Select up to \(maxSelection). Categories are only here to make scanning faster.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(QTheme.muted)
                    }
                    Spacer()
                    Text("\(selectedInterests.count)/\(maxSelection)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(selectedInterests.count >= maxSelection ? QTheme.warning : QTheme.electric)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.09), in: Capsule())
                }

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(categories) { category in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category.title)
                                .font(.system(size: 15, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 136), spacing: 8)], spacing: 8) {
                                ForEach(category.interests, id: \.self) { interest in
                                    InterestChip(
                                        title: interest,
                                        selected: selectedInterests.contains(interest),
                                        disabled: selectedInterests.count >= maxSelection && !selectedInterests.contains(interest)
                                    ) {
                                        toggle(interest)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
    }

    private func toggle(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.removeAll { $0 == interest }
        } else if selectedInterests.count < maxSelection {
            selectedInterests.append(interest)
        } else {
            Haptics.light()
        }
    }
}

struct InterestChip: View {
    let title: String
    let selected: Bool
    let disabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(disabled ? Color.white.opacity(0.38) : .white)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(.horizontal, 10)
                .background(selected ? QTheme.violet.opacity(0.50) : Color.white.opacity(disabled ? 0.04 : 0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(selected ? QTheme.electric.opacity(0.60) : Color.white.opacity(0.10), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
}

struct QuestionSlotEditSheet: View {
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    let slotID: UUID

    var body: some View {
        ZStack {
            AppBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Edit question")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Pick one question, then select all answers that fit.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(QTheme.muted)
                        }
                        Spacer()
                        GlassIconButton(symbol: "xmark") {
                            store.editingQuestionSlot = nil
                            dismiss()
                        }
                    }

                    GlassCard(cornerRadius: 22) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Question")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                            ForEach(store.profilePromptDefinitions) { definition in
                                QuestionChoiceRow(definition: definition, selected: currentSlot?.questionID == definition.id) {
                                    updateSlot { slot in
                                        slot.questionID = definition.id
                                        slot.selectedAnswers = []
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }

                    if let definition = selectedDefinition {
                        GlassCard(cornerRadius: 22, glow: true) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Answers")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.white)
                                ForEach(definition.answers, id: \.self) { answer in
                                    MultiSelectAnswerRow(answer: answer, selected: currentSlot?.selectedAnswers.contains(answer) ?? false) {
                                        updateSlot { slot in
                                            if slot.selectedAnswers.contains(answer) {
                                                slot.selectedAnswers.remove(answer)
                                            } else {
                                                slot.selectedAnswers.insert(answer)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                    }

                    GlassButton(title: "Done", symbol: "checkmark", prominent: true) {
                        store.editingQuestionSlot = nil
                        dismiss()
                    }
                }
                .padding(20)
            }
        }
    }

    private var currentSlot: ProfileQuestionSlot? {
        store.profileQuestionSlots.first { $0.id == slotID }
    }

    private var selectedDefinition: ProfilePromptDefinition? {
        guard let questionID = currentSlot?.questionID else { return nil }
        return store.profilePromptDefinitions.first { $0.id == questionID }
    }

    private func updateSlot(_ update: (inout ProfileQuestionSlot) -> Void) {
        guard let index = store.profileQuestionSlots.firstIndex(where: { $0.id == slotID }) else { return }
        update(&store.profileQuestionSlots[index])
    }
}

struct QuestionChoiceRow: View {
    let definition: ProfilePromptDefinition
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? QTheme.success : QTheme.muted)
                Text(definition.question)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(12)
            .background(selected ? QTheme.violet.opacity(0.22) : Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct MultiSelectAnswerRow: View {
    let answer: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: selected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(selected ? QTheme.success : QTheme.muted)
                Text(answer)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(12)
            .background(selected ? QTheme.violet.opacity(0.25) : Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
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

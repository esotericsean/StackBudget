import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image
                    Image("profile") // Add your profile image to Assets.xcassets
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(AppTheme.primaryColor, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    
                    // Made By Section
                    Text("Made by")
                        .font(AppTheme.subheadlineFont)
                        .foregroundColor(.secondary)
                    Text("Sean Duran")
                        .font(AppTheme.headlineFont.bold())
                    
                    // About Me Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About Me")
                            .font(AppTheme.headlineFont)
                        
                        Text("Hi, I'm esotericsean/esotericmods. I'm a YouTuber and game developer. I love Game Boys, dogs, my wife, and my kids. Feel free to say hi and let me know if you guys have any issues with this app! :)")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(12)
                    
                    // About Me Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("I made StackBudget pretty much for myself because I do something similar (but way more complex in Excel every month and always thought it would be nice to have an app version and this is what I came up with, figured I'd share it with others and maybe make a little extra money to buy my wife some flowers with. Oh, and that's why the icon is a snail too, my wife likes snails haha.")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(12)
                    
                    // Social Links
                    VStack(spacing: 12) {
                        Button {
                            openURL("mailto:sean@seanduran.com")
                        } label: {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("Email")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button {
                            openURL("https://seanduran.com")
                        } label: {
                            HStack {
                                Image(systemName: "globe")
                                Text("Website")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button {
                            openURL("https://github.com/esotericsean")
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left.forwardslash.chevron.right")
                                Text("GitHub")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

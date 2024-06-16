import DotEnv
import DiscordKitBot
import Foundation

var env = try DotEnv.read(path: ".env")
env.load()

let bot = Client(intents: .unprivileged)

// Guild to register commands in. If the COMMAND_GUILD_ID environment variable is set, commands are scoped
// to that server and update instantly, useful for debugging. Otherwise, they are registered globally.
let commandGuildID = ProcessInfo.processInfo.environment["COMMAND_GUILD_ID"]

bot.ready.listen {
    print("Logged in as \(bot.user!.username)#\(bot.user!.discriminator)!")

    try? await bot.registerApplicationCommands(guild: commandGuildID) {
        NewAppCommand("ping", description: "Ping me!") { interaction in
            try? await interaction.reply("Pong!")
        }        
    }
}

bot.login() // Reads the bot token from the DISCORD_TOKEN environment variable and logs in with the token

// Run the main RunLoop to prevent the program from exiting
RunLoop.main.run()

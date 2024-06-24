import DiscordKitBot
import DiscordKitCore
import DotEnv
import Foundation
import OllamaKit

var env = try DotEnv.read(path: ".env")
env.load()

let bot = Client(intents: [.unprivileged, .messageContent])

let ok = OllamaKit.init(baseURL: URL(string: ProcessInfo.processInfo.environment["OLLAMA_HOST"]!)!)

let isReachable = await ok.reachable()
let model =
  ProcessInfo.processInfo.environment["OLLAMA_MODEL"] ?? "xe/mimi:hermes-2-theta-llama3-8b"

// Guild to register commands in. If the COMMAND_GUILD_ID environment variable is set, commands are scoped
// to that server and update instantly, useful for debugging. Otherwise, they are registered globally.
let commandGuildID = ProcessInfo.processInfo.environment["COMMAND_GUILD_ID"]
let spamChannelID = ProcessInfo.processInfo.environment["SPAM_CHANNEL_ID"]

var backlog: [Snowflake: [OKChatRequestData.Message]] = [:]

bot.ready.listen {
  print("Logged in as \(bot.user!.username)#\(bot.user!.discriminator)!")

  //   try? await bot.registerApplicationCommands(guild: commandGuildID) {
  //     NewAppCommand("inquire", description: "Ask Mimi a question!") {
  //       StringOption("question", description: "The question you want to ask Mimi", required: true)
  //     } handler: { interaction in
  //       print("Inquire command invoked")
  //       if let question: String = interaction.optionValue(of: "question") {
  //         let messages = [
  //           OKChatRequestData.Message(role: OKChatRequestData.Message.Role.user, content: question)
  //         ]
  //         let chatData = OKChatRequestData(model: model, messages: messages)
  //         var msg = ""
  //         do {
  //           for try await response in ok.chat(data: chatData) {
  //             if response.done {
  //               break
  //             }
  //
  //             if response.message != nil {
  //               msg += response.message!.content
  //               print(msg)
  //             }
  //           }
  //         } catch {
  //           // Handle error
  //         }
  //         try? await interaction.reply("> \(question)\n\n\(msg)")
  //       } else {
  //         try? await interaction.reply("You need to provide a question, baka!")
  //       }
  //     }
  //   }

  bot.messageCreate.listen { message in
    if message.channelID != spamChannelID {
      return
    }

    print("Received message in \(message.channelID) with content '\(message.content)'")

    if Int.random(in: 0...100) % 10 == 4 {
      let question = message.content
      let messages = [
        OKChatRequestData.Message(role: OKChatRequestData.Message.Role.user, content: question)
      ]
      let chatData = OKChatRequestData(model: model, messages: messages)
      var msg = ""
      do {
        for try await response in ok.chat(data: chatData) {
          if response.done {
            break
          }

          if response.message != nil {
            msg += response.message!.content
            print(msg)
          }
        }

        try? await message.reply(msg)
      } catch {
        // Handle error
      }
      return
    }

    if message.content.starts(with: "Mimi, ") {
      let question = message.content
      let messages = [
        OKChatRequestData.Message(role: OKChatRequestData.Message.Role.user, content: question)
      ]
      let chatData = OKChatRequestData(model: model, messages: messages)
      var msg = ""
      do {
        for try await response in ok.chat(data: chatData) {
          if response.done {
            break
          }

          if response.message != nil {
            msg += response.message!.content
            print(msg)
          }
        }

        try? await message.reply(msg)
      } catch {
        // Handle error
      }
    }
  }
}

bot.login()  // Reads the bot token from the DISCORD_TOKEN environment variable and logs in with the token

// Run the main RunLoop to prevent the program from exiting
RunLoop.main.run()

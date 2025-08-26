PK��Z�����
mirage-api.jsconst express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;
const PLACE_ID = "2753915549"; // Blox Fruits

app.get('/api/mirage', (req, res) => {
    const filePath = path.join(__dirname, 'mirage.json');

    if (!fs.existsSync(filePath)) {
        return res.status(404).json({ error: "Không tìm thấy dữ liệu Mirage Island." });
    }

    const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    const jobId = data.jobId;
    const joinScript = \`game:GetService("TeleportService"):TeleportToPlaceInstance(${PLACE_ID}, "\${jobId}", game.Players.LocalPlayer)\`;

    res.json({
        jobId,
        playerCount: data.playerCount,
        updatedAt: data.updatedAt,
        joinScript
    });
});

app.listen(PORT, () => {
    console.log(\`✅ Mirage API chạy tại http://localhost:\${PORT}/api/mirage\`);
});
PK��Zo��Rmirage-listener.jsconst fs = require('fs');
const { Client, Intents } = require('discord.js-selfbot-v13');

const TOKEN = 'MTA5MTg2Njg0NjU4MTQ5Nzk0Nw.G9pO5D.IArKyXpxR7dUwV4idR_GvBwOQPbukTiDs9M8Tw';
const MIRAGE_CHANNEL_ID = '1363502983144542320'; // ID kênh chứa Mirage

const client = new Client({
  intents: new Intents(32767)
});

client.on('ready', () => {
  console.log(`🟢 Đã đăng nhập: ${client.user.tag}`);
});

client.on('messageCreate', async (message) => {
  if (message.channelId !== MIRAGE_CHANNEL_ID) return;
  if (!message.embeds || message.embeds.length === 0) return;

  const embed = message.embeds[0];
  const fields = embed.fields;

  const jobId = fields.find(f => f.name.includes("Job ID PC"))?.value;

  if (jobId) {
    const data = {
      jobId: jobId.trim(),
      playerCount: fields.find(f => f.name.includes("Player Count"))?.value || "N/A",
      updatedAt: new Date().toISOString()
    };

    fs.writeFileSync("mirage.json", JSON.stringify(data, null, 2));
    console.log("📦 Đã lưu Job ID:", data.jobId);
  }
});

client.login(TOKEN);
PK��Z�	�KWWmirage.json{
  "jobId": "abc123xyz",
  "playerCount": 12,
  "updatedAt": "2025-05-09T08:12:00Z"
}
PK��Z�����
�mirage-api.jsPK��Zo��R��mirage-listener.jsPK��Z�	�KWW��mirage.jsonPK�i

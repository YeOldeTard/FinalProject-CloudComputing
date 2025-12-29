/* ================= AI CHAT CONFIGURATION ================= */
window.AI_CHAT_CONFIG = {
  // Enable/Disable AI
  enabled: true,
  
  // AI Provider Selection
  provider: "gemini", // "openai", "gemini", "hybrid", "rules"
  
  // API Keys (keep empty if using rules)
  apiKeys: {
    openai: "", // "sk-..." - Leave empty if not using
    gemini: "AIzaSyAuIUmVC7zCCxKd8QskpL4GI0N0CuUPV4E"  // "AIza..." - Leave empty if not using
  },
  
  // AI Personality Settings
  personality: {
    name: "Driver",
    tone: "friendly",
    language: "indonesia",
    useEmojis: true,
    responseLength: "medium" // "short", "medium", "long"
  },
  
  // Context Settings
  context: {
    includePhase: true,
    includeETA: true,
    includeLocation: true,
    includeStoreName: true,
    historyLength: 5 // Number of messages to remember
  },
  
  // Response Settings
  responses: {
    greeting: [
      "Halo! Ada yang bisa saya bantu? 😊",
      "Hi! Siap mengantar pesanan Anda 🛵",
      "Hai! Driver siap melayani ✨"
    ],
    thanks: [
      "Sama-sama! Senang bisa membantu 🙏",
      "Dengan senang hati! 😄",
      "Makasih juga ya! 👍"
    ],
    eta: [
      "Perkiraan sampai {eta} menit lagi 🕒",
      "Sekitar {eta} menit lagi sampai ⏱️",
      "Tinggal {eta} menit! Sudah dekat nih 🎯"
    ],
    location: [
      "Saya sedang {phase_text} 😊",
      "Saat ini {phase_text} ⚡",
      "{phase_text}, mohon ditunggu 🙌"
    ],
    urgent: [
      "Siap! Akan saya percepat 🚀",
      "Oke, akan saya usahakan lebih cepat! ⚡",
      "Diterima! Sedang maksimalkan kecepatan 💨"
    ],
    safety: [
      "Tenang, saya selalu berhati-hati 🛡️",
      "Safety first! Terima kasih perhatiannya 👍",
      "Iya, saya perhatikan. Makasih ya 🙏"
    ],
    default: [
      "Oke, pesanannya dalam perjalanan ya 🛡️",
      "Noted! Terima kasih informasinya 👍",
      "Baik, saya perhatikan pesannya ✨"
    ]
  },
  
  // Phase Mappings
  phases: {
    "order_confirmed": "sedang menuju ke restoran",
    "to_store": "dalam perjalanan ke restoran",
    "preparing_done": "sedang mengambil pesanan di restoran",
    "to_customer": "sedang menuju ke lokasi Anda",
    "delivered": "sudah sampai di lokasi"
  },
  
  // Timing Settings
  timing: {
    typingDelay: 1000, // ms before showing typing indicator
    minResponseTime: 800, // ms minimum response time
    maxResponseTime: 3000, // ms maximum response time
    autoGreetingDelay: 1500 // ms before auto greeting
  },
  
  // Debug Settings
  debug: {
    logResponses: false,
    showAIBadge: true,
    simulateDelay: true
  }
};

/* ================= PHASE-SPECIFIC RESPONSES ================= */
window.AI_PHASE_RESPONSES = {
  "order_confirmed": {
    greeting: "Halo! Saya sedang menuju ke restoran untuk mengambil pesanan Anda 🛵",
    eta: "Sedang menuju restoran dulu ya, perkiraan {eta} menit lagi",
    location: "Dalam perjalanan ke restoran {store_name}"
  },
  "to_store": {
    greeting: "Masih dalam perjalanan ke restoran, tidak lama lagi sampai ⚡",
    eta: "Ke restoran: {eta} menit lagi",
    location: "Sedang di jalan menuju {store_name}"
  },
  "preparing_done": {
    greeting: "Sudah sampai di restoran! Sekarang ambil pesanan Anda 😊",
    eta: "Sedang ambil pesanan, sebentar lagi berangkat",
    location: "Lagi di {store_name}"
  },
  "to_customer": {
    greeting: "Pesanan sudah diambil! Sekarang menuju ke lokasi Anda 🎯",
    eta: "Perkiraan sampai: {eta} menit lagi",
    location: "Sudah di jalan menuju lokasi Anda!"
  },
  "delivered": {
    greeting: "Sudah sampai! Pesanan siap diserahkan 🎉",
    eta: "Sudah tiba di lokasi",
    location: "Sudah di depan ya!"
  }
};

/* ================= INTENT DETECTION PATTERNS ================= */
window.AI_INTENT_PATTERNS = {
  greeting: /^(halo|hai|hi|hey|hello|selamat|pagi|siang|sore|malam)/i,
  thanks: /^(terima kasih|makasih|thanks|thank you|tengkyu|thx)/i,
  eta: /^(kapan|berapa lama|eta|sampe|sampai|jam|waktu)/i,
  location: /^(dimana|di mana|lokasi|posisi|tujuan|alamat)/i,
  urgent: /^(cepat|cepatkan|buruan|cepatin|cepatin dong|cepat ya)/i,
  safety: /^(hati|hati-hati|awas|bahaya|selamat|safety)/i,
  question: /^(bisa|bisakah|boleh|apakah|bagaimana|kenapa|mengapa|\?)/i,
  cancel: /^(batal|cancel|stop|tolak|gagal)/i,
  change: /^(ganti|ubah|tambah|kurang|extra|tambahan)/i
};

/* ================= EMOJI BANK ================= */
window.AI_EMOJIS = {
  greeting: ["😊", "👋", "✨"],
  thanks: ["🙏", "😄", "👍"],
  eta: ["🕒", "⏱️", "🎯"],
  location: ["📍", "🗺️", "🎯"],
  driving: ["🛵", "🚗", "⚡"],
  food: ["🍔", "🍕", "🍜"],
  positive: ["✅", "🌟", "💫"],
  warning: ["⚠️", "🚨", "🔔"],
  celebration: ["🎉", "🥳", "✨"]
};

/* ================= HELPER FUNCTIONS ================= */
window.AI_HELPERS = {
  // Get random item from array
  randomItem: (array) => array[Math.floor(Math.random() * array.length)],
  
  // Add appropriate emoji
  addEmoji: (text, intent) => {
    if (!AI_CHAT_CONFIG.personality.useEmojis) return text;
    
    const emojis = AI_EMOJIS[intent] || AI_EMOJIS.default || [];
    if (emojis.length === 0) return text;
    
    const emoji = AI_HELPERS.randomItem(emojis);
    return `${text} ${emoji}`;
  },
  
  // Replace template variables
  replaceVariables: (text, variables) => {
    let result = text;
    Object.keys(variables).forEach(key => {
      result = result.replace(new RegExp(`{${key}}`, 'g'), variables[key]);
    });
    return result;
  },
  
  // Detect message intent
  detectIntent: (message) => {
    const msg = message.toLowerCase();
    
    for (const [intent, pattern] of Object.entries(AI_INTENT_PATTERNS)) {
      if (pattern.test(msg)) {
        return intent;
      }
    }
    
    return "default";
  },
  
  // Get phase description
  getPhaseDescription: (phase) => {
    return AI_CHAT_CONFIG.phases[phase] || "sedang mengantar pesanan";
  },
  
  // Format response based on length preference
  formatResponse: (text) => {
    const { responseLength } = AI_CHAT_CONFIG.personality;
    
    if (responseLength === "short") {
      // Keep only first sentence
      return text.split(/[.!?]/)[0] + (text.match(/[.!?]/) ? text.match(/[.!?]/)[0] : ".");
    }
    
    return text;
  }
};

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    AI_CHAT_CONFIG,
    AI_PHASE_RESPONSES,
    AI_INTENT_PATTERNS,
    AI_EMOJIS,
    AI_HELPERS
  };
}
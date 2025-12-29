/* ================= AI CHAT ENGINE ================= */
class AIChatEngine {
  constructor(config = {}) {
    this.config = { ...window.AI_CHAT_CONFIG, ...config };
    this.context = {
      phase: "order_confirmed",
      eta: "10",
      storeName: "Restoran",
      driverName: "Driver",
      conversationHistory: [],
      userPreferences: {}
    };
    this.isTyping = false;
  }
  
  // Update context with current state
  updateContext(newContext) {
    this.context = { ...this.context, ...newContext };
    
    // Keep history limited
    if (this.context.conversationHistory.length > this.config.context.historyLength) {
      this.context.conversationHistory = 
        this.context.conversationHistory.slice(-this.config.context.historyLength);
    }
  }
  
  // Generate AI response
  async generateResponse(userMessage) {
    // Add to history
    this.context.conversationHistory.push({
      role: "user",
      content: userMessage,
      timestamp: new Date().toISOString()
    });
    
    // Detect intent
    const intent = window.AI_HELPERS.detectIntent(userMessage);
    
    // Generate response based on provider
    let response;
    
    switch (this.config.provider) {
      case "openai":
        response = await this.generateOpenAIResponse(userMessage, intent);
        break;
      case "gemini":
        response = await this.generateGeminiResponse(userMessage, intent);
        break;
      case "hybrid":
        response = this.generateHybridResponse(userMessage, intent);
        break;
      case "rules":
      default:
        response = this.generateRulesResponse(userMessage, intent);
        break;
    }
    
    // Add to history
    this.context.conversationHistory.push({
      role: "assistant",
      content: response,
      timestamp: new Date().toISOString()
    });
    
    return response;
  }
  
  // Rules-based response generation
  generateRulesResponse(userMessage, intent) {
    // Get base responses
    let responses = [...this.config.responses[intent] || this.config.responses.default];
    
    // Check for phase-specific responses
    if (this.config.context.includePhase && window.AI_PHASE_RESPONSES[this.context.phase]) {
      const phaseResponses = window.AI_PHASE_RESPONSES[this.context.phase][intent];
      if (phaseResponses) {
        responses = Array.isArray(phaseResponses) 
          ? [...phaseResponses, ...responses]
          : [phaseResponses, ...responses];
      }
    }
    
    // Select random response
    let response = window.AI_HELPERS.randomItem(responses);
    
    // Replace variables
    const variables = {
      eta: this.context.eta,
      phase_text: window.AI_HELPERS.getPhaseDescription(this.context.phase),
      store_name: this.context.storeName,
      driver_name: this.context.driverName
    };
    
    response = window.AI_HELPERS.replaceVariables(response, variables);
    
    // Add emoji
    response = window.AI_HELPERS.addEmoji(response, intent);
    
    // Format based on length preference
    response = window.AI_HELPERS.formatResponse(response);
    
    return response;
  }
  
  // Hybrid response (Rules + Simple AI)
  generateHybridResponse(userMessage, intent) {
    // Try rules first
    const rulesResponse = this.generateRulesResponse(userMessage, intent);
    
    // For complex questions, enhance with AI-like variations
    if (intent === "question" || userMessage.length > 30) {
      const enhancements = [
        "Saya pastikan pesanannya aman sampai ya!",
        "Tenang, saya perhatikan dengan baik.",
        "Informasinya sudah saya catat nih."
      ];
      
      const enhancement = window.AI_HELPERS.randomItem(enhancements);
      return `${rulesResponse} ${enhancement}`;
    }
    
    return rulesResponse;
  }
  
  // OpenAI API integration
  async generateOpenAIResponse(userMessage, intent) {
    if (!this.config.apiKeys.openai) {
      console.warn("OpenAI API key not configured, falling back to rules");
      return this.generateRulesResponse(userMessage, intent);
    }
    
    try {
      const prompt = this.createAIPrompt(userMessage, intent);
      
      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.config.apiKeys.openai}`
        },
        body: JSON.stringify({
          model: 'gpt-3.5-turbo',
          messages: [
            {
              role: 'system',
              content: prompt.system
            },
            {
              role: 'user',
              content: prompt.user
            }
          ],
          max_tokens: 150,
          temperature: 0.7
        })
      });
      
      const data = await response.json();
      if (data.choices && data.choices[0]) {
        return data.choices[0].message.content.trim();
      }
      
      throw new Error('No response from OpenAI');
      
    } catch (error) {
      console.error('OpenAI Error:', error);
      return this.generateRulesResponse(userMessage, intent);
    }
  }
  
  // Gemini API integration
  async generateGeminiResponse(userMessage, intent) {
    if (!this.config.apiKeys.gemini) {
      console.warn("Gemini API key not configured, falling back to rules");
      return this.generateRulesResponse(userMessage, intent);
    }
    
    try {
      const prompt = this.createAIPrompt(userMessage, intent);
      
      const response = await fetch(
        `https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=${this.config.apiKeys.gemini}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            contents: [{
              parts: [{ text: prompt.system + "\n\n" + prompt.user }]
            }],
            generationConfig: {
              temperature: 0.7,
              maxOutputTokens: 150
            }
          })
        }
      );
      
      const data = await response.json();
      if (data.candidates && data.candidates[0]) {
        return data.candidates[0].content.parts[0].text.trim();
      }
      
      throw new Error('No response from Gemini');
      
    } catch (error) {
      console.error('Gemini Error:', error);
      return this.generateRulesResponse(userMessage, intent);
    }
  }
  
  // Create AI prompt
  createAIPrompt(userMessage, intent) {
    const phaseDesc = window.AI_HELPERS.getPhaseDescription(this.context.phase);
    
    return {
      system: `You are a friendly delivery driver named ${this.context.driverName}.
Current status: ${phaseDesc}
ETA: ${this.context.eta} minutes
Store: ${this.context.storeName}

Guidelines:
1. Respond in Indonesian
2. Be friendly and helpful
3. Keep responses short (1-2 sentences)
4. Use emojis occasionally
5. Stay professional but warm
6. Don't share personal information

User's intent: ${intent}`,
      
      user: userMessage
    };
  }
  
  // Get auto greeting based on phase
  getAutoGreeting() {
    const greetings = {
      "order_confirmed": `Halo! Saya ${this.context.driverName}, sedang menuju ke ${this.context.storeName} 🛵`,
      "to_store": `Masih dalam perjalanan ke ${this.context.storeName}, tidak lama lagi sampai ⚡`,
      "preparing_done": `Sudah sampai di ${this.context.storeName}! Ambil pesanan dulu ya 😊`,
      "to_customer": `Pesanan sudah diambil! Sekarang menuju ke lokasi Anda 🎯`,
      "delivered": `Hampir sampai! Siap-siap ya 🎉`
    };
    
    return greetings[this.context.phase] || 
           `Halo! Saya ${this.context.driverName}, driver pengantar pesanan Anda 😊`;
  }
  
  // Get ETA update message
  getETAUpdate() {
    if (this.context.phase === "delivered") {
      return "Sudah sampai di lokasi! 🎉";
    }
    
    const messages = [
      `Perkiraan sampai: ${this.context.eta} menit lagi 🕒`,
      `Sekitar ${this.context.eta} menit lagi sampai ya ⏱️`,
      `Tinggal ${this.context.eta} menit! Sudah dekat nih 🎯`
    ];
    
    return window.AI_HELPERS.randomItem(messages);
  }
  
  // Get location update message
  getLocationUpdate() {
    const phaseDesc = window.AI_HELPERS.getPhaseDescription(this.context.phase);
    return `Update: ${phaseDesc} ${window.AI_HELPERS.randomItem(["😊", "✨", "👍"])}`;
  }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
  module.exports = AIChatEngine;
} else {
  window.AIChatEngine = AIChatEngine;
}
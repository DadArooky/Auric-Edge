// SmartHedgeGridEA_Mobile_Advanced.mq5

// Implementing $1.2 per position take profit targets
// Close trade profit logic
// $10 minimum equity requirements for trading

input double TakeProfitTarget = 1.2; // Take profit in dollars
input double MinimumEquityRequirement = 10.0; // Minimum equity required

void OnTick() {
    double currentEquity = AccountEquity();
    
    // Check if enough equity before trading
    if (currentEquity < MinimumEquityRequirement) {
        Print("Not enough equity to trade.");
        return;
    }
    
    // Your trading logic goes here
    // Example: Open a trade with take profit
    double lotSize = CalculateLotSize();
    int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, 0, Ask + TakeProfitTarget, NULL, 0, 0, clrGreen);
    if (ticket < 0) {
        Print("Error opening order: ", GetLastError());
    }

    // Close trades logic based on conditions
    CloseProfitTrades();
}

double CalculateLotSize() {
    // Logic to calculate appropriate lot size
    return 0.01; // Example
}

void CloseProfitTrades() {
    // Iterate through open trades and close them based on profit
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS) && OrderType() == OP_BUY) {
            double profit = OrderProfit();
            if (profit >= 1.2) { // Close if profit target met
                OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrRed);
            }
        }
    }
}
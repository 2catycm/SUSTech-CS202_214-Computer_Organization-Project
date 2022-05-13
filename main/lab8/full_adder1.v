
module full_adder1(
        input   Ai, Bi, Ci,
        output  So, Co);

`ifdef ADDER_DESCRIPTION
        assign {Co, So} = Ai + Bi + Ci ;
`else
        assign So = Ai ^ Bi ^ Ci ;
        assign Co = (Ai & Bi) | (Ci & (Ai | Bi));
`endif


endmodule

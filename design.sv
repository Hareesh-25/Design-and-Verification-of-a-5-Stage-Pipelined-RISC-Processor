// Code your design here
module pc(
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc_out
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        pc_out <= 32'd0;
    else
        pc_out <= next_pc;
end

endmodule

//Instruction Memory
module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory [0:255];

initial begin
    memory[0] = 32'h00221820; // ADD
    memory[1] = 32'h00632022; // SUB
    memory[2] = 32'h00852824; // AND
    memory[3] = 32'h00A63025; // OR
end

assign instruction = memory[address[9:2]];

endmodule

//Register File
module register_file(
    input clk,
    input reg_write,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] reg_mem [0:31];

assign read_data1 = reg_mem[rs];
assign read_data2 = reg_mem[rt];

always @(posedge clk)
begin
    if(reg_write)
        reg_mem[rd] <= write_data;
end

endmodule

//ALU
module alu(
    input [31:0] a,
    input [31:0] b,
    input [2:0] alu_control,
    output reg [31:0] result,
    output zero
);

always @(*)
begin
    case(alu_control)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = (a < b);
        default: result = 32'd0;
    endcase
end

assign zero = (result == 0);

endmodule

//Data Memory
module data_memory(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] mem [0:255];

always @(posedge clk)
begin
    if(mem_write)
        mem[address[9:2]] <= write_data;
end

always @(*)
begin
    if(mem_read)
        read_data = mem[address[9:2]];
    else
        read_data = 32'd0;
end

endmodule

//Control Unit
module control_unit(
    input [5:0] opcode,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg alu_src
);

always @(*)
begin
    case(opcode)

        6'b000000:
        begin
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 0;
            alu_src = 0;
        end

        6'b100011:
        begin
            reg_write = 1;
            mem_read = 1;
            mem_write = 0;
            mem_to_reg = 1;
            alu_src = 1;
        end

        6'b101011:
        begin
            reg_write = 0;
            mem_read = 0;
            mem_write = 1;
            mem_to_reg = 0;
            alu_src = 1;
        end

        default:
        begin
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            mem_to_reg = 0;
            alu_src = 0;
        end
    endcase
end

endmodule

//IF/ID Pipeline Register
module if_id(
    input clk,
    input reset,

    input [31:0] pc_in,
    input [31:0] instr_in,

    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        pc_out <= 0;
        instr_out <= 0;
    end
    else
    begin
        pc_out <= pc_in;
        instr_out <= instr_in;
    end
end

endmodule

//ID/EX Pipeline Register
module id_ex(
    input clk,
    input reset,

    input [31:0] a_in,
    input [31:0] b_in,

    output reg [31:0] a_out,
    output reg [31:0] b_out
);

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        a_out <= 0;
        b_out <= 0;
    end
    else
    begin
        a_out <= a_in;
        b_out <= b_in;
    end
end

endmodule

//EX/MEM Pipeline Register
module ex_mem(
    input clk,
    input reset,

    input [31:0] alu_in,
    output reg [31:0] alu_out
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        alu_out <= 0;
    else
        alu_out <= alu_in;
end

endmodule

//MEM/WB Pipeline Register
module mem_wb(
    input clk,
    input reset,

    input [31:0] data_in,
    output reg [31:0] data_out
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        data_out <= 0;
    else
        data_out <= data_in;
end

endmodule

//Forwarding Unit
module forwarding_unit(
    input [4:0] ex_rs,
    input [4:0] ex_rt,
    input [4:0] mem_rd,
    input [4:0] wb_rd,
    input mem_regwrite,
    input wb_regwrite,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*)
begin
    forwardA = 2'b00;
    forwardB = 2'b00;

    if(mem_regwrite && (mem_rd == ex_rs))
        forwardA = 2'b10;

    if(mem_regwrite && (mem_rd == ex_rt))
        forwardB = 2'b10;

    if(wb_regwrite && (wb_rd == ex_rs))
        forwardA = 2'b01;

    if(wb_regwrite && (wb_rd == ex_rt))
        forwardB = 2'b01;
end

endmodule

//Hazard Detection Unit
module hazard_detection(
    input id_ex_memread,
    input [4:0] id_ex_rt,
    input [4:0] if_id_rs,
    input [4:0] if_id_rt,

    output reg stall
);

always @(*)
begin
    if(id_ex_memread &&
      ((id_ex_rt == if_id_rs) ||
       (id_ex_rt == if_id_rt)))
        stall = 1;
    else
        stall = 0;
end

endmodule

//Top Module Skeleton
module processor_top(
    input clk,
    input reset
);

wire [31:0] pc_current;
wire [31:0] next_pc;
wire [31:0] instruction;

assign next_pc = pc_current + 4;

pc PC(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc_out(pc_current)
);

instruction_memory IM(
    .address(pc_current),
    .instruction(instruction)
);

endmodule


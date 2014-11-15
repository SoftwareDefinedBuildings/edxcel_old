
/*
static uint64_t load_3(const unsigned char *in) {
    uint64_t result;

    result = (uint64_t) in[0];
    result |= ((uint64_t) in[1]) << 8;
    result |= ((uint64_t) in[2]) << 16;

    return result;
}
*/

function [63:0] load_3;
input [23:0] in;
begin
    load_3 = {40b'0, in};
end

function [63:0] load_4;
input [32:0] in;
begin
    load_4 = {32b'0, in};
end

function
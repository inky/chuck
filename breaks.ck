"samples/amen.wav" => string amen_filename;
SndBuf amen => dac;
amen_filename => amen.read;

dac => WvOut w => blackhole;
"out/breaks.wav" => w.wavFilename;

92 => float m;  // length of one beat

// amen break
//  b: beats
//  r: rate (1.0 = original speed)
//  pos: position
fun void abreak(float b, float r, int pos) {
    r => amen.rate;
    pos => amen.pos;
    (b * m)::ms => now;
}

fun void sbreak(float b, float r, int pos) {
    SndBuf a => dac;
    amen_filename => a.read;
    0.8 => a.gain;
    r => a.rate;
    pos => a.pos;
    (b * m)::ms => now;
}

amen.samples() => int samples;
samples => amen.pos;

samples/16 => int _snare_pos;
samples/2 => int _downbeat_pos;
29 * samples/32 => int _cymbal_pos;

fun void snare(float b, float r) { abreak(b, r, _snare_pos); }
fun void downbeat(float b, float r) { abreak(b, r, _downbeat_pos); }
fun void cymbal(float b, float r) { abreak(b, r, _cymbal_pos); }


for (0 => int L; L < 3; L++) {
    for (0 => int i; i < 4; i++) {
        downbeat(2, 1.12);
        downbeat(2, 1.02);

        if (i < 3) {
            snare(1, 0.88);
            snare(1, 0.85);
            cymbal(2, 1.2);

            cymbal(2, 1.05);
            snare(1, 0.85);
            snare(1, 0.75);

            cymbal(1, 0.85);
            snare(1, 1.15);
        } else {
            spork ~ sbreak(4, 0.8, _cymbal_pos);
            snare(2, 0.8);
            snare(2, 1.2);

            cymbal(2, 1.2);

            snare(1, 0.78);
            snare(1, 0.88);
            snare(1, 0.98);
            snare(1, 1.08);
        }
    }
}

spork ~ sbreak(3, 0.8, _cymbal_pos);
downbeat(1.5, 1.0);
cymbal(1.5, 1.0);
downbeat(1.5, 0.9);
cymbal(1.5, 1.0);
spork ~ sbreak(3, 0.7, _cymbal_pos);
snare(1.5, 1.1);
cymbal(1.5, 1);
downbeat(1.5, 1);
downbeat(1.5, 0.8);

spork ~ sbreak(3, 0.5, _cymbal_pos);
cymbal(2, 0.85);
snare(1, 0.9);
downbeat(1.5, 0.9);
cymbal(3, 0.85);
downbeat(1.5, 0.9);
snare(1.5, 0.8);
downbeat(1.5, 1);

downbeat(3, 0.8);
0 => amen.gain;
0.5::second => now;

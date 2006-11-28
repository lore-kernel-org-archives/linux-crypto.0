From: rsnel@cube.dyndns.org
Subject: Re: [PATCHv2 4/6] crypto: table driven multiplications in GF(2^128), needed by LRW (and in the future ABL)
Date: Tue, 28 Nov 2006 21:02:32 +0100
Message-ID: <20061128200232.GA401@cube.dyndns.org>
References: <20060901103707.GA17110@gondor.apana.org.au> <11571588311154-git-send-email-rsnel@cube.dyndns.org> <20061126235607.GA25850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:9742 "EHLO
	smtp-vbr2.xs4all.nl") by vger.kernel.org with ESMTP id S936084AbWK1UC7
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Nov 2006 15:02:59 -0500
To: Herbert Xu <herbert@gondor.apana.org.au>
Content-Disposition: inline
In-Reply-To: <20061126235607.GA25850@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

On Mon, Nov 27, 2006 at 10:56:07AM +1100, Herbert Xu wrote:
> On Sat, Sep 02, 2006 at 03:00:25AM +0200, rsnel@cube.dyndns.org wrote:
>
> Sorry it took so long.  But I've been trying to modify the code so
> that the same source is used for both BE and LE machines.  I've
> finally accumulated enough time to finish it.

It's OK. The source will be more maintainable, but constantly converting
between big and little-endian (on little endian machines) may have a
significant performance impact (I will just test when your gf128 hits
cryptodev-2.6, and complain if it is the case).

Two more remarks (errors in v2 of my patch): b128ops.h and gf128mul.h
should be in include/ (so they can be used in modules) and the inline
functions in b128ops.h should also be static.

> Unfortunately it seems that the end result doesn't quite agree with
> your test vectors :) In particular, the LE version of your mul_x and
> mul_x8 functions don't agree with mine.
> 
> Could you please compare the two versions and double-check them?
> I'm unsure why 15 was used above as a shift count.  It would seem
> that 7 would seem to make more sense as endianness is byte-based
> not word-based.
> >
> > +#define M80X	0x8080808080808080LLU
> > +#define M01X	0x0101010101010101LLU
> > +
> > +static void gf128mul_x_lle(u64 r[2], const u64 x[2])
> > +{
> > +	u64  _tt = gf128mul_table_lle[(x[1] >> 49) & 0x80];
> > +	r[1] =  ((x[1] >> 1) & ~M80X) | (((x[1] << 15) | (x[0] >> 49)) & M80X);
> > +	r[0] = (((x[0] >> 1) & ~M80X) |  ((x[0] << 15) & M80X)) ^ _tt;
> > +}

I'll try to explain why I think the above code is correct:
As in my comment in gf128mul.h, lle means the polynomials in gf127 are
stored in little-little-endian format. So 
10000000 00000000 .. 00000000 = 0x80 0x00 .. 0x00 = 1
01000000 00000000 .. 00000000 = 0x40 0x00 .. 0x00 = X^1
01010001 00000000 .. 10000000 = 0x51 0x00 .. 0x80 = X^1 + X^3 + X^7 + X^120
00000000 00000000 .. 00000001 = 0x00 0x00 .. 0x01 = X^127

The u64 type emulates a little endian 64bit processor (on my 32bit
intel) so when we load the these examples in two 64bit little endian
integers they are:
0x0000000000000080 0x0000000000000000 = 1
0x0000000000000040 0x0000000000000000 = X^1
0x0000000000000051 0x8000000000000000 = X^1 + X^3 + X^7 + X^120
0x0000000000000000 0x0100000000000000 = X^127

Let's multiply the third example by X, we should get
00101000 10000000 .. 01000000 = 0x28 0x80 .. 0x40 = X^2 + X^4 + X^8 + X^121

Represented as two little endian 64 bit values:
0x0000000000008028 0x4000000000000000

The above code implements this shift (efficiently?) by noting:
in each byte bit 1 moves to bit 0, bit 2 moves to bit 1, ..., bit 7
moves to bit 6 and all 7th bits are zeroed afterwards.
(this is done by ((x[1] >> 1) & ~M80X)), the 7th bits are set by moving
the least significant bits of the bytes to the right position (15 bits
to the left) and orring.

Let's look at the example: the first 8 in 0x0...008028 comes from the
least significant bit of 0x00.00051. So the shift by 15 to get the 7th
bit of every byte right is correct. (I have included a simple program
to compare the different implementations)

> I've attached my version of gf128mul which is based on your BE
> code.

Ok, will comment.

> The other main change I've made is to remove the need to
> allocate a contiguous 64K table in gf128mul.  Requiring every
> tfm to allocate a contiguous 64K chunk of memory is not realistic
> on Linux.

Ok.

> I also added a be128/le128/u128 type to make 128-bit operations
> easier.

I assume it is: typedef struct { u64 a, u64 b } be128; 
As long as compilers don't do u128 natively it is just a matter of taste.

> [...]
> +#define xx(p, q)       __constant_be16_to_cpu(0x##p##q)

This seems to be the problem, the table is constructed wrongly. 
All the calculations take place as if we are on a big endian machine, so
the table entries should never be swapped, so the above line should read

+#define xx(p, q)       0x##p##q

While investigating the problem, I wrote a small program to compare
a bytewise implementation with Brian's and your implementation of mul_x,
it only works in the lle implementation.

Once I found this problem, I stopped looking, so let me know if the test
vectors still don't match up, then I will need to take a closer look.

Greetings,

Rik.

/* test program for mutiplying by X in GF(2^128) in lle representation
 * on a little endian machine. */
/* GNU GPL >= v2 applies, (C) Brian Gladman, Herbert Xu, Rik Snel. */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <byteswap.h>

typedef uint64_t u64;
typedef uint16_t u16;
typedef struct {
	u64 a;
	u64 b;
} be128;

#define gf128mul_dat(q) { \
        q(0x00), q(0x01), q(0x02), q(0x03), q(0x04), q(0x05), q(0x06), q(0x07),\
        q(0x08), q(0x09), q(0x0a), q(0x0b), q(0x0c), q(0x0d), q(0x0e), q(0x0f),\
        q(0x10), q(0x11), q(0x12), q(0x13), q(0x14), q(0x15), q(0x16), q(0x17),\
        q(0x18), q(0x19), q(0x1a), q(0x1b), q(0x1c), q(0x1d), q(0x1e), q(0x1f),\
        q(0x20), q(0x21), q(0x22), q(0x23), q(0x24), q(0x25), q(0x26), q(0x27),\
        q(0x28), q(0x29), q(0x2a), q(0x2b), q(0x2c), q(0x2d), q(0x2e), q(0x2f),\
        q(0x30), q(0x31), q(0x32), q(0x33), q(0x34), q(0x35), q(0x36), q(0x37),\
        q(0x38), q(0x39), q(0x3a), q(0x3b), q(0x3c), q(0x3d), q(0x3e), q(0x3f),\
        q(0x40), q(0x41), q(0x42), q(0x43), q(0x44), q(0x45), q(0x46), q(0x47),\
        q(0x48), q(0x49), q(0x4a), q(0x4b), q(0x4c), q(0x4d), q(0x4e), q(0x4f),\
        q(0x50), q(0x51), q(0x52), q(0x53), q(0x54), q(0x55), q(0x56), q(0x57),\
        q(0x58), q(0x59), q(0x5a), q(0x5b), q(0x5c), q(0x5d), q(0x5e), q(0x5f),\
        q(0x60), q(0x61), q(0x62), q(0x63), q(0x64), q(0x65), q(0x66), q(0x67),\
        q(0x68), q(0x69), q(0x6a), q(0x6b), q(0x6c), q(0x6d), q(0x6e), q(0x6f),\
        q(0x70), q(0x71), q(0x72), q(0x73), q(0x74), q(0x75), q(0x76), q(0x77),\
        q(0x78), q(0x79), q(0x7a), q(0x7b), q(0x7c), q(0x7d), q(0x7e), q(0x7f),\
        q(0x80), q(0x81), q(0x82), q(0x83), q(0x84), q(0x85), q(0x86), q(0x87),\
        q(0x88), q(0x89), q(0x8a), q(0x8b), q(0x8c), q(0x8d), q(0x8e), q(0x8f),\
        q(0x90), q(0x91), q(0x92), q(0x93), q(0x94), q(0x95), q(0x96), q(0x97),\
        q(0x98), q(0x99), q(0x9a), q(0x9b), q(0x9c), q(0x9d), q(0x9e), q(0x9f),\
        q(0xa0), q(0xa1), q(0xa2), q(0xa3), q(0xa4), q(0xa5), q(0xa6), q(0xa7),\
        q(0xa8), q(0xa9), q(0xaa), q(0xab), q(0xac), q(0xad), q(0xae), q(0xaf),\
        q(0xb0), q(0xb1), q(0xb2), q(0xb3), q(0xb4), q(0xb5), q(0xb6), q(0xb7),\
        q(0xb8), q(0xb9), q(0xba), q(0xbb), q(0xbc), q(0xbd), q(0xbe), q(0xbf),\
        q(0xc0), q(0xc1), q(0xc2), q(0xc3), q(0xc4), q(0xc5), q(0xc6), q(0xc7),\
        q(0xc8), q(0xc9), q(0xca), q(0xcb), q(0xcc), q(0xcd), q(0xce), q(0xcf),\
        q(0xd0), q(0xd1), q(0xd2), q(0xd3), q(0xd4), q(0xd5), q(0xd6), q(0xd7),\
        q(0xd8), q(0xd9), q(0xda), q(0xdb), q(0xdc), q(0xdd), q(0xde), q(0xdf),\
        q(0xe0), q(0xe1), q(0xe2), q(0xe3), q(0xe4), q(0xe5), q(0xe6), q(0xe7),\
        q(0xe8), q(0xe9), q(0xea), q(0xeb), q(0xec), q(0xed), q(0xee), q(0xef),\
        q(0xf0), q(0xf1), q(0xf2), q(0xf3), q(0xf4), q(0xf5), q(0xf6), q(0xf7),\
        q(0xf8), q(0xf9), q(0xfa), q(0xfb), q(0xfc), q(0xfd), q(0xfe), q(0xff) \
}

#define xxle(p,q) 0x##q##p        /* assemble in little endian order */
#define xxbe(p,q) 0x##p##q        /* assemble in big endian order */

#define xda_lle_le(i) ( \
    (i&0x80?xxle(e1,00):0)^(i&0x40?xxle(70,80):0)^ \
    (i&0x20?xxle(38,40):0)^(i&0x10?xxle(1c,20):0)^ \
    (i&0x08?xxle(0e,10):0)^(i&0x04?xxle(07,08):0)^ \
    (i&0x02?xxle(03,84):0)^(i&0x01?xxle(01,c2):0) \
)

#define xda_lle_be(i) ( \
    (i&0x80?xxbe(e1,00):0)^(i&0x40?xxbe(70,80):0)^ \
    (i&0x20?xxbe(38,40):0)^(i&0x10?xxbe(1c,20):0)^ \
    (i&0x08?xxbe(0e,10):0)^(i&0x04?xxbe(07,08):0)^ \
    (i&0x02?xxbe(03,84):0)^(i&0x01?xxbe(01,c2):0) \
)

static const u16 gf128mul_table_lle_le[256] = gf128mul_dat(xda_lle_le);
static const u16 gf128mul_table_lle_be[256] = gf128mul_dat(xda_lle_be);

/* simple straightforward implementation, does not depend
 * on machine endianness */
void mul_x_lle_simple(be128 *result, const be128 *ex) {
	unsigned char *r = (unsigned char*)result;
	const unsigned char *x = (unsigned char*)ex;
	u64 overflow = 0xE1*(x[15]&0x01); /* do we get X^128 ? */
	r[15] = x[15]>>1|x[14]<<7;
	r[14] = x[14]>>1|x[13]<<7;
	r[13] = x[13]>>1|x[12]<<7;
	r[12] = x[12]>>1|x[11]<<7;
	r[11] = x[11]>>1|x[10]<<7;
	r[10] = x[10]>>1|x[9]<<7;
	r[9] = x[9]>>1|x[8]<<7;
	r[8] = x[8]>>1|x[7]<<7;
	r[7] = x[7]>>1|x[6]<<7;
	r[6] = x[6]>>1|x[5]<<7;
	r[5] = x[5]>>1|x[4]<<7;
	r[4] = x[4]>>1|x[3]<<7;
	r[3] = x[3]>>1|x[2]<<7;
	r[2] = x[2]>>1|x[1]<<7;
	r[1] = x[1]>>1|x[0]<<7;
	r[0] = x[0]>>1|overflow;
}

/* for use on little endian machines; remove bswap_64's for usage
 * on bigendian machines */
void mul_x_lle_herbert(be128 *r, const be128 *x) {
	u64 a = bswap_64(x->a);
	u64 b = bswap_64(x->b);
	u64 _tt = gf128mul_table_lle_be[(b << 7) & 0xff];

	r->b = bswap_64((b >> 1) | (a << 63));
	r->a = bswap_64((a >> 1) ^ (_tt << 48));
}

/* works on little endian machines, use above version without bswap_64's
 * on big endian machines, should be faster than the above version
 * on little endian machines */
#define M80X       0x8080808080808080LLU
void mul_x_lle_brian(be128 *r, const be128 *x) {
	u64  _tt = gf128mul_table_lle_le[(x->b >> 49) & 0x80];
	r->b =  ((x->b >> 1) & ~M80X) | (((x->b << 15) | (x->a >> 49)) & M80X);
	r->a = (((x->a >> 1) & ~M80X) |  ((x->a << 15) & M80X)) ^ _tt;
}

void debug(char *name, be128 *ex) {
	int i;
	unsigned char *x = (unsigned char*)ex;
	for (i = 0; i < 16; i++)
		printf("%02x ", x[i]);
	printf("%s\n", name);
}

int main(int argc, char **argv) {
	assert(sizeof(be128) == 128/8);
	char V[16] = {
		//0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		//0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
		0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0,
		0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0,
	};
	char R[16];
	debug("V", (be128*)V);
	mul_x_lle_simple((be128*)R, (be128*)V);
	debug("XV_simple", (be128*)R);
	mul_x_lle_herbert((be128*)R, (be128*)V);
	debug("XV_herbert", (be128*)R);
	mul_x_lle_brian((be128*)R, (be128*)V);
	debug("XV_brian", (be128*)R);
	exit(0);
}

-- 
Nothing is ever a total loss; it can always serve as a bad example.

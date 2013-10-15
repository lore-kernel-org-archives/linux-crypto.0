From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 15 Oct 2013 08:23:41 +0200
Message-ID: <2784827.Oba8fbRgfE@tauon>
References: <2579337.FPgJGgHYdz@tauon> <3593500.a7fOuGKlEX@tauon> <CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACXcFm=M2Jrra3tttWyhwfs-a6iVm0joiKi=wHKuANe_s_F-Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 14. Oktober 2013, 11:18:16 schrieb Sandy Harris:

Hi Sandy,

Could you please review the following code to see that the mix is 
function right in your eyes?
>
>However, having done that, I see no reason not to add mixing.
>Using bit() for getting one bit of input and rotl(x) for rotating
>left one bit, your code is basically, with 64-bit x:
>
>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) )
>        x |= bit()
>
>Why not declare some 64-bit constant C with a significant
>number of bits set and do this:
>
>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) ) // same loop control
>      if( bit() ) x ^= C ;

I only want to use the XOR function as this is bijective and fits to my 
mathematical model.

The entropy_collector->data contains the random number. The code first 
produces the mixer value that is XORed as often as set bits are 
available in the input random number. Finally, it is XORed with the 
random number.

The function is currently called unconditionally after the 64 bit random 
number is generated from the noise source.

static inline void jent_stir_pool(struct rand_data *entropy_collector)
{
        /* This constant is derived from the first two 32 bit 
initialization
         * vectors of SHA-1 -- 32 bits are set and 32 are unset */
        __u64 constant = 0x67452301efcdab89;
        __u64 mixer = 0;
        int i = 0;

        for(i = 0; i < DATA_SIZE_BITS; i++)
        {
                /* get the i-th bit of the input random number and
                 * XOR the constant into the mixer value only when that 
bit
                 * is set */
                if((entropy_collector->data >> i) & 0x0000000000000001)
                        mixer ^= constant;
                mixer = rol64(mixer, 1);
        }
        entropy_collector->data ^= mixer;
}

The statistical behavior of the output looks good so far (just tested it 
with the ent tool -- the Chi Square value is good). It also does not 
compress with bzip2.

Thanks a lot
Stephan

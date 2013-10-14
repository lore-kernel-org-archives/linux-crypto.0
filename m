From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 14 Oct 2013 17:26:53 +0200
Message-ID: <1420251.G1iR4tbUp8@tauon>
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

>On Mon, Oct 14, 2013 at 10:40 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
>> Another thing: when you start adding whitening functions, other
>> people
>> are starting (and did -- thus I added section 4.3 to my
>> documentation)
>> to complain that you hide your weaknesses behind the whiteners. I
>> simply want to counter that argument and show that RNG produces
>> white noise without a whitener.
>
>Yes, you absolutely have to test the unwhitened input entropy, and
>provide a way for others to test it so they can have confidence in your
>code and it can be tested again if it is going to be used on some new
>host. You do a fine job of that; your paper has the most detailed
>analysis I have seen. Bravo.

Thank you very much.
>
>However, having done that, I see no reason not to add mixing.
>Using bit() for getting one bit of input and rotl(x) for rotating
>left one bit, your code is basically, with 64-bit x:
>
>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) )
>        x |= bit()

Ok, let me play a bit with that. Maybe I can add another flag to the 
allocation function so that the caller can decide whether to use that. 
If the user is another RNG, you skip that mixing function, otherwise you 
should take it.

But I need a whitening / mixing function that should not add more 
dependencies on the underlying host. The code you have above would be 
ok.
>
>Why not declare some 64-bit constant C with a significant

Which constant would you take? The CRC twist values? The SHA-1 initial 
values? Or the first few from SHA-256?

>number of bits set and do this:
>
>   for( i=0, x = 0 ; i < 64; i++, x =rotl(x) ) // same loop control
>      if( bit() ) x ^= C ;
>
>This makes every output bit depend on many input bits
>and costs almost nothing extra.

Good point.
>
>In the unlikely event that the overhead here matters,
>your deliberately inefficient parity calculation in bit()
>could easily be made faster to compensate.


I will come back to you on this suggestion.


Ciao
Stephan

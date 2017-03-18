From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [ANNOUNCE] /dev/random - a new approach (code for 4.11-rc1)
Date: Sat, 18 Mar 2017 14:31:38 +0100
Message-ID: <4792500.irvFnm0WRl@positron.chronox.de>
References: <2785457.pDyvZpZC2q@positron.chronox.de> <CAH8yC8=+K76rwRfYk=92sBE0v9fPEWB=2bUQqF=tyY5C1nrvKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58104 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbdCRNbp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Mar 2017 09:31:45 -0400
In-Reply-To: <CAH8yC8=+K76rwRfYk=92sBE0v9fPEWB=2bUQqF=tyY5C1nrvKQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. März 2017, 11:11:57 CET schrieb Jeffrey Walton:

Hi Jeffrey,

> > The design and implementation is driven by a set of goals described in [2]
> > that the LRNG completely implements. Furthermore, [2] includes a
> > comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
> > AIS20/31.
> 
> A quick comment about SP800 and the hardware instructions... RDSEED is
> 2 to 5 times slower than RDRAND on Intel hardware, depending on the
> architecture and microarchitecture.

I am not sure how this statement relates to the quote above. RDSEED is the 
CBC-MACed output of the flip-flop providing the raw noise.

RDRAND is the output of the SP800-90A CTR DRBG that is seeded by the CBC-MAC 
that also feeds RDSEED. Thus, RDSEED is as fast as the noise source where 
RDRAND is a pure deterministic RNG that tries to be (re)seeded as often as 
possible.

Both instructions are totally unrelated to the SP800-90A DRBG available to the 
Linux kernel.

> AMD's implementation of RDRAND is
> orders of magnitude slower than Intel's. Testing on an Athlon 845 X4
> (Bulldozer v4) @ 3.5 GHz shows it runs between 4100 and 4500 cycles
> per byte. It works out to be about 1 MiB/s.

Please consider my speed measurements given in [1] section 3.4.6. The DRBG is 
just slightly slower than the ChaCha20 on small block sizes and twice as fast 
on larger block sizes using AES-NI on x86. As the DRBG implementation has no 
relationship to the RDRAND DRBG, I am not sure about your argument.

When I refer to hardware instructions and SP800-90A, I consider the SP800-90A 
DRBG implementation in crypto/drbg.c provided with the kernel crypto API which 
uses the raw AES/SHA cipher implementation provided by the kernel crypto API. 
Here, the implementation uses the fastest one, such as the AES-NI raw AES 
implementation on x86. Or it uses the ARM NEON SHA implementation for the 
HMAC/Hash DRBG.
> 
> While the LRNG may reach a cryptographically acceptable seed level
> much earlier then the existing /dev/random, it may not be early
> enough.

The LRNG will initialize as a DRBG during late_initcall. Thus, the DRBG is 
always present if user space calls.

However, during kernel boot, there is of course a need for earlier randomness. 
This is covered by the init DRNG documented in [1] section 2.10.

> Some components, like systemd, will ask for random numbers and
> truck-on even if they are not available. Systemd does not block or
> wait if get_random_bytes fails to produce. In the bigger picture,
> don't expect that software layered above will do the expected thing in
> all cases.

The LRNG works as a full ABI and API replacement for the current /dev/random 
implementation. I run it on my servers. It delivers random data for all use 
cases, during early kernel and user space boot as well as during runtime.

[1] http://www.chronox.de/lrng/doc/lrng.pdf
> 
> Jeff


Ciao
Stephan

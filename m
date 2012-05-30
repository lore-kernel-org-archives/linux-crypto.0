From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Thu, 31 May 2012 07:29:11 +1000
Message-ID: <20120530212911.GA14884@gondor.apana.org.au>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
 <20120530113235.GO17705@kronos.redsun>
 <20120530153949.GS27374@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?Q?M=FCller?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120530153949.GS27374@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 30, 2012 at 05:39:49PM +0200, Andi Kleen wrote:
> > I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
> > ciphers from the intel-aesni module get loaded whether I need them or not. As
> > Jussi stated most people using distros probably won't need the
> > serpent-avx-x86_64 module get loaded automatically, so it's probably better to
> > leave it that way.
> 
> That means you got a 50% chance to use the wrong serpent.

You should always get the best one available.  For example, when
you request for "aes" all implementations of it will be loaded by
modprobe.

> This was a continuous problem with AESNI and the accelerated CRC,
> that is why the cpuid probing was implemented.

The only case where it doesn't work is if you have some variants
built-in and the faster ones built as modules.  But then the answer
is to either build all of them as modules or all of them built-in
so that priority-based selection can work.

Can you provide an example where it doesn't work as intended?

What we could do is to use the cpuid-based probing when an algorithm
is needed to selectively load the relevant implementations instead
of all of them.  However, for most algorithms it won't make that
big a difference since all the available ones will be loaded anyway.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

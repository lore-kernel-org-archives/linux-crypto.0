From: Satyam Sharma <satyam@infradead.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Sun, 2 Sep 2007 08:22:42 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0709020746250.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <20070901155353.8a09db69.kamezawa.hiroyu@jp.fujitsu.com>
 <20070831235815.a09c7865.akpm@linux-foundation.org> <20070901085429.GA7213@gondor.apana.org.au>
 <alpine.LFD.0.999.0709020157580.20781@enigma.security.iitk.ac.in>
 <20070902014610.GA15533@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37179 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXIBCjn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Sep 2007 22:39:43 -0400
In-Reply-To: <20070902014610.GA15533@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Sun, 2 Sep 2007, Herbert Xu wrote:
> 
> On Sun, Sep 02, 2007 at 02:39:15AM +0530, Satyam Sharma wrote:
> > 
> > Tangential, but I've often wondered what are the upsides of keeping
> > CONFIG_CRYPTO_ALGAPI as a separate config option in the first place? Every
> > single item in crypto/ ends up "select"ing it (directly or transitively)
> > so it makes all sense to just do away with it and keep it == CONFIG_CRYPTO
> > in the Makefile, thusly:
> 
> NACK.  ALGAPI exists so that it can be built as a module, as
> opposed to CRYPTO which is always built-in.

I had already noticed that, and was even *expecting* you to reply with
*exactly* this ;-)

[ BTW CRYPTO is _not_ always built-in -- but only when CONFIG_CRYPTO=y ]

Anyway, the natural follow-up to your argument is -- why is the other
stuff in CRYPTO always built-in too ?

Take the crypto_alloc_xxx() callchain for example (I chose it because
it is the _first_ call any cryptoapi user ever has to make, and hence
it's the one that deals with module-loading stuff).

So what finally got exported out of crypto/ to the rest of the kernel
was just the crypto_alloc_xxx() wrapper. That resolves to a call to
crypto_alloc_base() in crypto/api.c, which first loads the specific
low-level algo modules, and then proceeds to crypto_init_ops(), which
itself may, say, resolve to a crypto_init_digest_ops() -- the only
interface exported from digest.c.

The point is, because the module-loading (if necessary) already takes
place before the call to digest.c is made, there is _no_ reason why
even digest.c can't be made modular -- or _any_ of the other CRYPTO
stuff (with the exception of api.c itself, of course) that "always
gets built-in" as you mentioned above.

And so caring about the optimization of making ALGAPI modular rather
than simply built-in with rest of "core" crypto stuff such as digest.c
(which could _also_ have been made modular by the same logic but wasn't)
sounds like a bogus argument to me. [ BTW did you notice that the
__crypto_alloc_tfm() has been EXPORT_SYMBOL'ed _only_ because of one
solitary modular-callsite in algapi.c ? ]


Satyam

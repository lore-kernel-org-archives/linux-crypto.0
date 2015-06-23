From: Stephan Mueller <smueller@chronox.de>
Subject: Re: #pragma GCC warnings (was: Re: [PATCH] crypto: drbg - use pragmas for disabling optimization)
Date: Tue, 23 Jun 2015 15:01:14 +0200
Message-ID: <33380936.3jDOACMRCz@tachyon.chronox.de>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com> <20150623092106.GA18791@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47794 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbbFWNBW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 09:01:22 -0400
In-Reply-To: <20150623092106.GA18791@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. Juni 2015, 17:21:06 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Jun 23, 2015 at 11:17:23AM +0200, Geert Uytterhoeven wrote:
> > I get that too with m68k-linux-gcc-4.6.3 and m68k-linux-gcc-4.9.0.
> > 
> > With m68k-linux-gnu-gcc-4.1, which is still my default cross-compiler due
> > to the good unused warning reporting, I get:
> > 
> > crypto/jitterentropy.c:235: warning: ignoring #pragma GCC push_options
> > crypto/jitterentropy.c:236: warning: ignoring #pragma GCC optimize
> > crypto/jitterentropy.c:266: warning: ignoring #pragma GCC pop_options
> > crypto/jitterentropy.c:295: warning: ignoring #pragma GCC push_options
> > crypto/jitterentropy.c:296: warning: ignoring #pragma GCC optimize
> > crypto/jitterentropy.c:336: warning: ignoring #pragma GCC pop_options
> > crypto/jitterentropy.c:385: warning: ignoring #pragma GCC push_options
> > crypto/jitterentropy.c:386: warning: ignoring #pragma GCC optimize
> > crypto/jitterentropy.c:416: warning: ignoring #pragma GCC pop_options
> > crypto/jitterentropy.c:517: warning: ignoring #pragma GCC push_options
> > crypto/jitterentropy.c:518: warning: ignoring #pragma GCC optimize
> > crypto/jitterentropy.c:580: warning: ignoring #pragma GCC pop_options
> 
> Stephan, could you look into moving the relevant functions into
> its own file which can then be compiled with -O0? Obviously any
> dependency on kernel header files would have to be hidden using
> functions outside of this file.

I have separated all so far. However, there are two items left where I am not 
sure about:

- asm/types.h: I need __u64

- linux/bitops.h: I need rol64

Can I safely include both header files or do I have to hide them too. If yes, 
how would I do that in a way that is satisfactory?

Thanks.

-- 
Ciao
Stephan

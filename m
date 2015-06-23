From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: #pragma GCC warnings (was: Re: [PATCH] crypto: drbg - use
 pragmas for disabling optimization)
Date: Tue, 23 Jun 2015 17:21:06 +0800
Message-ID: <20150623092106.GA18791@gondor.apana.org.au>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guenter Roeck <linux@roeck-us.net>,
	Stephan Mueller <smueller@chronox.de>,
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39028 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbFWJVj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 05:21:39 -0400
Content-Disposition: inline
In-Reply-To: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:17:23AM +0200, Geert Uytterhoeven wrote:
> 
> I get that too with m68k-linux-gcc-4.6.3 and m68k-linux-gcc-4.9.0.
> 
> With m68k-linux-gnu-gcc-4.1, which is still my default cross-compiler due
> to the good unused warning reporting, I get:
> 
> crypto/jitterentropy.c:235: warning: ignoring #pragma GCC push_options
> crypto/jitterentropy.c:236: warning: ignoring #pragma GCC optimize
> crypto/jitterentropy.c:266: warning: ignoring #pragma GCC pop_options
> crypto/jitterentropy.c:295: warning: ignoring #pragma GCC push_options
> crypto/jitterentropy.c:296: warning: ignoring #pragma GCC optimize
> crypto/jitterentropy.c:336: warning: ignoring #pragma GCC pop_options
> crypto/jitterentropy.c:385: warning: ignoring #pragma GCC push_options
> crypto/jitterentropy.c:386: warning: ignoring #pragma GCC optimize
> crypto/jitterentropy.c:416: warning: ignoring #pragma GCC pop_options
> crypto/jitterentropy.c:517: warning: ignoring #pragma GCC push_options
> crypto/jitterentropy.c:518: warning: ignoring #pragma GCC optimize
> crypto/jitterentropy.c:580: warning: ignoring #pragma GCC pop_options

Stephan, could you look into moving the relevant functions into
its own file which can then be compiled with -O0? Obviously any
dependency on kernel header files would have to be hidden using
functions outside of this file.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: nios2: Export get_cycles
Date: Tue, 9 Jun 2015 13:50:52 +0800
Message-ID: <20150609055052.GA8464@gondor.apana.org.au>
References: <3181127.KGS6GDHCq6@tachyon.chronox.de>
 <55766C3A.3070101@roeck-us.net>
 <20150609044646.GA6892@gondor.apana.org.au>
 <20150609151932.4e6ac9e9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guenter Roeck <linux@roeck-us.net>,
	Stephan Mueller <smueller@chronox.de>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53198 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbFIFvJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 01:51:09 -0400
Content-Disposition: inline
In-Reply-To: <20150609151932.4e6ac9e9@canb.auug.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2015 at 03:19:32PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> On Tue, 9 Jun 2015 12:46:46 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Mon, Jun 08, 2015 at 09:31:54PM -0700, Guenter Roeck wrote:
> > > 
> > > nios2 still fails to build with
> > > 
> > > ERROR: "get_cycles" [crypto/jitterentropy.ko] undefined!
> > 
> > It's the only arch that doesn't inline get_cycles and doesn't
> > export it.
> > 
> > ---8<---
> > nios2 is the only architecture that does not inline get_cycles
> > and does not export it.  This breaks crypto as it uses get_cycles
> > in a number of modules.
> > 
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Also added into linux-next today.
> 
> I am assuming that they will turn up in the crypto tree soon(ish).

Yes I'll be adding them to cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

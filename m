From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.37
Date: Thu, 16 Dec 2010 08:58:13 +0800
Message-ID: <20101216005813.GA820@gondor.apana.org.au>
References: <20100305071043.GA3548@gondor.apana.org.au> <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <AANLkTikM4vQe7dsN8JJ1QSLeeTbRpSnuoJU=e4H2YFoz@mail.gmail.com> <20101216004938.GA32662@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60444 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0LPA6S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Dec 2010 19:58:18 -0500
Content-Disposition: inline
In-Reply-To: <20101216004938.GA32662@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 16, 2010 at 08:49:38AM +0800, Herbert Xu wrote:
> On Wed, Dec 15, 2010 at 12:40:48PM -0800, Linus Torvalds wrote:
> >
> > There's a few other objects like that too. How do you push to your
> > repo, and what changed?
> 
> Oops, I've fixed that now.  I use rsync to copy files across so
> it's my end that has changed.  And indeed I've just done an upgrade.
> Sorry.

OK it should be fixed for got now.  I suspect what has changed
is that git is now using my umask by default.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

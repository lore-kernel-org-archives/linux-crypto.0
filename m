From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Crypto Update for 3.5
Date: Thu, 24 May 2012 08:36:24 +0000
Message-ID: <201205240836.24845.arnd@arndb.de>
References: <20101024061625.GA23715@gondor.apana.org.au> <CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com> <20120524002126.GA28104@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Westin <andreas.westin@stericsson.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:65215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2EXIgj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 May 2012 04:36:39 -0400
In-Reply-To: <20120524002126.GA28104@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 24 May 2012, Herbert Xu wrote:
> On Wed, May 23, 2012 at 04:06:35PM -0700, Linus Torvalds wrote:
> > On Tue, May 22, 2012 at 6:35 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > Here is the crypto update for 3.5:
> > 
> > I pulled this, but quite frankly, some of it looks like utter garbage.
> > 
> > There's a declaration for dbx500_add_platform_device_noirq() that does
> > not exist and is not used anywhere. Why? It was added in commit
> > 585d188f8072, and I see no rhyme or reason to it.
> 
> I can't see why that was added there either.
> 
> Adding Arnd/Linus Walleij to see if they can tell us whether
> it should go or stay.

It should go. For all I can tell, this was the result of Lee Jones
doing major cleanups to the ux500 platform for this merge window
in parallel with the crypto driver getting added following the
older code pattern. The crypto patch had to be reworked for this
and apparently a hunk from the older version survived.

The entire file in which it was added is going to be removed
in one of the next kernel versions once we can boot all ux500 machines
using only device tree definitions, so it will be taken care of.

	Arnd

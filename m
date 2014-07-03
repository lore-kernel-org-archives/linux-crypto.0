From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: ux500: make interrupt mode plausible
Date: Thu, 03 Jul 2014 16:01:54 +0200
Message-ID: <6058264.NMWsAerSr1@wuerfel>
References: <13720857.JmA1VNKFj8@wuerfel> <20140703134400.GC14291@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	Fabio Baltieri <fabio.baltieri@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53286 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaGCOCA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 10:02:00 -0400
In-Reply-To: <20140703134400.GC14291@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 03 July 2014 21:44:00 Herbert Xu wrote:
> 
> > The bug has existed since the driver was first merged, and was
> > probably never detected because nobody tried to use interrupt mode.
> > It might make sense to backport this fix to stable kernels, depending
> > on how the crypto maintainers feel about that.
> 
> Patch applied.  I'm not going to push this to stable though until
> I see some more testing.  We can always push this later if needed.

Sounds good, thanks!

	Arnd

From: Andrew Morton <akpm@osdl.org>
Subject: Re: [-mm patch] CRYPTO_DEV_PADLOCK_AES must select CRYPTO_BLKCIPHER
Date: Sun, 20 Aug 2006 16:51:50 -0700
Message-ID: <20060820165150.bdb9e4cc.akpm@osdl.org>
References: <20060819220008.843d2f64.akpm@osdl.org>
	<20060820160928.GN7813@stusta.de>
	<20060820230415.GB31693@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:18129 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932109AbWHTXzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Aug 2006 19:55:12 -0400
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <20060820230415.GB31693@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 21 Aug 2006 09:04:15 +1000
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > --- linux-2.6.18-rc4-mm2/drivers/crypto/Kconfig.old	2006-08-20 17:28:46.000000000 +0200
> > +++ linux-2.6.18-rc4-mm2/drivers/crypto/Kconfig	2006-08-20 17:44:56.000000000 +0200
> > @@ -16,6 +16,7 @@
> >  config CRYPTO_DEV_PADLOCK_AES
> >  	bool "Support for AES in VIA PadLock"
> >  	depends on CRYPTO_DEV_PADLOCK
> > +	select CRYPTO_BLKCIPHER
> >  	default y
> >  	help
> >  	  Use VIA PadLock for AES algorithm.
> 
> Andrew, there is definitely something screwed up.

Things are a bit messy at present - some git trees are based off Greg's
tree and some are based off Linus's and git is pretty hopeless at pulling
usable diffs in these complex situations.

So yes, it's quite possible that the above is a merging problem.

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Wed, 24 Sep 2008 11:01:16 +0800
Message-ID: <20080924030116.GA4159@gondor.apana.org.au>
References: <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de> <20080923181840.GA24982@2ka.mipt.ru> <20080923.145515.34843004.davem@davemloft.net> <20080924025308.GA27398@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, max@psycast.de,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44379 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751467AbYIXDBc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 23:01:32 -0400
Content-Disposition: inline
In-Reply-To: <20080924025308.GA27398@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 24, 2008 at 06:53:08AM +0400, Evgeniy Polyakov wrote:
>
> Maybe, we need to check, since allocation of multiple smaller pages from
> 4 gb area, copy data between them, hardware crypto, backward copy and
> page freeing can be slower than software crypto. Although we can
> preallocate buffers for several common sizes, although this will not
> help dm-crypto which can submit up to 31 pages in single request on top
> of ext3 in the common case.

IPsec is going to be lowmem most of the time.  So you could
allocate a software backup similar to what padlock-sha does
and use that within hifn if you get a highmem request.

Of course not registering it works for me too.  I don't think
we need to lose too much sleep over people who can afford this
much memory but still insists on 32-bit.  They can afford to
hire a kernel engineer to fix this :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

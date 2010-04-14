From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 14 Apr 2010 14:44:23 +0800
Message-ID: <20100414064423.GA20555@gondor.apana.org.au>
References: <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il> <4BC48C08.7040608@nokia.com> <20100414004453.GA18044@gondor.apana.org.au> <4BC562BB.4040800@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:45403 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753365Ab0DNGod (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Apr 2010 02:44:33 -0400
Content-Disposition: inline
In-Reply-To: <4BC562BB.4040800@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 14, 2010 at 09:37:47AM +0300, Dmitry Kasatkin wrote:
>
> Like just with import/export.
> Problems for hw:
>
> 1. To have a good performance with DMA we need to have large buffer.
>     Not just 64 bytes block. state becomes large

Sure.  But it shouldn't be up to the driver to merge operations.
Higher layers (either the end-user or the crypto API) should perform
merging.

We don't put request merging into storage drivers for a reason.

> 2. supporting concurrent requests means switching HW state and it takes  
> a time.

Well that's just the way it is.  I'm not saying that it's going
to occur frequently, but if it does, you need to support it.

> All that burden significantly slowdown hw acceleration and increase CPU  
> load.
>
> I guess my points are understandable.

I understand your concerns, but these are really limitations
common to all off-chip acceleration.  If you have to write drivers
for them, then you'll have to deal with these issues.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

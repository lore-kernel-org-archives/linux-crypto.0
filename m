From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Mon, 19 Apr 2010 21:27:39 +0800
Message-ID: <20100419132739.GB11498@gondor.apana.org.au>
References: <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il> <4BC48C08.7040608@nokia.com> <20100414004453.GA18044@gondor.apana.org.au> <4BC562BB.4040800@nokia.com> <20100414064423.GA20555@gondor.apana.org.au> <4BC565EA.2090109@nokia.com> <20100414065500.GA20713@gondor.apana.org.au> <4BC81565.8040808@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:50968 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754787Ab0DSN1m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Apr 2010 09:27:42 -0400
Content-Disposition: inline
In-Reply-To: <4BC81565.8040808@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 16, 2010 at 10:44:37AM +0300, Dmitry Kasatkin wrote:
> Hi,
>
> crypto_ahash_update()
> crypto_ahash_dinup()
> crypto_ahash_final()
>
> obviously might need to return -EINPROGRESS
>
> but can
> crypto_ahash_init(req)
>
> be synchronous?
>
> Or it could also return EINPROGRESS, though not sense.

crypto_ahash_init is allowed to return EINPROGRESS, but it certainly
doesn't *have* to be asynchronous.  Most hardware implementations
should be able to do it synchronously by duplicating a precomputed
initial state.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

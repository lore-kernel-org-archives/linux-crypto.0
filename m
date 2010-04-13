From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 20:10:04 +0800
Message-ID: <20100413121004.GB10822@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:48184 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567Ab0DMMKO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 08:10:14 -0400
Content-Disposition: inline
In-Reply-To: <4BC44446.2010405@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 13, 2010 at 01:15:34PM +0300, Dmitry Kasatkin wrote:
>
> But anyway hmac does not support ahash now. right?
> So the only way currently is to add to the driver.

No the only way is to add an ahash version of hmac.

Anyway, the fact that you can't easily implement import/export
is not just a question of supporting hmac.  It is in fact a sign
that your driver breaks the crypto API.

The fundamental requirement for the ahash interface is that you
must be able to launch multiple operations, which means that all
state must be stored in the request and not held in hardware
(except as a cache).

IOW, you must be able to support

	crypto_ahash_update(&reqa);

	...

	crypto_ahash_update(&reqb);

	...

	ahash_request_set_crypt(&reqa, ...);
	crypto_ahash_finup(&reqa);

	...

	ahash_request_set_crypt(&reqb, ...);
	crypto_ahash_finup(&reqb);

AFAICS your driver cannot do this correctly in its current form.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

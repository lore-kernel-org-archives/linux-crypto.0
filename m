From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 20:02:43 +0800
Message-ID: <20100413120243.GA10822@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:52071 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932Ab0DMMCw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 08:02:52 -0400
Content-Disposition: inline
In-Reply-To: <4BC443DB.1030602@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 13, 2010 at 01:13:47PM +0300, Dmitry Kasatkin wrote:
>
> As I can see from the patch initial vectors calculated with SW shash
> Rest is done in hw, basically sha1.

Ideally that code shouldn't be duplicated either, but honestly
that doesn't matter when it comes to whether the hardware can
do HMAC directly.

You only compute the IVs once for each key, so whether it's done
in software or hardware doesn't matter.

> The same can be done with omap driver.
> Just in addition to finalize as done in hmac_final().

If you do hmac_final in software, then this is no longer a hw
HMAC implementation and we should instead implement an ahash
version of hmac.

The difference here is that ipad/opad is computed only once for
a key, while final happens many times over the lifetime of that
key.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

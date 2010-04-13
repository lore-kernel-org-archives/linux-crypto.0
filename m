From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 22:45:27 +0800
Message-ID: <20100413144527.GC12695@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:52439 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751752Ab0DMOpf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 10:45:35 -0400
Content-Disposition: inline
In-Reply-To: <4BC46ADB.3000501@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 13, 2010 at 04:00:11PM +0300, Dmitry Kasatkin wrote:
>
> I would also:
> 1. calc hash(opad) using sw, export
> 2. hash(ipad =E2=88=A5 message) using hw
> 3. then import and finup hash from step 1 with results of step 2 (usi=
ng sw)

Step 3 is the problem.  If you perform step 3 in software then
there is no point in exporting a hmac(sha1) object.

We should instead add ahash support to hmac and use that.

Cheers,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

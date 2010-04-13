From: Uri Simchoni <uri@jdland.co.il>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 18:16:49 +0300
Message-ID: <4BC48AE1.4010103@jdland.co.il>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:35283 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0DMPRH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 11:17:07 -0400
In-Reply-To: <20100413144527.GC12695@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Doing step 3 using sw is probably faster than by hw (because it's short=
 and avoid all the hw setup), so the suggested approach is probably fas=
ter than generic async hmac.

On 4/13/2010 5:45 PM, Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 04:00:11PM +0300, Dmitry Kasatkin wrote:
>>
>> I would also:
>> 1. calc hash(opad) using sw, export
>> 2. hash(ipad =E2=88=A5 message) using hw
>> 3. then import and finup hash from step 1 with results of step 2 (us=
ing sw)
>=20
> Step 3 is the problem.  If you perform step 3 in software then
> there is no point in exporting a hmac(sha1) object.
>=20
> We should instead add ahash support to hmac and use that.
>=20
> Cheers,

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

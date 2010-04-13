From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 16:00:11 +0300
Message-ID: <4BC46ADB.3000501@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41726 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DMNAv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 09:00:51 -0400
In-Reply-To: <20100413120243.GA10822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13/04/10 15:02, ext Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 01:13:47PM +0300, Dmitry Kasatkin wrote:
>   =20
>> As I can see from the patch initial vectors calculated with SW shash
>> Rest is done in hw, basically sha1.
>>     =20
> Ideally that code shouldn't be duplicated either, but honestly
> that doesn't matter when it comes to whether the hardware can
> do HMAC directly.
>
> You only compute the IVs once for each key, so whether it's done
> in software or hardware doesn't matter.
>
>   =20
>> The same can be done with omap driver.
>> Just in addition to finalize as done in hmac_final().
>>     =20
> If you do hmac_final in software, then this is no longer a hw
> HMAC implementation and we should instead implement an ahash
> version of hmac.
>
> The difference here is that ipad/opad is computed only once for
> a key, while final happens many times over the lifetime of that
> key.
>
>   =20
I do not see your point.
As stated by Uri Simchoni, hw hmac(sha1) in mv_cesa case requires sw=20
sha1 driver.
Initial vectors are calculated per key by sw.
So it is no longer hw HMAC implementation.

I just want to understand what make it defferent from mv_cesa if in=20
omap-sham case

hash(opad =E2=88=A5 hash(ipad =E2=88=A5 message))

I would also:
1. calc hash(opad) using sw, export
2. hash(ipad =E2=88=A5 message) using hw
3. then import and finup hash from step 1 with results of step 2 (using=
 sw)

What makes it different from mc_cesa case?


> Cheers,
>   =20
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

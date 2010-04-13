From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 18:21:44 +0300
Message-ID: <4BC48C08.7040608@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Uri Simchoni <uri@jdland.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51996 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0DMPWV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 11:22:21 -0400
In-Reply-To: <4BC48AE1.4010103@jdland.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 13/04/10 18:16, ext Uri Simchoni wrote:
> Doing step 3 using sw is probably faster than by hw (because it's sho=
rt and avoid all the hw setup), so the suggested approach is probably f=
aster than generic async hmac.
>
>   =20
Yes. that is exactly what happens in hw - it is much slower.
And I do not see any problems as well with finishing it with sw.


> On 4/13/2010 5:45 PM, Herbert Xu wrote:
>   =20
>> On Tue, Apr 13, 2010 at 04:00:11PM +0300, Dmitry Kasatkin wrote:
>>     =20
>>> I would also:
>>> 1. calc hash(opad) using sw, export
>>> 2. hash(ipad =E2=88=A5 message) using hw
>>> 3. then import and finup hash from step 1 with results of step 2 (u=
sing sw)
>>>       =20
>> Step 3 is the problem.  If you perform step 3 in software then
>> there is no point in exporting a hmac(sha1) object.
>>
>> We should instead add ahash support to hmac and use that.
>>
>> Cheers,
>>     =20
>   =20
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

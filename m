From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 14 Apr 2010 08:44:53 +0800
Message-ID: <20100414004453.GA18044@gondor.apana.org.au>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il> <4BC48C08.7040608@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:44087 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883Ab0DNApF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 20:45:05 -0400
Content-Disposition: inline
In-Reply-To: <4BC48C08.7040608@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 13, 2010 at 06:21:44PM +0300, Dmitry Kasatkin wrote:
>
>
> On 13/04/10 18:16, ext Uri Simchoni wrote:
>> Doing step 3 using sw is probably faster than by hw (because it's short and avoid all the hw setup), so the suggested approach is probably faster than generic async hmac.
>>
>>    
> Yes. that is exactly what happens in hw - it is much slower.
> And I do not see any problems as well with finishing it with sw.

I never said that you can't do it in software.  I just don't
want every driver to write its own copy of hmac in software.

If you're going to do it in software, then let's make an ahash
version of hmac.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

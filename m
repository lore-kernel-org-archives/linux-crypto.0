From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 14 Apr 2010 09:37:47 +0300
Message-ID: <4BC562BB.4040800@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il> <4BC48C08.7040608@nokia.com> <20100414004453.GA18044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51931 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DNGiY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Apr 2010 02:38:24 -0400
In-Reply-To: <20100414004453.GA18044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 14/04/10 03:44, ext Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 06:21:44PM +0300, Dmitry Kasatkin wrote:
>    
>>
>> On 13/04/10 18:16, ext Uri Simchoni wrote:
>>      
>>> Doing step 3 using sw is probably faster than by hw (because it's short and avoid all the hw setup), so the suggested approach is probably faster than generic async hmac.
>>>
>>>
>>>        
>> Yes. that is exactly what happens in hw - it is much slower.
>> And I do not see any problems as well with finishing it with sw.
>>      
> I never said that you can't do it in software.  I just don't
> want every driver to write its own copy of hmac in software.
>
>    
I understand that it is better to have more "generic" approach and not 
duplicate that.
I am not objecting that.

The key point is that we use HW accelerators to get speedup, release CPU 
for something else and reduce power consumption (if possible and 
specific hw does it more energy efficiently).

Base on above facts hw drivers need to make certain optimization.
And that optimization often does not fit well to the "generic" way.

Like just with import/export.
Problems for hw:

1. To have a good performance with DMA we need to have large buffer.
     Not just 64 bytes block. state becomes large

2. supporting concurrent requests means switching HW state and it takes 
a time.

All that burden significantly slowdown hw acceleration and increase CPU 
load.

I guess my points are understandable.

thanks
> If you're going to do it in software, then let's make an ahash
> version of hmac.
>
> Cheers,
>    

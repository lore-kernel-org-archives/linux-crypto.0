From: Uri Simchoni <uri@jdland.co.il>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 15:00:51 +0300
Message-ID: <4BC45CF3.8020906@jdland.co.il>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:58122 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0DMMBL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 08:01:11 -0400
In-Reply-To: <4BC44446.2010405@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Marvell CESA needs some software assistance in doing HMAC - the inner and outer blocks need
to be prepared and hashed (partial hash). The hash results are fed into the hardware and the hardware uses it
as IVs and does the two hash operations. So in effect the HW hmac(sha1) driver needs software sha1 driver.

Note, however, that the above calculation is not per-request, it is per setkey operation. The IVs are stored in the tfm.

I hope that clears things with respect to the mv_cesa driver.

On 4/13/2010 1:15 PM, Dmitry Kasatkin wrote:
> Btw.
> 
> But anyway hmac does not support ahash now. right?
> So the only way currently is to add to the driver.
> 
> 
> On 13/04/10 13:03, ext Herbert Xu wrote:
>> On Tue, Apr 13, 2010 at 12:39:55PM +0300, Dmitry Kasatkin wrote:
>>   
>>> btw. patch to mv_cesa is actually adding hmac to the driver.
>>> How would you comment that?
>>>      
>> AFAICS it's doing HMAC in hardware.  Uri, is that not the case?
>>
>>   
>>> The same way could be also used here.
>>>      
>> If your hardware supports HMAC that would definitely be the way
>> to go.
>>
>> Cheers,
>>    


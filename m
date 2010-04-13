From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 12:39:55 +0300
Message-ID: <4BC43BEB.90901@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21762 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0DMJki (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 05:40:38 -0400
In-Reply-To: <20100413085921.GA8988@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

btw. patch to mv_cesa is actually adding hmac to the driver.
How would you comment that?

The same way could be also used here.
I could calc final output with sw.

Any comments?

- Dmitry



On 13/04/10 11:59, ext Herbert Xu wrote:
> On Thu, Apr 08, 2010 at 06:35:33PM +0200, Dmitry.Kasatkin@nokia.com wrote:
>    
>> Sha1 only is also very useful. We calcluate hashes of all binaries for integrity verification. We do not need hmac there.
>>      
> But do we do that in the Linux kernel?
>
> Of course it would be useful if we had a user-space API, but
> that is still on the TODO list.
>
>    
>> But in general it is possible do add algo hmac(sha1) to the driver and implement it internally without import/export.
>>      
> No we don't want to add hmac to every single driver that does
> sha1.  So this would not be a good precedent.  In any case,
> some form of import/export must be possible (maybe not in our
> current format) because our API requires the ability to perform
> a partial update and postpone the finalisation indefinitely.
>
> If you couldn't import/export, that would imply that the hardware
> must have infinite memory.
>
>    
>> I have to check on documentation publicity.
>>      
> Thanks!
>    

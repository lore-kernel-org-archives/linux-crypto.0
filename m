From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 13:15:34 +0300
Message-ID: <4BC44446.2010405@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53740 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0DMKQh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 06:16:37 -0400
In-Reply-To: <20100413100308.GA9600@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Btw.

But anyway hmac does not support ahash now. right?
So the only way currently is to add to the driver.


On 13/04/10 13:03, ext Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 12:39:55PM +0300, Dmitry Kasatkin wrote:
>    
>> btw. patch to mv_cesa is actually adding hmac to the driver.
>> How would you comment that?
>>      
> AFAICS it's doing HMAC in hardware.  Uri, is that not the case?
>
>    
>> The same way could be also used here.
>>      
> If your hardware supports HMAC that would definitely be the way
> to go.
>
> Cheers,
>    

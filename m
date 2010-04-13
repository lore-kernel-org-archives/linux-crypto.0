From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 18:48:42 +0300
Message-ID: <4BC4925A.4010109@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com> <20100413121004.GB10822@gondor.apana.org.au> <4BC47543.1020508@nokia.com> <20100413144843.GD12695@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56367 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0DMPs5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 11:48:57 -0400
In-Reply-To: <20100413144843.GD12695@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


About import/export.

The problem with HW is that it always handles 64 byte blocks except last 
one.
So until finup/final it is not known if it is the last data. So some 
buffer is kept in context.

With DMA it is very inefficient to have small buffer.
I use page 4k for that.
So after a certain update there is a data in the cache.

Doing export means that we need to get out intermediate hash and that 
buffer.

Any suggestion?

Thanks


On 13/04/10 17:48, ext Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 04:44:35PM +0300, Dmitry Kasatkin wrote:
>    
>> Well it can... if reqa occupied hw all other requests will fallback to
>> sw sha1.
>>      
> That is unacceptable.  If we had a user-space API that would
> mean a single request can tie up the hardware indefinitely.
>
> If your hardware is not able to produce a non-finalised hash,
> then you should only do finup/final in hardware, and use a software
> fallback to implement the rest.
>
>    
> If your hardware is also not able to accept an initial state,
> then the only thing you can implement is digest.  The rest would
> have to fall back to software.
>
> Cheers,
>    

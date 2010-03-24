From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 24 Mar 2010 16:51:09 +0200
Message-ID: <4BAA26DD.3000007@nokia.com>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com> <20100323113239.GA29837@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21908 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0CXPCu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Mar 2010 11:02:50 -0400
In-Reply-To: <20100323113239.GA29837@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 23/03/10 13:32, ext Herbert Xu wrote:
> On Wed, Mar 17, 2010 at 03:12:49PM +0200, Dmitry Kasatkin wrote:
>    
>> Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
>> was not ported to new crypto APIs and removed from the source tree.
>>
>> This driver implements async and sync crypto API.
>>
>> It still contains pr_debug() for debugging purpose.
>> Will be remove for integration.
>>
>> Dmitry Kasatkin (2):
>>    sec: omap sha1&  md5 driver
>>    sec: Makefile/Kconfig update for omap sha1 md5 driver
>>      
> It looks good to me as far as the Crypto API is concerned.
>
> My only question is what's your plan with respect to HMAC? If
> you're going to do it in hardware then it's fine as it is.
>
> Otherwise you need to implement export/import and we also need
> to add ahash support to hmac.c.
>
> Thanks,
>    

Hello.

Interesting case with hmac.

     return crypto_shash_init(&desc.shash) ?:
            crypto_shash_update(&desc.shash, ipad, bs) ?:
            crypto_shash_export(&desc.shash, ipad) ?:
            crypto_shash_init(&desc.shash) ?:
            crypto_shash_update(&desc.shash, opad, bs) ?:
            crypto_shash_export(&desc.shash, opad);

Basically it does not call final.
Then call init again.

hw has certain limitation that it requires to process last block with 
some bit set.
WHen update is called there is no possibility to know that no more 
update() will come.
So possible last block is stored and then hashed out from the final.

I see that above code will not work with the driver.
I wonder how intermediate export/import could be done with omap hw.

But if it's not possible, then why not to have hmac(sha1) as just sw.
Anyway hmac should not process as huge amount of data as hash itself.

What is your opinion/advice?

Thank you
- Dmitry



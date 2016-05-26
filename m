From: Denis B <begun.denis@gmail.com>
Subject: Re: SKB dst field is NULL when AEAD request complete() is called
Date: Thu, 26 May 2016 13:04:10 +0300
Message-ID: <CADREXspWNf0JVJhv-hhTEi9DCBhm+X_aK1-gPZTJ2Mvf1j9u9g@mail.gmail.com>
References: <CADREXsqviDO5RvN87LmDOQU3By_y8YPaGbcRxDpNW4Eyf62_6g@mail.gmail.com>
	<20160526092902.GA1740@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35347 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbcEZKEM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 06:04:12 -0400
Received: by mail-vk0-f42.google.com with SMTP id f66so96024846vkh.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2016 03:04:11 -0700 (PDT)
In-Reply-To: <20160526092902.GA1740@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The bug was: return value of my driver's encrypt() function should
have been -EINPROGRESS to support asynchronous operation.

Thanks.

On Thu, May 26, 2016 at 12:29 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Denis B <begun.denis@gmail.com> wrote:
>> Working with kernel 3.12.14, in AEAD mode, I register my crypto driver
>> and the givencrypt() method in the driver gets called when I send
>> IPSec traffic. I store the request, and later call its complete()
>> method from a work queue. There is no actual encryption happening at
>> the moment, I'm just testing flow. As stated, the complete() call
>> stumbles upon a NULL pointer exception in xfrm_output_resume() because
>> skb_dst(skb) is NULL. When I receive the request in givencrypt(), dst
>> is not null in the SKB.
>>
>> Why would the framework meddle with the SKB? Has anyone experienced
>> anything similar?
>
> This is probably the result of some kind of a bug in your driver.
>
> If however you're sure that your driver is doing the right thing,
> then the bug would be in the network stack.  You should discuss
> networking issues on netdev@vger.kernel.org.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

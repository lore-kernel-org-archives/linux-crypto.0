From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 18:31:11 +1000
Message-ID: <E1HrVCZ-00078J-00@gondolin.me.apana.org.au>
References: <20070523100244.GA6079@Chamillionaire.breakpoint.cc>
Cc: johnpol@2ka.mipt.ru, linux-crypto@vger.kernel.org
To: linux-crypto@ml.breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3053 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751775AbXEYIbU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 04:31:20 -0400
In-Reply-To: <20070523100244.GA6079@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
 
>>And, btw, do not use mutex in encryption path, it is not supposed to
>>sleep in ipsec.
> I am aware of that but again: I might be totally wrong. Herbert
> introduced a async API. My understanding was that he wants to queue
> encrypt+decrypt (not setkey) and process it later in a dedicated thread.
> On the other hand: what is async when still evrything happny sync.
> He's tcrypt code queues a request, and calls

Evgeniy is absolutely right here.

While it is true that the whole point of async is so that you can go
away and do something else while the crypto operation is in place,
it does not mean that the crypto driver itself can sleep when handling
a request.

For example, the caller might be IPsec which runs in an unsleepable BH
context.  It wants to queue the packet for processing and have the
crypto layer call it back when it's done.  There is no explicit sleeping
involved here.

So if you need locking you should use something like a spin lock.

> wait_for_completion_interruptible() so he does sleep and waits until the
> cipher finishes (in a seperate kthread). However this is only the case
> if crypto_ablkcipher_XXX() returns with -EINPROGRESS or -EBUSY. In case

Of course the caller can sleep if it is safe.  tcrypt always runs in
process context which is why it can afford to sleep here.  IPsec on
the other hand would not be able to do that.

>>HIFN supports at least 12 different ciphers/mode (3des, des and aes,
>>each one with 4 modes), so it is not a good idea to put them all into
>>separated structures, so I rised a question about it.
> This might be cool.

I'm all for helpers to reduce typing here :)

However, we really do need separate objects for each block cipher
since from the crypto API's point of view they're totally unrelated.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Wed, 23 May 2007 16:30:21 +0400
Message-ID: <20070523123020.GA19175@2ka.mipt.ru>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070522151919.GB32493@Chamillionaire.breakpoint.cc> <20070523080354.GA19665@2ka.mipt.ru> <20070523100244.GA6079@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42673 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbXEWMah (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 May 2007 08:30:37 -0400
Received: from 2ka.mipt.ru (localhost [127.0.0.1])
	by 2ka.mipt.ru (8.13.8/8.13.8) with ESMTP id l4NCUL8c002529
	for <linux-crypto@vger.kernel.org>; Wed, 23 May 2007 16:30:23 +0400
Received: (from johnpol@localhost)
	by 2ka.mipt.ru (8.13.8/8.12.1/Submit) id l4NCULg8002490
	for linux-crypto@vger.kernel.org; Wed, 23 May 2007 16:30:21 +0400
Content-Disposition: inline
In-Reply-To: <20070523100244.GA6079@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi, Sebastian.

On Wed, May 23, 2007 at 12:02:44PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> It is also possible that I interpreted Herbert's code the wrong
> way. Let me comment the obvious part of the skeleton code which I thing
> you overlooked (If you didn't than I didn't catch up with in the first
> place or missed the goal of the async API).
> 
> Register 12 struct crypto_alg, each with unique functions for
> aes|3des|.. + ecb|cbc|.. + encrypto|decrypt (I agree with you, that you
> prefer 4 instead of 12 since most of the attributes are the same).
> Now, algo_decrypt_ecb_async() is doing just:
>   return enqueue_request(req, algo_request_decrypt);

That is what I want to avoid.

> consider algo_request_decrypt as request_aes_decrypt_ecb. This function
> (algo_request_decrypt) only calls blkcipher_crypt(...., HW_DECRYPT_ECB)
> which calls the HW directly. You see that way what is requested
> (AES+ECB+ENCRYPT).
> 
> Instead of calling a function pointer, you could shorten the code by
> enqueue_request(..., HW_DECRYPT_ECB) directly and call blkcipher_crypt()
> from process_requests_thread() with the correct operation type. However
> the encrypt/decrypt process happens in a seperate kthread.

My point is not to introduce a lot of structures and functions, which
are essentially (read: exactly) the same, but instead get crypto processing 
mode from the tfm/whatever structure. Your code only registers ecb, but to 
fully support crypto capabilities for given device the same structure (but 
with different functions and template strings) must be registered for every
device for every cipher/digest and every mode and probably even for
every key size, but I'm not sure about the latter though.
That is what I want to avoid.

> I took a deeper look on your code and it seems to me, that you might
> still use the sync API. Your .cra_type is still crypto_blkcipher_type.
> Your code might actually be broken because you set up a struct
> ablkcipher_alg but the crypto might threat it as struct blkcipher_alg.
> Check /proc/crypto, your supported keysizes should be wrong.

Thanks for pointing, that must be ablkcpiher_type, I've fixed that typo.

> >And, btw, do not use mutex in encryption path, it is not supposed to
> >sleep in ipsec.
> I am aware of that but again: I might be totally wrong. Herbert
> introduced a async API. My understanding was that he wants to queue
> encrypt+decrypt (not setkey) and process it later in a dedicated thread.
> On the other hand: what is async when still evrything happny sync.

Ah, then your code only works with dedicated thread, which is not needed
for true hardware, which works in interrupt mode, since register setup
is quite fast compared to rescheduling to dedicated thread, so it is not
needed, and instead registers setup is performed in ->encrypt/->decrypt
callbacks and completion function is called (with disabled interrupts)
from interrupt handler.

> *I* have to sleep while handling a crypto request over to the hardware.

No, you have not. Check acrypto sources and how it is implemented for
example for hifn driver and ipsec stack.

> My understanding of Herbert's async crypto API was a blessing :) In case

I'm about to disagree, last time we talked with Herbert about async 
cryptoapi design we failed to find a solution, suitable for both points of 
view. :-)

> of IPsec I am actually thinking how to fix this and not break anything
> (in terms of performance and hacky code).

In case of async IPsec you might check acrypto sources, which have async
ipsec support quite for a while, but it is hacky indeed - I needed to
heavily change ipsec processing code both in input and output to make it
possible to work without any sleeps and with 'interrupted' crypto processing. 
It works not slower than native code, although I only did esp4.

> Sebastian

-- 
	Evgeniy Polyakov

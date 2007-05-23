From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Wed, 23 May 2007 12:02:44 +0200
Message-ID: <20070523100244.GA6079@Chamillionaire.breakpoint.cc>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070522151919.GB32493@Chamillionaire.breakpoint.cc> <20070523080354.GA19665@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52647 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765020AbXEWKCq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 May 2007 06:02:46 -0400
Content-Disposition: inline
In-Reply-To: <20070523080354.GA19665@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-05-23 12:03:54 [+0400]:

>On Tue, May 22, 2007 at 05:19:19PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
>> * Evgeniy Polyakov | 2007-05-22 16:58:29 [+0400]:
>> 
>> >Current driver only supports AES ECB encrypt/decrypt, since I do not 
>> >know how to detect operation mode in runtime (a question).
>> Take a look on my skeleton driver (posted just a few seconds ago). It
>> should solve your problem here.
>
>It does not - your code only supposed to work with ecb, since it is what
>was requested during initialization time. This new scheme with templates
>helps alot for ciphers/crypto modes which do not support several
>templates, so I used old scheme with 'cipher' only template, not
>'ecb(cipher)', 'cbc(cipher)' and so on.
Maybe I missed the point. I am confused with your mutex comment anyway
(but later mode).
It is also possible that I interpreted Herbert's code the wrong
way. Let me comment the obvious part of the skeleton code which I thing
you overlooked (If you didn't than I didn't catch up with in the first
place or missed the goal of the async API).

Register 12 struct crypto_alg, each with unique functions for
aes|3des|.. + ecb|cbc|.. + encrypto|decrypt (I agree with you, that you
prefer 4 instead of 12 since most of the attributes are the same).
Now, algo_decrypt_ecb_async() is doing just:
  return enqueue_request(req, algo_request_decrypt);

consider algo_request_decrypt as request_aes_decrypt_ecb. This function
(algo_request_decrypt) only calls blkcipher_crypt(...., HW_DECRYPT_ECB)
which calls the HW directly. You see that way what is requested
(AES+ECB+ENCRYPT).

Instead of calling a function pointer, you could shorten the code by
enqueue_request(..., HW_DECRYPT_ECB) directly and call blkcipher_crypt()
from process_requests_thread() with the correct operation type. However
the encrypt/decrypt process happens in a seperate kthread.

I took a deeper look on your code and it seems to me, that you might
still use the sync API. Your .cra_type is still crypto_blkcipher_type.
Your code might actually be broken because you set up a struct
ablkcipher_alg but the crypto might threat it as struct blkcipher_alg.
Check /proc/crypto, your supported keysizes should be wrong.

>And, btw, do not use mutex in encryption path, it is not supposed to
>sleep in ipsec.
I am aware of that but again: I might be totally wrong. Herbert
introduced a async API. My understanding was that he wants to queue
encrypt+decrypt (not setkey) and process it later in a dedicated thread.
On the other hand: what is async when still evrything happny sync.
He's tcrypt code queues a request, and calls
wait_for_completion_interruptible() so he does sleep and waits until the
cipher finishes (in a seperate kthread). However this is only the case
if crypto_ablkcipher_XXX() returns with -EINPROGRESS or -EBUSY. In case
of 0 he expects a synchron processing. I assume in case of -EBUSY, the
caller has to put the request once again in the queue (at a later time,
probably after a request completed. This looks little dodgy to me,
because it may be the first request).
However, if the caller is requesting a async algo, he knows that he
might go to bed in the meantime.
*I* have to sleep while handling a crypto request over to the hardware.
My understanding of Herbert's async crypto API was a blessing :) In case
of IPsec I am actually thinking how to fix this and not break anything
(in terms of performance and hacky code).

>HIFN supports at least 12 different ciphers/mode (3des, des and aes,
>each one with 4 modes), so it is not a good idea to put them all into
>separated structures, so I rised a question about it.
This might be cool.

>
>> Sebastian
>
>-- 
>	Evgeniy Polyakov
Sebastian

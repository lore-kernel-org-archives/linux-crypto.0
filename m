From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v8 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Sat, 10 Jun 2017 10:33:28 +0200
Message-ID: <25395002.4o58NXqqVS@positron.chronox.de>
References: <1534260.eLzG41Ydnz@positron.chronox.de> <2934385.XAQy5ZyJXM@positron.chronox.de> <20170610031316.GA14206@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60140 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751844AbdFJIdb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 04:33:31 -0400
In-Reply-To: <20170610031316.GA14206@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 10. Juni 2017, 05:13:16 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, May 23, 2017 at 04:31:59PM +0200, Stephan Müller wrote:
> >  static void skcipher_sock_destruct(struct sock *sk)
> >  {
> >  
> >  	struct alg_sock *ask = alg_sk(sk);
> >  	struct skcipher_ctx *ctx = ask->private;
> > 
> > -	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(&ctx->req);
> > +	struct sock *psk = ask->parent;
> > +	struct alg_sock *pask = alg_sk(psk);
> > +	struct skcipher_tfm *skc = pask->private;
> > +	struct crypto_skcipher *tfm = skc->skcipher;
> > 
> > -	if (atomic_read(&ctx->inflight))
> > -		skcipher_wait(sk);
> > +	/* Suspend caller if AIO operations are in flight. */
> > +	wait_event_interruptible(skcipher_aio_finish_wait,
> > +				 (ctx->inflight == 0));
> 
> This doesn't look right.  If a signal comes in wouldn't you end
> up freeing live memory?

Right. Shouldn't we drop the ctx->inflight completely?

The code in the current patch set contains:

when an async operation is queued:

                sock_hold(sk);
                ctx->inflight++;

upon completion of the callback:

        __sock_put(sk);
        ctx->inflight--;

Thus, the socket is grabbed already. Hence, when dropping the inflight code 
including the wait queue entirely, I would think we are still save as we hold 
the socket.

Ciao
Stephan

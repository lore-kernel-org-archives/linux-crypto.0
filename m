From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Sat, 10 Jun 2017 11:13:16 +0800
Message-ID: <20170610031316.GA14206@gondor.apana.org.au>
References: <1534260.eLzG41Ydnz@positron.chronox.de>
 <2934385.XAQy5ZyJXM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:54302 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751685AbdFJDNi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2017 23:13:38 -0400
Content-Disposition: inline
In-Reply-To: <2934385.XAQy5ZyJXM@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 23, 2017 at 04:31:59PM +0200, Stephan Müller wrote:
>
>  static void skcipher_sock_destruct(struct sock *sk)
>  {
>  	struct alg_sock *ask = alg_sk(sk);
>  	struct skcipher_ctx *ctx = ask->private;
> -	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(&ctx->req);
> +	struct sock *psk = ask->parent;
> +	struct alg_sock *pask = alg_sk(psk);
> +	struct skcipher_tfm *skc = pask->private;
> +	struct crypto_skcipher *tfm = skc->skcipher;
>  
> -	if (atomic_read(&ctx->inflight))
> -		skcipher_wait(sk);
> +	/* Suspend caller if AIO operations are in flight. */
> +	wait_event_interruptible(skcipher_aio_finish_wait,
> +				 (ctx->inflight == 0));

This doesn't look right.  If a signal comes in wouldn't you end
up freeing live memory?

The existing code is crap too.  We should not be waiting in the
destructor in the first place.  The proper way to do it is to hold
a reference count on the socket.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

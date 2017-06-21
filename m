From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v9 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Wed, 21 Jun 2017 09:30:53 +0200
Message-ID: <4569323.iShbTmMGM5@positron.chronox.de>
References: <1529895.BiIeBiIAIs@positron.chronox.de> <2834834.Sa5QGNeBMP@positron.chronox.de> <20170620031042.GA17690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60328 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbdFUHaz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 03:30:55 -0400
In-Reply-To: <20170620031042.GA17690@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 20. Juni 2017, 05:10:42 CEST schrieb Herbert Xu:

Hi Herbert,

> > +		int err = _skcipher_recvmsg(sock, msg, ignored, flags);
> > +
> > +		/*
> > +		 * This error covers -EIOCBQUEUED which implies that we can
> > +		 * only handle one AIO request. If the caller wants to have
> > +		 * multiple AIO requests in parallel, he must make multiple
> > +		 * separate AIO calls.
> > +		 */
> > +		if (err < 0) {
> > +			ret = err;
> > +			goto out;
> 
> This looks like a semantic change.  The previous code would return
> the number of bytes already successfully processed in case of a
> subsequent error.  With your new code you will always return the
> error.

In the current code, the synchronous returns the processed bytes whereas the 
async case returns EIOCBQUEUED if this error occurs without returning the 
processed bytes.

Thus, would you like to change that code into

if (err < 0) {
	if (err == -EIOCBQUEUED)
		ret = err;

	goto out;
}

?


> 
> > @@ -724,10 +737,9 @@ static unsigned int skcipher_poll(struct file *file,
> > struct socket *sock,> 
> >  	struct sock *sk = sock->sk;
> >  	struct alg_sock *ask = alg_sk(sk);
> >  	struct skcipher_ctx *ctx = ask->private;
> > 
> > -	unsigned int mask;
> > +	unsigned int mask = 0;
> > 
> >  	sock_poll_wait(file, sk_sleep(sk), wait);
> > 
> > -	mask = 0;
> > 
> >  	if (ctx->used)
> >  	
> >  		mask |= POLLIN | POLLRDNORM;
> 
> Please remove this hunk as it has nothing to do with this patch.

Removed.

Thanks

Ciao
Stephan

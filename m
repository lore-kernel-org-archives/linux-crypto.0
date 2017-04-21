From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: algif_aead - Require setkey before accept(2)
Date: Fri, 21 Apr 2017 18:35:07 +0200
Message-ID: <2572320.UaipMWf1ob@positron.chronox.de>
References: <2439869.UPpkkqdW7f@positron.chronox.de> <20170421111127.GA13925@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59116 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161902AbdDUQn3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 12:43:29 -0400
In-Reply-To: <20170421111127.GA13925@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 21. April 2017, 13:11:27 CEST schrieb Herbert Xu:

Hi Herbert,

> On Mon, Apr 10, 2017 at 01:59:21PM +0200, Stephan Müller wrote:
> > @@ -757,12 +887,14 @@ static void aead_sock_destruct(struct sock *sk)
> > 
> >  	af_alg_release_parent(sk);
> >  
> >  }
> > 
> > -static int aead_accept_parent(void *private, struct sock *sk)
> > +static int aead_accept_parent_nokey(void *private, struct sock *sk)
> > 
> >  {
> >  
> >  	struct aead_ctx *ctx;
> >  	struct alg_sock *ask = alg_sk(sk);
> > 
> > -	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(private);
> > -	unsigned int ivlen = crypto_aead_ivsize(private);
> > +	struct aead_tfm *tfm = private;
> > +	struct crypto_aead *aead = tfm->aead;
> > +	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(aead);
> > +	unsigned int ivlen = crypto_aead_ivsize(aead);
> > 
> >  	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
> >  	if (!ctx)
> > 
> > @@ -789,7 +921,7 @@ static int aead_accept_parent(void *private, struct
> > sock *sk)> 
> >  	ask->private = ctx;
> > 
> > -	aead_request_set_tfm(&ctx->aead_req, private);
> > +	aead_request_set_tfm(&ctx->aead_req, aead);
> > 
> >  	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> >  	
> >  				  af_alg_complete, &ctx->completion);
> 
> Please don't mix unrelated cleanups like this with the real change.
>  It makes reviewing harder than necessary.
> 

After checking again, IMHO that is no unreleated cleanup or even a cleanup at 
all.

void *private used to be struct crypto_aead and is now struct aead_tfm. struct 
crypto_aead is found in private->aead. Hence, the patch assigned private to 
tfm and then obtained the struct crypto_aead pointer. As this was not 
necessary before, it is a required extension IMHO.

Ciao
Stephan

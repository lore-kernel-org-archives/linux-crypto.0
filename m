From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 4/4] crypto: add CRYPTO_TFM_REQ_PARALLEL flag
Date: Wed, 07 Feb 2018 16:43:10 +0100
Message-ID: <2396074.YQ3hgbV6mL@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <3051095.6v3pDGNVZ5@tauon.chronox.de> <20180207153911.00002ac6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Harsh Jain <harsh@chelsio.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59416 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754138AbeBGPnM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Feb 2018 10:43:12 -0500
In-Reply-To: <20180207153911.00002ac6@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 7. Februar 2018, 16:39:11 CET schrieb Jonathan Cameron:

Hi Jonathan,

> On Wed, 7 Feb 2018 13:48:32 +0100
> 
> Stephan Mueller <smueller@chronox.de> wrote:
> > Am Mittwoch, 7. Februar 2018, 08:44:04 CET schrieb Stephan Müller:
> > 
> > Hi,
> > 
> > > diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> > > index 3970ad7f6fd0..da010405eea0 100644
> > > --- a/crypto/algif_aead.c
> > > +++ b/crypto/algif_aead.c
> > > @@ -66,13 +66,22 @@ static int aead_sendmsg(struct socket *sock, struct
> > > msghdr *msg, size_t size) {
> > > 
> > >  	struct sock *sk = sock->sk;
> > >  	struct alg_sock *ask = alg_sk(sk);
> > > 
> > > +	struct af_alg_ctx *ctx = ask->private;
> > > 
> > >  	struct sock *psk = ask->parent;
> > >  	struct alg_sock *pask = alg_sk(psk);
> > >  	struct aead_tfm *aeadc = pask->private;
> > > 
> > > -	struct crypto_aead *tfm = aeadc->aead;
> > > -	unsigned int ivsize = crypto_aead_ivsize(tfm);
> > > +	struct crypto_aead *aead = aeadc->aead;
> > > +	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> > > +	unsigned int ivsize = crypto_aead_ivsize(aead);
> > > +	int ret = af_alg_sendmsg(sock, msg, size, ivsize);
> > > +
> > > +	if (ret < 0)
> > > +		return ret;
> > > 
> > > -	return af_alg_sendmsg(sock, msg, size, ivsize);
> > > +	if (ctx->iiv == ALG_IIV_USE)
> > 
> > This should be ALG_IIV_DISABLE of course.
> 
> You say that, but my initial reading was that the core
> was requesting that the driver do things in parallel
> irrespective of whether the driver thought it was safe.
> So I would think this was correct.
> 
> Definitely needs some documentation or a clearer name.

How about:

ALG_IV_SERIAL_PROCESSING (was ALG_IIV_DISABLE)
ALG_IV_PARALLEL_PROCESSING (was ALG_IIV_USE)

Ciao
Stephan

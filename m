Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:33205 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbeKWLsM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 06:48:12 -0500
Date: Fri, 23 Nov 2018 09:05:55 +0800
From: PanBian <bianpan2016@163.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: do not free algorithm before using
Message-ID: <20181123010555.GA83154@bp>
Reply-To: PanBian <bianpan2016@163.com>
References: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
 <20181122144441.tkfmrq3lzibq2g3y@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122144441.tkfmrq3lzibq2g3y@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 22, 2018 at 10:44:41PM +0800, Herbert Xu wrote:
> On Thu, Nov 22, 2018 at 06:00:16PM +0800, Pan Bian wrote:
> > In multiple functions, the algorithm fields are read after its reference
> > is dropped through crypto_mod_put. In this case, the algorithm memory
> > may be freed, resulting in use-after-free bugs. This patch delays the
> > put operation until the algorithm is never used.
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> 
> I don't think this patch is needed.
> 
> > ---
> >  crypto/cbc.c  | 6 ++++--
> >  crypto/cfb.c  | 6 ++++--
> >  crypto/pcbc.c | 6 ++++--
> >  3 files changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/crypto/cbc.c b/crypto/cbc.c
> > index b761b1f..dd5f332 100644
> > --- a/crypto/cbc.c
> > +++ b/crypto/cbc.c
> > @@ -140,9 +140,8 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
> >  	spawn = skcipher_instance_ctx(inst);
> >  	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
> >  				CRYPTO_ALG_TYPE_MASK);
> > -	crypto_mod_put(alg);
> >  	if (err)
> > -		goto err_free_inst;
> > +		goto err_put_alg;
> 
> We can safely drop the reference to the algorithm because the spawn
> is now meant to hold a reference to it.  As long as the spawn is
> alive so will the algorithm.

Thanks for your explanation! But I find that the function
crypto_init_spawn just lets spawn->alg point to the algorithm without 
increasing the reference count, i.e., alg->cra_refcnt. So I am confused
about how this can protect the algorithm from being freed. Maybe I
missed some key points. Could you please explain it in more details?

Thank you!

Best regards,
Pan Bian

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

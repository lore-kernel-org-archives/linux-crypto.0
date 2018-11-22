Return-Path: <SRS0=unN5=OB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42740 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbeKWBYZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Nov 2018 20:24:25 -0500
Date: Thu, 22 Nov 2018 22:44:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pan Bian <bianpan2016@163.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: do not free algorithm before using
Message-ID: <20181122144441.tkfmrq3lzibq2g3y@gondor.apana.org.au>
References: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 22, 2018 at 06:00:16PM +0800, Pan Bian wrote:
> In multiple functions, the algorithm fields are read after its reference
> is dropped through crypto_mod_put. In this case, the algorithm memory
> may be freed, resulting in use-after-free bugs. This patch delays the
> put operation until the algorithm is never used.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

I don't think this patch is needed.

> ---
>  crypto/cbc.c  | 6 ++++--
>  crypto/cfb.c  | 6 ++++--
>  crypto/pcbc.c | 6 ++++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/crypto/cbc.c b/crypto/cbc.c
> index b761b1f..dd5f332 100644
> --- a/crypto/cbc.c
> +++ b/crypto/cbc.c
> @@ -140,9 +140,8 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	spawn = skcipher_instance_ctx(inst);
>  	err = crypto_init_spawn(spawn, alg, skcipher_crypto_instance(inst),
>  				CRYPTO_ALG_TYPE_MASK);
> -	crypto_mod_put(alg);
>  	if (err)
> -		goto err_free_inst;
> +		goto err_put_alg;

We can safely drop the reference to the algorithm because the spawn
is now meant to hold a reference to it.  As long as the spawn is
alive so will the algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

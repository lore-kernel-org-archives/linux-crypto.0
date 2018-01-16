From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFT PATCH] crypto: ahash.c: Require export/import in ahash
Date: Tue, 16 Jan 2018 13:20:12 +0100
Message-ID: <2041364.q1qUov6bzd@amdc3058>
References: <CGME20180116103545eucas1p230af34b97f903f8dc7db5e634297f4f8@eucas1p2.samsung.com>
        <2a8e710f-9d1c-726b-3355-5d671e04cb68@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:17790 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbeAPMUR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 07:20:17 -0500
In-reply-to: <2a8e710f-9d1c-726b-3355-5d671e04cb68@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, January 16, 2018 11:35:44 AM Kamil Konieczny wrote:
> Export and import were optional in async hash. As drivers were rewritten,
> they become mandatory now, so correct init of ahash transformation.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
> Tested with crypto run-time self test on Odroid-U3 with Exynos 4412 CPU,
> with insmod s5p-sss.ko
> Please test with other crypto hash drivers.

Testing all existing ahash drivers is impossible so the code audit
should be done instead. From the quick look there are 3 hash drivers
left that still don't implement ->import/->export methods:

drivers/crypto/mxs-dcp.c
drivers/crypto/n2_core.c
drivers/crypto/ux500/hash/hash_core.c

It seems that after this patch they will OOPS, currently they now
return errors on ->import/->export attempts.

Please verify this and if necessary add dummy ->import/->export
implementations to affected drivers + contact their maintainers
(or authors if there is no maintainer assigned) to make them
aware of the problem (maybe some drivers should be removed now?).

>  crypto/ahash.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 3a35d67de7d9..7a8906d5af53 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -434,16 +434,6 @@ static int ahash_def_finup(struct ahash_request *req)
>  	return ahash_def_finup_finish1(req, err);
>  }
>  
> -static int ahash_no_export(struct ahash_request *req, void *out)
> -{
> -	return -ENOSYS;
> -}
> -
> -static int ahash_no_import(struct ahash_request *req, const void *in)
> -{
> -	return -ENOSYS;
> -}
> -
>  static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
>  {
>  	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
> @@ -451,8 +441,8 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
>  
>  	hash->setkey = ahash_nosetkey;
>  	hash->has_setkey = false;
> -	hash->export = ahash_no_export;
> -	hash->import = ahash_no_import;
> +	hash->export = alg->export;
> +	hash->import = alg->import;
>  
>  	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
>  		return crypto_init_shash_ops_async(tfm);
> @@ -467,10 +457,6 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
>  		hash->setkey = alg->setkey;
>  		hash->has_setkey = true;
>  	}
> -	if (alg->export)
> -		hash->export = alg->export;
> -	if (alg->import)
> -		hash->import = alg->import;
>  
>  	return 0;
>  }

Best regards,

From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2] crypto/ahash: Require export/import in ahash
Date: Thu, 18 Jan 2018 11:51:29 +0100
Message-ID: <9370ae6a-71fd-52b9-bfeb-af44956dea0e@partner.samsung.com>
References: <CGME20180116183836eucas1p18da0aa4ef25452069e8f64ef95950f53@eucas1p1.samsung.com>
        <af4995fb-4c68-d265-e78b-26e71402ae40@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43098 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755395AbeARKve (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 05:51:34 -0500
In-reply-to: <af4995fb-4c68-d265-e78b-26e71402ae40@partner.samsung.com>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 16.01.2018 19:38, Kamil Konieczny wrote:
> Export and import were optional in async hash. As most drivers were
> rewritten, they become mandatory now, so correct init of ahash
> transformation.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Please drop this patch, as there is one more driver needed for convert,
namely bfin_crc.c

I will also prepare this as patch series, to be sure that this patch is last

> ---
> This is resend of previous patch. As Bartlomiej Zolnierkiewicz pointed out,
> there are still three crypto drivers that didn't have export/import implemented:
> 
> drivers/crypto/mxs-dcp.c
> drivers/crypto/n2_core.c
> drivers/crypto/ux500/hash/hash_core.c
> 
> I have no documentation for them, so I sended patches with the behaviour taken
> from crypto framework, but maybe that hardware is capable of import/export,
> so proper implementation is possible. Unfortunatly, there is no maintainer
> for any of these files.
> 
> Please take this patch after these remainig drivers will be patched.
> 
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
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

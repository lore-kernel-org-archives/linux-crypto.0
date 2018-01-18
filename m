From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: n2_core: Add empty hash export and import
Date: Thu, 18 Jan 2018 18:53:41 +0100
Message-ID: <99689cdf-781f-9e24-7fcd-e810e30c57f2@partner.samsung.com>
References: <CGME20180116161844eucas1p27634e8860ca620b45224fa9efe491e2c@eucas1p2.samsung.com>
        <d46bfcf3-8c75-c7cd-ed6a-98ae8d9cdcaf@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <d46bfcf3-8c75-c7cd-ed6a-98ae8d9cdcaf@partner.samsung.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Please drop this as I will resend it as part of patchset.

On 16.01.2018 17:18, Kamil Konieczny wrote:
> Crypto framework will require async hash export/import, so add empty
> functions to prevent OOPS.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/n2_core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
> index 662e709812cc..80e9c842aad4 100644
> --- a/drivers/crypto/n2_core.c
> +++ b/drivers/crypto/n2_core.c
> @@ -359,6 +359,16 @@ static int n2_hash_async_finup(struct ahash_request *req)
>  	return crypto_ahash_finup(&rctx->fallback_req);
>  }
>  
> +static int n2_hash_async_noimport(struct ahash_request *req, const void *in)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int n2_hash_async_noexport(struct ahash_request *req, void *out)
> +{
> +	return -ENOSYS;
> +}
> +
>  static int n2_hash_cra_init(struct crypto_tfm *tfm)
>  {
>  	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
> @@ -1467,6 +1477,8 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
>  	ahash->final = n2_hash_async_final;
>  	ahash->finup = n2_hash_async_finup;
>  	ahash->digest = n2_hash_async_digest;
> +	ahash->export = n2_hash_async_noexport;
> +	ahash->import = n2_hash_async_noimport;
>  
>  	halg = &ahash->halg;
>  	halg->digestsize = tmpl->digest_size;
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

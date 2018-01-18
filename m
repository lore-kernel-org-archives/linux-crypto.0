From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: ux500/hash: Add empty export and import
Date: Thu, 18 Jan 2018 18:53:51 +0100
Message-ID: <0ded4dca-e253-5a88-3f23-a7e5764ca2cb@partner.samsung.com>
References: <CGME20180116163219eucas1p132fafc2db8cb9b3af1a1f22d8bf2fdaf@eucas1p1.samsung.com>
        <a83d9022-b8bc-ea50-0707-5812f2306b8e@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joakim Bech <joakim.bech@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <a83d9022-b8bc-ea50-0707-5812f2306b8e@partner.samsung.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Please drop this as I will resend it as part of patchset.

On 16.01.2018 17:32, Kamil Konieczny wrote:
> Crypto framework will require async hash export/import, so add empty
> functions to prevent OOPS.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/ux500/hash/hash_core.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
> index 9acccad26928..2d0a677bcc76 100644
> --- a/drivers/crypto/ux500/hash/hash_core.c
> +++ b/drivers/crypto/ux500/hash/hash_core.c
> @@ -1403,6 +1403,16 @@ static int ahash_sha256_digest(struct ahash_request *req)
>  	return ret1 ? ret1 : ret2;
>  }
>  
> +static int ahash_noimport(struct ahash_request *req, const void *in)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int ahash_noexport(struct ahash_request *req, void *out)
> +{
> +	return -ENOSYS;
> +}
> +
>  static int hmac_sha1_init(struct ahash_request *req)
>  {
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> @@ -1507,6 +1517,8 @@ static struct hash_algo_template hash_algs[] = {
>  			.update = ahash_update,
>  			.final = ahash_final,
>  			.digest = ahash_sha1_digest,
> +			.export = ahash_noexport,
> +			.import = ahash_noimport,
>  			.halg.digestsize = SHA1_DIGEST_SIZE,
>  			.halg.statesize = sizeof(struct hash_ctx),
>  			.halg.base = {
> @@ -1529,6 +1541,8 @@ static struct hash_algo_template hash_algs[] = {
>  			.update	= ahash_update,
>  			.final = ahash_final,
>  			.digest = ahash_sha256_digest,
> +			.export = ahash_noexport,
> +			.import = ahash_noimport,
>  			.halg.digestsize = SHA256_DIGEST_SIZE,
>  			.halg.statesize = sizeof(struct hash_ctx),
>  			.halg.base = {
> @@ -1553,6 +1567,8 @@ static struct hash_algo_template hash_algs[] = {
>  			.final = ahash_final,
>  			.digest = hmac_sha1_digest,
>  			.setkey = hmac_sha1_setkey,
> +			.export = ahash_noexport,
> +			.import = ahash_noimport,
>  			.halg.digestsize = SHA1_DIGEST_SIZE,
>  			.halg.statesize = sizeof(struct hash_ctx),
>  			.halg.base = {
> @@ -1577,6 +1593,8 @@ static struct hash_algo_template hash_algs[] = {
>  			.final = ahash_final,
>  			.digest = hmac_sha256_digest,
>  			.setkey = hmac_sha256_setkey,
> +			.export = ahash_noexport,
> +			.import = ahash_noimport,
>  			.halg.digestsize = SHA256_DIGEST_SIZE,
>  			.halg.statesize = sizeof(struct hash_ctx),
>  			.halg.base = {
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

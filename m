From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: mxs-dcp: Add empty hash export and import
Date: Thu, 18 Jan 2018 18:53:33 +0100
Message-ID: <87da7572-a9a1-3fd1-e916-0cd5b161cfda@partner.samsung.com>
References: <CGME20180116161641eucas1p1f776ccf0d08da2d3b670e5b2ad550ea6@eucas1p1.samsung.com>
        <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Marek Vasut <marex@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Please drop this as I will resend it as part of patchset.

On 16.01.2018 17:16, Kamil Konieczny wrote:
> Crypto framework will require async hash export/import, so add empty
> functions to prevent OOPS.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/mxs-dcp.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index 764be3e6933c..a10c418d4e5c 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -759,6 +759,16 @@ static int dcp_sha_digest(struct ahash_request *req)
>  	return dcp_sha_finup(req);
>  }
>  
> +static int dcp_sha_noimport(struct ahash_request *req, const void *in)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int dcp_sha_noexport(struct ahash_request *req, void *out)
> +{
> +	return -ENOSYS;
> +}
> +
>  static int dcp_sha_cra_init(struct crypto_tfm *tfm)
>  {
>  	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> @@ -829,6 +839,8 @@ static struct ahash_alg dcp_sha1_alg = {
>  	.final	= dcp_sha_final,
>  	.finup	= dcp_sha_finup,
>  	.digest	= dcp_sha_digest,
> +	.import = dcp_sha_noimport,
> +	.export = dcp_sha_noexport,
>  	.halg	= {
>  		.digestsize	= SHA1_DIGEST_SIZE,
>  		.base		= {
> @@ -853,6 +865,8 @@ static struct ahash_alg dcp_sha256_alg = {
>  	.final	= dcp_sha_final,
>  	.finup	= dcp_sha_finup,
>  	.digest	= dcp_sha_digest,
> +	.import = dcp_sha_noimport,
> +	.export = dcp_sha_noexport,
>  	.halg	= {
>  		.digestsize	= SHA256_DIGEST_SIZE,
>  		.base		= {
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: mxs-dcp: Add empty hash export and import
Date: Tue, 16 Jan 2018 17:56:13 +0100
Message-ID: <fbdc8a2b-4ed3-cc1c-246f-10c3c05a2ab0@denx.de>
References: <CGME20180116161641eucas1p1f776ccf0d08da2d3b670e5b2ad550ea6@eucas1p1.samsung.com>
 <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:46118 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751884AbeAPQ4U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 11:56:20 -0500
In-Reply-To: <4f3389a1-d6aa-b3cc-2299-d638058ddd48@partner.samsung.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/16/2018 05:16 PM, Kamil Konieczny wrote:
> Crypto framework will require async hash export/import, so add empty
> functions to prevent OOPS.

Shouldn't this be handled on the subsystem level with some

if (foo->bar)
 foo->bar();

instead?

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
Marek Vasut

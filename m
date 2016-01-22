From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v1] crypto: ccp - Add hash state import and export support
Date: Fri, 22 Jan 2016 11:22:48 -0600
Message-ID: <56A26568.3000806@amd.com>
References: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:26688
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754415AbcAVRzK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 12:55:10 -0500
In-Reply-To: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/12/2016 11:17 AM, Tom Lendacky wrote:
> Commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
> added a check to prevent ahash algorithms from successfully registering
> if the import and export functions were not implemented. This prevents
> an oops in the hash_accept function of algif_hash. This commit causes
> the ccp-crypto module SHA support and AES CMAC support from successfully
> registering and causing the ccp-crypto module load to fail because the
> ahash import and export functions are not implemented.
> 
> Update the CCP Crypto API support to provide import and export support
> for ahash algorithms.
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Herbert, is it possible this patch can be part of Crypto Fixes for 4.5?

Thanks,
Tom

> ---
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   23 +++++++++++++++++++++++
>  drivers/crypto/ccp/ccp-crypto-sha.c      |   23 +++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
> index d89f20c..00207cf 100644
> --- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
> +++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
> @@ -220,6 +220,26 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
>  	return ccp_aes_cmac_finup(req);
>  }
>  
> +static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
> +{
> +	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
> +	struct ccp_aes_cmac_req_ctx *state = out;
> +
> +	*state = *rctx;
> +
> +	return 0;
> +}
> +
> +static int ccp_aes_cmac_import(struct ahash_request *req, const void *in)
> +{
> +	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
> +	const struct ccp_aes_cmac_req_ctx *state = in;
> +
> +	*rctx = *state;
> +
> +	return 0;
> +}
> +
>  static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  			       unsigned int key_len)
>  {
> @@ -352,10 +372,13 @@ int ccp_register_aes_cmac_algs(struct list_head *head)
>  	alg->final = ccp_aes_cmac_final;
>  	alg->finup = ccp_aes_cmac_finup;
>  	alg->digest = ccp_aes_cmac_digest;
> +	alg->export = ccp_aes_cmac_export;
> +	alg->import = ccp_aes_cmac_import;
>  	alg->setkey = ccp_aes_cmac_setkey;
>  
>  	halg = &alg->halg;
>  	halg->digestsize = AES_BLOCK_SIZE;
> +	halg->statesize = sizeof(struct ccp_aes_cmac_req_ctx);
>  
>  	base = &halg->base;
>  	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "cmac(aes)");
> diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
> index d14b3f2..3aae58d 100644
> --- a/drivers/crypto/ccp/ccp-crypto-sha.c
> +++ b/drivers/crypto/ccp/ccp-crypto-sha.c
> @@ -207,6 +207,26 @@ static int ccp_sha_digest(struct ahash_request *req)
>  	return ccp_sha_finup(req);
>  }
>  
> +static int ccp_sha_export(struct ahash_request *req, void *out)
> +{
> +	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
> +	struct ccp_sha_req_ctx *state = out;
> +
> +	*state = *rctx;
> +
> +	return 0;
> +}
> +
> +static int ccp_sha_import(struct ahash_request *req, const void *in)
> +{
> +	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
> +	const struct ccp_sha_req_ctx *state = in;
> +
> +	*rctx = *state;
> +
> +	return 0;
> +}
> +
>  static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
>  			  unsigned int key_len)
>  {
> @@ -403,9 +423,12 @@ static int ccp_register_sha_alg(struct list_head *head,
>  	alg->final = ccp_sha_final;
>  	alg->finup = ccp_sha_finup;
>  	alg->digest = ccp_sha_digest;
> +	alg->export = ccp_sha_export;
> +	alg->import = ccp_sha_import;
>  
>  	halg = &alg->halg;
>  	halg->digestsize = def->digest_size;
> +	halg->statesize = sizeof(struct ccp_sha_req_ctx);
>  
>  	base = &halg->base;
>  	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
> 

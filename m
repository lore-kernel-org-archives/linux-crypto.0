From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: ccp - Limit the amount of information exported
Date: Mon, 1 Feb 2016 22:35:06 +0800
Message-ID: <20160201143506.GC11410@gondor.apana.org.au>
References: <20160129184514.10863.45404.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42486 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcBAOfK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 09:35:10 -0500
Content-Disposition: inline
In-Reply-To: <20160129184514.10863.45404.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 29, 2016 at 12:45:14PM -0600, Tom Lendacky wrote:
> Since the exported information can be exposed to user-space, instead of
> exporting the entire request context only export the minimum information
> needed.
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   16 +++++++++++-----
>  drivers/crypto/ccp/ccp-crypto-sha.c      |   20 +++++++++++++++-----
>  drivers/crypto/ccp/ccp-crypto.h          |   22 ++++++++++++++++++++++
>  3 files changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
> index 00207cf..6a2d836 100644
> --- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
> +++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
> @@ -223,9 +223,12 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
>  static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
>  {
>  	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
> -	struct ccp_aes_cmac_req_ctx *state = out;
> +	struct ccp_aes_cmac_exp_ctx *state = out;
>  
> -	*state = *rctx;
> +	state->null_msg = rctx->null_msg;
> +	memcpy(state->iv, rctx->iv, sizeof(state->iv));
> +	state->buf_count = rctx->buf_count;
> +	memcpy(state->buf, rctx->buf, sizeof(state->buf));
>  
>  	return 0;
>  }

BTW this code needs to be fixed to not assume that in/out are
aligned.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

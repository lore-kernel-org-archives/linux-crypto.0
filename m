From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 10/11] crypto: caam: add ahash_edesc_add_src()
Date: Wed, 9 Dec 2015 18:21:05 +0200
Message-ID: <566854F1.8020409@freescale.com>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
 <E1a61DK-0007nF-BJ@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:35328
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751785AbbLIQgG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 11:36:06 -0500
In-Reply-To: <E1a61DK-0007nF-BJ@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/7/2015 9:12 PM, Russell King wrote:
> Add a helper to map the source scatterlist into the descriptor.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

After appending 07/11 ("crypto: caam: check and use dma_map_sg() return code")
as follows:

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 241268d108ec..00b35e763f58 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1120,7 +1120,7 @@ static int ahash_digest(struct ahash_request *req)

src_nents = sg_nents_for_len(req->src, req->nbytes);
mapped_nents = dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
- if (mapped_nents == 0) {
+ if (src_nents && mapped_nents == 0) {
dev_err(jrdev, "unable to map source for DMA\n");
return -ENOMEM;
}

I still see tcrypts test failures:
caam_jr ffe301000.jr: 4000131c: DECO: desc idx 19: DECO Watchdog timer timeout error
alt: hash: update failed on test 6 for hmac-sha1-caam: ret=-1073746716
alg: hash: Test 4 failed for sha1-caam
00000000: 75 e1 d9 26 df 3b 5c 31 d7 a3 02 ca 79 26 55 0e
00000010: 31 96 8d 9f
[...]

git bisect points to this commit.

> ---
>  drivers/crypto/caam/caamhash.c | 106 +++++++++++++++++++----------------------
>  1 file changed, 49 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> index 241268d108ec..4e73d3218481 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -789,6 +789,40 @@ static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
>  	return edesc;
>  }
>  
> +static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
> +			       struct ahash_edesc *edesc,
> +			       struct ahash_request *req, int nents,
> +			       unsigned int first_sg, unsigned int first_bytes)
> +{
> +	dma_addr_t src_dma;
> +	u32 options;
> +
> +	if (nents > 1 || first_sg) {
> +		struct sec4_sg_entry *sg = edesc->sec4_sg;
> +		unsigned int sgsize = sizeof(*sg) * (first_sg + nents);
> +
> +		sg_to_sec4_sg_last(req->src, nents, sg + first_sg, 0);
> +
> +		src_dma = dma_map_single(ctx->jrdev, sg, sgsize, DMA_TO_DEVICE);
> +		if (dma_mapping_error(ctx->jrdev, src_dma)) {
> +			dev_err(ctx->jrdev, "unable to map S/G table\n");
> +			return -ENOMEM;
> +		}
> +
> +		edesc->sec4_sg_bytes = sgsize;
> +		edesc->sec4_sg_dma = src_dma;
> +		options = LDST_SGF;
> +	} else {
> +		src_dma = sg_dma_address(req->src);
> +		options = 0;
> +	}
> +
> +	append_seq_in_ptr(edesc->hw_desc, src_dma, first_bytes + req->nbytes,
> +			  options);
> +
> +	return 0;
> +}
[snip]
> @@ -1471,9 +1486,7 @@ static int ahash_update_first(struct ahash_request *req)
>  		&state->buflen_1 : &state->buflen_0;
>  	int to_hash;
>  	u32 *desc;
> -	int sec4_sg_bytes, src_nents, mapped_nents;
> -	dma_addr_t src_dma;
> -	u32 options;
> +	int src_nents, mapped_nents;
>  	struct ahash_edesc *edesc;
>  	int ret = 0;
>  
> @@ -1490,11 +1503,6 @@ static int ahash_update_first(struct ahash_request *req)
>  			dev_err(jrdev, "unable to map source for DMA\n");
>  			return -ENOMEM;
>  		}
> -		if (mapped_nents > 1)
> -			sec4_sg_bytes = mapped_nents *
> -					sizeof(struct sec4_sg_entry);
> -		else
> -			sec4_sg_bytes = 0;
>  
>  		/*
>  		 * allocate space for base edesc and hw desc commands,
> @@ -1511,28 +1519,14 @@ static int ahash_update_first(struct ahash_request *req)
>  		}
>  
>  		edesc->src_nents = src_nents;
> -		edesc->sec4_sg_bytes = sec4_sg_bytes;
>  		edesc->dst_dma = 0;
>  
> -		if (src_nents > 1) {
> -			sg_to_sec4_sg_last(req->src, mapped_nents,
> -					   edesc->sec4_sg, 0);
> -			edesc->sec4_sg_dma = dma_map_single(jrdev,
> -							    edesc->sec4_sg,
> -							    sec4_sg_bytes,
> -							    DMA_TO_DEVICE);
> -			if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
> -				dev_err(jrdev, "unable to map S/G table\n");
> -				ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
> -						DMA_TO_DEVICE);
> -				kfree(edesc);
> -				return -ENOMEM;
> -			}
> -			src_dma = edesc->sec4_sg_dma;
> -			options = LDST_SGF;
> -		} else {
> -			src_dma = sg_dma_address(req->src);
> -			options = 0;
> +		ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0);
> +		if (ret) {
> +			ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
> +					DMA_TO_DEVICE);
> +			kfree(edesc);
> +			return ret;
>  		}
>  
>  		if (*next_buflen)
> @@ -1541,8 +1535,6 @@ static int ahash_update_first(struct ahash_request *req)
>  
>  		desc = edesc->hw_desc;
>  
> -		append_seq_in_ptr(desc, src_dma, to_hash, options);
> -

The refactoring changes the logic here: instead of hashing over "to_hash" input
bytes, it will do over req->nbytes.

Current patch could be fixed as follows, but I guess it's abusing the
"first_bytes" param:

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 6d903398fb0d..7d40765e94c5 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -792,7 +792,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct
caam_hash_ctx *ctx,
 static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
                               struct ahash_edesc *edesc,
                               struct ahash_request *req, int nents,
-                              unsigned int first_sg, unsigned int first_bytes)
+                              unsigned int first_sg, int first_bytes)
 {
        dma_addr_t src_dma;
        u32 options;
@@ -817,7 +817,7 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
                options = 0;
        }

-       append_seq_in_ptr(edesc->hw_desc, src_dma, first_bytes + req->nbytes,
+       append_seq_in_ptr(edesc->hw_desc, src_dma, req->nbytes + first_bytes,
                          options);

        return 0;
@@ -1521,7 +1521,8 @@ static int ahash_update_first(struct ahash_request *req)
                edesc->src_nents = src_nents;
                edesc->dst_dma = 0;

-               ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0);
+               ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0,
+                                         -*next_buflen);
                if (ret) {
                        ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len,
                                        DMA_TO_DEVICE);

Horia

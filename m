From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 07/11] crypto: caam: check and use dma_map_sg() return
 code
Date: Wed, 9 Dec 2015 17:20:45 +0200
Message-ID: <566846CD.1020607@freescale.com>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
 <E1a61D4-0007ms-UR@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:2489
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbbLIPUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 10:20:54 -0500
In-Reply-To: <E1a61D4-0007ms-UR@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/7/2015 9:12 PM, Russell King wrote:
> Strictly, dma_map_sg() may coalesce SG entries, but in practise on iMX
> hardware, this will never happen.  However, dma_map_sg() can fail, and
> we completely fail to check its return value.  So, fix this properly.
> 
> Arrange the code to map the scatterlist early, so we know how many
> scatter table entries to allocate, and then fill them in.  This allows
> us to keep relatively simple error cleanup paths.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Some tcrypt tests fail - looks like those with zero plaintext:
caam_jr ffe301000.jr: unable to map source for DMA
alg: hash: digest failed on test 1 for sha1-caam: ret=12
[...]

Need to be careful, dma_map_sg() returning zero is an error only if ptxt
is not null (alternatively src_nents returned by sg_nents_for_len()
could be checked).

> @@ -1091,7 +1102,7 @@ static int ahash_digest(struct ahash_request *req)
>  	u32 *sh_desc = ctx->sh_desc_digest, *desc;
>  	dma_addr_t ptr = ctx->sh_desc_digest_dma;
>  	int digestsize = crypto_ahash_digestsize(ahash);
> -	int src_nents, sec4_sg_bytes;
> +	int src_nents, mapped_nents, sec4_sg_bytes;
>  	dma_addr_t src_dma;
>  	struct ahash_edesc *edesc;
>  	int ret = 0;
> @@ -1099,9 +1110,14 @@ static int ahash_digest(struct ahash_request *req)
>  	int sh_len;
>  
>  	src_nents = sg_nents_for_len(req->src, req->nbytes);
> -	dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
> -	if (src_nents > 1)
> -		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
> +	mapped_nents = dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
> +	if (mapped_nents == 0) {
> +		dev_err(jrdev, "unable to map source for DMA\n");
> +		return -ENOMEM;
> +	}

This is at least one of the places where the error condition must change
to smth. like (src_nents != 0 && mapped_nents == 0).

Horia

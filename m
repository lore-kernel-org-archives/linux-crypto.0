Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAF53B2A0;
	Mon,  1 Jun 2026 05:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780292462; cv=none; b=dzLo+3uCauT/5wSFhmx0iwn6Y8a4K5kva9bVEKGU8cjr+8B/dTNozeMIdQyqTOoRTlQgxNVdCK66XlXGQxsDlwy/9F1PPxUwEQZLpiGKE4cqql09BsX/OPgUbNR7Z4oFDcnV2soY4VvEpFTSVO7SPtjmv84PuY+xkwu8/8bQE4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780292462; c=relaxed/simple;
	bh=8kipKYbgohwzWhN7R9VSyJl+U3GBYczZSwEGkH1Quc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TazFXjELC4c+x1bJqSY2F7jtuUvhaduN7VIB9Ri+SlPyEkyeziR71ioBP6Cp8PR8Nti7VhktxHR5kZIXVmhI3cesc0u0M2/9rtTc6X/7KtE9xGhrwRno2E7t6djmPbeNQmc3Ey9tUkw7sHWIz1oQx8PNBIsflUQ7g2Jbh4fmTOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/A57HXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/A57HXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45F61F00893;
	Mon,  1 Jun 2026 05:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780292460;
	bh=/8IEGrbkiNt50pT94ZxugSzJIVn5KiXBJ2YKJgpaiYg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e/A57HXGP16EOFYYJTJeOjcrfo5XJOHyp3rxkGumfjl9Um4Y1V4mBm+JjLgl/sF2/
	 i+1K5tqKP35mmGwij2oO6rgeELmzwPrrK+/70qt04mScnrPy7QLhGFl3UzJXMXAq2W
	 5ojBIyLnodoPxzkCaaD7y0tLrONpksOrk+LCVsWfyarUvbYjkTngXth/19CkAglmji
	 YhJQF4oTxzDr+yn1Wgb+fEN8fCi+cFBIKFqIcucU2S2LHA1hdT26BDp2MqgSXgpJrc
	 KJGEqTvelxyX1n3EyLZwr+ghke8yf+Fnpz9hQbbOF9THJeYJDj594yzagOviTLrjx7
	 YMshI6fl0HTfA==
Message-ID: <f70f5279-e136-467a-8306-a1af1ea27015@kernel.org>
Date: Mon, 1 Jun 2026 07:40:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/29] crypto: talitos/hash - Use CRYPTO_AHASH_BLOCK_ONLY
 API
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-1-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-1-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> The hash implementation maintained a software buffer to accumulate
> partial blocks across update() calls, copying data to/from scatterlists
> with sg_copy_to_buffer()/sg_pcopy_to_buffer() and chaining in a virtual
> scatterlist entry.  This is unnecessary now with
> CRYPTO_AHASH_ALG_BLOCK_ONLY flag.
> 
> Remove unnecessary fields in the request and export structure. On
> completion, pass any remaining tail bytes back via
> ahash_request_complete() so that the core re-submits them with the next
> request.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

I have a build failure with this patch:

   UPD     include/config/kernel.release
   UPD     include/generated/utsrelease.h
   DESCEND objtool
   INSTALL libsubcmd_headers
   CC      drivers/crypto/talitos.o
drivers/crypto/talitos.c: In function 'talitos_cra_init_ahash':
drivers/crypto/talitos.c:3150:34: warning: statement with no effect 
[-Wunused-value]
  3150 |                                  sizeof(struct 
talitos_ahash_req_ctx));
       |                                  ^~~~~~
drivers/crypto/talitos.c:3150:70: error: expected ';' before ')' token
  3150 |                                  sizeof(struct 
talitos_ahash_req_ctx));
       | 
      ^
       | 
      ;
drivers/crypto/talitos.c:3150:70: error: expected statement before ')' token
make[4]: *** [scripts/Makefile.build:289: drivers/crypto/talitos.o] Error 1
make[3]: *** [scripts/Makefile.build:548: drivers/crypto] Error 2
make[2]: *** [scripts/Makefile.build:548: drivers] Error 2
make[1]: *** [/home/chleroy/linux-powerpc/Makefile:2141: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2


> ---
>   drivers/crypto/talitos.c | 149 ++++++++++++++++++-----------------------------
>   1 file changed, 57 insertions(+), 92 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 584508963241..3610d9f6d5ea 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -941,25 +941,18 @@ struct talitos_ctx {
>   struct talitos_ahash_req_ctx {
>   	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
>   	unsigned int hw_context_size;
> -	u8 buf[2][HASH_MAX_BLOCK_SIZE];
> -	int buf_idx;
>   	unsigned int swinit;
>   	unsigned int first_request;
>   	unsigned int last_request;
>   	unsigned int to_hash_later;
> -	unsigned int nbuf;
> -	struct scatterlist bufsl[2];
> -	struct scatterlist *psrc;
>   };
>   
>   struct talitos_export_state {
>   	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
> -	u8 buf[HASH_MAX_BLOCK_SIZE];
>   	unsigned int swinit;
>   	unsigned int first_request;
>   	unsigned int last_request;
>   	unsigned int to_hash_later;
> -	unsigned int nbuf;
>   };
>   
>   static int aead_setkey(struct crypto_aead *authenc,
> @@ -1826,14 +1819,8 @@ static void ahash_done(struct device *dev,
>   	struct talitos_edesc *next;
>   
>   	if (is_sec1) {
> -		if (!req_ctx->last_request && req_ctx->to_hash_later) {
> -			/* Position any partial block for next update/final/finup */
> -			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
> -			req_ctx->nbuf = req_ctx->to_hash_later;
> -		}
> -
>   		free_edesc_list_from(areq, edesc);
> -		ahash_request_complete(areq, err);
> +		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
>   	} else {
>   		next = edesc->next_desc;
>   
> @@ -1851,14 +1838,9 @@ static void ahash_done(struct device *dev,
>   			return;
>   		}
>   out:
> -		if (!req_ctx->last_request && req_ctx->to_hash_later) {
> -			/* Position any partial block for next update/final/finup */
> -			req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
> -			req_ctx->nbuf = req_ctx->to_hash_later;
> -		}
>   		if (err && next)
>   			free_edesc_list_from(areq, next);
> -		ahash_request_complete(areq, err);
> +		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
>   	}
>   }
>   
> @@ -1978,7 +1960,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
>   	size_t offset = 0;
>   
>   	do {
> -		src = scatterwalk_ffwd(tmp, req_ctx->psrc, offset);
> +		src = scatterwalk_ffwd(tmp, areq->src, offset);
>   
>   		to_hash_this_desc =
>   			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
> @@ -1991,8 +1973,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
>   			return edesc;
>   		}
>   
> -		edesc->src =
> -			scatterwalk_ffwd(edesc->bufsl, req_ctx->psrc, offset);
> +		edesc->src = scatterwalk_ffwd(edesc->bufsl, areq->src, offset);
>   		edesc->desc.hdr = ctx->desc_hdr_template;
>   		edesc->first = offset == 0;
>   		edesc->last = nbytes - to_hash_this_desc == 0;
> @@ -2045,62 +2026,17 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
>   	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(ctx->dev));
>   	unsigned int nbytes_to_hash;
>   	unsigned int to_hash_later;
> -	unsigned int nsg;
> -	int nents;
>   	struct device *dev = ctx->dev;
> -	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
>   	int ret;
>   
> -	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
> -		/* Buffer up to one whole block */
> -		nents = sg_nents_for_len(areq->src, nbytes);
> -		if (nents < 0) {
> -			dev_err(dev, "Invalid number of src SG.\n");
> -			return nents;
> -		}
> -		sg_copy_to_buffer(areq->src, nents,
> -				  ctx_buf + req_ctx->nbuf, nbytes);
> -		req_ctx->nbuf += nbytes;
> -		return 0;
> -	}
> -
> -	/* At least (blocksize + 1) bytes are available to hash */
> -	nbytes_to_hash = nbytes + req_ctx->nbuf;
> -	to_hash_later = nbytes_to_hash & (blocksize - 1);
> +	nbytes_to_hash = ALIGN_DOWN(nbytes, blocksize);
> +	to_hash_later = nbytes - nbytes_to_hash;
>   
> -	if (req_ctx->last_request)
> +	if (req_ctx->last_request) {
> +		nbytes_to_hash = nbytes;
>   		to_hash_later = 0;
> -	else if (to_hash_later)
> -		/* There is a partial block. Hash the full block(s) now */
> -		nbytes_to_hash -= to_hash_later;
> -	else {
> -		/* Keep one block buffered */
> -		nbytes_to_hash -= blocksize;
> -		to_hash_later = blocksize;
> -	}
> -
> -	/* Chain in any previously buffered data */
> -	if (req_ctx->nbuf) {
> -		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
> -		sg_init_table(req_ctx->bufsl, nsg);
> -		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
> -		if (nsg > 1)
> -			sg_chain(req_ctx->bufsl, 2, areq->src);
> -		req_ctx->psrc = req_ctx->bufsl;
> -	} else
> -		req_ctx->psrc = areq->src;
> -
> -	if (to_hash_later) {
> -		nents = sg_nents_for_len(areq->src, nbytes);
> -		if (nents < 0) {
> -			dev_err(dev, "Invalid number of src SG.\n");
> -			return nents;
> -		}
> -		sg_pcopy_to_buffer(areq->src, nents,
> -				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
> -				      to_hash_later,
> -				      nbytes - to_hash_later);
>   	}
> +
>   	req_ctx->to_hash_later = to_hash_later;
>   
>   	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
> @@ -2125,8 +2061,6 @@ static int ahash_init(struct ahash_request *areq)
>   	dma_addr_t dma;
>   
>   	/* Initialize the context */
> -	req_ctx->buf_idx = 0;
> -	req_ctx->nbuf = 0;
>   	req_ctx->first_request = 1;
>   	req_ctx->swinit = 0; /* assume h/w init of context */
>   	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
> @@ -2223,12 +2157,10 @@ static int ahash_export(struct ahash_request *areq, void *out)
>   
>   	memcpy(export->hw_context, req_ctx->hw_context,
>   	       req_ctx->hw_context_size);
> -	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
>   	export->swinit = req_ctx->swinit;
>   	export->first_request = req_ctx->first_request;
>   	export->last_request = req_ctx->last_request;
>   	export->to_hash_later = req_ctx->to_hash_later;
> -	export->nbuf = req_ctx->nbuf;
>   
>   	return 0;
>   }
> @@ -2249,12 +2181,10 @@ static int ahash_import(struct ahash_request *areq, const void *in)
>   			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
>   	req_ctx->hw_context_size = size;
>   	memcpy(req_ctx->hw_context, export->hw_context, size);
> -	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
>   	req_ctx->swinit = export->swinit;
>   	req_ctx->first_request = export->first_request;
>   	req_ctx->last_request = export->last_request;
>   	req_ctx->to_hash_later = export->to_hash_later;
> -	req_ctx->nbuf = export->nbuf;
>   
>   	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
>   			     DMA_TO_DEVICE);
> @@ -2932,8 +2862,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "md5",
>   				.cra_driver_name = "md5-talitos",
>   				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2948,8 +2881,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "sha1",
>   				.cra_driver_name = "sha1-talitos",
>   				.cra_blocksize = SHA1_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2964,8 +2900,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "sha224",
>   				.cra_driver_name = "sha224-talitos",
>   				.cra_blocksize = SHA224_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2980,8 +2919,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "sha256",
>   				.cra_driver_name = "sha256-talitos",
>   				.cra_blocksize = SHA256_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2996,8 +2938,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "sha384",
>   				.cra_driver_name = "sha384-talitos",
>   				.cra_blocksize = SHA384_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3012,8 +2957,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "sha512",
>   				.cra_driver_name = "sha512-talitos",
>   				.cra_blocksize = SHA512_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3028,8 +2976,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "hmac(md5)",
>   				.cra_driver_name = "hmac-md5-talitos",
>   				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3044,8 +2995,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "hmac(sha1)",
>   				.cra_driver_name = "hmac-sha1-talitos",
>   				.cra_blocksize = SHA1_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3060,8 +3014,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "hmac(sha224)",
>   				.cra_driver_name = "hmac-sha224-talitos",
>   				.cra_blocksize = SHA224_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3076,8 +3033,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "hmac(sha256)",
>   				.cra_driver_name = "hmac-sha256-talitos",
>   				.cra_blocksize = SHA256_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3092,8 +3052,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "hmac(sha384)",
>   				.cra_driver_name = "hmac-sha384-talitos",
>   				.cra_blocksize = SHA384_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3108,8 +3071,11 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "hmac(sha512)",
>   				.cra_driver_name = "hmac-sha512-talitos",
>   				.cra_blocksize = SHA512_BLOCK_SIZE,
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -3181,7 +3147,6 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
>   				   algt.alg.hash);
>   
>   	ctx->keylen = 0;
> -	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
>   				 sizeof(struct talitos_ahash_req_ctx));
>   
>   	return talitos_init_common(ctx, talitos_alg);
> 


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0896C367B88;
	Mon,  1 Jun 2026 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315330; cv=none; b=J4cmm2ze/aKCIcQBw1Ac5iSgBEoRsnhGYQymPtHNwlNMkvL53L3l3I0JU/x9dvPSbrnefVZOj769chXR3CPTzWeTOvpyvahXa/SSjEGao8jCfFDfkiV1+1OxoS3j1xG1b95L9+88TV4vSsZB++nlOa8A3u89hIKfxJOFhzhmEsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315330; c=relaxed/simple;
	bh=Sd4/dLNg9BnsIAat4B4gmqsHV3cvdQu1Nl/hUPmZZgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+8Ze9rQjvsrJz3oS1mKHI7S9NUVP398tpJLOLJub3WQ1NBULXiO0J+6kIpjGZzs/NNwQdWSp5ua/A83Vyo0QgmK3XnGMf9pv5vUnmSLam9w9Hzi4OFR0BuV1+bQfXaqpFIoVsEhDcoWbeUuwCXslbRSxAgbORoQRKTTo8/Tyqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2fN3TcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2fN3TcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DC01F00893;
	Mon,  1 Jun 2026 12:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315328;
	bh=DYugI6ZxHA/4GutmYzXAb7kiRM4K40u8mxKyxFvpsNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P2fN3TcLx2MQ7fNoEgjDZvtB4yUqXafchtA6vCJzCuGaw+YsROEBPUzBGFWdQVPKE
	 qUaBLwjwEur9PoaRdU9elTyzIrpNb7zlE4W/tqgg6PUAvOE1KNBIRyxgdO3/IGW0Ju
	 DTNTctR0mtm1J9BA2PbINS8/SV8qIUC4NZIcWF3XF+8Xf6zZFc+w1Ng0Fgt6z4M83q
	 ccmWqrMMAk2waq7IpPDmWFzYviJovL7GVQViju/HJIrjdHm2s4NLjnL3JcEfqLQ6DR
	 P9auU41cTaEjC/VDJarpZQCtRs2HFfl44eNrDy7etvBz9iq1MPrElSK4UR6JHjW9Uf
	 Ji1kBCQjZq3Ww==
Message-ID: <8246e50a-cfdb-472e-a2e0-c68b47751af5@kernel.org>
Date: Mon, 1 Jun 2026 14:02:04 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/29] crypto: talitos/hash - Use macro for algorithm
 definitions
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-15-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-15-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Replace the repetitive struct initializer entries in hash_driver_algs[]
> with preprocessor macros (TALITOS_HASH_ALG, TALITOS_HMAC_HASH_ALG).
> 
> Remove the function pointer assignments (init_tfm, exit_tfm, init, update,
> final, finup, digest, export, import).
> 
> The HMAC setkey assignment, previously done by comparing the algorithm
> name at runtime, is now handled by passing ahash_setkey directly through
> the TALITOS_HMAC_HASH_ALG macro variant.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/talitos/talitos-hash.c | 392 +++++++++-------------------------
>   1 file changed, 104 insertions(+), 288 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
> index f7f6f01cfddf..9e6d849c3123 100644
> --- a/drivers/crypto/talitos/talitos-hash.c
> +++ b/drivers/crypto/talitos/talitos-hash.c
> @@ -551,283 +551,111 @@ static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
>   	talitos_cra_exit(crypto_ahash_tfm(tfm));
>   }
>   
> -static struct talitos_alg_template hash_driver_algs[] = {
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = MD5_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "md5",
> -				.cra_driver_name = "md5-talitos",
> -				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_MD5,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA1_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "sha1",
> -				.cra_driver_name = "sha1-talitos",
> -				.cra_blocksize = SHA1_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_SHA1,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA224_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "sha224",
> -				.cra_driver_name = "sha224-talitos",
> -				.cra_blocksize = SHA224_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_SHA224,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA256_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "sha256",
> -				.cra_driver_name = "sha256-talitos",
> -				.cra_blocksize = SHA256_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_SHA256,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA384_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "sha384",
> -				.cra_driver_name = "sha384-talitos",
> -				.cra_blocksize = SHA384_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUB |
> -				     DESC_HDR_MODE0_MDEUB_SHA384,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA512_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "sha512",
> -				.cra_driver_name = "sha512-talitos",
> -				.cra_blocksize = SHA512_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUB |
> -				     DESC_HDR_MODE0_MDEUB_SHA512,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = MD5_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "hmac(md5)",
> -				.cra_driver_name = "hmac-md5-talitos",
> -				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_MD5,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA1_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "hmac(sha1)",
> -				.cra_driver_name = "hmac-sha1-talitos",
> -				.cra_blocksize = SHA1_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_SHA1,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA224_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "hmac(sha224)",
> -				.cra_driver_name = "hmac-sha224-talitos",
> -				.cra_blocksize = SHA224_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_SHA224,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA256_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "hmac(sha256)",
> -				.cra_driver_name = "hmac-sha256-talitos",
> -				.cra_blocksize = SHA256_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUA |
> -				     DESC_HDR_MODE0_MDEU_SHA256,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA384_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "hmac(sha384)",
> -				.cra_driver_name = "hmac-sha384-talitos",
> -				.cra_blocksize = SHA384_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUB |
> -				     DESC_HDR_MODE0_MDEUB_SHA384,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AHASH,
> -		.alg.hash = {
> -			.halg.digestsize = SHA512_DIGEST_SIZE,
> -			.halg.statesize = sizeof(struct talitos_export_state),
> -			.halg.base = {
> -				.cra_name = "hmac(sha512)",
> -				.cra_driver_name = "hmac-sha512-talitos",
> -				.cra_blocksize = SHA512_BLOCK_SIZE,
> -				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> -			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> -					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			}
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_MDEUB |
> -				     DESC_HDR_MODE0_MDEUB_SHA512,
> +#define TALITOS_HASH_ALG_COMMON(name, digest_size, block_size, template, \
> +				set_key)                                 \
> +	{ \
> +		.type = CRYPTO_ALG_TYPE_AHASH, \
> +		.alg.hash = { \
> +			.init_tfm = talitos_cra_init_ahash, \
> +			.exit_tfm = talitos_cra_exit_ahash, \
> +			.init = ahash_init, \
> +			.update = ahash_update, \
> +			.final = ahash_final, \
> +			.finup = ahash_finup, \
> +			.digest = ahash_digest, \
> +			.setkey = set_key, \
> +			.import = ahash_import, \
> +			.export = ahash_export, \
> +			.halg.digestsize = digest_size, \
> +			.halg.statesize = sizeof(struct talitos_export_state), \
> +			.halg.base = { \
> +				.cra_name = name, \
> +				.cra_driver_name = name"-talitos", \
> +				.cra_blocksize = block_size, \
> +				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx), \
> +				.cra_flags = CRYPTO_ALG_ASYNC | \
> +					     CRYPTO_ALG_ALLOCATES_MEMORY | \
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY | \
> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY | \
> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO, \
> +				.cra_priority = TALITOS_CRA_PRIORITY, \
> +				.cra_ctxsize = sizeof(struct talitos_ctx), \
> +				.cra_module = THIS_MODULE, \
> +			}, \
> +		}, \
> +		.desc_hdr_template = template, \
>   	}
> +
> +#define TALITOS_HASH_ALG(name, digest_size, block_size, desc_hdr_template) \
> +	TALITOS_HASH_ALG_COMMON(name, digest_size, block_size,             \
> +				desc_hdr_template, NULL)
> +
> +#define TALITOS_HMAC_HASH_ALG(name, digest_size, block_size,               \
> +			      desc_hdr_template)                           \
> +	TALITOS_HASH_ALG_COMMON("hmac(" name ")", digest_size, block_size, \
> +				desc_hdr_template, ahash_setkey)
> +
> +static struct talitos_alg_template hash_driver_algs[] = {
> +	TALITOS_HASH_ALG("md5", MD5_DIGEST_SIZE, MD5_HMAC_BLOCK_SIZE,
> +			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				 DESC_HDR_SEL0_MDEUA | DESC_HDR_MODE0_MDEU_MD5),
> +
> +	TALITOS_HASH_ALG("sha1", SHA1_DIGEST_SIZE, SHA1_BLOCK_SIZE,
> +			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				 DESC_HDR_SEL0_MDEUA |
> +				 DESC_HDR_MODE0_MDEU_SHA1),
> +
> +	TALITOS_HASH_ALG("sha224", SHA224_DIGEST_SIZE, SHA224_BLOCK_SIZE,
> +			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				 DESC_HDR_SEL0_MDEUA |
> +				 DESC_HDR_MODE0_MDEU_SHA224),
> +
> +	TALITOS_HASH_ALG("sha256", SHA256_DIGEST_SIZE, SHA256_BLOCK_SIZE,
> +			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				 DESC_HDR_SEL0_MDEUA |
> +				 DESC_HDR_MODE0_MDEU_SHA256),
> +
> +	TALITOS_HASH_ALG("sha384", SHA384_DIGEST_SIZE, SHA384_BLOCK_SIZE,
> +			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				 DESC_HDR_SEL0_MDEUB |
> +				 DESC_HDR_MODE0_MDEUB_SHA384),
> +
> +	TALITOS_HASH_ALG("sha512", SHA512_DIGEST_SIZE, SHA512_BLOCK_SIZE,
> +			 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				 DESC_HDR_SEL0_MDEUB |
> +				 DESC_HDR_MODE0_MDEUB_SHA512),
> +
> +	/* HMAC */
> +
> +	TALITOS_HMAC_HASH_ALG("md5", MD5_DIGEST_SIZE, MD5_HMAC_BLOCK_SIZE,
> +			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				      DESC_HDR_SEL0_MDEUA |
> +				      DESC_HDR_MODE0_MDEU_MD5),
> +
> +	TALITOS_HMAC_HASH_ALG("sha1", SHA1_DIGEST_SIZE, SHA1_BLOCK_SIZE,
> +			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				      DESC_HDR_SEL0_MDEUA |
> +				      DESC_HDR_MODE0_MDEU_SHA1),
> +
> +	TALITOS_HMAC_HASH_ALG("sha224", SHA224_DIGEST_SIZE, SHA224_BLOCK_SIZE,
> +			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				      DESC_HDR_SEL0_MDEUA |
> +				      DESC_HDR_MODE0_MDEU_SHA224),
> +
> +	TALITOS_HMAC_HASH_ALG("sha256", SHA256_DIGEST_SIZE, SHA256_BLOCK_SIZE,
> +			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				      DESC_HDR_SEL0_MDEUA |
> +				      DESC_HDR_MODE0_MDEU_SHA256),
> +
> +	TALITOS_HMAC_HASH_ALG("sha384", SHA384_DIGEST_SIZE, SHA384_BLOCK_SIZE,
> +			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				      DESC_HDR_SEL0_MDEUB |
> +				      DESC_HDR_MODE0_MDEUB_SHA384),
> +
> +	TALITOS_HMAC_HASH_ALG("sha512", SHA512_DIGEST_SIZE, SHA512_BLOCK_SIZE,
> +			      DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +				      DESC_HDR_SEL0_MDEUB |
> +				      DESC_HDR_MODE0_MDEUB_SHA512),
>   };
>   
>   int talitos_register_hash(struct device *dev)
> @@ -846,18 +674,6 @@ int talitos_register_hash(struct device *dev)
>   		ahash_alg = &hash_driver_algs[i].alg.hash;
>   		alg = &ahash_alg->halg.base;
>   
> -		ahash_alg->init_tfm = talitos_cra_init_ahash;
> -		ahash_alg->exit_tfm = talitos_cra_exit_ahash;
> -		ahash_alg->init = ahash_init;
> -		ahash_alg->update = ahash_update;
> -		ahash_alg->final = ahash_final;
> -		ahash_alg->finup = ahash_finup;
> -		ahash_alg->digest = ahash_digest;
> -		if (!strncmp(alg->cra_name, "hmac", 4))
> -			ahash_alg->setkey = ahash_setkey;
> -		ahash_alg->import = ahash_import;
> -		ahash_alg->export = ahash_export;
> -
>   		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
>   		    !strncmp(alg->cra_name, "hmac", 4)) {
>   			/* not supported */
> 


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552F533F5A4;
	Mon,  1 Jun 2026 12:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315981; cv=none; b=ajXStFJppGRytx9gect4ClWXRdOygfQp9cyLJlHQk64PgPiBt0DSqKAQRrYs2CIoge1F9MCVwHWqADeVdxUBpw+UtAi96dyDymj7NA9Jk+4VSTSOjdTCWWtobRP/mzEZWEKAqBejRO4Iv1BZWOVP7CCsx+7YHGibB0uKFDLWBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315981; c=relaxed/simple;
	bh=kNZGYDzlMAsTHzBan4v5MQydQ7YPxZw+DF2QhNp1Qkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u2cKke4JmZTDldPxuDbH0ZA+5xfPKuUUl2Ih2mJmT8m3u8XLX/yXeBR78Ao2uszeMjKIa4hN4ZHPLxLoUCrdC8ovJfkk3bL+iu5/2A/koOWozKVlKwYFt+ZWChf9E1SLLq2Gk5FhPA6sHkmlXL/sZp+EgyAg5dEKmY0U9wAGx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6WNVTgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6WNVTgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223C11F00898;
	Mon,  1 Jun 2026 12:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315979;
	bh=3/lTiWX9XYLcNSiyMkteMKq6vUh1JSHz7geZ78m8P/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J6WNVTgVKAs8Y/1jAJz1hyZNa0iyJb4s16B5i7VmVyygUWe3pK1o4g0jHIr/dB7AM
	 SMXoJ3nu/s571g1vnyezHi5r1pJmPDtZN3OrJnrnclEqAM8qqjyNw+76w1Dz/Uo2CB
	 21HUpZNejxwnCmiUiDK4+HvuQsDaIn+phz1owYLMjZo1FjGsVR5nYoFdRiHkEu6XLZ
	 iiaYa4j8aEhwpfPoQZujIL4Tbte5Jd/dN3q2jxcn4rd5ViJPt6i0mKINtNO8rREjFq
	 rZTQFFT5Zw0RSS6QJyxR3JtsNRauJKUCZlRdX+SUGh8psoThcYa1+q8PgeDn0GPFq4
	 e4zfLfgb3BYEQ==
Message-ID: <30919934-0baf-47c3-a601-3ff0c8cc7f43@kernel.org>
Date: Mon, 1 Jun 2026 14:12:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/29] crypto: talitos/aead - Use macro for algorithm
 definitions
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-17-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-17-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Replace the repetitive struct initializer entries in aead_driver_algs[]
> with preprocessor macros (TALITOS_AEAD_ALG, TALITOS_AEAD_ALG_HSNA).
> 
> Move the function pointer assignments (init, exit, encrypt, decrypt)
> from the registration loop into the static initializer, since they are
> identical for all algorithms.
> 
> The fallback setkey assignment (aead_alg->setkey ?: aead_setkey) is
> replaced by specifying the correct setkey handler directly in each macro
> invocation.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Wondering if we could go even more far with the COMMON flags, as for 
instance all TALITOS_AEAD_ALG_HSNA have DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU 
while TALITOS_AEAD_ALG have DESC_HDR_TYPE_IPSEC_ESP

> ---
>   drivers/crypto/talitos/talitos-aead.c | 751 ++++++++++------------------------
>   1 file changed, 218 insertions(+), 533 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
> index 38df616c9b22..cd1b8e6d371b 100644
> --- a/drivers/crypto/talitos/talitos-aead.c
> +++ b/drivers/crypto/talitos/talitos-aead.c
> @@ -405,535 +405,225 @@ static void talitos_cra_exit_aead(struct crypto_aead *tfm)
>   	talitos_cra_exit(crypto_aead_tfm(tfm));
>   }
>   
> +#define TALITOS_AEAD_ALG_COMMON(name, name_prefix, set_key, block_size, \
> +				max_auth_size, template, priority)      \
> +	{ \
> +		.type = CRYPTO_ALG_TYPE_AEAD, \
> +		.alg.aead = { \
> +			.base = { \
> +				.cra_name = name, \
> +				.cra_driver_name = name"-talitos"name_prefix, \
> +				.cra_blocksize = block_size, \
> +				.cra_flags = CRYPTO_ALG_ASYNC | \
> +					     CRYPTO_ALG_ALLOCATES_MEMORY | \
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY, \
> +				.cra_priority = (priority), \
> +				.cra_ctxsize = sizeof(struct talitos_ctx), \
> +				.cra_module = THIS_MODULE, \
> +			}, \
> +			.ivsize = block_size, \
> +			.maxauthsize = max_auth_size, \
> +			.setkey = set_key, \
> +			.init = talitos_cra_init_aead, \
> +			.exit = talitos_cra_exit_aead, \
> +			.encrypt = aead_encrypt, \
> +			.decrypt = aead_decrypt, \
> +		}, \
> +		.desc_hdr_template = template, \
> +	}
> +
> +#define TALITOS_AEAD_ALG(name, set_key, block_size, max_auth_size, template)  \
> +	TALITOS_AEAD_ALG_COMMON(name, "", set_key, block_size, max_auth_size, \
> +				template, TALITOS_CRA_PRIORITY)
> +
> +#define TALITOS_AEAD_ALG_HSNA(name, set_key, block_size, max_auth_size, \
> +			      template)                                 \
> +	TALITOS_AEAD_ALG_COMMON(name, "-hsna", set_key, block_size,     \
> +				max_auth_size, template,                \
> +				TALITOS_CRA_PRIORITY_AEAD_HSNA)
> +
>   static struct talitos_alg_template aead_driver_algs[] = {
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha1),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-aes-talitos",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA1_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha1),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-aes-talitos-hsna",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA1_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha1),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-3des-talitos",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA1_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha1),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-3des-talitos-hsna",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA1_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
> -	},
> -	{       .type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha224),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha224-"
> -						   "cbc-aes-talitos",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA224_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
> -	},
> -	{       .type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha224),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha224-"
> -						   "cbc-aes-talitos-hsna",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA224_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha224),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha224-"
> -						   "cbc-3des-talitos",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA224_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha224),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha224-"
> -						   "cbc-3des-talitos-hsna",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA224_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha256),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha256-"
> -						   "cbc-aes-talitos",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA256_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha256),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha256-"
> -						   "cbc-aes-talitos-hsna",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA256_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha256),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha256-"
> -						   "cbc-3des-talitos",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA256_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha256),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha256-"
> -						   "cbc-3des-talitos-hsna",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA256_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha384),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha384-"
> -						   "cbc-aes-talitos",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA384_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUB |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha384),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha384-"
> -						   "cbc-3des-talitos",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA384_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUB |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha512),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-sha512-"
> -						   "cbc-aes-talitos",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = SHA512_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUB |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(sha512),"
> -					    "cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-sha512-"
> -						   "cbc-3des-talitos",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = SHA512_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUB |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(md5),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-md5-"
> -						   "cbc-aes-talitos",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = MD5_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(md5),cbc(aes))",
> -				.cra_driver_name = "authenc-hmac-md5-"
> -						   "cbc-aes-talitos-hsna",
> -				.cra_blocksize = AES_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = AES_BLOCK_SIZE,
> -			.maxauthsize = MD5_DIGEST_SIZE,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-md5-"
> -						   "cbc-3des-talitos",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = MD5_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.alg.aead = {
> -			.base = {
> -				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
> -				.cra_driver_name = "authenc-hmac-md5-"
> -						   "cbc-3des-talitos-hsna",
> -				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> -				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> -				.cra_ctxsize = sizeof(struct talitos_ctx),
> -				.cra_module = THIS_MODULE,
> -			},
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.maxauthsize = MD5_DIGEST_SIZE,
> -			.setkey = aead_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> -	},
> +	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
> +
> +	/* sha1 auth */
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(aes))", aead_setkey,
> +			 AES_BLOCK_SIZE, SHA1_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(sha1),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
> +		SHA1_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(des3_ede))", aead_des3_setkey,
> +			 DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
> +				 DESC_HDR_MODE0_DEU_CBC |
> +				 DESC_HDR_MODE0_DEU_3DES | DESC_HDR_SEL1_MDEUA |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(sha1),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
> +
> +	/* sha224 auth */
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(sha224),cbc(aes))", aead_setkey,
> +			 AES_BLOCK_SIZE, SHA224_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEU_SHA224_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(sha224),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
> +		SHA224_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
> +
> +	TALITOS_AEAD_ALG(
> +		"authenc(hmac(sha224),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(sha224),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
> +
> +	/* sha256 auth */
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(sha256),cbc(aes))", aead_setkey,
> +			 AES_BLOCK_SIZE, SHA256_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEU_SHA256_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(sha256),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
> +		SHA256_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
> +
> +	TALITOS_AEAD_ALG(
> +		"authenc(hmac(sha256),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(sha256),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
> +
> +	/* sha384 auth */
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(sha384),cbc(aes))", aead_setkey,
> +			 AES_BLOCK_SIZE, SHA384_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
> +
> +	TALITOS_AEAD_ALG(
> +		"authenc(hmac(sha384),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA384_DIGEST_SIZE,
> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
> +
> +	/* sha512 auth */
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(sha512),cbc(aes))", aead_setkey,
> +			 AES_BLOCK_SIZE, SHA512_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
> +
> +	TALITOS_AEAD_ALG(
> +		"authenc(hmac(sha512),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, SHA512_DIGEST_SIZE,
> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
> +
> +	/* md5 auth */
> +
> +	TALITOS_AEAD_ALG("authenc(hmac(md5),cbc(aes))", aead_setkey,
> +			 AES_BLOCK_SIZE, MD5_DIGEST_SIZE,
> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +				 DESC_HDR_MODE1_MDEU_INIT |
> +				 DESC_HDR_MODE1_MDEU_PAD |
> +				 DESC_HDR_MODE1_MDEU_MD5_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(md5),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
> +		MD5_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_MD5_HMAC),
> +
> +	TALITOS_AEAD_ALG(
> +		"authenc(hmac(md5),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
> +
> +	TALITOS_AEAD_ALG_HSNA(
> +		"authenc(hmac(md5),cbc(des3_ede))", aead_des3_setkey,
> +		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
>   };
>   
>   int talitos_register_aead(struct device *dev)
> @@ -955,11 +645,6 @@ int talitos_register_aead(struct device *dev)
>   		if (has_ftr_sec1(priv))
>   			alg->cra_alignmask = 3;
>   
> -		aead_alg->init = talitos_cra_init_aead;
> -		aead_alg->exit = talitos_cra_exit_aead;
> -		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
> -		aead_alg->encrypt = aead_encrypt;
> -		aead_alg->decrypt = aead_decrypt;
>   		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
>   		    !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
>   			continue;
> 


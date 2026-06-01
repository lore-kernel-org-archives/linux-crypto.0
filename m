Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA21348C66;
	Mon,  1 Jun 2026 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315363; cv=none; b=TBA0Ej/8udi7rkQbGhWxwS6WRzUaV2f3zBw+ROdlCpK0p2aSCqW7rdAhn9JNBaKvtJRau0mt8lO2/ZeLdE9RVFD7wgtfGRDX3UoUKRu3tf884bqH0+9lR1eIlItDiKwN4Fu31g3v65tcd3o4oHaWDxJHMkTVVGHzqvwhFUOW7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315363; c=relaxed/simple;
	bh=Wlh/M8CLpDdWA/krbCUs8zF9lWbsDI4fk/LDZG2PvlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JnWmTG5/igeZ7qf7mOGsvkdXaaX11/Co9tHvuImEA9oBSs/10iOZdhT+yqF1RAV6lx2y+oSR9/aoy2RIbVm9NlBvxZOhpnRfNGkBmh42VEYS5UmdQMIreehrHIq668rvScYP5LHPM5JhSfomLYkqgC8RB5Dq3JMGAd6xOLDWsEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKkiiSkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKkiiSkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1771F00893;
	Mon,  1 Jun 2026 12:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315362;
	bh=0ieTT7PJ6Y9I8Mw8myl5veBPGL/Ah5nl2I45HaryrRY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TKkiiSkwtAlZkpi62keH+s5YQqXLDsiS3+eOQ0bBRmdjS40WNuSrEIMI3A1tNjKh5
	 MWxWCt8E2uY5sKKkaAONavL192WNTMeSvODql7cDFmlzKTTZypMxXCvFzie6QFK5Mx
	 sn2RXWSXldYbnSzR1wfuuJ6tNGF4nwt/taczeyOYRyb2LlyneaCJKpuFbMJM1rtXvM
	 e1DJlcvEr6g/K8uNEdFMvhFe9TwbEV+yvBcAfhtXKG7dsfNNdj0xgXavwXq4B7z9WG
	 +jPNzC7nNlum56WE/ECChkOUszVC5Xlz5OnOcS90zxFJ3JuoQbbT8xEzQV3xApNbr7
	 ic8lVc5I3/iRw==
Message-ID: <2ef112b2-a217-4c45-97e8-76bfc747a7c4@kernel.org>
Date: Mon, 1 Jun 2026 14:02:38 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/29] crypto: talitos/skcipher - Use macro for algorithm
 definitions
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-16-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-16-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Replace the repetitive struct initializer entries in
> skcipher_driver_algs[] with preprocessor macros
> (TALITOS_SKCIPHER_ALG_AES, TALITOS_SKCIPHER_ALG_DES,
> TALITOS_SKCIPHER_ALG_DES3).
> 
> Move the function pointer assignments (init, exit, encrypt, decrypt)
> from the registration loop into the static initializer, since they are
> identical for all algorithms.
> 
> The fallback setkey assignment (skcipher_alg->setkey ?: skcipher_setkey)
> is no longer needed because each macro specifies the correct setkey
> handler directly.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/talitos/talitos-skcipher.c | 244 ++++++++++--------------------
>   1 file changed, 82 insertions(+), 162 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
> index f86a0a9a0ffe..b12191243aae 100644
> --- a/drivers/crypto/talitos/talitos-skcipher.c
> +++ b/drivers/crypto/talitos/talitos-skcipher.c
> @@ -237,163 +237,89 @@ static void talitos_cra_exit_skcipher(struct crypto_skcipher *tfm)
>   	talitos_cra_exit(crypto_skcipher_tfm(tfm));
>   }
>   
> +#define TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, min_ksz, max_ksz, \
> +				    set_key, desc_template)                \
> +	{ \
> +		.type = CRYPTO_ALG_TYPE_SKCIPHER, \
> +		.alg.skcipher = { \
> +			.base.cra_name = name, \
> +			.base.cra_driver_name = name"-talitos", \
> +			.base.cra_blocksize = blk_sz, \
> +			.base.cra_flags = CRYPTO_ALG_ASYNC | \
> +					  CRYPTO_ALG_ALLOCATES_MEMORY | \
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY, \
> +			.base.cra_priority = TALITOS_CRA_PRIORITY, \
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx), \
> +			.base.cra_module = THIS_MODULE, \
> +			.min_keysize = min_ksz, \
> +			.max_keysize = max_ksz, \
> +			.ivsize = iv_sz, \
> +			.setkey = set_key, \
> +			.init = talitos_cra_init_skcipher, \
> +			.exit = talitos_cra_exit_skcipher, \
> +			.encrypt = skcipher_encrypt, \
> +			.decrypt = skcipher_decrypt, \
> +		}, \
> +		.desc_hdr_template = desc_template, \
> +	}
> +
> +#define TALITOS_SKCIPHER_ALG_AES(name, blk_sz, iv_sz, desc_template)       \
> +	TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, AES_MIN_KEY_SIZE, \
> +				    AES_MAX_KEY_SIZE, skcipher_aes_setkey, \
> +				    desc_template)
> +
> +#define TALITOS_SKCIPHER_ALG_DES(name, blk_sz, iv_sz, desc_template)   \
> +	TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, DES_KEY_SIZE, \
> +				    DES_KEY_SIZE, skcipher_des_setkey, \
> +				    desc_template)
> +
> +#define TALITOS_SKCIPHER_ALG_DES3(name, blk_sz, iv_sz, desc_template)        \
> +	TALITOS_SKCIPHER_ALG_COMMON(name, blk_sz, iv_sz, DES3_EDE_KEY_SIZE,  \
> +				    DES3_EDE_KEY_SIZE, skcipher_des3_setkey, \
> +				    desc_template)
> +
>   static struct talitos_alg_template skcipher_driver_algs[] = {
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "ecb(aes)",
> -			.base.cra_driver_name = "ecb-aes-talitos",
> -			.base.cra_blocksize = AES_BLOCK_SIZE,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = AES_MIN_KEY_SIZE,
> -			.max_keysize = AES_MAX_KEY_SIZE,
> -			.setkey = skcipher_aes_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "cbc(aes)",
> -			.base.cra_driver_name = "cbc-aes-talitos",
> -			.base.cra_blocksize = AES_BLOCK_SIZE,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = AES_MIN_KEY_SIZE,
> -			.max_keysize = AES_MAX_KEY_SIZE,
> -			.ivsize = AES_BLOCK_SIZE,
> -			.setkey = skcipher_aes_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "ctr(aes)",
> -			.base.cra_driver_name = "ctr-aes-talitos",
> -			.base.cra_blocksize = 1,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = AES_MIN_KEY_SIZE,
> -			.max_keysize = AES_MAX_KEY_SIZE,
> -			.ivsize = AES_BLOCK_SIZE,
> -			.setkey = skcipher_aes_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CTR,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "ctr(aes)",
> -			.base.cra_driver_name = "ctr-aes-talitos",
> -			.base.cra_blocksize = 1,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = AES_MIN_KEY_SIZE,
> -			.max_keysize = AES_MAX_KEY_SIZE,
> -			.ivsize = AES_BLOCK_SIZE,
> -			.setkey = skcipher_aes_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CTR,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "ecb(des)",
> -			.base.cra_driver_name = "ecb-des-talitos",
> -			.base.cra_blocksize = DES_BLOCK_SIZE,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = DES_KEY_SIZE,
> -			.max_keysize = DES_KEY_SIZE,
> -			.setkey = skcipher_des_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "cbc(des)",
> -			.base.cra_driver_name = "cbc-des-talitos",
> -			.base.cra_blocksize = DES_BLOCK_SIZE,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = DES_KEY_SIZE,
> -			.max_keysize = DES_KEY_SIZE,
> -			.ivsize = DES_BLOCK_SIZE,
> -			.setkey = skcipher_des_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "ecb(des3_ede)",
> -			.base.cra_driver_name = "ecb-3des-talitos",
> -			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = DES3_EDE_KEY_SIZE,
> -			.max_keysize = DES3_EDE_KEY_SIZE,
> -			.setkey = skcipher_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_3DES,
> -	},
> -	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
> -		.alg.skcipher = {
> -			.base.cra_name = "cbc(des3_ede)",
> -			.base.cra_driver_name = "cbc-3des-talitos",
> -			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> -			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY |
> -					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> -			.base.cra_priority = TALITOS_CRA_PRIORITY,
> -			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> -			.base.cra_module = THIS_MODULE,
> -			.min_keysize = DES3_EDE_KEY_SIZE,
> -			.max_keysize = DES3_EDE_KEY_SIZE,
> -			.ivsize = DES3_EDE_BLOCK_SIZE,
> -			.setkey = skcipher_des3_setkey,
> -		},
> -		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES,
> -	},
> +	/* AES */
> +
> +	TALITOS_SKCIPHER_ALG_AES("ecb(aes)", AES_BLOCK_SIZE, 0,
> +				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					 DESC_HDR_SEL0_AESU),
> +
> +	TALITOS_SKCIPHER_ALG_AES("cbc(aes)", AES_BLOCK_SIZE, AES_BLOCK_SIZE,
> +				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					 DESC_HDR_SEL0_AESU |
> +					 DESC_HDR_MODE0_AESU_CBC),
> +
> +	TALITOS_SKCIPHER_ALG_AES("ctr(aes)", 1, AES_BLOCK_SIZE,
> +				 DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
> +					 DESC_HDR_SEL0_AESU |
> +					 DESC_HDR_MODE0_AESU_CTR),
> +
> +	TALITOS_SKCIPHER_ALG_AES("ctr(aes)", 1, AES_BLOCK_SIZE,
> +				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					 DESC_HDR_SEL0_AESU |
> +					 DESC_HDR_MODE0_AESU_CTR),
> +	/* DES */
> +
> +	TALITOS_SKCIPHER_ALG_DES("ecb(des)", DES_BLOCK_SIZE, 0,
> +				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					 DESC_HDR_SEL0_DEU),
> +
> +	TALITOS_SKCIPHER_ALG_DES("cbc(des)", DES_BLOCK_SIZE, DES_BLOCK_SIZE,
> +				 DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					 DESC_HDR_SEL0_DEU |
> +					 DESC_HDR_MODE0_DEU_CBC),
> +	/* DES3 */
> +
> +	TALITOS_SKCIPHER_ALG_DES3("ecb(des3_ede)", DES3_EDE_BLOCK_SIZE, 0,
> +				  DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> +					  DESC_HDR_SEL0_DEU |
> +					  DESC_HDR_MODE0_DEU_3DES),
> +
> +	TALITOS_SKCIPHER_ALG_DES3(
> +		"cbc(des3_ede)", DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE,
> +		DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES),
>   };
>   
>   int talitos_register_skcipher(struct device *dev)
> @@ -415,12 +341,6 @@ int talitos_register_skcipher(struct device *dev)
>   		if (has_ftr_sec1(priv))
>   			alg->cra_alignmask = 3;
>   
> -		skcipher_alg->init = talitos_cra_init_skcipher;
> -		skcipher_alg->exit = talitos_cra_exit_skcipher;
> -		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
> -		skcipher_alg->encrypt = skcipher_encrypt;
> -		skcipher_alg->decrypt = skcipher_decrypt;
> -
>   		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
>   		    DESC_TYPE(skcipher_driver_algs[i].desc_hdr_template) !=
>   			    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {
> 


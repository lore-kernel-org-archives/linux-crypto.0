Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AA91DA60D;
	Mon,  1 Jun 2026 11:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780314833; cv=none; b=InI59YNUrIUt8CkumLJsqUzblr864QGmR5y4K97Lbe4Sh/wekllmaIONUD7af9YTuSLZay45IFZint5zlEv1CZZeAMKK382p5xvOvl9TRx51rf74HC7iKbW68/mpfqHxROEvbGqYmyA84g8VAYqeYu4sc/bRDcs3fDdEeed2YcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780314833; c=relaxed/simple;
	bh=suChEY7fFbjuVRd8ln9Wmj+nQCEGNJJ2svYD2Q19Q5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SN3P29+0FoIwHOmJaQh9AKyvfFmdzx7qmPgsyNLeRLz6wcUcoA93nLRohTFCigYsZXFSnPT0rYx15I3mDSdW1Jp+aiGzaaHHEGdIRjynn1VD+DHShU9XhBs2bJq99n7Ub4gEoXBPw/ijiUCV+c8fSU8kTyRw2CfS2b2jhA4VDJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrLeIjpt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrLeIjpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FE51F00893;
	Mon,  1 Jun 2026 11:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780314831;
	bh=P+OkIU8cmYQc5e3C1YrhvhQOo1/nTKZDXw8hXEOy7AU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jrLeIjptTGQ2L86YMiVScjpSJ6aR0XVxLWY9w1TYlMp1VC97UMzR/JemMLQ2/1Ka6
	 blWteiy0U7mmx0ZkBmQUhkOdUBNP1X9Mh634Ea/etQCLo7z4EXAyfLjRNdeOfmJ/UQ
	 XTDMnhPstJn2MdAg/ayeRzUfXTKwJ2t0EG3g0JLrWs7SAfgulkaqrNpSwoaApfGYM+
	 EilesFcfp6ykee4Kqideu647itjpVmH6UcImjCMGvkj9LIvZ1I/Kg7h/QiNLxLIcuq
	 94fEC9YGLtbNN6FWbaqXHumXXQO0bTNs9g21SwNJzCiRN9hgFkj2FhPhPrnk0JznJS
	 QrP6KGh5Auwdg==
Message-ID: <d98bd2ad-fba2-49f4-97e0-1dfb559ea419@kernel.org>
Date: Mon, 1 Jun 2026 13:53:48 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/29] crypto: talitos - Remove alg settings in
 talitos_register_common()
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-10-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-10-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Algorithm properties should be set at definition time.

Can you provide more details on why it _should_ be set at definition time ?

Also, couldn't this change be done after the "Use macro for algorithm 
definitions" patches in order to minimise churn ?

> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   drivers/crypto/talitos/talitos-aead.c     | 131 +++++++++++++++++++++++-------
>   drivers/crypto/talitos/talitos-hash.c     |  72 +++++++++++++---
>   drivers/crypto/talitos/talitos-skcipher.c |  51 ++++++++++--
>   drivers/crypto/talitos/talitos.c          |  23 ------
>   4 files changed, 206 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
> index ce6bd6133fd0..c09ed08be2ef 100644
> --- a/drivers/crypto/talitos/talitos-aead.c
> +++ b/drivers/crypto/talitos/talitos-aead.c
> @@ -409,7 +409,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA1_DIGEST_SIZE,
> @@ -423,7 +427,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha1),cbc(aes))",
> @@ -431,7 +434,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA1_DIGEST_SIZE,
> @@ -453,7 +460,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA1_DIGEST_SIZE,
> @@ -469,7 +480,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha1),"
> @@ -478,7 +488,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA1_DIGEST_SIZE,
> @@ -501,7 +515,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA224_DIGEST_SIZE,
> @@ -515,7 +533,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>   	},
>   	{       .type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha224),cbc(aes))",
> @@ -523,7 +540,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA224_DIGEST_SIZE,
> @@ -545,7 +566,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA224_DIGEST_SIZE,
> @@ -561,7 +586,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha224),"
> @@ -570,7 +594,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA224_DIGEST_SIZE,
> @@ -593,7 +621,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA256_DIGEST_SIZE,
> @@ -607,7 +639,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha256),cbc(aes))",
> @@ -615,7 +646,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA256_DIGEST_SIZE,
> @@ -637,7 +672,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA256_DIGEST_SIZE,
> @@ -653,7 +692,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha256),"
> @@ -662,7 +700,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA256_DIGEST_SIZE,
> @@ -685,7 +727,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA384_DIGEST_SIZE,
> @@ -707,7 +753,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA384_DIGEST_SIZE,
> @@ -730,7 +780,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = SHA512_DIGEST_SIZE,
> @@ -752,7 +806,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = SHA512_DIGEST_SIZE,
> @@ -775,7 +833,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = MD5_DIGEST_SIZE,
> @@ -789,7 +851,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(md5),cbc(aes))",
> @@ -797,7 +858,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = AES_BLOCK_SIZE,
>   			.maxauthsize = MD5_DIGEST_SIZE,
> @@ -818,7 +883,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = MD5_DIGEST_SIZE,
> @@ -834,7 +903,6 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>   	},
>   	{	.type = CRYPTO_ALG_TYPE_AEAD,
> -		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
>   		.alg.aead = {
>   			.base = {
>   				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
> @@ -842,7 +910,11 @@ static struct talitos_alg_template aead_driver_algs[] = {
>   						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC |
> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
> +				.cra_priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			},
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
>   			.maxauthsize = MD5_DIGEST_SIZE,
> @@ -875,6 +947,9 @@ int talitos_register_aead(struct device *dev)
>   		aead_alg = &aead_driver_algs[i].alg.aead;
>   		alg = &aead_alg->base;
>   
> +		if (has_ftr_sec1(priv))
> +			alg->cra_alignmask = 3;
> +
>   		alg->cra_exit = talitos_cra_exit;
>   		aead_alg->init = talitos_cra_init_aead;
>   		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
> diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
> index 5792e7093392..3793b6fd5b75 100644
> --- a/drivers/crypto/talitos/talitos-hash.c
> +++ b/drivers/crypto/talitos/talitos-hash.c
> @@ -559,8 +559,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -578,8 +582,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -597,8 +605,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -616,8 +628,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -635,8 +651,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -654,8 +674,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -673,8 +697,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -692,8 +720,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -711,8 +743,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -730,8 +766,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -749,8 +789,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -768,8 +812,12 @@ static struct talitos_alg_template hash_driver_algs[] = {
>   				.cra_reqsize = sizeof(struct talitos_ahash_req_ctx),
>   				.cra_flags = CRYPTO_ALG_ASYNC |
>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
> +				.cra_priority = TALITOS_CRA_PRIORITY,
> +				.cra_ctxsize = sizeof(struct talitos_ctx),
> +				.cra_module = THIS_MODULE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
> index 4f742930ec47..ff7b8f9344c4 100644
> --- a/drivers/crypto/talitos/talitos-skcipher.c
> +++ b/drivers/crypto/talitos/talitos-skcipher.c
> @@ -239,7 +239,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "ecb-aes-talitos",
>   			.base.cra_blocksize = AES_BLOCK_SIZE,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = AES_MIN_KEY_SIZE,
>   			.max_keysize = AES_MAX_KEY_SIZE,
>   			.setkey = skcipher_aes_setkey,
> @@ -253,7 +257,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "cbc-aes-talitos",
>   			.base.cra_blocksize = AES_BLOCK_SIZE,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = AES_MIN_KEY_SIZE,
>   			.max_keysize = AES_MAX_KEY_SIZE,
>   			.ivsize = AES_BLOCK_SIZE,
> @@ -269,7 +277,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "ctr-aes-talitos",
>   			.base.cra_blocksize = 1,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = AES_MIN_KEY_SIZE,
>   			.max_keysize = AES_MAX_KEY_SIZE,
>   			.ivsize = AES_BLOCK_SIZE,
> @@ -285,7 +297,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "ctr-aes-talitos",
>   			.base.cra_blocksize = 1,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = AES_MIN_KEY_SIZE,
>   			.max_keysize = AES_MAX_KEY_SIZE,
>   			.ivsize = AES_BLOCK_SIZE,
> @@ -301,7 +317,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "ecb-des-talitos",
>   			.base.cra_blocksize = DES_BLOCK_SIZE,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = DES_KEY_SIZE,
>   			.max_keysize = DES_KEY_SIZE,
>   			.setkey = skcipher_des_setkey,
> @@ -315,7 +335,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "cbc-des-talitos",
>   			.base.cra_blocksize = DES_BLOCK_SIZE,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = DES_KEY_SIZE,
>   			.max_keysize = DES_KEY_SIZE,
>   			.ivsize = DES_BLOCK_SIZE,
> @@ -331,7 +355,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "ecb-3des-talitos",
>   			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = DES3_EDE_KEY_SIZE,
>   			.max_keysize = DES3_EDE_KEY_SIZE,
>   			.setkey = skcipher_des3_setkey,
> @@ -346,7 +374,11 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
>   			.base.cra_driver_name = "cbc-3des-talitos",
>   			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   			.base.cra_flags = CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
> +			.base.cra_priority = TALITOS_CRA_PRIORITY,
> +			.base.cra_ctxsize = sizeof(struct talitos_ctx),
> +			.base.cra_module = THIS_MODULE,
>   			.min_keysize = DES3_EDE_KEY_SIZE,
>   			.max_keysize = DES3_EDE_KEY_SIZE,
>   			.ivsize = DES3_EDE_BLOCK_SIZE,
> @@ -375,6 +407,9 @@ int talitos_register_skcipher(struct device *dev)
>   		skcipher_alg = &skcipher_driver_algs[i].alg.skcipher;
>   		alg = &skcipher_alg->base;
>   
> +		if (has_ftr_sec1(priv))
> +			alg->cra_alignmask = 3;
> +
>   		alg->cra_exit = talitos_cra_exit;
>   		skcipher_alg->init = talitos_cra_init_skcipher;
>   		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index 41d7d0e570e3..f38a156a0459 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -1133,23 +1133,6 @@ static void talitos_remove(struct platform_device *ofdev)
>   		tasklet_kill(&priv->done_task[1]);
>   }
>   
> -static void talitos_alg_set_common(struct talitos_private *priv,
> -				   struct crypto_alg *alg, u32 custom_priority,
> -				   u32 type)
> -{
> -	alg->cra_module = THIS_MODULE;
> -	if (custom_priority)
> -		alg->cra_priority = custom_priority;
> -	else
> -		alg->cra_priority = TALITOS_CRA_PRIORITY;
> -	if (has_ftr_sec1(priv) && type != CRYPTO_ALG_TYPE_AHASH)
> -		alg->cra_alignmask = 3;
> -	else
> -		alg->cra_alignmask = 0;
> -	alg->cra_ctxsize = sizeof(struct talitos_ctx);
> -	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
> -}
> -
>   int talitos_register_common(struct device *dev,
>   			    struct talitos_alg_template *template)
>   {
> @@ -1168,20 +1151,14 @@ int talitos_register_common(struct device *dev,
>   	switch (t_alg->algt.type) {
>   	case CRYPTO_ALG_TYPE_AHASH:
>   		alg = &t_alg->algt.alg.hash.halg.base;
> -		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
> -				       t_alg->algt.type);
>   		ret = crypto_register_ahash(&t_alg->algt.alg.hash);
>   		break;
>   	case CRYPTO_ALG_TYPE_SKCIPHER:
>   		alg = &t_alg->algt.alg.skcipher.base;
> -		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
> -				       t_alg->algt.type);
>   		ret = crypto_register_skcipher(&t_alg->algt.alg.skcipher);
>   		break;
>   	case CRYPTO_ALG_TYPE_AEAD:
>   		alg = &t_alg->algt.alg.aead.base;
> -		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
> -				       t_alg->algt.type);
>   		ret = crypto_register_aead(&t_alg->algt.alg.aead);
>   		break;
>   	default:
> 


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C78231A572;
	Mon,  1 Jun 2026 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315070; cv=none; b=QH+3WpxX7FAkPDht6ERT4C5558BUtSG39wyuy3Bo72uG3PLoU9Ednbdp/0HT23eEUlMyEzwMcjnEUQ5hA0EVFQAHfb9X+72mbEcE3Z6TKnO55dPF6fgI+kSLt6At2fN4+Tx2ZHdoVmWK0zSFBzJeBcLuJvq8KM88FNZp09185tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315070; c=relaxed/simple;
	bh=iZmkuhoTx80hTEGlAyO8gKKDHbP7cCZRtPc6TYLu2iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sCPZOG7Td5qZGNkMbchhMpbfUwComCANFn4ZOScCba2DxREJcWdJMqyxX5XYfm1io1jqVoRPsPcvmcMWCXj2Za3H7J6YTdknAg4Hvqv6NJCoVq+1LwQGPSBzrjqtlG68C29pRdZqAyT4wTLWEwWIW1PtLQcU/lfHqD8o0KJw7ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXvFhLHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXvFhLHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9D71F00893;
	Mon,  1 Jun 2026 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315069;
	bh=KYU4hs5toz/1ps7mH6SpfbpGZddUskcmwpSpDR+3dDo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AXvFhLHSApCE6fQt+uipOJab2sG7555sQmQCs+5AeP170tjgPufg9M9MNxy3Q6kIt
	 oV+Ng+qKtW8nqViVrjvbeHjNvpPtIb1Icfuia9UWvUGqLFXe9rzsclFNzeSBinjfVZ
	 QLRSCKTkQiC1vzwoT3r0cV5nuVdXJ9gulejE1JKqW4vO/ATmiVKQSSCI8759VTwsOY
	 YBdt8E8vAA0p8CAvfEJiL56jM053kUeo/tqaEpAMsbLdUqMyFlEUAf01JWFJmLfLFK
	 4JpStxvPDfGnJoG5VwljUh8lyqTnMEULq6sqmQyDVVZ2WprN0HamLT/bLK1KOiIOfO
	 Fmjh1pUy/7PnQ==
Message-ID: <8e2de0a8-a1e2-4316-9f80-4a137a04b41f@kernel.org>
Date: Mon, 1 Jun 2026 13:57:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/29] crypto: talitos/hash - Convert to init_tfm/exit_tfm
 type-specific API
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-12-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-12-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
> deprecated"), both cra_{init,exit} are deprecated.
> 
> Switch hash from the deprecated cra_init/cra_exit fields on crypto_alg
> to the preferred init_tfm/exit_tfm fields on ahash_alg.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/talitos/talitos-hash.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
> index 3793b6fd5b75..f7f6f01cfddf 100644
> --- a/drivers/crypto/talitos/talitos-hash.c
> +++ b/drivers/crypto/talitos/talitos-hash.c
> @@ -531,22 +531,26 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
>   	return 0;
>   }
>   
> -static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
> +static int talitos_cra_init_ahash(struct crypto_ahash *tfm)
>   {
> -	struct crypto_alg *alg = tfm->__crt_alg;
> +	struct ahash_alg *alg = crypto_ahash_alg(tfm);
>   	struct talitos_crypto_alg *talitos_alg;
> -	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
>   
> -	talitos_alg = container_of(__crypto_ahash_alg(alg),
> +	talitos_alg = container_of(alg,
>   				   struct talitos_crypto_alg,
>   				   algt.alg.hash);
>   
>   	ctx->keylen = 0;
> -				 sizeof(struct talitos_ahash_req_ctx));

Should be in patch 1 ?

>   
>   	return talitos_init_common(ctx, talitos_alg);
>   }
>   
> +static void talitos_cra_exit_ahash(struct crypto_ahash *tfm)
> +{
> +	talitos_cra_exit(crypto_ahash_tfm(tfm));
> +}
> +
>   static struct talitos_alg_template hash_driver_algs[] = {
>   	{	.type = CRYPTO_ALG_TYPE_AHASH,
>   		.alg.hash = {
> @@ -842,8 +846,8 @@ int talitos_register_hash(struct device *dev)
>   		ahash_alg = &hash_driver_algs[i].alg.hash;
>   		alg = &ahash_alg->halg.base;
>   
> -		alg->cra_init = talitos_cra_init_ahash;
> -		alg->cra_exit = talitos_cra_exit;
> +		ahash_alg->init_tfm = talitos_cra_init_ahash;
> +		ahash_alg->exit_tfm = talitos_cra_exit_ahash;
>   		ahash_alg->init = ahash_init;
>   		ahash_alg->update = ahash_update;
>   		ahash_alg->final = ahash_final;
> 


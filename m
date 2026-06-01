Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3EA1DA60D;
	Mon,  1 Jun 2026 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315111; cv=none; b=bnUbEtA2SfGWxZBfYlZkG3v4E36bY1WhMiBNRg+pDnr4sdFyNAWwFVo9lIvMaC19vKK80SbYvsGgW4ta+uB+cVFAfp/iUz4FFPAarHhRG8x8drA4xBuzwQAwikkAduXWhghbScJlSQ+etlxhpLYBIFixtCoBinIYPya9j10OXjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315111; c=relaxed/simple;
	bh=oz5zQMYjFEhFj0m3ga234drC83+IK3p2NNXfLsDmElM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qchZc2l2w5Fd3sEzYQKJ0ofRr7OibR3K2BdOLPsMWijcwuWYTRWbwntmhNtREDLPSyNBiZVw4+cwUCR3JddC8m77GWjUWZVaABaRX3CzCLMeSKq9O+QmJZ9c0PV2FoxiFe6ognTOruJ1ZSok6IHEca2BYIHrE6dYWPM7sXknrw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghqSBuod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghqSBuod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EFA1F00893;
	Mon,  1 Jun 2026 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315110;
	bh=CCsie/r7pg4r3EDXexbjZRKYURJPJXOE1+nQRENck2c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ghqSBuodx52y6TIkZDvY9BFTIAYhMUdoMbsFe2js/fM79SXVjvQXKa7m04TFexQ7W
	 n55c04/99r+GAAMjHbCjT61xG3DStPmp+Zp/57I2ORh+4rROB/k+DyyaLcYzpgXrBN
	 moXZZy+63pbdCQeinsTpEoTPgQ3a/lAhwSNs1sGSTFgKkrRR0ByPvzr6aEIbaRXe7W
	 Bpk0M55uvAUvTjpnlC1rAC0AMKoHpywFQnTDxMm/35HG/Z9p7gxVxW210jcvZhhOoN
	 cfsufCkvc40g9yVZvIsPsy1s9I9MpJpTZgbCktEggS6edt94/vTh4A2EZf3qxDOLeT
	 Z+8cTkEKo5sLQ==
Message-ID: <2fca7e9e-8e91-408f-a588-dd83e625b042@kernel.org>
Date: Mon, 1 Jun 2026 13:58:25 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/29] crypto: talitos/skcipher - Convert to init/exit
 type-specific API
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-13-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-13-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
> deprecated"), both cra_{init,exit} are deprecated.
> 
> Restore the type-specific talitos_cra_exit_skcipher() wrapper and use
> skcipher_alg->exit instead of the generic cra_exit field, matching the
> pattern used by init.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/talitos/talitos-skcipher.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
> index ff7b8f9344c4..f86a0a9a0ffe 100644
> --- a/drivers/crypto/talitos/talitos-skcipher.c
> +++ b/drivers/crypto/talitos/talitos-skcipher.c
> @@ -232,6 +232,11 @@ static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
>   	return talitos_init_common(ctx, talitos_alg);
>   }
>   
> +static void talitos_cra_exit_skcipher(struct crypto_skcipher *tfm)
> +{
> +	talitos_cra_exit(crypto_skcipher_tfm(tfm));
> +}
> +
>   static struct talitos_alg_template skcipher_driver_algs[] = {
>   	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
>   		.alg.skcipher = {
> @@ -410,8 +415,8 @@ int talitos_register_skcipher(struct device *dev)
>   		if (has_ftr_sec1(priv))
>   			alg->cra_alignmask = 3;
>   
> -		alg->cra_exit = talitos_cra_exit;
>   		skcipher_alg->init = talitos_cra_init_skcipher;
> +		skcipher_alg->exit = talitos_cra_exit_skcipher;
>   		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
>   		skcipher_alg->encrypt = skcipher_encrypt;
>   		skcipher_alg->decrypt = skcipher_decrypt;
> 


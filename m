Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794290027;
	b=5FWAWZSw4ZoQ3DY3UvyLLvleqjesIdSnbhuT3+o8rhkyKmKtIDU7UTqLGUK27ctpOjuU
	 /v+NLCubFyoACWF37TTjF8Z3lrvL9LwBFWrWHAGpGz/Z15jqVBEv2JdQiazPsS7nJgKVi
	 aw3OAk0e4T5B7TV+JuIYG8CeVpQ+7nQK3QZTdLuWbBmHyXl9pbrxA0qImjRMY1iiJjEN2
	 fZdYIx3cHdyH/OcLIaObVk9QduAH92IhKL2qvxgXcXPU/Q/+7vyqOsW5uoyKQe3WlHyW9
	 3sTfE0nPTpYyySw0sz5q73+Vz9qrHr9D92w11BjKG8FbPQcR2dYn9iaSMbfe66C3Vpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794290027;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gsngdIcF5BezJhiHCFR4oBshgT4Mp+hVmPTiOYWGUTE=;
	b=cws/p1qKLjtfxQz5CbtH9qhPCcuG4qByCWxXCkjd1ksxRhDVGwSkVsxdWxwsABJ5nMqL
	 JkLGPH2f3Lx2K6P9kOXYMbN7+m6Ocu3/7P+jIUAVwS6JqMrySiLwER2IDbdIBOYPEB9gH
	 rH3O8nhT19fdOJfjWIpCqfr/T7+m3lU6++SX1fWvk3M3SffSkETFq90qsIHiSNR7CfMUW
	 RbZfoymZeqN7B1Uy0R9HRspa6APS+tgn2Vt+r4vkNExPcc0UH+/4YsfkHPzNoZMdB7q+E
	 /XNuvZ953oo6AfREIdMgGLud8LKxgihqiwWbnXhpuZCZ4veBYXDxM3rDd7S+4o9qWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB30TmJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2696A606A333;
	Tue, 10 Nov 2026 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB30TmJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499CF1F008A1;
	Tue, 10 Nov 2026 05:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290026;
	bh=gsngdIcF5BezJhiHCFR4oBshgT4Mp+hVmPTiOYWGUTE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bB30TmJ7JJrLnS3fWRywvazws8Y2xpumBiByBDRtJdSoUFP9FtsceSExkeZslq6+n
	 gdTABPDONzRsF4M4dGFwe3sr5FBxSgHEfebNmziH0yZTRqj0GOVAqVdlvEmLRi6avq
	 oEodf6CES2umjFB8cNNKD3X7q4lRYgOrdMxJauDuogzOPQXl1s1MMh68xzoxwECI5T
	 HWW14l8KVa2ZPEcBuPq/SbDMQ9yTwjr0doOUxFe+FknYiILxXuWuDsmI2qLHZ+aNbQ
	 3koDaJAxItkbKw0Ja87ICk2+I1L3itp9gujFR6tVqDsK9oMGvydYACZE7MEgdLmxNU
	 XVvMxIz9uipCw==
Message-ID: <sashiko-outbox-206350@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: sun8i-ce - Add AES-XTS for the H616
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arun Iyengar" <aiyengar1990@gmail.com>, "Corentin Labbe" <clabbe.montjoie@gmail.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Chen-Yu
 Tsai" <wens@kernel.org>, "Jernej Skrabec" <jernej.skrabec@gmail.com>, "Samuel
 Holland" <samuel@sholland.org>
Cc: linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev
In-Reply-To: <20261110-sun8i-ce-h616-xts-v1-1-2fff3eb0807a@gmail.com>
References: <20261110-sun8i-ce-h616-xts-v1-1-2fff3eb0807a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:53:44 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: sun8i-ce: missing CRYPTO_XTS select fails
  sun8i_ce_cipher_init()
--

commit 660524c38c775c4edff2e13f8df35a02b4667a78
Author: Arun Iyengar <aiyengar1990@gmail.com>

crypto: sun8i-ce - Add AES-XTS for the H616

This commit adds AES-XTS support for the Allwinner H616 crypto engine
using its RAES unit and registers xts-aes-sun8i-ce with a fallback
transform.

> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/=
crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 21762bd408e54..a7d771927b7a1 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c

[ ... ]

> @@ -350,6 +350,36 @@ static struct sun8i_ce_alg_template ce_algs[] =3D {
>  		.do_one_request =3D sun8i_ce_cipher_do_one,
>  	},
>  },
> +{
> +	.type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> +	.ce_algo_id =3D CE_ID_CIPHER_AES,
> +	.ce_blockmode =3D CE_ID_OP_XTS,
> +	.alg.skcipher.base =3D {
> +		.base =3D {
> +			.cra_name =3D "xts(aes)",
> +			.cra_driver_name =3D "xts-aes-sun8i-ce",
> +			.cra_priority =3D CE_PRIO_BELOW_CPU,
> +			.cra_blocksize =3D AES_BLOCK_SIZE,
> +			.cra_flags =3D CRYPTO_ALG_TYPE_SKCIPHER |
> +				CRYPTO_ALG_ASYNC |
> +				CRYPTO_ALG_NEED_FALLBACK,
> +			.cra_ctxsize =3D sizeof(struct sun8i_cipher_tfm_ctx),
> +			.cra_module =3D THIS_MODULE,
> +			.cra_alignmask =3D 0xf,
> +			.cra_init =3D sun8i_ce_cipher_init,

[Severity: Medium]
Should CRYPTO_DEV_SUN8I_CE in drivers/crypto/allwinner/Kconfig select
CRYPTO_XTS alongside CRYPTO_ECB and CRYPTO_CBC?

sun8i_ce_cipher_init() unconditionally calls
crypto_alloc_skcipher("xts(aes)", 0, CRYPTO_ALG_NEED_FALLBACK) to allocate
op->fallback_tfm, which fails with -ENOENT during registration self-tests
or transform allocation when CONFIG_CRYPTO_XTS is disabled and no other
xts(aes) implementation is built in.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-sun8i-ce-h=
616-xts-v1-1-2fff3eb0807a@gmail.com?part=3D1

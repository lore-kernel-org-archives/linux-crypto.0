Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594227;
	b=o8eKFCTgC2WN1n8mxTgA0GUt+1QDphQ15va/xZFN58O7pGotWJ4ZIjrIr1swlHiSOuxp
	 JItV31OQ93dus2r17Rm6ENJILSHKawtDDu2xRFOyxXMRm37qlTtn0L9WR0Bgk4XomKwD4
	 RzwyRB5wbH5WAveN+yB2nMRT7zCzu5dxpwBySjx+1EVm7gPgBvJKrUjuE/saUY9FlbnvU
	 ang6HIb0ysRhUQlnorRA8dJOzbAIYxAgc0O2X4LI2tCjPH8nXWhzmOdObkRO4vZuISMBY
	 jAJB+4momhD0szTEjxGJFaDxbtCtLoerwPSY0nu7lUKc8jxLR1iZEOvuYLc1B9daScw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594227;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=I4ZLIwe7uulTo3bAK7TWGUOgBgf32EkyxUEsNl8JTn8=;
	b=SGpEQCMLvoLUUr//ef8/B1f3c0bYzpmiWiQxLGUPlFHFja0l1V9/OmmFFhGc0beEkPJp
	 4LYeacarh1LtN+3wM2Ee7jTnfdRma5g1RLqGXVVFN7y5vrlcDi9AgZB0VPvEgN4zgYc6E
	 24g7CFMRZYIoSjO9jHLo0f+061uyxsYz8ooyeZnOFJp5SdbSdAJrZyu8BjXN4gmY+2eFj
	 07R8W5RAYFRMjN+3ndqk8pIZKHwc+Nh0wAlsujpe2EMG1SZZ+Xf/iX5Mkri2IN8KXTzzT
	 Khl+smoYuRBepW14nGXVx3lPZw829LbZ6KsqnMNrJutEvFC2t9JIb/gsSZIETSvwjRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJpIsxMW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A5606A32D
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 08:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJpIsxMW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2ED1F00A00;
	Wed, 25 Nov 2026 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594226;
	bh=I4ZLIwe7uulTo3bAK7TWGUOgBgf32EkyxUEsNl8JTn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TJpIsxMWMgBAZ3lCuzaIgBppkMt54DU9moVp0fyfCnaJkQtH4wkojQMSYORcbNdXe
	 o9roNJSfdl1KxnR2N51764g53PFQQH/eq+Rm8c3k1NSMBmtYstVhEPdMjkIZ/2f0ES
	 rgoLgxZv3d2HLkHiBZXsGyA7dg4BIBWfJSoX4bPOC0SeWpOSQfnHAHi8tylAVcjpAQ
	 E4x+jQyQ6LpSxKJfVD5F7g6ZrT+Rz0CO8GzIIVIjostoFz2vkL3PUXhZaDXTUt6P53
	 TXJYxHGp0OapyYPo3kkWrDPLDYNnINsEw9bCcr5zkPRQdT89f/Knacy5Nad3xsGfsM
	 JOnq55SjzobPw==
Message-ID: <sashiko-outbox-232867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/11] crypto: ccp - add SM3 engine and ahash algorithms
Reply-To: sashiko-reviews@lists.linux.dev
To: "Depei Yang" <yangdepei@hygon.cn>, linux-crypto@vger.kernel.org
Cc: "Tom Lendacky" <thomas.lendacky@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Gary R Hook" <gary.hook@amd.com>, "Shan
 Chen" <chenshan@hygon.cn>, "Yongwei Xu" <xuyongwei@hygon.cn>, "Xiaochen
 Shen" <shenxiaochen@hygon.cn>
In-Reply-To: <7cc3e8096373670b553d0e469b245b444d295ff7.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
 <7cc3e8096373670b553d0e469b245b444d295ff7.1795588986.git.yangdepei@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 08:10:25 +0000
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
- [Medium] crypto: ccp: missing CRYPTO_HMAC select breaks hmac(sm3)
  fallback init
--

commit f58b08a6f33547b17d76105dad73af6381c5f603
Author: Depei Yang <yangdepei@hygon.cn>

crypto: ccp - add SM3 engine and ahash algorithms

This commit adds the SM3 engine command builder, request handling, and
sm3 and hmac(sm3) ahash algorithms to the CCP driver.

> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index f16a0f6113175..a226720201fe8 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -15,6 +15,7 @@ config CRYPTO_DEV_SP_CCP
>  	select DMA_ENGINE
>  	select CRYPTO_SHA1
>  	select CRYPTO_SHA256
> +	select CRYPTO_SM3
>  	help
>  	  Provides the support for AMD Cryptographic Coprocessor (CCP) device
>  	  which can be used to offload encryption operations such as SHA, AES

[Severity: Medium]
Should CRYPTO_DEV_SP_CCP (or CRYPTO_DEV_CCP_CRYPTO) also select
CRYPTO_HMAC?

ccp_register_sm3_alg() and ccp_register_hmac_sm3_alg() register
hmac-sm3-ccp with CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK, so
crypto_ahash_init_tfm() allocates a synchronous fallback for hmac(sm3)
whenever a transform is initialized (including during registration
self-tests).  Unlike CRYPTO_SHA1 and CRYPTO_SHA256, which directly
register synchronous hmac(sha*) shash algorithms, CRYPTO_SM3 only
registers sm3-lib and relies on the hmac template from CONFIG_CRYPTO_HMAC
to provide hmac(sm3).  Without CONFIG_CRYPTO_HMAC enabled, allocating
hmac(sm3) fails with -ENOENT.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795588986.gi=
t.yangdepei@hygon.cn?part=3D11

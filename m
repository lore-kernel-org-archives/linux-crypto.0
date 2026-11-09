Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794210410;
	b=vwwA1TrOO45NepRS6IgHdSvROSqn/JQgdN8mOaELQicNGXqEyEE2ZY0UY9dPjkzvfvh7
	 sAuDAnxVdpMjBMddE90uWaw5Inliq9fe8l1bW6X0ZBNBU57Gdlol/HIf6he8PfaQjnJlK
	 Ape8GjEGIOTBgmQsDubyCddHS8tqgnIGib2CVGT3GmcOkMHerq6a3SbA3YDWoWJQ9SOlc
	 54UYN8N4jpQxpCiTyKfXDqcGsSg1y5gdsXAfUU83htlLcAp22w+AFlWZ6V073tCiyp0WU
	 x2r2E/j113XWHcfQSqrmAEcUMnF6DL2lU2OegbEhT1c2GfrYd5ngKY+r/Ukpo6dbeEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794210410;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Rx76FG78lOQoej89gUJQJ6PGzemKDJffTNheteOd04o=;
	b=Ol5ftpPCnfP/qh8k4xVlVRHrhcztdSn6056DTMjx8UZsRVPd/MJ+K/bVKSwW4jZKkHTY
	 PtnnN+lIwpX9mkh9S95k6m8BIZVEcpdszjXfyz8gmrO1ppukKI2w5bEv7IMMtqmFXQ8lu
	 7mJKEA+0aZz+F90vDGu3uGZedPxzPFFBiyArNU4mSdV2zuuzyuJ+DOtBuPQRcBZyXt082
	 FQX5wVM5AsLL5ggbu3V+lw/kil/2z13044b9jDWtU/c7dVMCNzweeYB06BRtP+fG95oWD
	 xbfq+bzpumSsITgYJ7+D21M8RzMhuuiPro92AcrJjoPzpeLoPzZGw7FXgfxqYOepV1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mes9tqCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D842606A31C
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 07:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mes9tqCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F8D1F0089F;
	Mon,  9 Nov 2026 07:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794210410;
	bh=Rx76FG78lOQoej89gUJQJ6PGzemKDJffTNheteOd04o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mes9tqCjEDxdy/6fHU3yuKUqUP3OstMXgOvvheOQpaTiraAJzewnAbVvpdnV93QfD
	 ipg46AepRMxyjjTjrH1JsyGImift486IA5Pk5rNSGQCnq5aarHdwSAnECQ2k1zddpZ
	 d/LpTvHmTPnNumIGHoCPgSBEqNgdIQsgcOnzw+4cKTtJ8ZIXyI7JAHmFcUu60NAk76
	 dSsF39zLqJEmsL9lU4SPkeEkWntpoTDRfkxBHti9a1EQw/NgrrevtgFBG8PQvDCkvi
	 U2utkq5UPDb1QJP/qMaI/ykUL/AsPesWY2LDnW5glqohmMYL0BPi3vFNMyO4V14GR+
	 vDurhrnVWfX0w==
Message-ID: <sashiko-outbox-204552@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] crypto: engine - add acomp support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chenghai Huang" <huangchenghai2@huawei.com>, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, liulongfang@huawei.com, qianweili@huawei.com, wangzhou1@hisilicon.com, linwenkai6@hisilicon.com
In-Reply-To: <20261109073556.2517351-3-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
 <20261109073556.2517351-3-huangchenghai2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 07:46:49 +0000
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
- [High] crypto: engine - missing CRYPTO_ACOMP select in CRYPTO_ENGINE
  Kconfig
--

commit 21d47c711df84337042460c8075ae29a58a54c22
Author: Chenghai Huang <huangchenghai2@huawei.com>

crypto: engine - add acomp support

This commit adds asynchronous compression (acomp) request transfer,
finalization, and algorithm registration helpers to the crypto engine
framework, and moves struct acomp_alg to include/crypto/acompress.h.

> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index 5b669038acb45..2a0740d9dd634 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
[ ... ]
> @@ -504,6 +532,20 @@ void crypto_engine_exit(struct crypto_engine *engine)
>  }
>  EXPORT_SYMBOL_GPL(crypto_engine_exit);
> =20
> +int crypto_engine_register_acomp(struct acomp_engine_alg *alg)
> +{
> +	if (!alg->op.do_one_request)
> +		return -EINVAL;
> +	return crypto_register_acomp(&alg->base);
> +}
> +EXPORT_SYMBOL_GPL(crypto_engine_register_acomp);
> +
> +void crypto_engine_unregister_acomp(struct acomp_engine_alg *alg)
> +{
> +	crypto_unregister_acomp(&alg->base);
> +}
> +EXPORT_SYMBOL_GPL(crypto_engine_unregister_acomp);
> +
>  int crypto_engine_register_aead(struct aead_engine_alg *alg)
>  {
>  	if (!alg->op.do_one_request)

[Severity: High]
Does CRYPTO_ENGINE in crypto/Kconfig also need to select CRYPTO_ACOMP?

crypto_register_acomp() and crypto_unregister_acomp() are only built when
CONFIG_CRYPTO_ACOMP2 is enabled, and have no inline stub fallbacks.
Unlike CRYPTO_AEAD, CRYPTO_AKCIPHER, CRYPTO_HASH, CRYPTO_KPP, and
CRYPTO_SKCIPHER, CRYPTO_ENGINE does not select CRYPTO_ACOMP, so enabling
CONFIG_CRYPTO_ENGINE without CONFIG_CRYPTO_ACOMP2 (or with
CONFIG_CRYPTO_ENGINE=3Dy and CONFIG_CRYPTO_ACOMP2=3Dm) fails to link with
undefined references to crypto_register_acomp() and
crypto_unregister_acomp().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109073556.2517=
351-1-huangchenghai2@huawei.com?part=3D2

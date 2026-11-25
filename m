Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795649371;
	b=J496pQOsMUGRTrzFdm0vP50aUUEfUAyaan0fXex4ORzbnUJVEQX0u1c32+4Ta+TQexTu
	 GujK5Mv1CaoEwA7U2h+j+JbPkxLg7dpWNcL2FMH8Twwtdz77UEEeCGvG9kt8ZItB1IrZp
	 OyIgyGWvmdbdrdDa7BTOPRSD80zqHkP205rHPjpnwMJFtvXwU5sZ5CWZ6i/ohuF2el4Hd
	 Cd0KAAP/z2GFj9ggJT/wj0KvWPwE2PIVmezXlPuxNhmZpP8WJG+DKUR25yBfrOTP/fYJh
	 X/Kek3c3Vhuznv47MZKpqlZF4VbTXciis3O31ESyjF0uGXHF0IOhbWvqMFL+Rb87JaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795649371;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C+uz+utGmI/T6WiqsI5K9gY2PcFELU4kFQOl3At4YBk=;
	b=qS2vjOlHuLlsrFRKfAigMotoNGJUv5X0tmav6YvETYoVex6rhDbSqsOWh6tvQR7tmjs9
	 ZWJM9v1j2KR53RdjTsSnUpEe1ucx7HBEb3pP1qzgKxzTQlqH+A0Hh4SlTMqiy6RDKvfg3
	 MZgrkGX3nn62Eir94EcXa5xgLH+fA6SjWLXeWSNzUkBrPVseZiPNyyk/2VztN5pJrQ36A
	 2MtVgk6Enhbf5fpdY4uAZkwNc85NbbkAkkNd1Lb/O/9qPrX3QVwBRQjbGzTxAg3OElcOG
	 hUJtBH97vXi9AGFv6TNFWe9YxnBrSSZxc2fqiaJHeVotFQAZY7xXFfh7/4g9A25etig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWyyuGBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23F4606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 23:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWyyuGBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CEE1F000C6;
	Wed, 25 Nov 2026 23:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795649370;
	bh=C+uz+utGmI/T6WiqsI5K9gY2PcFELU4kFQOl3At4YBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LWyyuGBqx4wy3sxMIL5BYC6ZsSVgqRYpcy0x2P2BEN/a67sEWH0fV4gX5/miIQzNc
	 6Ux8N4pPsiBj9RQPWoJE2zT7dMnQCVADfzVGFgApGWjiYXHQTpYf8ZJUqL0/mCtMcN
	 0h3ULqJOoq67DwyncELTlaL3yAui/aZBueImeWLuTrLDKNBDXR0KmyLbc/xH7fKX6F
	 YIQ9wa5KCMCuA5G6C8oVRrgOzTaW55s0F9ZtnruCfl4OupSLKm8aNjvm5/Fx/lj1OO
	 YYuff5pYchTUbKaTdnrfespjDxeEcvh+rfzY8cpR71c+T9k9j5Hgl7ZMKZpBKzzL7L
	 sjr6dhtDHRWGw==
Message-ID: <sashiko-outbox-234403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] crypto: hisilicon/hpre - fix missing DH/ECDH public
 key validation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Zhiqi Song" <songzhiqi1@huawei.com>, "Longfang
 Liu" <liulongfang@huawei.com>
Cc: "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
In-Reply-To: <20261125231929.1857637-1-rc4d5a@protonmail.com>
References: <20261125231929.1857637-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 23:29:29 +0000
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
- [High] crypto: hisilicon/hpre - call to undeclared
  crypto_dh_pubkey_in_range()
--

commit 68d806f8478204295fe2a1e07880933e7ec78e7e
Author: Ryan Prinz <rc4d5a@protonmail.com>

crypto: hisilicon/hpre - fix missing DH/ECDH public key validation

This commit validates peer-supplied DH and ECDH public keys in
hpre_dh_compute_value() and hpre_ecdh_compute_value() before submitting
them to the hardware queue.

> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto=
/hisilicon/hpre/hpre_crypto.c
> index 66a276786a7d0..7355e5bd94cef 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> @@ -4,6 +4,7 @@
>  #include <crypto/dh.h>
>  #include <crypto/ecc_curve.h>
>  #include <crypto/ecdh.h>
> +#include <crypto/internal/ecc.h>
>  #include <crypto/rng.h>
>  #include <crypto/internal/akcipher.h>
>  #include <crypto/internal/kpp.h>
> @@ -471,6 +472,49 @@ static int hpre_send(struct hpre_ctx *ctx, struct hp=
re_sqe *msg)
>  	return ret;
>  }
> =20
> +static int hpre_dh_peer_pubkey_valid(struct hpre_ctx *ctx,
> +				     struct scatterlist *src,
> +				     unsigned int src_len, gfp_t gfp)
> +{
> +	unsigned int key_sz =3D ctx->key_sz;
> +	u8 *p_minus_1, *y;
> +	size_t copied;
> +	int i, ret =3D 0;
> +
> +	if (!src_len || src_len > key_sz)
> +		return -EINVAL;
> +
> +	y =3D kzalloc(key_sz, gfp);
> +	if (!y)
> +		return -ENOMEM;
> +
> +	copied =3D sg_copy_to_buffer(src, sg_nents_for_len(src, src_len),
> +				   y + (key_sz - src_len), src_len);
> +	if (copied !=3D src_len) {
> +		ret =3D -EINVAL;
> +		goto free_y;
> +	}
> +
> +	p_minus_1 =3D kmemdup(ctx->dh.xa_p + key_sz, key_sz, gfp);
> +	if (!p_minus_1) {
> +		ret =3D -ENOMEM;
> +		goto free_y;
> +	}
> +
> +	for (i =3D key_sz - 1; i >=3D 0; i--) {
> +		if (p_minus_1[i]-- !=3D 0)
> +			break;
> +	}
> +
> +	if (!crypto_dh_pubkey_in_range(y, p_minus_1, key_sz))
> +		ret =3D -EINVAL;

[Severity: High]
Does this break the build when CONFIG_CRYPTO_DEV_HISI_HPRE is enabled?
crypto_dh_pubkey_in_range() is neither declared in include/crypto/dh.h nor
defined anywhere in the tree, causing hpre_crypto.c to fail to compile due
to an implicit function declaration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125231929.1857=
637-1-rc4d5a@protonmail.com?part=3D1

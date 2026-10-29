Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243162;
	b=vlXcOo2eUp6J8G4r167w8XGHXuqkSj0iONWzopkdQ/FP2xGsQrvVuv9aBmKP6Oj8JGwU
	 22BDEUpUt/TCI1PTdZSOJka0M/vgqj9Hm7qOWXoTBduwuSaGuUdw5JUMlyO/0sgcOKp7f
	 g+FrDJLb9qRqKfyIlnnyi3HzL2v9zUjZS+hidjwF54Y2xfAolQiISg4QrySq7IjtkcBWa
	 hQvfCocBvQMIC2Htq9nHaCGrTR5ULVpe1nZpiiH+/Q41/Hh4rhf1QzM3lLYSCm9DFwHtL
	 z7CGxWF04lPhKofZIEX62xC8UG5w53iA7eLtACdf7/wH1efSs8dBD8F8TD6kMHFgMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243162;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ggG4r95jRpXsMfothCtjRrBypmbpmfyn2VhHQxaSWzg=;
	b=YMZ2cTvv6Gam3GV8kbcvlxy715lnU7Z8Gs8t0ZE20t0TtBMmkfaKldZO5mIfqtYyX2j5
	 zEJGt+EbcHxzcPBqMO5IAGwfPJ+GRxMIA2lqRyTuM/0aTZO2EJnsHi1gZmKMW1yq8QPlm
	 ydpN22IJ3gsQzcMJKm7TkMQrKR1CiJeasmsenD2yPQdKJA70ffsC50oPXRmTZESFOPlq9
	 64f2dTvvNGlY0VFixbXLU/gGn6Gc5b0CboJ3DKKUGWlbMg6bvVeHADKrelxUIqUZz4ZS2
	 4/13Kknkstza0Op0sNc1vm4OlCoUc1F+sf4gyPJYDqIi0a7BZLOYf7eSFy3WVKMCb2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7lp57MK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ECC606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 03:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7lp57MK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736571F01828;
	Thu, 29 Oct 2026 03:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243162;
	bh=ggG4r95jRpXsMfothCtjRrBypmbpmfyn2VhHQxaSWzg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y7lp57MKZLMxO3H+K4fbVfkqtVUqRlQTdj/Of3/59DVjyHO0+juWpvLT7mymEUhQ7
	 L4bnB00pgB6xGFa2J0jjNEzfRxlky7YY49UfJdOIkzOmYrYMmxHdvOl5YiFszCGM8l
	 HzURJ4lvae41Ov5iaPE9CZOQDTe5dD/s6F3NrNVZ1PCkxeG2cwjf/uU7DS+Fiu8K5G
	 og21V/CXNibuCXCwMPJtNBlMRTeWJAkreDRofu39yMF6JBxp2ybTuG0bc7Ag/GrCWE
	 548nNOptaYOo3O/kfOQ1M1fzok4ImkU+oO3rSpTcf90ohUEI/VGgxwV/2e2aTY3h13
	 Ru9Z0zFP0t51w==
Message-ID: <sashiko-outbox-188656@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-5-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-5-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:01 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] crypto: acomp: broken type check and async gate in crypto_acomp_=
batch_size()
--

commit a38b95e87019ff2c11b51ebf159a082ec340456f
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add API to get a compression algorithm's batch-size.

This commit adds a batch_size member to struct acomp_alg and introduces
crypto_acomp_batch_size() so callers such as zswap can query the maximum
number of requests an acomp algorithm can process in a batch.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index c55b0e8eff3d8..8e285cb7477e9 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -326,6 +326,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
>  }
>  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> =20
> +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> +{
> +	if (acomp_is_async(tfm) &&
> +		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRE=
SS)) {
> +		struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> +
> +		if (alg && alg->batch_size > 1)
> +			return alg->batch_size;
> +	}

[Severity: Medium]
Does the cra_flags check in crypto_acomp_batch_size() distinguish
struct acomp_alg from struct scomp_alg as intended?

In include/linux/crypto.h, algorithm types are 4-bit values under
CRYPTO_ALG_TYPE_MASK rather than single-bit flags:

    #define CRYPTO_ALG_TYPE_MASK		0x0000000f
    ...
    #define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000a
    #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000b

Because (0x0b & 0x0a) =3D=3D 0x0a, testing cra_flags & CRYPTO_ALG_TYPE_ACOM=
PRESS
without masking by CRYPTO_ALG_TYPE_MASK evaluates to true for both
CRYPTO_ALG_TYPE_ACOMPRESS and CRYPTO_ALG_TYPE_SCOMPRESS.

A struct crypto_acomp *tfm allocated via crypto_alloc_acomp() can wrap eith=
er
a struct acomp_alg or a struct scomp_alg. If an scomp_alg has CRYPTO_ALG_AS=
YNC
set in cra_flags (or if the acomp_is_async(tfm) check is removed), calling
crypto_acomp_alg(tfm) performs container_of() to struct acomp_alg on a
struct scomp_alg and reads alg->batch_size from unrelated memory inside
struct scomp_alg::streams.

Elsewhere in crypto/acompress.c, such as in crypto_acomp_init_tfm():

    if (tfm->__crt_alg->cra_type !=3D &crypto_acomp_type)
        return crypto_init_scomp_ops_async(tfm);

the code checks cra_type =3D=3D &crypto_acomp_type (or masks cra_flags with
CRYPTO_ALG_TYPE_MASK before comparing against CRYPTO_ALG_TYPE_ACOMPRESS) to
verify that the tfm is backed by a struct acomp_alg.

Also, should crypto_acomp_batch_size() gate on acomp_is_async(tfm)? A
synchronous struct acomp_alg registered via crypto_register_acomp() does not
set CRYPTO_ALG_ASYNC, which causes crypto_acomp_batch_size() to always retu=
rn 1
even when batch_size > 1, whereas segmented request handling in
crypto_acomp_compress() and acomp_do_req_chain() checks
crypto_acomp_req_seg(tfm) (CRYPTO_ALG_REQ_SEG) instead.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D4

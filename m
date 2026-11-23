Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445415;
	b=sSH8l4lJzYfkb8Nf6gt24Kv0P1Auu/NtR43m9AcoKdisjJeCHVExUjQgzja3LEi8X2Km
	 PvQS55hd0YkR2HAqPatz+MHfdej5gB/UMM/ZUvdwA3UPnwbbYYreNbtgk9FHgzDmC7rcd
	 HZ2UpfUFxB/Lb8OuN8EZBZSGhLmQsVtGH8OsETCxGxYXnWyCbCBZL14iF6ImOZK6PhNKw
	 NWPddIJUkHb3ArYDU6QI9CNK4qNmY0XFzK9oyn6Es1tjyRxK2jqSdCTf+PDJ6qzXokl6D
	 nH2NtZEhaaUvacv2WlJn/llK05LFHHkvyvryI3P5iFHvSSAFpACAzcfGuVH1wBJOYzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445415;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2VYFcyBKXC3yZ4aRuefyjeS6/vKwFOYv0oy6xLnW2HE=;
	b=q4vSVgWGFZ4SdDAt13LOewPDLl9ACFPAi9epseAGwkWMwdZrKAG6CVHuVtk5M/KBmfEe
	 Hvsf9KN2cflG1HcQolWxWuXGSm1S4+vtWmIzwF+3reBLW8uHy9W0o9cgVub1HVAjkJDye
	 aTST2Lk/RF8VZ3n+DkSXUeO3bHGVX66MsymfbyFAMbhkU2gO5KWa7tXrtRG+gwq6oaaED
	 P9He4JB66YbwQGQLxfAh3/NA95CmGBcA9/ZPuzQjqL0rlCndZGi5e4QFkxmvEc1slXsCB
	 EF47l+ZD7yT+BIAqOQvd4GFUG4MOqt7wJPuSWbtBGqHChWzkskr48PnHbUwLPuyUgug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YnJoag5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C8E606A31E
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YnJoag5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7321F000C6;
	Mon, 23 Nov 2026 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445415;
	bh=2VYFcyBKXC3yZ4aRuefyjeS6/vKwFOYv0oy6xLnW2HE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YnJoag5dBnmG57jVFt7tUyGes+NixEJk+hqqfdfGddITC66LrrtkgLo4ijI0YXqNr
	 1QklmX3Mw8/jl+WNXnBiJWMr3Uyk68PYKW4kGa26ThGE6GhFqI7pvvcuBvvxf3I6JN
	 /HgYbLTqxx7EWJ+JsLQC3Y4SatNekToKBzeMmMC6SapRgHFdhYFWiwcNXB/DSy6muO
	 2CWAsgrw+7F1d790Zz6xqI9L421Y9Ag3c67rw3v4/7UarqsmXiNLZqmNFR0ZfWOA9f
	 y3eoW4jY7UM2doLpq6f+Mn8CGB+88ObUeoi1GJogrIRqwCeaYhR/zxxIAeAcT6Gu9k
	 rcg5/NV69rohA==
Message-ID: <sashiko-outbox-229443@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 2/2] crypto: ti - Add support for HMAC in DTHEv2
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "T Pratham" <t-pratham@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>
Cc: "Sebin Francis" <sebin.francis@ti.com>, "Manorit Chawdhry" <m-chawdhry@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261123142918.3451969-3-t-pratham@ti.com>
References: <20261123142918.3451969-1-t-pratham@ti.com>
 <20261123142918.3451969-3-t-pratham@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:50:14 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] crypto: ti - sleeping crypto_alloc_shash() call in
  dthe_hash_export()
- [Low] crypto: ti - redundant fallback setkey and shash alloc in
  dthe_hmac_setkey()
--

commit 325575ece1b4fbdd9ca3a408597f30635e4f5362
Author: T Pratham <t-pratham@ti.com>

crypto: ti - Add support for HMAC in DTHEv2 driver

This commit adds HMAC-SHA512, HMAC-SHA384, HMAC-SHA256, and HMAC-SHA224
support to the DTHEv2 hashing engine driver.

> diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-h=
ash.c
> index ac6119e4e4d68..02ff7a5e6812a 100644
> --- a/drivers/crypto/ti/dthev2-hash.c
> +++ b/drivers/crypto/ti/dthev2-hash.c

[ ... ]

> @@ -551,6 +618,53 @@ static const void *dthe_hash_get_init_state(struct d=
the_tfm_ctx *ctx)
>  	}
>  }
> =20
> +/*
> + * Compute the HMAC inner or outer pad state (the intermediate hash stat=
e after
> + * processing one block of key XOR pad_byte) and write it to @out. Only =
the
> + * first ctx->phash_size bytes are written, which is always the raw hash=
 state
> + * at the start of the shash export struct.
> + */
> +static int dthe_hmac_compute_pad_state(struct dthe_tfm_ctx *ctx, u8 pad_=
byte,
> +				       void *out)
> +{
> +	const char *alg_name =3D dthe_hash_get_alg_name(ctx);
> +	struct crypto_shash *ktfm;
> +	u8 data[SHA512_BLOCK_SIZE];
> +	unsigned int ss;
> +	u8 *state;
> +	int ret;
> +
> +	ktfm =3D crypto_alloc_shash(alg_name, 0, 0);
> +	if (IS_ERR(ktfm))
> +		return PTR_ERR(ktfm);
> +
> +	ss =3D crypto_shash_statesize(ktfm);
> +	state =3D kmalloc(ss, GFP_ATOMIC);
> +	if (!state) {
> +		crypto_free_shash(ktfm);
> +		return -ENOMEM;
> +	}
> +
> +	SHASH_DESC_ON_STACK(desc, ktfm);
> +
> +	desc->tfm =3D ktfm;
> +	for (int i =3D 0; i < ctx->keylen; i++)
> +		data[i] =3D ((u8 *)ctx->key)[i] ^ pad_byte;
> +
> +	ret =3D crypto_shash_init(desc) ?:
> +	      crypto_shash_update(desc, data, ctx->keylen) ?:
> +	      crypto_shash_export(desc, state);
> +
> +	if (!ret)
> +		memcpy(out, state, ctx->phash_size);
> +
> +	memzero_explicit(state, ss);
> +	kfree(state);
> +	crypto_free_shash(ktfm);
> +	memzero_explicit(data, sizeof(data));
> +	return ret;
> +}
> +
>  static int dthe_hash_export(struct ahash_request *req, void *out)
>  {
>  	struct dthe_hash_req_ctx *rctx =3D ahash_request_ctx_dma(req);
> @@ -561,9 +675,12 @@ static int dthe_hash_export(struct ahash_request *re=
q, void *out)
>  		u8 *u8;
>  		u64 *u64;
>  	} p =3D { .u8 =3D out };
> +	int ret =3D 0;
> =20
>  	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL))
>  		memcpy(out, rctx->phash, ctx->phash_size);
> +	else if (ctx->keylen > 0)
> +		ret =3D dthe_hmac_compute_pad_state(ctx, HMAC_IPAD_VALUE, out);
>  	else
>  		memcpy(out, dthe_hash_get_init_state(ctx), ctx->phash_size);

[Severity: High]
Can calling crypto_alloc_shash() in dthe_hmac_compute_pad_state() sleep
when dthe_hash_export() runs in atomic context?

crypto_ahash_export() and crypto_ahash_export_core() may be called from
softirq or atomic context (as the GFP_ATOMIC allocation of state reflects),
but crypto_alloc_shash() acquires the sleeping crypto_alg_sem rw_semaphore
and allocates the transform with GFP_KERNEL.

In addition, computing the inner pad state here appears unnecessary:
CRYPTO_AHASH_ALG_NO_EXPORT_CORE is set, so exported state is only consumed
by dthe_hash_import().  Because rctx->flags is exported with
DTHE_HASH_FLAG_PHASH_AVAIL clear, dthe_hash_dma_start() after import ignores
rctx->phash and loads ctx->key with DTHE_HASH_MODE_HMAC_KEY_PROCESSING.  The
on-stack desc in dthe_hmac_compute_pad_state() is also not cleared with
shash_desc_zero() before returning.

[ ... ]

> @@ -603,6 +730,53 @@ static int dthe_hash_import(struct ahash_request *re=
q, const void *in)
>  	return 0;
>  }
> =20
> +static int dthe_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
> +			    unsigned int keylen)
> +{
> +	struct dthe_tfm_ctx *ctx =3D crypto_ahash_ctx(tfm);
> +	struct crypto_ahash *fb =3D crypto_ahash_fb(tfm);
> +	const char *hash_alg_name =3D dthe_hash_get_alg_name(ctx);
> +	unsigned int max_keysize;
> +
> +	memzero_explicit(ctx->key, sizeof(ctx->key));
> +
> +	switch (ctx->hash_mode) {
> +	case DTHE_HASH_SHA512:
> +	case DTHE_HASH_SHA384:
> +		max_keysize =3D DTHE_HMAC_SHA512_MAX_KEYSIZE;
> +		break;
> +	case DTHE_HASH_SHA256:
> +	case DTHE_HASH_SHA224:
> +		max_keysize =3D DTHE_HMAC_SHA256_MAX_KEYSIZE;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (keylen > max_keysize) {
> +		struct crypto_shash *ktfm;
> +		int err;
> +
> +		ktfm =3D crypto_alloc_shash(hash_alg_name, 0, 0);
> +		if (IS_ERR(ktfm))
> +			return PTR_ERR(ktfm);
> +
> +		SHASH_DESC_ON_STACK(desc, ktfm);
> +
> +		desc->tfm =3D ktfm;
> +		err =3D crypto_shash_digest(desc, key, keylen, (u8 *)ctx->key);
> +		crypto_free_shash(ktfm);
> +		if (err)
> +			return err;
> +	} else {
> +		memcpy(ctx->key, key, keylen);
> +	}
> +
> +	ctx->keylen =3D max_keysize;
> +
> +	return crypto_ahash_setkey(fb, key, keylen);
> +}

[Severity: Low]
Does dthe_hmac_setkey() need to call crypto_ahash_setkey(fb, key, keylen)
or allocate a crypto_shash transform for long keys?

Because CRYPTO_ALG_NEED_FALLBACK is set, crypto_ahash_setkey() in
crypto/ahash.c already propagates the key to crypto_ahash_fb(tfm) after
alg->setkey() succeeds, so calling it here sets the fallback key twice.
Also, since CRYPTO_SHA256 and CRYPTO_SHA512 are selected in Kconfig and
<crypto/sha2.h> is included, sha224(), sha256(), sha384(), and sha512() can
hash keys longer than max_keysize directly without allocating a temporary
shash transform, and ctx->keylen should be reset to 0 when ctx->key is
zeroed at the start so a failed setkey does not leave a stale non-zero
ctx->keylen with an all-zero key.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123142918.3451=
969-1-t-pratham@ti.com?part=3D2

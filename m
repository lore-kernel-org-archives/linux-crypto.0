Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781898;
	b=MgIuXoFYhIr5nugNPdbCJr2VhZmIbmba+gzi8nMqsj73C70GdI5OVkRYkmbrElWSfWLx
	 sS33/QNDmDqOPPlxyZ6F1nYRd9dPN8K5WnntAoUN+ACwzyyw4+iJINSz/t+l47tm+PVg1
	 b6itBHiB6RAq3NYGv/HTlMLX4DIJexVpRxcHEgkVDwubngtayImsIQCyGv8P3uS2QsZiQ
	 s5L4wonxTJIVnzTkDOS+igkNH+b+BpB0oUprWXKHLhHX/872n+WOrpZk4WJDr9vxE4GP6
	 JoYvGIha+GbIsyP/7zAUi6TnqDamCt0elQp6TM7IS+uX2E8zuAv1Nj9iUGh12s/Xzpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781898;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jynokmy2Zg40YxhFBolqCvaNpMNi5CarvM1aMB5c7VY=;
	b=MaGpKQjuyG7vH5khd/Y+P9jftsol/cuGCHh2e6C7SF3powuhFGfsL3ERv81Z3EuPCGQt
	 s1/xBuAEYCOyflbsLbkZZkqQtCo6hSZpoJFe9WEkaoPxRm+Ha7XuK4ifcPE669/klG72n
	 XDG9X/vVhsq+ml2Orh1sPIl++LudFy2PGT5cRwf1IAIJ9EQAejLTb3fUreGWPRDoXD4zN
	 rNMT7MdC7fF0jG0PsenUaxJP0tx77zbZd9s9b04uHsWhCHAbWxsjGA4/FH3xR/Jr93B7g
	 YXZfo6HoZhkG/rOWzpbWb1j4RJdVIv+kByWQ6cGqbEA0Ctqzx9LOvEDULdDisVcSmKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P8gS9Trq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2857606A33C;
	Fri, 27 Nov 2026 12:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P8gS9Trq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746951F00897;
	Fri, 27 Nov 2026 12:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781897;
	bh=jynokmy2Zg40YxhFBolqCvaNpMNi5CarvM1aMB5c7VY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P8gS9Trq+OPzXmXFEmFkOw/S/nxfMo4mpI1VcPQBMvVPX2JMS+I4d5XVPiVacHYb6
	 oPHSUtHH4kL81i7SazVhAJn2VGDxsmsAhqwJNiRZ2K+g0Gpst3uGUV5H2EXkU0S2jH
	 t7Wpec7F8Beaw1el0PPe60eH/4nsw8Rd0wTDkeMIJjSFsCZL5Vk+1/n59qgDlGPfzx
	 vlZUGmnHDn4GLvvlvMOGAhmi7YBqVfNCNbP3ireFYpooeJV5EwT3rFVyOK3MXDBta0
	 ihejJ53iS5K01qcoUZZ+3epPgc4JqtBuNW1YWV6AnoyFlVO9d5mXntacflimjRSf6e
	 Ka1LkyHU6vgSw==
Message-ID: <sashiko-outbox-237345@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 12/30] crypto: amlogic - Avoid kzalloc in engine
 thread
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-13-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-13-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:18:16 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] crypto: amlogic: shared TFM keyiv buffer races across
  concurrent requests
- [Medium] crypto: amlogic: keyiv DMA length mismatch in meson_cipher()
- [Low] crypto: amlogic: unused DMA reqsize padding in
  meson_cipher_init()
- [Low] crypto: amlogic: stale trailing key bytes on re-key in
  meson_aes_setkey()
--

commit c0d41dfd052dda605b64b5392f2c86747ef3d026
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Avoid kzalloc in engine thread

This commit replaces the per-request dynamically allocated key and IV
buffer with a fixed keyiv buffer in struct meson_cipher_tfm_ctx and
switches the transform context to DMA-aligned crypto helpers.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto=
/amlogic/amlogic-gxl-cipher.c
> index cb6b959bb1f96..df42940f1112a 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
[ ... ]
> @@ -147,17 +146,17 @@ static void meson_setup_keyiv_descs(struct cipher_c=
tx *ctx)
>  	struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
>  	struct meson_alg_template *algt =3D container_of(alg,
>  		struct meson_alg_template, alg.skcipher.base);
> -	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx(tfm);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx_dma(tfm);
>  	struct meson_dev *mc =3D op->mc;
>  	unsigned int ivsize =3D crypto_skcipher_ivsize(tfm);
>  	unsigned int blockmode =3D algt->blockmode;
>  	int i;
> =20
>  	if (ctx->tloffset)
>  		return;
> =20
>  	if (blockmode =3D=3D DESC_OPMODE_CBC) {
> -		memcpy(ctx->bkeyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
> +		memcpy(op->keyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
>  		dma_sync_single_for_device(mc->dev, ctx->keyiv.addr,
>  					   ctx->keyiv.len, DMA_TO_DEVICE);
>  	}
[ ... ]
> @@ -320,21 +320,21 @@ static int meson_cipher(struct skcipher_request *ar=
eq)
>  	mc->chanlist[rctx->flow].stat_req++;
>  #endif
> =20
> -	ctx.bkeyiv =3D kzalloc(48, GFP_KERNEL | GFP_DMA);
> -	if (!ctx.bkeyiv)
> -		return -ENOMEM;
> -
> -	memcpy(ctx.bkeyiv, op->key, op->keylen);
>  	ctx.keyiv.len =3D op->keylen;
>  	if (ctx.keyiv.len =3D=3D AES_KEYSIZE_192)
>  		ctx.keyiv.len =3D AES_MAX_KEY_SIZE;
> =20
> -	ctx.keyiv.addr =3D dma_map_single(mc->dev, ctx.bkeyiv, ctx.keyiv.len,
> +	if (algt->blockmode =3D=3D DESC_OPMODE_CBC) {
> +		memcpy(op->keyiv + AES_MAX_KEY_SIZE, areq->iv, ivsize);
> +		ctx.keyiv.len =3D AES_MAX_KEY_SIZE + ivsize;
> +	}
> +
> +	ctx.keyiv.addr =3D dma_map_single(mc->dev, op->keyiv, ctx.keyiv.len,
>  					DMA_TO_DEVICE);
>  	err =3D dma_mapping_error(mc->dev, ctx.keyiv.addr);
>  	if (err) {
>  		dev_err(mc->dev, "Cannot DMA MAP KEY IV\n");
> -		goto free_keyiv;
> +		return err;
>  	}

[Severity: High]
Can two concurrent CBC requests sharing a crypto_skcipher transform race
on op->keyiv?

meson_skencrypt() and meson_skdecrypt() dispatch requests round-robin
across mc->flow_cnt independent crypto_engine worker threads via
meson_get_engine_number().  Because op is per-transform, two requests on
the same transform can run meson_cipher() in parallel on different engine
threads:

flow 0 kworker                    flow 1 kworker
meson_cipher(req0)
  memcpy(op->keyiv + 32,
         req0->iv, ivsize)
  dma_map_single(..., op->keyiv, ...)
                                  meson_cipher(req1)
                                    memcpy(op->keyiv + 32,
                                           req1->iv, ivsize)  <-- overwrite=
s IV
                                    dma_map_single(..., op->keyiv, ...)
  meson_kick_hardware()
  dma_unmap_single(...)
                                    meson_kick_hardware()  <-- DMA on unmap=
ped
                                                               or corrupted=
 IV

Moving the mutable per-request DMA buffer into struct meson_cipher_req_ctx
(or per-channel storage) would avoid sharing it across concurrent requests.

[Severity: Medium]
Does ctx.keyiv.len match the descriptors programmed in
meson_setup_keyiv_descs()?

In ECB mode, ctx.keyiv.len remains 16 (AES-128) or 32 (AES-192/256), and
only ctx.keyiv.len bytes of op->keyiv are mapped with dma_map_single().
meson_setup_keyiv_descs() then unconditionally emits
mc->pdata->setup_desc_cnt (3 on GXL and AXG) descriptors at offsets 0, 16,
and 32, each transferring ctx->keyiv.len bytes:

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_setup_keyiv_descs() {
    ...
	for (i =3D 0; i < mc->pdata->setup_desc_cnt; i++) {
		struct meson_desc *desc =3D
			&mc->chanlist[rctx->flow].tl[ctx->tloffset];
		int offset =3D i * 16;

		desc->t_src =3D cpu_to_le32(ctx->keyiv.addr + offset);
		desc->t_dst =3D cpu_to_le32(offset);
		desc->t_status =3D cpu_to_le32(DESC_OWN | DESC_MODE_KEY | ctx->keyiv.len);

		ctx->tloffset++;
	}
}

At this commit, descriptors at offsets 16 and 32 read past the DMA mapping
and past the 48-byte op->keyiv buffer.  Even with the later commit
"crypto: amlogic: fix setup descriptor lengths and CBC IV copy" in this
series changing the descriptor length to
ctx->keyiv.len / mc->pdata->setup_desc_cnt, ECB mode on GXL and AXG still
divides 16 or 32 by 3 (truncating each descriptor length to 5 or 10 bytes)
and accesses offsets up to 32 beyond a 16- or 32-byte DMA mapping.

[ ... ]

> @@ -425,42 +422,39 @@ static int meson_skencrypt(struct skcipher_request =
*areq)
> =20
>  static int meson_cipher_init(struct crypto_tfm *tfm)
>  {
> -	struct meson_cipher_tfm_ctx *op =3D crypto_tfm_ctx(tfm);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_tfm_ctx_dma(tfm);
>  	struct meson_alg_template *algt;
>  	const char *name =3D crypto_tfm_alg_name(tfm);
>  	struct crypto_skcipher *sktfm =3D __crypto_skcipher_cast(tfm);
> @@ -443,7 +440,7 @@ static int meson_cipher_init(struct crypto_tfm *tfm)
>  		return PTR_ERR(op->fallback_tfm);
>  	}
> =20
> -	crypto_skcipher_set_reqsize(sktfm, sizeof(struct meson_cipher_req_ctx) +
> +	crypto_skcipher_set_reqsize_dma(sktfm, sizeof(struct meson_cipher_req_c=
tx) +
>  				    crypto_skcipher_reqsize(op->fallback_tfm));
> =20
>  	return 0;
>  }

[Severity: Low]
Why use crypto_skcipher_set_reqsize_dma() here when struct
meson_cipher_req_ctx holds no DMA buffers and every caller still retrieves
it via skcipher_request_ctx() rather than skcipher_request_ctx_dma()?

[ ... ]

>  static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  			    unsigned int keylen)
>  {
> -	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx(tfm);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx_dma(tfm);
>  	struct meson_dev *mc =3D op->mc;
> =20
>  	switch (keylen) {
> @@ -477,11 +473,9 @@ static int meson_aes_setkey(struct crypto_skcipher *=
tfm, const u8 *key,
>  		dev_dbg(mc->dev, "ERROR: Invalid keylen %u\n", keylen);
>  		return -EINVAL;
>  	}
> -	kfree_sensitive(op->key);
> +
> +	memcpy(op->keyiv, key, keylen);
>  	op->keylen =3D keylen;
> -	op->key =3D kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> -	if (!op->key)
> -		return -ENOMEM;
> =20
>  	return crypto_skcipher_setkey(op->fallback_tfm, key, keylen);
>  }

[Severity: Low]
If a transform is keyed with AES-256 and later re-keyed with AES-128 or
AES-192, does op->keyiv retain stale key bytes in
op->keyiv[keylen..AES_MAX_KEY_SIZE - 1]?

Previously kzalloc() zeroed the 48-byte buffer on each request.  Now
op->keyiv is only zeroed in meson_cipher_init(), so re-keying with a
shorter key leaves the old trailing bytes in place when meson_cipher()
maps AES_MAX_KEY_SIZE (for AES-192) or AES_MAX_KEY_SIZE + ivsize (for CBC).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D12

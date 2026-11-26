Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722529;
	b=Ns2JfaIybM/IGf5BHzk0t0M12ZTGk8OwprWQ0opQB/8VdtLOmQBy3jLYsxhKRFhZhhbY
	 SjAMDa84RrqMSfVeklI7ubQosBGj9Fu2idYJVSc+c27JrO+O29ZA0A97Qt6hP3xyp19qw
	 oD+UOQiWyFlupfC5E65UNHHUJ2ZpIrM8OybY7VAQpvZEwebZZElnVYdVtkinUL/hv4yLK
	 EG9A10NcMtV6M1ongiIbwLM0ODN5rc240iZkKo8UPBjCZx9zcjOg0iEjFqju+86KBB1CW
	 ayHvFXc/nGhbhCX5Z8X3c1xjyRM9ZEXIREXUp5POjL8SnT0ITConabOJ+fr75UwZoMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722529;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cXHtkSGqYTHMGfEbz2hkNOCAQRnLJiBWoIsvMJU6LJ4=;
	b=tLqT6qVEmrFNE3FLxfvFzmq23st8P+Atc28Dva2ZhCPDWBHOlsZqCrydJF3jms3vKsP3
	 Ew9CoJW8NmhB56uPk3fKayw5OqGlScuvOG6uT9KDEy7pB3EHEEuhcRuH2hE9wxQiL7tCA
	 G327UB9zKH4r7pS3kb9eBjAdKg6fkECYC7DnZ9XNQj80KoEh6iINKNbhBOrqMvEGWRBP8
	 jtoFz+ZUgE4PwChMWR5OONvggu8gJLxxqExN90QayWgxuuw2krsZIZFd2F+JexW8UE89K
	 lBAw1S3+ZmN5J0cXeXDJ51ycbm+I8kVIiYYEKFEF0cZ3O6Fejln3Bej3dMIwSz+xifQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIOry1Ex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3124A606A32F;
	Thu, 26 Nov 2026 19:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIOry1Ex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D57F1F000C6;
	Thu, 26 Nov 2026 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722528;
	bh=cXHtkSGqYTHMGfEbz2hkNOCAQRnLJiBWoIsvMJU6LJ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lIOry1Ex2Z9eaH9FjKoNMZVFLDZKbX9be2fAq6azcwsFS0fDSQ6QTahaJ32GGv2Qw
	 Us9CX/wUdk+makl5WAY1dGdJ8ikeoEU4R1w8puC2uO5COizKteuR8OX8K9ix2EOPqA
	 YC4+sVDkvaYEnADeBtxuVcUmsj3Br3EPMxJbaE2FEsnZCkyJ+s2addHFBF4q1ZPTg5
	 2JFqa0+kuG/nzbcy0haBCA3jYGmxX0bMrNjMrMS2R3yyKbOd86MIaA9qowPtu2XGYy
	 QxEK73av+LWBbtuIgn6QLAP1FgbDuWWDbf1qAK6nMDLGayou9tx1opLfAx2MrdYJTk
	 Y/mE2ZtUWwg+A==
Message-ID: <sashiko-outbox-236121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 12/25] crypto: amlogic - Avoid kzalloc in engine
 thread
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-13-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-13-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:48:47 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] crypto: amlogic: shared TFM keyiv buffer races across
  concurrent requests
- [Medium] crypto: amlogic: unsynced DMA write and duplicate IV copy in
  meson_cipher()
- [Medium] crypto: amlogic: out-of-bounds keyiv DMA descriptors in
  meson_cipher()
- [Low] crypto: amlogic: unused DMA reqsize padding in
  meson_cipher_init()
- [Low] crypto: amlogic: stale trailing key bytes on re-key in
  meson_aes_setkey()
--

commit 228a0fe250c8671b89954b4f55b91bfb1b59975f
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Avoid kzalloc in engine thread

This commit replaces the per-request kzalloc() key/IV buffer in meson_ciphe=
r()
and the dynamically allocated key in struct meson_cipher_tfm_ctx with a
fixed-size keyiv array in the transform context, and switches transform and
request context accessors to their DMA-aligned variants.

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

[Severity: Medium]
Does meson_setup_keyiv_descs() modify the DMA-mapped op->keyiv buffer
without calling dma_sync_single_for_cpu() first, while also duplicating the
initial IV copy and DMA sync already performed in meson_cipher()?

In meson_cipher(), CBC requests copy areq->iv into op->keyiv and call
dma_map_single(..., DMA_TO_DEVICE), transferring buffer ownership to the
device before entering the loop with ctx.tloffset =3D=3D 0.  On the first l=
oop
iteration, meson_setup_keyiv_descs() immediately repeats that memcpy() and
flushes the cache a second time via dma_sync_single_for_device(), and on
every batch it writes to the mapped buffer from the CPU without a preceding
dma_sync_single_for_cpu() call.

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

[Severity: Medium]
Does setting ctx.keyiv.len to 48 in CBC mode cause meson_setup_keyiv_descs()
to program key/IV DMA descriptors that read past the end of op->keyiv?

meson_setup_keyiv_descs() loops mc->pdata->setup_desc_cnt (3) times at
16-byte offsets (0, 16, 32) and sets each descriptor's length in t_status to
ctx->keyiv.len:

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

With ctx.keyiv.len increased to 48 for CBC (and 16 or 32 for ECB, where
dma_map_single() only maps ctx.keyiv.len bytes), the descriptors at offsets
16 and 32 instruct the DMA engine to read up to 32 bytes past the end of the
48-byte op->keyiv buffer and its DMA mapping.

[ ... ]
> @@ -425,40 +422,37 @@ static int meson_skencrypt(struct skcipher_request =
*areq)
> =20
>  static int meson_cipher_init(struct crypto_tfm *tfm)
>  {
[ ... ]
> -	crypto_skcipher_set_reqsize(sktfm, sizeof(struct meson_cipher_req_ctx) +
> +	crypto_skcipher_set_reqsize_dma(sktfm, sizeof(struct meson_cipher_req_c=
tx) +
>  				    crypto_skcipher_reqsize(op->fallback_tfm));
> =20
>  	return 0;
>  }

[Severity: Low]
Is crypto_skcipher_set_reqsize_dma() needed here when struct
meson_cipher_req_ctx holds no DMA buffers and all callers still access it
via skcipher_request_ctx()?  Unless the per-request DMA buffer is moved into
struct meson_cipher_req_ctx and accessed with skcipher_request_ctx_dma(),
this adds unused DMA alignment padding to every request allocation.

>  static void meson_cipher_exit(struct crypto_tfm *tfm)
>  {
> -	struct meson_cipher_tfm_ctx *op =3D crypto_tfm_ctx(tfm);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_tfm_ctx_dma(tfm);
> =20
> -	kfree_sensitive(op->key);
>  	crypto_free_skcipher(op->fallback_tfm);
>  }
> =20
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

[Severity: Low]
Can re-keying an existing transform with a shorter key leave stale key bytes
in op->keyiv?

Previously, meson_cipher() allocated a zeroed 48-byte buffer on each reques=
t.
Because op->keyiv is now only zeroed once in meson_cipher_init(), re-keying=
 a
transform from AES-256 to AES-192 or AES-128 leaves the old key's trailing
bytes in op->keyiv[keylen..AES_MAX_KEY_SIZE - 1], which are then DMA-mapped
and sent to the hardware when ctx.keyiv.len is padded to AES_MAX_KEY_SIZE.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogi=
c/amlogic-gxl.h
> index 6797b44905d3e..c401cbbadaa34 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl.h
> +++ b/drivers/crypto/amlogic/amlogic-gxl.h
> @@ -125,14 +125,14 @@ struct meson_cipher_req_ctx {
> =20
>  /*
>   * struct meson_cipher_tfm_ctx - context for a skcipher TFM
> - * @key:		pointer to key data
> + * @keyiv:		key data
>   * @keylen:		len of the key
>   * @keymode:		The keymode(type and size of key) associated with this TFM
>   * @mc:			pointer to the private data of driver handling this TFM
>   * @fallback_tfm:	pointer to the fallback TFM
>   */
>  struct meson_cipher_tfm_ctx {
> -	u32 *key;
> +	u8 keyiv[AES_MAX_KEY_SIZE + AES_BLOCK_SIZE];
>  	u32 keylen;
>  	u32 keymode;
>  	struct meson_dev *mc;

[Severity: High]
Can moving the mutable key/IV DMA buffer into struct meson_cipher_tfm_ctx
cause a data race and CBC data corruption when two requests share a transfo=
rm?

A single struct crypto_skcipher transform is shared across concurrent
requests, and meson_skencrypt() / meson_skdecrypt() dispatch requests
round-robin across mc->flow_cnt (2) crypto_engine worker threads via
meson_get_engine_number():

flow 0 kworker                    flow 1 kworker
meson_cipher(req1)
  memcpy(op->keyiv + 32,
         req1->iv, 16)
  dma_map_single(..., op->keyiv,
                 ...)
                                  meson_cipher(req2)
                                    memcpy(op->keyiv + 32,
                                           req2->iv, 16)  <-- overwrites IV
                                    dma_map_single(..., op->keyiv, ...)
  meson_kick_hardware()
    meson_dma_start()             <-- DMA reads req2's IV for req1
  dma_unmap_single(...)           <-- unmaps while flow 1 DMA is active

In addition, op->keyiv is not padded to a cacheline boundary inside struct
meson_cipher_tfm_ctx, so it shares a cacheline with keylen, keymode, mc, and
fallback_tfm during streaming DMA mappings.  Should the per-request key/IV
DMA buffer live in struct meson_cipher_req_ctx (accessed via
skcipher_request_ctx_dma()) instead of the shared transform context?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D12

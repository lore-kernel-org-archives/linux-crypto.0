Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781598;
	b=M0zyYqRbNkoZfY40yUGrpov5Q6wWyqffh7nAzdwbAM+P51S36x+LhqNqBdMhn2X1lm1t
	 LYwEEaq5/nYGqZ3IZrxrNlDtNW62viaL9y+/b8fShvMB6aK5c28mgkP1xYpt3Da8lAAsL
	 bRxK1/E6q72IJ/ypRVcyF40XjOlv5xUOZQu8XuKsPgWAgFSswpXE053TokmoEi3qWlEDK
	 3SxjYSQvoHAtu/wIUniQ1RWkkQydV4KexucLyOjbUnIzyL+ryNGhK/J9vGrpeOifPhm7k
	 QGEi+3vihjmTfMHg5t4Ft0peR4kHqt2sdBRkT6p2MYuuV9aPGuXucc1pAqfhsxmMSEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781598;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pHz68dESKIdyXIoCTsybjyjeooLTejwjRt9ur77xsaw=;
	b=J1kUG4M685PVpY88Sk8ciZmUtfgkGvdcjHUlXqEIMDyG0e0I8v3nivQZ/aKeZHaJK+VW
	 1qs/xm6OdEy8KaIRnlEttqLfaQukqN9w1220+cxOCngpp7xG4DRgNSRHIAt1dOSSP+90Z
	 aSO8SrqjaALJUv4Xj5K5QzQHkHKh4CU6i1anzeQVP1nca78/bP7oADgsuuwIIL+YeOrcO
	 KRT5NEy4Dz1uoiJ38Q3k+OuBzHo3ayWPDLK2baDK+bg+rbTZ2Gtbmi8aCFYxeO1DkOruZ
	 uKD3ixw9d1VMjZrsE6QJ+PjTCzqDjugiAVZ23mUZzoZ2TJQEe+J3kZ5aPSsHQmIdymA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhNsEUxa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2899F606A31E;
	Fri, 27 Nov 2026 12:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhNsEUxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1B81F000C1;
	Fri, 27 Nov 2026 12:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781597;
	bh=pHz68dESKIdyXIoCTsybjyjeooLTejwjRt9ur77xsaw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BhNsEUxanGD5CK6hmlZmy8D5BzL/zgpd5iAWZvk4ODVMe6bG+hizRcDAp7oUgM0m5
	 RJ9oqr/cjla6IJf9/FvEhglZNIXG34yGFEjmekUSVHzDT4kG39XleVWzGboKq6DrmP
	 ritsk8u99ui0LDXSI4iJf4tVhFiIQ2LFmE1a+HTyjok+8u8Grm5KtPsxn//viQmCE8
	 h39zmFwzO79YRxZOp/97yAyG9GQ/s/9A/oeYms1gMxcPIqM5jqFWqAfABtB1yssvrd
	 qx/xRsBPM75xvi5teCzjSAXTSmY8fefIF6DEYJ6NWyBTCms1dwrWGqw1B8DppqGwfs
	 1RO6P8FghsWyg==
Message-ID: <sashiko-outbox-237334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 11/30] crypto: amlogic - Process more than MAXDESCS
 descriptors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-12-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-12-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:13:16 +0000
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
- [High] crypto: amlogic: unmapped IV and bad keyiv DMA length in
  meson_cipher()
- [High] crypto: amlogic: bad sg_virt() offset and DMA sync in
  meson_kick_hardware()
--

commit 4d7b0e2239c95f15cc0e337acf98505c54b39ed1
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Process more than MAXDESCS descriptors

This commit rewrites the Amlogic GXL cipher descriptor handling to split
large skcipher requests across multiple hardware batches and makes the
number of key/IV setup descriptors configurable via platform data.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto=
/amlogic/amlogic-gxl-cipher.c
> index c17ce5cc70a87..cb6b959bb1f96 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c

[ ... ]

> +static void meson_setup_keyiv_descs(struct cipher_ctx *ctx)
> +{
> +	struct meson_cipher_req_ctx *rctx =3D skcipher_request_ctx(ctx->areq);
> +	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(ctx->areq);
> +	struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
> +	struct meson_alg_template *algt =3D container_of(alg,
> +		struct meson_alg_template, alg.skcipher.base);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx(tfm);
> +	struct meson_dev *mc =3D op->mc;
> +	unsigned int ivsize =3D crypto_skcipher_ivsize(tfm);
> +	unsigned int blockmode =3D algt->blockmode;
> +	int i;
> +
> +	if (ctx->tloffset)
> +		return;
> +
> +	if (blockmode =3D=3D DESC_OPMODE_CBC) {
> +		memcpy(ctx->bkeyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
> +		dma_sync_single_for_device(mc->dev, ctx->keyiv.addr,
> +					   ctx->keyiv.len, DMA_TO_DEVICE);
> +	}
> +
> +	for (i =3D 0; i < mc->pdata->setup_desc_cnt; i++) {
> +		struct meson_desc *desc =3D
> +			&mc->chanlist[rctx->flow].tl[ctx->tloffset];
> +		int offset =3D i * 16;
> +
> +		desc->t_src =3D cpu_to_le32(ctx->keyiv.addr + offset);
> +		desc->t_dst =3D cpu_to_le32(offset);
> +		desc->t_status =3D cpu_to_le32(DESC_OWN | DESC_MODE_KEY | ctx->keyiv.l=
en);
> +
> +		ctx->tloffset++;
> +	}
> +}

[Severity: High]
Does meson_setup_keyiv_descs() leave the CBC IV outside the DMA mapping and
program each setup descriptor with ctx->keyiv.len instead of 16 bytes?

In meson_cipher(), ctx.keyiv.len is set to op->keylen (or AES_MAX_KEY_SIZE
for AES-192), so dma_map_single() and dma_sync_single_for_device() only
cover the first 16 or 32 bytes of ctx.bkeyiv and never map or flush the CBC
IV copied to offset 32 (AES_MAX_KEY_SIZE).  In addition, setting each of the
setup_desc_cnt descriptors at offset =3D i * 16 to transfer ctx->keyiv.len
bytes causes descriptors i > 0 to DMA-read outside the mapped range and up
to offset 64, which is 16 bytes past the end of the 48-byte ctx.bkeyiv
buffer.

Later commits in this series ("crypto: amlogic - Avoid kzalloc in engine
thread" and "crypto: amlogic: fix setup descriptor lengths and CBC IV copy")
partially adjust this, but still leave ECB mode mapping 16 or 32 bytes while
issuing 3 descriptors of length ctx->keyiv.len / 3 (5 or 10 bytes instead of
16) up to offset 32, and remove the IV update in meson_setup_keyiv_descs()
needed between multi-batch CBC kicks.

> +static bool meson_setup_data_descs(struct cipher_ctx *ctx)
> +{
> +	struct meson_cipher_req_ctx *rctx =3D skcipher_request_ctx(ctx->areq);
> +	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(ctx->areq);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx(tfm);
> +	struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
> +	struct meson_alg_template *algt =3D container_of(alg,
> +						       struct meson_alg_template,
> +						       alg.skcipher.base);
> +	struct meson_dev *mc =3D op->mc;
> +	struct meson_desc *desc =3D &mc->chanlist[rctx->flow].tl[ctx->tloffset];
> +	unsigned int blocksize =3D crypto_skcipher_blocksize(tfm);
> +	unsigned int blockmode =3D algt->blockmode;
> +	unsigned int maxlen =3D rounddown(DESC_MAXLEN, blocksize);
> +	unsigned int todo;
> +	u32 v;
> +
> +	ctx->tloffset++;
> +
> +	todo =3D min(ctx->cryptlen, maxlen);
> +	todo =3D min(todo, ctx->cryptlen);
> +	todo =3D min(todo, sg_dma_len(ctx->src_sg) - ctx->src_offset);
> +	todo =3D min(todo, sg_dma_len(ctx->dst_sg) - ctx->dst_offset);
> +
> +	desc->t_src =3D cpu_to_le32(sg_dma_address(ctx->src_sg) + ctx->src_offs=
et);
> +	desc->t_dst =3D cpu_to_le32(sg_dma_address(ctx->dst_sg) + ctx->dst_offs=
et);
> +
> +	ctx->cryptlen -=3D todo;
> +	ctx->src_offset +=3D todo;
> +	ctx->dst_offset +=3D todo;
> +
> +	v =3D DESC_OWN | blockmode | op->keymode | todo;
> +	if (rctx->op_dir =3D=3D MESON_ENCRYPT)
> +		v |=3D DESC_ENCRYPTION;
> +
> +	if (!ctx->cryptlen || ctx->tloffset =3D=3D MAXDESC)
> +		v |=3D DESC_LAST;
> +
> +	desc->t_status =3D cpu_to_le32(v);
> +
> +	return v & DESC_LAST;
> +}
> +
> +static int meson_kick_hardware(struct cipher_ctx *ctx)
> +{
> +	struct meson_cipher_req_ctx *rctx =3D skcipher_request_ctx(ctx->areq);
> +	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(ctx->areq);
> +	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx(tfm);
> +	struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
> +	struct meson_alg_template *algt =3D container_of(alg,
> +						       struct meson_alg_template,
> +						       alg.skcipher.base);
> +	struct meson_dev *mc =3D op->mc;
> +	unsigned int ivsize =3D crypto_skcipher_ivsize(tfm);
> +	unsigned int blockmode =3D algt->blockmode;
> +	enum dma_data_direction new_iv_dir;
> +	struct scatterlist *sg_head;
> +	void *new_iv;
> +	int err;
> +
> +	if (blockmode =3D=3D DESC_OPMODE_CBC) {
> +		struct scatterlist *sg_current;
> +		unsigned int offset;
> +
> +		if (rctx->op_dir =3D=3D MESON_ENCRYPT) {
> +			sg_current =3D ctx->dst_sg;
> +			sg_head =3D ctx->areq->dst;
> +			offset =3D ctx->dst_offset;
> +			new_iv_dir =3D DMA_FROM_DEVICE;
> +		} else {
> +			sg_current =3D ctx->src_sg;
> +			sg_head =3D ctx->areq->src;
> +			offset =3D ctx->src_offset;
> +			new_iv_dir =3D DMA_TO_DEVICE;
> +		}
> +
> +		if (ctx->areq->src =3D=3D ctx->areq->dst)
> +			new_iv_dir =3D DMA_BIDIRECTIONAL;
> +
> +		offset -=3D ivsize;
> +		new_iv =3D sg_virt(sg_current) + offset;
> +	}
> +
> +	if (blockmode =3D=3D DESC_OPMODE_CBC &&
> +	    rctx->op_dir =3D=3D MESON_DECRYPT) {
> +		dma_sync_sg_for_cpu(mc->dev, sg_head,
> +				    sg_nents(sg_head), new_iv_dir);
> +		memcpy(ctx->areq->iv, new_iv, ivsize);
> +	}
> +
> +	reinit_completion(&mc->chanlist[rctx->flow].complete);
> +	meson_dma_start(mc, rctx->flow);
> +	err =3D wait_for_completion_interruptible_timeout(&mc->chanlist[rctx->f=
low].complete,
> +							msecs_to_jiffies(500));
> +	if (err =3D=3D 0) {
> +		dev_err(mc->dev, "DMA timeout for flow %d\n", rctx->flow);
> +		return -EINVAL;
> +	} else if (err < 0) {
> +		dev_err(mc->dev, "Waiting for DMA completion is failed (%d)\n", err);
> +		return err;
> +	}
> +
> +	if (blockmode =3D=3D DESC_OPMODE_CBC &&
> +	    rctx->op_dir =3D=3D MESON_ENCRYPT) {
> +		dma_sync_sg_for_cpu(mc->dev, sg_head,
> +				    sg_nents(sg_head), new_iv_dir);
> +		memcpy(ctx->areq->iv, new_iv, ivsize);
> +	}

[Severity: High]
Can computing new_iv as sg_virt(sg_current) + offset read past the end of
sg_current's page when dma_map_sg() coalesces scatterlist entries?

meson_setup_data_descs() and meson_cipher() advance ctx->src_offset and
ctx->dst_offset using sg_dma_len(), which can exceed sg_current->length when
adjacent entries are merged by dma_map_sg().  Indexing sg_virt(sg_current)
by that DMA segment offset reads outside sg_current's virtual buffer (or
from the wrong scatterlist entry after coalesced segments).

Also, meson_kick_hardware() calls dma_sync_sg_for_cpu() over the entire
scatterlist (walking sg_nents(sg_head) on every batch) to read new_iv
without a matching dma_sync_sg_for_device() before meson_dma_start() on
decrypt or before the next batch's meson_dma_start() on multi-batch encrypt,
leaving dirty or stale CPU cache lines across the DMA transfer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D11

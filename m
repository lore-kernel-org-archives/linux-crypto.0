Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722324;
	b=vybdbycQIoNO1NyDgwmXhJy+en1o5MUGGEOud0zJJUYcNlyhifEScf8z/Jf2sYG/tIvo
	 hAUXk59rcBYmbqYoHNDDVIpK9+xc8j6tm1xtYyryk7/TqQE0VvnVGo56sZQRqi7mo8hsL
	 7LTGC8G2biuyHSxfsGbGUWS5KP7y4LolSGkDtEChaIYKfyEZaAbyIajG9Oz9GqJD8q5ia
	 KXsTKqr7Yz020KdoCOKzPuv/XVQfNrp1pkfLjg+9qpESdzy9+IIiyoDLoXNFk/hF7rA/G
	 Sr/TjciooR1lMrmTpmoeGc3UnyxLWEI/iG1x0fmBZ/5BlXkNPFD2lp8IgVSt3am3vJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722324;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QpSJK/iai0Uu6QRIbjzX2UqSB9VVD6gv6H14Jvr8nGQ=;
	b=qGK6ykPm+sJgpGJ5REddRBARf+ZafWQDH9xKg5ODN1DgAJJ3rVnCk4wBzX+KysjjPmX0
	 Xy8JdfCq5fIcLTrqayh0QLTPAO6XOG+BgBLqkza+gbD1liJN1Cgku0icnZRhWFUtq4O8s
	 y97B6uuatO8A4qVorNmGFzjQeaqY5FsN0BmmwA1B3Jc39nD70l+DIVlORKCpGB1AwrZvT
	 NVucx4j/f8XYCmdu8v08NcNvwxV4FRyX4GTsOTlSTOLBf9XMOHe5UyC32IwlcEWsQx7Ef
	 W4h7XLvCtwhA6V5GqT355UvBUluhkdIUMs5L5v/XwsSzg4ar5aFyL3ck8mIJvQaDdgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpkGIwmH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D109E606A31C;
	Thu, 26 Nov 2026 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpkGIwmH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD981F000C4;
	Thu, 26 Nov 2026 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722324;
	bh=QpSJK/iai0Uu6QRIbjzX2UqSB9VVD6gv6H14Jvr8nGQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jpkGIwmHrzPKByPi0Cp/tbAQLbBGNO7rzREbKe/9V4poAZaSfx6GYRnbWYtQFXcjT
	 4wrn5NtVOuqr7egTe0G+gnq6zlZvxmum513takVOnD6z9H3PmdVrA6Jim6QUmzxQo+
	 lmD3L8IpttJCx9skAAScBmZ9YwetJpuVLaHQAENYENHvvaCXffBZCSCjAl4fQLLx2V
	 4sgAK455znta9bOdgs2pMy5GMgFMLPqjOhihCQkbD+KVJiKLv+Cwhjk0uPItApjxo0
	 krRmHMuQTxpveXYI+s8AGmHkoS45IfxObW/yuR35U2eR34iZoXyDMZdHEj2WjhZ7JP
	 Nz/4tzD9H+OxA==
Message-ID: <sashiko-outbox-236117@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 11/25] crypto: amlogic - Process more than MAXDESCS
 descriptors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-12-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-12-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:45:23 +0000
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
- [High] crypto: amlogic: unmapped IV and out-of-bounds keyiv DMA length
  in meson_cipher()
- [High] crypto: amlogic: bad sg_virt() offset and DMA sync in
  meson_kick_hardware()
--

commit 685ee7508ec6e6946361c6c3e2f5421b6188d69b
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Process more than MAXDESCS descriptors

This commit reworks descriptor setup in the Amlogic GXL crypto driver to
process requests requiring more than MAXDESC descriptors in batches and
makes the number of key/IV setup descriptors configurable via platform
data.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto=
/amlogic/amlogic-gxl-cipher.c
> index c17ce5cc70a87..cb6b959bb1f96 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
[ ... ]
> @@ -76,6 +82,213 @@ static int meson_cipher_do_fallback(struct skcipher_r=
equest *areq)
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
Does meson_setup_keyiv_descs() leave the CBC IV unmapped and program an
out-of-bounds DMA length on each key/IV descriptor?

In meson_cipher(), ctx.keyiv.len is set to 16 (AES-128) or 32
(AES-192/256) and passed to dma_map_single(), so bytes 32..47 of the
48-byte ctx->bkeyiv buffer where the CBC IV is copied are never mapped or
flushed by dma_sync_single_for_device().  In addition, each of the
setup_desc_cnt descriptors at offset =3D i * 16 sets its transfer length to
ctx->keyiv.len instead of 16, causing hardware DMA to read past the DMA
mapping and past the end of ctx->bkeyiv.

A later patch in this series, commit "crypto: amlogic - Avoid kzalloc in
engine thread", sets ctx.keyiv.len to AES_MAX_KEY_SIZE + ivsize (48) for
CBC, but meson_setup_keyiv_descs() still encodes ctx->keyiv.len instead of
16 in each descriptor.

> +
> +static bool meson_setup_data_descs(struct cipher_ctx *ctx)
> +{
[ ... ]
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
[ ... ]
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
> +
> +	ctx->tloffset =3D 0;
> +
> +	return 0;
> +}

[Severity: High]
Can sg_virt(sg_current) + offset read out of bounds when dma_map_sg()
coalesces scatterlist entries?

ctx->src_offset and ctx->dst_offset track offsets within the coalesced DMA
segment of length sg_dma_len(sg_current), whereas sg_virt(sg_current) only
maps the single uncoalesced page buffer of length sg_current->length.
When dma_map_sg() merges contiguous entries, offset can exceed
sg_current->length (or index the wrong entry), reading past the end of
sg_current's virtual buffer.

Also, meson_kick_hardware() calls dma_sync_sg_for_cpu() over the entire
scatterlist on every batch without calling dma_sync_sg_for_device() to
hand ownership back to the device before meson_dma_start() runs (including
on in-place CBC decrypt and multi-batch CBC encrypt), and walks
sg_nents(sg_head) on every batch.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D11

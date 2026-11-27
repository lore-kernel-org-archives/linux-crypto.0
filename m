Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782284;
	b=Mev4Ie665N0UnE08IIu6UiRG70fKAvjgf5xv814YW7hvdCWzg8TBRJlTurixn5B4UXT4
	 aVVxYwHO2HS2LfmYDzLQbRr4TpU7vmxJcPr2HPIw0WSV1sKuhcbyWvkkmCHjj+kxDQWTu
	 NyUllx63Ov/IIkw0W8sHhHZ/Ts34HyGOTEJbKvbZHoDgLVSk94N2d2vJ+zNsSWJjHU18Y
	 ooZe1J5THmRRew56a5fkeqJSCMZG6Y6ecG8DNEBjjZ6C9ZuuEYkrZuvHYIsoqH0Sq+0tp
	 DSMpdo/lRmrpsBl2ldD+jkGW1XZUcBDZTh6edLFoDmHNG3mmkROGqEAdhLo09fazmcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782284;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g+3AGT7lsSUMycUTAeX4M8F4EAcVisB6S3gJdFvzz9c=;
	b=R5x9v2rEujHIfR21Mx0H3xjb3PluphSfQZSkDPyPkmdpFGpFnWhBVGGLOSeRyup1vh2O
	 eiU5V3/vRkNoz0tC/s7Wmm68JlaA9ayNQ2BZwFu7y6eE2OCg3nqzdzXjbMc95UqrWGh1u
	 KDTpWPSxmeKGFAyc5YpBY/voNnJzs62bIL/bkELuCbCd/OVDsM2V0zwG+YjANi0gXvmoD
	 5GZ4xDz8RO5m1VFtIy3HTEYDQPeq3vJxGXaTJUUxo4NPThjoPCK+X9Cd6/tOz2MPlgSue
	 KFZ1s+TnoxKbGZ9V7yrmG35unAutaaIdICWyvf3/Wc5gwvfAOoXgi/0o4IDd2eOa5iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k+M4K2JP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE43606A31E;
	Fri, 27 Nov 2026 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k+M4K2JP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2649F1F00899;
	Fri, 27 Nov 2026 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782284;
	bh=g+3AGT7lsSUMycUTAeX4M8F4EAcVisB6S3gJdFvzz9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k+M4K2JPpZ7sOEgaNF5aVl2zhKiidl4Q924G3sPvNYuxhnlOHZN7S8g8mQ8Btc3HQ
	 tKfHhJy2vpZgIlT9h6ivKIIpd4ol8g+lIa2AUP0kBi+sx2NOlzzGM9tQNcAn/OwDMe
	 5siF5wIpb2GppL5TjbC5tus8po5Jdq80fOjb6lA40hCzUWLc2b4JAGO7jGUFzF/ZIe
	 jTHivlB+m+5hcEkqzXdQ8armX1ERc1Qicuj4o4z6/PrraSgLEoqw6PXx69/vXAdrd8
	 XZ9PlVodz5N+ZbtW0tYjJ6aajEQdmp57Mr+VLPG/koktjJBzSQDQuRGl7bVu0ZfkqA
	 VNiQb6t03GUFw==
Message-ID: <sashiko-outbox-237372@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 13/30] crypto: amlogic - Introduce hasher
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-14-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-14-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:24:43 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] crypto: amlogic: 0-byte SHA DMA descriptor in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: double completion on error in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: unaligned DMA request ctx via
  ahash_request_ctx()
- [High] crypto: amlogic: invalid src DMA map on final in
  meson_hasher_req_map()
- [Medium] crypto: amlogic: leaked partial_addr DMA mapping in
  meson_kick_hardware()
- [Medium] crypto: amlogic: sg_virt() indexed by sg_dma_len() in
  amlogic-gxl-hasher
--

commit 531139f52bee7e6e883c924298c554e02337a015
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Introduce hasher

This commit adds hardware asynchronous SHA1, SHA224, and SHA256 hash
algorithm support to the Amlogic GXL crypto driver.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-hasher.c b/drivers/crypto=
/amlogic/amlogic-gxl-hasher.c
> new file mode 100644
> index 0000000000000..c83739ec34566
> --- /dev/null
> +++ b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
[ ... ]
> +static int meson_hasher_req_map(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	struct meson_hasher_tfm_ctx *tctx =3D crypto_ahash_ctx_dma(tfm);
> +	struct meson_dev *mc =3D tctx->mc;
> +	int ret;
> +
> +	if (!req->nbytes)
> +		return 0;
> +
> +	ret =3D dma_map_sg(mc->dev, req->src, sg_nents(req->src), DMA_TO_DEVICE=
);
> +	if (!ret) {
> +		dev_err(mc->dev, "Cannot DMA MAP request data\n");
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void meson_hasher_req_unmap(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	struct meson_hasher_tfm_ctx *tctx =3D crypto_ahash_ctx_dma(tfm);
> +	struct meson_dev *mc =3D tctx->mc;
> +
> +	if (!req->nbytes)
> +		return;
> +
> +	dma_unmap_sg(mc->dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
> +}

[Severity: High]
Can meson_hasher_req_map() and meson_hasher_req_unmap() dereference an
invalid req->src during crypto_ahash_final()?

The ahash final() callback does not consume input data, and callers such
as ahash_def_finup_finish1() invoke final(req) after update(req) without
clearing req->nbytes.  Although meson_hasher_do_one_request() sets
ctx.nbytes =3D 0 when rctx->final_req is true, it still sets
ctx.src_sg =3D req->src and calls meson_hasher_req_map() and
meson_hasher_req_unmap(), which check req->nbytes instead of
rctx->final_req.  If the caller freed or nulled req->src after update()
completed, sg_nents(req->src) and sg_dma_len(ctx.src_sg) will dereference
a dangling or NULL scatterlist pointer.

[ ... ]

> +static int meson_kick_hardware(struct hasher_ctx *ctx)
> +{
> +	struct ahash_request *req =3D ahash_request_cast(ctx->areq);
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	struct meson_hasher_req_ctx *rctx =3D ahash_request_ctx(req);
> +	struct meson_hasher_tfm_ctx *tctx =3D crypto_ahash_ctx_dma(tfm);
> +	struct meson_dev *mc =3D tctx->mc;
> +	struct meson_flow *flow =3D &mc->chanlist[rctx->flow];
> +	int ret;
> +
> +	reinit_completion(&flow->complete);
> +	meson_dma_start(mc, rctx->flow);
> +
> +	ret =3D wait_for_completion_timeout(&flow->complete,
> +					  msecs_to_jiffies(500));
> +	if (ret =3D=3D 0) {
> +		dev_err(mc->dev, "DMA timeout for flow %d\n", rctx->flow);
> +		return -EINVAL;
> +	} else if (ret < 0) {
> +		dev_err(mc->dev, "Waiting for DMA completion is failed (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	if (rctx->partial_mapped) {
> +		dma_unmap_single(mc->dev, rctx->partial_addr,
> +				 rctx->partial_size,
> +				 DMA_TO_DEVICE);
> +		rctx->partial_size =3D 0;
> +		rctx->partial_mapped =3D false;
> +	}

[Severity: Medium]
Does meson_kick_hardware() leak the rctx->partial_addr DMA mapping when
wait_for_completion_timeout() times out?

When rctx->partial_mapped is true and the wait fails, returning early
skips dma_unmap_single() here, and the fail label in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr.

> +
> +	ctx->tloffset =3D 0;
> +
> +	return 0;
> +}
[ ... ]
> +static int meson_hasher_do_one_request(struct crypto_engine *engine, voi=
d *areq)
> +{
> +	struct ahash_request *req =3D ahash_request_cast(areq);
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	struct meson_hasher_tfm_ctx *tctx =3D crypto_ahash_ctx_dma(tfm);
> +	struct meson_hasher_req_ctx *rctx =3D ahash_request_ctx(req);
> +	struct meson_dev *mc =3D tctx->mc;
> +	struct hasher_ctx ctx =3D {
> +		.tloffset =3D 0,
> +		.src_offset =3D 0,
> +		.nbytes =3D rctx->final_req ? 0 : req->nbytes,
> +		.src_sg =3D req->src,
> +		.areq =3D areq,
> +	};
> +	unsigned int blocksize =3D crypto_ahash_blocksize(tfm);
> +	unsigned int digest_size =3D crypto_ahash_digestsize(tfm);
> +	bool final_req =3D rctx->final_req;
> +	int ret;
> +
> +	ctx.state_addr =3D dma_map_single(mc->dev, rctx->state,
> +					sizeof(rctx->state), DMA_BIDIRECTIONAL);
> +	ret =3D dma_mapping_error(mc->dev, ctx.state_addr);
> +	if (ret) {
> +		dev_err(mc->dev, "Cannot DMA MAP SHA state buffer");
> +		goto fail_map_single;
> +	}
> +
> +	ret =3D meson_hasher_req_map(req);
> +	if (ret)
> +		goto fail_map_req;
> +
> +	for (;;) {
> +		unsigned int len =3D ctx.src_sg ?
> +			min(sg_dma_len(ctx.src_sg) - ctx.src_offset, ctx.nbytes) : 0;
> +
> +		ctx.src_addr =3D 0;
> +		ctx.todo =3D 0;
> +
> +		if (!rctx->final_req && !ctx.nbytes)
> +			break;
> +
> +		meson_setup_state_descs(&ctx);
> +
> +		if (rctx->partial_size && rctx->partial_size < blocksize) {
> +			ret =3D meson_fill_partial_buffer(&ctx, len);
> +			if (ret)
> +				goto fail;
> +		} else if (len && len < blocksize) {
> +			memcpy(rctx->partial, sg_virt(ctx.src_sg) + ctx.src_offset, len);

[Severity: Medium]
Can indexing sg_virt(ctx.src_sg) by ctx.src_offset read past the end of
ctx.src_sg's virtual buffer when dma_map_sg() coalesces scatterlist
entries?

ctx.src_offset and len are bounded by sg_dma_len(ctx.src_sg), and
ctx.src_sg only advances when ctx.src_offset reaches
sg_dma_len(ctx.src_sg).  If dma_map_sg() merges adjacent entries so that
sg_dma_len(ctx.src_sg) exceeds ctx.src_sg->length, ctx.src_offset can grow
larger than ctx.src_sg->length, causing memcpy() here and in
meson_fill_partial_buffer() to read out of bounds from
sg_virt(ctx.src_sg).

> +
> +			rctx->partial_size =3D len;
> +			ctx.nbytes -=3D len;
> +			ctx.src_offset +=3D len;
> +		} else if (len) {
> +			ctx.src_addr =3D sg_dma_address(ctx.src_sg) + ctx.src_offset;
> +			ctx.todo =3D min(rounddown(DESC_MAXLEN, blocksize),
> +				       rounddown(len, blocksize));
> +			ctx.nbytes -=3D ctx.todo;
> +			ctx.src_offset +=3D ctx.todo;
> +		}
> +
> +		if (ctx.src_sg && ctx.src_offset =3D=3D sg_dma_len(ctx.src_sg)) {
> +			ctx.src_offset =3D 0;
> +			ctx.src_sg =3D sg_next(ctx.src_sg);
> +		}
> +
> +		if (!ctx.todo && ctx.nbytes)
> +			continue;
> +
> +		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
> +			continue;
> +
> +		if (meson_setup_data_descs(&ctx)) {
> +			ret =3D meson_kick_hardware(&ctx);
> +			if (ret)
> +				goto fail;
> +		}
> +	}

[Severity: High]
Does meson_hasher_do_one_request() emit and kick a 0-byte SHA DMA
descriptor with t_src =3D 0 when a non-final update() leaves trailing bytes
in rctx->partial?

When a non-final update() has trailing sub-block bytes, ctx.tloffset is
already non-zero when those bytes are copied into rctx->partial: either
meson_setup_state_descs() just queued state descriptors (when
!rctx->begin_req), or an earlier iteration in the same request queued full
blocks without setting DESC_LAST (because ctx.nbytes was still non-zero).
Buffering the trailing bytes reduces ctx.nbytes to 0 while leaving
ctx.todo =3D 0 and ctx.src_addr =3D 0.  Because ctx.nbytes is 0,
rctx->final_req is false, and ctx.tloffset > 0, neither continue guard
triggers, so meson_setup_data_descs() and meson_kick_hardware() submit a
0-length descriptor at physical address 0 to the hardware.

> +
> +fail:
> +	meson_hasher_req_unmap(req);
> +
> +fail_map_req:
> +	dma_unmap_single(mc->dev, ctx.state_addr, sizeof(rctx->state),
> +			 DMA_BIDIRECTIONAL);
> +
> +fail_map_single:
> +	if (final_req && ret =3D=3D 0)
> +		memcpy(req->result, rctx->state, digest_size);
> +
> +	local_bh_disable();
> +	crypto_finalize_hash_request(engine, req, ret);
> +	local_bh_enable();
> +
> +	return ret;
> +}

[Severity: High]
Does returning a negative ret after crypto_finalize_hash_request() complete
req twice on error?

crypto_finalize_hash_request() calls crypto_request_complete(), waking the
caller who may free req.  When do_one_request() then returns ret < 0,
crypto_pump_requests() calls crypto_request_complete(async_req, ret) a
second time on the already-completed request:

crypto/crypto_engine.c:crypto_pump_requests() {
    ...
	ret =3D op->do_one_request(engine, async_req);

	/* Request unsuccessfully executed by hardware */
	if (ret < 0) {
		if (!engine->retry_support ||
		    (ret !=3D -ENOSPC)) {
			dev_err(engine->dev,
				"Failed to do one request from queue: %d\n",
				ret);
			goto req_err_1;
		}
    ...
req_err_1:
	crypto_request_complete(async_req, ret);
    ...
}

meson_hasher_do_one_request() should return 0 after calling
crypto_finalize_hash_request(), matching meson_handle_cipher_request().

[ ... ]

> +static int meson_hasher_init(struct crypto_tfm *tfm)
> +{
> +	struct meson_hasher_tfm_ctx *tctx =3D crypto_tfm_ctx_dma(tfm);
> +	struct crypto_ahash *atfm =3D __crypto_ahash_cast(tfm);
> +	struct hash_alg_common *alg =3D crypto_hash_alg_common(atfm);
> +	struct meson_alg_template *algt =3D container_of(alg,
> +		struct meson_alg_template, alg.ahash.base.halg);
> +
> +	crypto_ahash_set_reqsize_dma(atfm, crypto_ahash_statesize(atfm));

[Severity: High]
Should the request callbacks retrieve rctx with ahash_request_ctx_dma(req)
instead of ahash_request_ctx(req), and align the DMA buffers in
struct meson_hasher_req_ctx to ARCH_DMA_MINALIGN?

meson_hasher_init() reserves DMA alignment padding via
crypto_ahash_set_reqsize_dma(), but every callback in this file uses
ahash_request_ctx(req), which is only aligned to CRYPTO_MINALIGN (8 bytes
on arm64), and struct meson_hasher_req_ctx marks state and partial with
____cacheline_aligned (64 bytes on arm64, smaller than
ARCH_DMA_MINALIGN =3D 128).  As a result, the DMA-mapped state and partial
buffers share DMA cachelines with struct ahash_request and CPU-updated
fields in struct meson_hasher_req_ctx, which can corrupt adjacent fields
during DMA cacheline invalidation on non-coherent systems.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D13

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782454;
	b=2G+uDFHtXtSR5I0EivSjw6TxmZEycPaAAjKZBCxTXPPKFSaNmJzvziTETIm7IcE996+W
	 J/UmP9/wS6tP+987ocGLxJCbydJZcsq4bKZwvmH2VwarK86j26pgih3sZxbQEDuaqUtu0
	 o5tYPJzO1x4RoAK1QEMrh7LoUG+g7jLd9y2t91LqE9EAWUR1kyyXWYBzMRaCzPE3F0Fvd
	 kyKH8MvmCY3ri0Onuy2lr/3sZeFe17SM06wZIo68yhFwfKo+0FVYy5Q6GGka/rpdgmSVu
	 vG2YeVNRvriuLNw3NGJRGMF7FQRq5MSBQgE1z+GKF+V1VAgns5ARSEjk+P6HSw2nE7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782454;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uB3byrI6j5a3+iN0MqWtCUyxgozP13CLCuikc54zyEQ=;
	b=BhHztmFvIE77YfQnoub80CqXV2ms3E7i+scGR6Kl8hc63Lzrlu84wkuxGObTyDrMryox
	 x/8nJ8H+MD1a+iJZ18MupQzuoQGAX7K5DhOshB46amZ5S8/Pt9396u/705IBVsd429k1j
	 tOCbDCZhY7iUlXQSw0k3TeJz8v4Nw3AwaGkYEcxondqiZx1pUmkhRf90UgCAJrBv9jw0R
	 oBA5iN6J/j14SuVWRk9buuCocULEpCFAyzzftUb4EtFV7k77Zkr/04AnPQV9QxtWrsQqO
	 OKP2L2h1PlZFSuKJTd9FVSUhe5uUrvGUBAVfjGDPl/O5j98jFtkNfAYz2vm0j3+Lyfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXLSJ3JX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5EC606A31C;
	Fri, 27 Nov 2026 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXLSJ3JX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04701F00893;
	Fri, 27 Nov 2026 12:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782454;
	bh=uB3byrI6j5a3+iN0MqWtCUyxgozP13CLCuikc54zyEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BXLSJ3JXe8EAWw8ljYND85NufYlJetHC1DhVUSSXg/Qo+qur5BYhy/7tZ2FcN5P5w
	 Xu08FMUbKzL/2ASMjwD2lO2E9vzYLeqsDW7Hip+Tw6U37BA2Fik0lPZ6FR0TmrShLG
	 eZxq/etJLFNefKWt3Vjh381KsGAUFW7/LFAJagw433kkIzUIV1+pqwaoNZaceqnkk4
	 5poYTNOiCBYOsAKdkpDuTYy72UQfRcPlzq3jCQ6D9jfujXk+/XtKPsh0CdhGjrR4sI
	 +uKolPEp7s+zusGY8EautUabq0JqMBRG1eaUyqT01EVsXfyccLDk82CnPTzYTioIan
	 d8LJ1GGNm6kIA==
Message-ID: <sashiko-outbox-237390@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 15/30] crypto: amlogic - Add support for G12-series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-16-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-16-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:27:33 +0000
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
- [High] crypto: amlogic: 0-byte SHA DMA desc on partial update in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: double completion on error in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: broken key/IV descriptors and shared keyiv in
  meson_cipher()
- [Medium] crypto: amlogic: partial_addr DMA leak on
  meson_kick_hardware() timeout
--

commit 6d405eb12267511d2b1777a56617785870d3b0c4
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Add support for G12-series

This commit adds platform data and the "amlogic,g12a-crypto" device tree
match entry to support the crypto engine and hardware hasher on Amlogic
G12-series SoCs.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index f530e238812eb..0fb0da20e06b2 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
> @@ -282,11 +282,23 @@ static const struct meson_pdata meson_gxl_pdata =3D=
 {
>  	.support_192bit_key =3D true,
>  };
> =20
> +static const struct meson_pdata meson_g12a_pdata =3D {
> +	.descs_reg =3D 0x0,
> +	.status_reg =3D 0x8,
> +	.setup_desc_cnt =3D 1,
> +	.hasher_supported =3D true,
> +	.support_192bit_key =3D false,
> +};

[Severity: High]
Enabling hasher_supported on G12A activates meson_hasher_do_one_request(),
where non-block-aligned crypto_ahash_update() calls can program a 0-length
DMA descriptor from physical address 0x0.

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_do_one_request() {
    ...
		meson_setup_state_descs(&ctx);

		if (rctx->partial_size && rctx->partial_size < blocksize) {
			ret =3D meson_fill_partial_buffer(&ctx, len);
			if (ret)
				goto fail;
		} else if (len && len < blocksize) {
			memcpy(rctx->partial, sg_virt(ctx.src_sg) + ctx.src_offset, len);

			rctx->partial_size =3D len;
			ctx.nbytes -=3D len;
			ctx.src_offset +=3D len;
		}
    ...
		if (!ctx.todo && ctx.nbytes)
			continue;

		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
			continue;

		if (meson_setup_data_descs(&ctx)) {
			ret =3D meson_kick_hardware(&ctx);
    ...
}

When an update request buffers a trailing sub-block tail (< blocksize) into
rctx->partial while ctx.tloffset is already non-zero (either because an
earlier iteration queued full blocks without setting DESC_LAST while
ctx.nbytes was non-zero, or because meson_setup_state_descs() queued a state
descriptor at the top of the loop when rctx->begin_req is false), ctx.nbytes
becomes 0 while ctx.todo and ctx.src_addr remain 0.  Both continue guards
evaluate to false, so execution falls through to meson_setup_data_descs()
and meson_kick_hardware() with a 0-byte descriptor at src_addr 0 (and the
later commit "crypto: amlogic: hasher: add one-shot digest path" only guards
the rctx->final_req case).

In addition, on final() requests (where rctx->final_req is true and
ctx.nbytes is forced to 0), meson_hasher_req_map() and
meson_hasher_req_unmap() only check !req->nbytes, while the loop reads
sg_dma_len(ctx.src_sg) whenever req->src is non-NULL even when ctx.nbytes is
0.

[Severity: High]
When meson_hasher_do_one_request() fails (for example on a DMA mapping error
or a hardware timeout in meson_kick_hardware()), can returning a negative
ret after crypto_finalize_hash_request() complete the request twice?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_do_one_request() {
    ...
	local_bh_disable();
	crypto_finalize_hash_request(engine, req, ret);
	local_bh_enable();

	return ret;
}

Because engine->retry_support is false, crypto_pump_requests() treats a
negative return from do_one_request() as an unfinalized error and calls
crypto_request_complete() a second time, risking a use-after-free if the
completion callback freed the request.  Like meson_handle_cipher_request(),
this should return 0 after calling crypto_finalize_hash_request().

[Severity: Medium]
Does meson_kick_hardware() leak the rctx->partial_addr DMA mapping when
wait_for_completion_timeout() fails?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_kick_hardware() {
    ...
	ret =3D wait_for_completion_timeout(&flow->complete,
					  msecs_to_jiffies(500));
	if (ret =3D=3D 0) {
		dev_err(mc->dev, "DMA timeout for flow %d\n", rctx->flow);
		return -EINVAL;
	} else if (ret < 0) {
		dev_err(mc->dev, "Waiting for DMA completion is failed (%d)\n", ret);
		return ret;
	}

	if (rctx->partial_mapped) {
		dma_unmap_single(mc->dev, rctx->partial_addr,
				 rctx->partial_size,
				 DMA_TO_DEVICE);
    ...
}

When meson_fill_partial_buffer() DMA-maps rctx->partial, a timeout returns
before reaching dma_unmap_single(), and the fail path in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr.

[Severity: High]
Can concurrent or multi-batch skcipher requests in meson_cipher() corrupt
the key and IV or read outside the DMA mapping?

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_setup_keyiv_descs() {
    ...
	if (blockmode =3D=3D DESC_OPMODE_CBC) {
		memcpy(op->keyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
		dma_sync_single_for_device(mc->dev, ctx->keyiv.addr,
					   ctx->keyiv.len, DMA_TO_DEVICE);
	}

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

First, op->keyiv lives in struct meson_cipher_tfm_ctx rather than the
per-request context, so concurrent CBC requests on the same transform
dispatched across different hardware flows overwrite op->keyiv +
AES_MAX_KEY_SIZE and race on dma_map_single() and dma_unmap_single() of
op->keyiv.

Second, each setup descriptor programs the full ctx->keyiv.len from
ctx->keyiv.addr + i * 16, reading past the 48-byte op->keyiv buffer and
DMA mapping when setup_desc_cnt is 3; the later commit "crypto: amlogic: fix
setup descriptor lengths and CBC IV copy" divides ctx->keyiv.len by
setup_desc_cnt, which in ECB mode (where ctx->keyiv.len is 16 or 32)
truncates the descriptor length to 16 / 3 =3D 5 or 32 / 3 =3D 10 bytes and =
still
accesses offsets 16 and 32 outside the DMA-mapped key buffer.

Third, that later commit removes the CBC IV copy and DMA sync from
meson_setup_keyiv_descs(), so multi-batch CBC requests exceeding MAXDESC
descriptors reload the stale initial IV from op->keyiv on subsequent batches
after meson_kick_hardware() updates ctx->areq->iv.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D15

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722904;
	b=ExsQXcBgGHqJfvP1mPuEjchhS8FjSjb6jgCRtwmfXtxIHmZJATykAt1SmdbRFncXokVG
	 te97OvDvFKZvUEx1M9CYSxD0uUnDpfbEksRIi2XITUxppyVFSf+yJOvjNtHLeE22mvCRe
	 gSSmlu21OxFzPoa08E7r4zJyVYHsPo6lan7gUXLVEEGs9Kdhugw6yCvwfcWYE5hs7euIt
	 Vc297/34SAB5GqayajAiRiojBSFiWny1IsJ2GE2ykv7XzOBiuidmY915lo3SG7IzRv30s
	 LaqI2hs4LR+6/Vz47DjPTdIGFyKCurm6h9jfEm6UrF5DGddmaFKkq8cWW/Yd+Xgi/Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722904;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OTLReDXIQ9w1vGBEAoyOL0h+q14QC0GH0MQlClgxmUI=;
	b=afTL4hkFAllpxqWivbvK6LF9cwWDS282DKl9sh+v5I8Bh1MxhPYR1tTCoT3kib3muKpm
	 R5gk6+u2NRqSernXVaLtpyGC8T//hJD0repgrTRoErlgN+IsBTU9piJ+nFznERNDdxgMB
	 O2OAppYzBh2BnBHefLkWN+zwURsfxhAuDvV3UVOS5gRtX37oXk6CXxzBOoXcQreNlG01Q
	 slHWcmQq3lD3Jukv3Hlk06fFqaF9Y/QqznL5/LzGMnNutc0+9tXR7ofGutaYgXPq1r9yU
	 szJSQR9ZSxTk/Uu5jn5VFwR82jiMme4oxWBoqU0sSF+J9x2PZhhT4VQI1Ozn72kOGeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5CSNN+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E98606A31C;
	Thu, 26 Nov 2026 19:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5CSNN+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD6F1F000C0;
	Thu, 26 Nov 2026 19:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722904;
	bh=OTLReDXIQ9w1vGBEAoyOL0h+q14QC0GH0MQlClgxmUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f5CSNN+J1CuKSJE6FR3mgNbqWlMfsbitNyxv43Q3YzDjGQAtIqLzyc1/2iMYp/mzV
	 YzeUGyD5b5FKY3Axzp7+i1ZZzdn4PYKhU7xZpFuN7nSkvS5/MGjR+iQ69QTKDU4CWC
	 ON3L2tag94BSMvM+ZEpeWCvQVQ4V3y2oVjzsNneFDbH3fekr7eGdxMJdFbG2B2YbCn
	 ZXT/LdmRTHa8Ae6K/NHesnDb2bAVfUsPCt3symh7HCIyJHV/ofHS5vTQHD/k8hThV5
	 dElsr9B10kdt0L2XrC3LcI6GlwsRPoko7s3l5uQydnUs3aZqpGGINXfWDSnq36mDDV
	 4icYmFxQsu6Rw==
Message-ID: <sashiko-outbox-236129@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 15/25] crypto: amlogic - Add support for G12-series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-16-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-16-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:55:03 +0000
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
- [High] crypto: amlogic: 0-byte SHA DMA desc and double complete in
  hasher request
- [High] crypto: amlogic: OOB DMA length and shared keyiv race in
  meson_cipher()
- [Medium] crypto: amlogic: debugfs leak and UAF on error_hasher in
  meson_crypto_probe()
- [Medium] crypto: amlogic: unregister of failed alg in
  meson_register_algs() rollback
- [Medium] crypto: amlogic: partial_addr DMA leak on
  meson_kick_hardware() timeout
- [Medium] crypto: amlogic: engine/DMA leak and early IRQ in
  meson_allocate_chanlist()
--

commit df12ec18bc93360a5cdf078f04efac1cfd6bdee7
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Add support for G12-series

This commit adds platform data and the "amlogic,g12a-crypto" device tree
compatible entry to support the Amlogic G12-series crypto engine, including
hardware hasher support.

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

[Severity: High]
Can enabling hasher_supported emit a bogus 0-length DMA descriptor from
physical address 0 during non-block-aligned update() requests, and double
complete failed hash requests?

In meson_hasher_do_one_request(), meson_setup_state_descs() writes a state
descriptor and increments ctx.tloffset before checking whether the
remaining bytes are shorter than blocksize and only buffered into
rctx->partial.  The same state is reached when a single update() contains
one or more full blocks followed by a sub-block tail, because the full
block increments ctx.tloffset without setting DESC_LAST (as ctx->nbytes is
still non-zero).  Once the trailing bytes are copied into rctx->partial,
ctx.nbytes and ctx.todo are both 0 while ctx.tloffset is non-zero, so
execution falls through to meson_setup_data_descs() and
meson_kick_hardware() with ctx.src_addr =3D=3D 0 and ctx.todo =3D=3D 0:

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
		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
			continue;

		if (meson_setup_data_descs(&ctx)) {
			ret =3D meson_kick_hardware(&ctx);
    ...
}

Also in the hasher path:
- on final() requests (rctx->final_req =3D=3D true), meson_hasher_do_one_re=
quest()
  forces ctx.nbytes =3D 0, but meson_hasher_req_map() and
  meson_hasher_req_unmap() only check !req->nbytes instead of
  (!req->nbytes || rctx->final_req), and the loop reads
  sg_dma_len(ctx.src_sg) whenever req->src is non-NULL even when
  req->nbytes =3D=3D 0 and req->src was never DMA-mapped.
- at the end of meson_hasher_do_one_request(), returning a negative ret
  after calling crypto_finalize_hash_request(engine, req, ret) causes
  crypto_pump_requests() to call crypto_request_complete() a second time
  on the same request; do_one_request callbacks must return 0 after
  finalizing the request.

[Severity: Medium]
Does meson_crypto_probe() leak mc->dbgfs_dir and leave a dangling mc
pointer in debugfs if meson_hasher_register() fails?

With hasher_supported set to true, meson_hasher_register() registers the
ahash algorithms and can now fail and jump to error_hasher.
meson_crypto_probe() creates the "gxl-crypto" debugfs directory and "stats"
file (with mc as seq->private) before calling meson_hasher_register(), but
the error_hasher unwind path does not call
debugfs_remove_recursive(mc->dbgfs_dir):

drivers/crypto/amlogic/amlogic-gxl-core.c:meson_crypto_probe() {
    ...
	err =3D meson_hasher_register(mc);
	if (err)
		goto error_hasher;

	return 0;

error_hasher:
	meson_cipher_unregister(mc);
error_alg:
	meson_free_chanlist(mc, mc->flow_cnt - 1);
	return err;
}

When probe fails, devres frees mc while /sys/kernel/debug/gxl-crypto/stats
remains registered, causing a use-after-free in meson_debugfs_show() if the
file is read.

[Severity: Medium]
Does meson_kick_hardware() leak the rctx->partial_addr DMA mapping when
wait_for_completion_timeout() times out?

meson_fill_partial_buffer() maps rctx->partial via dma_map_single() and
sets rctx->partial_mapped =3D true.  If wait_for_completion_timeout() retur=
ns
0 in meson_kick_hardware(), it returns -EINVAL before reaching the
dma_unmap_single() block for rctx->partial_addr, and the fail label in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr:

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_kick_hardware() {
    ...
	if (ret =3D=3D 0) {
		dev_err(mc->dev, "DMA timeout for flow %d\n", rctx->flow);
		return -EINVAL;
	}
    ...
	if (rctx->partial_mapped) {
		dma_unmap_single(mc->dev, rctx->partial_addr,
				 rctx->partial_size, DMA_TO_DEVICE);
		rctx->partial_mapped =3D false;
	}
    ...
}

> +	.support_192bit_key =3D false,
> +};
> +
>  static const struct of_device_id meson_crypto_of_match_table[] =3D {
>  	{
>  		.compatible =3D "amlogic,gxl-crypto",
>  		.data =3D &meson_gxl_pdata,
>  	},
> +	{
> +		.compatible =3D "amlogic,g12a-crypto",
> +		.data =3D &meson_g12a_pdata,
> +	},

[Severity: High]
Can concurrent CBC requests on the same transform corrupt each other's IV
and DMA mapping through op->keyiv, and does meson_setup_keyiv_descs() read
past the end of op->keyiv when setup_desc_cnt > 1?

op->keyiv lives in struct meson_cipher_tfm_ctx (per-TFM) rather than
struct meson_cipher_req_ctx (per-request), while meson_skencrypt() and
meson_skdecrypt() dispatch requests across mc->flow_cnt crypto_engine
threads via meson_get_engine_number().  Concurrent CBC requests sharing a
TFM overwrite op->keyiv + AES_MAX_KEY_SIZE with their own areq->iv and race
on dma_map_single(), dma_sync_single_for_device(), and dma_unmap_single()
in meson_cipher() and meson_setup_keyiv_descs().

In addition, meson_setup_keyiv_descs() programs every descriptor in the
setup_desc_cnt loop with the full ctx->keyiv.len instead of the 16-byte
chunk length at offset =3D i * 16:

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

When setup_desc_cnt is 3 (GXL), descriptors i =3D 1 and i =3D 2 read up to
offset 32 + 48 =3D 80 bytes in CBC mode, 32 bytes past the 48-byte op->keyiv
buffer and outside its DMA mapping.

[Severity: Medium]
Does meson_register_algs() attempt to unregister the algorithm that just
failed to register on its error path?

meson_register_algs() sets algs[i].mc =3D mc before calling
crypto_engine_register_skcipher() or crypto_engine_register_ahash().  If
registration fails for entry i, it calls meson_unregister_algs() without
clearing algs[i].mc first:

drivers/crypto/amlogic/amlogic-gxl-core.c:meson_register_algs() {
    ...
	for (i =3D 0; i < count; i++) {
		algs[i].mc =3D mc;
		switch (algs[i].type) {
		case CRYPTO_ALG_TYPE_SKCIPHER:
			err =3D crypto_engine_register_skcipher(&algs[i].alg.skcipher);
			if (err) {
				dev_err(mc->dev, "Fail to register %s\n",
					algs[i].alg.skcipher.base.base.cra_name);
				meson_unregister_algs(mc, algs, count);
				return err;
			}
			break;
    ...
}

Because meson_unregister_algs() unregisters every entry with a non-NULL
algs[i].mc (and also never resets algs[i].mc =3D NULL afterward), it calls
crypto_engine_unregister_skcipher() or crypto_engine_unregister_ahash() on
the entry that failed registration, triggering a WARN() in
crypto_unregister_alg().

[Severity: Medium]
Does meson_allocate_chanlist() leak already-started crypto_engine threads
and coherent DMA buffers if requesting an IRQ fails on channel i > 0, and
can an early IRQ fire before init_completion()?

In meson_allocate_chanlist(), if platform_get_irq() or devm_request_irq()
fails on iteration i > 0, the function returns directly instead of
unwinding channels 0 .. i - 1 via meson_free_chanlist(), leaking their
running crypto_engine kthreads and dma_alloc_coherent() descriptor rings.
In the same loop, devm_request_irq() is called before
init_completion(&mc->chanlist[i].complete), so an interrupt arriving right
after registration calls complete() in meson_irq_handler() on an
uninitialized completion:

drivers/crypto/amlogic/amlogic-gxl-core.c:meson_allocate_chanlist() {
    ...
	for (i =3D 0; i < mc->flow_cnt; i++) {
		mc->chanlist[i].irq =3D platform_get_irq(pdev, i);
		if (mc->chanlist[i].irq < 0)
			return mc->chanlist[i].irq;

		err =3D devm_request_irq(mc->dev, mc->chanlist[i].irq,
				       meson_irq_handler, 0, "aml-crypto", mc);
		if (err < 0) {
			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
			return err;
		}

		init_completion(&mc->chanlist[i].complete);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D15

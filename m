Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783073;
	b=Dc8HbtfQ98++t/eKveCej3tXrPklsIHgDAN4bppswBAIcwShg35MVm3wQUjes6lmwkTl
	 xwY0VgPS92kbkDRYbxRio17O+DjOFr+xhpTm9EXdR7p7eigU6JqUANJ6jURkoaqbDVMWK
	 /GHBIWj/jlmSZhjfZe3D91hFLzYsAI19gHRhRpWVwX4H/tIFQ2jXn1EJCNwLJrvsYIdic
	 nji5oX0xP2zdp9o589kwMqeyam7z+Ag8A7iTJlPlzverqAnjWO1HZILmK3mEh8wRlizHp
	 VJG6x09JofV+3Et7M1edW8LJh1JxErrxt+G7RaEx8KIsn5H+rSVWKdmt7vCy0ACwcog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783073;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t8/Dt8KF407jZhcwuZhsFCWRhqIWKjAElIH/rbAjAOs=;
	b=Idq2aleE6yrvG3E3vHXLHPgfPbEqFC6URbtkQl+cxR5ovBUx3xTTmf/ZPdkV+QAXMvkW
	 GX8OBWxUd5X+yq+bCObAsd8uUGwtIpXQ335qQLdaGAVKq/PndtoDI9pjd1V33PRJ0GqjX
	 wZbRHcZfcHTi/mHODbfQ8mS2D9HSH3dw5Emg7awa9eveTz1gzGnm/fdUQQdtQJZi8Essu
	 3Cr8GSp/mt0hZtCVh7QY8u+ZmcARUD47wogckzfoACH9XZXkhRQmykX+AZ/Tg1Mt/WTE0
	 WYjZsPok42Lp/WIJ1Su56lUY0LqIJqsJi71i63etBnJ8WrKf9DIEBwjfW5HXHUKb7Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ap+C5Q+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9804606A31C;
	Fri, 27 Nov 2026 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ap+C5Q+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B5F1F00893;
	Fri, 27 Nov 2026 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795783073;
	bh=t8/Dt8KF407jZhcwuZhsFCWRhqIWKjAElIH/rbAjAOs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ap+C5Q+5hq/JoCsoBwIzqoY48uZaqSqvsWPl4CfzwKJOKv/ti4KyRe9GGhfkqxJpt
	 wPB32eZ7/o9MCcMns01zbwzitykmvXSO5lJ/rwXNqg/kJH1s5T4FiJFg5vypfrUO0h
	 EAwY3OLF3ANu8XP/LtAVYtRkkdJMUGNLBBFmLImm3J7iEXl4w0O2d00vZEdU3UnYlT
	 YykK7Ja9OQ7CrSFbZj41mf/TlElFNEbzYpGTl9qX3he/8OKIdZbvy4ctKNJhIhdvBl
	 F9+DxXm72hJL2XbK++b+MjrZKLrLIecxIhahc9QJRXhoo2nH81mx1D/KHeqUdGTi6O
	 hj4ZHkJN+wuMQ==
Message-ID: <sashiko-outbox-237420@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 30/30] arm64: dts: amlogic: use the system clock for
 A1/S4 crypto
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>
In-Reply-To: <20261127120103.1532882-31-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-31-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:37:52 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [High] crypto: amlogic: bad ECB key length and offset in
  meson_setup_keyiv_descs()
- [High] crypto: amlogic: missing CBC IV update between batches in
  meson_cipher()
- [High] crypto: amlogic: spurious zero-length SHA DMA descriptor on
  sub-block update
- [High] crypto: amlogic: unaligned DMA request ctx via
  ahash_request_ctx() in hasher
- [High] crypto: amlogic: unsynchronized per-TFM keyiv mutation in
  meson_cipher()
- [Medium] crypto: amlogic: DMA mapping leak of partial_addr in
  meson_kick_hardware()
- [Medium] crypto: amlogic: dangling algs[i].mc pointer left by
  meson_unregister_algs()
--

commit f6b2c31d50397ca9aaeaf051190828cd8f6462ad
Author: Jose Nieto <jnieto.alaber@gmail.com>

arm64: dts: amlogic: use the system clock for A1/S4 crypto

This commit switches the A1 and S4 crypto DT nodes to use the peripheral
clock controller's system clock and removes the fixed clk81 nodes.

> diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/=
dts/amlogic/meson-a1.dtsi
> index 396260b7b3989..1b064c556c68c 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> @@ -691,7 +691,7 @@ crypto: crypto@6000 {
>  				compatible =3D "amlogic,a1-crypto";
>  				reg =3D <0x0 0x6000 0x0 0x48>;
>  				interrupts =3D <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
> -				clocks =3D <&clk81>;
> +				clocks =3D <&clkc_periphs CLKID_SYS>;
>  				power-domains =3D <&pwrc PWRC_DMA_ID>;
>  			};
>  		};

[Severity: Medium]
In the Amlogic crypto hasher driver, does meson_kick_hardware() leak the
rctx->partial_addr DMA mapping when waiting for DMA completion times out?

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

When meson_fill_partial_buffer() maps rctx->partial and sets
rctx->partial_mapped, an early return on timeout in meson_kick_hardware()
skips the dma_unmap_single() call, and the fail path in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr.

[Severity: High]
In the Amlogic cipher driver, does meson_setup_keyiv_descs() program
truncated key lengths and out-of-bounds DMA offsets for ECB mode on GXL
and AXG?

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_setup_keyiv_descs() {
	...
	for (i =3D 0; i < mc->pdata->setup_desc_cnt; i++) {
		struct meson_desc *desc =3D
			&mc->chanlist[rctx->flow].tl[ctx->tloffset];
		int offset =3D i * 16;

		desc->t_src =3D cpu_to_le32(ctx->keyiv.addr + offset);
		desc->t_dst =3D cpu_to_le32(offset);
		desc->t_status =3D cpu_to_le32(DESC_OWN | DESC_MODE_KEY |
					     ctx->keyiv.len /
					     mc->pdata->setup_desc_cnt);

		ctx->tloffset++;
	}
}

In meson_cipher(), ECB mode leaves ctx.keyiv.len at 16 (for AES-128) or
32 (for AES-192 and AES-256) and maps only ctx.keyiv.len bytes.  On GXL
and AXG where setup_desc_cnt is 3, dividing ctx->keyiv.len by
setup_desc_cnt truncates each descriptor length to 5 or 10 bytes instead
of 16, and the later descriptors read from ctx->keyiv.addr + 16 and
ctx->keyiv.addr + 32 past the end of the DMA mapping.

[Severity: High]
In the Amlogic cipher driver, does a multi-batch CBC request reuse the
initial IV instead of the chaining IV on subsequent descriptor batches?

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_kick_hardware() {
	...
	if (blockmode =3D=3D DESC_OPMODE_CBC &&
	    rctx->op_dir =3D=3D MESON_ENCRYPT) {
		dma_sync_sg_for_cpu(mc->dev, sg_head,
				    sg_nents(sg_head), new_iv_dir);
		memcpy(ctx->areq->iv, new_iv, ivsize);
	}

	ctx->tloffset =3D 0;
}

When a CBC request spans more than MAXDESC descriptors,
meson_kick_hardware() saves the next chaining IV into ctx->areq->iv and
resets ctx->tloffset to 0.  On the next loop iteration in meson_cipher(),
meson_setup_keyiv_descs() re-emits the key/IV descriptors from
ctx->keyiv.addr, but nothing copies the updated ctx->areq->iv into
op->keyiv + AES_MAX_KEY_SIZE or syncs ctx->keyiv.addr for the device,
corrupting CBC output after the first batch.

[Severity: High]
In the Amlogic hasher driver, does meson_hasher_do_one_request() emit and
kick a zero-length DMA descriptor at address 0 when a non-final SHA update
leaves a sub-block remainder?

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
	...
		if (!ctx.todo && ctx.nbytes)
			continue;

		if (!ctx.todo && rctx->final_req && rctx->partial_size)
			continue;

		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
			continue;

		if (meson_setup_data_descs(&ctx)) {
			ret =3D meson_kick_hardware(&ctx);
	...
}

When a non-final update() buffers trailing bytes smaller than blocksize
after either meson_setup_state_descs() (on a subsequent update) or an
earlier full block in the same request has already advanced ctx.tloffset
above 0, ctx.todo and ctx.nbytes both become 0 while rctx->final_req is
false.  Also, when a full block is followed by a sub-block tail in a
non-final update(), meson_setup_data_descs() does not set DESC_LAST on the
last full block because ctx->nbytes is still non-zero, and the next
iteration falls through the continue checks to program and kick a
descriptor with t_src =3D 0 and todo =3D 0.

[Severity: High]
In the Amlogic hasher driver, should the request handlers retrieve the
request context with ahash_request_ctx_dma() instead of
ahash_request_ctx()?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_do_one_request() {
	struct ahash_request *req =3D ahash_request_cast(areq);
	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
	struct meson_hasher_tfm_ctx *tctx =3D crypto_ahash_ctx_dma(tfm);
	struct meson_hasher_req_ctx *rctx =3D ahash_request_ctx(req);
	...
	ctx.state_addr =3D dma_map_single(mc->dev, rctx->state,
					sizeof(rctx->state), DMA_BIDIRECTIONAL);
	...
}

meson_hasher_init() reserves DMA alignment padding via
crypto_ahash_set_reqsize_dma(), and struct meson_hasher_req_ctx marks
state and partial as cacheline aligned.  Using ahash_request_ctx() leaves
rctx only 8-byte aligned inside struct ahash_request, so rctx->state
shares cachelines with struct ahash_request and rctx->partial during
non-coherent DMA.

[Severity: Medium]
In the Amlogic crypto core, does meson_unregister_algs() leave dangling
algs[i].mc pointers in the static algorithm template arrays?

drivers/crypto/amlogic/amlogic-gxl-core.c:meson_unregister_algs() {
	int i;

	for (i =3D 0; i < count; i++) {
		if (!algs[i].mc)
			continue;
		switch (algs[i].type) {
		case CRYPTO_ALG_TYPE_SKCIPHER:
			crypto_engine_unregister_skcipher(&algs[i].alg.skcipher);
			break;
		case CRYPTO_ALG_TYPE_AHASH:
			crypto_engine_unregister_ahash(&algs[i].alg.ahash);
			break;
		}
	}
}

On registration failure, meson_register_algs() clears algs[i].mc =3D NULL
for the failing index and calls meson_unregister_algs(mc, algs, count),
relying on unregistered entries having algs[j].mc =3D=3D NULL.  Because
meson_unregister_algs() does not clear algs[i].mc =3D NULL after
unregistering, a later re-probe that fails partway through
meson_register_algs() will unregister entries from the earlier probe a
second time.

[Severity: High]
In the Amlogic cipher driver, can concurrent CBC requests sharing a
crypto_skcipher transform corrupt each other's IV through op->keyiv?

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_cipher() {
	...
	if (algt->blockmode =3D=3D DESC_OPMODE_CBC) {
		memcpy(op->keyiv + AES_MAX_KEY_SIZE, areq->iv, ivsize);
		ctx.keyiv.len =3D AES_MAX_KEY_SIZE + ivsize;
	}

	ctx.keyiv.addr =3D dma_map_single(mc->dev, op->keyiv, ctx.keyiv.len,
					DMA_TO_DEVICE);
	...
}

op->keyiv lives in struct meson_cipher_tfm_ctx, which is shared across all
requests on the same transform, while meson_skencrypt() and
meson_skdecrypt() dispatch requests round-robin across mc->flow_cnt
crypto_engine threads:

kworker (flow 0)                  kworker (flow 1)
meson_cipher(areq0)
  memcpy(op->keyiv + 32,
         areq0->iv, 16)
  dma_map_single(..., op->keyiv, ...)
                                  meson_cipher(areq1)
                                    memcpy(op->keyiv + 32,
                                           areq1->iv, 16)  <-- overwrites IV
                                    dma_map_single(..., op->keyiv, ...)
  meson_kick_hardware()

Two concurrent CBC requests on the same transform overwrite and DMA-map
op->keyiv simultaneously, corrupting the IV read by hardware.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D30

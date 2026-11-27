Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783166;
	b=k6h+jh9db/4qUvYTXXIhxQvEd+YSQr2lht2L2qQhFCxa2IhDLaB8Hs2BmdcXBBRwVbfE
	 oJda5ceHN5Yvu1z9iZBWtdtinFpzh4TBYzRQlNaevOnSl7uLogjPpvbbmnfL+meA+Uqj0
	 jPkIXNvBGIx+wLk9GuCEXd6i7UV6gvoUUACVR4xqIBlXvzQxLhSNBz/c4QKB7/x/NMRId
	 fbKTxe60B/pbXS8rYm07XAm72Ha0/8KkUbbkv2WZmgSBbg0WtJbpx2OEoALfHqb2Iv4Fw
	 Hxg9kcwmXS1g99zNSeWx9i7lVV/ixlJf/rVmiHPGYgrwvLJ31pzA52D7SD7VzhpVKdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zGOzGkQJasjL8g7nW4a5pg7vqqj6rpi22iN+G03CzJ4=;
	b=h5U5v4b5hqIaJcxMckjU+R8+Uoa4SZk9y4HWZb0Jos/V3UZoWWVCqoyCfzucZoLAVbOe
	 ulcw6F23dNwnlzWeJFAq+V5xaqHkY/O29P6V6Y/L+ksIMMWxKZH5f0ugBKfgyDa5NnRd8
	 CPuIFIMH4g3Mg0xbk138kC1ExiW+9N1O7jqc3zdw5ox3v+VlYY/6ZrOA+BZPN/uPaT5Al
	 FY+y/ekVjdDZbCkY3KjT6pg3VScVsnSlH04U52PabsrIN2L5Ntm1SArb6eSdfIVAf/LFj
	 JxpW9B9iKJqLXicUKTIKfIGIpn67hhfXlHt5vLZJjck/EyaoY8TFmL4u4j05BhQ/bbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcJ0J24q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595FF606A31C;
	Fri, 27 Nov 2026 12:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcJ0J24q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3581F0089B;
	Fri, 27 Nov 2026 12:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795783165;
	bh=zGOzGkQJasjL8g7nW4a5pg7vqqj6rpi22iN+G03CzJ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PcJ0J24qhrqBoCt16UCQKJHp/ejS0qaKnOaiwZ4ZBN3jCA97oV9QHZTy7DQgq5lHV
	 v4XtiGyWSYS+GolOXsJVpYQ6BdSd/R35TkcpfAXOuszgqywYVgt2bF8MTeDU6u7WNZ
	 ut4bEkQB2hZl1hc9opSyUtr3kkR3sldp8ax3rDNKvZL+L6P3bKhvTeRei5lVAgNOC6
	 u3/iCjwKsfymmEKYXtmnZyUUELJRQXZSFsUhne31NturjtPzEhAnBNvGzQgQUhuJ9w
	 AB7dITJz+0TXY9NmEz8Rb2RtFxcPoRGdGcKGESYZ+ztssfJgWiOZvsL2iDHLshbRb5
	 cV2zX34USNWAQ==
Message-ID: <sashiko-outbox-237422@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 25/30] arm64: dts: amlogic: axg: add crypto node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-26-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-26-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:39:24 +0000
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
- [High] crypto: amlogic: spurious 0-byte DMA desc in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: double completion in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: unaligned DMA ctx via ahash_request_ctx() in
  hasher
- [High] crypto: amlogic: broken key/IV setup descriptors in
  meson_setup_keyiv_descs()
- [Medium] crypto: amlogic: leaked partial_addr DMA map in
  meson_kick_hardware()
--

commit fb4b4c7512312719a7e889c4b297d41920184b0d
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

arm64: dts: amlogic: axg: add crypto node

This commit adds the amlogic,axg-crypto devicetree node to meson-axg.dtsi
to enable hardware SHA and AES acceleration on Amlogic AXG SoCs.

> diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot=
/dts/amlogic/meson-axg.dtsi
> index 5b8ef98f6d03b..e755a019b384b 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
> @@ -321,6 +321,13 @@ ethmac: ethernet@ff3f0000 {
>  			status =3D "disabled";
>  		};
> =20
> +		crypto: crypto@ff63e000 {
> +			compatible =3D "amlogic,axg-crypto";
> +			reg =3D <0x0 0xff63e000 0x0 0x48>;
> +			interrupts =3D <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
> +			clocks =3D <&clkc CLKID_CLK81>;
> +		};
> +
>  		pcie_phy: phy@ff644000 {
>  			compatible =3D "amlogic,axg-pcie-phy";
>  			reg =3D <0x0 0xff644000 0x0 0x1c>;

[Severity: High]
Can meson_hasher_do_one_request() emit a spurious 0-byte DMA descriptor at
physical address 0 during non-final incremental SHA updates?

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

		if (!ctx.todo && rctx->final_req && rctx->partial_size)
			continue;

		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
			continue;

		if (meson_setup_data_descs(&ctx)) {
			ret =3D meson_kick_hardware(&ctx);
			if (ret)
				goto fail;
		}
	...
}

On a non-final meson_sha_update() whose length exceeds one 64-byte block
but is not block-aligned (for example, 100 bytes), the first iteration
queues a 64-byte descriptor into flow->tl[0] (incrementing ctx.tloffset to
1) without setting DESC_LAST, and the second iteration copies the trailing
36 bytes into rctx->partial with ctx.todo =3D=3D 0, ctx.src_addr =3D=3D 0, =
and
ctx.nbytes =3D=3D 0.  None of the three continue guards match because
ctx.tloffset is non-zero, so meson_setup_data_descs() and
meson_kick_hardware() append and execute a 0-length descriptor with
t_src =3D 0 and DESC_LAST, corrupting the intermediate hardware hash state.
The same happens on any later sub-block update after rctx->begin_req is
false, because meson_setup_state_descs() increments ctx.tloffset before
the trailing bytes are buffered in rctx->partial.

[Severity: Medium]
Does meson_kick_hardware() leak the rctx->partial_addr DMA mapping when
wait_for_completion_timeout() times out or fails?

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
		rctx->partial_size =3D 0;
		rctx->partial_mapped =3D false;
	}
	...
}

When meson_fill_partial_buffer() maps rctx->partial via dma_map_single()
and wait_for_completion_timeout() returns 0 or a negative error in
meson_kick_hardware(), the early return skips unmapping
rctx->partial_addr, and the fail path in meson_hasher_do_one_request()
only unmaps req->src and ctx.state_addr.

[Severity: High]
Does meson_hasher_do_one_request() complete the ahash_request twice when
it returns a negative error code?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_do_one_request() {
	...
	local_bh_disable();
	crypto_finalize_hash_request(engine, req, ret);
	local_bh_enable();

	return ret;
}

crypto_finalize_hash_request() already completes req with ret, and in
crypto_pump_requests() any negative return from do_one_request() jumps to
req_err_1 and calls crypto_request_complete() a second time on the same
request, which can trigger a use-after-free if the completion callback
frees the request.  Like meson_handle_cipher_request() in
amlogic-gxl-cipher.c, meson_hasher_do_one_request() should return 0 after
calling crypto_finalize_hash_request().

[Severity: High]
Should the hasher driver obtain struct meson_hasher_req_ctx via
ahash_request_ctx_dma(req) instead of ahash_request_ctx(req)?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_do_one_request() {
	...
	struct meson_hasher_req_ctx *rctx =3D ahash_request_ctx(req);
	...
}

meson_hasher_init() calls crypto_ahash_set_reqsize_dma() to reserve
DMA-alignment padding, but meson_hasher_do_one_request() and the other
hasher helpers call ahash_request_ctx(req), which is only 8-byte aligned
rather than aligned to ARCH_DMA_MINALIGN.  DMA-mapping rctx->state
(DMA_BIDIRECTIONAL) and rctx->partial (DMA_TO_DEVICE) can then share cache
lines with neighboring struct ahash_request fields and corrupt request
metadata or digest state during non-coherent DMA cache maintenance.

[Severity: High]
Does enabling the AXG crypto node with meson_axg_pdata (where
setup_desc_cnt is 3) break AES-ECB and multi-batch AES-CBC key/IV setup in
meson_setup_keyiv_descs()?

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
	...
}

In ECB mode, meson_cipher() maps only 16 bytes (AES-128) or 32 bytes
(AES-192/256) into ctx.keyiv.addr, but meson_setup_keyiv_descs() always
emits 3 descriptors at offsets 0, 16, and 32 reading past the DMA mapping;
even with commit "crypto: amlogic: fix setup descriptor lengths and CBC IV
copy" dividing ctx->keyiv.len by setup_desc_cnt, integer division yields 5
or 10 bytes per descriptor instead of 16 in ECB mode while still reading
past the mapped buffer.  That earlier commit also drops the CBC IV update
and dma_sync_single_for_device() from meson_setup_keyiv_descs(), so
multi-batch CBC requests spanning more than MAXDESC descriptors reuse the
initial IV on subsequent batches instead of the updated chaining IV in
areq->iv.  In addition, op->keyiv is stored in per-TFM context rather than
per-request context without synchronization across concurrent CBC requests
or zeroization in meson_cipher_exit().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D25

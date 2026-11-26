Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723348;
	b=RSLm8SVneWrWPAXOQFnclOZRq4ui3KAFAg4lUHp1X4s3YLb3on+w56xM+tguwZTBcNuO
	 Zlu1ehZ81olpR3ElGrCJOm8W6TWmzDwD/1yXylWoCRSMDCHuA43vlbkiVP9eLS3Kjgnjm
	 9fpvVvaPSyUpJeSBIuUgT0hPIy5wOJTAlFrOIjXeHGL3lMB/YmwhtTkoJFvFVasorVm0l
	 WSsK+hkvUQIA7qyIIqfSZNZhUsta8h1R9lEL5lpT5wJlvpLviUDtqctXkIOtA8p/8FkEI
	 wvL/t4F3yOLek8+j2LOQstPcx7Y2cyUaE/UwKFF/yAdN5mMlfy0p/4HqloFN5xYYtqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723348;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0LYeH1r+zC/nsfG1kZkExBGsvvvg1qGEnUATOXtVy7w=;
	b=vYpEZ4YvM+ZDD3UjlNL+sqtERU4dcfisEzBi7gHPgSkQIBiL/oxMbFmBwYWdbHM5lpXR
	 5g7o/4ac9Pn9WSOWZlbkp4lCBaeoyqMb7LO+IBHnU8lLVD1+UuasFCkNyo49RRn4XPYYM
	 vlGxYXTJwaA1Tjz9npRslekU2Qs8vaIb4a3LlQ6ui9cSA9M2h/aIyGqDNZ1Lef1lnPtOC
	 ux7lPODlaPxgzbdd/vi7dS/5nJbsYd38tCSutjzq6TJisqG2fhsH+z5z+zRpgMeR7doLX
	 w5EREToc8VNeVPExZkMIa4PHsWXQ1Wq0s6GiO+hyDAP+kiwun2TfpbRsjKF+JxN0OUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9s7D2Tv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7569606A31C;
	Thu, 26 Nov 2026 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9s7D2Tv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E1C1F000C4;
	Thu, 26 Nov 2026 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795723348;
	bh=0LYeH1r+zC/nsfG1kZkExBGsvvvg1qGEnUATOXtVy7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g9s7D2TvADGIFBU5Sjo5OUa4gjVSapy8KCXbKixuJL8/IkzzBPnj1omK0cFxUIgC+
	 +w1ryNIxRXNmF66fQmGVoAt8JmlWABCEOkQSR5WC2DH7si405hFrjo9JuOCaGgkcDZ
	 l1RlyFsv1o9nnUBegwZpt0klp2drCqGuIAmdv5ulk3zPysW9eb9pHyPSYL35l54+I9
	 CatAqHDucCYCaVqjj3RBPUL32UsvZJ3SvxRSuGG9FgTaxp+Ks+MKExQXlMyM0vnVDo
	 iSzbZ3sk5NE8XQ81bPR6u6Z65eGqb+ZNqarSnqkVbLgURVDY0372tpd5EWxoKo35B2
	 ElbSpMDkgNklA==
Message-ID: <sashiko-outbox-236142@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 23/25] arm64: dts: amlogic: s4: add crypto node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-24-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-24-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 20:02:27 +0000
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
- [High] crypto: amlogic: bogus 0-byte DMA descriptor in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: unaligned ahash_request_ctx() used for DMA in
  hasher
- [Medium] arm64: dts: amlogic: s4: fake clk81 fixed-clock instead of
  clkc_periphs CLKID_SYS
- [Medium] crypto: amlogic: double completion on error in
  meson_hasher_do_one_request()
- [Medium] crypto: amlogic: partial_addr DMA mapping leak in
  meson_kick_hardware()
- [Medium] crypto: amlogic: meson_hasher_req_map() maps req->src on
  final() requests
--

commit a7e6ec30c6bf850169c1198e33c98a237aa31006
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

arm64: dts: amlogic: s4: add crypto node

This commit adds a fixed-clock clk81 node and a crypto device node to the
Amlogic S4 SoC devicetree.

> diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/=
dts/amlogic/meson-s4.dtsi
> index 2a6fbd5308362..de173f40e15ed 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
> @@ -71,6 +71,12 @@ xtal: xtal-clk {
>  		#clock-cells =3D <0>;
>  	};
> =20
> +	clk81: clk81 {
> +		compatible =3D "fixed-clock";
> +		#clock-cells =3D <0>;
> +		clock-frequency =3D <166000000>;
> +	};

[Severity: Medium]
Should crypto@440400 use <&clkc_periphs CLKID_SYS> instead of adding a
separate root clk81 fixed-clock node?

meson-s4.dtsi already includes dt-bindings/clock/amlogic,s4-peripherals-clk=
c.h
and defines clkc_periphs: clock-controller@0, whose driver
(drivers/clk/meson/s4-peripherals.c) registers the S4 system bus clock
(s4_sys_clk) at CLKID_SYS.  Adding a root fixed-clock duplicates that
internal SoC clock with a hardcoded 166 MHz rate instead of deriving it
from the hardware mux and divider registers, and the node name clk81 does
not follow the Devicetree generic node naming convention.

> @@ -621,6 +627,13 @@ mux {
> =20
>  			};
> =20
> +			crypto: crypto@440400 {
> +				compatible =3D "amlogic,s4-crypto", "amlogic,a1-crypto";
> +				reg =3D <0x0 0x440400 0x0 0x48>;
> +				interrupts =3D <GIC_SPI 24 IRQ_TYPE_EDGE_RISING>;
> +				clocks =3D <&clk81>;
> +			};

[Severity: High]
In the Amlogic SHA hasher driver enabled by this node (introduced earlier
in this series in commit "crypto: amlogic - Introduce hasher" and commit
"crypto: amlogic: hasher: add one-shot digest path"), can
meson_hasher_do_one_request() emit a bogus 0-byte DMA descriptor with
t_src =3D 0 when an update() request ends with a partial block?

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

If an update() call passes 74 bytes, the first iteration queues a 64-byte
descriptor in flow->tl[0] (setting ctx.tloffset =3D 1 and ctx.nbytes =3D 10=
),
and the second iteration copies the remaining 10 bytes into rctx->partial,
leaving ctx.nbytes =3D 0, ctx.todo =3D 0, and ctx.src_addr =3D 0.  The same=
 state
occurs on an update() smaller than 64 bytes after an earlier update()
already ran, because meson_setup_state_descs() advances ctx.tloffset before
the sub-block data is copied into rctx->partial.

Because ctx.todo is 0, ctx.nbytes is 0, rctx->final_req is false, and
ctx.tloffset is non-zero, none of the three continue checks match.
meson_setup_data_descs() then appends a 0-byte SHA descriptor with
t_src =3D 0 and DESC_LAST set, and meson_kick_hardware() starts DMA from
physical address 0, corrupting the hash state or timing out.

[Severity: Medium]
Does meson_hasher_do_one_request() complete req twice when an error occurs?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_do_one_request() {
    ...
	local_bh_disable();
	crypto_finalize_hash_request(engine, req, ret);
	local_bh_enable();

	return ret;
}

When ret is negative (such as on a DMA mapping failure or a DMA timeout in
meson_kick_hardware()), crypto_finalize_hash_request() calls
crypto_request_complete(&req->base, ret).  Returning that negative ret to
crypto_pump_requests() tells crypto_engine that do_one_request() failed
without finalizing, so crypto_pump_requests() calls
crypto_request_complete() on the same request a second time and can trigger
a use-after-free.  meson_handle_cipher_request() in amlogic-gxl-cipher.c
returns 0 after finalizing the request.

[Severity: Medium]
Does meson_kick_hardware() leak the rctx->partial_addr DMA mapping when
wait_for_completion_timeout() times out?

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
rctx->partial_mapped =3D true, an early return on timeout skips the
dma_unmap_single() block above, and the fail unwind path in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr.

[Severity: High]
Can using ahash_request_ctx(req) instead of ahash_request_ctx_dma(req) in
amlogic-gxl-hasher.c cause DMA cacheline corruption on non-coherent arm64
platforms?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_init() {
    ...
	crypto_ahash_set_reqsize_dma(atfm, crypto_ahash_statesize(atfm));
    ...
}

meson_hasher_init() calls crypto_ahash_set_reqsize_dma(), which reserves
padding for ahash_request_ctx_dma(req), but meson_hasher_do_one_request()
and the other callbacks in amlogic-gxl-hasher.c retrieve rctx with
ahash_request_ctx(req).  ahash_request_ctx(req) is only aligned to
crypto_tfm_ctx_alignment() (8 bytes) at offset 64 of struct ahash_request,
not ARCH_DMA_MINALIGN (128 bytes on arm64), so rctx->state (mapped
DMA_BIDIRECTIONAL) shares a 128-byte cacheline with struct ahash_request.

[Severity: Medium]
Can meson_hasher_req_map() and meson_hasher_req_unmap() access an unused or
dangling req->src scatterlist during crypto_ahash_final()?

drivers/crypto/amlogic/amlogic-gxl-hasher.c:meson_hasher_req_map() {
    ...
	if (!req->nbytes)
		return 0;

	ret =3D dma_map_sg(mc->dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
    ...
}

meson_hasher_do_one_request() sets ctx.nbytes to 0 when
rctx->final_req && !rctx->digest_req, because crypto_ahash_final() only
writes the digest to req->result and ignores req->src and req->nbytes.
However, meson_hasher_req_map() and meson_hasher_req_unmap() test
req->nbytes directly instead of ctx.nbytes, so a final() call where
req->nbytes was left non-zero from an earlier update() (including
crypto_ahash_finup() via ahash_def_finup()) will DMA-map req->src again, or
dereference a NULL or freed req->src in sg_nents(req->src).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D23

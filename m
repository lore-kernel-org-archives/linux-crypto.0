Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723232;
	b=aWiYsnIzQqNWLkbmpwOtS2KVzmkRzz/iLR3pSnww74wb9bJQxiDEwvmj7Z6e9u2c2ZUt
	 V3a17OwM2MXAukd9aTWerJftzYY4ixjvgpkjMDxD7UksCIPVByPn322btkARltxsL45u0
	 eKSsZfzLZY/mM4+37mW3wVHs8//QUyKo77FD30kjIQVHCRKFKzRAVaaUhLGH4IGh+1ykH
	 RA8QPm/fGc5H0Y+gtzwOptDXGLbhbYnGwkXZsM3vBOBWBnhb5YFKoQalmpPXaeiX62Cfa
	 1dWcC4DJJRRa+YJF1a16ZNk6vFMBZ+3ZMxyhe51lCJ+lV6dFiLuYQq+IUcCNcZ1d+4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723232;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PnfzaTqjdQrwOOTGwO9+9tEgTJR9trTIpytwiiAbfqg=;
	b=SogcQ+YxlSV5RB4BwtSEftvCSh97K8xAPDqie67MHnOcnRop1jkZ66JBUb1sMJmWQKaD
	 T4W8su/XQ7FDl3/7zRHtk/TQxxoZcG49HMxs2OANQLsrbF2nTbfpeJuZyHq1x7NgP32mI
	 gj9gra9NnpQT2aGN30EHJCYFzaTLctdK4QNTxEE26EE3Z5gXKmAB55awN5+34z0VbMTt7
	 8rEIGv4EqEn8mMX85kTtMWK8Z/eQeanMnN2F294hQ3Zu02nX7C1N2TpLinxX7B5U7g6d/
	 1d5OwK/Cu7KDAoE7ZoeE2PK8Mso70XuvM0himjeN/1jhDDp/e4LFpT8Ay5vzm6itsOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oh0fI/1B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95667606A31C;
	Thu, 26 Nov 2026 20:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh0fI/1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9791F000C0;
	Thu, 26 Nov 2026 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795723231;
	bh=PnfzaTqjdQrwOOTGwO9+9tEgTJR9trTIpytwiiAbfqg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oh0fI/1ByPbms/sL38/65sSa1MH6HeZorE7XLWx+Q6U2KBbcXN6ljK6TFkodDvO0e
	 K/9ORpI7QS5N+kcflww0/Y+vpKEWEbg/jz5oUl+ca2UpQElJWCguIY74x3KD3fwdjp
	 4PKI/EKm53vMqKWrcE1+MUh9hjPsboaJaZoeT+/Tq5ZWiEtaT6O9QQY7kn2mIjPjuu
	 F3/BsYsBecDZTBJ3HLVU/W8QQ2rXcFL5AgK1BXRnmlGFU5edoya5kyXr2NhkZmFi3z
	 8WxZ9rSB09WDnuU0QnP1TXygJOb2g4azKWwZR2cVvYrNdklo1ppd5JxrEU7f/rOjiD
	 9Xp9H5j+90aQg==
Message-ID: <sashiko-outbox-236138@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 25/25] arm64: dts: amlogic: axg: add crypto node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-26-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-26-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 20:00:30 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 9 potential
issues to consider:
- [High] crypto: amlogic: spurious 0-byte DMA desc in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: double completion in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: unaligned DMA context via ahash_request_ctx()
  in hasher
- [High] crypto: amlogic: out-of-bounds DMA setup descriptors and shared
  op->keyiv
- [Medium] crypto: amlogic: leaked partial_addr DMA mapping on
  meson_kick_hardware() error
- [Medium] crypto: amlogic: meson_register_algs() unregisters failed alg
  on error
- [Medium] crypto: amlogic: debugfs leak and UAF on error_hasher in
  meson_crypto_probe()
- [Medium] crypto: amlogic: channel leak and uninit completion in
  meson_allocate_chanlist()
- [Medium] arm64: dts: amlogic: fake root clk81 fixed-clock node in
  meson-a1 and meson-s4
--

commit abed3b0054164bf8d148380dd2a8f605cf5fb64f
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

arm64: dts: amlogic: axg: add crypto node

This series reworks the Amlogic GXL crypto driver to support hardware SHA
hashing and the G12A, AXG, A1, and S4 SoC families, and adds the
corresponding Devicetree crypto nodes.

> diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/=
dts/amlogic/meson-a1.dtsi
> index 6f6a6145cba12..396260b7b3989 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> @@ -686,6 +686,14 @@ sd_emmc: mmc@10000 {
>  				assigned-clocks =3D <&clkc_periphs CLKID_SD_EMMC>;
>  				assigned-clock-rates =3D <24000000>;
>  			};
> +
> +			crypto: crypto@6000 {
> +				compatible =3D "amlogic,a1-crypto";
> +				reg =3D <0x0 0x6000 0x0 0x48>;
> +				interrupts =3D <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
> +				clocks =3D <&clk81>;
> +				power-domains =3D <&pwrc PWRC_DMA_ID>;
> +			};
>  		};
> =20
>  		usb: usb@fe004400 {
> @@ -767,4 +775,10 @@ xtal: xtal-clk {
>  		clock-output-names =3D "xtal";
>  		#clock-cells =3D <0>;
>  	};
> +
> +	clk81: clk81 {
> +		compatible =3D "fixed-clock";
> +		#clock-cells =3D <0>;
> +		clock-frequency =3D <64000000>;
> +	};
>  };

[Severity: Medium]
Should the crypto nodes in meson-a1.dtsi and meson-s4.dtsi use the system
clock from the peripheral clock controller (<&clkc_periphs CLKID_SYS>)
instead of adding a fake root clk81 fixed-clock node?

Both A1 and S4 already expose their system bus clock through clkc_periphs,
and the root node name clk81 is also not a generic Devicetree node name.

[ ... ]

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto=
/amlogic/amlogic-gxl-cipher.c
> index d78815b0547d8..c11ccbaf920dd 100644
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
> +	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx_dma(tfm);
> +	struct meson_dev *mc =3D op->mc;
> +	unsigned int ivsize =3D crypto_skcipher_ivsize(tfm);
> +	unsigned int blockmode =3D algt->blockmode;
> +	int i;
> +
> +	if (ctx->tloffset)
> +		return;
> +
> +	if (blockmode =3D=3D DESC_OPMODE_CBC) {
> +		memcpy(op->keyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
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
Does meson_setup_keyiv_descs() program out-of-bounds DMA transfers on GXL
and AXG, where setup_desc_cnt is 3?

Previously, each key/IV setup descriptor transferred 16 bytes and the loop
stopped once keyivlen bytes were consumed.  Here, all three descriptors at
offsets 0, 16, and 32 are given the full ctx->keyiv.len (16, 32, or 48
bytes), so descriptors 1 and 2 instruct the DMA engine to read past the end
of the dma_map_single() mapping and past op->keyiv.  The same issue exists
in meson_setup_state_descs() in amlogic-gxl-hasher.c on AXG, where each of
the 3 descriptors specifies MESON_SHA_BUFFER_SIZE (48) at offsets 0, 16,
and 32 from ctx->state_addr.

Also, in CBC mode, writing the per-request IV into the per-TFM op->keyiv
buffer while ctx->keyiv.addr is mapped to the device without calling
dma_sync_single_for_cpu() first violates the DMA API, and concurrent
requests sharing a TFM across multiple flows can overwrite each other's IV
in op->keyiv.  In addition, meson_cipher_exit() no longer wipes the key
material in op->keyiv on exit.

[ ... ]

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 48dbdf4520348..90c817e412ad4 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c

[ ... ]

>  static int meson_allocate_chanlist(struct meson_dev *mc)
>  {
> +	struct platform_device *pdev =3D to_platform_device(mc->dev);
>  	int i, err;
> =20
> -	mc->chanlist =3D devm_kzalloc_objs(mc->dev, struct meson_flow, MAXFLOW);
> +	mc->flow_cnt =3D platform_irq_count(pdev);
> +	if (mc->flow_cnt <=3D 0) {
> +		dev_err(mc->dev, "No IRQs defined\n");
> +		return -ENODEV;
> +	}
> +
> +	mc->chanlist =3D devm_kzalloc_objs(mc->dev, struct meson_flow, mc->flow=
_cnt);
>  	if (!mc->chanlist)
>  		return -ENOMEM;
> =20
> -	for (i =3D 0; i < MAXFLOW; i++) {
> +	for (i =3D 0; i < mc->flow_cnt; i++) {
> +		mc->chanlist[i].irq =3D platform_get_irq(pdev, i);
> +		if (mc->chanlist[i].irq < 0)
> +			return mc->chanlist[i].irq;
> +
> +		err =3D devm_request_irq(mc->dev, mc->chanlist[i].irq,
> +				       meson_irq_handler, 0, "aml-crypto", mc);
> +		if (err < 0) {
> +			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
> +			return err;
> +		}
> +
>  		init_completion(&mc->chanlist[i].complete);

[Severity: Medium]
If platform_get_irq() or devm_request_irq() fails when i > 0, does this
return leak the crypto_engine instances and coherent DMA buffers allocated
for earlier channels 0 .. i - 1?

In addition, devm_request_irq() registers meson_irq_handler() before
init_completion(&mc->chanlist[i].complete) is called, so an early interrupt
could call complete() on an uninitialized completion.

[ ... ]

> -static int meson_register_algs(struct meson_dev *mc)
> +int meson_register_algs(struct meson_dev *mc, struct meson_alg_template =
*algs,
> +			unsigned int count)
>  {
>  	int err, i;
> =20
> -	for (i =3D 0; i < ARRAY_SIZE(mc_algs); i++) {
> -		mc_algs[i].mc =3D mc;
> -		switch (mc_algs[i].type) {
> +	for (i =3D 0; i < count; i++) {
> +		algs[i].mc =3D mc;
> +		switch (algs[i].type) {
>  		case CRYPTO_ALG_TYPE_SKCIPHER:
> -			err =3D crypto_engine_register_skcipher(&mc_algs[i].alg.skcipher);
> +			err =3D crypto_engine_register_skcipher(&algs[i].alg.skcipher);
>  			if (err) {
>  				dev_err(mc->dev, "Fail to register %s\n",
> -					mc_algs[i].alg.skcipher.base.base.cra_name);
> -				mc_algs[i].mc =3D NULL;
> +					algs[i].alg.skcipher.base.base.cra_name);
> +				meson_unregister_algs(mc, algs, count);
> +				return err;
> +			}
> +			break;
> +		case CRYPTO_ALG_TYPE_AHASH:
> +			err =3D crypto_engine_register_ahash(&algs[i].alg.ahash);
> +			if (err) {
> +				dev_err(mc->dev, "Fail to register %s\n",
> +					algs[i].alg.ahash.base.halg.base.cra_name);
> +				meson_unregister_algs(mc, algs, count);
>  				return err;
>  			}
>  			break;
>  		}
>  	}
> =20
>  	return 0;
>  }
> =20
> -static void meson_unregister_algs(struct meson_dev *mc)
> +void meson_unregister_algs(struct meson_dev *mc, struct meson_alg_templa=
te *algs,
> +			   unsigned int count)
>  {
>  	int i;
> =20
> -	for (i =3D 0; i < ARRAY_SIZE(mc_algs); i++) {
> -		if (!mc_algs[i].mc)
> +	for (i =3D 0; i < count; i++) {
> +		if (!algs[i].mc)
>  			continue;
> -		switch (mc_algs[i].type) {
> +		switch (algs[i].type) {
>  		case CRYPTO_ALG_TYPE_SKCIPHER:
> -			crypto_engine_unregister_skcipher(&mc_algs[i].alg.skcipher);
> +			crypto_engine_unregister_skcipher(&algs[i].alg.skcipher);
> +			break;
> +		case CRYPTO_ALG_TYPE_AHASH:
> +			crypto_engine_unregister_ahash(&algs[i].alg.ahash);
>  			break;
>  		}
>  	}
>  }

[Severity: Medium]
When crypto_engine_register_skcipher() or crypto_engine_register_ahash()
fails, algs[i].mc has already been set to mc and is not cleared before
calling meson_unregister_algs().  Won't meson_unregister_algs() then try to
unregister the algorithm that just failed registration?

meson_unregister_algs() also never clears algs[i].mc =3D NULL after
unregistering, leaving stale mc pointers in the static algs arrays across
probe failure or device removal.

[ ... ]

> @@ -243,50 +227,35 @@ static int meson_crypto_probe(struct platform_devic=
e *pdev)
>  	if (IS_ERR(mc->base))
>  		return PTR_ERR(mc->base);
> =20
> -	mc->busclk =3D devm_clk_get_enabled(&pdev->dev, "blkmv");
> -	if (IS_ERR(mc->busclk)) {
> -		err =3D PTR_ERR(mc->busclk);
> -		dev_err(&pdev->dev, "Cannot get/enable core clock err=3D%d\n", err);
> -		return err;
> -	}
> -
>  	err =3D meson_allocate_chanlist(mc);
>  	if (err)
>  		return err;
> =20
> -	for (i =3D 0; i < MAXFLOW; i++) {
> -		mc->irqs[i] =3D platform_get_irq(pdev, i);
> -		if (mc->irqs[i] < 0) {
> -			err =3D mc->irqs[i];
> -			goto error_chanlist;
> -		}
> -
> -		err =3D devm_request_irq(&pdev->dev, mc->irqs[i], meson_irq_handler, 0,
> -				       "gxl-crypto", mc);
> -		if (err < 0)
> -			goto error_chanlist;
> -	}
> -
> -	err =3D meson_register_algs(mc);
> +	err =3D meson_cipher_register(mc);
>  	if (err)
> -		goto error_alg;
> +		goto error_flow;
> =20
>  	if (IS_ENABLED(CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG)) {
>  		struct dentry *dbgfs_dir;
> =20
>  		dbgfs_dir =3D debugfs_create_dir("gxl-crypto", NULL);
>  		debugfs_create_file("stats", 0444, dbgfs_dir, mc, &meson_debugfs_fops);
> -
>  #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
>  		mc->dbgfs_dir =3D dbgfs_dir;
>  #endif
>  	}
> =20
> +	err =3D meson_hasher_register(mc);
> +	if (err)
> +		goto error_hasher;
> +
>  	return 0;
> -error_alg:
> -	meson_unregister_algs(mc);
> -error_chanlist:
> -	meson_free_chanlist(mc, MAXFLOW - 1);
> +
> +error_hasher:
> +	meson_cipher_unregister(mc);
> +
> +error_flow:
> +	meson_free_chanlist(mc, mc->flow_cnt - 1);
>  	return err;
>  }

[Severity: Medium]
If meson_hasher_register() fails when CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
is enabled, does the error_hasher path leak mc->dbgfs_dir?  Reading the
leftover debugfs stats file afterwards would then dereference the freed
struct meson_dev *mc.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-hasher.c b/drivers/crypto=
/amlogic/amlogic-gxl-hasher.c
> new file mode 100644
> index 0000000000000..978cdcd8a4f91
> --- /dev/null
> +++ b/drivers/crypto/amlogic/amlogic-gxl-hasher.c

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
If wait_for_completion_timeout() times out while rctx->partial_mapped is
true, does this leak the rctx->partial_addr DMA mapping?

meson_kick_hardware() returns before reaching the dma_unmap_single() block,
and the fail label in meson_hasher_do_one_request() only unmaps req->src
and ctx.state_addr.

[ ... ]

> +static int meson_hasher_do_one_request(struct crypto_engine *engine, voi=
d *areq)
> +{
> +	struct ahash_request *req =3D ahash_request_cast(areq);
> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> +	struct meson_hasher_tfm_ctx *tctx =3D crypto_ahash_ctx_dma(tfm);
> +	struct meson_hasher_req_ctx *rctx =3D ahash_request_ctx(req);

[Severity: High]
Should meson_hasher_do_one_request() and the other hasher helpers retrieve
rctx with ahash_request_ctx_dma(req) instead of ahash_request_ctx(req)?

meson_hasher_init() reserves DMA alignment padding via
crypto_ahash_set_reqsize_dma(), but ahash_request_ctx(req) returns the
unaligned req->__ctx pointer.  As a result, the DMA-mapped buffers
rctx->state (DMA_BIDIRECTIONAL) and rctx->partial (DMA_TO_DEVICE) are not
aligned to ARCH_DMA_MINALIGN and can share cachelines with struct
ahash_request fields, risking cacheline corruption during non-coherent DMA
maintenance.

> +	struct meson_dev *mc =3D tctx->mc;
> +	struct hasher_ctx ctx =3D {
> +		.tloffset =3D 0,
> +		.src_offset =3D 0,
> +		.nbytes =3D (rctx->final_req && !rctx->digest_req) ? 0 : req->nbytes,
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
> +		if (!ctx.todo && rctx->final_req && rctx->partial_size)
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
Can non-final update requests emit a spurious 0-byte DMA descriptor with
t_src =3D 0 when trailing bytes are buffered in rctx->partial?

For example, on a non-final meson_sha_update() of 100 bytes (64 + 36), the
first iteration queues the 64-byte block into descriptor 0 (incrementing
ctx.tloffset to 1) without DESC_LAST because ctx.nbytes is 36.  On the
second iteration, the remaining 36 bytes are copied into rctx->partial and
ctx.nbytes becomes 0 while ctx.todo and ctx.src_addr stay 0.  Because
ctx.tloffset is non-zero, none of the three continue conditions match, so
meson_setup_data_descs() appends a 0-length descriptor reading from address
0 and kicks the hardware, corrupting the hash state.

The same happens on a subsequent update with len < blocksize after
rctx->begin_req has been cleared, because meson_setup_state_descs()
increments ctx.tloffset before the partial-buffer check.

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
Does returning a negative ret after calling crypto_finalize_hash_request()
complete the request twice?

crypto_finalize_hash_request() already completes req with ret.  When
do_one_request() returns a negative error to crypto_pump_requests() and
engine->retry_support is false, crypto_pump_requests() calls
crypto_request_complete(async_req, ret) a second time, which can trigger a
double completion or use-after-free if the completion callback freed the
request.  Should this return 0 like meson_handle_cipher_request() does?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D25

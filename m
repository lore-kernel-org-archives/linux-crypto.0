Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722622;
	b=1HVf5k81c6f8pioLQVB4m/kyVyvvXB+C1bVcMkzMAAxlTatZHBZtglfOTrqacjYCMFHa
	 DQQJOixUHDQw/rQhPvffZqh/vXozHKg/GA9WbK+OpDm5cYwrZzzCu0+xOoaGqQ0Ovdtc5
	 y1X/3a7xfIin+/HbLbwpcXAgmXvHHBGsXQFFirVV2kFWTKXa7InvvQPx0vNFi6xHMXcSX
	 /OeXepSL8+AJRyoFSMwCa/0SAyLd18SVMLmFKlLoAFspkODMFt53lJIa5sXo+vzEsI8jg
	 rCN4OIGq6SN5ZrlnhxhCfEvgx+zRXY6cX/hSdS3B+PXIybTyYclXIi5GI0dSRB/W+bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722622;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0nGU2S1TqSU9SkdknDv1gl7nTTx1aS2r7KELR2cPYwA=;
	b=nNLjzHFXwE8xsDZvmvlvcKMWItyrYt5ee9E4yi7IEJcb/BZw+oCIQoftSXnKjTLr5kaL
	 WoCYnWn+k2pcjxyC0ZiIDcdAQ7WhwuaIIRHNQBBkEaoO5ns5nRNdmKrsla1sZHnlVXaA1
	 alaq/gJ6HAHVb1Oj5kLs623ORDai7yIQrgx0+QKQpHdqiA0ICEo8EcfHXsVUBwG2zkE4M
	 Ew7zpFx8okktD8PX9k40Wx8CtKY1nUiRtUXsEfvQyNafDwed4QPdLorOU4Sy3BNYrB2qF
	 Jc5ssht3ZNzoN74Oljt8hel+97FBSvCXPXVwr1XjqfLdaER2WIgd2J1gd58UVTEasnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRKIoktf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BE3606A31C;
	Thu, 26 Nov 2026 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KRKIoktf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EB31F000C0;
	Thu, 26 Nov 2026 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722622;
	bh=0nGU2S1TqSU9SkdknDv1gl7nTTx1aS2r7KELR2cPYwA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KRKIoktf1f7o9I7i25GYuHCN/guiMCEp9x8+P1w2INzRRpiWrFYIodOc7GH96TMgy
	 FXZi8+HHzCU9F2uu5rG2hKAuq0ypmyXpb/gWv52gCxNcyfO61qjYkETaB1p7Vtk3os
	 lNFDQg3DNVKRa3t7XzK0rjFTwP4DgG+Jt3UG8K0RZ+42zXMTiwMyWUMgoUo9u21/pT
	 3jpksvTaAuW4BUE0BRehN5PcCos3DOvk3kmVW1YgETFA79BPl7on+fDpkR02pn7Sg4
	 6T8oMTdphfKbfv9VWWfsPuYEaeX74c91chKSK8epxbGjk8hESAebSxBVRSpOlPEPVZ
	 kFV8DXhL82ZWQ==
Message-ID: <sashiko-outbox-236125@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 19/25] crypto: amlogic: hasher: add one-shot digest
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>
In-Reply-To: <20261126193241.1471372-20-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-20-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:50:21 +0000
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
- [Medium] crypto: amlogic: unmapped partial_addr DMA buffer on
  meson_kick_hardware() error
- [Medium] crypto: amlogic: unremoved debugfs dir on hasher init failure
  in meson_crypto_probe()
--

commit 8c0248c4b7c9ffb36b968750cdcd5dfcb7a2b1f1
Author: Jose Nieto <jnieto.alaber@gmail.com>

crypto: amlogic: hasher: add one-shot digest path

This commit implements the ahash ->digest callback for one-shot SHA
requests and unregisters the hasher algorithms on device removal.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 3a6bac10bb04b..e79175368d8ce 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
> @@ -269,6 +269,7 @@ static void meson_crypto_remove(struct platform_devic=
e *pdev)
>  	debugfs_remove_recursive(mc->dbgfs_dir);
>  #endif
> =20
> +	meson_hasher_unregister(mc);
>  	meson_cipher_unregister(mc);
> =20
>  	meson_free_chanlist(mc, mc->flow_cnt - 1);

[Severity: Medium]
Does meson_crypto_probe() leak mc->dbgfs_dir when meson_hasher_register()
fails?

drivers/crypto/amlogic/amlogic-gxl-core.c:meson_crypto_probe() {
    ...
	if (IS_ENABLED(CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG)) {
		struct dentry *dbgfs_dir;

		dbgfs_dir =3D debugfs_create_dir("gxl-crypto", NULL);
		debugfs_create_file("stats", 0444, dbgfs_dir, mc, &meson_debugfs_fops);
#ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
		mc->dbgfs_dir =3D dbgfs_dir;
#endif
	}

	err =3D meson_hasher_register(mc);
	if (err)
		goto error_hasher;

	return 0;

error_hasher:
	meson_cipher_unregister(mc);
    ...
}

Unlike meson_crypto_remove(), the error_hasher unwind path does not call
debugfs_remove_recursive(mc->dbgfs_dir).  When probe fails, devres frees
mc and leaves the debugfs stats file with a dangling private pointer,
causing a use-after-free in meson_debugfs_show() if the file is read.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-hasher.c b/drivers/crypto=
/amlogic/amlogic-gxl-hasher.c
> index c83739ec34566..978cdcd8a4f91 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-hasher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
[ ... ]
> @@ -310,6 +329,9 @@ static int meson_hasher_do_one_request(struct crypto_=
engine *engine, void *areq)
>  		if (!ctx.todo && ctx.nbytes)
>  			continue;
> =20
> +		if (!ctx.todo && rctx->final_req && rctx->partial_size)
> +			continue;
> +
>  		if (!ctx.todo && !rctx->final_req && !ctx.tloffset)
>  			continue;

[Severity: Medium]
Does meson_hasher_do_one_request() leak the rctx->partial_addr DMA
mapping when meson_kick_hardware() fails?

meson_fill_partial_buffer() maps rctx->partial with dma_map_single() and
sets rctx->partial_mapped =3D true.  If wait_for_completion_timeout() times
out in meson_kick_hardware(), it returns before unmapping
rctx->partial_addr, and the fail path in meson_hasher_do_one_request()
only unmaps req->src and ctx.state_addr:

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

When a DMA timeout occurs while flushing a partial block,
rctx->partial_addr remains mapped.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D19

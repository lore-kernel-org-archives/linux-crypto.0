Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782127;
	b=XIPEJmW7RTV/lu6YYYZFuGu6ho+v1X0bO/wNCBHkSTTbplLR7LPCFBAiIJWDuBI57ixd
	 mA92Vfl8I2qzSnodaluw3k6pI0mBGT00jixGEljboL7jgwGxGLV5f/HwWdrMRDgqPFMsz
	 xFwDV728jeW/arZQGNZUIPkXaLtrrjUsx1uBZz9cFXjAFwY1h1MKy1oG+3u47WrTNfcxw
	 L0InQLM/lNqutyeJIqLLIEh02u9orNr+q9y6v9ZX2TKz36BYXCwZRoyvW8ewGOrXtRlLn
	 PvNr0FFpcGcm8FbHY/46JxY+wI/AOnpKPyDXPzWD9NmVEucjMgAvwv4a29r0reBu8Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782127;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YBtbGhdcHaTPh4Cp45Uwxj8GEBk2yppZmWyURV6PBPs=;
	b=V1dIJ8wD7IelzypJ9H2/pa86SpPkTphUuo1U5hDNpR4VweLTt8vFSwezBAai4GLgUnPs
	 DPO8pZiGWIq24w8P+RSMtkPASo7ypGsAB4w3pCSwBh4eeTEYG69Qo+8jKr12llljYrip5
	 h7U3I+weJXpfWweO8erjYkeo2+SRhX9LM7WInHQ64Cr+2/2Lyy9+7LQIcx40Fs3aHE25g
	 oU7hXTmHrdStlvevRCfYBJ5xwzVkSbEB6Ho0q6L/O0VaFLG/qlLvw1dy3SrP/B5o+w8OS
	 iGI1UEYOO+Kp6DhYs3iHSf2f62snfs0UVH+ZGmMvBmhO9Zd3y28s+o2cXtyMcFfCUKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFkFGgLQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1AF606A31C;
	Fri, 27 Nov 2026 12:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFkFGgLQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C411F0089B;
	Fri, 27 Nov 2026 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782127;
	bh=YBtbGhdcHaTPh4Cp45Uwxj8GEBk2yppZmWyURV6PBPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QFkFGgLQCvqWdQq1G4gCpTmmTMKGGsU2J3xj1o5GhLKFe5tuqqJ8ZzJOnK+ULjbqh
	 JXVkIbmIIDXCQGaxvZavLMFMY/ZsSZkJta6yW1eQitZK+QUQdcdALAvsMyJ1si/1Cm
	 8xkiarb0bbg6Fx4pTvFcE5iSqvanuBMju5YmB/8Pz5q9Eo4HzpkXaraCh2PCtLyFZD
	 2gO56T5tEvdLB2SUPiqljfI9y2Tb1DoWBVuKGBBoliEcJOpnElGfFNMn7kiFhVkh0x
	 uydTxNeEZQ/dq8lMNQapA80W7EXeLFqznRVCjT0qS77NomsfpYjfcOo7S9aWVuBk0I
	 Yq7/7OvkSrIUA==
Message-ID: <sashiko-outbox-237361@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 19/30] crypto: amlogic: hasher: add one-shot digest
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>
In-Reply-To: <20261127120103.1532882-20-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-20-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:22:06 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: amlogic: unmapped partial_addr DMA buffer on
  meson_kick_hardware() error
--

commit 3c19d4fb37e9f39951d2fec607a504c2dffee73a
Author: Jose Nieto <jnieto.alaber@gmail.com>

crypto: amlogic: hasher: add one-shot digest path

This commit adds the ahash ->digest callback for one-shot SHA requests,
unregisters the hasher on device removal, and lowers the unsupported
platform message to dev_dbg.

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
mapping when meson_kick_hardware() fails or times out while flushing a
partial block?

When meson_fill_partial_buffer() maps rctx->partial, it sets
rctx->partial_mapped =3D true.  If wait_for_completion_timeout() fails in
meson_kick_hardware(), it returns before reaching the dma_unmap_single()
block for rctx->partial_addr, and the fail cleanup path in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr:

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

Unmapping rctx->partial_addr when rctx->partial_mapped is set in the
error path (or before returning in meson_kick_hardware()) would avoid
leaking the DMA mapping.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D19

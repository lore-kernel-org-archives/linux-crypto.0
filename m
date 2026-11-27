Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782966;
	b=rfg+5PmGux/4skV6ezFyA2bx421w8n6qFT8T1xPzLEdu23oS8lRjeCbYX1MajAHn+TTu
	 hAgojuWyPHV7e5fBN1wZw3aAYLnHVseyuw5nqs0i+V/UIWqV/iz0xMc/th9PwuBi9BVsM
	 7OVJVVip7Gz8ZwSQg5ctfIqj4wDLcU1ylnpMPLlMoHBpgFW5PcB+dy/gjLWR24w85VP1R
	 ytsche5ioMzCHho8DixwrUsU49WnyLPjEMtIH+58TALbXh1frfGhzkjH8o/I8/qBrU5QV
	 0/Xh4O4Lc0dR2yriFT9YuGb5l1Drn1EU/RZ0XYsjQbmUsneQ7+X+9pPzeEgtAyHwaRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782966;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=o6H1OZKpZa8qg+PZkI0yZ4zW1o+8hbyP4Qf6dSOjaYw=;
	b=tLLpYValjS8HeE3lV+LrXPhKIswXw0rro/wi0cm+1ZjtB7zqn/+khjhx3JvL283q4pZ7
	 TD5YJwMti8QtXO0saQl6l/lmr7zhCVOeShrTtcqx0WCrpvu6MmyBBFtTLGoJGAVntMx4l
	 d5on5BM32BCPOixJIIh65vmjwaaldi4i3AxTH70h8CkjQT2aAYcPFp/xvICaKiWrFjZeE
	 N1YB3/RWYKKJvFIc6JZjPqWskOFxTUST97PdNeUUsbs9pdXOgWopBI9MJ4fIE5e1VJxZi
	 bp1BfLn5JbrlT8jZfB7yRXCLVkYhfZfthlASj/Mo+bWiJX4HbEOhgES9Qys2RWnJjvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afgIcSvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCA606A31C;
	Fri, 27 Nov 2026 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afgIcSvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDCC1F000C1;
	Fri, 27 Nov 2026 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782966;
	bh=o6H1OZKpZa8qg+PZkI0yZ4zW1o+8hbyP4Qf6dSOjaYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=afgIcSvImlxbWDq+q36mTUP0lLDYWHi1APa9BRajaC234AL8T61OrVNI3ssXxf3yu
	 dVr14fZup+aNdgFzOPgHx1Ci8Zp96tvIVFfSfTj72v3G+h7HgluHDVzyI/nsK8sHkE
	 wyp7j/L7cF5SdiPDTgdAYTHfwVTxZ730rZ5g6qe2YWYg54P48oG0Q/hTjHqVcBzVcF
	 rdqGzjpuEv+0LKfvmZkAqUyV6zbpTvy533v1Cw7TDHDO1PoWfDE6hV9F5wI+xI88Q0
	 PQW0BgDEEE/s8+bunPxeJWN5SzYym8LfWNx0fbAjjsnD4NHxtAxptXT/+1B0SComjw
	 uTQdh2r26eUwg==
Message-ID: <sashiko-outbox-237415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 24/30] arm64: dts: amlogic: g12: add crypto node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-25-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-25-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:36:05 +0000
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
- [High] crypto: amlogic: double completion on error in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: zero-byte SHA DMA descriptor in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: unaligned DMA request context in
  meson_hasher_do_one_request()
- [Medium] crypto: amlogic: partial_addr DMA mapping leak in
  meson_kick_hardware()
- [Medium] crypto: amlogic: unexpected req->src DMA map on final in
  meson_hasher_req_map()
--

commit de440de738747f23777b7e1340e71b73e7c85fdd
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

arm64: dts: amlogic: g12: add crypto node

This series adds hardware SHA1/SHA224/SHA256 hashing support to the Amlogic
crypto driver and enables the crypto node on Amlogic G12-series SoCs.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-hasher.c b/drivers/crypto=
/amlogic/amlogic-gxl-hasher.c
> new file mode 100644
> index 0000000000000..978cdcd8a4f91
> --- /dev/null
> +++ b/drivers/crypto/amlogic/amlogic-gxl-hasher.c
> @@ -0,0 +1,510 @@

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

[Severity: Medium]
Can meson_hasher_req_map() and meson_hasher_req_unmap() dereference a NULL =
or
dangling req->src during crypto_ahash_final()?

In meson_hasher_do_one_request(), ctx.nbytes is forced to 0 when
rctx->final_req && !rctx->digest_req, because final() does not consume input
from req->src.  However, meson_hasher_req_map() and meson_hasher_req_unmap()
check req->nbytes directly.  If a caller leaves req->nbytes non-zero from an
earlier update() (as ahash_def_finup() does) and releases or clears req->src
before calling crypto_ahash_final(), sg_nents(req->src) and dma_map_sg() wi=
ll
access an invalid scatterlist.  Checking ctx.nbytes instead of req->nbytes
avoids mapping req->src on final requests.

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
> +
> +	ctx->tloffset =3D 0;
> +
> +	return 0;
> +}

[Severity: Medium]
Does meson_kick_hardware() leak the rctx->partial_addr DMA mapping when
wait_for_completion_timeout() times out?

When rctx->partial_mapped is true and the wait times out, returning -EINVAL
skips the dma_unmap_single() call below, and the fail path in
meson_hasher_do_one_request() only unmaps req->src and ctx.state_addr.

[ ... ]

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
Can this loop submit a 0-byte SHA DMA descriptor with t_src =3D 0 during
incremental crypto_ahash_update() calls, corrupting the hardware SHA state?

There are two ways a non-final update() reaches meson_setup_data_descs() wi=
th
ctx.todo =3D=3D 0, ctx.src_addr =3D=3D 0, ctx.nbytes =3D=3D 0, and ctx.tlof=
fset > 0:

1. If an update() request has full blocks followed by a trailing partial
block (for example 70 bytes in one SG entry), the first iteration emits a
64-byte data descriptor without DESC_LAST (because ctx.nbytes is 6) and sets
ctx.tloffset =3D 1.  The second iteration copies the trailing 6 bytes into
rctx->partial and sets ctx.nbytes =3D 0 while ctx.todo stays 0.

2. On a subsequent update() after an earlier hardware kick (so
rctx->begin_req is false), meson_setup_state_descs() runs at the top of the
loop and increments ctx.tloffset before checking whether the input will only
be buffered into rctx->partial without filling a full block.

In both cases, none of the three continue conditions match because
ctx.tloffset is non-zero, so meson_setup_data_descs() appends a 0-length da=
ta
descriptor at address 0 with DESC_LAST and kicks the DMA engine.

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
the request twice on error?

crypto_finalize_hash_request() already completes req via
crypto_request_complete().  Because the engine is initialized with
crypto_engine_alloc_init(mc->dev, true) (so engine->retry_support is false),
returning a negative error code from do_one_request() causes
crypto_pump_requests() to call crypto_request_complete() a second time on t=
he
same request, leading to a double completion and use-after-free in callers
that free the request in their completion callback.
meson_hasher_do_one_request() should return 0 after finalizing the request,
matching meson_handle_cipher_request().

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
> +
> +	memset(tctx, 0, sizeof(struct meson_hasher_tfm_ctx));
> +
> +	tctx->mc =3D algt->mc;
> +
> +	return 0;
> +}

[ ... ]

> diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogi=
c/amlogic-gxl.h
> index d68094ffb70af..9c3df0d162b9b 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl.h
> +++ b/drivers/crypto/amlogic/amlogic-gxl.h

[ ... ]

> +struct meson_hasher_req_ctx {
> +	u8 state[SHA256_DIGEST_SIZE + 16] ____cacheline_aligned;
> +	u8 partial[SHA256_BLOCK_SIZE] ____cacheline_aligned;
> +	unsigned int partial_size ____cacheline_aligned;
> +	dma_addr_t partial_addr;
> +	bool partial_mapped;
> +
> +	bool begin_req;
> +	bool final_req;
> +	bool digest_req;
> +	int flow;
> +};

[Severity: High]
Can DMA cache maintenance on rctx->state and rctx->partial corrupt adjacent
fields on non-coherent arm64 platforms?

meson_hasher_init() reserves DMA alignment padding via
crypto_ahash_set_reqsize_dma(), but the hasher callbacks retrieve the reque=
st
context with ahash_request_ctx(req) instead of ahash_request_ctx_dma(req),
leaving rctx only 8-byte aligned and sharing a cacheline with struct
ahash_request.

In addition, on arm64 ____cacheline_aligned is 64 bytes while
ARCH_DMA_MINALIGN is 128 bytes.  As a result, state (mapped
DMA_BIDIRECTIONAL) and partial (written by the CPU while state is mapped, a=
nd
mapped DMA_TO_DEVICE) share the same 128-byte DMA cacheline granule.  Using
ahash_request_ctx_dma() and aligning DMA buffers in struct
meson_hasher_req_ctx with __aligned(ARCH_DMA_MINALIGN) avoids cacheline
sharing during DMA unmap invalidation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D24

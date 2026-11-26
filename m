Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722997;
	b=2hcsWT5TyFf68MQMzjEaeTbOcHglPG5gOo3w1S78tmDXhH/32jhBRG+aDZsR/TdVMCMy
	 /ImxeEUWVyLsWxGQFNwhoMAW1sCvBQUdSGXfINzc0b/oueC2TKVN7epHXdetXgZwiiqY0
	 s3ULVayiwjjR/kSGE2rNT9xLCnhdVKyKZ3Oc+nCH6HiX7IePeXdy8YaOTJL56Vp+jwQCs
	 8/dEAqSRz29oKKS6riVlpsCtbNdH9iq9ydukf/G2kWr5/4PVRUtBCjV16o97CyhyYA1xz
	 dbpDGR8OHb5E+qaHqmsueRY/WDNVN2XqsSi09fkAdqO2vpMpusVgFgpVS8vTXTIwolg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722997;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4E+cZDLd4RaIePBoRaVSM6a6mIbVj3DXOB0tO8phPHY=;
	b=BfvzTZT1P3ghrvh5HxCWEhX7Yqp0zRKAEm9yk0noJd84v9CRnxX5IBfpDbmodRBsqDap
	 Wonl67xjp6+9agyYQLrSTJAt6fveIpadu0uwZP9fXPdFsb4aqRtiAtHG2sgAAuxVSVIGc
	 0WoNaP3UEACOj7r6VqhVStBpQaEZP1b4I3xvJogaNRbytEI9wTNL1XxsEDFTzL4xXwHLJ
	 8LyeZuzVCO6Rhy43HpPifzPmo75aTMzjHDRYlegzub+mNNPQC8aTGguLyuUslIEp4cpbj
	 Hs1EYIBKzeJEWkgVYlRpLAKi7RdtgeiUlxI5dZCr7iMmxciMy+RghK9weJtgV/JVjQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gT4M2sP3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AAB606A31E;
	Thu, 26 Nov 2026 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gT4M2sP3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBE61F000CA;
	Thu, 26 Nov 2026 19:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722996;
	bh=4E+cZDLd4RaIePBoRaVSM6a6mIbVj3DXOB0tO8phPHY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gT4M2sP3cqg4XHdPH2fHuiceyunoS+EDuef2a6dhqLAO5uGvHUAwv9WLTZBcd+obG
	 J+8lEfejxfD8W+Z8rQevGZmh9Qtc0sO+IpmS15FDwTmnDcGAkwqujYrHLEk2vfSdWf
	 saRH6xyV9oDN9up+C0AY6USLYkQuzUKnXSGdvSbusr61MpRvpOqVvvLRoECBiEI94n
	 AhiwSjLxdD+ij71Bze3Lp3Laid2itrR+rWsWLV4i9uAKJVJwADAF1gRyKPf4hxP8SX
	 HlfmLc7++CzU6MPt3CItcVwf+YTm7gx+cnEdKbQzN794M35kCMiFBZ8tsEmh9OZ+kP
	 8WbMC35sDITkg==
Message-ID: <sashiko-outbox-236131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 13/25] crypto: amlogic - Introduce hasher
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-14-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-14-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:56:35 +0000
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
- [High] crypto: amlogic: 0-byte SHA DMA descriptor in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: double completion on error in
  meson_hasher_do_one_request()
- [High] crypto: amlogic: invalid src DMA map on final in
  meson_hasher_req_map()
- [High] crypto: amlogic: unaligned DMA request ctx via
  ahash_request_ctx()
- [Medium] crypto: amlogic: debugfs leak and UAF on
  meson_hasher_register() error
- [Medium] crypto: amlogic: leaked partial_addr DMA mapping in
  meson_kick_hardware()
- [Medium] crypto: amlogic: meson_register_algs() unregisters failed
  ahash algorithm
- [Medium] crypto: amlogic: partial buffer DMA mapping leak in
  meson_kick_hardware()
- [Medium] crypto: amlogic: sg_virt() indexed by sg_dma_len() in
  amlogic-gxl-hasher
--

commit 8f2023eba0fbe0a55f65e0dd07dde281e4bf36f0
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Introduce hasher

This commit adds asynchronous hardware SHA1, SHA224, and SHA256 support to
the Amlogic GXL crypto driver.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 0e17105520dfb..9676b86a50891 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
[ ... ]
> @@ -172,6 +175,15 @@ int meson_register_algs(struct meson_dev *mc, struct=
 meson_alg_template *algs,
>  				return err;
>  			}
>  			break;
> +		case CRYPTO_ALG_TYPE_AHASH:
> +			err =3D crypto_engine_register_ahash(&algs[i].alg.ahash);
> +			if (err) {
> +				dev_err(mc->dev, "Fail to register %s\n",
> +					algs[i].alg.ahash.base.halg.base.cra_name);
> +				meson_unregister_algs(mc, algs, count);
> +				return err;
> +			}
> +			break;
>  		}
>  	}
> =20
> @@ -190,6 +202,9 @@ void meson_unregister_algs(struct meson_dev *mc, stru=
ct meson_alg_template *algs
>  		case CRYPTO_ALG_TYPE_SKCIPHER:
>  			crypto_engine_unregister_skcipher(&algs[i].alg.skcipher);
>  			break;
> +		case CRYPTO_ALG_TYPE_AHASH:
> +			crypto_engine_unregister_ahash(&algs[i].alg.ahash);
> +			break;
>  		}
>  	}
>  }

[Severity: Medium]
Does meson_register_algs() unregister the entry that just failed to
register?

meson_register_algs() sets algs[i].mc =3D mc at the start of each loop
iteration, and meson_unregister_algs() unregisters every entry with a
non-NULL algs[i].mc without clearing it.  If
crypto_engine_register_ahash() fails, meson_unregister_algs() calls
crypto_engine_unregister_ahash() on the unregistered algs[i], which can
trigger a NULL pointer dereference in list_del_init(&alg->cra_list) or a
WARN() in crypto_unregister_alg().

> @@ -227,13 +242,20 @@ static int meson_crypto_probe(struct platform_devic=
e *pdev)
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
> +
> +error_hasher:
> +	meson_cipher_unregister(mc);
> +
>  error_flow:
>  	meson_free_chanlist(mc, mc->flow_cnt - 1);
>  	return err;

[Severity: Medium]
Does error_hasher leak mc->dbgfs_dir when meson_hasher_register() fails?
Leaving the "gxl-crypto" debugfs directory and "stats" file registered
blocks subsequent probes from creating the directory and leaves a dangling
pointer to the devm-freed struct meson_dev in the file's private data,
causing a use-after-free in meson_debugfs_show() if the file is read.

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
Should meson_hasher_req_map(), meson_hasher_req_unmap(), and
meson_hasher_do_one_request() skip touching req->src when rctx->final_req
is set?

In the ahash API, .final() only finalizes the hash state into req->result,
and callers such as ahash_def_finup_finish1() invoke .final(req) after
.update(req) without zeroing req->nbytes.  Although
meson_hasher_do_one_request() sets ctx.nbytes =3D 0 when rctx->final_req is
true, it still sets ctx.src_sg =3D req->src (dereferenced via
sg_dma_len(ctx.src_sg)) and calls meson_hasher_req_map() and
meson_hasher_req_unmap(), which check !req->nbytes and DMA-map req->src.
If the caller freed or cleared req->src after .update() completed without
zeroing req->nbytes, sg_nents(req->src) and sg_dma_len(ctx.src_sg) will
dereference an invalid or NULL scatterlist pointer.

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
Does returning early on wait_for_completion_timeout() failure here leak the
rctx->partial_addr DMA mapping when rctx->partial_mapped is true?

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

[Severity: Medium]
Can indexing sg_virt(ctx.src_sg) by ctx.src_offset read out of bounds when
dma_map_sg() merges scatterlist entries?

len and the sg_next() advance condition use sg_dma_len(ctx.src_sg), which
can exceed ctx.src_sg->length when dma_map_sg() coalesces adjacent
segments.  If a trailing partial block falls after the first scatterlist
entry in a coalesced DMA segment, ctx.src_offset advances past
ctx.src_sg->length and memcpy() in both meson_hasher_do_one_request() and
meson_fill_partial_buffer() reads past the end of ctx.src_sg's virtual
buffer instead of the next scatterlist entry.

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
Does a non-final update that ends with a partial block (< blocksize bytes)
program and kick a 0-length SHA DMA descriptor with t_src =3D 0?

This happens in two ways.  First, meson_setup_state_descs() runs at the
top of the loop before checking whether a full block is ready; on any
non-initial update (rctx->begin_req =3D=3D false), it writes the state setup
descriptors and sets ctx.tloffset to setup_desc_cnt.  Second, when an
update has full blocks followed by trailing sub-block bytes (e.g. 74
bytes), meson_setup_data_descs() only sets DESC_LAST when !ctx->nbytes,
ctx->tloffset =3D=3D MAXDESC, or rctx->partial_mapped, so the full-block
descriptor leaves ctx.tloffset > 0 without kicking hardware.  On the
iteration that buffers the trailing sub-block bytes into rctx->partial,
ctx.nbytes becomes 0 while ctx.todo is 0 and ctx.tloffset > 0, so both
continue guards are bypassed and meson_setup_data_descs() emits a bogus
0-byte descriptor at physical address 0 and kicks the DMA engine.

> +
> +fail:
> +	meson_hasher_req_unmap(req);
> +
> +fail_map_req:
> +	dma_unmap_single(mc->dev, ctx.state_addr, sizeof(rctx->state),
> +			 DMA_BIDIRECTIONAL);

[Severity: Medium]
Should the fail cleanup path also unmap rctx->partial_addr when
rctx->partial_mapped is true?  If meson_kick_hardware() fails after
meson_fill_partial_buffer() mapped rctx->partial, this unwind path only
unmaps req->src and ctx.state_addr, leaking the streaming DMA mapping for
rctx->partial.

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

crypto_finalize_hash_request() completes req, and when do_one_request()
returns a negative error code to crypto_pump_requests(), crypto_engine
calls crypto_request_complete(async_req, ret) a second time, causing a
double completion and potential use-after-free if the caller freed the
request on the first completion.  meson_handle_cipher_request() returns 0
after finalizing the request.

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
meson_hasher_init() reserves DMA alignment padding via
crypto_ahash_set_reqsize_dma(), but every request callback in this file
retrieves rctx with ahash_request_ctx(req) instead of
ahash_request_ctx_dma(req), and struct meson_hasher_req_ctx uses
____cacheline_aligned (64 bytes on arm64) rather than ARCH_DMA_MINALIGN
(128 bytes on arm64).

Because ahash_request_ctx(req) is only aligned to CRYPTO_MINALIGN (8 bytes
on arm64), rctx->state (mapped with DMA_BIDIRECTIONAL) and rctx->partial
are not cacheline-aligned and share DMA cachelines with adjacent struct
ahash_request and struct meson_hasher_req_ctx fields, which can corrupt
those fields on DMA cache invalidation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D13

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795516631;
	b=VNqQ6nZ4UolJYQZBGpFYLPbYlpEt2pGgzKrUjOf2nDaGvKUbT6Q+diSHgfDv18celtqY
	 I2tzAnaTuQu4sDWDV/SAwrRJBcDqnEpcw0sr3cnjtnN+1kTmHHqQpC5fC+xDvfd6QYrJ7
	 RGIW9aC8qHh8N9RQE5DudwGQqxZymiCP6/oo42fwhNH8tFoeqK3mrX9hZXVsYJJXcL0mc
	 Ugv9Qla3KCGKNuzYJs31OT4fXa09plcCz3Y9bZeZwfJPUZetFC5BUKMs89GV0+AG9b67L
	 Ojmc9fOc+kz1t2CCL0KREAmlUfyqksmYtwdU0tdPjfSM6Zf3d3KTw6QVdcFMTOud5GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516631;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=haEATHXpVwfGz8LqOneVJChsCc9IrYOW88iySKnFUX4=;
	b=g03hbDqyPEUG/z456V5mNTkvM5A8+qUSF4CgsQyPDuzYWXWeyZSrvZ00KS4SaHMdMJ6Y
	 lpA0aq/OjNO5ec321kB8eJuorpB4fDQbesu6jm+yiEv7lQY7/i9DHWXLbIkjZxxhqmqHk
	 IRQ1Awjoy258z+VDf2dAYRAHw01+uCSLW7mjdousjp/aEn76M59sg0BhAkvyqhGldhYTX
	 NG6/uOd74j6A8WTCMC/bQHzyz89TwN9Fp0q+Va2+41b1oxax2LbqcHZ46ToCxBj11ShJF
	 l3W48EqSqhDhRjaBXFsn8Fc/uSQ1mcoV3hYiOG7pjIRUAGWOvExpWZ8eoqh1YJVZuAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="g0s1ar/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3083606A339
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g0s1ar/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAB71F000D0;
	Tue, 24 Nov 2026 10:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795516631;
	bh=haEATHXpVwfGz8LqOneVJChsCc9IrYOW88iySKnFUX4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g0s1ar/LhPmsu/TYLJs7iG8+r8CNcr81Fu/dgf10tLIxoq+WJF4s2NpeaoDEJgo0E
	 myJo8FJN9Pu5vVX65wL7N/0ZSgo2jvGmAe8QYfwnxQRxclhx0YWWlBzTHfcLc5UrrS
	 7gwReqWr41Rx6jzRHquL8BfsVlDkVxqzekJdRJzn/IUat9mHlsxqeu5RmEjKBU3v68
	 xes/U3gKz7YKav4UJsrIuQ8d/SnD59ocriedfKWvWx4Kpd4FA6XV/0p5emXgxrjRGz
	 o2ENcn/i89D+woP+jg01NXuWCnbZvtNSzUyghMKr1eE73mQU3xGAhL7A/460/B4Gm0
	 tlGarWUDNbhpg==
Message-ID: <sashiko-outbox-230968@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - fix ECDH compute_shared_secret
 dst_len requirement
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Zhiqi Song" <songzhiqi1@huawei.com>, "Longfang
 Liu" <liulongfang@huawei.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
In-Reply-To: <20261124101912.1718740-1-rc4d5a@protonmail.com>
References: <20261124101912.1718740-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 10:37:09 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] crypto: hpre: hpre_ecdh_hw_data_clr_all() corrupts dst buffer
  on error paths
- [Medium] crypto: hpre: hpre_ecdh_cb() reports wrong dst_len for P-192
  public key
- [Medium] crypto: hisilicon/hpre - hpre_ecdh_dst_data_init() rejects
  multi-entry sg
--

commit 7c1c914742d923b9ff38c5599d17f759c401716d
Author: Ryan Prinz <rc4d5a@protonmail.com>

crypto: hisilicon/hpre - fix ECDH compute_shared_secret dst_len requirement

This commit lowers the minimum dst_len required for ECDH
compute_shared_secret() to curve_sz by allocating a 2 * ctx->key_sz DMA
bounce buffer and copying out the X coordinate on completion.

> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto=
/hisilicon/hpre/hpre_crypto.c
> index 66a276786a7d0..a3fec7c7549dd 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> @@ -1390,9 +1390,11 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_=
ctx *ctx,
>  				      struct scatterlist *dst,
>  				      struct scatterlist *src)
>  {
> +	unsigned int curve_sz =3D hpre_ecdh_get_curvesz(ctx->curve_id);
>  	struct device *dev =3D ctx->dev;
>  	struct hpre_sqe *sqe =3D &req->req;
>  	dma_addr_t dma;
> +	char *p;
> =20
>  	dma =3D le64_to_cpu(sqe->in);
>  	if (unlikely(dma_mapping_error(dev, dma)))
> @@ -1405,8 +1407,24 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_=
ctx *ctx,
>  	if (unlikely(dma_mapping_error(dev, dma)))
>  		return;
> =20
> -	if (dst)
> +	if (req->dst) {
> +		/*
> +		 * Bounce buffer for compute_shared_secret(): holds the
> +		 * hardware's full, hw-slot-padded X||Y output. Copy out
> +		 * just the tightly-packed X coordinate to the caller's
> +		 * own (possibly smaller) buffer.
> +		 */
> +		p =3D req->dst;
> +		if (dst)
> +			scatterwalk_map_and_copy(p + ctx->key_sz - curve_sz,
> +						 dst, 0, curve_sz, 1);
> +		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
> +	} else if (dst) {
>  		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
> +		p =3D sg_virt(dst);
> +		memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
> +		memmove(p + curve_sz, p + (ctx->key_sz << 1) - curve_sz, curve_sz);
> +	}
>  }

[Severity: Medium]
Does moving the destination buffer copy and memmove() compaction into
hpre_ecdh_hw_data_clr_all() corrupt the caller's req->dst buffer on error
paths?

When hpre_send() fails in hpre_ecdh_compute_value() after
hpre_ecdh_dst_data_init() succeeds, the clear_all label calls
hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src), which now
copies zeros from the unused bounce buffer into req->dst or shifts
sg_virt(req->dst) in place via memmove().  The same happens in
hpre_ecdh_cb() when hpre_alg_res_post_hf() reports a hardware error.
Also, because dma_unmap_single() is inside the else if (dst) branch,
callers cannot simply pass dst =3D NULL on error without leaking the DMA
mapping for generate_public_key().

> =20
>  static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
> @@ -1416,12 +1434,11 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, vo=
id *resp)
>  	struct hpre_asym_request *req =3D NULL;
>  	struct kpp_request *areq;
>  	u64 overtime_thrhld;
> -	char *p;
>  	int ret;
> =20
>  	ret =3D hpre_alg_res_post_hf(ctx, resp, (void **)&req);
>  	areq =3D req->areq.ecdh;
> -	areq->dst_len =3D ctx->key_sz << 1;
> +	areq->dst_len =3D req->dst ? curve_sz : ctx->key_sz << 1;

[Severity: Medium]
Should the false branch here be curve_sz << 1 instead of ctx->key_sz << 1?

For ECC_CURVE_NIST_P192, ctx->key_sz is 32 (HPRE_ECC_HW256_KSZ_B) while
curve_sz is 24.  On generate_public_key(), the two memmove() calls compact
X and Y into 2 * curve_sz =3D 48 bytes at the start of dst, so setting
areq->dst_len to ctx->key_sz << 1 reports 64 bytes including 16 trailing
uncompacted bytes.

[ ... ]

> @@ -1503,12 +1526,15 @@ static int hpre_ecdh_src_data_init(struct hpre_as=
ym_request *hpre_req,
>  }
> =20
>  static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
> -				   struct scatterlist *data, unsigned int len)
> +				   struct scatterlist *data, unsigned int len,
> +				   bool is_shared_secret)
>  {
> +	gfp_t gfp =3D hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :=
 GFP_ATOMIC;
>  	struct hpre_sqe *msg =3D &hpre_req->req;
>  	struct hpre_ctx *ctx =3D hpre_req->ctx;
>  	struct device *dev =3D ctx->dev;
>  	dma_addr_t dma;
> +	void *ptr;
> =20
>  	if (unlikely(!data || !sg_is_last(data))) {
>  		dev_err(dev, "data is illegal!\n");

[Severity: Medium]
Does checking !sg_is_last(data) here still cause TPM2 session salt
derivation in tpm_buf_append_salt() to fail with -EINVAL, as well as
rejecting multi-entry destination scatterlists on the bounce-buffered
compute_shared_secret() path?

Before calling crypto_kpp_compute_shared_secret(), tpm_buf_append_salt()
calls crypto_kpp_generate_public_key() with a 2-entry scatterlist for X
and Y:

drivers/char/tpm/tpm2-sessions.c:tpm_buf_append_salt() {
    ...
	sg_init_table(s, 2);
	sg_set_buf(&s[0], x, EC_PT_SZ);
	sg_set_buf(&s[1], y, EC_PT_SZ);
    ...
	kpp_request_set_input(req, NULL, 0);
	kpp_request_set_output(req, s, EC_PT_SZ*2);
	rc =3D crypto_wait_req(crypto_kpp_generate_public_key(req), &wait);
    ...
}

Because s has two entries, !sg_is_last(data) rejects the
generate_public_key() call before tpm_buf_append_salt() reaches
compute_shared_secret().  In addition, when is_shared_secret is true, the
output is copied via scatterwalk_map_and_copy() from a bounce buffer, so
requiring sg_is_last(data) rejects multi-segment destination scatterlists
there too (and leaves len unused).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124101912.1718=
740-1-rc4d5a@protonmail.com?part=3D1

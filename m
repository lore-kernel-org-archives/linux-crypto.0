Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799565;
	b=TmdPLp2KK4qpKNwJnF+oB+WItAU4asNjqsthk7ihJEouyZ8KxqE3y0RBbQDr/hkUby+d
	 y5bfZ+17j93FaehcYhPoVGQJeIPTfw0p1pcKL99txi8q3OvpBqs+7HLm12neR5+lXATJi
	 XBNqrbbB7EiSn1q6CE1dk8O/0UBJClQFJyjJtbype+qSYK/TvmG1HtyMyvklEnkO+kTrI
	 QTR++feccFFFLCETyHb0ZS/xyITRK5ebFCtA9eK3sZPRHhKQChzDE44d21Tiys+Lc0Ig1
	 7XroBiik0jtEF2HruN6hqwpMoZ1C4bnCZ+uJ9NwOEtEZ8r0WnBMd8eCA38DhdHwpPeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799565;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=M9+youAg31ETkg5SmtqXtQdd6AGe81YyK+pizb8H3gM=;
	b=Xn/Ji3Mawr8zH5sSFKeflXcojKibMObekMyCCRjoTseb3w7zUeYp+JWP2kuZYpDr5kZ8
	 gfYWmOkU9vtMCJs6XcG5yxiEm8SYELJVF0E/GrrNoituMA6bCpCiFIt+GCUSUtlKS8fLI
	 Xp8AXZiTRLLr0fXoXuadpX6SfRw0b8hHdUEHq42UmWJYEyv9iFasllT/DlBbbtcaUsOEJ
	 vYoYf83F8AAvpM/LRXlrEGeHUBc52bkw/xJzTwgNcTNeFHgjGpg/CoxHeFVTs4pCBcGjm
	 e7/cPY+ppvzH3RzbJZML2G9CODbCmvl1cht/2BTt0CX2+yXoqAhhain+5lNIrz+fnmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nfGqWV/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40979606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfGqWV/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BD81F000C1;
	Fri, 27 Nov 2026 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795799564;
	bh=M9+youAg31ETkg5SmtqXtQdd6AGe81YyK+pizb8H3gM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nfGqWV/vfqtAzX3G9XrElH5KqW/Lq2ghbdnHmxZuRZeDAO6TJvhT9CvCHRSWXgmxM
	 JL+9P/7Z94KD5uQBxXIEOUw+PViogLrxpxZnyn6phcJLiHBVCp6te6xBJ0fiCwwm1c
	 oKCYeuh+4bdEgErJcoT2NnATVn1DwyWqVNJkgz+A6Ct2JDZn8mhDLvEDSzkofSkk0x
	 YaqzDuv9dbIFtMHobf20iqiZQJyPofUoOs4XWtjmDmKV5WsNcgQ/A8lTs2Me6OHPTD
	 NgA+csubPiLhsNGicH5kOjWs8nZMaQ500+nfS6uYtj1/PzOvOd/ed1GEa806DZT+yt
	 fP6ih4x06Jg2w==
Message-ID: <sashiko-outbox-237969@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: qce - aead: unmap the scatterlist that was
 mapped
Reply-To: sashiko-reviews@lists.linux.dev
To: "Thomas Fourier" <fourier.thomas@gmail.com>
Cc: "Bartosz Golaszewski" <brgl@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Wei Yongjun" <weiyongjun1@huawei.com>,
 =?utf-8?b?b3BlbiBsaXN0OlFVQUxDT01NIENSWVBUTyBEUklWRVJT?= <linux-crypto@vger.kernel.org>
In-Reply-To: <20261127170201.62667-2-fourier.thomas@gmail.com>
References: <20261127170201.62667-2-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 17:12:43 +0000
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
- [Low] crypto: qce - Fixes trailer cites 5c0ecc2e81ec instead of
  9363efb4181c
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] crypto: qce: missing error check in
  qce_aead_ccm_prepare_buf_assoclen() [1]
--

commit 377c9768f06fe7baadd13bf43eb833dcae74b8e1
Author: Thomas Fourier <fourier.thomas@gmail.com>

> crypto: qce - aead: unmap the scatterlist that was mapped
>
> qce_aead_async_req_handle() maps rctx->src_sg, which for CCM with
> src !=3D dst is a table built by the driver and not req->src, but its
> error path unmaps req->src. The mapping result is also checked with
> "< 0" although dma_map_sg() returns 0 on failure.
>
> Unmap rctx->src_sg like qce_aead_done() does and treat a zero return of
> dma_map_sg() as an error.
>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> Fixes: 5c0ecc2e81ec ("crypto: qce - Fix some error handling path")

[Severity: Low]
Both the src_nents < 0 check and the dma_unmap_sg(..., req->src, ...) call
were introduced by 9363efb4181c ("crypto: qce - Add support for AEAD
algorithms"), whereas 5c0ecc2e81ec ("crypto: qce - Fix some error handling
path") only added ret =3D src_nents inside the existing error branch.  Shou=
ld
the Fixes tag point to 9363efb4181c ("crypto: qce - Add support for AEAD
algorithms") instead?

> diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
> index 8ce1a9f3c9d80..a40dd338d7b5d 100644
> --- a/drivers/crypto/qce/aead.c
> +++ b/drivers/crypto/qce/aead.c
> @@ -450,8 +450,8 @@ qce_aead_async_req_handle(struct crypto_async_request=
 *async_req)
> =20
>  	if (diff_dst) {
>  		src_nents =3D dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_=
src);
> -		if (src_nents < 0) {
> -			ret =3D src_nents;
> +		if (!src_nents) {
> +			ret =3D -EIO;
>  			goto error_unmap_dst;
>  		}
>  	} else {
> @@ -478,7 +478,7 @@ qce_aead_async_req_handle(struct crypto_async_request=
 *async_req)
>  	qce_dma_terminate_all(&qce->dma);
>  error_unmap_src:
>  	if (diff_dst)
> -		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
> +		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
>  error_unmap_dst:
>  	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
>  error_free:

[Severity: High]
This problem wasn't introduced by this patch, but can
qce_aead_ccm_prepare_buf_assoclen() pass a negative rctx->src_nents to
sg_alloc_table() [1] when preparing rctx->src_sg?

drivers/crypto/qce/aead.c:qce_aead_ccm_prepare_buf_assoclen() {
    ...
	if (diff_dst)
		rctx->src_nents =3D sg_nents_for_len(req->src, totallen) + 1;
	else
		rctx->src_nents =3D sg_nents_for_len(req->src, totallen) + 2;

	gfp =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL : GFP_AT=
OMIC;
	ret =3D sg_alloc_table(&rctx->src_tbl, rctx->src_nents, gfp);
    ...
}

If a caller (such as an unprivileged user via AF_ALG) provides a source
scatterlist shorter than totallen, sg_nents_for_len() returns -EINVAL.
Adding 1 or 2 leaves rctx->src_nents negative, which is converted to a huge
unsigned int nents in sg_alloc_table(), exhausting memory and triggering the
OOM killer.

[1] https://sashiko.dev/#/bug/linux-49abb05c-1d69-4d3c-9e75-f9284781402e

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127170201.6266=
7-2-fourier.thomas@gmail.com?part=3D1

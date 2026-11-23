Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795471761;
	b=qgf1njf3B2IkdE6tpbmREox52PWaPkqwDOSPM0IGqFGEmGWUXTdTO5rK6Oaj1PMTFRji
	 IcyQRniU3olfNlsUULQT+eTEDwsVSPW7qKf0d/b4RIFS+iVuNCQMSlfNHYnppeV42hVuM
	 /2kaISVHO5hhwPc/tfnh334P8I0CUtO7KsrpLQNOLe6mVdkM1joZZJamUy+1g9rNi2+6R
	 vqxEVimIXhtosJk56o2DAz1748jd176e/MY+CR8Zhabm9Zrloorhzq/CYulC0tQ/ggcVY
	 xSFrUMSPg5TC65NBuY/qUPlGissYA4tEtAPnexNJ3xtt7I9v74YRCuFYOmWquIlazzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795471761;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tVswqTTTT3aV6rDHcynjHEB1FK2M0Q3FWyjtolQpcIc=;
	b=WPvrJK7zcnuCB2JIiomOE9NQXt7AEPtrbUrOIxFX/lwrlfcHrYYfp1VJTp4h6EZ3gS/P
	 u25wbQitQqpGDDPgcstuw8WVgZpAuFLeK+I6WX2hj1+rKCiYWHxP7rfLcJlrxQD2Ge8Yg
	 unQJrvoByuASKS8YRMNiaWzUjbaqvM2Sb4xFm1x4Y5ZLusR+NvbXCVhEm1/f2h07D4CY9
	 G1yzF5Y0E0vMVTO7H3U6ftRUzZ5Xqm3uim1Uo6udjHKPcMCtWPAzWmCy0l6k27me1KVre
	 llMZERb6VFlOjZwuXPpYLYEw/lQZNIHAgQh4LgeyUeh+ng/kFojpaTGbbkgNYCGt3Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hM02yJST;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E19606A31E
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 22:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hM02yJST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40661F000D3;
	Mon, 23 Nov 2026 22:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795471761;
	bh=tVswqTTTT3aV6rDHcynjHEB1FK2M0Q3FWyjtolQpcIc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hM02yJSTmZzBFDk9tIprVly3ggNY17OKNgFmW0on6rugXiEbEiF0zeieGkRrcSKtg
	 S22HErrcu1aJxWxsfnuvFy7+4wU2sdFMTCV3Youzn/5g2KzcBPmnHl78LSr+CpV1g5
	 gCnWIkG07b71GZ7UfpuaoV4XVUEwSBxLbhN68KXdHNYqSO9wcQf4m8I3txs90150Ay
	 zxLQZp5v5TPyaAKlRCZ0JE7DU/YgoI8gUNtAv2pGOgBiavQQ8USW2f4BI0hn2mbsgx
	 6vnlktNLWUp+pJf1GcrOiUBciPAKSyLrE5GyDo64aA8E6+2RykLQjytQfnvxb/jjMy
	 1FdNIiOAQC7lw==
Message-ID: <sashiko-outbox-230116@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - fix missing DH/ECDH public key
 validation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Zhiqi Song" <songzhiqi1@huawei.com>, "Longfang
 Liu" <liulongfang@huawei.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
In-Reply-To: <20261123215144.1677044-1-rc4d5a@protonmail.com>
References: <20261123215144.1677044-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 22:09:20 +0000
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
- [High] crypto: hisilicon/hpre: wrong P-192 key size in
  hpre_ecdh_peer_pubkey_valid()
- [Medium] crypto: hisilicon/hpre: GFP_KERNEL alloc in
  hpre_ecdh_peer_pubkey_valid()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] crypto: hisilicon/hpre: heap buffer overflow in
  hpre_ecdh_src_data_init() [1]
--

commit 0db0261ad258477cf8a2d64e1bd4053cb55e5606
Author: Ryan Prinz <rc4d5a@protonmail.com>

crypto: hisilicon/hpre - fix missing DH/ECDH public key validation

This commit adds peer public key validation to hpre_dh_compute_value()
and hpre_ecdh_compute_value() before requests are submitted to the
hardware queue.

> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto=
/hisilicon/hpre/hpre_crypto.c
> index 66a276786a7d0..a5702d2d73b3d 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c

[ ... ]

> @@ -1526,6 +1599,54 @@ static int hpre_ecdh_dst_data_init(struct hpre_asy=
m_request *hpre_req,
>  	return 0;
>  }
> =20
> +static int hpre_ecdh_peer_pubkey_valid(struct hpre_ctx *ctx,
> +				       struct scatterlist *src,
> +				       unsigned int src_len)
> +{
> +	const struct ecc_curve *curve =3D ecc_get_curve(ctx->curve_id);
> +	unsigned int nbytes =3D ctx->key_sz;
> +	unsigned int half =3D src_len >> 1;
> +	u8 coord_buf[2 * ECC_MAX_BYTES] =3D { };
> +	struct ecc_point *pk;
> +	size_t copied;
> +	int ret;
> +
> +	if (!curve)
> +		return -EINVAL;
> +
> +	/*
> +	 * Src_data is gx and gy concatenated, each zero-padded up to
> +	 * nbytes, matching the convention hpre_ecdh_src_data_init() uses
> +	 * for the hardware submission path.
> +	 */
> +	if (!half || half > nbytes || 2 * nbytes > sizeof(coord_buf))
> +		return -EINVAL;
> +
> +	copied =3D sg_pcopy_to_buffer(src, sg_nents_for_len(src, src_len),
> +				    coord_buf + (nbytes - half), half, 0);
> +	if (copied !=3D half)
> +		return -EINVAL;
> +
> +	copied =3D sg_pcopy_to_buffer(src, sg_nents_for_len(src, src_len),
> +				    coord_buf + nbytes + (nbytes - half),
> +				    half, half);
> +	if (copied !=3D half)
> +		return -EINVAL;
> +
> +	pk =3D ecc_alloc_point(curve->g.ndigits);
> +	if (!pk)
> +		return -ENOMEM;

[Severity: Medium]
Can ecc_alloc_point() sleep when CRYPTO_TFM_REQ_MAY_SLEEP is not set in
the request flags?

ecc_alloc_point() unconditionally allocates with GFP_KERNEL, whereas
hpre_dh_compute_value() and hpre_ecdh_src_data_init() select GFP_ATOMIC
when CRYPTO_TFM_REQ_MAY_SLEEP is clear.  Using stack buffers with
ECC_POINT_INIT() would avoid the allocation altogether.

> +
> +	ecc_swap_digits(coord_buf, pk->x, curve->g.ndigits);
> +	ecc_swap_digits(coord_buf + nbytes, pk->y, curve->g.ndigits);
> +
> +	ret =3D ecc_is_pubkey_valid_partial(curve, pk);

[Severity: High]
Does setting nbytes to ctx->key_sz break validation for ecdh-nist-p192?

For ECC_CURVE_NIST_P192, hpre_ecdh_supported_curve() sets ctx->key_sz to
HPRE_ECC_HW256_KSZ_B (32 bytes, the 256-bit hardware slot width), while
the curve coordinate size is 24 bytes (curve->g.ndigits =3D 3):

drivers/crypto/hisilicon/hpre/hpre_crypto.c:hpre_ecdh_supported_curve() {
	switch (id) {
	case ECC_CURVE_NIST_P192:
	case ECC_CURVE_NIST_P256:
		return HPRE_ECC_HW256_KSZ_B;
}

When a valid 48-byte P-192 public key (half =3D 24) is checked, the
coordinates are right-aligned to coord_buf + 8 and coord_buf + 40, but
ecc_swap_digits() reads only 3 digits (24 bytes) starting at coord_buf
and coord_buf + 32.  That shifts each coordinate right by 64 bits and
causes ecc_is_pubkey_valid_partial() to reject every valid 48-byte P-192
public key with -EINVAL (including the testmgr self-test), while a
64-byte input on P-192 passes half <=3D nbytes and has only the upper 24
bytes of each 32-byte coordinate validated before
hpre_ecdh_src_data_init() copies all 32 bytes to the hardware buffer.

nbytes should be derived from curve->g.ndigits << ECC_DIGITS_TO_BYTES_SHIFT
instead of ctx->key_sz.

> +
> +	ecc_free_point(pk);
> +
> +	return ret;
> +}
> +
>  static int hpre_ecdh_compute_value(struct kpp_request *req)
>  {
>  	struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
> @@ -1543,6 +1664,12 @@ static int hpre_ecdh_compute_value(struct kpp_requ=
est *req)
>  	}
> =20
>  	if (req->src) {
> +		ret =3D hpre_ecdh_peer_pubkey_valid(ctx, req->src, req->src_len);
> +		if (unlikely(ret)) {
> +			dev_err(dev, "invalid peer public key, ret =3D %d!\n", ret);
> +			return ret;
> +		}
> +
>  		ret =3D hpre_ecdh_src_data_init(hpre_req, req->src, req->src_len);

[Severity: Critical]
This problem wasn't introduced by this patch, but can an odd req->src_len
pass validation and cause a 1-byte DMA buffer overflow in
hpre_ecdh_src_data_init() [1]?

Neither hpre_ecdh_peer_pubkey_valid() nor hpre_ecdh_src_data_init()
rejects an odd length when computing req->src_len >> 1:

drivers/crypto/hisilicon/hpre/hpre_crypto.c:hpre_ecdh_src_data_init() {
	...
	shift =3D ctx->key_sz - (len >> 1);
	if (unlikely(shift < 0))
		return -EINVAL;

	ptr =3D dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
	if (unlikely(!ptr))
		return -ENOMEM;

	tmpshift =3D ctx->key_sz << 1;
	scatterwalk_map_and_copy(ptr + tmpshift, data, 0, len, 0);
}

For a 32-byte curve such as NIST P-256, a 65-byte input whose first 64
bytes form a valid point passes both half <=3D nbytes (65 >> 1 =3D=3D 32) a=
nd
shift >=3D 0, after which scatterwalk_map_and_copy() writes 65 bytes at
offset 64 of the 128-byte (ctx->key_sz << 2) buffer.

[1] https://sashiko.dev/#/bug/linux-42c6cdd1-7f7e-4071-bb2f-a4db5935267e

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123215144.1677=
044-1-rc4d5a@protonmail.com?part=3D1

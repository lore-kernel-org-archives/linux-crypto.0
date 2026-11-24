Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530195;
	b=jnsec0zHK0NIELjpt54QC+ZnsUQpDeU6sPaaHy74nyIgnqS0f2YfY5w+6/jltUBx+rr8
	 G4zTNdWdHl1/hY8v7bZhlXnGvUGzYVq/2mFiSK/M8sAJSEziwC1BPQ5zFH+X4sxy5/JYb
	 tHpB6Bv5BtpO+T0i5egs3s0b+GiuzZYIwqKVIyFwbPp9p8Z7VSPITlro8FirgZDDXwizP
	 zhfUtBSfTzrJ27+mTRVQN06FtPqbrVOAVomqN9uG1VBYVQ8YtZrE0WwySRWOy1lppbcSF
	 pkL5wxUBx8RDgYluJhOQ+IwG0Lq97KtmIVI4oEnEmflLbzBt7dNiQXRKwYeNTOUwZ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530195;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5gVToo1FpGaDFr+bXbxhuK3a+Dpx7/ZsW9WcCC4lSnA=;
	b=ZQjXt9dPv5SG8/ncrteyyefDjjKdCsY1ds52O6zmx1rGb3LERgcQUetBLA1Q+oWUX6/Z
	 UUBjE7dSEfqooDpmddj57kfOkMYvHMbbf7CsNtrkS+82jJdQAzQCW/4M2wFu/4r+XX0V3
	 CDaITY9nSLXo4TtQWmbsx5vLkZp+jAa+jppkNJego+nClza6FJOqRFJD1B/R6kNaFKVTQ
	 qc5H0g5ailMUMnY/GEjJiQRhPEJ048GBysQTDHJguBElcn6Ysr6AeHV0azlLy4QxAgIXV
	 qreX73kWvixqWTl1Ur08dW/K9kbjvAWqc2NisD54kHaIMKvO16p9REOQj1/yTqgAFvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InzuOnOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE08606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=InzuOnOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553F61F000CA;
	Tue, 24 Nov 2026 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795530194;
	bh=5gVToo1FpGaDFr+bXbxhuK3a+Dpx7/ZsW9WcCC4lSnA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=InzuOnOqTq55rAKeJzxtthi3dM/mFzu7JHKDAO7wW5YPnDq7r0PYwy+lWW6Zhdy+2
	 VcpwxSgdnDtpHedDGzBIjTBX7jCudsxnFdBI+WYkSAWdASeFmDZ8/6uOyfRFtYlD8q
	 ChBDHqvlgW6VhvoIJM2EbCjeqROJz90T3c5haZS05k0MNe4v6sNlDmBMYFAqBH+Hef
	 bRN0HtJn8PhO40KoMn7OElbr4FEg6ymNVvPaxxipE/eXKB5ivtB1zt+UeBCZJq/RqN
	 ZuStgI6nhBGqJ0q6lMCn/w76BBQmf11YwITl6XWa6x6zGEDf0hB73URor0+7mA/ELz
	 SNQlHhWonkd8Q==
Message-ID: <sashiko-outbox-231332@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] crypto: qat - fix missing DH public key validation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org
In-Reply-To: <20261124141238.1743680-1-rc4d5a@protonmail.com>
References: <20261124141238.1743680-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 14:23:13 +0000
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
- [Low] crypto: qat - duplicate buffer allocation and copy in
  qat_dh_compute_value()
--

commit 64e695c4154aabd945fc196f5f802b7fe41f7873
Author: Ryan Prinz <rc4d5a@protonmail.com>

crypto: qat - fix missing DH public key validation

This commit adds range validation for peer-supplied Diffie-Hellman public
keys in qat_dh_compute_value() so values outside [2, p - 2] are rejected
before reaching the QAT hardware queue.

> diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/driver=
s/crypto/intel/qat/qat_common/qat_asym_algs.c
> index 77d59e977472d..78f1b949614b9 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
> @@ -216,6 +216,63 @@ static unsigned long qat_dh_fn_id(unsigned int len, =
bool g2)
>  	}
>  }
> =20
> +/* Returns true iff 2 <=3D y <=3D p - 2, given big-endian buffers of p_s=
ize bytes. */
> +static bool qat_dh_pubkey_in_range(const u8 *y, const u8 *p_minus_1,
> +				   unsigned int p_size)
> +{
> +	bool is_zero_or_one =3D true;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < p_size - 1; i++) {
> +		if (y[i]) {
> +			is_zero_or_one =3D false;
> +			break;
> +		}
> +	}
> +
> +	if (is_zero_or_one && y[p_size - 1] <=3D 1)
> +		return false;
> +
> +	return memcmp(y, p_minus_1, p_size) < 0;
> +}
> +
> +static int qat_dh_peer_pubkey_valid(struct qat_dh_ctx *ctx,
> +				    struct scatterlist *src,
> +				    unsigned int src_len, gfp_t flags)
> +{
> +	unsigned int p_size =3D ctx->p_size;
> +	u8 *p_minus_1, *y;
> +	int i, ret =3D 0;
> +
> +	if (!src_len || src_len > p_size)
> +		return -EINVAL;
> +
> +	y =3D kzalloc(p_size, flags);
> +	if (!y)
> +		return -ENOMEM;
> +
> +	scatterwalk_map_and_copy(y + (p_size - src_len), src, 0, src_len, 0);
> +
> +	p_minus_1 =3D kmemdup(ctx->p, p_size, flags);
> +	if (!p_minus_1) {
> +		ret =3D -ENOMEM;
> +		goto free_y;
> +	}
> +
> +	for (i =3D p_size - 1; i >=3D 0; i--) {
> +		if (p_minus_1[i]-- !=3D 0)
> +			break;
> +	}
> +
> +	if (!qat_dh_pubkey_in_range(y, p_minus_1, p_size))
> +		ret =3D -EINVAL;
> +
> +	kfree_sensitive(p_minus_1);
> +free_y:
> +	kfree_sensitive(y);
> +	return ret;
> +}
> +
>  static int qat_dh_compute_value(struct kpp_request *req)
>  {
>  	struct crypto_kpp *tfm =3D crypto_kpp_reqtfm(req);
> @@ -241,6 +298,12 @@ static int qat_dh_compute_value(struct kpp_request *=
req)
>  	if (req->src_len > ctx->p_size)
>  		return -EINVAL;
> =20
> +	if (req->src) {
> +		ret =3D qat_dh_peer_pubkey_valid(ctx, req->src, req->src_len, flags);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +

[Severity: Low]
This isn't a bug, but qat_dh_peer_pubkey_valid() duplicates the buffer
preparation that qat_dh_compute_value() already performs right before
dma_map_single():

drivers/crypto/intel/qat/qat_common/qat_asym_algs.c:qat_dh_compute_value() {
	...
	if (req->src) {
		if (sg_is_last(req->src) && req->src_len =3D=3D ctx->p_size) {
			qat_req->src_align =3D NULL;
			vaddr =3D sg_virt(req->src);
		} else {
			int shift =3D ctx->p_size - req->src_len;

			qat_req->src_align =3D kzalloc(ctx->p_size, flags);
			if (unlikely(!qat_req->src_align))
				return ret;

			scatterwalk_map_and_copy(qat_req->src_align + shift,
						 req->src, 0, req->src_len, 0);

			vaddr =3D qat_req->src_align;
		}
	...
}

On every shared-secret request, qat_dh_peer_pubkey_valid() re-checks
src_len > p_size, allocates y and p_minus_1, copies req->src with
scatterwalk_map_and_copy(), and zeroes and frees both buffers via
kfree_sensitive().  Validating vaddr right before dma_map_single() (and
comparing against ctx->p without a per-request kmemdup()) would check the
exact buffer mapped for DMA while avoiding the duplicate scatterlist copy
and extra GFP_ATOMIC allocations when CRYPTO_TFM_REQ_MAY_SLEEP is clear.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124141238.1743=
680-1-rc4d5a@protonmail.com?part=3D1

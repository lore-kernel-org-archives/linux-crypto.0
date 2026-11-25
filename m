Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795649203;
	b=s4TedN60kaE+40Yjv216MwX43YweN5M4DIMXEkARXpDXl6Cm8O9E/lt/yvnxw/cNozQV
	 Nu+rWCxsuMlyiUGxoHE6fgKLl9ayhEvE+KzALnd4k431/3/F1waCyijHAoKsqhqiQ57gH
	 lj9K476xWJLGFVh6BuxYeeC9BQaTzw1RSm0chtv3VIVsoyQ4jSF+2o22wwQ4e8dRn2s/N
	 POEQfpYRASLVZNhGar6A3WEGc4IKq9WeyhgH2ZiEfd2kFbn/lUOsznO96sf2dVJTcs9xB
	 qXQU11MpHg6YI7IKCH7rH7jgPf9eEbB6byTSlu50ikw8UAGxlZgeg+xunDVbTUmrceA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795649203;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SokZVg1bMNHMNI7vkTIp/8GwWgTgMUHfQcEaNlaEVds=;
	b=Ds9IX767ZjM+z4/m76gfzcRv1fAUg8Y3tJZq5ATeL0cw0EXljIZjW6smWDBWiEZvzSJd
	 gCgX70k8ZauMs3fcAmx8GxUitzoEovWi95BuIT+acWi3bYbRHTXVzF9aM5mzmWe4xpvUv
	 ryPzQ1RooHn7DF8gt/AzdmBj1NWghP8KI8W0bTlHgpuAcHJtBDrWjzeWEZ2w6VPO7xn1h
	 blahDQqPGjyZWkCylbaQ/b9V9g4yn4uMmOSfUkzE1zhAy9QGl30DyaEMJEY7u744JIi/u
	 k+VzTz/CENHWAgnTHGaX9NiN1P+OG33ida2bspZBaIL19CD8CPmeeNgUI5RcnhcMvjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dleBgMN5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0B5606A323
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 23:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dleBgMN5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C0A1F000CF;
	Wed, 25 Nov 2026 23:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795649202;
	bh=SokZVg1bMNHMNI7vkTIp/8GwWgTgMUHfQcEaNlaEVds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dleBgMN53KVmlid6xSA0naijoZsgDJgI0lyApdFWPpSkwve8mgwAVy7JLb6fc15iw
	 ZQwxZ9JfkP7iqo1a4BGheGCT0ak1Yt9XnIL8xkrFiGe9vbQYFCJR35qq5TzlY3SBWL
	 Ofaw+SGT1SiAPG0Zmb4AF9HpkWpm1NarpGzAq4OFa185mDJbIlgDIPSl06TPrFWosr
	 WCa12w/pYRxDlIFPLrsflrwjRDs6lC5/ZgrV6fzFCSn+91am+7qXFWJCwZ1d6kxEid
	 vAqEc6L1/09Ny98YRXI4S5qCY/cT6pGTLiz/oYFLsCYHZdKHgMU0CQSUYqU5XxWEtt
	 16CxAAEta+6lA==
Message-ID: <sashiko-outbox-234394@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] crypto: qat - fix missing DH public key validation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org
In-Reply-To: <20261125231859.1857450-1-rc4d5a@protonmail.com>
References: <20261125231859.1857450-1-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 23:26:41 +0000
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
- [High] crypto: qat - build failure from undeclared
  crypto_dh_pubkey_in_range()
- [Low] crypto: qat - duplicate buffer allocation and copy in
  qat_dh_compute_value()
--

commit 0140ee9c1bcbef53ad898f6e8736ea350a10f33a
Author: Ryan Prinz <rc4d5a@protonmail.com>

crypto: qat - fix missing DH public key validation

This commit adds range validation for peer Diffie-Hellman public keys in
qat_dh_compute_value() before submitting requests to the QAT hardware
queue.

> diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/driver=
s/crypto/intel/qat/qat_common/qat_asym_algs.c
> index 77d59e977472d..e7532c66404d8 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
> @@ -216,6 +216,43 @@ static unsigned long qat_dh_fn_id(unsigned int len, =
bool g2)
>  	}
>  }
> =20
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
> +	if (!crypto_dh_pubkey_in_range(y, p_minus_1, p_size))
> +		ret =3D -EINVAL;

[Severity: High]
Does this break the build when CONFIG_CRYPTO_DEV_QAT is enabled?
crypto_dh_pubkey_in_range() is not declared in include/crypto/dh.h or
defined anywhere in this tree, because the prerequisite commit
"crypto: dh - add shared DH public key range check" noted in the patch
commentary is missing.

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
> @@ -241,6 +278,12 @@ static int qat_dh_compute_value(struct kpp_request *=
req)
>  	if (req->src_len > ctx->p_size)
>  		return -EINVAL;
> =20
> +	if (req->src) {
> +		ret =3D qat_dh_peer_pubkey_valid(ctx, req->src, req->src_len, flags);
> +		if (unlikely(ret))
> +			return ret;
> +	}

[Severity: Low]
This isn't a bug, but qat_dh_peer_pubkey_valid() re-checks
src_len > p_size, allocates y, and copies req->src via
scatterwalk_map_and_copy(), even though qat_dh_compute_value() already
produces a contiguous zero-padded ctx->p_size buffer in vaddr right
before dma_map_single():

drivers/crypto/intel/qat/qat_common/qat_asym_algs.c:qat_dh_compute_value() {
	...
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

Validating vaddr there would avoid allocating a second buffer and copying
req->src twice on every request.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125231859.1857=
450-1-rc4d5a@protonmail.com?part=3D1

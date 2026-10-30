Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793382887;
	b=IX/IDlTsrwLT3zEuYK9OHI+N6iquvK5gm0Oyh0cqwdELFA2y1xoGlZqcseBLVqm1JTX8
	 9W+Bbu0wQxCAiD1t8gDI30teVptlLsAHTCRyin0E5kj8Uo5NMHAeaFvd9Bkxbdsb7ho0n
	 ZuFjrFxX+XIFPsQl/upSBOv1ZCjzjkwYwFplhZCt43sts6tKVsSTwldmZAH3w4ARNJswa
	 6vMesweHf/2z1uk0zbaj9uC4PBMDtgYJDKW8lfb3cLMt07Lcj3XpQlIe8I8OU+WN/jfy3
	 u2ehZHU0y12pbv1tL6gImR7IyGUQjpBqGFJbzzWAAPOLLKpINy+rU0+szN8bb+O3TIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793382887;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+wCz1dsNx3ey0wRHzL8BvitqUyMqwYyVY7koKZ45akM=;
	b=D4bB+Bcour0Zlpfd0sLqaLEAm9+o521S6msN3sH/kzqG60cWWlTuBLxvxnsP3NCeOx8E
	 NTdCHkmTlGfSr039XECDz2ncPNknztQ6EekB9ZR3RMh91X3bUkb1u4PXAnj9DkIeH0er6
	 SPjxFXYPeHAAysjrX5D1OFcR8sSjo9MEHHNgduOrCvGcmei9/L56OigDCNgLFk6RqMxlb
	 P1hjRKNeCyN1SxlmJIkjdIqM7XVbNHb3tyYyko272w9phpNIxPr1CuoGYooXZusvbNTtG
	 C0TYdhdOSk49Gv8iYFdPyf20kT86DftJuJFxnp2+JFsh+bRwqVAX+gY3RxhKLMy5cLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBkWoi6h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4CB606A332;
	Fri, 30 Oct 2026 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBkWoi6h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3011F00A15;
	Fri, 30 Oct 2026 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793382886;
	bh=+wCz1dsNx3ey0wRHzL8BvitqUyMqwYyVY7koKZ45akM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TBkWoi6hUwP/osGjjoBImGrc/ya65uAi53POK5o7qrKDi6WQjUvL+5ytK5IyOKr+n
	 AXZLTBGVDXdNqXXualIEFl/pLhiQNfeLX6O6fNJAE1qfV6yCbB0nMy6G3rKvENZuSt
	 LnnXZAVFeb3ZZve8oZ85Kya6LZdJy2iHKHS/5HlEnCcNea6/33ayaSUoKPWgi2wbZk
	 ysGyI50cq6h32rT1K3NRcjJlIgmgCXDHYOr+fpQaoDltalYM1KMG3Z7S34CuC/xriV
	 DgmjB47j7YMsS2kln7tT6AVrMFPbEY/LkEAx3LeiDlLv8rMMDbr4K8y294/sX3siIT
	 DaeeOpau2EVSQ==
Message-ID: <sashiko-outbox-191373@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v27 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pavitrakumar Managutte" <pavitrakumarm@vayavyalabs.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, nazim.khan@vayavyalabs.com
In-Reply-To: <20261030172456.274744-5-pavitrakumarm@vayavyalabs.com>
References: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
 <20261030172456.274744-5-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 17:54:45 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] crypto: spacc - CRYPTO_AHASH_ALG_BLOCK_ONLY inflates statesize pas=
t limit
- [High] crypto: spacc - use-after-free in spacc_hash_exit_tfm() and spacc_=
hash_setkey()
--

commit c650f028323b3118ec1e7adfa8aafa6c190ddd1d
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

crypto: spacc - Add SPAcc Kconfig and Makefile

This commit adds the Kconfig and Makefile for the Synopsys DesignWare SPAcc
driver and hooks them into drivers/crypto/.

[ ... ]

> diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc=
/Makefile
> new file mode 100644
> index 0000000000000..b7125a7797ba0
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_CRYPTO_DEV_SPACC) +=3D snps-spacc.o
> +
> +snps-spacc-y :=3D spacc_hal.o spacc_core.o \
> +spacc_manager.o spacc_interrupt.o spacc_device.o
> +
> +snps-spacc-$(CONFIG_CRYPTO_DEV_SPACC_HASH) +=3D spacc_ahash.o

[Severity: High]
As reported by Sashiko on v26 [1], enabling spacc_ahash.o builds
spacc_hash_template and spacc_register_hash() in
drivers/crypto/dwc-spacc/spacc_ahash.c with both CRYPTO_AHASH_ALG_BLOCK_ONLY
and statesize set to HASH_MAX_STATESIZE:

drivers/crypto/dwc-spacc/spacc_ahash.c:spacc_hash_template:
		.halg.base =3D {
			...
			.cra_flags	=3D CRYPTO_ALG_TYPE_AHASH		|
					  CRYPTO_ALG_ASYNC		|
					  CRYPTO_AHASH_ALG_BLOCK_ONLY
		},

drivers/crypto/dwc-spacc/spacc_ahash.c:spacc_register_hash() {
	...
	salg->alg.hash.base.halg.digestsize =3D salg->mode->hashlen;
	salg->alg.hash.base.halg.statesize =3D HASH_MAX_STATESIZE;

	rc =3D crypto_engine_register_ahash(&salg->alg.hash);
}

When crypto_engine_register_ahash() -> crypto_register_ahash() ->
ahash_prepare_alg() sees CRYPTO_AHASH_ALG_BLOCK_ONLY, it adds
cra_blocksize + 1 to statesize:

crypto/ahash.c:ahash_prepare_alg() {
	...
	if (base->cra_flags & CRYPTO_AHASH_ALG_BLOCK_ONLY) {
		...
		alg->halg.statesize +=3D base->cra_blocksize + 1;
	}
}

This inflates crypto_ahash_statesize(tfm) to HASH_MAX_STATESIZE +
cra_blocksize + 1 for every registered SPAcc hash algorithm.

As a result, any virtual-address request reaching ahash_do_req_chain() (such
as the generic hmac template wrapping an unkeyed SPAcc hash like sha3-256)
hits:

	if (crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE)
		return -ENOSYS;

and fails with -ENOSYS. In addition, callers allocating a buffer of size
HASH_MAX_STATESIZE and calling crypto_ahash_export() will overflow that
buffer by cra_blocksize + 1 bytes when crypto_ahash_export() appends the
block-only partial block buffer at out + ss - plen.

Furthermore, spacc_hash_init(), spacc_hash_update(), spacc_hash_final(), and
spacc_hash_finup() delegate directly to the software fallback fbreq rather
than performing block-only hardware hashing:

drivers/crypto/dwc-spacc/spacc_ahash.c:spacc_hash_update() {
	...
	rc =3D crypto_ahash_import(fbreq, ctx->state_buffer);
	if (!rc)
		rc =3D crypto_ahash_update(fbreq);
	if (!rc)
		rc =3D crypto_ahash_export(fbreq, ctx->state_buffer);

	HASH_REQUEST_ZERO(fbreq);

	return rc;
}

Because spacc_hash_update() consumes trailing bytes into ctx->state_buffer
via the fallback and returns 0 instead of returning the unprocessed tail
length expected by ahash_update_finish(), partial blocks are split between
the core block-only buffer and ctx->state_buffer.

Should CRYPTO_AHASH_ALG_BLOCK_ONLY be dropped from spacc_hash_template?

[Severity: High]
Can spacc_hash_exit_tfm() and spacc_hash_setkey() race with
spacc_crypto_remove() and trigger a use-after-free on priv->spacc?

In drivers/crypto/dwc-spacc/spacc_device.c, spacc_crypto_remove() notes that
sysfs unbind does not wait for existing transforms to be freed. At the end =
of
spacc_crypto_remove(), spacc_remove() frees spacc->ctx and spacc->job via
spacc_fini() before clearing drvdata:

drivers/crypto/dwc-spacc/spacc_device.c:spacc_crypto_remove() {
	...
	spacc_remove(pdev);
	platform_set_drvdata(pdev, NULL);
}

However, in drivers/crypto/dwc-spacc/spacc_ahash.c, neither
spacc_hash_exit_tfm() nor spacc_hash_setkey() -> spacc_hash_commit_key()
checks priv->removing or serializes against spacc_crypto_remove():

drivers/crypto/dwc-spacc/spacc_ahash.c:spacc_hash_exit_tfm() {
	struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(tfm);
	struct spacc_priv *priv =3D dev_get_drvdata(tctx->dev);

	if (priv && tctx->handle >=3D 0)
		spacc_close(&priv->spacc, tctx->handle);
	...
}

drivers/crypto/dwc-spacc/spacc_ahash.c:spacc_hash_setkey() {
	...
	struct spacc_priv *priv =3D dev_get_drvdata(salg->dev);
	...
	if (!spacc_is_mode_keysize_supported(&priv->spacc, salg->mode->id,
				klen, 1)) {
	...
	ret =3D spacc_hash_commit_key(tfm, priv, key, keylen, keybuf, klen);
}

If an existing transform calls crypto_free_ahash() or crypto_ahash_setkey()
concurrently with sysfs unbind and reads priv before
platform_set_drvdata(pdev, NULL), won't spacc_close() or
spacc_is_mode_keysize_supported() access spacc->job, spacc->ctx, and
devm-managed priv after they have been freed?

[1] https://lore.kernel.org/r/20261019162457.1000115-5-pavitrakumarm@vayavy=
alabs.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030172456.2747=
44-1-pavitrakumarm@vayavyalabs.com?part=3D4

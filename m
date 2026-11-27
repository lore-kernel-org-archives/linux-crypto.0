Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782026;
	b=g2pnxkb2sw2ieeab1+TbzWJvFy8diytPOUPaJ2XCp3uQpziQVJ7oUUP73APd+J63bqRZ
	 hJVR4iKy4Ee8F3QFfeScgZNfH9Lw+cEsWep5TfHp2MLdgUdbo/sxWmM7f0q14Vbb+ZmfM
	 mLST+sZ0lKJfl6QNgLOwHuUZYWojwHcKqt/5H6hyHe1X4EqkZUXpnQ4OwZp1Hvger2g0q
	 NW3J3gP6gcVQDAnGYTk4aq6kg+m4b0+lgH67f8z+8ASVh52tlKDdBKOUoFLxN8Y+MMRmn
	 NyYxqjvxnqtllXB8z2/SmPLHkJUNwO3g00ewAaPs0P07oE7ypdSOCaCzQXouRKrAjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782026;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oyRJw5VZuPqgkXCwGVIH59kgww0UgsaVA4mSOquF3cE=;
	b=XJuA1e2qrc65tEdfIkoIJ3RZa2MsQtrFcB6QvvRhU1UqcIubpA3rO9JmQsqq2pLW1wlL
	 5aaNlacxDP0aYfIcOeVOs9ydh8Ckv48r1CGOT+1LGN51HAUG0u1YnUNR3b0CmkppPMxR1
	 GBZtv4Zj1K2cUURO39fjyap7Ey8qHgRES/0bl6MTU6Ua75Z33pSou+i/l/ihB+NMcFIcj
	 skfZt62B8A/wJ99xMwsQjvXP2x/8hD/saKEKZpAh4FCnMUCK0rNd6Cz+gSkdU7018r1x2
	 zIV06wf/Zds2I5LA9JgfZXq817tfBMJaIysqI7V+HBtEs6Lpzwa5Ml5GF2lCMGkYpPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSbtyVzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C9F606A31E;
	Fri, 27 Nov 2026 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSbtyVzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF991F0093A;
	Fri, 27 Nov 2026 12:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782025;
	bh=oyRJw5VZuPqgkXCwGVIH59kgww0UgsaVA4mSOquF3cE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VSbtyVzjY3CSZXP10UPMEXrfrFyc6VdjqN3j5T8us6bKgjjARoZLA74Z+WIk4HOPp
	 jyRmt91bJI1wlqSFh3uCg1WrTLzyWLzmJaFOJUyOcP1oKuIOUA8wqSEfrENIztj9v9
	 zoWJbJafMe86bzDd/lPOiuppfNVHs50PR9IDkYSr1yznFavZNl5FvQEP6czyPBewTO
	 2JHdYDA/qM4NfAcBU7/Q8j0FOwP3Aa7XiMaMcVaslrM+063i2nBbBT6lOvjALMBmYm
	 EDvFt6jiz2GL4qNsfyZ8GUIfn1p3uvashbyRIFz0q8SPNrjKPw7DBUV8XfET9oeC3N
	 i647yEnXHHnPQ==
Message-ID: <sashiko-outbox-237352@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 28/30] crypto: amlogic: fix setup descriptor lengths
 and CBC IV copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>
In-Reply-To: <20261127120103.1532882-29-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-29-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:20:24 +0000
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
- [High] crypto: amlogic: ECB key truncation and DMA OOB in
  meson_setup_keyiv_descs()
- [High] crypto: amlogic: broken multi-batch CBC IV update in
  meson_setup_keyiv_descs()
--

commit 9246a121ba55b6e8c714e81736c007cdd1b7ad72
Author: Jose Nieto <jnieto.alaber@gmail.com>

crypto: amlogic: fix setup descriptor lengths and CBC IV copy

This commit divides the key/IV and SHA state setup descriptor lengths by
setup_desc_cnt and drops the CBC IV copy and DMA sync from
meson_setup_keyiv_descs().

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto=
/amlogic/amlogic-gxl-cipher.c
> index c11ccbaf920dd..10815ffe33135 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> @@ -147,24 +147,13 @@ static void meson_setup_keyiv_descs(struct cipher_c=
tx *ctx)
>  {
>  	struct meson_cipher_req_ctx *rctx =3D skcipher_request_ctx(ctx->areq);
>  	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(ctx->areq);
> -	struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
> -	struct meson_alg_template *algt =3D container_of(alg,
> -		struct meson_alg_template, alg.skcipher.base);
>  	struct meson_cipher_tfm_ctx *op =3D crypto_skcipher_ctx_dma(tfm);
>  	struct meson_dev *mc =3D op->mc;
> -	unsigned int ivsize =3D crypto_skcipher_ivsize(tfm);
> -	unsigned int blockmode =3D algt->blockmode;
>  	int i;
> =20
>  	if (ctx->tloffset)
>  		return;
> =20
> -	if (blockmode =3D=3D DESC_OPMODE_CBC) {
> -		memcpy(op->keyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
> -		dma_sync_single_for_device(mc->dev, ctx->keyiv.addr,
> -					   ctx->keyiv.len, DMA_TO_DEVICE);
> -	}
> -

[Severity: High]
Does removing this memcpy() and dma_sync_single_for_device() break CBC IV
chaining when a request spans multiple descriptor batches?

meson_cipher() copies the initial IV into op->keyiv before the
while (ctx.cryptlen) loop, but when a batch fills MAXDESC descriptors,
meson_kick_hardware() saves the chaining IV for the next batch into
ctx->areq->iv and resets ctx->tloffset to 0:

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_kick_hardware() {
	...
	if (blockmode =3D=3D DESC_OPMODE_CBC &&
	    rctx->op_dir =3D=3D MESON_ENCRYPT) {
		dma_sync_sg_for_cpu(mc->dev, sg_head,
				    sg_nents(sg_head), new_iv_dir);
		memcpy(ctx->areq->iv, new_iv, ivsize);
	}

	ctx->tloffset =3D 0;
	...
}

Without updating and syncing op->keyiv + AES_MAX_KEY_SIZE in
meson_setup_keyiv_descs(), subsequent batches reload the initial IV instead
of the updated ctx->areq->iv, corrupting multi-batch CBC encryption and
decryption.

>  	for (i =3D 0; i < mc->pdata->setup_desc_cnt; i++) {
>  		struct meson_desc *desc =3D
>  			&mc->chanlist[rctx->flow].tl[ctx->tloffset];
> @@ -172,7 +161,9 @@ static void meson_setup_keyiv_descs(struct cipher_ctx=
 *ctx)
> =20
>  		desc->t_src =3D cpu_to_le32(ctx->keyiv.addr + offset);
>  		desc->t_dst =3D cpu_to_le32(offset);
> -		desc->t_status =3D cpu_to_le32(DESC_OWN | DESC_MODE_KEY | ctx->keyiv.l=
en);
> +		desc->t_status =3D cpu_to_le32(DESC_OWN | DESC_MODE_KEY |
> +					     ctx->keyiv.len /
> +					     mc->pdata->setup_desc_cnt);
> =20
>  		ctx->tloffset++;
>  	}

[Severity: High]
Does dividing ctx->keyiv.len by mc->pdata->setup_desc_cnt truncate the AES
key and read out of bounds in ECB mode on GXL and AXG?

In meson_cipher(), ctx.keyiv.len is only extended to 48 bytes
(AES_MAX_KEY_SIZE + ivsize) for DESC_OPMODE_CBC, so for ecb(aes)
ctx.keyiv.len and its DMA mapping are 16 or 32 bytes:

drivers/crypto/amlogic/amlogic-gxl-cipher.c:meson_cipher() {
	...
	ctx.keyiv.len =3D op->keylen;
	if (ctx.keyiv.len =3D=3D AES_KEYSIZE_192)
		ctx.keyiv.len =3D AES_MAX_KEY_SIZE;

	if (algt->blockmode =3D=3D DESC_OPMODE_CBC) {
		memcpy(op->keyiv + AES_MAX_KEY_SIZE, areq->iv, ivsize);
		ctx.keyiv.len =3D AES_MAX_KEY_SIZE + ivsize;
	}

	ctx.keyiv.addr =3D dma_map_single(mc->dev, op->keyiv, ctx.keyiv.len,
					DMA_TO_DEVICE);
	...
}

On GXL and AXG, setup_desc_cnt is 3.  In ECB mode, ctx->keyiv.len / 3
evaluates to 5 bytes (AES-128) or 10 bytes (AES-192/256) per descriptor
instead of 16, while the loop still emits 3 descriptors at offsets 0, 16
and 32, loading a truncated key and performing DMA reads past the mapped
ctx.keyiv.len bytes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D28

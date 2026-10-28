Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793160974;
	b=Evu+ObHr/DqYS62vS7imjxxuH+Fb4CkdFR3Auvjk9wxXzjP+mxk/5Yp9AFS+XHFXwgEr
	 /PVHaAKyZd9ZByUFq9Ne7dYSOmX1JgQyeWnIKNqR6tFBUefCB5t9rwa0tas6vC1XEUNDN
	 zaI3oeIEtzJeku+kh/H5qYK7aZV8728nemWD0pz7FlAdrSpW/x99UV8rUBdsSjsspGAAR
	 UkAP9IrgDbWNv0QShcJkUc/Q2Mlnt/1Zy+lvRK81fdyb3K1O0xKUVCOQDwuxGnsVg26hA
	 rycIc3OOJ0VKASo/Q5c/Qci4w5XrhhWYkBfhMjWxBz2KvbhmT6uWqITWFtRexC6PCrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793160974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VZ2sjRpD/iQJW/ZABHQe0O/IxQ9U74+CpGgCW4YB9rg=;
	b=sDGydhNoXIfdT414N6VzPWFb4s6jVAiPubA226nwcupEdga4KiLYS3dFf9BCR2ZvM2xz
	 6fvtFW3Mcsd2gIC2SXlIGTvjPmw2hUTDOSvttNV7PBYEEzFvN9Dhr5EdBbhNBVYGZh8Qx
	 Hdi4ISRf3WI6+t4aDuEpwPhcognKhAJag8zsfc1D+zXm+dNo3L5WK7nziZCjMgrd+1ViR
	 sfQ303yFtiu0tKUObejczyaMheHERQrOyPILsRcZMvB0b3C57HBrdKsYAucp51ze55smb
	 sVkXam7FEmdaEo8/q6uaXRAdHMj/sar2Kx1Igel+C6DuGv21BDZcjDKjFMxU2kgmIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibVXE1O8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDDA606A31A
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 04:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ibVXE1O8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BDB1F01825;
	Wed, 28 Oct 2026 04:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793160973;
	bh=VZ2sjRpD/iQJW/ZABHQe0O/IxQ9U74+CpGgCW4YB9rg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ibVXE1O8XWzcPC/s6Fpe9cXDPlo7YAVwvx/n3vw2XQK2EgomuXZiYkMD4CyjkMQxT
	 qqyPuHBSc1ueqaLKAr+hjftmuKMUXi5w6eYz8PV6yKX6HargJPDcC8mfTqyef4+5qn
	 t5/q2FV0njcZx0bDX6hINRzOZLiYrb+QfSgmTMm/FBls8/l9vLzMtg3kcF0WESJkFy
	 +5pNh0K4sp2jdgRt1AYEpha45Nel9DJVLWJ03kThdV4Vv3wqYYJcdCehZyZmGpdbv0
	 osOgsq+8Pop+wH2PMEethdUT0lf4zTqkXVda75veII8n8ipXSuQY2gZ4ANYdqEzPQw
	 gKjyjPxruURIQ==
Message-ID: <sashiko-outbox-187467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: ti - dthev2: fix empty-list wild pointer in
 dthe_get_dev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Ximo" <lixicaicai@gmail.com>, "T Pratham" <t-pratham@ti.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, "Wang Haoran" <haoranwangsec@gmail.com>
In-Reply-To: <20261028040319.171479-1-lixicaicai@gmail.com>
References: <20261028040319.171479-1-lixicaicai@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 04:16:12 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] crypto: ti - dthev2: missing NULL check on dthe_get_dev() return v=
alue
--

commit 7858ab938a94a13ed7e28adf576e74952aceb946
Author: Wang Haoran <haoranwangsec@gmail.com>

crypto: ti - dthev2: fix empty-list wild pointer in dthe_get_dev()

This commit changes dthe_get_dev() to use list_first_entry_or_null() when
looking up a device on dthe_dev_list.dev_list and reorders dthe_remove()
to call dthe_unregister_algs() before removing the device from the list.

> diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2=
-common.c
> index ba6cde75d3611..099c0b92368d6 100644
> --- a/drivers/crypto/ti/dthev2-common.c
> +++ b/drivers/crypto/ti/dthev2-common.c
> @@ -39,7 +39,8 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
>  		return ctx->dev_data;
> =20
>  	spin_lock_bh(&dthe_dev_list.lock);
> -	dev_data =3D list_first_entry(&dthe_dev_list.dev_list, struct dthe_data=
, list);
> +	dev_data =3D list_first_entry_or_null(&dthe_dev_list.dev_list,
> +					    struct dthe_data, list);
>  	if (dev_data)
>  		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
>  	spin_unlock_bh(&dthe_dev_list.lock);
> @@ -200,12 +201,12 @@ static void dthe_remove(struct platform_device *pde=
v)
>  {
>  	struct dthe_data *dev_data =3D platform_get_drvdata(pdev);
> =20
> +	dthe_unregister_algs();
> +
>  	spin_lock(&dthe_dev_list.lock);
>  	list_del(&dev_data->list);
>  	spin_unlock(&dthe_dev_list.lock);
> =20
> -	dthe_unregister_algs();

[Severity: High]
Does calling dthe_unregister_algs() before list_del(&dev_data->list) in
dthe_remove() completely close the empty-list window, or can callers in
drivers/crypto/ti/dthev2-aes.c still receive NULL from dthe_get_dev() and
dereference a NULL dev_data pointer?

In the crypto API, crypto_alloc_tfm_node() holds crypto_alg_sem only inside
crypto_find_alg() while looking up the algorithm and taking a module
reference, then releases crypto_alg_sem before calling
crypto_create_tfm_node() -> frontend->init_tfm(tfm).

If dthe_remove() runs concurrently (for example via platform device unbind),
dthe_unregister_algs() -> crypto_unregister_alg() unlinks the algorithms
under crypto_alg_sem without waiting for in-flight crypto_alloc_tfm_node()
callers that already finished crypto_find_alg(), and then executes
list_del(&dev_data->list) to empty dthe_dev_list.dev_list. A similar window
also exists in dthe_probe() if dthe_register_aes_algs() fails partway after
crypto_register_alg() has spawned asynchronous cryptomgr_test kthreads and
the error path removes dev_data from dthe_dev_list.dev_list.

When an in-flight init_tfm callback in drivers/crypto/ti/dthev2-aes.c runs
after the list becomes empty, dthe_get_dev(ctx) now returns NULL to callers
that do not check for NULL:

drivers/crypto/ti/dthev2-aes.c:dthe_cipher_init_tfm() {
	struct dthe_data *dev_data =3D dthe_get_dev(ctx);

	ctx->dev_data =3D dev_data;
	ctx->keylen =3D 0;

	return 0;
}

drivers/crypto/ti/dthev2-aes.c:dthe_cipher_init_tfm_fallback() {
	struct dthe_data *dev_data =3D dthe_get_dev(ctx);
	const char *alg_name =3D crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));

	ctx->dev_data =3D dev_data;
	ctx->keylen =3D 0;

	ctx->skcipher_fb =3D crypto_alloc_sync_skcipher(alg_name, 0,
						      CRYPTO_ALG_NEED_FALLBACK);
	if (IS_ERR(ctx->skcipher_fb)) {
		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
			alg_name);
		...
}

drivers/crypto/ti/dthev2-aes.c:dthe_aead_init_tfm() {
	struct dthe_data *dev_data =3D dthe_get_dev(ctx);

	ctx->dev_data =3D dev_data;

	const char *alg_name =3D crypto_tfm_alg_name(crypto_aead_tfm(tfm));

	ctx->aead_fb =3D crypto_alloc_sync_aead(alg_name, 0,
					      CRYPTO_ALG_NEED_FALLBACK);
	if (IS_ERR(ctx->aead_fb)) {
		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
			alg_name);
		...
}

If fallback allocation fails in dthe_cipher_init_tfm_fallback() or
dthe_aead_init_tfm(), dev_err(dev_data->dev, ...) immediately dereferences
a NULL dev_data pointer. Otherwise, init_tfm succeeds with
ctx->dev_data =3D=3D NULL, and subsequent requests in dthe_aes_crypt() or
dthe_aead_crypt() get NULL from dthe_get_dev(ctx) and dereference
dev_data->engine:

drivers/crypto/ti/dthev2-aes.c:dthe_aes_crypt() {
	struct dthe_data *dev_data =3D dthe_get_dev(ctx);
	...
	engine =3D dev_data->engine;
	return crypto_transfer_skcipher_request_to_engine(engine, req);
}

drivers/crypto/ti/dthev2-aes.c:dthe_aead_crypt() {
	struct dthe_data *dev_data =3D dthe_get_dev(ctx);
	...
	engine =3D dev_data->engine;
	return crypto_transfer_aead_request_to_engine(engine, req);
}

Should the init_tfm callbacks in drivers/crypto/ti/dthev2-aes.c check for
!dev_data and return -ENODEV?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028040319.1714=
79-1-lixicaicai@gmail.com?part=3D1

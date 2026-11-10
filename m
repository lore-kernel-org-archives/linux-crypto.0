Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334735;
	b=zDqvsP2DzLYwsNqrUeet8b6Sr8AhconUl1TiN1EGeD1Qti7hJmbfPumCASuWbIijtFGV
	 Brviia1/cdOeXsWfIVFiEAv1KWhKYRnsbGaxMJNDEXWMheZOZ0GMsB2/nXzRFajTMTq0I
	 Bin1XsKA70r3afvl/tJCeppsNuyhZem6kaHKjhVJ65ExcQW7nVC1sVFF2YcZqabNC3COU
	 YSXwEXGDUbdD0mhbYJC3AtvkcU0VH9cXiDApvDIHQRqH6u4OBCpxLclG2RZzh/pGq5jxO
	 I4ZCJXZlWyt0q5fzcHpgKr7Ux05Qyvx4b/MxWeVCQrMvXp+TlqiZjm3LCeU7QHqZAQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334735;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ti0FFiAc19qMbwUdWnG2Fegu5iHFKeoAF69fwct6oz4=;
	b=ztKS6dQvoyB/jeRiQkOteJCwebjTAW4QN1ExoJe7Cec7ekAz2eZC0GmGVikWCO7Tl2Pl
	 cP3k51oqHqrCL3RzLjiWBwYGNrWW9MLe/hxiRbXnxooAa4UCqg7PE3eSPV8DSyXzdW5Fl
	 cOkFNTcT/IR+RxNeCFu6P4dXbbPuYhvkNnbmr26WiQZm4UX56tpr4QEyv2N9gGD/ITh0k
	 5dU/g+YnzEOQpGFERwpY+zCYF0l9JV44uFvfWfSnhj1AMKtHrWHuZHCY6wokiKB3VRsVb
	 O6QZSQicrzB8zy6cmbTVRR8+ieXzOPDCcLl/PvLVoytAoVPrsgeKpNb01UeZDAbKwCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeruiO8w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEBF606A320;
	Tue, 10 Nov 2026 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeruiO8w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565FC1F0089F;
	Tue, 10 Nov 2026 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794334735;
	bh=ti0FFiAc19qMbwUdWnG2Fegu5iHFKeoAF69fwct6oz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JeruiO8wDEvUtzVDB/HytMdFLSTbVBjy7bsq/3OG7qCNYx+byR+PCDntTHGMzTaY5
	 Y3281yxPfX5y7wm0SNdnYs1QN+syDXWaurpxXcHWYXKgsoifNq2AObISC+moEYRoH2
	 scuzGwHyaeudfKcp8oX8ZXf6KqxJcitl2EmKwc/1yFIuBoXAoNY3rsIEBC9qjxfgEH
	 vtx8xfV0fmquxBXqSq4hrIqk01hHqxtJ1BZxoLKHRLTUi52Nqla6iOcEBY0613BkmM
	 HPajy513ZLd71RiT5fm0DbSJBYwW7C6m/2kagSqkE9Kmndj6BmH8ihs0ZgBX+wPxWY
	 bPqoX78/RpE/w==
Message-ID: <sashiko-outbox-207570@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/5] crypto: cmh - add AES skcipher/aead/cmac
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alex Ousherovitch" <aousherovitch@rambus.com>, "Saravanakrishnan
 Krishnamoorthy" <skrishnamoorthy@rambus.com>, "Joel Wittenauer" <Joel.Wittenauer@cryptography.com>, "Thi
 Nguyen" <thin@rambus.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261110-cmh-b4-a-v8-v8-4-4cea8ebc1d40@rambus.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-4-4cea8ebc1d40@rambus.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 18:18:53 +0000
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
- [Critical] crypto: cmh: stack overflow in ahash_request_zero() via
  missing tfm->fb
- [Medium] crypto: cmh: missing CRYPTO_ALG_ASYNC mask in
  cmh_aes_aead_init_tfm()
--

commit 89559a30a0ea6b4fc4382fe41b13de31385e0958
Author: Alex Ousherovitch <aousherovitch@rambus.com>

crypto: cmh - add AES skcipher/aead/cmac

This commit registers AES skcipher (ECB, CBC, CTR, XTS), AEAD (GCM, CCM),
and ahash (CMAC) algorithms on the CMH AES core, along with the AES core
ABI definitions.

> diff --git a/drivers/crypto/cmh/cmh_aes_aead.c b/drivers/crypto/cmh/cmh_a=
es_aead.c
> new file mode 100644
> index 0000000000000..7edacf38198bf
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_aes_aead.c

[ ... ]

> +static int cmh_aes_aead_init_tfm(struct crypto_aead *tfm)
> +{
> +	struct cmh_aes_aead_tfm_ctx *tctx =3D crypto_aead_ctx(tfm);
> +	const struct cmh_aes_aead_info *info =3D cmh_aes_aead_get_info(tfm);
> +
> +	memset(tctx, 0, sizeof(*tctx));
> +	tctx->authsize =3D info->maxauthsize;
> +
> +	if (info->type =3D=3D CMH_AES_AEAD_CCM) {
> +		struct crypto_aead *fb;
> +
> +		tctx->ccm =3D true;
> +		fb =3D crypto_alloc_aead("ccm(aes)", 0,
> +				       CRYPTO_ALG_NEED_FALLBACK);

[Severity: Medium]
Does this fallback allocation need CRYPTO_ALG_ASYNC in the mask so that
ccm(aes) does not wrap rambus-cmh-ctr-aes?

On architectures where ccm-aes-lib is not registered (such as arm64 and
arm), allocating ccm(aes) instantiates the ccm template via
crypto_ccm_create_common(), which grabs ctr(aes) using the passed mask.
Because cmh_aes_register() has already registered rambus-cmh-ctr-aes at
priority 300, the fallback ends up running CTR on the CMH hardware via
bounce buffers and rejecting requests over 32 MiB with -EINVAL, rather
than using a software implementation with no size limit as documented.

> diff --git a/drivers/crypto/cmh/cmh_aes_cmac.c b/drivers/crypto/cmh/cmh_a=
es_cmac.c
> new file mode 100644
> index 0000000000000..34a7a5ba07baf
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_aes_cmac.c

[ ... ]

> +static int cmh_aes_cmac_init_tfm(struct crypto_ahash *tfm)
> +{
> +	struct cmh_aes_cmac_tfm_ctx *tctx =3D crypto_ahash_ctx(tfm);
> +	struct crypto_ahash *fb;
> +
> +	tctx->key.mode =3D CMH_KEY_NONE;
> +
> +	/*
> +	 * The generic cmac(aes) shash has no export_core, so the crypto
> +	 * core cannot wrap it as crypto_ahash_fb().  Allocate it here
> +	 * instead; masking out CRYPTO_ALG_ASYNC excludes this (async)
> +	 * driver so the allocator picks the generic, synchronous transform,
> +	 * and its request is embedded after the reqctx.
> +	 */
> +	fb =3D crypto_alloc_ahash(crypto_ahash_alg_name(tfm), 0,
> +				CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(fb))
> +		return PTR_ERR(fb);
> +	tctx->fb =3D fb;
> +
> +	crypto_ahash_set_reqsize(tfm,
> +				 sizeof(struct cmh_aes_cmac_reqctx) +
> +				 crypto_tfm_ctx_alignment() +
> +				 sizeof(struct ahash_request) +
> +				 crypto_ahash_reqsize(fb));
> +	crypto_ahash_set_statesize(tfm, crypto_ahash_statesize(fb));
> +	return 0;
> +}

[Severity: Critical]
Can leaving crypto_ahash_tfm(tfm)->fb pointing to the async CMH transform
overflow the kernel stack when a caller uses crypto_hash_digest() or
HASH_FBREQ_ON_STACK()?

Because cmh_aes_cmac_alg sets CRYPTO_ALG_NO_FALLBACK,
crypto_create_tfm_node() leaves tfm->fb pointing to tfm itself, while
cmh_aes_cmac_init_tfm() sets tfm's reqsize to over 800 bytes above
MAX_SYNC_HASH_REQSIZE:

crypto/ahash.c:crypto_hash_digest() {
	HASH_REQUEST_ON_STACK(req, crypto_ahash_fb(tfm));
	int err;

	ahash_request_set_callback(req, 0, NULL, NULL);
	ahash_request_set_virt(req, data, out, len);
	err =3D crypto_ahash_digest(req);

	ahash_request_zero(req);

	return err;
}

HASH_REQUEST_ON_STACK() reserves only sizeof(struct ahash_request) +
MAX_SYNC_HASH_REQSIZE bytes on the stack and binds req to
crypto_ahash_fb(tfm) (still the CMH tfm).  crypto_ahash_digest() then
returns -EAGAIN because an on-stack request is used with an async
transform, and ahash_request_zero() zeroes sizeof(*req) +
crypto_ahash_reqsize(tfm) bytes, writing over 800 bytes past the stack
buffer.

Pointing crypto_ahash_tfm(tfm)->fb at crypto_ahash_tfm(fb) (and restoring
it before freeing fb in cmh_aes_cmac_exit_tfm()) would direct stack
requests to the synchronous fallback transform.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-cmh-b4-a-v=
8-v8-0-4cea8ebc1d40@rambus.com?part=3D4

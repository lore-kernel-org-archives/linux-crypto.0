Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190579;
	b=o2NK/wtu06CB8dstVrGXcJ8oN3lyoJxnWoirHxdJ+EnI+FDacsNx6twKbqZUUvD4JUDL
	 FNIqdYoPrOOphE3kAd4HZyC2SigX7+erM0TPrGrUtG3AimxTNkZy2X93kP2CLcnbI1jWP
	 Zd1mzX+zS9o/icJH5aGrTZNyXiZoYguIKkeT4FGIa4u0yeYwJsWQ936NiSeINaj4o8X1p
	 86fXpSuNGDJFtjExquaZKfhl2BUNzLzfTj7qrBh6qn6E1V/phsUuIB3CEmtrAxon6uwop
	 emlZ9l9cqO3QzIihn+cQ8c13LH9LZhYTjJQxRO2E7a3W47AfmHaIwxnvVJqZ2Hz/ivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190579;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f4v+VzKuF2NTemJjcMRqcdgcEOirJgXR9ibodN5nUtM=;
	b=xqZRj50LaWeoF7MZCJbajgAyC77OPF6JvVFEi43QMP80vXI2/C3KwEYbJbv6JrFU6JDD
	 pFiedifsNQv5znCbLyDYMCW0tkHVK1cZdRKgef25wRfg8vSrVXTw1rPU9NbEMKkqEHKdL
	 azxbS/R4SQ5GHAzN3PyZ0lomtJ9+/Xr2vU2y+/dAzUiVTvE/pr+8zRvJAEB6DeDiEmvZr
	 OxW5QtJn0wj39w6d78/PhNsMFQjdn/dgFzFzw9HyWm6/nd1c97Yl+4HApJezQW4O30kGp
	 4FaE5F/LA5/kPMTzUE3P/h9PrHL2mGQDXy/v1nFKsro9X4RmGec2p10VqIz3hOAKr1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H/tHtu2F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C759B606A320
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H/tHtu2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C211F000CA;
	Fri, 20 Nov 2026 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190579;
	bh=f4v+VzKuF2NTemJjcMRqcdgcEOirJgXR9ibodN5nUtM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H/tHtu2FSxaaNaslDzftMkX6XXS+0LEZvXOg4eiKXv6nKZVLz1gcC4QSw+P5cUH7a
	 0TT9Wg7JBkYGIsR8Mxbhk3BPEyQ0yahkQY9W2vE8UJWtP5FDAGTfggfKE68J6WzH0+
	 3CoXIc7ci16ynDk5enZQlFwWGSKLF09xfGcNmTKWg0bBn8R7rVKjC2rXmnuvJV+LyC
	 Ob8wA05vamladZxgwbewbuF3Mwh85c5A7jQ4tZABgWrhfTTJCjEiFQOdJfLX43HbVv
	 +JLIhaZUjnFc+Je3sDuBH0XA/wzxozbO9F/e0YBa/aU5nYZxPGGRsVKOHdeWfDRO81
	 HjhJTIyOBUMEA==
Message-ID: <sashiko-outbox-225520@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: powerpc/p10-aes-gcm - Fix IPsec stall on bond
 failover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Danny Tsen" <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com, appro@cryptogams.org, mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
In-Reply-To: <20261120150856.7039-1-dtsen@linux.ibm.com>
References: <20261120150856.7039-1-dtsen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:02:58 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Critical] crypto: p10-aes-gcm - unchecked key memcpy overflow in
  p10_aes_gcm_setkey()
- [High] crypto: p10-aes-gcm - missing fallback authsize update in
  set_authsize()
- [High] crypto: p10-aes-gcm - uninitialized fallback subreq in
  p10_aes_gcm_crypt()
- [Medium] crypto: p10-aes-gcm - missing CRYPTO_ALG_ASYNC mask in
  p10_aead_init()
- [Medium] crypto: p10-aes-gcm - missing CRYPTO_GCM select for
  CRYPTO_AES_GCM_P10
--

commit 0ea59836db10f05695eb5711fdb48763c557e6c5
Author: Danny Tsen <dtsen@linux.ibm.com>

crypto: powerpc/p10-aes-gcm - Fix IPsec stall on bond failover

This commit replaces the crypto SIMD wrapper registration for Power10
AES-GCM with direct aead_alg registration and synchronous fallback
transforms for requests that cannot use VSX or have cryptlen < 64.

> diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto=
/aes-gcm-p10-glue.c
> index f3417436d3f79..13352b838432d 100644
> --- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
> +++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
[ ... ]
> @@ -173,6 +177,40 @@ static void finish_tag(struct gcm_ctx *gctx, struct =
Hash_ctx *hash, int len)
>  		hash->Htable[i] ^=3D gctx->ivtag[i];
>  }
> =20
> +static int p10_aead_init(struct crypto_aead *tfm)
> +{
> +	struct p10_aes_gcm_ctx *ctx =3D crypto_aead_ctx(tfm);
> +
> +	ctx->fallback_tfm =3D crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_NEED_=
FALLBACK);
> +	if (IS_ERR(ctx->fallback_tfm))
> +		return PTR_ERR(ctx->fallback_tfm);
> +
> +	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
> +				crypto_aead_reqsize(ctx->fallback_tfm));
> +	return 0;
> +}
> +
> +static int rfc4106_init(struct crypto_aead *tfm)
> +{
> +	struct p10_aes_gcm_ctx *ctx =3D crypto_aead_ctx(tfm);
> +
> +	ctx->fallback_tfm =3D crypto_alloc_aead("rfc4106(gcm(aes))", 0, CRYPTO_=
ALG_NEED_FALLBACK);
> +	if (IS_ERR(ctx->fallback_tfm))
> +		return PTR_ERR(ctx->fallback_tfm);
> +
> +	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
> +				crypto_aead_reqsize(ctx->fallback_tfm));
> +	return 0;
> +}

[Severity: Medium]
Should p10_aead_init() and rfc4106_init() pass
CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC as the mask to
crypto_alloc_aead()?

gcm_aes_algs[] registers synchronous AEAD algorithms without
CRYPTO_ALG_ASYNC, so if an asynchronous implementation with higher
priority than the generic fallback is bound to ctx->fallback_tfm, it can
return -EINPROGRESS or -EBUSY to callers expecting synchronous completion.

[Severity: Medium]
Should CRYPTO_AES_GCM_P10 in arch/powerpc/crypto/Kconfig also select
CRYPTO_GCM and CRYPTO_AES now that p10_aead_init() and rfc4106_init()
unconditionally allocate fallback gcm(aes) and rfc4106(gcm(aes))
transforms?

On powerpc, the library-based gcm-aes-lib AEAD registrations in
crypto/aes.c are disabled under !CONFIG_PPC, so transform initialization
fails with -ENOENT when CONFIG_CRYPTO_GCM or CONFIG_CRYPTO_AES is not
enabled.

> +
> +static void p10_aead_exit(struct crypto_aead *tfm)
> +{
> +	struct p10_aes_gcm_ctx *ctx =3D crypto_aead_ctx(tfm);
> +
> +	if (ctx->fallback_tfm)
> +		crypto_free_aead(ctx->fallback_tfm);
> +}
> +
>  static int set_authsize(struct crypto_aead *tfm, unsigned int authsize)
>  {
>  	switch (authsize) {
> @@ -194,13 +232,34 @@ static int set_authsize(struct crypto_aead *tfm, un=
signed int authsize)
>  static int p10_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
>  			      unsigned int keylen)
>  {
> -	struct crypto_tfm *tfm =3D crypto_aead_tfm(aead);
> -	struct p10_aes_gcm_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +	struct p10_aes_gcm_ctx *ctx =3D crypto_aead_ctx(aead);
> +	int ret =3D 0;
> +
> +	ctx->simd_set_key =3D 0;
> +	if (crypto_simd_usable()) {
> +		vsx_begin();
> +		ret =3D aes_p10_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
> +		vsx_end();
> +		ctx->simd_set_key =3D 1;
> +		if (ret)
> +			ctx->simd_set_key =3D 0;
> +	}
> +
> +	ctx->keylen =3D keylen;
> +	memcpy(ctx->key, key, keylen);
> +
> +	return ret ? -EINVAL : 0;
> +}
> +
> +static int gcm_setkey(struct crypto_aead *aead, const u8 *key,
> +		      unsigned int keylen)
> +{
> +	struct p10_aes_gcm_ctx *ctx =3D crypto_aead_ctx(aead);
>  	int ret;
> =20
> -	vsx_begin();
> -	ret =3D aes_p10_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
> -	vsx_end();
> +	ret =3D p10_aes_gcm_setkey(aead, key, keylen);
> +
> +	ret |=3D crypto_aead_setkey(ctx->fallback_tfm, key, keylen);
> =20
>  	return ret ? -EINVAL : 0;
>  }

[Severity: Critical]
Can memcpy(ctx->key, key, keylen) in p10_aes_gcm_setkey() overflow
ctx->key[AES_MAX_KEYLENGTH]?

gcm_setkey() calls p10_aes_gcm_setkey() before crypto_aead_setkey()
validates keylen, and p10_aes_gcm_setkey() copies keylen bytes even when
aes_p10_set_encrypt_key() fails or is skipped.  An unprivileged user can
pass keylen > 240 via setsockopt(ALG_SET_KEY) on an AF_ALG socket bound to
gcm(aes) and write past ctx->key in struct p10_aes_gcm_ctx.  ctx->key and
ctx->keylen are also never read anywhere in this driver and can be dropped.

> @@ -208,8 +267,8 @@ static int p10_aes_gcm_setkey(struct crypto_aead *aea=
d, const u8 *key,
>  static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
>  			     int assoclen, int enc)
>  {
> -	struct crypto_tfm *tfm =3D req->base.tfm;
> -	struct p10_aes_gcm_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +	struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> +	struct p10_aes_gcm_ctx *ctx =3D crypto_aead_ctx(tfm);
>  	u8 databuf[sizeof(struct gcm_ctx) + PPC_ALIGN];
>  	struct gcm_ctx *gctx =3D PTR_ALIGN((void *)databuf, PPC_ALIGN);
>  	u8 hashbuf[sizeof(struct Hash_ctx) + PPC_ALIGN];
> @@ -220,12 +279,24 @@ static int p10_aes_gcm_crypt(struct aead_request *r=
eq, u8 *riv,
>  	unsigned int cryptlen =3D req->cryptlen;
>  	unsigned char ivbuf[AES_BLOCK_SIZE+PPC_ALIGN];
>  	unsigned char *iv =3D PTR_ALIGN((void *)ivbuf, PPC_ALIGN);
> -	int ret;
> -	unsigned long auth_tag_len =3D crypto_aead_authsize(__crypto_aead_cast(=
tfm));
> +	int ret =3D 0;
> +	unsigned long auth_tag_len =3D crypto_aead_authsize(tfm);
>  	u8 otag[16];
>  	int total_processed =3D 0;
>  	int nbytes;
> =20
> +	if (!crypto_simd_usable() || !ctx->simd_set_key || req->cryptlen < 64) {
> +		struct aead_request *subreq =3D aead_request_ctx(req);
> +
> +		aead_request_set_tfm(subreq, ctx->fallback_tfm);
> +		aead_request_set_crypt(subreq, req->src, req->dst,
> +					req->cryptlen, req->iv);
> +		aead_request_set_ad(subreq, req->assoclen);
> +
> +		return enc ? crypto_aead_encrypt(subreq) :
> +			     crypto_aead_decrypt(subreq);
> +	}

[Severity: High]
Does the fallback path use the wrong tag size when authsize is configured
to less than 16 bytes?

Neither set_authsize() nor rfc4106_setauthsize() calls
crypto_aead_setauthsize(ctx->fallback_tfm, authsize), so
ctx->fallback_tfm->authsize stays at 16.  When a transform configured with
a shorter tag (such as 8 or 12 bytes) takes the fallback path, encryption
writes a 16-byte tag past the caller's tag buffer (or walks off the end of
req->dst) and decryption fails with -EINVAL or -EBADMSG.

[Severity: High]
Does the fallback path leave subreq->base.flags, subreq->base.complete,
and subreq->base.data uninitialized by not calling
aead_request_set_callback()?

crypto_gcm_encrypt() and crypto_gcm_decrypt() read aead_request_flags(req)
and forward it to the underlying skcipher request.  When
p10_aes_gcm_crypt() falls back in softirq context (or during crypto
self-tests, where testmgr poisons the request context with 0xfe) and
CRYPTO_TFM_REQ_MAY_SLEEP happens to be set in subreq->base.flags, the
skcipher walk can perform GFP_KERNEL allocations and call cond_resched() in
atomic context.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120150856.7039=
-1-dtsen@linux.ibm.com?part=3D1

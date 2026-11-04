Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793772274;
	b=1YroqyAg8iZneGrm03aJT/eh4/fnwSD9+T8wpQ0NzB5n46hJkEoOth7+UeI2/o1iI1gi
	 oe0zn1ECAR7RGk3PK5788R3NN3QUu6WXYWb7XUk+5d5SzW1jgaaD8sZUbK+jEQZ9gzbwf
	 pDkZKUbSUv2vbP/z7fywSnE3rph33t9YQC30oVRNs056dF4rrk9Fnc6T/rloHaO2IXPnD
	 OkOz6ALesIbCrpJFQsgdGuCRWoUnLO/e9Ub7877wItnrUM2oSO8xGilDGBRJnsSNvDr7A
	 KTZx7GHo6nLpu5u9bxcVtX1qudoMwOumjgHylRyYEl4vkcioOZvqDRe0CnM19jBkxoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793772274;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Lj5+rtTxMqYjZGX+QzhQPPskI/tF8SRIiRrZpB/Nv8g=;
	b=g2bRpTT9MFcfpd8eLfR3W66z9nyMnjK1vg5LiN61UmQ/u81D5kjFCBxY1/lc0jhfdIsd
	 e7G02zj3DgHq3kDpgKF6V3TiHBu8sUbHr9ZTC8MEgJQuF45XshZpxx3FzYl4J8jntrk41
	 j0JG5XTTA90hgV54AsgFTyN+K9KkLFAB5yHhaaO0LiPxJUVO5jbh9Bnp+TrlUjDsGxyBn
	 9SrEyPSUIWeKoVO2SncWs03xWOF/cXxS7sR4NkEOYjkHc+nlKC714w+HHyu63Rnp9L4Fb
	 2ZdLd+qXZIz6e8xCvd15RtBLxMvTx36BGxqgT4UStYjIfwUnWpM1JJH1KgEUQrS3k1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="J/vbi7hq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066B606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 06:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J/vbi7hq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142501F000C1;
	Wed,  4 Nov 2026 06:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793772273;
	bh=Lj5+rtTxMqYjZGX+QzhQPPskI/tF8SRIiRrZpB/Nv8g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J/vbi7hq/Bc4hqRBr0gbgvxOuh+smxcIs25c37W3KavfbX52o/OiYl5Gxqa9UfbEi
	 aVJUD+HS0nEyn8ka1CD6lUp3kP/4pax/XcomZU9dtm/qFU+33uD4hDEpeKDSIgQdGi
	 MdXEtXOlAX+YIacggT+S5riVnz40HsrmarOrq9MxFuUi5tRYLiA64CnBBpL0lal0n7
	 9FXMawmGXBl20GRUwBUndds9ObxhCGCo/Cemy3aTIJNpnY76Sk5HZYan8XJrkHdz6A
	 kpIW7hsEOo93t+QghFEXYiMxyU26fDBtsc4okbVsztRv2QNFhLjj9KUxIEpLFpA5nI
	 XnHZ9Zm2WX5EA==
Message-ID: <sashiko-outbox-196724@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 28/30] crypto: sa2ul - route requests through
 crypto_engine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manorit Chawdhry" <m-chawdhry@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>, "Colin Ian
 King" <colin.i.king@gmail.com>
Cc: "Andrew Davis" <afd@ti.com>, "Pratham T" <t-pratham@ti.com>, "Kamlesh
 Gurudasani" <kamlesh@ti.com>, "Udit Kumar" <u-kumar1@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-28-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
 <20261104-b4-upstream-sa2ul-cleanup-v2-28-15ab90b3f9c2@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:04:32 +0000
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
- [Low] crypto: sa2ul: unused-but-set variable enc_size in sa_aead_run()
--

commit f24f2777678674102188bb8e0c6e2374169ce53e
Author: Manorit Chawdhry <m-chawdhry@ti.com>

crypto: sa2ul - route requests through crypto_engine

This commit routes skcipher, ahash, and AEAD requests in the SA2UL driver
through crypto_engine so that request setup and submission run in a
sleepable context.

> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 19caaa41ba038..5716b44afaebf 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c

[ ... ]

> @@ -1800,12 +1925,14 @@ static int sa_aead_cbc_sha256_setkey(struct crypt=
o_aead *authenc,
>  	return sa_aead_setkey(authenc, key, keylen, &ad);
>  }
> =20
> -static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
> +static int sa_aead_run(struct aead_request *req, int enc)
>  {
>  	struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
>  	struct sa_tfm_ctx *ctx =3D crypto_aead_ctx(tfm);
> -	struct sa_req sa_req =3D { 0 };
> +	struct sa_aead_req_ctx *rctx =3D aead_request_ctx(req);
>  	size_t auth_size, enc_size;
> +	unsigned long flags;
> +	int ret;
> =20
>  	enc_size =3D req->cryptlen;
>  	auth_size =3D req->assoclen + req->cryptlen;
> @@ -1833,271 +1960,330 @@ static int sa_aead_run(struct aead_request *req=
, u8 *iv, int enc)
>  		return ret;
>  	}
> =20
> +	rctx->enc =3D enc;
> +
> +	spin_lock_irqsave(&ctx->dev_data->request_lock, flags);
> +	ret =3D ctx->dev_data->stopping ? -ESHUTDOWN :
> +		crypto_transfer_aead_request_to_engine(ctx->dev_data->engine, req);
> +	spin_unlock_irqrestore(&ctx->dev_data->request_lock, flags);
> +	return ret;
> +}
> +
> +static int sa_aead_do_one_req(struct crypto_engine *engine, void *areq)
> +{
> +	struct aead_request *req =3D container_of(areq, struct aead_request, ba=
se);
> +	struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> +	struct sa_tfm_ctx *ctx =3D crypto_aead_ctx(tfm);
> +	struct sa_aead_req_ctx *rctx =3D aead_request_ctx(req);
> +	struct sa_req sa_req =3D { 0 };
> +	size_t auth_size, enc_size;
> +
> +	enc_size =3D req->cryptlen;
> +	auth_size =3D req->assoclen + req->cryptlen;
> +
> +	if (!rctx->enc) {
> +		enc_size -=3D crypto_aead_authsize(tfm);
> +		auth_size -=3D crypto_aead_authsize(tfm);
> +	}
> +
>  	sa_req.enc_offset =3D req->assoclen;
>  	sa_req.enc_size =3D enc_size;

[Severity: Low]
Now that the struct sa_req setup has been moved to sa_aead_do_one_req(),
enc_size in sa_aead_run() is still assigned and decremented when !enc:

	enc_size =3D req->cryptlen;
	auth_size =3D req->assoclen + req->cryptlen;

	if (!enc) {
		enc_size -=3D crypto_aead_authsize(tfm);
		auth_size -=3D crypto_aead_authsize(tfm);
	}

but it is never read anywhere in sa_aead_run(). Does this trigger an
-Wunused-but-set-variable warning when building drivers/crypto/sa2ul.o
with W=3D1? Should enc_size be removed from sa_aead_run()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-b4-upstrea=
m-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com?part=3D28

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036308;
	b=5IVNizmjYMUFqizFS599lgxxkTw9aRbyZSnJ6W8b/EZts9Xx6cUrijJwnsAWEhUAXOI4
	 vfPjccwCGOge5DhtLDfzOS57EYdh+3ERWZu9elF3fh6ckZUtOEGodPxGNAtI73ISWNKta
	 OaNRngxOMCafmuwzMfrDgLQ5jF27UpfIAYdIFTNdKaG09ja9peSuUb0UGVHUklJLFjbwv
	 2I7nO3Nlboy/4BX97wtx4rLbG51tC6/p67UtLDOe2yyji0HHxa3Ow5+dDPiiwoZ275Bwn
	 AprH1+ZLuTNVJqFiRVej0bx7R0DN2h5b4Q9RKZtQs+KqCSv/2abJ+iqxrQYpCVPvLZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036308;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TgN9ogDRRfRK2oexKDdbAOVIB3kCwunMAnWHxeIq0w0=;
	b=QAiZ06Q/X1hf1e0v4aB03KGlqO/jrA8N7KLX1fRFLnYWGEpntIdgODa1y3ItPWytvK7k
	 Uv1MWvNSnUvNWfSl9+IxmcKdC3CQcRKRF7n73yPZ/RS5blgYSctAinJ3e35Ianyvmwk6j
	 l9J9hOBeyLOY9C3sQnArjX5LIfy5AU441dYFLYsUg0owgT0vDBD5p/+diIyPHzlY2V/Hn
	 7H/mSJcXqqDWMmp9FS6eo1QJsVK4veEAN7r2laqKfqkCQh/NO43l+PpmDSM4Q3lGmat/d
	 R7p+sjXjsyV7qpaPljZJeilwSs5vIU0ftTtLhqoUnweJ15L7m4/mDAnkd2N8X+1guFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJVUYjQk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3CD606A330
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 07:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJVUYjQk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF62A1F008A1;
	Sat,  7 Nov 2026 07:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036307;
	bh=TgN9ogDRRfRK2oexKDdbAOVIB3kCwunMAnWHxeIq0w0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DJVUYjQkXVy8QrSbj0lQ/02xBLylp9eHAUe4LuTBjg94FTrisAs7fomyvtqGz2m/B
	 5yUTsmXO7uO+imVJN35EnBt1mlexyH1oMHf0S2Mzyn1FWUol0daV63rup2cACFVTo2
	 MmnXEEpwN65LTKg8BrvyC5wFsr485uXyt79SaPYVlIlXqulm3DdQIMhBHg8tYNeL2N
	 whR8e0pudEp6C54X6dGAcc6aINtFA6WI1D1zyF9mrmPRRyvk2o2BFcm2go1aLbIGnf
	 YEk0ZzuF6rDt1fflPiiSVyBBQO/ZHfrU9HgCeMfP2b3Oy02AAdkpT+Y2jVwpb+HBr2
	 x/cuso6kfG8Rw==
Message-ID: <sashiko-outbox-202710@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-5-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-5-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:06 +0000
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
- [Medium] crypto: acomp: batch_size gated on acomp_is_async() instead
  of REQ_SEG
--

commit 2fa95d403dcc5d6c7b702698b0e306a5d643d3b3
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add API to get a compression algorithm's batch-size.

This commit adds a batch_size field to struct acomp_alg and introduces
crypto_acomp_batch_size() to query the maximum batch size supported by an
acomp transform.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index ac4dc52668b89..df9e42f519c35 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
>  }
>  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> =20
> +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> +{
> +	if (acomp_is_async(tfm) &&
> +	    (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_acomp_ty=
pe)) {
> +		struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> +
> +		if (alg && alg->batch_size > 1)
> +			return alg->batch_size;
> +	}
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);

[Severity: Medium]
Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) (or
have crypto_register_acomp() enforce CRYPTO_ALG_REQ_SEG when batch_size
> 1) instead of gating on acomp_is_async(tfm)?

crypto_acomp_compress() dispatches segmented requests based on
crypto_acomp_req_seg(tfm):

crypto/acompress.c:crypto_acomp_compress() {
    ...
	if (req->unit_size && acomp_request_issg(req)) {
		if (!crypto_acomp_req_seg(tfm))
			return acomp_do_req_chain(req, true);

		return tfm->compress(req);
	}
    ...
}

If an asynchronous acomp_alg sets batch_size > 1 without setting
CRYPTO_ALG_REQ_SEG in cra_flags, crypto_acomp_batch_size() returns
alg->batch_size, but crypto_acomp_compress() routes batched requests
(req->slen > req->unit_size) to acomp_do_req_chain(), which fails with
-ENOSYS.  Conversely, requiring acomp_is_async(tfm) forces
crypto_acomp_batch_size() to return 1 for synchronous acomp_alg
transforms even when they set batch_size > 1 and CRYPTO_ALG_REQ_SEG.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D4

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795234805;
	b=mZA/FZaHXDkClazsLQeiN4lWngSRD6KVSkvdlFK9EKuIQ8X260Qt/3NCbuBdJDLmcaVK
	 9kNUNZuuex6DqHsMXJEWwyg4Rdfk9/ds4CpEP1Xq+ftOjkATt5MPFJgm4pozCsCLQvxkP
	 AfXIqCBQN/8TUt8Jol8K/32TphlRCkwHUbvdmvpyK0P2kJ7zaKjy2P2jfsTxaWHjjnC3P
	 iDOPGOFy/cyT3RhWm4b1JYKGa4QlMkcvmX/cl444dTgGXdqgwB0/SHPMHPut6xJr/NyHR
	 CAjniQkOnoUeOi+R75xHW/YKQyBN3u4ypy+ZVKPMyp0PNw6fTw0GCyGUlJ0xRyGAhzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795234805;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1AnGr17n7QBlqJTgR0L/2DWD4IMKoGtf1+NZyW5LFIg=;
	b=kxDZ8lQaQprFz0mnP45G7FdMR2e66BUOp80m4IZ4D3u7zNjtWy5VzgBT+/uz5QjQTN/e
	 G/dYovtrYHtAE9923GEgiejJUcXU3/qc8Ur0m20CxfgF15IhGrpE0XqRnT15Eyal9cYim
	 95ujNg1R5vWweabEPdotrlnNLj6UtVy8U19+EdHl1WHW/gXO6cM3Lnph0LwdUulQDwmaD
	 0wKcpJgcGJhotJid92qnsrQ6fVhmM244+CnpO2PRk9iHwx4jV8vDdqP11broG4W9kLOIf
	 vZinaxoblDIlk/V6073qSvoswgHNWrlPOvl9CY/U/VoAdIGEnrqsg1lGPAwhbdLVqfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6myZ4Q0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516F8606A6B0
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 04:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6myZ4Q0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA41F000C6;
	Sat, 21 Nov 2026 04:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795234804;
	bh=1AnGr17n7QBlqJTgR0L/2DWD4IMKoGtf1+NZyW5LFIg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l6myZ4Q0DB+5S1slDpMuSwj+aBJpNMW6/Js8aMwBVS7+OrzbjxL9drtdk/O1+C20E
	 0rQoUwn5jXHlhJmKWvHPGOmzc5ZlvSvCzDJsK9SsR2q+f8ZDSZANxcFjDj0vv2oGCL
	 iHT9g9NP+s9UHbe9NvEirOr0CIQwEQPWrExpAF9Zf70YIZQ8fFkD0VXNdLo8ReUtxa
	 7TbBUNscblAGuQ7O1M2ax+vyq006PaMEGpPJ3IgSO7cRYLt9ZIud1K+sVEP2rB/xXQ
	 GNCiN91dT6i3/Hty/hh6+4rxhDopgFB9t1kkUhs5EgoXa//EORdR8ic9kMiAfV5Isy
	 qteQPQbAqAO4w==
Message-ID: <sashiko-outbox-226634@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261120041906.5785-5-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-5-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 04:20:03 +0000
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
- [Medium] crypto: acomp: crypto_acomp_batch_size() checks async instead
  of req_seg
--

commit 4f8164105102abaa98a8641d32dd35c9cb223ee0
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add API to get a compression algorithm's batch-size.

This commit adds a batch_size field to struct acomp_alg and introduces
crypto_acomp_batch_size() so callers can query the maximum batch size suppo=
rted
by an acomp algorithm.

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
Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) instead of
acomp_is_async(tfm)?

crypto_acomp_compress() only dispatches segmented requests (where
req->unit_size is set) to tfm->compress(req) when crypto_acomp_req_seg(tfm)=
 is
true, and otherwise sends them to acomp_do_req_chain(), which rejects
multi-segment requests (req->slen > req->unit_size) with -ENOSYS:

crypto/acompress.c:crypto_acomp_compress() {
    ...
	if (req->unit_size && acomp_request_issg(req)) {
		if (!crypto_acomp_req_seg(tfm))
			return acomp_do_req_chain(req, true);

		return tfm->compress(req);
	}
    ...
}

If an asynchronous acomp_alg sets batch_size > 1 without CRYPTO_ALG_REQ_SEG,
crypto_acomp_batch_size() returns alg->batch_size and callers such as zswap
will submit multi-unit requests that fail with -ENOSYS.  Conversely, because
base.cra_type =3D=3D &crypto_acomp_type already distinguishes struct acomp_=
alg from
struct scomp_alg, requiring acomp_is_async(tfm) forces
crypto_acomp_batch_size() to return 1 for a synchronous acomp_alg even when=
 it
sets CRYPTO_ALG_REQ_SEG and batch_size > 1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.5785=
-1-kanchanapsridhar2026@gmail.com?part=3D4

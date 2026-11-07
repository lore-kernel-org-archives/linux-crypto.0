Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036307;
	b=TAQS6M20vDDwznI+aDnuKsS57zC05P/yxw1N4sxTLaiqyerdXeoC5hSCNY5/TKo6Evlh
	 yoYZVFgasrGVCgCy9aTA9WTARt9+LnL+0PszXZlhZBgifQUDZAGCAv/lF3Dsf0z6LmDyq
	 5wRNtjK3a5hd9ETaZTFFnGUrvYaqIsK0ALuOaJDjCzhtyyMN5/gvMMY6Uu6HOR/1uIo8s
	 OAm3PfkrjXUXx8mOgsjpkOmU43pqg67umzuE7ksF+Xw7lM7Cbpb10/aSp/8NtqEkV0k5L
	 /M3bksPA6M7w5+7Nfx68CCBMa+Wj6MTqMRNSxf1IU2+6i3v6N8zZF0tpcP4RsXu039g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036307;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sRnoEnJS6lgMf2aidbtQUnxmoBvYWDnbbxpzbj70vYw=;
	b=JIVPTpIcdGJiHDb+ly/Kl6GQoYdGXK43iyVercnZ/KnRMtQQ33DVJ5GQVmHEFqJDTfWY
	 ilkyIdvwWOT1gwKXi9lWUrsVaGbAxO5jEnUEVsVBiEKyf6fgfzE///OEr/Ik9bGnrImej
	 J0SpoPp47UI7jRiAkHST/lsvH0C0chXpbKCWZAD2ytiPxW2LDc/MkNP5wHuNyytYh6KQP
	 OOP6TTM2zKkDy+cNLW7g3FoybtDGrtnNkrAxOXZbxRxZb/6f74pvxrb8cOsdM13RE/Bsg
	 rHIDiR6LYhELFaWmLuxjBwVuxSVfbdwaChZTW/0+BkSwWZxGDdt+Rs3iTfxub5AoQ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mxRiTpft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA677606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 07:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mxRiTpft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF881F0089F;
	Sat,  7 Nov 2026 07:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036306;
	bh=sRnoEnJS6lgMf2aidbtQUnxmoBvYWDnbbxpzbj70vYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mxRiTpftuY+2Qfqw5gmB982A/13H8/92gVHVpuRdPbZNh1vA/nlUN3fNzgZN6XmWZ
	 /kpCA7kVewi0ASrYzwiWFwwHGmlheLm8bDXrK9ImIip83L8mcoORUuGQ5vAnndvLhU
	 hYm1tQPLA0frelU6Tj2kAfssd10C0Cvq/8Dp+ESsyvoVbip2HbPRbVXS9GQ+n0bhEK
	 vK6SgGQPRGlbUEB0mpEjuxmaURkDHnI+jvUBruVHyaobL66/sjFjC7X20GboKKwyTA
	 soZdpeHDL2LnCa7PwMQo+a8eUKC4ISiJ1TBmU1Ug91aoQ1RG6uHtC8yURNbEgTZO8U
	 cYgydu+i0W6QA==
Message-ID: <sashiko-outbox-202709@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation
 wrapper.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:05 +0000
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
- [Medium] crypto: acomp - missing non-zero unit_size check in
  crypto_acomp_compress()
- [Medium] crypto: acomp - union type confusion in
  acomp_reqchain_finish() on virt dst
--

commit c2a605231cabd5e0e15d6d778b3943a2c118d756
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add trivial segmentation wrapper.

This commit adds a single-segment compression wrapper for algorithms that do
not natively support segmentation, returning the compressed length or error
in req->dst->length when req->unit_size is set.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index c8b4b8589769e..ac4dc52668b89 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
[ ... ]
> @@ -242,6 +246,10 @@ static int acomp_reqchain_finish(struct acomp_req *r=
eq, int err)
>  {
>  	acomp_reqchain_virt(req);
>  	acomp_restore_req(req);
> +
> +	if (req->unit_size)
> +		req->dst->length =3D unlikely(err) ? err : req->dlen;
> +
>  	return err;
>  }
> =20
> @@ -266,10 +274,13 @@ static int acomp_do_req_chain(struct acomp_req *req=
, bool comp)
>  {
>  	int err;
> =20
> +	if (unlikely(req->unit_size && req->slen > req->unit_size))
> +		return -ENOSYS;

[Severity: Medium]
Can acomp_reqchain_finish() corrupt the destination buffer when a request
with a non-zero req->unit_size uses virtual addresses?

In struct acomp_req, dst and dvirt share an anonymous union.  When
acomp_do_req_chain() handles a virtual-address request
(CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u8 *
buffer pointer into req->dvirt before acomp_restore_req() restores
req->unit_size.  Writing to req->dst->length then treats req->dvirt as a
struct scatterlist * and overwrites 4 bytes inside the caller's output
buffer.

In addition, acomp_do_req_chain() is called for decompression (comp =3D=3D =
false),
so a decompression request with req->unit_size set will also hit the
compression-only req->slen > req->unit_size check and write to
req->dst->length.

>  	acomp_save_req(req, acomp_reqchain_done);
> =20
>  	err =3D acomp_do_one_req(req, comp);
> -	if (err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS)
> +	if (unlikely(err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS))
>  		return err;
> =20
>  	return acomp_reqchain_finish(req, err);
> @@ -279,10 +290,27 @@ int crypto_acomp_compress(struct acomp_req *req)
>  {
>  	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> =20
> +	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req)=
 &&
> +		    !crypto_acomp_req_seg(tfm) && !acomp_is_async(tfm))) {
> +		int err =3D tfm->compress(req);
> +
> +		req->dst->length =3D unlikely(err) ? err : req->dlen;
> +		return err;
> +	}

[Severity: Medium]
Should this fast-path check also verify that req->unit_size is non-zero?

Callers that do not use segmentation leave req->unit_size at 0.  If such a
caller submits a scatterlist request with req->slen =3D=3D 0 on a synchrono=
us
non-segmented transform, req->unit_size =3D=3D req->slen is true, so
crypto_acomp_compress() enters the segmentation path and writes the negative
error from tfm->compress(req) into req->dst->length, corrupting the caller's
scatterlist or causing a NULL pointer dereference if req->dst is NULL (which
can also happen when req->unit_size is non-zero and req->dst is NULL here or
in acomp_reqchain_finish()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D3

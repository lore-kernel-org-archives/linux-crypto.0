Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793243161;
	b=CPFlW2mcGezUg29eqUlPNwljLK60oMDGiTRipYOC+vFcGQ8+1pUuIemeW3pHvPdOEFJ1
	 BnIiw4bk2p6ubnFb6Y813sLAXnbJVU+rbWSJD1vCU1oCyP27VaXnPaOiWRHpcEgRBiMHb
	 K46mXC8KjO5+IGk39GGuLGcPqL79OkspESV/wyu3f52rMpJ/cLjDw7cuENOHiDKvkuZKl
	 xCWto9CTVIx9/1S/zUdHK+NmhccPWXE+wo60sbK4pGrT139Bh8Zfr1nzJz4234SXTHj/c
	 hPxltF7yTYPmXWkKG6y9VvBzcymP5fZLEk7p9nC9NUX0IV9GqLoklM5dN0pW7g27QBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793243161;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eBnn/OUg7PxXvo8p3nJ/SroKfFD1H0Hr92Nww3NdOjM=;
	b=IlgdSRZ470NIlOUxKcLGJmnDavR/YEgKgls+rHZ88VCKuEQjV3Q0UbOQa0PFdDVGRPQc
	 5FtXihPjQkX9OAql0xBejAYycBqruSS3TIYyM0CdbjcfYZ0mbjrzMoL8VqxmQa0iaFy3c
	 bH7Kymhwjd98+kQTBxrQ4GvRcgE5TfmfgUP6mTd3fasdYVXqo9H5AUZbPD7zBPErLHnkL
	 3HTr0bimY8OGrWjeF64mfE8c6165ibcf0Mo92LKLffkwvOaJhc7VKKVILI5bDxoYTpoxS
	 yOj+ouQn2m/PHgAWgvFLEhfefQARGVfYLDjpoas+dmXkKmC9JsS6U0i4aXsd+Q5CkdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1v3ooI7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA8606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 03:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1v3ooI7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8141F01825;
	Thu, 29 Oct 2026 03:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243160;
	bh=eBnn/OUg7PxXvo8p3nJ/SroKfFD1H0Hr92Nww3NdOjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B1v3ooI7lpqk6Men20s5ikVdhaQOBtMk3DcYDpo1whk+KkTP3E6j+lRTgzxXS2eAC
	 k0WMhkatNRdifPO2fA8vfanB4te8HhYIK2SkYgcM+i8MoeJiyQqCAlwPyfJ6R9eitt
	 XJOl1m4HfKsdG9f7r9JrzuFRlTpjlpogx1xwBYQyHWobyob+EOTV4v1Ny7wtbIemkS
	 +OFP/wU4POmBxBK7OhO7J3GTDl/vTbCmVOw2tQEC+q47TwZToOe7cmuE05a4sIz9Dw
	 HCxWzcsuhPZL4wGRWyAdjyxiH/Fww6nne+H3+zm92JHSgs7WzX+NXex7i5hk/Scm1H
	 HnrG3ZT/IIUJw==
Message-ID: <sashiko-outbox-188655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation
 wrapper.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:05:59 +0000
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
- [Critical] crypto: acomp - missing async check in crypto_acomp_compress()=
 fast path
- [High] crypto: acomp: uninitialized state->src/dst restore in acomp_reqch=
ain_virt()
--

commit 7144b07b2cc5b6704699fb53fac44c4270d31f7b
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add trivial segmentation wrapper.

This commit adds a single-segment compression wrapper in crypto/acompress.c
that stores the compressed length or error code into req->dst->length when
req->unit_size is set on transforms that do not support segmentation. It al=
so
adds an inline fast path in crypto_acomp_compress() for single-segment
scatterlist requests.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index c8b4b8589769e..c55b0e8eff3d8 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req, c=
rypto_completion_t cplt)
> =20
>  	state->compl =3D req->base.complete;
>  	state->data =3D req->base.data;
> +	state->unit_size =3D req->unit_size;
> +	state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> +					  CRYPTO_ACOMP_REQ_DST_VIRT);

[Severity: High]
Can moving the state->flags assignment from acomp_virt_to_sg() into
acomp_save_req() corrupt req->svirt and req->dvirt when a request is
configured with acomp_request_set_src_nondma() or
acomp_request_set_dst_nondma()?

When a caller sets up a non-dma virtual request via
acomp_request_set_src_nondma() or acomp_request_set_dst_nondma(), both the
non-dma and virtual request flags are set in req->base.flags. When
crypto_acomp_compress() or crypto_acomp_decompress() calls
acomp_do_req_chain(), the call chain is:

crypto_acomp_compress()
  acomp_do_req_chain()
    acomp_save_req()
      state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
                                        CRYPTO_ACOMP_REQ_DST_VIRT);
    acomp_do_one_req()
      if (acomp_request_isnondma(req))
          return acomp_do_nondma(req, comp);

Because acomp_do_one_req() returns early through acomp_do_nondma() without
calling acomp_virt_to_sg(), state->src and state->dst are never initialized
from req->svirt and req->dvirt.

When acomp_reqchain_finish() then calls acomp_reqchain_virt() in
crypto/acompress.c:

static void acomp_reqchain_virt(struct acomp_req *req)
{
	struct acomp_req_chain *state =3D &req->chain;
	unsigned int slen =3D req->slen;
	unsigned int dlen =3D req->dlen;

	if (state->flags & CRYPTO_ACOMP_REQ_SRC_VIRT)
		acomp_request_set_src_dma(req, state->src, slen);
	if (state->flags & CRYPTO_ACOMP_REQ_DST_VIRT)
		acomp_request_set_dst_dma(req, state->dst, dlen);
}

won't acomp_reqchain_virt() see the virtual flags set in state->flags and
overwrite req->svirt and req->dvirt with the uninitialized state->src and
state->dst pointers (while also clearing the non-dma flags), causing a null
or wild pointer dereference if acomp_reqchain_finish() then writes to
req->dst->length when req->unit_size is non-zero?

[ ... ]

> @@ -279,10 +289,27 @@ int crypto_acomp_compress(struct acomp_req *req)
>  {
>  	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> =20
> +	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req)=
 &&
> +		    !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req))) {
> +		int err =3D tfm->compress(req);
> +
> +		req->dst->length =3D unlikely(err) ? err : req->dlen;
> +		return err;
> +	}

[Severity: Critical]
Should this fast path in crypto_acomp_compress() in crypto/acompress.c check
!acomp_is_async(tfm) instead of !acomp_req_on_stack(req)?

Callers using asynchronous hardware compression transforms (where
acomp_is_async(tfm) is true, such as qat, hisi_zip, or iaa in async mode)
allocate requests on the heap with acomp_request_alloc(), so
!acomp_req_on_stack(req) is true for asynchronous requests.

When zswap_compress() submits a single-segment scatterlist request with
req->unit_size =3D=3D req->slen to an asynchronous transform that does not
support segmentation, this fast path will be taken instead of
acomp_do_req_chain(req, true):

crypto/acompress.c:crypto_acomp_compress() {
	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req) &&
		    !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req))) {
		int err =3D tfm->compress(req);

		req->dst->length =3D unlikely(err) ? err : req->dlen;
		return err;
	}
}

When tfm->compress(req) submits the descriptor to hardware and returns an
in-progress or busy status, won't this immediately overwrite req->dst->leng=
th
with the negative error value while hardware dma is still in flight on
req->dst, and skip registering acomp_reqchain_done() via acomp_save_req() so
that req->dst->length is never updated to req->dlen upon async completion?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D3

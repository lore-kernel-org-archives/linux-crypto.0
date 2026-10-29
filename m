Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793250589;
	b=d74SLTmJQfFRDYJ+CZJD2RHYb8AYPAJ869fuEYym8bJ5IPUgxJZ4IZBEdjJmlc6Z8lMr
	 EAxRldso1WW2HL60if5Bh2WP7TqmNUltjW2I7Br2byDZAA9dPk3vYXQAMXJs1UDdceiG1
	 MqRBJd6Eqzs2yft4S0nxN9RDV0MlAJdT1Bh+2jEG4FeSNcs6NGv8pZP0Mp9gVfCnhjiuF
	 oZs0G2k6CV0OunTf+oX14tF76uLDrTr9GrgweWEcpn0nRP4ih4YoWhQ8jawx8Zo4sHhti
	 vyL742BEMCxv0e8MRkiPlUCPvWNBGIkmap65jUIiRTenEuimzRq0K3UgQIR3sSNu9kQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250589;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
	b=SD7bvUJSCccGW3Qst7WkUjYXNTgR6lKTkek1ehYjxj1tc0bRoffhWeNiwt6WIqbGSdxo
	 l8ChyY7cYeXVZfGGpGmlFqmO6O+dU6HurchQ6CiaKlKwYh2U9mR8xtwUmLzhl5noc0f1B
	 /DaJbS9Y0Q7smqWLTTJY9lMGCAp8mAZoj90bT8xIfGY8o3v6z8r/JK4TEHfbNohXtJS+g
	 2MmzmPKcgQaEc4O+oP8re+GHxfyYMgzKstY2UmOvhjUx/UXollketJVQZJybkgtyId5UQ
	 NJjIwwnMcuMX0NtAQW7zBH/YQ9i8/MyhWf/YUel8bk5rmTwdIEuPREXUbWJBBwdr9yA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fKJQhP+U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EF2606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 05:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88EF2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fKJQhP+U
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bfa686881fso1477859e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 22:09:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793250588; cv=none;
        d=google.com; s=arc-20260327;
        b=A6Ulc7BWqAmTWwQjUDXr5SMPr5eJhJShDgYDz+aXjNysZ/QzvgOsPFyHLzI3HKswD1
         GOAtLanmtCMKrMOF/Fe4iZOIrP3wSFdpiOifG8KdYZS4P4qJty/sEqlxw/HnYWJKBqT7
         1tHdTrtP/9ssPkaXrNgUS5xQPeBYZZDAel/2OJM7Z9+c5F7neI6qsJPaUD+5tCJCxfPU
         m7nOMbV9Vrfj0fjQMn3ENijkJTSON7ofd1uv9FMph8c5+EA6FSEeKKLL7WsYLYdALYTo
         WPclMZ7gKqmpZjdfNTcF59Dm8KBjZa/TSShSvW5JTs719AtVbtVjvy8LCa6vpY4quYr8
         SLlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
        fh=j2DLkGJI0HwRx6h/T69iP0CR+meyzu/A+d/TH8KvyTE=;
        b=rgk7FY8bbQacOdtmZ8ZbZPeSMYwtC7RCY+cGRZKgDNm6EiDPoD8uYSXiBK9Oi4xzxT
         M0GBtRh9c66CYIL2P1AsxdrdBHiI4vMkaNJXYbUP3Q/otJZi0zhMHvq9t0pMNZJ8dnOu
         ivxjC5DbSQ/geJpwBVPH7vftIOCjdfNp2/wF2n7k/fmtZzwN5wA470Q2b/4WvKD1UfrJ
         kjYBgDN/3n155DomflOqiAIAmPdLJBtSNQqNB97HjoQDmOMkVv5DUs04zbJvdRi5CeXK
         6c5jLDy9MA5hbDmYJXhO4YGiIAhMSFSmj2wBEewX4YPF/GUHiDCIhJEUz4+K7HigCiBe
         WzXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793250588; x=1793855388; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
        b=fKJQhP+UXcDynwbgZnQqP7dYWYZ8gebIN+TkPhpfnC1Oy5MplwAJZBhCY3bFXwlmH9
         bSy+xfwWLQzfmJAI8qVFK+zn1ftaV9xNe/G43FgsHLZsHEiig9gGfRbEQHO8YQpBQg8z
         /FxxJi56VjcZTd3H5Q7TPwcCKXxK2ds8g1k+1yQNvQDf37aM6ZcWqlO0NSIfXZtMKka5
         Pvb7SdiCfCoXIyxpCDKQRd9Oy+sta81KtqWPMBwro7RKs2p9Km5quikWSYmZ+PHBu5yV
         sF0b+CKqZY47WutPwGDcMhYXU9kP++gDfUUODJWQq3bTZQuK/GYAat62RU/aTviG7Fpx
         LKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793250588; x=1793855388;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kpw8TTYWKB5hnWuUygH4ZRFIeIPvKSlqcY3nCnns/2g=;
        b=CstiKjciebkzrKIdEVVEvRzai1WzJm3rvgAfDIv153yg9J7qebZuMTGHAZ56jyXcPH
         BV6Qe8GamIR1gDrXUUHBlQAVp/PmzHwFUhQFgP3trl+ItltbCXDTuHsYv0KtSIaO0oFY
         cJNBiI6HvPItyFfZg+61WRs8CN0SoFozrwbSOcfcw6SSN8v3nAw7LebyV0pEpHbVCAm/
         PIA+NDYlqPkDTVhDQYgVI2JzWB7A2Od1oVxAy0mHT5fTUxJo+lTALRKQoDRw/uVc18cL
         2LV+VM1Kfy3vsRsnUW5e4zF9W00vHYGDuXMrF1e/L4qWgWeumAwAMfq2R2nP1+fSB7w/
         nryA==
X-Forwarded-Encrypted: i=1; AKwUvByfhQrlC/6bsRQQGNPtTtEm/n4oYEXSU2S+0n3JIX4l4ix0VEHfcPmnctLxwBUimF5vCy815Tlcrws43VQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKb9XwESQQdwyjCsRRd6FP/b0CXa+xcwkYGOIsfB+FFFapR4xkw
	83QCPUEuMIMXhNnq1otiAR9Vn0epI3Sa8RuCpGBelggeVi9mt3mUvUym1HHhm1vxViLT5AbM+b2
	ubBqg6UBXTQXUQpo44WeWBPtphI6JPi4=
X-Gm-Gg: AYBFou3S/SpUhAwpleh/3gq834QvZlSAnavutJfjnj6pZhCBFIqgPFMyViD0ZR4WAlK
	CRC2qJnbN4RyJJudZ/PnaE9x4vRLNF5/NabQ2E2IZ1b3qPIB4a7BEImEaL5FFm88pNTOHl2hKOf
	hTWzmjfyV9pPoIr3h41bC9AklWVxR/Fm5BPUTpT59+x7WF53XXkiOGPn/BPqqLB2tldh10uNcgB
	UJZheGjhbbLQ+MLbCXaVuP6yJSZVIRfw7m+0wsqUtXGt6k6ilBk41+SABGuuDvhm4pkPb4qiVY6
	lsoL2AgwmrbPF2mOGbD5iGqVBDZQ3vID8jQpsgI0QuLQR8M/DjPFV0/HSSijKD0cNdjTlrlV9yt
	+W/OADcEm51v0D3hXAfx2nSMxJvEHFG3B0rD/
X-Received: by 2002:a05:6512:2254:b0:5bf:bbcb:5090 with SMTP id
 2adb3069b0e04-5bfcad1735cmr1673625e87.11.1793250587589; Wed, 28 Oct 2026
 22:09:47 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188655@kernel.org>
In-Reply-To: <sashiko-outbox-188655@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 28 Oct 2026 22:09:35 -0700
X-Gm-Features: AclHuK8nR-G5FLP-nKgfLbRVgykWEd41gXMbkberCRHNZZZBPGk3kNc3GrhEkxw
Message-ID: <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Critical] crypto: acomp - missing async check in crypto_acomp_compress=
() fast path
> - [High] crypto: acomp: uninitialized state->src/dst restore in acomp_req=
chain_virt()
> --

Thanks for the detailed code review!

>
> commit 7144b07b2cc5b6704699fb53fac44c4270d31f7b
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add trivial segmentation wrapper.
>
> This commit adds a single-segment compression wrapper in crypto/acompress=
.c
> that stores the compressed length or error code into req->dst->length whe=
n
> req->unit_size is set on transforms that do not support segmentation. It =
also
> adds an inline fast path in crypto_acomp_compress() for single-segment
> scatterlist requests.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index c8b4b8589769e..c55b0e8eff3d8 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req,=
 crypto_completion_t cplt)
> >
> >       state->compl =3D req->base.complete;
> >       state->data =3D req->base.data;
> > +     state->unit_size =3D req->unit_size;
> > +     state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
> > +                                       CRYPTO_ACOMP_REQ_DST_VIRT);
>
> [Severity: High]
> Can moving the state->flags assignment from acomp_virt_to_sg() into
> acomp_save_req() corrupt req->svirt and req->dvirt when a request is
> configured with acomp_request_set_src_nondma() or
> acomp_request_set_dst_nondma()?
>
> When a caller sets up a non-dma virtual request via
> acomp_request_set_src_nondma() or acomp_request_set_dst_nondma(), both th=
e
> non-dma and virtual request flags are set in req->base.flags. When
> crypto_acomp_compress() or crypto_acomp_decompress() calls
> acomp_do_req_chain(), the call chain is:
>
> crypto_acomp_compress()
>   acomp_do_req_chain()
>     acomp_save_req()
>       state->flags =3D req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
>                                         CRYPTO_ACOMP_REQ_DST_VIRT);
>     acomp_do_one_req()
>       if (acomp_request_isnondma(req))
>           return acomp_do_nondma(req, comp);
>
> Because acomp_do_one_req() returns early through acomp_do_nondma() withou=
t
> calling acomp_virt_to_sg(), state->src and state->dst are never initializ=
ed
> from req->svirt and req->dvirt.
>
> When acomp_reqchain_finish() then calls acomp_reqchain_virt() in
> crypto/acompress.c:
>
> static void acomp_reqchain_virt(struct acomp_req *req)
> {
>         struct acomp_req_chain *state =3D &req->chain;
>         unsigned int slen =3D req->slen;
>         unsigned int dlen =3D req->dlen;
>
>         if (state->flags & CRYPTO_ACOMP_REQ_SRC_VIRT)
>                 acomp_request_set_src_dma(req, state->src, slen);
>         if (state->flags & CRYPTO_ACOMP_REQ_DST_VIRT)
>                 acomp_request_set_dst_dma(req, state->dst, dlen);
> }
>
> won't acomp_reqchain_virt() see the virtual flags set in state->flags and
> overwrite req->svirt and req->dvirt with the uninitialized state->src and
> state->dst pointers (while also clearing the non-dma flags), causing a nu=
ll
> or wild pointer dereference if acomp_reqchain_finish() then writes to
> req->dst->length when req->unit_size is non-zero?
>

Herbert, can you please take a look at this and suggest what changes
need to be made here, since you are the original developer of this
portion of the patch. Thanks.

> [ ... ]
>
> > @@ -279,10 +289,27 @@ int crypto_acomp_compress(struct acomp_req *req)
> >  {
> >       struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > +     if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
> > +                 !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req=
))) {
> > +             int err =3D tfm->compress(req);
> > +
> > +             req->dst->length =3D unlikely(err) ? err : req->dlen;
> > +             return err;
> > +     }
>
> [Severity: Critical]
> Should this fast path in crypto_acomp_compress() in crypto/acompress.c ch=
eck
> !acomp_is_async(tfm) instead of !acomp_req_on_stack(req)?

Thanks for the catch! Yes, I will add (!acomp_is_async(tfm) &&
!acomp_req_on_stack(req)) here.
Since zswap is the only current user who, with this patch series,
submits the req as SG lists, I was assuming that async algorithms
would set the segmentation bit, and avoid this short-circuit. But
until that happens, the above check will take care of this.

>
> Callers using asynchronous hardware compression transforms (where
> acomp_is_async(tfm) is true, such as qat, hisi_zip, or iaa in async mode)
> allocate requests on the heap with acomp_request_alloc(), so
> !acomp_req_on_stack(req) is true for asynchronous requests.
>
> When zswap_compress() submits a single-segment scatterlist request with
> req->unit_size =3D=3D req->slen to an asynchronous transform that does no=
t
> support segmentation, this fast path will be taken instead of
> acomp_do_req_chain(req, true):
>
> crypto/acompress.c:crypto_acomp_compress() {
>         if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
>                     !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req=
))) {
>                 int err =3D tfm->compress(req);
>
>                 req->dst->length =3D unlikely(err) ? err : req->dlen;
>                 return err;
>         }
> }
>
> When tfm->compress(req) submits the descriptor to hardware and returns an
> in-progress or busy status, won't this immediately overwrite req->dst->le=
ngth
> with the negative error value while hardware dma is still in flight on
> req->dst, and skip registering acomp_reqchain_done() via acomp_save_req()=
 so
> that req->dst->length is never updated to req->dlen upon async completion=
?
>

The augmented check for async algs should take care of this.

Thanks,
Kanchana

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D3

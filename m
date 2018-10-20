Return-Path: <SRS0=gnyg=NA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F2CC67863
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 03:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42970214C3
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 03:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="BlV5fmtV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42970214C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbeJTLyb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Oct 2018 07:54:31 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38889 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbeJTLya (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 07:54:30 -0400
Received: by mail-io1-f67.google.com with SMTP id q18-v6so2107455iod.5
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 20:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PmAv4yFzfmJKyjq4j5Jo3kOgdb8jZtGQbQLKPiXcvLg=;
        b=BlV5fmtVIJGWr+BhN8U+mNyjKhtLcadw0pgUvrlBykc2oYTatfL4VOTPYojWrO9gR5
         7/VnnF96KfqT3Fo64qq/HxY3xruHZp14VLw4ba7x4F45G5kXcMO8H84SFlu6WPj9jZMu
         zpJAwSSRvKxDP/aVTc2DDldsaSIkxwImkIntw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PmAv4yFzfmJKyjq4j5Jo3kOgdb8jZtGQbQLKPiXcvLg=;
        b=e8+OdduOa+6YHZRAGrd2lPMXDgZMHhfQZKZ5MDG0cGda4lPdTpkVC/d+uEDqQ2AqUX
         DOYuT3QDVVKGblo/qUwZezRn2MCFKEYPQzI+VSWnrfla7EHEVk6Cwat1W3fAMxNDslBZ
         /0UVu6IUzSBDLmkv0NGOxCVRnmOF07QyF1tsl6FB2MgMqnQVrQrBqRP73ckebIWUbNka
         pzX4aoLT7mdIoH8aco6AYn7gfWzYlYuwX2LPEM7K9sXTMEty8iZBaXInktPFKGhnV6kE
         MQFMJOdTThkBa5jxRHBaOPJfKa1Omn1Rh7rROCWjCCt7Y2DB/ftletXHil2sct/fJN0i
         uBKw==
X-Gm-Message-State: AGRZ1gIZrPYyMpO+6db3IyF3dGk7E75K1Ya1GGWKZ7+pA0+S8xi9HiC6
        8ACri4R5A/sgLMZtJLDUFlm+egJ8czbo6/Y8uoJ5eQ==
X-Google-Smtp-Source: AJdET5cUwlgOvSeaGhVhQCdsS9DH9mWx4Cy0iuVNaaOJBAmN1isjWcOhtHQjCb8Sug7NAcTx5HMRoZShpcRDr1tgTkY=
X-Received: by 2002:a6b:be83:: with SMTP id o125-v6mr4456823iof.173.1540007133466;
 Fri, 19 Oct 2018 20:45:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 20:45:32
 -0700 (PDT)
In-Reply-To: <20181015175424.97147-9-ebiggers@kernel.org>
References: <20181015175424.97147-1-ebiggers@kernel.org> <20181015175424.97147-9-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 20 Oct 2018 11:45:32 +0800
Message-ID:
 <CAKv+Gu8NOH5gg9qk+4NNWFKVYTfNcxAfiQ3K3SXhCmEJUyMnTA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/12] crypto: poly1305 - add Poly1305 core API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181020034532.8h2nryahUQ6g7FIw8pkBra-ddSlfnNJDpLWBvBbvMxM@z>

On 16 October 2018 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Expose a low-level Poly1305 API which implements the
> =CE=B5-almost-=E2=88=86-universal (=CE=B5A=E2=88=86U) hash function under=
lying the Poly1305 MAC
> and supports block-aligned inputs only.
>
> This is needed for Adiantum hashing, which builds an =CE=B5A=E2=88=86U ha=
sh function
> from NH and a polynomial evaluation in GF(2^{130}-5); this polynomial
> evaluation is identical to the one the Poly1305 MAC does.  However, the
> crypto_shash Poly1305 API isn't very appropriate for this because its
> calling convention assumes it is used as a MAC, with a 32-byte
> "one-time key" provided for every digest.
>
> But by design, in Adiantum hashing the performance of the polynomial
> evaluation isn't nearly as critical as NH.  So it suffices to just have
> some C helper functions.  Thus, this patch adds such functions.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Could we split this up into
- a patch that updates the poly1305_desc_ctx layout and fixes up all
the references
- a patch that actually breaks out the functionality you need to
access separately

I am aware that you'll end up touching some lines twice, but it should
be much easier to review.

> ---
>  arch/x86/crypto/poly1305_glue.c |  20 ++--
>  crypto/poly1305_generic.c       | 174 ++++++++++++++++++--------------
>  include/crypto/poly1305.h       |  28 ++++-
>  3 files changed, 136 insertions(+), 86 deletions(-)
>
> diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_g=
lue.c
> index f012b7e28ad1d..88cc01506c84a 100644
> --- a/arch/x86/crypto/poly1305_glue.c
> +++ b/arch/x86/crypto/poly1305_glue.c
> @@ -83,35 +83,37 @@ static unsigned int poly1305_simd_blocks(struct poly1=
305_desc_ctx *dctx,
>         if (poly1305_use_avx2 && srclen >=3D POLY1305_BLOCK_SIZE * 4) {
>                 if (unlikely(!sctx->wset)) {
>                         if (!sctx->uset) {
> -                               memcpy(sctx->u, dctx->r, sizeof(sctx->u))=
;
> -                               poly1305_simd_mult(sctx->u, dctx->r);
> +                               memcpy(sctx->u, dctx->r.r, sizeof(sctx->u=
));
> +                               poly1305_simd_mult(sctx->u, dctx->r.r);
>                                 sctx->uset =3D true;
>                         }
>                         memcpy(sctx->u + 5, sctx->u, sizeof(sctx->u));
> -                       poly1305_simd_mult(sctx->u + 5, dctx->r);
> +                       poly1305_simd_mult(sctx->u + 5, dctx->r.r);
>                         memcpy(sctx->u + 10, sctx->u + 5, sizeof(sctx->u)=
);
> -                       poly1305_simd_mult(sctx->u + 10, dctx->r);
> +                       poly1305_simd_mult(sctx->u + 10, dctx->r.r);
>                         sctx->wset =3D true;
>                 }
>                 blocks =3D srclen / (POLY1305_BLOCK_SIZE * 4);
> -               poly1305_4block_avx2(dctx->h, src, dctx->r, blocks, sctx-=
>u);
> +               poly1305_4block_avx2(dctx->h.h, src, dctx->r.r, blocks,
> +                                    sctx->u);
>                 src +=3D POLY1305_BLOCK_SIZE * 4 * blocks;
>                 srclen -=3D POLY1305_BLOCK_SIZE * 4 * blocks;
>         }
>  #endif
>         if (likely(srclen >=3D POLY1305_BLOCK_SIZE * 2)) {
>                 if (unlikely(!sctx->uset)) {
> -                       memcpy(sctx->u, dctx->r, sizeof(sctx->u));
> -                       poly1305_simd_mult(sctx->u, dctx->r);
> +                       memcpy(sctx->u, dctx->r.r, sizeof(sctx->u));
> +                       poly1305_simd_mult(sctx->u, dctx->r.r);
>                         sctx->uset =3D true;
>                 }
>                 blocks =3D srclen / (POLY1305_BLOCK_SIZE * 2);
> -               poly1305_2block_sse2(dctx->h, src, dctx->r, blocks, sctx-=
>u);
> +               poly1305_2block_sse2(dctx->h.h, src, dctx->r.r, blocks,
> +                                    sctx->u);
>                 src +=3D POLY1305_BLOCK_SIZE * 2 * blocks;
>                 srclen -=3D POLY1305_BLOCK_SIZE * 2 * blocks;
>         }
>         if (srclen >=3D POLY1305_BLOCK_SIZE) {
> -               poly1305_block_sse2(dctx->h, src, dctx->r, 1);
> +               poly1305_block_sse2(dctx->h.h, src, dctx->r.r, 1);
>                 srclen -=3D POLY1305_BLOCK_SIZE;
>         }
>         return srclen;
> diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
> index 47d3a6b83931e..2a06874204e87 100644
> --- a/crypto/poly1305_generic.c
> +++ b/crypto/poly1305_generic.c
> @@ -38,7 +38,7 @@ int crypto_poly1305_init(struct shash_desc *desc)
>  {
>         struct poly1305_desc_ctx *dctx =3D shash_desc_ctx(desc);
>
> -       memset(dctx->h, 0, sizeof(dctx->h));
> +       poly1305_core_init(&dctx->h);
>         dctx->buflen =3D 0;
>         dctx->rset =3D false;
>         dctx->sset =3D false;
> @@ -47,23 +47,16 @@ int crypto_poly1305_init(struct shash_desc *desc)
>  }
>  EXPORT_SYMBOL_GPL(crypto_poly1305_init);
>
> -static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *k=
ey)
> +void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key)
>  {
>         /* r &=3D 0xffffffc0ffffffc0ffffffc0fffffff */
> -       dctx->r[0] =3D (get_unaligned_le32(key +  0) >> 0) & 0x3ffffff;
> -       dctx->r[1] =3D (get_unaligned_le32(key +  3) >> 2) & 0x3ffff03;
> -       dctx->r[2] =3D (get_unaligned_le32(key +  6) >> 4) & 0x3ffc0ff;
> -       dctx->r[3] =3D (get_unaligned_le32(key +  9) >> 6) & 0x3f03fff;
> -       dctx->r[4] =3D (get_unaligned_le32(key + 12) >> 8) & 0x00fffff;
> -}
> -
> -static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *k=
ey)
> -{
> -       dctx->s[0] =3D get_unaligned_le32(key +  0);
> -       dctx->s[1] =3D get_unaligned_le32(key +  4);
> -       dctx->s[2] =3D get_unaligned_le32(key +  8);
> -       dctx->s[3] =3D get_unaligned_le32(key + 12);
> +       key->r[0] =3D (get_unaligned_le32(raw_key +  0) >> 0) & 0x3ffffff=
;
> +       key->r[1] =3D (get_unaligned_le32(raw_key +  3) >> 2) & 0x3ffff03=
;
> +       key->r[2] =3D (get_unaligned_le32(raw_key +  6) >> 4) & 0x3ffc0ff=
;
> +       key->r[3] =3D (get_unaligned_le32(raw_key +  9) >> 6) & 0x3f03fff=
;
> +       key->r[4] =3D (get_unaligned_le32(raw_key + 12) >> 8) & 0x00fffff=
;
>  }
> +EXPORT_SYMBOL_GPL(poly1305_core_setkey);
>
>  /*
>   * Poly1305 requires a unique key for each tag, which implies that we ca=
n't set
> @@ -75,13 +68,16 @@ unsigned int crypto_poly1305_setdesckey(struct poly13=
05_desc_ctx *dctx,
>  {
>         if (!dctx->sset) {
>                 if (!dctx->rset && srclen >=3D POLY1305_BLOCK_SIZE) {
> -                       poly1305_setrkey(dctx, src);
> +                       poly1305_core_setkey(&dctx->r, src);
>                         src +=3D POLY1305_BLOCK_SIZE;
>                         srclen -=3D POLY1305_BLOCK_SIZE;
>                         dctx->rset =3D true;
>                 }
>                 if (srclen >=3D POLY1305_BLOCK_SIZE) {
> -                       poly1305_setskey(dctx, src);
> +                       dctx->s[0] =3D get_unaligned_le32(src +  0);
> +                       dctx->s[1] =3D get_unaligned_le32(src +  4);
> +                       dctx->s[2] =3D get_unaligned_le32(src +  8);
> +                       dctx->s[3] =3D get_unaligned_le32(src + 12);
>                         src +=3D POLY1305_BLOCK_SIZE;
>                         srclen -=3D POLY1305_BLOCK_SIZE;
>                         dctx->sset =3D true;
> @@ -91,41 +87,37 @@ unsigned int crypto_poly1305_setdesckey(struct poly13=
05_desc_ctx *dctx,
>  }
>  EXPORT_SYMBOL_GPL(crypto_poly1305_setdesckey);
>
> -static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
> -                                   const u8 *src, unsigned int srclen,
> -                                   u32 hibit)
> +static void poly1305_blocks_internal(struct poly1305_state *state,
> +                                    const struct poly1305_key *key,
> +                                    const void *src, unsigned int nblock=
s,
> +                                    u32 hibit)
>  {
>         u32 r0, r1, r2, r3, r4;
>         u32 s1, s2, s3, s4;
>         u32 h0, h1, h2, h3, h4;
>         u64 d0, d1, d2, d3, d4;
> -       unsigned int datalen;
>
> -       if (unlikely(!dctx->sset)) {
> -               datalen =3D crypto_poly1305_setdesckey(dctx, src, srclen)=
;
> -               src +=3D srclen - datalen;
> -               srclen =3D datalen;
> -       }
> +       if (!nblocks)
> +               return;
>
> -       r0 =3D dctx->r[0];
> -       r1 =3D dctx->r[1];
> -       r2 =3D dctx->r[2];
> -       r3 =3D dctx->r[3];
> -       r4 =3D dctx->r[4];
> +       r0 =3D key->r[0];
> +       r1 =3D key->r[1];
> +       r2 =3D key->r[2];
> +       r3 =3D key->r[3];
> +       r4 =3D key->r[4];
>
>         s1 =3D r1 * 5;
>         s2 =3D r2 * 5;
>         s3 =3D r3 * 5;
>         s4 =3D r4 * 5;
>
> -       h0 =3D dctx->h[0];
> -       h1 =3D dctx->h[1];
> -       h2 =3D dctx->h[2];
> -       h3 =3D dctx->h[3];
> -       h4 =3D dctx->h[4];
> -
> -       while (likely(srclen >=3D POLY1305_BLOCK_SIZE)) {
> +       h0 =3D state->h[0];
> +       h1 =3D state->h[1];
> +       h2 =3D state->h[2];
> +       h3 =3D state->h[3];
> +       h4 =3D state->h[4];
>
> +       do {
>                 /* h +=3D m[i] */
>                 h0 +=3D (get_unaligned_le32(src +  0) >> 0) & 0x3ffffff;
>                 h1 +=3D (get_unaligned_le32(src +  3) >> 2) & 0x3ffffff;
> @@ -154,16 +146,36 @@ static unsigned int poly1305_blocks(struct poly1305=
_desc_ctx *dctx,
>                 h1 +=3D h0 >> 26;       h0 =3D h0 & 0x3ffffff;
>
>                 src +=3D POLY1305_BLOCK_SIZE;
> -               srclen -=3D POLY1305_BLOCK_SIZE;
> -       }
> +       } while (--nblocks);
>
> -       dctx->h[0] =3D h0;
> -       dctx->h[1] =3D h1;
> -       dctx->h[2] =3D h2;
> -       dctx->h[3] =3D h3;
> -       dctx->h[4] =3D h4;
> +       state->h[0] =3D h0;
> +       state->h[1] =3D h1;
> +       state->h[2] =3D h2;
> +       state->h[3] =3D h3;
> +       state->h[4] =3D h4;
> +}
>
> -       return srclen;
> +void poly1305_core_blocks(struct poly1305_state *state,
> +                         const struct poly1305_key *key,
> +                         const void *src, unsigned int nblocks)
> +{
> +       poly1305_blocks_internal(state, key, src, nblocks, 1 << 24);
> +}
> +EXPORT_SYMBOL_GPL(poly1305_core_blocks);
> +
> +static void poly1305_blocks(struct poly1305_desc_ctx *dctx,
> +                           const u8 *src, unsigned int srclen, u32 hibit=
)
> +{
> +       unsigned int datalen;
> +
> +       if (unlikely(!dctx->sset)) {
> +               datalen =3D crypto_poly1305_setdesckey(dctx, src, srclen)=
;
> +               src +=3D srclen - datalen;
> +               srclen =3D datalen;
> +       }
> +
> +       poly1305_blocks_internal(&dctx->h, &dctx->r,
> +                                src, srclen / POLY1305_BLOCK_SIZE, hibit=
);
>  }
>
>  int crypto_poly1305_update(struct shash_desc *desc,
> @@ -187,9 +199,9 @@ int crypto_poly1305_update(struct shash_desc *desc,
>         }
>
>         if (likely(srclen >=3D POLY1305_BLOCK_SIZE)) {
> -               bytes =3D poly1305_blocks(dctx, src, srclen, 1 << 24);
> -               src +=3D srclen - bytes;
> -               srclen =3D bytes;
> +               poly1305_blocks(dctx, src, srclen, 1 << 24);
> +               src +=3D srclen - (srclen % POLY1305_BLOCK_SIZE);
> +               srclen %=3D POLY1305_BLOCK_SIZE;
>         }
>
>         if (unlikely(srclen)) {
> @@ -201,30 +213,18 @@ int crypto_poly1305_update(struct shash_desc *desc,
>  }
>  EXPORT_SYMBOL_GPL(crypto_poly1305_update);
>
> -int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
> +void poly1305_core_emit(const struct poly1305_state *state, void *dst)
>  {
> -       struct poly1305_desc_ctx *dctx =3D shash_desc_ctx(desc);
>         u32 h0, h1, h2, h3, h4;
>         u32 g0, g1, g2, g3, g4;
>         u32 mask;
> -       u64 f =3D 0;
> -
> -       if (unlikely(!dctx->sset))
> -               return -ENOKEY;
> -
> -       if (unlikely(dctx->buflen)) {
> -               dctx->buf[dctx->buflen++] =3D 1;
> -               memset(dctx->buf + dctx->buflen, 0,
> -                      POLY1305_BLOCK_SIZE - dctx->buflen);
> -               poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
> -       }
>
>         /* fully carry h */
> -       h0 =3D dctx->h[0];
> -       h1 =3D dctx->h[1];
> -       h2 =3D dctx->h[2];
> -       h3 =3D dctx->h[3];
> -       h4 =3D dctx->h[4];
> +       h0 =3D state->h[0];
> +       h1 =3D state->h[1];
> +       h2 =3D state->h[2];
> +       h3 =3D state->h[3];
> +       h4 =3D state->h[4];
>
>         h2 +=3D (h1 >> 26);     h1 =3D h1 & 0x3ffffff;
>         h3 +=3D (h2 >> 26);     h2 =3D h2 & 0x3ffffff;
> @@ -254,16 +254,40 @@ int crypto_poly1305_final(struct shash_desc *desc, =
u8 *dst)
>         h4 =3D (h4 & mask) | g4;
>
>         /* h =3D h % (2^128) */
> -       h0 =3D (h0 >>  0) | (h1 << 26);
> -       h1 =3D (h1 >>  6) | (h2 << 20);
> -       h2 =3D (h2 >> 12) | (h3 << 14);
> -       h3 =3D (h3 >> 18) | (h4 <<  8);
> +       put_unaligned_le32((h0 >>  0) | (h1 << 26), dst +  0);
> +       put_unaligned_le32((h1 >>  6) | (h2 << 20), dst +  4);
> +       put_unaligned_le32((h2 >> 12) | (h3 << 14), dst +  8);
> +       put_unaligned_le32((h3 >> 18) | (h4 <<  8), dst + 12);
> +}
> +EXPORT_SYMBOL_GPL(poly1305_core_emit);
> +
> +int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
> +{
> +       struct poly1305_desc_ctx *dctx =3D shash_desc_ctx(desc);
> +       __le32 digest[4];
> +       u64 f =3D 0;
> +
> +       if (unlikely(!dctx->sset))
> +               return -ENOKEY;
> +
> +       if (unlikely(dctx->buflen)) {
> +               dctx->buf[dctx->buflen++] =3D 1;
> +               memset(dctx->buf + dctx->buflen, 0,
> +                      POLY1305_BLOCK_SIZE - dctx->buflen);
> +               poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
> +       }
> +
> +       poly1305_core_emit(&dctx->h, digest);
>
>         /* mac =3D (h + s) % (2^128) */
> -       f =3D (f >> 32) + h0 + dctx->s[0]; put_unaligned_le32(f, dst +  0=
);
> -       f =3D (f >> 32) + h1 + dctx->s[1]; put_unaligned_le32(f, dst +  4=
);
> -       f =3D (f >> 32) + h2 + dctx->s[2]; put_unaligned_le32(f, dst +  8=
);
> -       f =3D (f >> 32) + h3 + dctx->s[3]; put_unaligned_le32(f, dst + 12=
);
> +       f =3D (f >> 32) + le32_to_cpu(digest[0]) + dctx->s[0];
> +       put_unaligned_le32(f, dst + 0);
> +       f =3D (f >> 32) + le32_to_cpu(digest[1]) + dctx->s[1];
> +       put_unaligned_le32(f, dst + 4);
> +       f =3D (f >> 32) + le32_to_cpu(digest[2]) + dctx->s[2];
> +       put_unaligned_le32(f, dst + 8);
> +       f =3D (f >> 32) + le32_to_cpu(digest[3]) + dctx->s[3];
> +       put_unaligned_le32(f, dst + 12);
>
>         return 0;
>  }
> diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
> index f718a19da82f7..34317ed2071e6 100644
> --- a/include/crypto/poly1305.h
> +++ b/include/crypto/poly1305.h
> @@ -13,13 +13,21 @@
>  #define POLY1305_KEY_SIZE      32
>  #define POLY1305_DIGEST_SIZE   16
>
> +struct poly1305_key {
> +       u32 r[5];       /* key, base 2^26 */
> +};
> +
> +struct poly1305_state {
> +       u32 h[5];       /* accumulator, base 2^26 */
> +};
> +
>  struct poly1305_desc_ctx {
>         /* key */
> -       u32 r[5];
> +       struct poly1305_key r;
>         /* finalize key */
>         u32 s[4];
>         /* accumulator */
> -       u32 h[5];
> +       struct poly1305_state h;
>         /* partial buffer */
>         u8 buf[POLY1305_BLOCK_SIZE];
>         /* bytes used in partial buffer */
> @@ -30,6 +38,22 @@ struct poly1305_desc_ctx {
>         bool sset;
>  };
>
> +/*
> + * Poly1305 core functions.  These implement the =CE=B5-almost-=E2=88=86=
-universal hash
> + * function underlying the Poly1305 MAC, i.e. they don't add an encrypte=
d nonce
> + * ("s key") at the end.  They also only support block-aligned inputs.
> + */
> +void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key);
> +static inline void poly1305_core_init(struct poly1305_state *state)
> +{
> +       memset(state->h, 0, sizeof(state->h));
> +}
> +void poly1305_core_blocks(struct poly1305_state *state,
> +                         const struct poly1305_key *key,
> +                         const void *src, unsigned int nblocks);
> +void poly1305_core_emit(const struct poly1305_state *state, void *dst);
> +
> +/* Crypto API helper functions for the Poly1305 MAC */
>  int crypto_poly1305_init(struct shash_desc *desc);
>  unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
>                                         const u8 *src, unsigned int srcle=
n);
> --
> 2.19.1.331.ge82ca0e54c-goog
>

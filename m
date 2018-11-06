Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD87C32789
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Nov 2018 14:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392E02085B
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Nov 2018 14:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ExgsOQCs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 392E02085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388795AbeKFXxz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:53:55 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:50636 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388786AbeKFXxy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 18:53:54 -0500
Received: by mail-it1-f193.google.com with SMTP id k206-v6so18062565ite.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Nov 2018 06:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ybYrQ/nMOI9TJQRUGGfCUK+OOS8n+w7lwfEAjLP3yvU=;
        b=ExgsOQCsQq/ZxRYppb6uWCdFvLoU/qmrpk4xPcb27o4MlzXsYTB49TmXWYpNyMNbY3
         h5zP9Ojr6pYpEkiwo7hVsevWVPXSn7tr3gBAC+bB4+5zab100hQEj77Xp8oexVt0ylt2
         aXADAFC05g5x8kzS743Tk6FJYzkUMFJf0olAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ybYrQ/nMOI9TJQRUGGfCUK+OOS8n+w7lwfEAjLP3yvU=;
        b=Vxew4d9SVH31FD/8VMI75UvjoN4d/dAfkqzb5tT8378RgLMxd892h5PZZrlWlyHGgm
         Xa9ETTMq57nw4abF9dBNTHkkpKhxWGlqLLws3TPUrnyh3MH8jC9Okou/2neRBIoq6ePx
         AIajiVWinlGWXWUkMOaK+QdGmPrs6Bn49lMoT63/z9fCNHEPg9J1a3W118/qCWXsnQGB
         rUcHG27pi71Xp46SCJudP3VgvO7wDp8oedIGNUu21oGbgdI9mTuV/aOhN+SmAdD/msIt
         2KvsEitmu5a3MaMqbak9VdMNtpxFqgaizAQx5yPinhplO6xKn/NMXdYzFiwr35T7s7xM
         yEgg==
X-Gm-Message-State: AGRZ1gJ12h/9T2WBjQjWy8YfwtrXqbm/S6UEW7jDTmOLV+65EqiL0cP4
        inLI74kAcs31hD5r+VEEnZeAL+7dH56nN0OgNonhFeAzj1g=
X-Google-Smtp-Source: AJdET5eqIjGs8kgfTuj86FCRRVhHB/uMwJGs2SElJM+36dUseDrYnSagliqRW5TGg5SP75EFm4K0W+x/vkn0YSxWzJA=
X-Received: by 2002:a02:6f41:: with SMTP id b1-v6mr23463073jae.62.1541514505503;
 Tue, 06 Nov 2018 06:28:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:4f16:0:0:0:0:0 with HTTP; Tue, 6 Nov 2018 06:28:24 -0800 (PST)
In-Reply-To: <20181105232526.173947-11-ebiggers@kernel.org>
References: <20181105232526.173947-1-ebiggers@kernel.org> <20181105232526.173947-11-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 6 Nov 2018 15:28:24 +0100
Message-ID:
 <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 10/15] crypto: poly1305 - use structures for key
 and accumulator
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181106142824.hZ6veo-gUgCAryLoJnw8qlbTTTGnwM1vDatNQEM9miA@z>

On 6 November 2018 at 00:25, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> In preparation for exposing a low-level Poly1305 API which implements
> the =CE=B5-almost-=E2=88=86-universal (=CE=B5A=E2=88=86U) hash function u=
nderlying the Poly1305
> MAC and supports block-aligned inputs only, create structures
> poly1305_key and poly1305_state which hold the limbs of the Poly1305
> "r" key and accumulator, respectively.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/poly1305_glue.c | 20 +++++++------
>  crypto/poly1305_generic.c       | 52 ++++++++++++++++-----------------
>  include/crypto/poly1305.h       | 12 ++++++--
>  3 files changed, 47 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_g=
lue.c
> index f012b7e28ad1..88cc01506c84 100644
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
> index 47d3a6b83931..a23173f351b7 100644
> --- a/crypto/poly1305_generic.c
> +++ b/crypto/poly1305_generic.c
> @@ -38,7 +38,7 @@ int crypto_poly1305_init(struct shash_desc *desc)
>  {
>         struct poly1305_desc_ctx *dctx =3D shash_desc_ctx(desc);
>
> -       memset(dctx->h, 0, sizeof(dctx->h));
> +       memset(dctx->h.h, 0, sizeof(dctx->h.h));
>         dctx->buflen =3D 0;
>         dctx->rset =3D false;
>         dctx->sset =3D false;
> @@ -50,11 +50,11 @@ EXPORT_SYMBOL_GPL(crypto_poly1305_init);
>  static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *k=
ey)
>  {
>         /* r &=3D 0xffffffc0ffffffc0ffffffc0fffffff */
> -       dctx->r[0] =3D (get_unaligned_le32(key +  0) >> 0) & 0x3ffffff;
> -       dctx->r[1] =3D (get_unaligned_le32(key +  3) >> 2) & 0x3ffff03;
> -       dctx->r[2] =3D (get_unaligned_le32(key +  6) >> 4) & 0x3ffc0ff;
> -       dctx->r[3] =3D (get_unaligned_le32(key +  9) >> 6) & 0x3f03fff;
> -       dctx->r[4] =3D (get_unaligned_le32(key + 12) >> 8) & 0x00fffff;
> +       dctx->r.r[0] =3D (get_unaligned_le32(key +  0) >> 0) & 0x3ffffff;
> +       dctx->r.r[1] =3D (get_unaligned_le32(key +  3) >> 2) & 0x3ffff03;
> +       dctx->r.r[2] =3D (get_unaligned_le32(key +  6) >> 4) & 0x3ffc0ff;
> +       dctx->r.r[3] =3D (get_unaligned_le32(key +  9) >> 6) & 0x3f03fff;
> +       dctx->r.r[4] =3D (get_unaligned_le32(key + 12) >> 8) & 0x00fffff;
>  }
>
>  static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *k=
ey)
> @@ -107,22 +107,22 @@ static unsigned int poly1305_blocks(struct poly1305=
_desc_ctx *dctx,
>                 srclen =3D datalen;
>         }
>
> -       r0 =3D dctx->r[0];
> -       r1 =3D dctx->r[1];
> -       r2 =3D dctx->r[2];
> -       r3 =3D dctx->r[3];
> -       r4 =3D dctx->r[4];
> +       r0 =3D dctx->r.r[0];
> +       r1 =3D dctx->r.r[1];
> +       r2 =3D dctx->r.r[2];
> +       r3 =3D dctx->r.r[3];
> +       r4 =3D dctx->r.r[4];
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
> +       h0 =3D dctx->h.h[0];
> +       h1 =3D dctx->h.h[1];
> +       h2 =3D dctx->h.h[2];
> +       h3 =3D dctx->h.h[3];
> +       h4 =3D dctx->h.h[4];
>
>         while (likely(srclen >=3D POLY1305_BLOCK_SIZE)) {
>
> @@ -157,11 +157,11 @@ static unsigned int poly1305_blocks(struct poly1305=
_desc_ctx *dctx,
>                 srclen -=3D POLY1305_BLOCK_SIZE;
>         }
>
> -       dctx->h[0] =3D h0;
> -       dctx->h[1] =3D h1;
> -       dctx->h[2] =3D h2;
> -       dctx->h[3] =3D h3;
> -       dctx->h[4] =3D h4;
> +       dctx->h.h[0] =3D h0;
> +       dctx->h.h[1] =3D h1;
> +       dctx->h.h[2] =3D h2;
> +       dctx->h.h[3] =3D h3;
> +       dctx->h.h[4] =3D h4;
>
>         return srclen;
>  }
> @@ -220,11 +220,11 @@ int crypto_poly1305_final(struct shash_desc *desc, =
u8 *dst)
>         }
>
>         /* fully carry h */
> -       h0 =3D dctx->h[0];
> -       h1 =3D dctx->h[1];
> -       h2 =3D dctx->h[2];
> -       h3 =3D dctx->h[3];
> -       h4 =3D dctx->h[4];
> +       h0 =3D dctx->h.h[0];
> +       h1 =3D dctx->h.h[1];
> +       h2 =3D dctx->h.h[2];
> +       h3 =3D dctx->h.h[3];
> +       h4 =3D dctx->h.h[4];
>
>         h2 +=3D (h1 >> 26);     h1 =3D h1 & 0x3ffffff;
>         h3 +=3D (h2 >> 26);     h2 =3D h2 & 0x3ffffff;
> diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
> index f718a19da82f..493244c46664 100644
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

Sorry to bikeshed, but wouldn't it make more sense to have single definitio=
n

struct poly1305_val {
    u32  v[5]; /* base 2^26 */
};

and have 'key' and 'accum[ulator]' fields of type struct poly1305_val
in the struct below?

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
> --
> 2.19.1.930.g4563a0d9d0-goog
>

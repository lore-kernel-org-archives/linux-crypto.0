Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883C4C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53BEF2054F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vs0irhNZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbfLLO7r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:59:47 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36144 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbfLLO7r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 09:59:47 -0500
Received: by mail-qt1-f196.google.com with SMTP id k11so2524852qtm.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 06:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bne6QclCdHVbeYrK9OqCGvDheWSNH24kX8Y3DsNcdIs=;
        b=Vs0irhNZRPP/xt+ksGWxEEK5nrgpPDI2BrwNayPgZpRdEple5n/CWBwYdwH/9luvOO
         of4YM8dRAN48lRFW18ijhJFtwdOLHMkC701z6rQeC+SfolS5oCtHk4QcNlS4IFkC4iMv
         FS4LtR4eQgmbSi2gulFdHLdepDPAyG6G/S3UCYgW46CSWQBLHxhjtBes0cF3tAEJSbWQ
         opvAUqHJKWHGUp7jJkZg0yhjaWRqB3L6WUFO/CCVoDBdETQUs73M0uR7tSwQn3P1TtvL
         k6nxCHCmob+rRfDSpI30Hz2NYOZ7+73V0ohEuvAQEhkTigVRsX/ngAiNhvyO4nSB45sU
         3k5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bne6QclCdHVbeYrK9OqCGvDheWSNH24kX8Y3DsNcdIs=;
        b=LRZ/jsvFRyJKZmhzreFaGAofnQI7Cfb1c3IV/JP9yV9r7zOEJ0E7ieIEqrThqlaC4N
         VNnGnL2BjN+r6BJ5Hx2umdeV98cNYAfucHOJNGQTviqPOY32OOklCEzDjYXlUgkPtuCU
         X9fb9KCVn7tPWSef4QpO3g5DkrQN1X7cPLCdZg0PXGs5xC1d324WfnW6op1TzbclXgoU
         cd76k03iLcVlsUxmcSOBmmDYYeEYNmlATeZLQ0gU5j0tgZ+A2c4v+rFADIPejrSRq51G
         wveexYKv91fzTXVtY7lG4hsKTTv4sT/YT3TSDhOPWlgJbOIqPTjq4fMQfjhZQElw5iSS
         saew==
X-Gm-Message-State: APjAAAWZN9HL5AJBoi/XVi/GwknvzsGgknOqG2h16J6zhSToyJ983hPm
        erpu7cZxDhmLwqkt8TWZviklZysAyS17WMu8SqvzTg==
X-Google-Smtp-Source: APXvYqwd5WR0vNqvP1XlKJhmS+nzT+JazIs9A6E74U80IlxebjOIog9rqWYrp5k21rknDbkFFqtEb3c68LPZBVhDcWY=
X-Received: by 2002:ac8:330d:: with SMTP id t13mr7684710qta.379.1576162785349;
 Thu, 12 Dec 2019 06:59:45 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <20191212093008.217086-3-Jason@zx2c4.com>
In-Reply-To: <20191212093008.217086-3-Jason@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 12 Dec 2019 15:59:34 +0100
Message-ID: <CAKv+Gu-JdxYpQDjiw5-mNo7QnDak5D--8HAtp-pyuPnRe18bjw@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 3/3] crypto: arm/arm64/mips/poly1305 -
 remove redundant non-reduction from emit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 12 Dec 2019 at 10:30, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> This appears to be some kind of copy and paste error, and is actually
> dead code.
>
> Pre: f =3D 0 =E2=87=92 (f >> 32) =3D 0
>     f =3D (f >> 32) + le32_to_cpu(digest[0]);
> Post: 0 =E2=89=A4 f < 2=C2=B3=C2=B2
>     put_unaligned_le32(f, dst);
>
> Pre: 0 =E2=89=A4 f < 2=C2=B3=C2=B2 =E2=87=92 (f >> 32) =3D 0
>     f =3D (f >> 32) + le32_to_cpu(digest[1]);
> Post: 0 =E2=89=A4 f < 2=C2=B3=C2=B2
>     put_unaligned_le32(f, dst + 4);
>
> Pre: 0 =E2=89=A4 f < 2=C2=B3=C2=B2 =E2=87=92 (f >> 32) =3D 0
>     f =3D (f >> 32) + le32_to_cpu(digest[2]);
> Post: 0 =E2=89=A4 f < 2=C2=B3=C2=B2
>     put_unaligned_le32(f, dst + 8);
>
> Pre: 0 =E2=89=A4 f < 2=C2=B3=C2=B2 =E2=87=92 (f >> 32) =3D 0
>     f =3D (f >> 32) + le32_to_cpu(digest[3]);
> Post: 0 =E2=89=A4 f < 2=C2=B3=C2=B2
>     put_unaligned_le32(f, dst + 12);
>
> Therefore this sequence is redundant. And Andy's code appears to handle
> misalignment acceptably.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

The change is obviously correct, but I ran it on a big-endian system
just to be sure.

Tested-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>  arch/arm/crypto/poly1305-glue.c   | 18 ++----------------
>  arch/arm64/crypto/poly1305-glue.c | 18 ++----------------
>  arch/mips/crypto/poly1305-glue.c  | 18 ++----------------
>  3 files changed, 6 insertions(+), 48 deletions(-)
>
> diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-g=
lue.c
> index abe3f2d587dc..ceec04ec2f40 100644
> --- a/arch/arm/crypto/poly1305-glue.c
> +++ b/arch/arm/crypto/poly1305-glue.c
> @@ -20,7 +20,7 @@
>
>  void poly1305_init_arm(void *state, const u8 *key);
>  void poly1305_blocks_arm(void *state, const u8 *src, u32 len, u32 hibit)=
;
> -void poly1305_emit_arm(void *state, __le32 *digest, const u32 *nonce);
> +void poly1305_emit_arm(void *state, u8 *digest, const u32 *nonce);
>
>  void __weak poly1305_blocks_neon(void *state, const u8 *src, u32 len, u3=
2 hibit)
>  {
> @@ -179,9 +179,6 @@ EXPORT_SYMBOL(poly1305_update_arch);
>
>  void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
>  {
> -       __le32 digest[4];
> -       u64 f =3D 0;
> -
>         if (unlikely(dctx->buflen)) {
>                 dctx->buf[dctx->buflen++] =3D 1;
>                 memset(dctx->buf + dctx->buflen, 0,
> @@ -189,18 +186,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *d=
ctx, u8 *dst)
>                 poly1305_blocks_arm(&dctx->h, dctx->buf, POLY1305_BLOCK_S=
IZE, 0);
>         }
>
> -       poly1305_emit_arm(&dctx->h, digest, dctx->s);
> -
> -       /* mac =3D (h + s) % (2^128) */
> -       f =3D (f >> 32) + le32_to_cpu(digest[0]);
> -       put_unaligned_le32(f, dst);
> -       f =3D (f >> 32) + le32_to_cpu(digest[1]);
> -       put_unaligned_le32(f, dst + 4);
> -       f =3D (f >> 32) + le32_to_cpu(digest[2]);
> -       put_unaligned_le32(f, dst + 8);
> -       f =3D (f >> 32) + le32_to_cpu(digest[3]);
> -       put_unaligned_le32(f, dst + 12);
> -
> +       poly1305_emit_arm(&dctx->h, dst, dctx->s);
>         *dctx =3D (struct poly1305_desc_ctx){};
>  }
>  EXPORT_SYMBOL(poly1305_final_arch);
> diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly13=
05-glue.c
> index 83a2338a8826..e97b092f56b8 100644
> --- a/arch/arm64/crypto/poly1305-glue.c
> +++ b/arch/arm64/crypto/poly1305-glue.c
> @@ -21,7 +21,7 @@
>  asmlinkage void poly1305_init_arm64(void *state, const u8 *key);
>  asmlinkage void poly1305_blocks(void *state, const u8 *src, u32 len, u32=
 hibit);
>  asmlinkage void poly1305_blocks_neon(void *state, const u8 *src, u32 len=
, u32 hibit);
> -asmlinkage void poly1305_emit(void *state, __le32 *digest, const u32 *no=
nce);
> +asmlinkage void poly1305_emit(void *state, u8 *digest, const u32 *nonce)=
;
>
>  static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
>
> @@ -162,9 +162,6 @@ EXPORT_SYMBOL(poly1305_update_arch);
>
>  void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
>  {
> -       __le32 digest[4];
> -       u64 f =3D 0;
> -
>         if (unlikely(dctx->buflen)) {
>                 dctx->buf[dctx->buflen++] =3D 1;
>                 memset(dctx->buf + dctx->buflen, 0,
> @@ -172,18 +169,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *d=
ctx, u8 *dst)
>                 poly1305_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE,=
 0);
>         }
>
> -       poly1305_emit(&dctx->h, digest, dctx->s);
> -
> -       /* mac =3D (h + s) % (2^128) */
> -       f =3D (f >> 32) + le32_to_cpu(digest[0]);
> -       put_unaligned_le32(f, dst);
> -       f =3D (f >> 32) + le32_to_cpu(digest[1]);
> -       put_unaligned_le32(f, dst + 4);
> -       f =3D (f >> 32) + le32_to_cpu(digest[2]);
> -       put_unaligned_le32(f, dst + 8);
> -       f =3D (f >> 32) + le32_to_cpu(digest[3]);
> -       put_unaligned_le32(f, dst + 12);
> -
> +       poly1305_emit(&dctx->h, dst, dctx->s);
>         *dctx =3D (struct poly1305_desc_ctx){};
>  }
>  EXPORT_SYMBOL(poly1305_final_arch);
> diff --git a/arch/mips/crypto/poly1305-glue.c b/arch/mips/crypto/poly1305=
-glue.c
> index b37d29cf5d0a..fc881b46d911 100644
> --- a/arch/mips/crypto/poly1305-glue.c
> +++ b/arch/mips/crypto/poly1305-glue.c
> @@ -15,7 +15,7 @@
>
>  asmlinkage void poly1305_init_mips(void *state, const u8 *key);
>  asmlinkage void poly1305_blocks_mips(void *state, const u8 *src, u32 len=
, u32 hibit);
> -asmlinkage void poly1305_emit_mips(void *state, __le32 *digest, const u3=
2 *nonce);
> +asmlinkage void poly1305_emit_mips(void *state, u8 *digest, const u32 *n=
once);
>
>  void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 *key)
>  {
> @@ -134,9 +134,6 @@ EXPORT_SYMBOL(poly1305_update_arch);
>
>  void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
>  {
> -       __le32 digest[4];
> -       u64 f =3D 0;
> -
>         if (unlikely(dctx->buflen)) {
>                 dctx->buf[dctx->buflen++] =3D 1;
>                 memset(dctx->buf + dctx->buflen, 0,
> @@ -144,18 +141,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *d=
ctx, u8 *dst)
>                 poly1305_blocks_mips(&dctx->h, dctx->buf, POLY1305_BLOCK_=
SIZE, 0);
>         }
>
> -       poly1305_emit_mips(&dctx->h, digest, dctx->s);
> -
> -       /* mac =3D (h + s) % (2^128) */
> -       f =3D (f >> 32) + le32_to_cpu(digest[0]);
> -       put_unaligned_le32(f, dst);
> -       f =3D (f >> 32) + le32_to_cpu(digest[1]);
> -       put_unaligned_le32(f, dst + 4);
> -       f =3D (f >> 32) + le32_to_cpu(digest[2]);
> -       put_unaligned_le32(f, dst + 8);
> -       f =3D (f >> 32) + le32_to_cpu(digest[3]);
> -       put_unaligned_le32(f, dst + 12);
> -
> +       poly1305_emit_mips(&dctx->h, dst, dctx->s);
>         *dctx =3D (struct poly1305_desc_ctx){};
>  }
>  EXPORT_SYMBOL(poly1305_final_arch);
> --
> 2.24.0
>

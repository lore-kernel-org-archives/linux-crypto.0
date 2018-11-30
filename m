Return-Path: <SRS0=r27M=OJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25067C04EB8
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Nov 2018 12:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C361A20863
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Nov 2018 12:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gUFvPZMA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C361A20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbeLAAHh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Nov 2018 19:07:37 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:39813 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeLAAHh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 19:07:37 -0500
Received: by mail-it1-f193.google.com with SMTP id a6so9004179itl.4
        for <linux-crypto@vger.kernel.org>; Fri, 30 Nov 2018 04:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z1o0tHX0ltNvSQAJmed29mgn/IROdSgmFErNTN/AroA=;
        b=gUFvPZMAbmHfLFaWN4Lttc0befn9uOiBjjekNcxoZVn42huhPDX/9e2+XvA/gkA4cQ
         yD6jN1/5zb6nk1+bNcqUPkhoIztd0MYNxPI4o0f3BuO71lrbQCB7KFag3BhnRsbyWrks
         Hsg05eGOR/NnrEuwTIjRk50pSOorTBFT7/NNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z1o0tHX0ltNvSQAJmed29mgn/IROdSgmFErNTN/AroA=;
        b=kOQrBTrnEGGxTJkRG+zAgqXqHK7sore1VP4FjPvCTpqM319KIWDHvUooBrid2+tMZh
         vMR+qnLjp3ofkW9kVa+lq0STBcvAwffG8R40ZO2xYhqmVeVitVAkcC1pnIssBJGu70Wy
         q1FmjUbZrQMAh4Ei92LI1RYt9NKTWOpCNyuNDOKM33HyhKuM65ZH79wkRclXyIeNeaHi
         ZEd8hqctjinQIjyyna3vW6jjIcn2QUzbcRDjh6OXi//iZw8/KWiyeCMaDAYmnq4Ni647
         OwPY9fNeFHvba39r1nduzcQDojiF1OKtY2w29fPrUthc2oa6wcbMBMRc5xO4UMYiCw/6
         6wgg==
X-Gm-Message-State: AA+aEWaNzUoApuSMO+xhRaAwIyTMFiTEGwEU+FteX789LUOtHpiy4F1s
        o7jTSvZLZPVI1BhjyI+Vpnp8fO/no5YwYWKLOih0Ug==
X-Google-Smtp-Source: AFSGD/XAHTOSD3oGQJjeQpVVbLt5ydp3NSc7Vh1XDBlhmTNf6aYKJ/Bj4WjAwE2QCBvRJZjBmmFsft1XP2kx0IeyKbY=
X-Received: by 2002:a02:4c9:: with SMTP id 192mr4905516jab.2.1543582702425;
 Fri, 30 Nov 2018 04:58:22 -0800 (PST)
MIME-Version: 1.0
References: <20181129063422.24307-1-ebiggers@kernel.org> <20181129063422.24307-2-ebiggers@kernel.org>
In-Reply-To: <20181129063422.24307-2-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 30 Nov 2018 13:58:09 +0100
Message-ID:
 <CAKv+Gu_PqnwYGfjEaG8Fh8bgbPWA+ymG27ky1uaScr9OohZUzw@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181130125809.jBTvXzEMyhRw0MDTCT5tcwZ_Wogrd2WiQ74UmuvmmiU@z>

On Thu, 29 Nov 2018 at 07:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add an ARM64 NEON implementation of NHPoly1305, an =CE=B5-almost-=E2=88=
=86-universal
> hash function used in the Adiantum encryption mode.  For now, only the
> NH portion is actually NEON-accelerated; the Poly1305 part is less
> performance-critical so is just implemented in C.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm64/crypto/Kconfig                |   5 ++
>  arch/arm64/crypto/Makefile               |   3 +
>  arch/arm64/crypto/nh-neon-core.S         | 103 +++++++++++++++++++++++
>  arch/arm64/crypto/nhpoly1305-neon-glue.c |  77 +++++++++++++++++
>  4 files changed, 188 insertions(+)
>  create mode 100644 arch/arm64/crypto/nh-neon-core.S
>  create mode 100644 arch/arm64/crypto/nhpoly1305-neon-glue.c
>
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index a5606823ed4da..3f5aeb786192b 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -106,6 +106,11 @@ config CRYPTO_CHACHA20_NEON
>         select CRYPTO_BLKCIPHER
>         select CRYPTO_CHACHA20
>
> +config CRYPTO_NHPOLY1305_NEON
> +       tristate "NHPoly1305 hash function using NEON instructions (for A=
diantum)"
> +       depends on KERNEL_MODE_NEON
> +       select CRYPTO_NHPOLY1305
> +
>  config CRYPTO_AES_ARM64_BS
>         tristate "AES in ECB/CBC/CTR/XTS modes using bit-sliced NEON algo=
rithm"
>         depends on KERNEL_MODE_NEON
> diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
> index f476fede09ba4..125dbb10a93ed 100644
> --- a/arch/arm64/crypto/Makefile
> +++ b/arch/arm64/crypto/Makefile
> @@ -53,6 +53,9 @@ sha512-arm64-y :=3D sha512-glue.o sha512-core.o
>  obj-$(CONFIG_CRYPTO_CHACHA20_NEON) +=3D chacha20-neon.o
>  chacha20-neon-y :=3D chacha20-neon-core.o chacha20-neon-glue.o
>
> +obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) +=3D nhpoly1305-neon.o
> +nhpoly1305-neon-y :=3D nh-neon-core.o nhpoly1305-neon-glue.o
> +
>  obj-$(CONFIG_CRYPTO_AES_ARM64) +=3D aes-arm64.o
>  aes-arm64-y :=3D aes-cipher-core.o aes-cipher-glue.o
>
> diff --git a/arch/arm64/crypto/nh-neon-core.S b/arch/arm64/crypto/nh-neon=
-core.S
> new file mode 100644
> index 0000000000000..e08d57676127a
> --- /dev/null
> +++ b/arch/arm64/crypto/nh-neon-core.S
> @@ -0,0 +1,103 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * NH - =CE=B5-almost-universal hash function, ARM64 NEON accelerated ve=
rsion
> + *
> + * Copyright 2018 Google LLC
> + *
> + * Author: Eric Biggers <ebiggers@google.com>
> + */
> +
> +#include <linux/linkage.h>
> +
> +       KEY             .req    x0
> +       MESSAGE         .req    x1
> +       MESSAGE_LEN     .req    x2
> +       HASH            .req    x3
> +
> +       PASS0_SUMS      .req    v0
> +       PASS1_SUMS      .req    v1
> +       PASS2_SUMS      .req    v2
> +       PASS3_SUMS      .req    v3
> +       K0              .req    v4
> +       K1              .req    v5
> +       K2              .req    v6
> +       K3              .req    v7
> +       T0              .req    v8
> +       T1              .req    v9
> +       T2              .req    v10
> +       T3              .req    v11
> +       T4              .req    v12
> +       T5              .req    v13
> +       T6              .req    v14
> +       T7              .req    v15
> +
> +.macro _nh_stride      k0, k1, k2, k3
> +
> +       // Load next message stride
> +       ld1             {T3.16b}, [MESSAGE], #16
> +
> +       // Load next key stride
> +       ld1             {\k3\().4s}, [KEY], #16
> +
> +       // Add message words to key words
> +       add             T0.4s, T3.4s, \k0\().4s
> +       add             T1.4s, T3.4s, \k1\().4s
> +       add             T2.4s, T3.4s, \k2\().4s
> +       add             T3.4s, T3.4s, \k3\().4s
> +
> +       // Multiply 32x32 =3D> 64 and accumulate
> +       mov             T4.d[0], T0.d[1]
> +       mov             T5.d[0], T1.d[1]
> +       mov             T6.d[0], T2.d[1]
> +       mov             T7.d[0], T3.d[1]

Nit: gmail mangles the whitespace anyway, but in the patch, there is
some whitespace damage here

With that fixed,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> # big-endian


> +       umlal           PASS0_SUMS.2d, T0.2s, T4.2s
> +       umlal           PASS1_SUMS.2d, T1.2s, T5.2s
> +       umlal           PASS2_SUMS.2d, T2.2s, T6.2s
> +       umlal           PASS3_SUMS.2d, T3.2s, T7.2s
> +.endm
> +
> +/*
> + * void nh_neon(const u32 *key, const u8 *message, size_t message_len,
> + *             u8 hash[NH_HASH_BYTES])
> + *
> + * It's guaranteed that message_len % 16 =3D=3D 0.
> + */
> +ENTRY(nh_neon)
> +
> +       ld1             {K0.4s,K1.4s}, [KEY], #32
> +         movi          PASS0_SUMS.2d, #0
> +         movi          PASS1_SUMS.2d, #0
> +       ld1             {K2.4s}, [KEY], #16
> +         movi          PASS2_SUMS.2d, #0
> +         movi          PASS3_SUMS.2d, #0
> +
> +       subs            MESSAGE_LEN, MESSAGE_LEN, #64
> +       blt             .Lloop4_done
> +.Lloop4:
> +       _nh_stride      K0, K1, K2, K3
> +       _nh_stride      K1, K2, K3, K0
> +       _nh_stride      K2, K3, K0, K1
> +       _nh_stride      K3, K0, K1, K2
> +       subs            MESSAGE_LEN, MESSAGE_LEN, #64
> +       bge             .Lloop4
> +
> +.Lloop4_done:
> +       ands            MESSAGE_LEN, MESSAGE_LEN, #63
> +       beq             .Ldone
> +       _nh_stride      K0, K1, K2, K3
> +
> +       subs            MESSAGE_LEN, MESSAGE_LEN, #16
> +       beq             .Ldone
> +       _nh_stride      K1, K2, K3, K0
> +
> +       subs            MESSAGE_LEN, MESSAGE_LEN, #16
> +       beq             .Ldone
> +       _nh_stride      K2, K3, K0, K1
> +
> +.Ldone:
> +       // Sum the accumulators for each pass, then store the sums to 'ha=
sh'
> +       addp            T0.2d, PASS0_SUMS.2d, PASS1_SUMS.2d
> +       addp            T1.2d, PASS2_SUMS.2d, PASS3_SUMS.2d
> +       st1             {T0.16b,T1.16b}, [HASH]
> +       ret
> +ENDPROC(nh_neon)
> diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto=
/nhpoly1305-neon-glue.c
> new file mode 100644
> index 0000000000000..22cc32ac9448d
> --- /dev/null
> +++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * NHPoly1305 - =CE=B5-almost-=E2=88=86-universal hash function for Adia=
ntum
> + * (ARM64 NEON accelerated version)
> + *
> + * Copyright 2018 Google LLC
> + */
> +
> +#include <asm/neon.h>
> +#include <asm/simd.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/nhpoly1305.h>
> +#include <linux/module.h>
> +
> +asmlinkage void nh_neon(const u32 *key, const u8 *message, size_t messag=
e_len,
> +                       u8 hash[NH_HASH_BYTES]);
> +
> +/* wrapper to avoid indirect call to assembly, which doesn't work with C=
FI */
> +static void _nh_neon(const u32 *key, const u8 *message, size_t message_l=
en,
> +                    __le64 hash[NH_NUM_PASSES])
> +{
> +       nh_neon(key, message, message_len, (u8 *)hash);
> +}
> +
> +static int nhpoly1305_neon_update(struct shash_desc *desc,
> +                                 const u8 *src, unsigned int srclen)
> +{
> +       if (srclen < 64 || !may_use_simd())
> +               return crypto_nhpoly1305_update(desc, src, srclen);
> +
> +       do {
> +               unsigned int n =3D min_t(unsigned int, srclen, PAGE_SIZE)=
;
> +
> +               kernel_neon_begin();
> +               crypto_nhpoly1305_update_helper(desc, src, n, _nh_neon);
> +               kernel_neon_end();
> +               src +=3D n;
> +               srclen -=3D n;
> +       } while (srclen);
> +       return 0;
> +}
> +
> +static struct shash_alg nhpoly1305_alg =3D {
> +       .base.cra_name          =3D "nhpoly1305",
> +       .base.cra_driver_name   =3D "nhpoly1305-neon",
> +       .base.cra_priority      =3D 200,
> +       .base.cra_ctxsize       =3D sizeof(struct nhpoly1305_key),
> +       .base.cra_module        =3D THIS_MODULE,
> +       .digestsize             =3D POLY1305_DIGEST_SIZE,
> +       .init                   =3D crypto_nhpoly1305_init,
> +       .update                 =3D nhpoly1305_neon_update,
> +       .final                  =3D crypto_nhpoly1305_final,
> +       .setkey                 =3D crypto_nhpoly1305_setkey,
> +       .descsize               =3D sizeof(struct nhpoly1305_state),
> +};
> +
> +static int __init nhpoly1305_mod_init(void)
> +{
> +       if (!(elf_hwcap & HWCAP_ASIMD))
> +               return -ENODEV;
> +
> +       return crypto_register_shash(&nhpoly1305_alg);
> +}
> +
> +static void __exit nhpoly1305_mod_exit(void)
> +{
> +       crypto_unregister_shash(&nhpoly1305_alg);
> +}
> +
> +module_init(nhpoly1305_mod_init);
> +module_exit(nhpoly1305_mod_exit);
> +
> +MODULE_DESCRIPTION("NHPoly1305 =CE=B5-almost-=E2=88=86-universal hash fu=
nction (NEON-accelerated)");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
> +MODULE_ALIAS_CRYPTO("nhpoly1305");
> +MODULE_ALIAS_CRYPTO("nhpoly1305-neon");
> --
> 2.19.2
>

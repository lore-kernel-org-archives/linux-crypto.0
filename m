Return-Path: <SRS0=r3Tc=N4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1552C43441
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Nov 2018 02:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B43A2086B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Nov 2018 02:01:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZtciWDRn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B43A2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbeKQMPw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Nov 2018 07:15:52 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:40279 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729793AbeKQMPw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 07:15:52 -0500
Received: by mail-it1-f194.google.com with SMTP id h193so43879ita.5
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 18:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n6h0g/OCAOkraLVmsoOXh7wZeywX4llmGcOd4QSpl20=;
        b=ZtciWDRnKhObQEj67xP5oexksLu1+iEKQd8ISI5XBC3z1XhgFUrCDaVHjp2KKT8jnH
         /Z0CPyMOKiBwoFlmalwQy06f1FxI82oEzD998BSkKiW+XIlF1u1hs+vzxYnfnmCdXbFH
         wPhNqaFjrUg6z4i8DB9XT4SdiQEs3VLcER9Ng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n6h0g/OCAOkraLVmsoOXh7wZeywX4llmGcOd4QSpl20=;
        b=VvTINowjT+8FO/CtrAJ8o7BiGbICGc2QFHJUWULlrlwNv399LuDs4htQl5KnChfCuQ
         zcjTCfZ3rrOAcvHW2TDEtRGEAUyoaM4hr8pmfmtnhY5iIcrQC8rFxw/y0l/h3Ks2c0r0
         mFT8I+UhxeyDQM1zVM65gN6epXcVWPaAgtKHIwjIUVCS90CzJuvI/HEEZ952jnxzcguN
         +ujl4esGRyCO8MwHqo8kPEbDuSagb6YS3qRCYp9N9n5Xr6oLs3WlGyf/Ru81TYA4xOx2
         /VuPTYfmR17vQ7j6zMXtBvi1XXpEucsjzTkk/5PYY15pXhGJYX4a1DbWIMCbIx4sS0MT
         g+ug==
X-Gm-Message-State: AA+aEWawJXNkl+prM9QxM7N/cgcteyLVpUPpE7+9fmlgykCu39l1gTfe
        o7rF2bBPJse9dmwyYIQXL2FocyhbJ/jEB+v+DAFoNA==
X-Google-Smtp-Source: AFSGD/XvuY4Ix6Wu1tgVxPpGDzg2KiQa4l/gqyG2KlrGTh43CzQvUvrFqxmbpq9Afom49/XXtYJsMjmwcKKUGpsgx/c=
X-Received: by 2002:a24:7d8d:: with SMTP id b135-v6mr542866itc.121.1542420060424;
 Fri, 16 Nov 2018 18:01:00 -0800 (PST)
MIME-Version: 1.0
References: <20181117012631.23528-1-ebiggers@kernel.org> <20181117012631.23528-14-ebiggers@kernel.org>
In-Reply-To: <20181117012631.23528-14-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 16 Nov 2018 18:00:49 -0800
Message-ID:
 <CAKv+Gu92imD=X-4ExxQH-KOkitUr04GGenYb59yDwBPRhLf3dw@mail.gmail.com>
Subject: Re: [PATCH v4 13/14] crypto: arm/nhpoly1305 - add NEON-accelerated NHPoly1305
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181117020049.ul5xFP1XIPYg1_f9D2o8qzZNUN8MrATDyeNxcgQooUM@z>

On Fri, 16 Nov 2018 at 17:29, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add an ARM NEON implementation of NHPoly1305, an =CE=B5-almost-=E2=88=86-=
universal
> hash function used in the Adiantum encryption mode.  For now, only the
> NH portion is actually NEON-accelerated; the Poly1305 part is less
> performance-critical so is just implemented in C.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/Kconfig                |   5 ++
>  arch/arm/crypto/Makefile               |   2 +
>  arch/arm/crypto/nh-neon-core.S         | 116 +++++++++++++++++++++++++
>  arch/arm/crypto/nhpoly1305-neon-glue.c |  77 ++++++++++++++++
>  4 files changed, 200 insertions(+)
>  create mode 100644 arch/arm/crypto/nh-neon-core.S
>  create mode 100644 arch/arm/crypto/nhpoly1305-neon-glue.c
>
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 59c674cf08ef..a95322b59799 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -131,4 +131,9 @@ config CRYPTO_CHACHA20_NEON
>         select CRYPTO_BLKCIPHER
>         select CRYPTO_CHACHA20
>
> +config CRYPTO_NHPOLY1305_NEON
> +       tristate "NEON accelerated NHPoly1305 hash function (for Adiantum=
)"
> +       depends on KERNEL_MODE_NEON
> +       select CRYPTO_NHPOLY1305
> +
>  endif
> diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
> index 005482ff9504..b65d6bfab8e6 100644
> --- a/arch/arm/crypto/Makefile
> +++ b/arch/arm/crypto/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) +=3D sha1-arm-neon.o
>  obj-$(CONFIG_CRYPTO_SHA256_ARM) +=3D sha256-arm.o
>  obj-$(CONFIG_CRYPTO_SHA512_ARM) +=3D sha512-arm.o
>  obj-$(CONFIG_CRYPTO_CHACHA20_NEON) +=3D chacha-neon.o
> +obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) +=3D nhpoly1305-neon.o
>
>  ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) +=3D aes-arm-ce.o
>  ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) +=3D sha1-arm-ce.o
> @@ -53,6 +54,7 @@ ghash-arm-ce-y        :=3D ghash-ce-core.o ghash-ce-glu=
e.o
>  crct10dif-arm-ce-y     :=3D crct10dif-ce-core.o crct10dif-ce-glue.o
>  crc32-arm-ce-y:=3D crc32-ce-core.o crc32-ce-glue.o
>  chacha-neon-y :=3D chacha-neon-core.o chacha-neon-glue.o
> +nhpoly1305-neon-y :=3D nh-neon-core.o nhpoly1305-neon-glue.o
>
>  ifdef REGENERATE_ARM_CRYPTO
>  quiet_cmd_perl =3D PERL    $@
> diff --git a/arch/arm/crypto/nh-neon-core.S b/arch/arm/crypto/nh-neon-cor=
e.S
> new file mode 100644
> index 000000000000..434d80ab531c
> --- /dev/null
> +++ b/arch/arm/crypto/nh-neon-core.S
> @@ -0,0 +1,116 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * NH - =CE=B5-almost-universal hash function, NEON accelerated version
> + *
> + * Copyright 2018 Google LLC
> + *
> + * Author: Eric Biggers <ebiggers@google.com>
> + */
> +
> +#include <linux/linkage.h>
> +
> +       .text
> +       .fpu            neon
> +
> +       KEY             .req    r0
> +       MESSAGE         .req    r1
> +       MESSAGE_LEN     .req    r2
> +       HASH            .req    r3
> +
> +       PASS0_SUMS      .req    q0
> +       PASS0_SUM_A     .req    d0
> +       PASS0_SUM_B     .req    d1
> +       PASS1_SUMS      .req    q1
> +       PASS1_SUM_A     .req    d2
> +       PASS1_SUM_B     .req    d3
> +       PASS2_SUMS      .req    q2
> +       PASS2_SUM_A     .req    d4
> +       PASS2_SUM_B     .req    d5
> +       PASS3_SUMS      .req    q3
> +       PASS3_SUM_A     .req    d6
> +       PASS3_SUM_B     .req    d7
> +       K0              .req    q4
> +       K1              .req    q5
> +       K2              .req    q6
> +       K3              .req    q7
> +       T0              .req    q8
> +       T0_L            .req    d16
> +       T0_H            .req    d17
> +       T1              .req    q9
> +       T1_L            .req    d18
> +       T1_H            .req    d19
> +       T2              .req    q10
> +       T2_L            .req    d20
> +       T2_H            .req    d21
> +       T3              .req    q11
> +       T3_L            .req    d22
> +       T3_H            .req    d23
> +
> +.macro _nh_stride      k0, k1, k2, k3
> +
> +       // Load next message stride
> +       vld1.8          {T3}, [MESSAGE]!
> +
> +       // Load next key stride
> +       vld1.32         {\k3}, [KEY]!
> +
> +       // Add message words to key words
> +       vadd.u32        T0, T3, \k0
> +       vadd.u32        T1, T3, \k1
> +       vadd.u32        T2, T3, \k2
> +       vadd.u32        T3, T3, \k3
> +
> +       // Multiply 32x32 =3D> 64 and accumulate
> +       vmlal.u32       PASS0_SUMS, T0_L, T0_H
> +       vmlal.u32       PASS1_SUMS, T1_L, T1_H
> +       vmlal.u32       PASS2_SUMS, T2_L, T2_H
> +       vmlal.u32       PASS3_SUMS, T3_L, T3_H
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
> +       vld1.32         {K0,K1}, [KEY]!
> +         vmov.u64      PASS0_SUMS, #0
> +         vmov.u64      PASS1_SUMS, #0
> +       vld1.32         {K2}, [KEY]!
> +         vmov.u64      PASS2_SUMS, #0
> +         vmov.u64      PASS3_SUMS, #0
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
> +       vadd.u64        T0_L, PASS0_SUM_A, PASS0_SUM_B
> +       vadd.u64        T0_H, PASS1_SUM_A, PASS1_SUM_B
> +       vadd.u64        T1_L, PASS2_SUM_A, PASS2_SUM_B
> +       vadd.u64        T1_H, PASS3_SUM_A, PASS3_SUM_B
> +       vst1.8          {T0-T1}, [HASH]
> +       bx              lr
> +ENDPROC(nh_neon)
> diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhp=
oly1305-neon-glue.c
> new file mode 100644
> index 000000000000..49aae87cb2bc
> --- /dev/null
> +++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * NHPoly1305 - =CE=B5-almost-=E2=88=86-universal hash function for Adia=
ntum
> + * (NEON accelerated version)
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
> +       if (!(elf_hwcap & HWCAP_NEON))
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
> 2.19.1.1215.g8438c0b245-goog
>

Return-Path: <SRS0=/kEc=EJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD047C388F9
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 14:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883F122370
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604414166;
	bh=rYubB5AU1HHQFEAtNG40roH8MILgTEAsuBRkjv3IjHI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=YwcomD10n/971b5MReTaC5RhC869VyPfCQkwzh+RvSVyRz9twdALRizDvDY/4F147
	 MSAeR4PNWk2Bxhsvx79LL5AACXjW8W5Os/NWyZ7gZY/Kq8m3AS4MLPDtPfp0hCDsR3
	 Jxq/O0VZFeSaVDJmPZkv08z151qt504i5IgYkJAw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgKCOgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgKCOel (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Nov 2020 09:34:41 -0500
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25E922370
        for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2020 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604414079;
        bh=rYubB5AU1HHQFEAtNG40roH8MILgTEAsuBRkjv3IjHI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A2Q8OpCSWCsVWMsAnzfdES+FpwTap9omOycnD2R3UdEYGy7aPbU5CQGFL9JnhOLDa
         xz3nfzJ20326zSkIwZG94OXKho1kkbihhVifdVPeOCJVyg+Ifh6zwIsUCEktLq3wwc
         4e/m6VpCfF/IAka2aeleZQqQKnXc7AcCSH6rTNNU=
Received: by mail-ot1-f42.google.com with SMTP id n15so16102243otl.8
        for <linux-crypto@vger.kernel.org>; Tue, 03 Nov 2020 06:34:39 -0800 (PST)
X-Gm-Message-State: AOAM533345DwzesDZuUgKp/yJYpSii1BVqxJ2QUwwMK+rNvptpCtW6u+
        3kf63AvPsElH0ChSOIL7iNlXaaKpmOpoB3jw5aY=
X-Google-Smtp-Source: ABdhPJzy/a4Pe6QCPXkdEosafOsgCJ1nmiDzO/jxcxL5vqTSQY1IQuugAFvQhDOH3hNmXIRQaeVkx5+AL37YuInV1FE=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr14990409ots.90.1604414078948;
 Tue, 03 Nov 2020 06:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20201103121506.1533-1-liqiang64@huawei.com> <20201103121506.1533-2-liqiang64@huawei.com>
In-Reply-To: <20201103121506.1533-2-liqiang64@huawei.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 3 Nov 2020 15:34:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
Message-ID: <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE instructions.
To:     l00374334 <liqiang64@huawei.com>, Dave Martin <Dave.Martin@arm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Dave)

Hello liqiang,

First of all, I don't think it is safe at the moment to use SVE in the
kernel, as we don't preserve all state IIRC. My memory is a bit hazy,
though, so perhaps Dave can elaborate?

I'll give my feedback on the code itself below, but please don't
consider this an ack on the intent of using SVE in the kernel.

Could you explain why SVE is so much better than NEON here?

On Tue, 3 Nov 2020 at 13:16, l00374334 <liqiang64@huawei.com> wrote:
>
> From: liqiang <liqiang64@huawei.com>
>
>         In the libz library, the checksum algorithm adler32 usually occupies
>         a relatively high hot spot, and the SVE instruction set can easily
>         accelerate it, so that the performance of libz library will be
>         significantly improved.
>
>         We can divides buf into blocks according to the bit width of SVE,
>         and then uses vector registers to perform operations in units of blocks
>         to achieve the purpose of acceleration.
>
>         On machines that support ARM64 sve instructions, this algorithm is
>         about 3~4 times faster than the algorithm implemented in C language
>         in libz. The wider the SVE instruction, the better the acceleration effect.
>
>         Measured on a Taishan 1951 machine that supports 256bit width SVE,
>         below are the results of my measured random data of 1M and 10M:
>
>                 [root@xxx adler32]# ./benchmark 1000000
>                 Libz alg: Time used:    608 us, 1644.7 Mb/s.
>                 SVE  alg: Time used:    166 us, 6024.1 Mb/s.
>
>                 [root@xxx adler32]# ./benchmark 10000000
>                 Libz alg: Time used:   6484 us, 1542.3 Mb/s.
>                 SVE  alg: Time used:   2034 us, 4916.4 Mb/s.
>
>         The blocks can be of any size, so the algorithm can automatically adapt
>         to SVE hardware with different bit widths without modifying the code.
>

Please drop this indentation from the commit log.

>
> Signed-off-by: liqiang <liqiang64@huawei.com>
> ---
>  arch/arm64/crypto/Kconfig            |   5 ++
>  arch/arm64/crypto/Makefile           |   3 +
>  arch/arm64/crypto/adler32-sve-glue.c |  93 ++++++++++++++++++++
>  arch/arm64/crypto/adler32-sve.S      | 127 +++++++++++++++++++++++++++
>  crypto/testmgr.c                     |   8 +-
>  crypto/testmgr.h                     |  13 +++

Please split into two patches. Also, who is going to use this "adler32" shash?

>  6 files changed, 248 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/crypto/adler32-sve-glue.c
>  create mode 100644 arch/arm64/crypto/adler32-sve.S
>
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index b8eb045..cfe58b9 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -126,4 +126,9 @@ config CRYPTO_AES_ARM64_BS
>         select CRYPTO_LIB_AES
>         select CRYPTO_SIMD
>
> +config SVE_ADLER32
> +       tristate "Accelerate Adler32 using arm64 SVE instructions."
> +       depends on ARM64_SVE
> +       select CRYPTO_HASH
> +
>  endif
> diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
> index d0901e6..45fe649 100644
> --- a/arch/arm64/crypto/Makefile
> +++ b/arch/arm64/crypto/Makefile
> @@ -63,6 +63,9 @@ aes-arm64-y := aes-cipher-core.o aes-cipher-glue.o
>  obj-$(CONFIG_CRYPTO_AES_ARM64_BS) += aes-neon-bs.o
>  aes-neon-bs-y := aes-neonbs-core.o aes-neonbs-glue.o
>
> +obj-$(CONFIG_SVE_ADLER32) += sve-adler32.o
> +sve-adler32-y := adler32-sve.o adler32-sve-glue.o
> +
>  CFLAGS_aes-glue-ce.o   := -DUSE_V8_CRYPTO_EXTENSIONS
>
>  $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
> diff --git a/arch/arm64/crypto/adler32-sve-glue.c b/arch/arm64/crypto/adler32-sve-glue.c
> new file mode 100644
> index 0000000..cb74514
> --- /dev/null
> +++ b/arch/arm64/crypto/adler32-sve-glue.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Accelerate Adler32 using arm64 SVE instructions.
> + * Automatically support all bit width of SVE
> + * vector(128~2048).
> + *
> + * Copyright (C) 2020 Huawei Technologies Co., Ltd.
> + *
> + * Author: Li Qiang <liqiang64@huawei.com>
> + */
> +#include <linux/cpufeature.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/zutil.h>
> +
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
> +
> +#include <asm/neon.h>
> +#include <asm/simd.h>
> +
> +/* Scalable vector extension min size 128bit */
> +#define SVE_ADLER32_MIN_SIZE 16U
> +#define SVE_ADLER32_DIGEST_SIZE 4
> +#define SVE_ADLER32_BLOCKSIZE 1
> +
> +asmlinkage u32 adler32_sve(u32 adler, const u8 *buf, u32 len);
> +
> +static int adler32_sve_init(struct shash_desc *desc)
> +{
> +       u32 *adler32 = shash_desc_ctx(desc);
> +
> +       *adler32 = 1;
> +       return 0;
> +}
> +
> +static int adler32_sve_update(struct shash_desc *desc, const u8 *data,
> +                                 unsigned int length)

Please indent function parameters

> +{
> +       u32 *adler32 = shash_desc_ctx(desc);
> +
> +       if (length >= SVE_ADLER32_MIN_SIZE && crypto_simd_usable()) {
> +               kernel_neon_begin();
> +               *adler32 = adler32_sve(*adler32, data, length);
> +               kernel_neon_end();
> +       } else {
> +               *adler32 = zlib_adler32(*adler32, data, length);
> +       }
> +       return 0;
> +}
> +
> +static int adler32_sve_final(struct shash_desc *desc, u8 *out)
> +{
> +       u32 *adler32 = shash_desc_ctx(desc);
> +
> +       *(u32 *)out = *adler32;

Please use put_unaligned here

> +       return 0;
> +}
> +
> +static struct shash_alg adler32_sve_alg[] = {{
> +       .digestsize                             = SVE_ADLER32_DIGEST_SIZE,
> +       .descsize                               = SVE_ADLER32_DIGEST_SIZE,
> +       .init                                   = adler32_sve_init,
> +       .update                                 = adler32_sve_update,
> +       .final                                  = adler32_sve_final,
> +
> +       .base.cra_name                  = "adler32",
> +       .base.cra_driver_name   = "adler32-arm64-sve",
> +       .base.cra_priority              = 200,
> +       .base.cra_blocksize             = SVE_ADLER32_BLOCKSIZE,
> +       .base.cra_module                = THIS_MODULE,

Please make sure the indentation is correct here.

> +}};
> +
> +static int __init adler32_sve_mod_init(void)
> +{
> +       if (!cpu_have_named_feature(SVE))
> +               return 0;
> +
> +       return crypto_register_shash(adler32_sve_alg);
> +}
> +
> +static void __exit adler32_sve_mod_exit(void)
> +{
> +       crypto_unregister_shash(adler32_sve_alg);
> +}
> +
> +module_init(adler32_sve_mod_init);
> +module_exit(adler32_sve_mod_exit);
> +
> +MODULE_AUTHOR("Li Qiang <liqiang64@huawei.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS_CRYPTO("adler32");
> +MODULE_ALIAS_CRYPTO("adler32-arm64-sve");
> diff --git a/arch/arm64/crypto/adler32-sve.S b/arch/arm64/crypto/adler32-sve.S
> new file mode 100644
> index 0000000..34ee4bb
> --- /dev/null
> +++ b/arch/arm64/crypto/adler32-sve.S
> @@ -0,0 +1,127 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Accelerate Adler32 using arm64 SVE instructions. Automatically support all bit
> + *      width of SVE vector(128~2048).
> + *
> + * Copyright (C) 2020 Huawei Technologies Co., Ltd.
> + *
> + * Author: Li Qiang <liqiang64@huawei.com>
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +
> +.arch armv8-a+sve
> +.file "adler32_sve.S"

Drop the .file

Please indent the rest 1 tab

> +.text
> +.align 6
> +
> +//The supported sve vector length range is 128~2048 by this Adler_sequence
> +.Adler_sequence:

This should be in .rodata. Also, if you use . or L prefixes, use .L
because that is what you need to make these local symbols.


> +       .short 256,255,254,253,252,251,250,249,248,247,246,245,244,243,242,241
> +       .short 240,239,238,237,236,235,234,233,232,231,230,229,228,227,226,225
> +       .short 224,223,222,221,220,219,218,217,216,215,214,213,212,211,210,209
> +       .short 208,207,206,205,204,203,202,201,200,199,198,197,196,195,194,193
> +       .short 192,191,190,189,188,187,186,185,184,183,182,181,180,179,178,177
> +       .short 176,175,174,173,172,171,170,169,168,167,166,165,164,163,162,161
> +       .short 160,159,158,157,156,155,154,153,152,151,150,149,148,147,146,145
> +       .short 144,143,142,141,140,139,138,137,136,135,134,133,132,131,130,129
> +       .short 128,127,126,125,124,123,122,121,120,119,118,117,116,115,114,113
> +       .short 112,111,110,109,108,107,106,105,104,103,102,101,100, 99, 98, 97
> +       .short  96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81
> +       .short  80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65
> +       .short  64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49
> +       .short  48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33
> +       .short  32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17
> +       .short  16, 15, 14, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1
> +
> +SYM_FUNC_START(adler32_sve)
> +       and w10, w0, #0xffff
> +       lsr w11, w0, #16
> +

Please put the instruction mnemonics in different columns using tabs

> +       // Get the length of the sve vector to x6.
> +       mov x6, #0
> +       mov x9, #256
> +       addvl x6, x6, #1
> +       adr x12, .Adler_sequence
> +       ptrue p1.h
> +
> +       // Get the starting position of the required sequence.
> +       sub x9, x9, x6
> +       ld1h z24.h, p1/z, [x12, x9, lsl #1] // taps1 to z24.h
> +       inch x9
> +       ld1h z25.h, p1/z, [x12, x9, lsl #1] // taps2 to z25.h
> +       mov x9, #0
> +       // A little of byte, jumper to normal proc

What does this comment mean?

> +       mov x14, #3
> +       mul x15, x14, x6
> +       cmp x2, x15
> +       b.le Lnormal_proc
> +
> +       ptrue p0.b
> +.align 6

Ident.

> +LBig_loop:

Use .L prefix

> +       // x is SVE vector length (byte).
> +       // Bn = Bn-1 + An-1 * x + x * D1 + (x-1) * D2 + ... + 1 * Dx
> +       // An = An-1 + D1 + D2 + D3 + ... + Dx
> +
> +       .macro ADLER_BLOCK_X

Please use lower case for asm macros, to distinguish them from CPP macros
Also, indent the name, and move the macro out of the function for legibility.

> +       ld1b z0.b, p0/z, [x1, x9]
> +       incb x9
> +       uaddv d20, p0, z0.b // D1 + D2 + ... + Dx
> +       mov x12, v20.2d[0]
> +       madd x11, x10, x6, x11 // Bn = An-1 * x + Bn-1
> +
> +       uunpklo z26.h, z0.b
> +       uunpkhi z27.h, z0.b
> +       mul z26.h, p1/m, z26.h, z24.h // x * D1 + (x-1) * D2 + ... + (x/2 + 1) * D(x/2)
> +       mul z27.h, p1/m, z27.h, z25.h // (x/2) * D(x/2 + 1) + (x/2 - 1) * D(x/2 + 2) + ... + 1 * Dx
> +
> +       uaddv d21, p1, z26.h
> +       uaddv d22, p1, z27.h
> +       mov x13, v21.2d[0]
> +       mov x14, v22.2d[0]
> +
> +       add x11, x13, x11
> +       add x11, x14, x11         // Bn += x * D1 + (x-1) * D2 + ... + 1 * Dx
> +       add x10, x12, x10         // An += D1 + D2 + ... + Dx
> +       .endm
> +       ADLER_BLOCK_X
> +       ADLER_BLOCK_X
> +       ADLER_BLOCK_X
> +       // calc = reg0 % 65521
> +       .macro mod65521, reg0, reg1, reg2
> +       mov w\reg1, #0x8071
> +       mov w\reg2, #0xfff1
> +       movk w\reg1, #0x8007, lsl #16
> +       umull x\reg1, w\reg0, w\reg1
> +       lsr x\reg1, x\reg1, #47
> +       msub w\reg0, w\reg1, w\reg2, w\reg0
> +       .endm
> +

Same as above

> +       mod65521 10, 14, 12
> +       mod65521 11, 14, 12
> +
> +       sub x2, x2, x15
> +       cmp x2, x15
> +       b.ge LBig_loop
> +
> +.align 6

Indent

> +Lnormal_proc:

.L


> +       cmp x2, #0
> +       b.eq Lret
> +
> +       ldrb w12, [x1, x9]
> +       add x9, x9, #1
> +       add x10, x12, x10
> +       add x11, x10, x11
> +       sub x2, x2, #1
> +       b Lnormal_proc
> +
> +Lret:
> +       mod65521 10, 14, 12
> +       mod65521 11, 14, 12
> +       lsl x11, x11, #16
> +       orr x0, x10, x11
> +       ret
> +SYM_FUNC_END(adler32_sve)
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a64a639..58b8020 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4174,6 +4174,13 @@ static const struct alg_test_desc alg_test_descs[] = {
>                 .suite = {
>                         .cipher = __VECS(adiantum_xchacha20_aes_tv_template)
>                 },
> +       }, {
> +               .alg = "adler32",
> +               .test = alg_test_hash,
> +               .fips_allowed = 1,
> +               .suite = {
> +                       .hash = __VECS(adler32_tv_template)
> +               }
>         }, {
>                 .alg = "aegis128",
>                 .test = alg_test_aead,
> @@ -5640,7 +5647,6 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
>         }
>
>         DO_ONCE(testmgr_onetime_init);
> -
>         if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
>                 char nalg[CRYPTO_MAX_ALG_NAME];
>
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 8c83811..5233960 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -3676,6 +3676,19 @@ static const struct hash_testvec crct10dif_tv_template[] = {
>         }
>  };
>
> +static const struct hash_testvec adler32_tv_template[] = {
> +       {
> +               .plaintext      = "abcde",
> +               .psize          = 5,
> +               .digest         = "\xf0\x01\xc8\x05",
> +       },
> +       {
> +               .plaintext      = "0123456789101112131415",
> +               .psize          = 22,
> +               .digest         = "\x63\x04\xa8\x32",
> +       },
> +};
> +
>  /*
>   * Streebog test vectors from RFC 6986 and GOST R 34.11-2012
>   */
> --
> 2.19.1
>

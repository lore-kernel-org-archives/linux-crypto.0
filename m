Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74025C4332E
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 540CE22527
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbhAPRKN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbhAPRKH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:10:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D89322527;
        Sat, 16 Jan 2021 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610816448;
        bh=Jhl+WxQR3dYL3p877dR8rbj8Q6qo6NZkbX45IT07E6c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HoKyxT5hndQe/N85S5WK5idq98B8T/WGyYqn2sr52PynAiB1KhZVymVb1Q7x33Ls7
         A5v2jOMhpqrnezuxS24AUqgHsRQWEYglSbjsEjBfqK0V5+VFdudptdKKy7/OlC1+8k
         TfRk1PhevULzjB44Juq5mJHaey3xx7j4KHEFj4N+oJY6SuwH8tn7+oFJnEYkFxK+wx
         3tUlTyqISt2dBW/mM90zQicV8yt/ja2Oi0P3Z46CX3PhkGxhL+nI4FlyCvtNiE7Xnz
         Qn9uP3BcE8QrqhumJZ++NL8rJut+RqSAL/iMiU4X8wtPyfEojUronpeaW9xrWiRdR2
         D5ePHRz3Tnjgw==
Received: by mail-ot1-f48.google.com with SMTP id r9so11836137otk.11;
        Sat, 16 Jan 2021 09:00:48 -0800 (PST)
X-Gm-Message-State: AOAM532lir7OwOEuEukr8N4RTWSNMj+/JOSWhic+gNITZ9WWxJYLG3tK
        HK562bOGwCMF4Afh7CPnQ6gDfBCaKNIEhsdjipw=
X-Google-Smtp-Source: ABdhPJywYD5slnXEYdzV8O84oswokomilTHDl/VHkRMpUAbOHtYX6EjqIG58Okpa3QKXmXV0X53P0RnOHwhbw+ms/QM=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr12189332otu.77.1610816447446;
 Sat, 16 Jan 2021 09:00:47 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com> <1608325864-4033-3-git-send-email-megha.dey@intel.com>
In-Reply-To: <1608325864-4033-3-git-send-email-megha.dey@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 16 Jan 2021 18:00:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGOiy8ohS6Wa90qm3Fct4UvwhnLZcGM9-4E_Jn=pur-ug@mail.gmail.com>
Message-ID: <CAMj1kXGOiy8ohS6Wa90qm3Fct4UvwhnLZcGM9-4E_Jn=pur-ug@mail.gmail.com>
Subject: Re: [RFC V1 2/7] crypto: crct10dif - Accelerated CRC T10 DIF with
 vectorized instruction
To:     Megha Dey <megha.dey@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, Dave Hansen <dave.hansen@intel.com>,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Dec 2020 at 22:07, Megha Dey <megha.dey@intel.com> wrote:
>
> From: Kyung Min Park <kyung.min.park@intel.com>
>
> Update the crc_pcl function that calculates T10 Data Integrity Field
> CRC16 (CRC T10 DIF) using VPCLMULQDQ instruction. VPCLMULQDQ instruction
> with AVX-512F adds EVEX encoded 512 bit version of PCLMULQDQ instruction.
> The advantage comes from packing multiples of 4 * 128 bit data into AVX512
> reducing instruction latency.
>
> The glue code in crct10diff module overrides the existing PCLMULQDQ version
> with the VPCLMULQDQ version when the following criteria are met:
> At compile time:
> 1. CONFIG_CRYPTO_AVX512 is enabled
> 2. toolchain(assembler) supports VPCLMULQDQ instructions
> At runtime:
> 1. VPCLMULQDQ and AVX512VL features are supported on a platform (currently
>    only Icelake)
> 2. If compiled as built-in module, crct10dif_pclmul.use_avx512 is set at
>    boot time or /sys/module/crct10dif_pclmul/parameters/use_avx512 is set
>    to 1 after boot.
>    If compiled as loadable module, use_avx512 module parameter must be set:
>    modprobe crct10dif_pclmul use_avx512=1
>
> A typical run of tcrypt with CRC T10 DIF calculation with PCLMULQDQ
> instruction and VPCLMULQDQ instruction shows the following results:
> For bytes per update >= 1KB, we see the average improvement of 46%(~1.4x)
> For bytes per update < 1KB, we see the average improvement of 13%.
> Test was performed on an Icelake based platform with constant frequency
> set for CPU.
>
> Detailed results for a variety of block sizes and update sizes are in
> the table below.
>
> ---------------------------------------------------------------------------
> |            |            |         cycles/operation         |            |
> |            |            |       (the lower the better)     |            |
> |    byte    |   bytes    |----------------------------------| percentage |
> |   blocks   | per update |   CRC T10 DIF  |  CRC T10 DIF    | loss/gain  |
> |            |            | with PCLMULQDQ | with VPCLMULQDQ |            |
> |------------|------------|----------------|-----------------|------------|
> |      16    |     16     |        77      |        106      |   -27.0    |
> |      64    |     16     |       411      |        390      |     5.4    |
> |      64    |     64     |        71      |         85      |   -16.0    |
> |     256    |     16     |      1224      |       1308      |    -6.4    |
> |     256    |     64     |       393      |        407      |    -3.4    |
> |     256    |    256     |        93      |         86      |     8.1    |
> |    1024    |     16     |      4564      |       5020      |    -9.0    |
> |    1024    |    256     |       486      |        475      |     2.3    |
> |    1024    |   1024     |       221      |        148      |    49.3    |
> |    2048    |     16     |      8945      |       9851      |    -9.1    |
> |    2048    |    256     |       982      |        951      |     3.3    |
> |    2048    |   1024     |       500      |        369      |    35.5    |
> |    2048    |   2048     |       413      |        265      |    55.8    |
> |    4096    |     16     |     17885      |      19351      |    -7.5    |
> |    4096    |    256     |      1828      |       1713      |     6.7    |
> |    4096    |   1024     |       968      |        805      |    20.0    |
> |    4096    |   4096     |       739      |        475      |    55.6    |
> |    8192    |     16     |     48339      |      41556      |    16.3    |
> |    8192    |    256     |      3494      |       3342      |     4.5    |
> |    8192    |   1024     |      1959      |       1462      |    34.0    |
> |    8192    |   4096     |      1561      |       1036      |    50.7    |
> |    8192    |   8192     |      1540      |       1004      |    53.4    |
> ---------------------------------------------------------------------------
>
> This work was inspired by the CRC T10 DIF AVX512 optimization published
> in Intel Intelligent Storage Acceleration Library.
> https://github.com/intel/isa-l/blob/master/crc/crc16_t10dif_by16_10.asm
>
> Co-developed-by: Greg Tucker <greg.b.tucker@intel.com>
> Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
> Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> ---
>  arch/x86/crypto/Makefile                  |   1 +
>  arch/x86/crypto/crct10dif-avx512-asm_64.S | 482 ++++++++++++++++++++++++++++++
>  arch/x86/crypto/crct10dif-pclmul_glue.c   |  24 +-
>  arch/x86/include/asm/disabled-features.h  |   8 +-
>  crypto/Kconfig                            |  23 ++
>  5 files changed, 535 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/crypto/crct10dif-avx512-asm_64.S
>
...
> diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
> index 71291d5a..26a6350 100644
> --- a/arch/x86/crypto/crct10dif-pclmul_glue.c
> +++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
> @@ -35,6 +35,16 @@
>  #include <asm/simd.h>
>
>  asmlinkage u16 crc_t10dif_pcl(u16 init_crc, const u8 *buf, size_t len);
> +#ifdef CONFIG_CRYPTO_CRCT10DIF_AVX512
> +asmlinkage u16 crct10dif_pcl_avx512(u16 init_crc, const u8 *buf, size_t len);
> +#else
> +static u16 crct10dif_pcl_avx512(u16 init_crc, const u8 *buf, size_t len)
> +{ return 0; }
> +#endif
> +

Please drop the alternative definition. If you code the references
correctly, the alternative is never called.

> +static bool use_avx512;
> +module_param(use_avx512, bool, 0644);
> +MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
>
>  struct chksum_desc_ctx {
>         __u16 crc;
> @@ -56,7 +66,12 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
>
>         if (length >= 16 && crypto_simd_usable()) {
>                 kernel_fpu_begin();
> -               ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
> +               if (IS_ENABLED(CONFIG_CRYPTO_CRCT10DIF_AVX512) &&
> +                   cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) &&
> +                   use_avx512)
> +                       ctx->crc = crct10dif_pcl_avx512(ctx->crc, data, length);
> +               else
> +                       ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);

Please use a static call or static key here, and initialize its value
in the init code.

>                 kernel_fpu_end();
>         } else
>                 ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
> @@ -75,7 +90,12 @@ static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
>  {
>         if (len >= 16 && crypto_simd_usable()) {
>                 kernel_fpu_begin();
> -               *(__u16 *)out = crc_t10dif_pcl(crc, data, len);
> +               if (IS_ENABLED(CONFIG_CRYPTO_CRCT10DIF_AVX512) &&
> +                   cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) &&
> +                   use_avx512)
> +                       *(__u16 *)out = crct10dif_pcl_avx512(crc, data, len);
> +               else
> +                       *(__u16 *)out = crc_t10dif_pcl(crc, data, len);

Same here.

>                 kernel_fpu_end();
>         } else
>                 *(__u16 *)out = crc_t10dif_generic(crc, data, len);
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 5861d34..1192dea 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -56,6 +56,12 @@
>  # define DISABLE_PTI           (1 << (X86_FEATURE_PTI & 31))
>  #endif
>
> +#if defined(CONFIG_AS_VPCLMULQDQ)
> +# define DISABLE_VPCLMULQDQ    0
> +#else
> +# define DISABLE_VPCLMULQDQ    (1 << (X86_FEATURE_VPCLMULQDQ & 31))
> +#endif
> +
>  #ifdef CONFIG_IOMMU_SUPPORT
>  # define DISABLE_ENQCMD        0
>  #else
> @@ -82,7 +88,7 @@
>  #define DISABLED_MASK14        0
>  #define DISABLED_MASK15        0
>  #define DISABLED_MASK16        (DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
> -                        DISABLE_ENQCMD)
> +                        DISABLE_ENQCMD|DISABLE_VPCLMULQDQ)
>  #define DISABLED_MASK17        0
>  #define DISABLED_MASK18        0
>  #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index a367fcf..b090f14 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -613,6 +613,29 @@ config CRYPTO_CRC32C_VPMSUM
>           (vpmsum) instructions, introduced in POWER8. Enable on POWER8
>           and newer processors for improved performance.
>
> +config CRYPTO_AVX512
> +       bool "AVX512 hardware acceleration for crypto algorithms"
> +       depends on X86
> +       depends on 64BIT
> +       help
> +         This option will compile in AVX512 hardware accelerated crypto
> +         algorithms. These optimized algorithms provide substantial(2-10x)
> +         improvements over existing crypto algorithms for large data size.
> +         However, it may also incur a frequency penalty (aka. "bin drops")
> +         and cause collateral damage to other workloads running on the
> +         same core.
> +
> +# We default CRYPTO_CRCT10DIF_AVX512 to Y but depend on CRYPTO_AVX512 in
> +# order to have a singular option (CRYPTO_AVX512) select multiple algorithms
> +# when supported. Specifically, if the platform and/or toolset does not
> +# support VPLMULQDQ. Then this algorithm should not be supported as part of
> +# the set that CRYPTO_AVX512 selects.
> +config CRYPTO_CRCT10DIF_AVX512
> +       bool
> +       default y
> +       depends on CRYPTO_AVX512
> +       depends on CRYPTO_CRCT10DIF_PCLMUL
> +       depends on AS_VPCLMULQDQ
>
>  config CRYPTO_CRC32C_SPARC64
>         tristate "CRC32c CRC algorithm (SPARC64)"
> --
> 2.7.4
>

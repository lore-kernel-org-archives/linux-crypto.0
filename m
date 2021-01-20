Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B1FC433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 23:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 529C62376F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 23:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbhATXnc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 18:43:32 -0500
Received: from mga17.intel.com ([192.55.52.151]:4380 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390802AbhATWzw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 17:55:52 -0500
IronPort-SDR: udtxPOmhbx2EnIn62+SSmqrFLisLgr4uYKtb4FHV+EW0FTLM15GMcMq9Lvbu6GeFFeqjQbJYXq
 6PDt+KiW9qpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="158962538"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="158962538"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 14:46:06 -0800
IronPort-SDR: fLJ8GrFuJ7/9eBa2BFm2rnSpPQQb9shFgLk775NIbGuON/ZvYJrtze2Ah9pWPjVM0O+CKUOUe+
 1AWjY7oL9XUQ==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="366540464"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.255.228.129]) ([10.255.228.129])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 14:46:05 -0800
Subject: Re: [RFC V1 2/7] crypto: crct10dif - Accelerated CRC T10 DIF with
 vectorized instruction
To:     Ard Biesheuvel <ardb@kernel.org>
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
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-3-git-send-email-megha.dey@intel.com>
 <CAMj1kXGOiy8ohS6Wa90qm3Fct4UvwhnLZcGM9-4E_Jn=pur-ug@mail.gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <0fc1709e-085a-82e8-8e09-a19fa3c3abf0@intel.com>
Date:   Wed, 20 Jan 2021 14:46:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGOiy8ohS6Wa90qm3Fct4UvwhnLZcGM9-4E_Jn=pur-ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On 1/16/2021 9:00 AM, Ard Biesheuvel wrote:
> On Fri, 18 Dec 2020 at 22:07, Megha Dey <megha.dey@intel.com> wrote:
>> From: Kyung Min Park <kyung.min.park@intel.com>
>>
>> Update the crc_pcl function that calculates T10 Data Integrity Field
>> CRC16 (CRC T10 DIF) using VPCLMULQDQ instruction. VPCLMULQDQ instruction
>> with AVX-512F adds EVEX encoded 512 bit version of PCLMULQDQ instruction.
>> The advantage comes from packing multiples of 4 * 128 bit data into AVX512
>> reducing instruction latency.
>>
>> The glue code in crct10diff module overrides the existing PCLMULQDQ version
>> with the VPCLMULQDQ version when the following criteria are met:
>> At compile time:
>> 1. CONFIG_CRYPTO_AVX512 is enabled
>> 2. toolchain(assembler) supports VPCLMULQDQ instructions
>> At runtime:
>> 1. VPCLMULQDQ and AVX512VL features are supported on a platform (currently
>>     only Icelake)
>> 2. If compiled as built-in module, crct10dif_pclmul.use_avx512 is set at
>>     boot time or /sys/module/crct10dif_pclmul/parameters/use_avx512 is set
>>     to 1 after boot.
>>     If compiled as loadable module, use_avx512 module parameter must be set:
>>     modprobe crct10dif_pclmul use_avx512=1
>>
>> A typical run of tcrypt with CRC T10 DIF calculation with PCLMULQDQ
>> instruction and VPCLMULQDQ instruction shows the following results:
>> For bytes per update >= 1KB, we see the average improvement of 46%(~1.4x)
>> For bytes per update < 1KB, we see the average improvement of 13%.
>> Test was performed on an Icelake based platform with constant frequency
>> set for CPU.
>>
>> Detailed results for a variety of block sizes and update sizes are in
>> the table below.
>>
>> ---------------------------------------------------------------------------
>> |            |            |         cycles/operation         |            |
>> |            |            |       (the lower the better)     |            |
>> |    byte    |   bytes    |----------------------------------| percentage |
>> |   blocks   | per update |   CRC T10 DIF  |  CRC T10 DIF    | loss/gain  |
>> |            |            | with PCLMULQDQ | with VPCLMULQDQ |            |
>> |------------|------------|----------------|-----------------|------------|
>> |      16    |     16     |        77      |        106      |   -27.0    |
>> |      64    |     16     |       411      |        390      |     5.4    |
>> |      64    |     64     |        71      |         85      |   -16.0    |
>> |     256    |     16     |      1224      |       1308      |    -6.4    |
>> |     256    |     64     |       393      |        407      |    -3.4    |
>> |     256    |    256     |        93      |         86      |     8.1    |
>> |    1024    |     16     |      4564      |       5020      |    -9.0    |
>> |    1024    |    256     |       486      |        475      |     2.3    |
>> |    1024    |   1024     |       221      |        148      |    49.3    |
>> |    2048    |     16     |      8945      |       9851      |    -9.1    |
>> |    2048    |    256     |       982      |        951      |     3.3    |
>> |    2048    |   1024     |       500      |        369      |    35.5    |
>> |    2048    |   2048     |       413      |        265      |    55.8    |
>> |    4096    |     16     |     17885      |      19351      |    -7.5    |
>> |    4096    |    256     |      1828      |       1713      |     6.7    |
>> |    4096    |   1024     |       968      |        805      |    20.0    |
>> |    4096    |   4096     |       739      |        475      |    55.6    |
>> |    8192    |     16     |     48339      |      41556      |    16.3    |
>> |    8192    |    256     |      3494      |       3342      |     4.5    |
>> |    8192    |   1024     |      1959      |       1462      |    34.0    |
>> |    8192    |   4096     |      1561      |       1036      |    50.7    |
>> |    8192    |   8192     |      1540      |       1004      |    53.4    |
>> ---------------------------------------------------------------------------
>>
>> This work was inspired by the CRC T10 DIF AVX512 optimization published
>> in Intel Intelligent Storage Acceleration Library.
>> https://github.com/intel/isa-l/blob/master/crc/crc16_t10dif_by16_10.asm
>>
>> Co-developed-by: Greg Tucker <greg.b.tucker@intel.com>
>> Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
>> Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
>> Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
>> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
>> Signed-off-by: Megha Dey <megha.dey@intel.com>
>> ---
>>   arch/x86/crypto/Makefile                  |   1 +
>>   arch/x86/crypto/crct10dif-avx512-asm_64.S | 482 ++++++++++++++++++++++++++++++
>>   arch/x86/crypto/crct10dif-pclmul_glue.c   |  24 +-
>>   arch/x86/include/asm/disabled-features.h  |   8 +-
>>   crypto/Kconfig                            |  23 ++
>>   5 files changed, 535 insertions(+), 3 deletions(-)
>>   create mode 100644 arch/x86/crypto/crct10dif-avx512-asm_64.S
>>
> ...
>> diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
>> index 71291d5a..26a6350 100644
>> --- a/arch/x86/crypto/crct10dif-pclmul_glue.c
>> +++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
>> @@ -35,6 +35,16 @@
>>   #include <asm/simd.h>
>>
>>   asmlinkage u16 crc_t10dif_pcl(u16 init_crc, const u8 *buf, size_t len);
>> +#ifdef CONFIG_CRYPTO_CRCT10DIF_AVX512
>> +asmlinkage u16 crct10dif_pcl_avx512(u16 init_crc, const u8 *buf, size_t len);
>> +#else
>> +static u16 crct10dif_pcl_avx512(u16 init_crc, const u8 *buf, size_t len)
>> +{ return 0; }
>> +#endif
>> +
> Please drop the alternative definition. If you code the references
> correctly, the alternative is never called.
ok.
>
>> +static bool use_avx512;
>> +module_param(use_avx512, bool, 0644);
>> +MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
>>
>>   struct chksum_desc_ctx {
>>          __u16 crc;
>> @@ -56,7 +66,12 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
>>
>>          if (length >= 16 && crypto_simd_usable()) {
>>                  kernel_fpu_begin();
>> -               ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
>> +               if (IS_ENABLED(CONFIG_CRYPTO_CRCT10DIF_AVX512) &&
>> +                   cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) &&
>> +                   use_avx512)
>> +                       ctx->crc = crct10dif_pcl_avx512(ctx->crc, data, length);
>> +               else
>> +                       ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
> Please use a static call or static key here, and initialize its value
> in the init code.
Yeah, Ill make the change.
>
>>                  kernel_fpu_end();
>>          } else
>>                  ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
>> @@ -75,7 +90,12 @@ static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
>>   {
>>          if (len >= 16 && crypto_simd_usable()) {
>>                  kernel_fpu_begin();
>> -               *(__u16 *)out = crc_t10dif_pcl(crc, data, len);
>> +               if (IS_ENABLED(CONFIG_CRYPTO_CRCT10DIF_AVX512) &&
>> +                   cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ) &&
>> +                   use_avx512)
>> +                       *(__u16 *)out = crct10dif_pcl_avx512(crc, data, len);
>> +               else
>> +                       *(__u16 *)out = crc_t10dif_pcl(crc, data, len);
> Same here.

will do

-Megha

>
>>                  kernel_fpu_end();
>>          } else
>>                  *(__u16 *)out = crc_t10dif_generic(crc, data, len);
>> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
>> index 5861d34..1192dea 100644
>> --- a/arch/x86/include/asm/disabled-features.h
>> +++ b/arch/x86/include/asm/disabled-features.h
>> @@ -56,6 +56,12 @@
>>   # define DISABLE_PTI           (1 << (X86_FEATURE_PTI & 31))
>>   #endif
>>
>> +#if defined(CONFIG_AS_VPCLMULQDQ)
>> +# define DISABLE_VPCLMULQDQ    0
>> +#else
>> +# define DISABLE_VPCLMULQDQ    (1 << (X86_FEATURE_VPCLMULQDQ & 31))
>> +#endif
>> +
>>   #ifdef CONFIG_IOMMU_SUPPORT
>>   # define DISABLE_ENQCMD        0
>>   #else
>> @@ -82,7 +88,7 @@
>>   #define DISABLED_MASK14        0
>>   #define DISABLED_MASK15        0
>>   #define DISABLED_MASK16        (DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP| \
>> -                        DISABLE_ENQCMD)
>> +                        DISABLE_ENQCMD|DISABLE_VPCLMULQDQ)
>>   #define DISABLED_MASK17        0
>>   #define DISABLED_MASK18        0
>>   #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index a367fcf..b090f14 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -613,6 +613,29 @@ config CRYPTO_CRC32C_VPMSUM
>>            (vpmsum) instructions, introduced in POWER8. Enable on POWER8
>>            and newer processors for improved performance.
>>
>> +config CRYPTO_AVX512
>> +       bool "AVX512 hardware acceleration for crypto algorithms"
>> +       depends on X86
>> +       depends on 64BIT
>> +       help
>> +         This option will compile in AVX512 hardware accelerated crypto
>> +         algorithms. These optimized algorithms provide substantial(2-10x)
>> +         improvements over existing crypto algorithms for large data size.
>> +         However, it may also incur a frequency penalty (aka. "bin drops")
>> +         and cause collateral damage to other workloads running on the
>> +         same core.
>> +
>> +# We default CRYPTO_CRCT10DIF_AVX512 to Y but depend on CRYPTO_AVX512 in
>> +# order to have a singular option (CRYPTO_AVX512) select multiple algorithms
>> +# when supported. Specifically, if the platform and/or toolset does not
>> +# support VPLMULQDQ. Then this algorithm should not be supported as part of
>> +# the set that CRYPTO_AVX512 selects.
>> +config CRYPTO_CRCT10DIF_AVX512
>> +       bool
>> +       default y
>> +       depends on CRYPTO_AVX512
>> +       depends on CRYPTO_CRCT10DIF_PCLMUL
>> +       depends on AS_VPCLMULQDQ
>>
>>   config CRYPTO_CRC32C_SPARC64
>>          tristate "CRC32c CRC algorithm (SPARC64)"
>> --
>> 2.7.4
>>

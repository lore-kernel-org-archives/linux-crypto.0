Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C568C3526B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 21:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 178B123B88
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 21:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLRVHW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 16:07:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:16592 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgLRVHW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 16:07:22 -0500
IronPort-SDR: iWnqiuM7+otpRRdDXf/MM0g+8OjQfCqK1f0/yitaBI9qTo4+BxF8Eyj2qM+dhk74T6OprYTSRb
 CznU94ovQHkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9839"; a="237075264"
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="237075264"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 13:06:41 -0800
IronPort-SDR: 52s5of98+mfvXunFxukl0uY49q9ySIok/gVoOjYRO5EaPxQZw7RsM7hqsQq5SpQA4hi/Esnew1
 c6Y9z9UUpnng==
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="370785933"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 18 Dec 2020 13:06:40 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com, megha.dey@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        tony.luck@intel.com, ira.weiny@intel.com, x86@kernel.org
Subject: [RFC V1 0/7] Introduce AVX512 optimized crypto algorithms
Date:   Fri, 18 Dec 2020 13:10:57 -0800
Message-Id: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Optimize crypto algorithms using VPCLMULQDQ and VAES AVX512 instructions
(first implemented on Intel's Icelake client and Xeon CPUs).

These algorithms take advantage of the AVX512 registers to keep the CPU
busy and increase memory bandwidth utilization. They provide substantial
(2-10x) improvements over existing crypto algorithms when update data size
is greater than 128 bytes and do not have any significant impact when used
on small amounts of data.

However, these algorithms may also incur a frequency penalty and cause
collateral damage to other workloads running on the same core(co-scheduled
threads). These frequency drops are also known as bin drops where 1 bin
drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
are observed on the Icelake server.

The AVX512 optimization are disabled by default to avoid impact on other
workloads. In order to use these optimized algorithms:
1. At compile time:
   a. User must enable CONFIG_CRYPTO_AVX512 option
   b. Toolchain(assembler) must support VAES or VPCLMULQDQ instructions
2. At run time:
   a. User must set module parameter use_avx512 at boot time
   (<module_name>.use_avx512 = 1) or post boot using sysfs
   (echo 1 > /sys/module/<module_name>/parameters/use_avx512).
   (except for aesni ctr and gcm which require boot time initialization
   because of commit 0fbafd06bdde ("crypto: aesni - fix failing setkey for
   rfc4106-gcm-aesni")
   b. Platform must support VPCLMULQDQ or VAES features

N.B. It is unclear whether these coarse grain controls(global module
parameter) would meet all user needs. Perhaps some per-thread control might
be useful? Looking for guidance here.
 
Other implementations of these crypto algorithms are possible, which would
result in lower crypto performance but would not cause collateral damage
from frequency drops (AVX512L vs AVX512VL).

The following crypto algorithms are optimized using AVX512 registers:

1. "by16" implementation of T10 Data Integrity Field CRC16 (CRC T10 DIF)
   The "by16" means the main loop processes 256 bytes (16 * 16 bytes) at
   a time in CRC T10 DIF calculation. This algorithm is optimized using
   the VPCLMULQDQ instruction which is the encoded 512 bit version of
   PCLMULQDQ instruction. On an Icelake desktop, with constant frequency
   set, the "by16" CRC T10 DIF AVX512 optimization shows about 1.5X
   improvement when the bytes per update size is 1KB or above as measured
   by the tcrypt module.

2. GHASH computations with vectorized instruction.
   VPCLMULQDQ instruction is used to accelerate the most time-consuming
   part of GHASH, carry-less multiplication. For best parallelism and
   deeper out of order execution, the main loop of the code works on 16x16
   byte blocks at a time and performs reduction every 48 x 16 byte blocks.
   Optimized GHASH computations show a 4x to 10x speedup when the bytes
   per update is 256B or above.

3. "by16" implementation of the AES CTR mode using VAES instructions
   "by16" means that 16 independent blocks (each 128 bits) can be ciphered
   simultaneously. On an Icelake desktop, with constant frequency set, the
   "by16" AES CTR mode shows about 2X improvement when the bytes per update
   size is 256B or above as measured by the tcrypt module.

4. AES GCM using VPCLMULQDQ instructions
   Using AVX 512 registers, an average increase of 2X is observed when the
   bytes per update size is 256B or above as measured by tcrypt module.

Patch 1 checks for assembler support for VPCLMULQDQ instruction
Patch 2 introduces CRC T10 DIF calculation with VPCLMULQDQ instructions
Patch 3 introduces optimized GHASH computation with VPCLMULQDQ instructions
Patch 4 adds new speed test for optimized GHASH computations
Patch 5 introduces "by 16" version of AES CTR mode using VAES instructions
Patch 6 fixes coding style in existing if else block
Patch 7 introduces the AES GCM mode using VPCLMULQDQ instructions

Complex sign off chain in patches 2 and 3. Original implementation (non
kernel) was done by Intel's IPsec team. Kyung Min Park is the author of
Patch 2 and co-author of patch 3 along with me.

Also, most of this code is related to crypto subsystem. X86 mailing list is
copied here because of Patch 1.

Cc: x86@kernel.org
Reviewed-by: Tony Luck <tony.luck@intel.com>

Kyung Min Park (3):
  crypto: crct10dif - Accelerated CRC T10 DIF with vectorized
    instruction
  crypto: ghash - Optimized GHASH computations
  crypto: tcrypt - Add speed test for optimized GHASH computations

Megha Dey (4):
  x86: Probe assembler capabilities for VAES and VPLCMULQDQ support
  crypto: aesni - AES CTR x86_64 "by16" AVX512 optimization
  crypto: aesni - fix coding style for if/else block
  crypto: aesni - AVX512 version of AESNI-GCM using VPCLMULQDQ

 arch/x86/Kconfig.assembler                   |   10 +
 arch/x86/crypto/Makefile                     |    4 +
 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S  |  856 ++++++++++++
 arch/x86/crypto/aesni-intel_avx512-x86_64.S  | 1788 ++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c           |  122 +-
 arch/x86/crypto/avx512_vaes_common.S         | 1633 +++++++++++++++++++++++
 arch/x86/crypto/crct10dif-avx512-asm_64.S    |  482 +++++++
 arch/x86/crypto/crct10dif-pclmul_glue.c      |   24 +-
 arch/x86/crypto/ghash-clmulni-intel_avx512.S |   68 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c   |   39 +-
 arch/x86/include/asm/disabled-features.h     |   14 +-
 crypto/Kconfig                               |   59 +
 crypto/tcrypt.c                              |    5 +
 13 files changed, 5091 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S
 create mode 100644 arch/x86/crypto/aesni-intel_avx512-x86_64.S
 create mode 100644 arch/x86/crypto/avx512_vaes_common.S
 create mode 100644 arch/x86/crypto/crct10dif-avx512-asm_64.S
 create mode 100644 arch/x86/crypto/ghash-clmulni-intel_avx512.S

-- 
2.7.4


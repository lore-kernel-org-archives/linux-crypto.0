Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E05BC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1072376F
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbhAWHa1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jan 2021 02:30:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:5178 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbhAWHa0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jan 2021 02:30:26 -0500
IronPort-SDR: 5nWrUb53UPTT9BbNQmbyGR4rvRE8HIHTkCAnwT6h3YmWEhhf/CpQdMjsAKTeuO4j3EYwUdDaym
 kW8irb06KcRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="158731935"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="158731935"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 23:29:46 -0800
IronPort-SDR: rd/XQ9SdwvmV95wY5PFQz9Fk2M1Y5zLyOCwdgHi9mkip/QvW+7y+AsglbtzTXvhYeAVqq1tsmE
 j4ThMzK4pOfQ==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="468448070"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 22 Jan 2021 23:29:45 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com, megha.dey@intel.com,
        greg.b.tucker@intel.com, robert.a.kasten@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        kyung.min.park@intel.com, tony.luck@intel.com, ira.weiny@intel.com,
        ebiggers@kernel.org, ardb@kernel.org, x86@kernel.org
Subject: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
Date:   Fri, 22 Jan 2021 23:28:35 -0800
Message-Id: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Optimize crypto algorithms using AVX512 instructions - VAES and VPCLMULQDQ
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
   b. Toolchain(assembler) must support VPCLMULQDQ and VAES instructions
2. At run time:
   a. User must set module parameter use_avx512 at boot time
   b. Platform must support VPCLMULQDQ and VAES features

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

2. "by16" implementation of the AES CTR mode using VAES instructions
   "by16" means that 16 independent blocks (each 128 bits) can be ciphered
   simultaneously. On an Icelake desktop, with constant frequency set, the
   "by16" AES CTR mode shows about 2X improvement when the bytes per update
   size is 256B or above as measured by the tcrypt module.

3. AES GCM using VPCLMULQDQ instructions
   Using AVX 512 registers, an average increase of 2X is observed when the
   bytes per update size is 256B or above as measured by tcrypt module.

These algorithms have been tested using CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n,
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and CONFIG_CRYPTO_TEST=m.

This patchset has been rebased on top of Herbert's Crypto tree(master branch):
https://kernel.googlesource.com/pub/scm/linux/kernel/git/herbert/cryptodev-2.6
Patch 1 fixes coding style in existing if else block
Patch 2 checks for assembler support for VPCLMULQDQ instruction
Patch 3 introduces CRC T10 DIF calculation with VPCLMULQDQ instructions
Patch 4 introduces "by 16" version of AES CTR mode using VAES instructions
Patch 5 introduces the AES GCM mode using VPCLMULQDQ instructions

Complex sign off chain in patch 3. Original implementation (non kernel) was
done by Intel's IPsec team. Kyung Min Park is the author of this patch.

Also, most of this code is related to crypto subsystem. X86 mailing list is
copied here because of Patch 2.
Cc: x86@kernel.org

Changes V1->V2:
1. Fixed errors in all the algorithms to ensure all tests pass, when
   CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
2. Removed GHASH AVX512 algorithm because of lack of use case
3. Removed code from AES-CTR VAES assembly which deals with partial blocks
   as C glue layer only sends 16 byte blocks
4. Removed dummy function definitions when the CRYPTO_AVX512 is disabled
5. Use static calls and static keys. This means that use_avx512 cannot be set
   after boot.
6. Allocated GCM hash_keys on the heap instead of stack
7. Removed '&& 64BIT' reference while probing assembler capability
8. Updated cover letter and copyright year from 2020 to 2021
9. Reorder patches so that coding style patch is first

Kyung Min Park (1):
  crypto: crct10dif - Accelerated CRC T10 DIF with vectorized
    instruction

Megha Dey (4):
  crypto: aesni - fix coding style for if/else block
  x86: Probe assembler capabilities for VAES and VPLCMULQDQ support
  crypto: aesni - AES CTR x86_64 "by16" AVX512 optimization
  crypto: aesni - AVX512 version of AESNI-GCM using VPCLMULQDQ

 arch/x86/Kconfig.assembler                  |   10 +
 arch/x86/crypto/Makefile                    |    3 +
 arch/x86/crypto/aes_avx512_common.S         |  341 +++
 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S |  955 +++++++++
 arch/x86/crypto/aesni-intel_avx512-x86_64.S | 3078 +++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c          |  141 +-
 arch/x86/crypto/crct10dif-avx512-asm_64.S   |  482 +++++
 arch/x86/crypto/crct10dif-pclmul_glue.c     |   17 +-
 arch/x86/include/asm/disabled-features.h    |   14 +-
 crypto/Kconfig                              |   50 +
 10 files changed, 5077 insertions(+), 14 deletions(-)
 create mode 100644 arch/x86/crypto/aes_avx512_common.S
 create mode 100644 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S
 create mode 100644 arch/x86/crypto/aesni-intel_avx512-x86_64.S
 create mode 100644 arch/x86/crypto/crct10dif-avx512-asm_64.S

-- 
2.7.4


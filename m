From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] crypto: CRCT10DIF support for ARM and arm64
Date: Thu, 24 Nov 2016 15:43:17 +0000
Message-ID: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, dingtianhong@huawei.com,
        yangshengkai@huawei.com, yuehaibing@huawei.com,
        hanjun.guo@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35454 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966610AbcKXPo1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2016 10:44:27 -0500
Received: by mail-wm0-f54.google.com with SMTP id a197so118458796wmd.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2016 07:44:26 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

First of all, apologies to Yue Haibing for stealing his thunder, to some
extent. But after reviewing (and replying to) his patch, I noticed that his
code is not original code, but simply a transliteration of the existing Intel
code that resides in arch/x86/crypto/crct10dif-pcl-asm_64.S, but with the
license and copyright statement removed. 

So, if we are going to transliterate code, let's credit the original authors,
even if the resulting code does not look like the code you started out with.

Then, I noticed that we could stay *much* closer to the original, and that
there is no need for jump tables or computed gotos at all. So I got a bit
carried away, and ended up reimplementing the whole thing, for both arm and64
and ARM.

Patch #1 fixes an issue in testmgr that results in spurious false negatives
in the chunking tests if the third chunk exceeds 31 bytes.

Patch #2 expands the existing CRCT10DIF test cases, to ensure that all
code paths are actually covered.

Patch #3 is a straight transliteration of the Intel code to arm64.

Patch #4 is a straight transliteration of the Intel code to ARM. This patch
is against patch #3 (using --find-copies-harder) so that it is easy to
see how the ARM code deviates from the arm64 code.

NOTE: this code uses the 64x64->128 bit polynomial multiply instruction,
which is only available on cores that implement the v8 Crypto Extensions.

Ard Biesheuvel (4):
  crypto: testmgr - avoid overlap in chunked tests
  crypto: testmgr - add/enhance test cases for CRC-T10DIF
  crypto: arm64/crct10dif - port x86 SSE implementation to arm64
  crypto: arm/crct10dif - port x86 SSE implementation to ARM

 arch/arm/crypto/Kconfig               |   5 +
 arch/arm/crypto/Makefile              |   2 +
 arch/arm/crypto/crct10dif-ce-core.S   | 569 ++++++++++++++++++++
 arch/arm/crypto/crct10dif-ce-glue.c   |  89 +++
 arch/arm64/crypto/Kconfig             |   5 +
 arch/arm64/crypto/Makefile            |   3 +
 arch/arm64/crypto/crct10dif-ce-core.S | 518 ++++++++++++++++++
 arch/arm64/crypto/crct10dif-ce-glue.c |  80 +++
 crypto/testmgr.c                      |   2 +-
 crypto/testmgr.h                      |  70 ++-
 10 files changed, 1314 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/crypto/crct10dif-ce-core.S
 create mode 100644 arch/arm/crypto/crct10dif-ce-glue.c
 create mode 100644 arch/arm64/crypto/crct10dif-ce-core.S
 create mode 100644 arch/arm64/crypto/crct10dif-ce-glue.c

-- 
2.7.4

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/2] AES in CBC/CTR/XTS modes using ARMv8 Crypto Extensions
Date: Fri, 13 Sep 2013 17:08:04 +0200
Message-ID: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, nico@linaro.org,
	catalin.marinas@arm.com, steve.capper@arm.com,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:35385 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3IMPI3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 11:08:29 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so649848ead.16
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2013 08:08:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

This is a first attempt at getting something implemented that uses the ARMv8
crypto extensions for performing AES encryption in CBC, CTR and XTS modes.

The first patch moves the ablk helper code out of arch/x86. This code is used
to automagically instantiate async blkciphers based on the synchronous ones in
my implementation.

The second patch contains the actual AES code. Note that this is only compile
tested, there are most likely numerous bugs that need to be shaken out before
this will even run, so consider yourselves warned.

Comments highly appreciated,

Regards,
Ard.


Ard Biesheuvel (2):
  crypto: move ablk_helper out of arch/x86
  arm64: add support for AES using ARMv8 Crypto Extensions

 arch/arm64/Makefile                        |   8 +-
 arch/arm64/crypto/Makefile                 |  12 +
 arch/arm64/crypto/aesce-cbc.S              |  58 +++++
 arch/arm64/crypto/aesce-ctr.S              |  83 +++++++
 arch/arm64/crypto/aesce-glue.c             | 352 +++++++++++++++++++++++++++++
 arch/arm64/crypto/aesce-macros.S           |  95 ++++++++
 arch/arm64/crypto/aesce-xts.S              | 129 +++++++++++
 arch/x86/crypto/Makefile                   |   1 -
 arch/x86/crypto/ablk_helper.c              | 149 ------------
 arch/x86/crypto/aesni-intel_glue.c         |   2 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |   2 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |   2 +-
 arch/x86/crypto/cast5_avx_glue.c           |   2 +-
 arch/x86/crypto/cast6_avx_glue.c           |   2 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   2 +-
 arch/x86/crypto/serpent_avx_glue.c         |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c        |   2 +-
 arch/x86/crypto/twofish_avx_glue.c         |   2 +-
 arch/x86/include/asm/crypto/ablk_helper.h  |  31 ---
 crypto/Kconfig                             |  28 ++-
 crypto/Makefile                            |   4 +
 crypto/ablk_helper_generic.c               | 155 +++++++++++++
 crypto/ablk_helper_x86.c                   |   8 +
 include/crypto/ablk_helper.h               |  34 +++
 24 files changed, 961 insertions(+), 204 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aesce-cbc.S
 create mode 100644 arch/arm64/crypto/aesce-ctr.S
 create mode 100644 arch/arm64/crypto/aesce-glue.c
 create mode 100644 arch/arm64/crypto/aesce-macros.S
 create mode 100644 arch/arm64/crypto/aesce-xts.S
 delete mode 100644 arch/x86/crypto/ablk_helper.c
 delete mode 100644 arch/x86/include/asm/crypto/ablk_helper.h
 create mode 100644 crypto/ablk_helper_generic.c
 create mode 100644 crypto/ablk_helper_x86.c
 create mode 100644 include/crypto/ablk_helper.h

-- 
1.8.1.2

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 0/2] crypto: move ablk_helper out of arch/x86
Date: Fri, 20 Sep 2013 09:55:39 +0200
Message-ID: <1379663741-21085-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: jussi.kivilinna@iki.fi, herbert@gondor.apana.org.au, arnd@arndb.de,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:35023 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3ITH40 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Sep 2013 03:56:26 -0400
Received: by mail-we0-f177.google.com with SMTP id t60so98176wes.22
        for <linux-crypto@vger.kernel.org>; Fri, 20 Sep 2013 00:56:25 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

v3:
- added generic and x86 versions of <asm/simd.h> containing may_use_simd(), and
  use it to decide whether to take the sync or the async path

v2:
- whitespace fix
- split into two patches so that the first one applies cleanly to the ARM/ARM64
  trees as well
- rebased onto cryptodev/master

Ard Biesheuvel (2):
  crypto: create generic version of ablk_helper
  crypto: move x86 to the generic version of ablk_helper

 arch/x86/crypto/Makefile                   |   1 -
 arch/x86/crypto/ablk_helper.c              | 149 ----------------------------
 arch/x86/crypto/aesni-intel_glue.c         |   2 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |   2 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |   2 +-
 arch/x86/crypto/cast5_avx_glue.c           |   2 +-
 arch/x86/crypto/cast6_avx_glue.c           |   2 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   2 +-
 arch/x86/crypto/serpent_avx_glue.c         |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c        |   2 +-
 arch/x86/crypto/twofish_avx_glue.c         |   2 +-
 arch/x86/include/asm/crypto/ablk_helper.h  |  31 ------
 arch/x86/include/asm/simd.h                |  11 +++
 crypto/Kconfig                             |  23 +++--
 crypto/Makefile                            |   1 +
 crypto/ablk_helper.c                       | 150 +++++++++++++++++++++++++++++
 include/asm-generic/simd.h                 |  14 +++
 include/crypto/ablk_helper.h               |  31 ++++++
 18 files changed, 227 insertions(+), 202 deletions(-)
 delete mode 100644 arch/x86/crypto/ablk_helper.c
 delete mode 100644 arch/x86/include/asm/crypto/ablk_helper.h
 create mode 100644 arch/x86/include/asm/simd.h
 create mode 100644 crypto/ablk_helper.c
 create mode 100644 include/asm-generic/simd.h
 create mode 100644 include/crypto/ablk_helper.h

-- 
1.8.1.2

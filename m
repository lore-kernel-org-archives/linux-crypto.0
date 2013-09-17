From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/2] crypto: move ablk_helper out of arch/x86
Date: Tue, 17 Sep 2013 09:49:12 +0200
Message-ID: <1379404154-31537-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: jussi.kivilinna@iki.fi, herbert@gondor.apana.org.au,
	patches@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40457 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3IQHtr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Sep 2013 03:49:47 -0400
Received: by mail-wi0-f170.google.com with SMTP id cb5so4598875wib.5
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2013 00:49:46 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
 arch/x86/include/asm/crypto/ablk_helper.h  |  38 ++------
 crypto/Kconfig                             |  23 +++--
 crypto/Makefile                            |   1 +
 crypto/ablk_helper.c                       | 150 +++++++++++++++++++++++++++++
 include/asm-generic/crypto/ablk_helper.h   |  13 +++
 include/crypto/ablk_helper.h               |  31 ++++++
 17 files changed, 224 insertions(+), 200 deletions(-)
 delete mode 100644 arch/x86/crypto/ablk_helper.c
 create mode 100644 crypto/ablk_helper.c
 create mode 100644 include/asm-generic/crypto/ablk_helper.h
 create mode 100644 include/crypto/ablk_helper.h

-- 
1.8.1.2

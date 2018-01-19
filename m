From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/8] crypto: arm64+generic - SHA3/SHA-512/SM-3 roundup
Date: Fri, 19 Jan 2018 12:04:32 +0000
Message-ID: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33560 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752368AbeASMFJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:09 -0500
Received: by mail-wm0-f67.google.com with SMTP id x4so6960140wmc.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2018 04:05:09 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This supersedes all outstanding patches from me related to SHA-3, SHA-512
or SM-3.

- fix a correctness issue in the SHA-3 code (#1) and a performance issue (#2),
  the first one is definitely a -stable candidate, the second one potentially
  as well
- patches #3 and #4 make the generic SHA-3 code reusable as a fallback for the
  accelerated code introduced in #6
- patch #5 adds some SHA-3 test cases
- patch #6 implements SHA-3 using special arm64 instructions
- patch #7 implements the Chinese SM3 secure hash algorithm using special
  arm64 instructions
- patch #8 contains some fixes for the recently queued SHA-512 arm64 code.

Ard Biesheuvel (8):
  crypto/generic: sha3 - fixes for alignment and big endian operation
  crypto/generic: sha3: rewrite KECCAK transform to help the compiler
    optimize
  crypto/generic: sha3 - simplify code
  crypto/generic: sha3 - export init/update/final routines
  crypto/testmgr: sha3 - add new testcases
  crypto/arm64: sha3 - new v8.2 Crypto Extensions implementation
  crypto/arm64: sm3 - new v8.2 Crypto Extensions implementation
  crypto/arm64: sha512 - fix/improve new v8.2 Crypto Extensions code

 arch/arm64/crypto/Kconfig          |  12 +
 arch/arm64/crypto/Makefile         |   6 +
 arch/arm64/crypto/sha3-ce-core.S   | 210 ++++++++
 arch/arm64/crypto/sha3-ce-glue.c   | 161 ++++++
 arch/arm64/crypto/sha512-ce-core.S | 145 +++---
 arch/arm64/crypto/sha512-glue.c    |   1 +
 arch/arm64/crypto/sm3-ce-core.S    | 141 +++++
 arch/arm64/crypto/sm3-ce-glue.c    |  92 ++++
 crypto/sha3_generic.c              | 332 ++++++------
 crypto/testmgr.h                   | 550 ++++++++++++++++++++
 include/crypto/sha3.h              |   6 +-
 11 files changed, 1413 insertions(+), 243 deletions(-)
 create mode 100644 arch/arm64/crypto/sha3-ce-core.S
 create mode 100644 arch/arm64/crypto/sha3-ce-glue.c
 create mode 100644 arch/arm64/crypto/sm3-ce-core.S
 create mode 100644 arch/arm64/crypto/sm3-ce-glue.c

-- 
2.11.0

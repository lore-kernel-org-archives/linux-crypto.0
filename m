From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/5] sha3 fixes and new implementation for arm64
Date: Fri, 12 Jan 2018 13:15:17 +0000
Message-ID: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, steve.capper@linaro.org,
        jgarzik@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:43023 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933357AbeALNPg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 08:15:36 -0500
Received: by mail-wm0-f67.google.com with SMTP id g1so11998969wmg.2
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 05:15:36 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add an implementation of SHA3 to arm64 using the new special instructions (#4)

In preparation of that, fix a bug in the SHA3 and refactor it a bit so it
can serve as a fallback for the other code. Also, add some new test vectors
to get better test coverage.

Ard Biesheuvel (5):
  crypto/generic: sha3 - fixes for alignment and big endian operation
  crypto/generic: sha3 - simplify code
  crypto/generic: sha3 - export init/update/final routines
  crypto/arm64: sha3 - new implementation based on special instructions
  crypto/testmgr: sha3 - add new testcases

 arch/arm64/crypto/Kconfig        |   6 +
 arch/arm64/crypto/Makefile       |   3 +
 arch/arm64/crypto/sha3-ce-core.S | 224 ++++++++
 arch/arm64/crypto/sha3-ce-glue.c | 156 ++++++
 crypto/sha3_generic.c            | 198 +++----
 crypto/testmgr.h                 | 550 ++++++++++++++++++++
 include/crypto/sha3.h            |   6 +-
 7 files changed, 1012 insertions(+), 131 deletions(-)
 create mode 100644 arch/arm64/crypto/sha3-ce-core.S
 create mode 100644 arch/arm64/crypto/sha3-ce-glue.c

-- 
2.11.0

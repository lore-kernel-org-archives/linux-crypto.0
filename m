From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/6] SHA-256/512 glue code consolidation
Date: Sat, 28 Mar 2015 23:10:22 +0100
Message-ID: <1427580628-7128-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36337 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbbC1WKh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Mar 2015 18:10:37 -0400
Received: by wgra20 with SMTP id a20so133081935wgr.3
        for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2015 15:10:36 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

After working on various flavors of SHA over the past week, I noticed there
is a fair amount of duplication, not only of true boiler plate but also of
glue code that is not entirely non-trivial.

So this series proposes a way to cut down on that: I implemented generic
glue for SHA-256 and SHA-512, and ported the generic implementations to
use it. The last two patches are examples of non-trivial uses of it.
Patch #5 ports the arm64 SHA-256 Crypto Extensions to use it: this code
needs to enable and disable the NEON before and after using it, and has
an implementation of the padding in asm for inputs that are round multiples
of the block size. The final patch is the same core code as the patch
I sent yesterday, but this time with most of the redundant glue removed.

Comments, suggestions etc are highly appreciated!

Regards,
Ard.


Ard Biesheuvel (6):
  crypto: sha512: implement base layer for SHA-512
  crypto: sha512-generic: move to generic glue implementation
  crypto: sha256: implement base layer for SHA-256
  crypto: sha256-generic: move to generic glue implementation
  arm64/crypto: move ARMv8 SHA-224/256 driver to SHA-256 base layer
  arm/crypto: accelerated SHA-512 using ARM generic ASM and NEON

 arch/arm/crypto/Kconfig               |    8 +
 arch/arm/crypto/Makefile              |    8 +-
 arch/arm/crypto/sha512-armv4.pl       |  656 ++++++++++++
 arch/arm/crypto/sha512-core.S_shipped | 1814 +++++++++++++++++++++++++++++++++
 arch/arm/crypto/sha512-glue.c         |  137 +++
 arch/arm/crypto/sha512-neon-glue.c    |  111 ++
 arch/arm/crypto/sha512.h              |    8 +
 arch/arm64/crypto/Kconfig             |    1 +
 arch/arm64/crypto/sha2-ce-core.S      |   11 +-
 arch/arm64/crypto/sha2-ce-glue.c      |  211 +---
 crypto/Kconfig                        |    9 +
 crypto/Makefile                       |    2 +
 crypto/sha256_base.c                  |  138 +++
 crypto/sha256_generic.c               |  131 +--
 crypto/sha512_base.c                  |  143 +++
 crypto/sha512_generic.c               |  117 +--
 include/crypto/sha.h                  |   37 +
 17 files changed, 3142 insertions(+), 400 deletions(-)
 create mode 100644 arch/arm/crypto/sha512-armv4.pl
 create mode 100644 arch/arm/crypto/sha512-core.S_shipped
 create mode 100644 arch/arm/crypto/sha512-glue.c
 create mode 100644 arch/arm/crypto/sha512-neon-glue.c
 create mode 100644 arch/arm/crypto/sha512.h
 create mode 100644 crypto/sha256_base.c
 create mode 100644 crypto/sha512_base.c

-- 
1.8.3.2

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/11] arm64 crypto roundup
Date: Wed, 14 May 2014 11:17:20 -0700
Message-ID: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, jussi.kivilinna@iki.fi,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:51557 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaENSRk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 14:17:40 -0400
Received: by mail-yk0-f180.google.com with SMTP id q9so1882577ykb.25
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2014 11:17:40 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is another repost of the arm64 crypto patches, this time I have only
included the ones that go under arch/arm64/crypto.

Changes wrt previous version:
- updated the voluntary preemption patches to test for CRYPTO_TFM_REQ_MAY_SLEEP
  instead of !in_interrupt()
- added Herbert's ack

All patches operate correctly under their respective 'tcrypt.ko mode=xx' tests.

Ard Biesheuvel (11):
  arm64/crypto: SHA-1 using ARMv8 Crypto Extensions
  arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions
  arm64/crypto: GHASH secure hash using ARMv8 Crypto Extensions
  arm64/crypto: AES using ARMv8 Crypto Extensions
  arm64/crypto: AES in CCM mode using ARMv8 Crypto Extensions
  arm64: pull in <asm/simd.h> from asm-generic
  arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto
    Extensions
  arm64/crypto: add shared macro to test for NEED_RESCHED
  arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
  arm64/crypto: add voluntary preemption to Crypto Extensions SHA2
  arm64/crypto: add voluntary preemption to Crypto Extensions GHASH

 arch/arm64/Kconfig                  |   3 +
 arch/arm64/Makefile                 |   1 +
 arch/arm64/crypto/Kconfig           |  53 ++++
 arch/arm64/crypto/Makefile          |  38 +++
 arch/arm64/crypto/aes-ce-ccm-core.S | 222 +++++++++++++++
 arch/arm64/crypto/aes-ce-ccm-glue.c | 297 ++++++++++++++++++++
 arch/arm64/crypto/aes-ce-cipher.c   | 155 +++++++++++
 arch/arm64/crypto/aes-ce.S          | 133 +++++++++
 arch/arm64/crypto/aes-glue.c        | 446 ++++++++++++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S       | 532 ++++++++++++++++++++++++++++++++++++
 arch/arm64/crypto/aes-neon.S        | 382 ++++++++++++++++++++++++++
 arch/arm64/crypto/ghash-ce-core.S   |  97 +++++++
 arch/arm64/crypto/ghash-ce-glue.c   | 173 ++++++++++++
 arch/arm64/crypto/sha1-ce-core.S    | 154 +++++++++++
 arch/arm64/crypto/sha1-ce-glue.c    | 190 +++++++++++++
 arch/arm64/crypto/sha2-ce-core.S    | 159 +++++++++++
 arch/arm64/crypto/sha2-ce-glue.c    | 270 ++++++++++++++++++
 arch/arm64/include/asm/Kbuild       |   1 +
 arch/arm64/include/asm/assembler.h  |  21 ++
 19 files changed, 3327 insertions(+)
 create mode 100644 arch/arm64/crypto/Kconfig
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-ccm-core.S
 create mode 100644 arch/arm64/crypto/aes-ce-ccm-glue.c
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c
 create mode 100644 arch/arm64/crypto/aes-ce.S
 create mode 100644 arch/arm64/crypto/aes-glue.c
 create mode 100644 arch/arm64/crypto/aes-modes.S
 create mode 100644 arch/arm64/crypto/aes-neon.S
 create mode 100644 arch/arm64/crypto/ghash-ce-core.S
 create mode 100644 arch/arm64/crypto/ghash-ce-glue.c
 create mode 100644 arch/arm64/crypto/sha1-ce-core.S
 create mode 100644 arch/arm64/crypto/sha1-ce-glue.c
 create mode 100644 arch/arm64/crypto/sha2-ce-core.S
 create mode 100644 arch/arm64/crypto/sha2-ce-glue.c

-- 
1.8.3.2

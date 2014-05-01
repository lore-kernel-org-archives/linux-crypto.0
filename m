From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 00/15] arm64 crypto roundup
Date: Thu,  1 May 2014 17:49:32 +0200
Message-ID: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:47986 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaEAPtt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 11:49:49 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so3369182wes.32
        for <linux-crypto@vger.kernel.org>; Thu, 01 May 2014 08:49:48 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a repost of the arm64 crypto patches that I have posted to the LAKML
over the past months. They have now been verified on actual hardware
(Cortex-A57) so if there are no remaining issues I would like to propose them
for 3.16.

Ard Biesheuvel (15):
  asm-generic: allow generic unaligned access if the arch supports it
  arm64: add abstractions for FPSIMD state manipulation
  arm64: defer reloading a task's FPSIMD state to userland resume
  arm64: add support for kernel mode NEON in interrupt context
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

 arch/arm64/Kconfig                    |   3 +
 arch/arm64/Makefile                   |   1 +
 arch/arm64/crypto/Kconfig             |  53 ++++
 arch/arm64/crypto/Makefile            |  38 +++
 arch/arm64/crypto/aes-ce-ccm-core.S   | 222 ++++++++++++++
 arch/arm64/crypto/aes-ce-ccm-glue.c   | 297 ++++++++++++++++++
 arch/arm64/crypto/aes-ce-cipher.c     | 155 ++++++++++
 arch/arm64/crypto/aes-ce.S            | 147 +++++++++
 arch/arm64/crypto/aes-glue.c          | 446 +++++++++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S         | 548 ++++++++++++++++++++++++++++++++++
 arch/arm64/crypto/aes-neon.S          | 382 ++++++++++++++++++++++++
 arch/arm64/crypto/ghash-ce-core.S     |  97 ++++++
 arch/arm64/crypto/ghash-ce-glue.c     | 172 +++++++++++
 arch/arm64/crypto/sha1-ce-core.S      | 154 ++++++++++
 arch/arm64/crypto/sha1-ce-glue.c      | 201 +++++++++++++
 arch/arm64/crypto/sha2-ce-core.S      | 159 ++++++++++
 arch/arm64/crypto/sha2-ce-glue.c      | 281 +++++++++++++++++
 arch/arm64/include/asm/Kbuild         |   1 +
 arch/arm64/include/asm/assembler.h    |  21 ++
 arch/arm64/include/asm/fpsimd.h       |  23 ++
 arch/arm64/include/asm/fpsimdmacros.h |  35 +++
 arch/arm64/include/asm/neon.h         |   6 +-
 arch/arm64/include/asm/thread_info.h  |   4 +-
 arch/arm64/kernel/entry-fpsimd.S      |  24 ++
 arch/arm64/kernel/entry.S             |   2 +-
 arch/arm64/kernel/fpsimd.c            | 187 ++++++++++--
 arch/arm64/kernel/process.c           |   2 +-
 arch/arm64/kernel/ptrace.c            |   2 +
 arch/arm64/kernel/signal.c            |  13 +-
 arch/arm64/kernel/signal32.c          |   9 +-
 include/asm-generic/unaligned.h       |  21 +-
 31 files changed, 3662 insertions(+), 44 deletions(-)
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

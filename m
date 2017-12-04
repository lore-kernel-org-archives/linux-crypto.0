From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/19] crypto: arm64 - play nice with CONFIG_PREEMPT
Date: Mon,  4 Dec 2017 12:26:26 +0000
Message-ID: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:45869 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdLDM04 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 07:26:56 -0500
Received: by mail-wr0-f178.google.com with SMTP id h1so17033163wre.12
        for <linux-crypto@vger.kernel.org>; Mon, 04 Dec 2017 04:26:55 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a followup 'crypto: arm64 - disable NEON across scatterwalk API
calls' sent out last Friday.

As reported by Sebastian, the way the arm64 NEON crypto code currently
keeps kernel mode NEON enabled across calls into skcipher_walk_xxx() is
causing problems with RT builds, given that the skcipher walk API may
allocate and free temporary buffers it uses to present the input and
output arrays to the crypto algorithm in blocksize sized chunks (where
blocksize is the natural blocksize of the crypto algorithm), and doing
so with NEON enabled means we're alloc/free'ing memory with preemption
disabled.

This was deliberate: when this code was introduced, each kernel_neon_begin()
and kernel_neon_end() call incurred a fixed penalty of storing resp.
loading the contents of all NEON registers to/from memory, and so doing
it less often had an obvious performance benefit. However, in the mean time,
we have refactored the core kernel mode NEON code, and now kernel_neon_begin()
only incurs this penalty the first time it is called after entering the kernel,
and the NEON register restore is deferred until returning to userland. This
means pulling those calls into the loops that iterate over the input/output
of the crypto algorithm is not a big deal anymore (although there are some
places in the code where we relied on the NEON registers retaining their
values between calls)

So let's clean this up for arm64: update the NEON based skcipher drivers to
no longer keep the NEON enabled when calling into the skcipher walk API.

As pointed out by Peter, this only solves part of the problem. So let's
tackle it more thoroughly, and update the algorithms to test the NEED_RESCHED
flag each time after processing a fixed chunk of input. An attempt was made
to align the different algorithms with regards to how much work such a fixed
chunk entails, i.e., yielding every block for an algorithm that operates on
16 byte blocks at < 1 cycles per byte seems rather pointless.

Changes since v1:
- add CRC-T10DIF test vector (#1)
- stop using GFP_ATOMIC in scatterwalk API calls, now that they are executed
  with preemption enabled (#2 - #6)
- do some preparatory refactoring on the AES block mode code (#7 - #9)
- add yield patches (#10 - #18)
- add test patch (#19) - DO NOT MERGE

Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-rt-users@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

Ard Biesheuvel (19):
  crypto: testmgr - add a new test case for CRC-T10DIF
  crypto: arm64/aes-ce-ccm - move kernel mode neon en/disable into loop
  crypto: arm64/aes-blk - move kernel mode neon en/disable into loop
  crypto: arm64/aes-bs - move kernel mode neon en/disable into loop
  crypto: arm64/chacha20 - move kernel mode neon en/disable into loop
  crypto: arm64/ghash - move kernel mode neon en/disable into loop
  crypto: arm64/aes-blk - remove configurable interleave
  crypto: arm64/aes-blk - add 4 way interleave to CBC encrypt path
  crypto: arm64/aes-blk - add 4 way interleave to CBC-MAC encrypt path
  crypto: arm64/sha256-neon - play nice with CONFIG_PREEMPT kernels
  arm64: assembler: add macro to conditionally yield the NEON under
    PREEMPT
  crypto: arm64/sha1-ce - yield every 8 blocks of input
  crypto: arm64/sha2-ce - yield every 8 blocks of input
  crypto: arm64/aes-blk - yield after processing each 64 bytes of input
  crypto: arm64/aes-bs - yield after processing each 128 bytes of input
  crypto: arm64/aes-ghash - yield after processing fixed number of
    blocks
  crypto: arm64/crc32-ce - yield NEON every 16 blocks of input
  crypto: arm64/crct10dif-ce - yield NEON every 8 blocks of input
  DO NOT MERGE

 arch/arm64/crypto/Makefile             |   3 -
 arch/arm64/crypto/aes-ce-ccm-glue.c    |  47 +-
 arch/arm64/crypto/aes-ce.S             |  17 +-
 arch/arm64/crypto/aes-glue.c           |  95 ++-
 arch/arm64/crypto/aes-modes.S          | 624 ++++++++++----------
 arch/arm64/crypto/aes-neon.S           |   2 +
 arch/arm64/crypto/aes-neonbs-core.S    | 317 ++++++----
 arch/arm64/crypto/aes-neonbs-glue.c    |  48 +-
 arch/arm64/crypto/chacha20-neon-glue.c |  12 +-
 arch/arm64/crypto/crc32-ce-core.S      |  55 +-
 arch/arm64/crypto/crct10dif-ce-core.S  |  39 +-
 arch/arm64/crypto/ghash-ce-core.S      | 128 ++--
 arch/arm64/crypto/ghash-ce-glue.c      |  17 +-
 arch/arm64/crypto/sha1-ce-core.S       |  45 +-
 arch/arm64/crypto/sha2-ce-core.S       |  40 +-
 arch/arm64/crypto/sha256-glue.c        |  36 +-
 arch/arm64/include/asm/assembler.h     |  83 +++
 crypto/testmgr.h                       | 259 ++++++++
 18 files changed, 1231 insertions(+), 636 deletions(-)

-- 
2.11.0

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ABFC43381
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B1864E28
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhCCB1G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378839AbhCBJCz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA7A164F04;
        Tue,  2 Mar 2021 09:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675719;
        bh=Z0EnfS30SP7mXyolFuHmeA91GSfI7L8TgL8Mrh6yoEc=;
        h=From:To:Cc:Subject:Date:From;
        b=RvZ5AcgmqQM0+Tiv65jOD4gfdQvozntZ9tlMKCHaMKkK+uQjdwC71iLjjkLT5VSzx
         kFNU3xJ/UkkUkw89FJu0eTk3BQ6f4sfmTTtDSPZz4KdYsJO2p8aU1w9AJ8O7VdVjPC
         PaAQiZnAttu/mjmySqfQub0rfbACCvxsJw+bWWFcU7a2vUAGiJ2htPTNWh5nuRqhJm
         5pEDUrlBISgQxfleR8rTaMbQLCXYiqYiE7a9Gbg+b6QWztjMmWHTVuZvhjU1ytIhUz
         +6di2x+RNcPZDwNbVoA89hCkrGjQ0qehHopWPpHsiy00IWQvjgRZrnG2ttG4zm7Jmb
         WmnmB6OZKkR0Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 0/9] running kernel mode SIMD with softirqs disabled
Date:   Tue,  2 Mar 2021 10:01:09 +0100
Message-Id: <20210302090118.30666-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[ TL;DR for the non-ARM folks on CC: disabling softirq processing when using
  SIMD in kernel mode could reduce complexity and improve performance, but we
  need to decide whether we can do this, and how much softirq processing
  latency we can tolerate. If we can find a satisfactory solution for this,
  we might do the same for x86 and 32-bit ARM as well.
  
  However, based on preliminary off-list discussions with peterz and luto, it
  seems that for x86, there is a preference for using per-CPU buffers to
  preserve/restore the task context's kernel mode SIMD state when the task is
  interrupted to perform kernel mode SIMD in softirq context. On arm64, we
  actually had this arrangement before, and removed it because it made
  reasoning about preserving/restoring userland SVE state (32 SIMD registers
  of up to 2 kbit in size) rather complex. ]

The crypto API provides two ways to invoke symmetric encryption algorithms:
- synchronously, where the transformation is guaranteed to be done by the
  time the function returns;
- asynchronously, where the function may return with a -EINPROGRESS return code,
  and a completion will be signalled when the transformation is done.

The latter is mainly intended for h/w accelerators, where the throughput would
be severely limited by the latency otherwise. However, it is also being used
for software algorithms based on SIMD instructions, which cannot be issued from
any context (the rules are not the same on each architecture, but typically,
SIMD can be used in task context, or in softirq context if it was not taken
while the SIMD was already in use in kernel mode).

Many users of the crypto API exist in the kernel today that opt out of this
asynchronous interface (802.11, macsec, kerberos, sw kTLS), or use a library
interface which is fundamentally synchronous (wireguard). This means we end
up using a degraded mode for the contended case (a scalar fallback) as well
as the uncontended case (generic GCM/CCM/CTR chaining mode templates wrapped
around the SIMD cipher as opposed to accelerated implementations of the full
chaining modes in question). Note that scalar AES runs ~20x slower than the
SIMD instruction based version.

So let's address this for arm64, by reorganizing kernel mode SIMD support so
that the SIMD unit can always be assumed to be available. This means we need
to defer softirq processing when grabbing the NEON unit in task context, so
that any use of it in softirq context is guaranteed not to interrupt any code
that was already using the NEON.

This obviously impacts softirq processing latency, which is why the existing
conditional yield support is modified to take pending softirqs into account.

Change since RFC/v1:
- add patch to remove obsolete cond_yield_neon macros
- rebased onto new, simplified cond_yield macro
- include patches to remove the async path from all arm64 crypto skciphers
  and AEADs

Previous RFC version:
[0] https://lore.kernel.org/linux-arm-kernel/20201218170106.23280-1-ardb@kernel.org/

The first 3 patches will need to go through the arm64 tree, so once this
series is reviewed, some coordination is required between the arm64 and
crypto trees to get this merged without conflicts.

Cc: Dave Martin <dave.martin@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>

Ard Biesheuvel (9):
  arm64: assembler: remove conditional NEON yield macros
  arm64: assembler: introduce wxN aliases for wN registers
  arm64: fpsimd: run kernel mode NEON with softirqs disabled
  crypto: aead - disallow en/decrypt for non-task or non-softirq context
  crypto: skcipher - disallow en/decrypt for non-task or non-softirq
    context
  crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
  crypto: arm64/aes-ccm - remove non-SIMD fallback path
  crypto: arm64/aes-ce - stop using SIMD helper for skciphers
  crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers

 arch/arm64/crypto/Kconfig           |   3 -
 arch/arm64/crypto/aes-ce-ccm-glue.c | 151 +++-----------
 arch/arm64/crypto/aes-glue.c        | 102 ++--------
 arch/arm64/crypto/aes-modes.S       |   2 +-
 arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
 arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
 arch/arm64/crypto/sha1-ce-core.S    |   2 +-
 arch/arm64/crypto/sha2-ce-core.S    |   2 +-
 arch/arm64/crypto/sha3-ce-core.S    |   4 +-
 arch/arm64/crypto/sha512-ce-core.S  |   2 +-
 arch/arm64/include/asm/assembler.h  | 106 +++-------
 arch/arm64/kernel/asm-offsets.c     |   2 +
 arch/arm64/kernel/fpsimd.c          |   4 +-
 crypto/aead.c                       |  10 +
 crypto/skcipher.c                   |  10 +
 15 files changed, 162 insertions(+), 569 deletions(-)

-- 
2.30.1


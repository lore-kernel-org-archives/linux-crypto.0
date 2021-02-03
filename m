Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ED0C43381
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E78B64F7C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 11:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhBCLh0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233972AbhBCLhV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 06:37:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6060A64DDE;
        Wed,  3 Feb 2021 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612352200;
        bh=QmFF8j1I2GT0xMoZchgOEKdlDZjGZwnQDGtb7SZX+fc=;
        h=From:To:Cc:Subject:Date:From;
        b=WpbGHrfcwF07/osWwhujXV9f5XTlvdZ282hrxlDw7DXMR4hl06kuCJ6VL4JbPZocU
         L/ep172JuyY5st2QsIdqZvgfzdEIaSyi4sJikxQlneXyxcaLtRyOjcx8eg120TOPfr
         seMaBs0MV7kY0Y6kAQ4ujBWW3oSKhME2qX6Su5z/p6/i6NkqegfywHaM2gjGsVn4Xz
         fp5nFRQ2c4uPVv3hfm92buJp7WMuNGzfiXu3lNXj2M9OpXRi6vux1xj/rUsYGIbPao
         n20sQZoTBbiujk4A5lzIiOi6J0rrHBdGtcoAucD4qsPV/R554972DewpOBnRbrymto
         sA5oNMeh2ePFw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, will@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 0/9] arm64: rework NEON yielding to avoid scheduling from asm code
Date:   Wed,  3 Feb 2021 12:36:17 +0100
Message-Id: <20210203113626.220151-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Given how kernel mode NEON code disables preemption (to ensure that the
FP/SIMD register state is protected without having to context switch it),
we need to take care not to let those algorithms operate on unbounded
input data, or we may end up with excessive scheduling blackouts on
CONFIG_PREEMPT kernels.

This is currently handled by the cond_yield_neon macros, which check the
preempt count and the TIF_NEED_RESCHED flag from assembler code, and call
into kernel_neon_end()+kernel_neon_begin(), triggering a reschedule.
This works as expected, but is a bit messy, given how much of the state
preserve/restore code in the algorithm needs to be duplicated, as well as
causing the need to manage the stack frame explicitly. All of this is better
handled by the compiler, especially now that we have enabled features such
as the shadow call stack and BTI, and are working to improve call stack
validation.

In some cases, yielding is not necessary at all: algoritms that implement
skciphers and use the skcipher walk API will be invoked at page granularity,
which is granular enough for our purpose.

In other cases, it is better to simply return early from the assembler
routine if a reschedule is pending, and let the C code handle with this, by
retrying the call until it completes. This removes any voluntary schedule()
calls from the call stack, making the code much easier to reason about in
the context of stack validation, rcu_tasks synchronization, etc.

Practical note: assuming there are no objections to these changes, it may
be the most convenient to take patch #1 into the arm64 tree for v5.12,
and postpone the rest for merging via the crypto tree. (Note that this
series was created against the cryptodev tree, and so the arm64 maintainers
are also welcome to take the whole set if it applies cleanly to the arm64
tree)

Will: if you stick #1 on a separate branch, please base it on v5.11-rc1

Changes since v1:
- use sub+cbz instead of cmp+b.eq to avoid clobbering the flags in cond_yield
  (patch #1)

Cc: Dave Martin <dave.martin@arm.com>
Cc: Eric Biggers <ebiggers@google.com>

Ard Biesheuvel (9):
  arm64: assembler: add cond_yield macro
  crypto: arm64/sha1-ce - simplify NEON yield
  crypto: arm64/sha2-ce - simplify NEON yield
  crypto: arm64/sha3-ce - simplify NEON yield
  crypto: arm64/sha512-ce - simplify NEON yield
  crypto: arm64/aes-neonbs - remove NEON yield calls
  crypto: arm64/aes-ce-mac - simplify NEON yield
  crypto: arm64/crc-t10dif - move NEON yield to C code
  arm64: assembler: remove conditional NEON yield macros

 arch/arm64/crypto/aes-glue.c          | 21 +++--
 arch/arm64/crypto/aes-modes.S         | 52 +++++--------
 arch/arm64/crypto/aes-neonbs-core.S   |  8 +-
 arch/arm64/crypto/crct10dif-ce-core.S | 43 +++--------
 arch/arm64/crypto/crct10dif-ce-glue.c | 30 ++++++--
 arch/arm64/crypto/sha1-ce-core.S      | 47 ++++--------
 arch/arm64/crypto/sha1-ce-glue.c      | 22 +++---
 arch/arm64/crypto/sha2-ce-core.S      | 38 ++++-----
 arch/arm64/crypto/sha2-ce-glue.c      | 22 +++---
 arch/arm64/crypto/sha3-ce-core.S      | 81 ++++++++------------
 arch/arm64/crypto/sha3-ce-glue.c      | 14 ++--
 arch/arm64/crypto/sha512-ce-core.S    | 29 ++-----
 arch/arm64/crypto/sha512-ce-glue.c    | 53 +++++++------
 arch/arm64/include/asm/assembler.h    | 78 +++----------------
 14 files changed, 209 insertions(+), 329 deletions(-)

-- 
2.30.0


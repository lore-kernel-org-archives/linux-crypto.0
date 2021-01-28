Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C565C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3204664DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 13:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhA1NHW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 08:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhA1NHV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 08:07:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB7B64D9F;
        Thu, 28 Jan 2021 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611839200;
        bh=+6OMNZcUUWaDvKg8NRL1a4tI1nBxsV+pPg6GaYsCbds=;
        h=From:To:Cc:Subject:Date:From;
        b=GXr7N4Nzg3nwJkB+78EsNwIdajoG/QMs9OlZ+IG+YIPqDeLfFcQFC9PmW7cdHTVYq
         fDm9y4VWeeOweyXI5vQaa817K2iI1veQyxXnA8xylOF40YEBOkzpYVcuT4hR7G4TPp
         k2fpEC6afKc1YdWg6ClcB0GqsUP4ID+/LMbdPAvDjzVMkI85sSIZMooGDquryDTCPG
         tx8lv8x9qIsDpUvhUEM1fQsLx2bk3F4DczZ09irGl/EKNM9DoCoVkfQ2gOR1mflM20
         gAOPAxZcmkzmcswawU4RpwOPOB5qlVUdUaoo46syL3HT9fTJm23Ln5A64VIhwBVlo0
         Rvf7Z/dKUx0Nw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 0/9] arm64: rework NEON yielding to avoid scheduling from asm code
Date:   Thu, 28 Jan 2021 14:06:16 +0100
Message-Id: <20210128130625.54076-1-ardb@kernel.org>
X-Mailer: git-send-email 2.29.2
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
2.29.2


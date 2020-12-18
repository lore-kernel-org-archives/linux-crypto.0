Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEDBC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF7F23B2F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgLRRDq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 12:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgLRRDq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 12:03:46 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH 0/5] running kernel mode SIMD with softirqs disabled
Date:   Fri, 18 Dec 2020 18:01:01 +0100
Message-Id: <20201218170106.23280-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[ TL;DR for the non-ARM folks on CC: disabling softirq processing when using
  SIMD in kernel mode could reduce complexity and improve performance, but we
  need to decide whether we can do this, and how much softirq processing
  latency we can tolerate. If we can find a satisfactory solution for this,
  we might do the same for x86 and 32-bit ARM as well. ]

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
conditional NEON yield support is modified to take pending softirqs into
account.

As an example of how this impacts the code, the existing arm64 GCM driver is
updated to:
- Add yield support - currently, the pending softirq check is performed every
  64 bytes of input, which is way too often - one of the desired outcomes of
  this RFC is getting a reasonable ballpark for how long we want to run with
  softirqs disabled.
- Remove the existing scalar fallbacks, which are no longer needed.

Questions:
- what did I miss or break horribly?
- does any of this matter for RT? AIUI, RT runs softirqs from a dedicated
  kthread, so I don't think it cares.
- what would be a reasonable upper bound to keep softirqs disabled? I suppose
  100s of cycles or less is overkill, but I'm not sure how to derive a better
  answer.
- could we do the same on x86, now that kernel_fpu_begin/end is no longer
  expensive?

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

Ard Biesheuvel (5):
  crypto: aead - disallow en/decrypt for non-task or non-softirq context
  crypto: skcipher - disallow en/decrypt for non-task or non-softirq
    context
  crypto: arm64/gcm-aes-ce - add NEON yield support
  arm64: fpsimd: run kernel mode NEON with softirqs disabled
  crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path

 arch/arm64/crypto/ghash-ce-core.S  | 115 ++++++-----
 arch/arm64/crypto/ghash-ce-glue.c  | 209 +++++---------------
 arch/arm64/include/asm/assembler.h |  19 +-
 arch/arm64/kernel/asm-offsets.c    |   2 +
 arch/arm64/kernel/fpsimd.c         |   4 +-
 crypto/aead.c                      |  10 +
 crypto/skcipher.c                  |  10 +
 7 files changed, 155 insertions(+), 214 deletions(-)

-- 
2.17.1


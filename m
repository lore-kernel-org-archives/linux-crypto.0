Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC71C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D0EB64E53
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhBJHX6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:23:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50248 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhBJHX4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:23:56 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jq7-0001HR-KN; Wed, 10 Feb 2021 18:23:08 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:23:07 +1100
Date:   Wed, 10 Feb 2021 18:23:07 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2 0/9] arm64: rework NEON yielding to avoid scheduling
 from asm code
Message-ID: <20210210072307.GA4617@gondor.apana.org.au>
References: <20210203113626.220151-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203113626.220151-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 03, 2021 at 12:36:17PM +0100, Ard Biesheuvel wrote:
> Given how kernel mode NEON code disables preemption (to ensure that the
> FP/SIMD register state is protected without having to context switch it),
> we need to take care not to let those algorithms operate on unbounded
> input data, or we may end up with excessive scheduling blackouts on
> CONFIG_PREEMPT kernels.
> 
> This is currently handled by the cond_yield_neon macros, which check the
> preempt count and the TIF_NEED_RESCHED flag from assembler code, and call
> into kernel_neon_end()+kernel_neon_begin(), triggering a reschedule.
> This works as expected, but is a bit messy, given how much of the state
> preserve/restore code in the algorithm needs to be duplicated, as well as
> causing the need to manage the stack frame explicitly. All of this is better
> handled by the compiler, especially now that we have enabled features such
> as the shadow call stack and BTI, and are working to improve call stack
> validation.
> 
> In some cases, yielding is not necessary at all: algoritms that implement
> skciphers and use the skcipher walk API will be invoked at page granularity,
> which is granular enough for our purpose.
> 
> In other cases, it is better to simply return early from the assembler
> routine if a reschedule is pending, and let the C code handle with this, by
> retrying the call until it completes. This removes any voluntary schedule()
> calls from the call stack, making the code much easier to reason about in
> the context of stack validation, rcu_tasks synchronization, etc.
> 
> Practical note: assuming there are no objections to these changes, it may
> be the most convenient to take patch #1 into the arm64 tree for v5.12,
> and postpone the rest for merging via the crypto tree. (Note that this
> series was created against the cryptodev tree, and so the arm64 maintainers
> are also welcome to take the whole set if it applies cleanly to the arm64
> tree)
> 
> Will: if you stick #1 on a separate branch, please base it on v5.11-rc1
> 
> Changes since v1:
> - use sub+cbz instead of cmp+b.eq to avoid clobbering the flags in cond_yield
>   (patch #1)
> 
> Cc: Dave Martin <dave.martin@arm.com>
> Cc: Eric Biggers <ebiggers@google.com>
> 
> Ard Biesheuvel (9):
>   arm64: assembler: add cond_yield macro
>   crypto: arm64/sha1-ce - simplify NEON yield
>   crypto: arm64/sha2-ce - simplify NEON yield
>   crypto: arm64/sha3-ce - simplify NEON yield
>   crypto: arm64/sha512-ce - simplify NEON yield
>   crypto: arm64/aes-neonbs - remove NEON yield calls
>   crypto: arm64/aes-ce-mac - simplify NEON yield
>   crypto: arm64/crc-t10dif - move NEON yield to C code
>   arm64: assembler: remove conditional NEON yield macros
> 
>  arch/arm64/crypto/aes-glue.c          | 21 +++--
>  arch/arm64/crypto/aes-modes.S         | 52 +++++--------
>  arch/arm64/crypto/aes-neonbs-core.S   |  8 +-
>  arch/arm64/crypto/crct10dif-ce-core.S | 43 +++--------
>  arch/arm64/crypto/crct10dif-ce-glue.c | 30 ++++++--
>  arch/arm64/crypto/sha1-ce-core.S      | 47 ++++--------
>  arch/arm64/crypto/sha1-ce-glue.c      | 22 +++---
>  arch/arm64/crypto/sha2-ce-core.S      | 38 ++++-----
>  arch/arm64/crypto/sha2-ce-glue.c      | 22 +++---
>  arch/arm64/crypto/sha3-ce-core.S      | 81 ++++++++------------
>  arch/arm64/crypto/sha3-ce-glue.c      | 14 ++--
>  arch/arm64/crypto/sha512-ce-core.S    | 29 ++-----
>  arch/arm64/crypto/sha512-ce-glue.c    | 53 +++++++------
>  arch/arm64/include/asm/assembler.h    | 78 +++----------------
>  14 files changed, 209 insertions(+), 329 deletions(-)

Patches 2-8 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C42CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 21:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21ADA64F72
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 21:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhBCVcV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 16:32:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhBCVcU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 16:32:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945CF64F5F;
        Wed,  3 Feb 2021 21:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612387899;
        bh=Co480oVhsgCAw1FshXDDT0AN/4L+VqPG9bJVyxbDMyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC0+83IWvBPsPg1QaOH6AHq4XcI1jV80IlPMMfou9YbzEnHPmRz5P74KV1T04jiSi
         ppk0M4PfYylZhB/oXl29jl5v84BNBAjYadq1MQKx727VMjUFRxojZ+NhCNEwr0gw0a
         6P5VxJ4zWoYHfXo4uPP339ttQdWnEuG4gP+KGTuAYR/5TZufFZbXZ1tTL6O+HJ9stC
         42GVALzMyS0mu1xSTSaQI5m/W1lhAQ3FyWtSn1VOKxY/aZCBzCXkHYxMSWqaGDYeW9
         2cRrsm6wKRfHH/g9xwQKVNOF5dGXaE0KLGqeM8CAT3zcotNq9pNWCLfvNf+/nD7TjG
         ewWYOfUAyuXUg==
From:   Will Deacon <will@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, mark.rutland@arm.com,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org
Subject: (subset) Re: [PATCH v2 0/9] arm64: rework NEON yielding to avoid scheduling from asm code
Date:   Wed,  3 Feb 2021 21:31:31 +0000
Message-Id: <161238528350.1984862.12324465919265084208.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203113626.220151-1-ardb@kernel.org>
References: <20210203113626.220151-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 3 Feb 2021 12:36:17 +0100, Ard Biesheuvel wrote:
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
> [...]

Applied first patch only to arm64 (for-next/crypto), thanks!

[1/9] arm64: assembler: add cond_yield macro
      https://git.kernel.org/arm64/c/d13c613f136c

This is the only patch on the branch, so I'm happy for it to be pulled
into the crypto tree too if it enables some of the other patches to land
in 5.12.

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

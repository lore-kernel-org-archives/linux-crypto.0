Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EE8C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 10:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AA6664DDE
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 10:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhBDKf6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 05:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235611AbhBDKef (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 05:34:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896B164E43;
        Thu,  4 Feb 2021 10:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612434833;
        bh=qUSmXmDQ2dLtxjBzj2Gr0CFZ0JoPsDW59/wmRF9PWbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pyoh2quCGRQ1SdeW0ydtU4oO5R/2DhENYpkdimSTLbbiURuq0cvRqrHdvISaveDZg
         mudjhfFURkSeUchQJLaC+bUnL2aFx40D9ToZGiol4zasM2bC48dmtvwxrHJyg6SlnR
         94Q1LnqQROIp3+V4lqcBTkDBD26cQpr+ndIuG6gbb8lrs0qKq73m3tT3sRpXxkArO/
         fwsTIJhFNIXNIUSdbA+bgD9JMESDYpN+mAMqogkCMUg0Gz7HooJ3PsmzrHMP/9CXE5
         opx4P3fOoJGoBz5ZEv5d9xgUBowCtDdVY4q+QXGC6d5lukO02H0643mmRTqp2zsdU+
         sbvsKeX7G16qQ==
Date:   Thu, 4 Feb 2021 10:33:48 +0000
From:   Will Deacon <will@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        mark.rutland@arm.com, Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org
Subject: Re: (subset) Re: [PATCH v2 0/9] arm64: rework NEON yielding to avoid
 scheduling from asm code
Message-ID: <20210204103347.GA20410@willie-the-truck>
References: <20210203113626.220151-1-ardb@kernel.org>
 <161238528350.1984862.12324465919265084208.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161238528350.1984862.12324465919265084208.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 03, 2021 at 09:31:31PM +0000, Will Deacon wrote:
> On Wed, 3 Feb 2021 12:36:17 +0100, Ard Biesheuvel wrote:
> > Given how kernel mode NEON code disables preemption (to ensure that the
> > FP/SIMD register state is protected without having to context switch it),
> > we need to take care not to let those algorithms operate on unbounded
> > input data, or we may end up with excessive scheduling blackouts on
> > CONFIG_PREEMPT kernels.
> > 
> > This is currently handled by the cond_yield_neon macros, which check the
> > preempt count and the TIF_NEED_RESCHED flag from assembler code, and call
> > into kernel_neon_end()+kernel_neon_begin(), triggering a reschedule.
> > This works as expected, but is a bit messy, given how much of the state
> > preserve/restore code in the algorithm needs to be duplicated, as well as
> > causing the need to manage the stack frame explicitly. All of this is better
> > handled by the compiler, especially now that we have enabled features such
> > as the shadow call stack and BTI, and are working to improve call stack
> > validation.
> > 
> > [...]
> 
> Applied first patch only to arm64 (for-next/crypto), thanks!

Oops, looks like I typo'd the external branch (for-next/crypo). No offense
intended! I'll rename it now; SHAs will stay the same.

Will

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81983C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 13:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 554836134F
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 13:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbhDLNMY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241722AbhDLNMV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Apr 2021 09:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B446128A;
        Mon, 12 Apr 2021 13:12:01 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Martin <dave.martin@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: (subset) [PATCH v2 0/9] running kernel mode SIMD with softirqs disabled
Date:   Mon, 12 Apr 2021 14:11:13 +0100
Message-Id: <161822613829.4133.7312323262518323547.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210302090118.30666-1-ardb@kernel.org>
References: <20210302090118.30666-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2 Mar 2021 10:01:09 +0100, Ard Biesheuvel wrote:
> [ TL;DR for the non-ARM folks on CC: disabling softirq processing when using
>   SIMD in kernel mode could reduce complexity and improve performance, but we
>   need to decide whether we can do this, and how much softirq processing
>   latency we can tolerate. If we can find a satisfactory solution for this,
>   we might do the same for x86 and 32-bit ARM as well.
> 
>   However, based on preliminary off-list discussions with peterz and luto, it
>   seems that for x86, there is a preference for using per-CPU buffers to
>   preserve/restore the task context's kernel mode SIMD state when the task is
>   interrupted to perform kernel mode SIMD in softirq context. On arm64, we
>   actually had this arrangement before, and removed it because it made
>   reasoning about preserving/restoring userland SVE state (32 SIMD registers
>   of up to 2 kbit in size) rather complex. ]
> 
> [...]

Applied to arm64 (for-next/neon-softirqs-disabled), thanks!

[1/9] arm64: assembler: remove conditional NEON yield macros
      https://git.kernel.org/arm64/c/27248fe1abb2
[2/9] arm64: assembler: introduce wxN aliases for wN registers
      https://git.kernel.org/arm64/c/4c4dcd3541f8
[3/9] arm64: fpsimd: run kernel mode NEON with softirqs disabled
      https://git.kernel.org/arm64/c/13150149aa6d

-- 
Catalin


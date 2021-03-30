Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757ABC433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 10:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AA48619AB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 10:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhC3Kg3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 06:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhC3KgN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 06:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4CAF619A6;
        Tue, 30 Mar 2021 10:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617100573;
        bh=vlejUKjTN3abqWjJfwmpRpsVi7zGnnH1VNzjwBkSdpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gn0F7rfpSJGa1lUn7RpxMmByH6rnRx0GkGAAOSQ9Mo2889QfJDudDHMrq6u19X7+p
         ZOD+ZKii11jl2u6IO5tb0jJSG2cBlGPtsSUBHgq64doV+qVgGNQZUWgY5jrBVhE90H
         dNr2jr/sgwn/MzxT1oem6Lsekm+J+9PjhaHhLk3AGAoxnVU/gq5CN5uhRgdCZok9yz
         0lS6xeCBCckQSQ8Ed2lbYNJfgOHHVMCr/o3zDqgyBMrgDo+buzsMVIvxQwBVhmZa0D
         do8Xpu5JFEp7BE7rN9o29obvSgyppymcMKn4/HW69Ehe4+HmYFprsP1aQ+pVJ0VQcy
         mOKV6oi0K4cYw==
Date:   Tue, 30 Mar 2021 11:36:07 +0100
From:   Will Deacon <will@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 3/9] arm64: fpsimd: run kernel mode NEON with softirqs
 disabled
Message-ID: <20210330103605.GC5352@willie-the-truck>
References: <20210302090118.30666-1-ardb@kernel.org>
 <20210302090118.30666-4-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302090118.30666-4-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 02, 2021 at 10:01:12AM +0100, Ard Biesheuvel wrote:
> Kernel mode NEON can be used in task or softirq context, but only in
> a non-nesting manner, i.e., softirq context is only permitted if the
> interrupt was not taken at a point where the kernel was using the NEON
> in task context.
> 
> This means all users of kernel mode NEON have to be aware of this
> limitation, and either need to provide scalar fallbacks that may be much
> slower (up to 20x for AES instructions) and potentially less safe, or
> use an asynchronous interface that defers processing to a later time
> when the NEON is guaranteed to be available.
> 
> Given that grabbing and releasing the NEON is cheap, we can relax this
> restriction, by increasing the granularity of kernel mode NEON code, and
> always disabling softirq processing while the NEON is being used in task
> context.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-modes.S      |  2 +-
>  arch/arm64/crypto/sha1-ce-core.S   |  2 +-
>  arch/arm64/crypto/sha2-ce-core.S   |  2 +-
>  arch/arm64/crypto/sha3-ce-core.S   |  4 +--
>  arch/arm64/crypto/sha512-ce-core.S |  2 +-
>  arch/arm64/include/asm/assembler.h | 28 +++++++++++++++-----
>  arch/arm64/kernel/asm-offsets.c    |  2 ++
>  arch/arm64/kernel/fpsimd.c         |  4 +--
>  8 files changed, 31 insertions(+), 15 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

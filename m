Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECE0C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 10:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF958619B4
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 10:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhC3KAB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 06:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhC3J7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 05:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932D86191D;
        Tue, 30 Mar 2021 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617098387;
        bh=WOcvGRY7a4j1mwA7iHz+r3yfCYo8kr8XRVh6nIOgYio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BY98ydOAxCiz9jsrfUDPPqvwwhdOScGUK1tzr2muVpAxAszPhjkB048I6RmK9jtR+
         LvOwQTyIwXvAZKMCElJ5zQ617/UO+Gsny2n8zr2F1r5xKcg3MDnGu1RIzdoMAF8H8V
         8izaivrw161Zpx48WX3k1hQLGy4jFZgtsdcZKwlXpR1Ld8W//sjAehmcbGnEi2Rir2
         RSEzJvLwFtTg0MXkt8ibLMUgWADWN1mXzyXhwv2MxJkNZPJ4QMSGgzNoJPePOUAre9
         JunnqAlpxBsUfb/KhkdJlHI+TIJtNzFEzMh7FngMVHsfYnL0XE/Tan73qjlSM2/rJ4
         ruWICFbWU8aEg==
Date:   Tue, 30 Mar 2021 10:59:42 +0100
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
Subject: Re: [PATCH v2 2/9] arm64: assembler: introduce wxN aliases for wN
 registers
Message-ID: <20210330095941.GB5352@willie-the-truck>
References: <20210302090118.30666-1-ardb@kernel.org>
 <20210302090118.30666-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302090118.30666-3-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 02, 2021 at 10:01:11AM +0100, Ard Biesheuvel wrote:
> The AArch64 asm syntax has this slightly tedious property that the names
> used in mnemonics to refer to registers depend on whether the opcode in
> question targets the entire 64-bits (xN), or only the least significant
> 8, 16 or 32 bits (wN). When writing parameterized code such as macros,
> this can be annoying, as macro arguments don't lend themselves to
> indexed lookups, and so generating a reference to wN in a macro that
> receives xN as an argument is problematic.
> 
> For instance, an upcoming patch that modifies the implementation of the
> cond_yield macro to be able to refer to 32-bit registers would need to
> modify invocations such as
> 
>   cond_yield	3f, x8
> 
> to
> 
>   cond_yield	3f, 8
> 
> so that the second argument can be token pasted after x or w to emit the
> correct register reference. Unfortunately, this interferes with the self
> documenting nature of the first example, where the second argument is
> obviously a register, whereas in the second example, one would need to
> go and look at the code to find out what '8' means.
> 
> So let's fix this by defining wxN aliases for all xN registers, which
> resolve to the 32-bit alias of each respective 64-bit register. This
> allows the macro implementation to paste the xN reference after a w to
> obtain the correct register name.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/assembler.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index e0fc1d424f9b..7b076ccd1a54 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -23,6 +23,14 @@
>  #include <asm/ptrace.h>
>  #include <asm/thread_info.h>
>  
> +	/*
> +	 * Provide a wxN alias for each wN register so what we can paste a xN
> +	 * reference after a 'w' to obtain the 32-bit version.
> +	 */
> +	.irp	n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
> +	wx\n	.req	w\n
> +	.endr

That's a pretty neat hack! I remember seeing code elsewhere which would
benefit from this, so might be worth a look at our other macros as I'm sure
I got annoyed by one the other day... ah yes, the SVE macros in fpsimdmacros.h

Acked-by: Will Deacon <will@kernel.org>

Will

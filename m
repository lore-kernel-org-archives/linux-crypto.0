Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14699C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 09:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4FA61582
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 09:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhC3Jxa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 05:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhC3Jw6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 05:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6BCC6198F;
        Tue, 30 Mar 2021 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617097977;
        bh=TDIuEQjclB00lgKJL1g7gDcWnY7fnhyVmjZ+P7OAOTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBF6shh3LLYK56Es/qigHfLFsXwETOgViscglwioDambiYrHw8q1Uub0gxbH6iY0P
         aNuhNmHEYQtZJE8BTUTr/gvRTWyh233afGJ954YnePRHZvPVi3kvsiWVJIHaWCh2g5
         Sp+gFHlFg6++3S/E1AD2i7VtEWiXiaZU7cHqRggSi+NXz4E/YCbUqSqK+rQqbU5XN5
         wPnKTz2SOP/InwKW98tNuq36WVLXw3jFUFSmI6C6fYOSuJo1RbTTUS6x3du9xSdfQ2
         5zcdZF9kspqqgNDOVqUOFhipXK14ue/hrvw4K+P0urfWY/aI8wCUiQ2M7qVeOw0Wjc
         Am2OiR749SFgA==
Date:   Tue, 30 Mar 2021 10:52:51 +0100
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
Subject: Re: [PATCH v2 1/9] arm64: assembler: remove conditional NEON yield
 macros
Message-ID: <20210330095250.GA5352@willie-the-truck>
References: <20210302090118.30666-1-ardb@kernel.org>
 <20210302090118.30666-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302090118.30666-2-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 02, 2021 at 10:01:10AM +0100, Ard Biesheuvel wrote:
> The users of the conditional NEON yield macros have all been switched to
> the simplified cond_yield macro, and so the NEON specific ones can be
> removed.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/assembler.h | 70 --------------------
>  1 file changed, 70 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

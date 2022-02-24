Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA47C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Feb 2022 07:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiBXHtr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Feb 2022 02:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiBXHtr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Feb 2022 02:49:47 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9432417581F;
        Wed, 23 Feb 2022 23:49:17 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id AA15B200230;
        Thu, 24 Feb 2022 07:49:15 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id C136580654; Thu, 24 Feb 2022 08:47:59 +0100 (CET)
Date:   Thu, 24 Feb 2022 08:47:59 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        bigeasy@linutronix.de, Sultan Alsawaf <sultan@kerneltoast.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: do crng pre-init loading in worker rather than
 irq
Message-ID: <Yhc4LwK3biZFIqwQ@owl.dominikbrodowski.net>
References: <20220223185511.628452-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223185511.628452-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Wed, Feb 23, 2022 at 07:55:11PM +0100 schrieb Jason A. Donenfeld:
> Taking spinlocks from IRQ context is problematic for PREEMPT_RT. That
> is, in part, why we take trylocks instead. But apparently this still
> trips up various lock dependency analyzers. That seems like a bug in the
> analyzers that should be fixed, rather than having to change things
> here.
> 
> But maybe there's another reason to change things up: by deferring the
> crng pre-init loading to the worker, we can use the cryptographic hash
> function rather than xor, which is perhaps a meaningful difference when
> considering this data has only been through the relatively weak
> fast_mix() function.
> 
> The biggest downside of this approach is that the pre-init loading is
> now deferred until later, which means things that need random numbers
> after interrupts are enabled, but before workqueues are running -- or
> before this particular worker manages to run -- are going to get into
> trouble. Hopefully in the real world, this window is rather small,
> especially since this code won't run until 64 interrupts had occurred.
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Sultan Alsawaf <sultan@kerneltoast.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/random.c | 62 ++++++++++++-------------------------------
>  1 file changed, 17 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 536237a0f073..9fb06fc298d3 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1298,7 +1278,12 @@ static void mix_interrupt_randomness(struct work_struct *work)
>  	local_irq_enable();
>  
>  	mix_pool_bytes(pool, sizeof(pool));
> -	credit_entropy_bits(1);
> +
> +	if (unlikely(crng_init == 0))
> +		crng_pre_init_inject(pool, sizeof(pool), true);
> +	else
> +		credit_entropy_bits(1);
> +
>  	memzero_explicit(pool, sizeof(pool));
>  }

Might it make sense to call crng_pre_init_inject() before mix_pool_bytes?
Otherwise, all looks fine:

	Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks
	Dominik

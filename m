Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE18C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 14:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiB1ODm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 09:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiB1ODl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 09:03:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED81026126;
        Mon, 28 Feb 2022 06:03:02 -0800 (PST)
Date:   Mon, 28 Feb 2022 15:02:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646056981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EjFJ3Fa2md9hPbH1gPAnTy1aNT3a4ma1Wibufn7mhms=;
        b=lFbSEZB72GcPAMGGDqd3KgnWB2SnI0ZCM+mfNi1trHwG9/JvYIR9l/roxpUy8oPyONKJa7
        cM5OkDBg1Jm3IN9eKMOYCrfpuAGy3/UvenMnqxVDORSN4BPV+CU3shjQREtMIs2RtGqEnY
        ODVJPKVP2CncPVQaO3X7IhDuhaIFCoULYNQOlmv4Ywpyq6zvPKhq56OsTeTWYUMotch5Jf
        4vmc6FPJer7UXH2OmCX28hwCGY0TzFOQBD+e2KfYBy6Fp7grex50LFxD3w7dynS0SxHRhW
        mUQrewTrOS7lWl44INCmURyl4S3Owc1Wfx/NsEFp9vnYGGL+dHuRAnKKP7/olg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646056981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EjFJ3Fa2md9hPbH1gPAnTy1aNT3a4ma1Wibufn7mhms=;
        b=Te8EpztFgOFTPBh58alfjFwcW1eOnaEQozL5RpTtdvNER1oLk7mquDni8O3F7y71she6PA
        tpNbTMhHUCwhkJDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v2] random: do crng pre-init loading in worker rather
 than irq
Message-ID: <YhzWE1NqYQFKeL5B@linutronix.de>
References: <CAHmME9pTfwbs9xUJy_jrdPcrhSyVixSXBM==9EuB8v7ufWe9Pw@mail.gmail.com>
 <20220224152937.12747-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220224152937.12747-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-02-24 16:29:37 [+0100], Jason A. Donenfeld wrote:
> Taking spinlocks from IRQ context is problematic for PREEMPT_RT. That
> is, in part, why we take trylocks instead. But apparently this still
> trips up various lock dependency analyzers. That seems like a bug in the
> analyzers that should be fixed, rather than having to change things
> here.

Could you please post a lockdep report so I can take a look?

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
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Other than that:

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

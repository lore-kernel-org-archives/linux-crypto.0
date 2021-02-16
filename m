Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AA1C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Feb 2021 10:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B32464DCF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Feb 2021 10:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhBPKfy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Feb 2021 05:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhBPKfw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Feb 2021 05:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F0264E00;
        Tue, 16 Feb 2021 10:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613471711;
        bh=2W9VGlDi6NiRZ8mjUgWkcUO+fkrD9CT0ZH5lsbWfrEU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DXioZDTwzPDIlGSizhs8rWfUJYgS2Tuc+cqT64jvlfj5io8N1/9EA8f0M/fEqAYec
         NVlXcOi79+2xaXle0ruTahXbL6TVK6wMOB1ryXzPQQB0GmNBkoJQgEyLyAxcvO2Snb
         81y8KWvP6O5S380MdroFj3g4PclQDrp0RLn2cyB0IUrdy4vIfpWOmS5OYOZQQS76El
         oBOrWlsnDNKSdBO0HoiUB9OUhaZlThamowPKwu4ZWpi91GzgOjGFheChSl2bWsX/Am
         XfglT+NOibIQbjCRGvb/qplT4XOfo1fQ++xh2lRQddEOxREimtlmhA7kW1QZFcivdQ
         kLQFmr+coLqbg==
Received: by mail-ot1-f50.google.com with SMTP id v3so3417165ota.2;
        Tue, 16 Feb 2021 02:35:11 -0800 (PST)
X-Gm-Message-State: AOAM530BEETGY2LLO3JItTsaYBcYSppWj6y1LtNSMJjStQjFYURe9cAB
        dJldha0xWck5eJOrp1I98ZlcHJ64xhOYX6Ipiu8=
X-Google-Smtp-Source: ABdhPJyWByBh4t+YLoIidK425VY3U+5gCaJa9ZbH9+97hLCz2MlNfVj5MPl5EAFmD3PwVx1tR8IiZbqtvuOKMFZdzKk=
X-Received: by 2002:a05:6830:1285:: with SMTP id z5mr14564809otp.90.1613471710852;
 Tue, 16 Feb 2021 02:35:10 -0800 (PST)
MIME-Version: 1.0
References: <20201218170106.23280-1-ardb@kernel.org> <YCuZwWWGtqf8PaAf@hirez.programming.kicks-ass.net>
In-Reply-To: <YCuZwWWGtqf8PaAf@hirez.programming.kicks-ass.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Feb 2021 11:35:00 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEiq-s8ZQQXS-ERwAkNXnsM8G0P=Pc61orw5upTqexuCA@mail.gmail.com>
Message-ID: <CAMj1kXEiq-s8ZQQXS-ERwAkNXnsM8G0P=Pc61orw5upTqexuCA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] running kernel mode SIMD with softirqs disabled
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 16 Feb 2021 at 11:10, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Dec 18, 2020 at 06:01:01PM +0100, Ard Biesheuvel wrote:
> > [ TL;DR for the non-ARM folks on CC: disabling softirq processing when using
> >   SIMD in kernel mode could reduce complexity and improve performance, but we
> >   need to decide whether we can do this, and how much softirq processing
> >   latency we can tolerate. If we can find a satisfactory solution for this,
> >   we might do the same for x86 and 32-bit ARM as well. ]
>
> > - could we do the same on x86, now that kernel_fpu_begin/end is no longer
> >   expensive?
>
> Can't we simply save/restore the relevant register set?
>
> So something like (note amluto was wanting to add a regset argument):
>
>         <task>
>         kernel_fpu_begin(MMX)
>                 <SIRQ>
>                 kernel_fpu_begin(SSE)
>                 kernel_fpu_end();
>                 </SIRQ>
>         ...
>         kernel_fpu_end()
>
> Would have to save the MMX regs on first SIRQ invocation of
> kernel_fpu_begin(), and then have softirq context termination </SIRQ>
> above, restore it.
>
> I mean, we already do much the same for the first kernel_fpu_begin(),
> that has to save the user registers, which will be restore when we go
> back to userspace.
>
> So why not do exactly the same for softirq context?

That is what we originally had on arm64, with per-CPU buffers of the
appropriate size. This became a bit messy when SVE support was added,
because the register file is so large (32 registers of up to 2048 bits
each), and since the kernel does not use SVE itself, we want the inner
per-CPU buffer to only cover 128 bits per register. This means we
cannot allow the <sirq></sirq> region above to interrupt the outer
preserve (which is implemented entirely in software), since resuming
the outer preserve after a sirq would preserve content that was
corrupted by the inner preserve/restore. This could be addressed by
disabling interrupts across the outer preserve, but this caused a
problem somewhere else (Dave might remember the details better than I
do). So we ended up making SIMD in task context mutually exclusive
with SIMD in softirq context, also because that is what 32-bit ARM and
x86 were already doing as well.

But I understand that these concerns may not apply to x86 at all, so
perhaps the answer there is indeed to have a alternate buffer. And
actually, Andy L. suggested the same when I asked him about it on IRC.

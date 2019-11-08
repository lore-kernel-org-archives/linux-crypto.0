Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9A9C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 14:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF47222C2
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 14:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OOPohQJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfKHOZB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 09:25:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53858 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKHOZA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 09:25:00 -0500
Received: by mail-wm1-f67.google.com with SMTP id x4so6371062wmi.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 06:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gUH4+Lm6b2RAa+J5G3J4eSOSx9Rht8sSIZqgyzmifHg=;
        b=OOPohQJgjzXM5esm9IVn7ZP7DTQnG6wv/sLjnhsIkYAQhg1XLyEjh3q+cBPPO3oiAI
         1DTpQ0+OxReSWYJYHy91bmVqLKlc6bkjNpdXYp/VCcXt+ycZQybsnjGYf708EwbCaFOf
         /wjbFML2mIu+u4I/ScuBJ+nQwlOTkXvp6+mtC2DR3r+fZI/iSkAeGT/VtwyidSInPMqf
         oFhp9qRk/6zuUG40eX7jEuBdJC1seiHIVAhlg1O/7KJTSytPGf7k59J4Jfeg93EHPHk0
         X9ANsbIu6VWv22c0K8BDLdXdP0Ci4pG+Rf7n09Gf9I8YcXph4yl6i6Hc1GzwVucIi0uI
         t10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gUH4+Lm6b2RAa+J5G3J4eSOSx9Rht8sSIZqgyzmifHg=;
        b=tMlgINVxpjPg13KaG4nukOETcdI/b/8kua6GH9FyaaUwfWGVvIGUcNjFD9qsc/0lby
         NLLsFygpIabdSgp+OSFZ8KlBZ2X6e/ZqYtnqq+c9YK1OQWP9YNL9iryzQxU7Qvu3v6FR
         dLfQnHy3kczX6DLVRkFtgpbWNoyX5Fbj69tgSB+aqHrj1/GLk4x3kwmXTgu3IJ4QVkaT
         504laS2a2DNgCcASGRksyffdfT421+pzkCAFf7vqHL61PXfFbyYNkFyqgxKU+3fygOM7
         fGGXgenbnauFHDhR2mYu1sb952FC1zp+TLNeEPpoqcL/oXD3kqlydrKlfJ9eFL7Z3FIU
         3uAQ==
X-Gm-Message-State: APjAAAWP9Sxt5xORaQS2IQcf0dw6Ppppj/bXUIUf1b+byixyI2gNi+q7
        I092RxbS/q5Nv9PTcy0H45TC9EXeyCkwTP7p4fjv8A==
X-Google-Smtp-Source: APXvYqwzFYQzPSwEpI7+L9ZLBntpvcT7bMu46NXIEtFFkGcktflwFwohBfhby+Ol+NY7FYQgfPccWjwW+U3uFxHpyX4=
X-Received: by 2002:a7b:c392:: with SMTP id s18mr7713080wmj.61.1573223098484;
 Fri, 08 Nov 2019 06:24:58 -0800 (PST)
MIME-Version: 1.0
References: <20191106141954.30657-1-rth@twiddle.net> <20191106141954.30657-2-rth@twiddle.net>
 <CAKv+Gu8pb5pBFBg0wGoORmaS6yzmoX7L45LLnhuZhqw4JX7d+w@mail.gmail.com>
 <23ce309b-1561-ed95-7ce7-463a991bd19b@linaro.org> <CAKv+Gu-03HLED79e+V2D5BtSjRwHH7=rnUWyqZ7dBBD-s7RowQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu-03HLED79e+V2D5BtSjRwHH7=rnUWyqZ7dBBD-s7RowQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 15:24:46 +0100
Message-ID: <CAKv+Gu8y4zwpesytU7vffSCuq8YAjWcHwFHwa_LhTW_cLiSfQw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] arm64: Implement archrandom.h for ARMv8.5-RNG
To:     Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Nov 2019 at 14:03, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Fri, 8 Nov 2019 at 12:10, Richard Henderson
> <richard.henderson@linaro.org> wrote:
> >
> > On 11/6/19 10:30 PM, Ard Biesheuvel wrote:
> > > On Wed, 6 Nov 2019 at 15:20, Richard Henderson
> > > <richard.henderson@linaro.org> wrote:
> > >> +static inline bool has_random(void)
> > >> +{
> > >> +       /*
> > >> +        * We "have" RNG if either
> > >> +        * (1) every cpu in the system has RNG, or
> > >> +        * (2) in a non-preemptable context, current cpu has RNG.
> > >> +        * Case 1 is the expected case when RNG is deployed, but
> > >> +        * case 2 is present as a backup in case some big/little
> > >> +        * system only has RNG on big cpus, we can still add entropy
> > >> +        * from the interrupt handler of the big cpus.
> > >
> > > I don't understand the reference to the interrupt handler here.
> >
> > To add_interrupt_randomness(), invoked by handle_irq_event_percpu().
> > Better if I reword the above to include the function name?
> >
>
> This is one of the several places where arch_random_get_seed_long() is
> called, so if you are going to single it out like that, it does make
> sense to clarify that.
>

Looking more carefully at that code, it seems we call
arch_get_random_seed_long() NR_CPUS times per second, and assuming
that our RNDRRS sysreg will be reseeded from a resource that is shared
between all the cores, I am now wondering if this is such a good fit
after all, especially in the context of virtualization and
accessibility of both sysregs all the way down to EL0.

I propose we go with RNDR instead, at least for the time being, and
once actual hardware appears, we can try to figure out how these
pieces best fit together.


> > > It is
> > > worth mentioning though that this arrangement permits
> > > rand_initialize() to use the instructions regardless of whether they
> > > are implemented only by the boot CPU or by all of them.
> >
> > Yes, I'll include that.
> >
> >
> > r~

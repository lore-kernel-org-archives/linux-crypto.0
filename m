Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A20DFC6194
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 13:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFAC52245B
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 13:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bRgco/j6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKHND4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 08:03:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55656 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfKHNDz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 08:03:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so6095287wmb.5
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 05:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RD3rCfuQNE2f6lJThi4WImY0CO33DjtVpBFoOhDzKvA=;
        b=bRgco/j6fJMrPrbhgZZvBs1Cx7s60pHxKUupeQ9oSiAO+j59MSXWl5ZycYmUdl4N+n
         LBzf56vqaExjhUDzR7jxVXOldV7wJbk+AuIiSZSLxp5JfP32Cd1DbPVl3V7S4GUEJEnP
         13G+dqk59eT7kGI4uHyXESl+fEq/UyX9sD45Z8DvOazsg5sJBGbhUjeDkqWA+gvOmpFG
         RYRfaoSjM93UVhHNudlSXaYwMW4I5+ICRg+hPm9efN2S4a7lbMEVD+lDu2JbOk8pIprH
         rt0r4IXHPz/l4pDogHC2pDCaN4phRztbjYx/BvT3ecuoATtLB3lw1yFgaBFPT8d6fv4h
         1tzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RD3rCfuQNE2f6lJThi4WImY0CO33DjtVpBFoOhDzKvA=;
        b=h5SHtwaCZ4ZGuMYI6PfUUynFh1APuP2q4v3SXt6lrY7SkZTrrCopBNsP4rOBcKXDkm
         cnwyjByMFn6RuUJXpPUPkg7DExdYErQcbiwzRE75/e0gRxkr7TSUc28cwX9eYOOCo8Jp
         fjLxgTPBNWJqj5cdgcCSiVxlxPght1xQkjiXPW0jcrx4/G97jCq3yVQqo6YSbCDj8yOh
         L371vsfdRq6R1PjMlnEIALd2MNHNFTa1ZdZIsFhNVrcDGZTsKO2pwArIfbMzzY+6M4p6
         ttwqVS3t+w3hFGwFTvPsFWjnMj7h/ixBwEMCtQ/8xe6WAQ0Mmovhz2m0lay3hfCDdOIb
         ryUA==
X-Gm-Message-State: APjAAAVGnhGb16TQ4u6MZfmWCS6h8ngh2mB0HygYFjrKUXRfrWeGAmqu
        Fvgux9ZJRk5aWR+zAs/LcQNpqroDuQpPsHpqMGPLLg==
X-Google-Smtp-Source: APXvYqwVxXQ7j7sjMh42No+5ULXztDWEexSCaMNrkoPLsNQPovd1PYbjQHTIWgODnj/ocS5b09k5EQx7FekbMjHu+v4=
X-Received: by 2002:a1c:64d6:: with SMTP id y205mr7605417wmb.136.1573218233883;
 Fri, 08 Nov 2019 05:03:53 -0800 (PST)
MIME-Version: 1.0
References: <20191106141954.30657-1-rth@twiddle.net> <20191106141954.30657-2-rth@twiddle.net>
 <CAKv+Gu8pb5pBFBg0wGoORmaS6yzmoX7L45LLnhuZhqw4JX7d+w@mail.gmail.com> <23ce309b-1561-ed95-7ce7-463a991bd19b@linaro.org>
In-Reply-To: <23ce309b-1561-ed95-7ce7-463a991bd19b@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 14:03:42 +0100
Message-ID: <CAKv+Gu-03HLED79e+V2D5BtSjRwHH7=rnUWyqZ7dBBD-s7RowQ@mail.gmail.com>
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

On Fri, 8 Nov 2019 at 12:10, Richard Henderson
<richard.henderson@linaro.org> wrote:
>
> On 11/6/19 10:30 PM, Ard Biesheuvel wrote:
> > On Wed, 6 Nov 2019 at 15:20, Richard Henderson
> > <richard.henderson@linaro.org> wrote:
> >> +static inline bool has_random(void)
> >> +{
> >> +       /*
> >> +        * We "have" RNG if either
> >> +        * (1) every cpu in the system has RNG, or
> >> +        * (2) in a non-preemptable context, current cpu has RNG.
> >> +        * Case 1 is the expected case when RNG is deployed, but
> >> +        * case 2 is present as a backup in case some big/little
> >> +        * system only has RNG on big cpus, we can still add entropy
> >> +        * from the interrupt handler of the big cpus.
> >
> > I don't understand the reference to the interrupt handler here.
>
> To add_interrupt_randomness(), invoked by handle_irq_event_percpu().
> Better if I reword the above to include the function name?
>

This is one of the several places where arch_random_get_seed_long() is
called, so if you are going to single it out like that, it does make
sense to clarify that.

> > It is
> > worth mentioning though that this arrangement permits
> > rand_initialize() to use the instructions regardless of whether they
> > are implemented only by the boot CPU or by all of them.
>
> Yes, I'll include that.
>
>
> r~

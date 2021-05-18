Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C722C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 14:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE7376100C
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 14:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbhERO5y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 10:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbhERO5x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 10:57:53 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB15C061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 07:56:35 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id v6so11944425ljj.5
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 07:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GIgWhqGcodNJt+bhmadIRku1GYGWA9BQY8QV+rt7Hg=;
        b=SN/bhWDUJ2SkBrO/ViOth1isjAPZnYWzCwPZ44mO97QnaN+zuhO5YuiWSqpMCEBe32
         eEnYvdyPJ4sVC4dfBW20qujRJ8QsR0Q+Ir7WBgaSE9L/1h6IgNSaa8lgmghnrhMEDf46
         1m6lR628LVmKdGAvvXtGWXQWZawohBG0sHO9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GIgWhqGcodNJt+bhmadIRku1GYGWA9BQY8QV+rt7Hg=;
        b=RzGQ6z0QCa152IX9I3UNEOMqEEGOIk9gJ0KHxb+Dr371zy/t9iLvVSL48TxFRc4zAa
         uyWRXzxq31zpy+3iPMdpBrjk97P0MJ7SlcS83Y4rbHwo1EIlnVzuMiQ7Rs9YWbQF3STI
         c6GjpgJoviKHmNw8twT6Wa13fYYrMVudGH3oO8QgwekPX8XFjJbosDtgYZQL7dE6OPL1
         NvYjUFkudnFmG0LIsRWleks4yy+jCVConbV7dCW87VE0fqChCWCtrAIbVNYtqX8InZWj
         okmJOG5fg+tE2pWKs6wn2e5IY6ETHCYfeluZzG9dTR88U7un6Y4xHukw6q9x2SK7artQ
         u5kw==
X-Gm-Message-State: AOAM530rlDHu7KPUWx+2qlq240soJlU7SS9/HZ9Bin839di+A6G1NA//
        d2L50QsG7rcl6033HDQCXTMxDJzSYV+1z2Vh
X-Google-Smtp-Source: ABdhPJwLbtDIA4/CWmvEgVvdJAge9UHeuPv94E1PWkn2rEutk1Mny14od/dkAYZnXSqP/e0+J1E7mA==
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr776408ljm.244.1621349793875;
        Tue, 18 May 2021 07:56:33 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id f13sm203316lfv.263.2021.05.18.07.56.32
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 07:56:33 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id i9so14573946lfe.13
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 07:56:32 -0700 (PDT)
X-Received: by 2002:a19:c3d1:: with SMTP id t200mr4305910lff.421.1621349792609;
 Tue, 18 May 2021 07:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210514100106.3404011-1-arnd@kernel.org> <20210514100106.3404011-8-arnd@kernel.org>
 <YKLlyQnR+3uW4ETD@gmail.com> <CAK8P3a0iqe5V6uvaW+Eo0qiwzvyUVavVEfZGwXh4s8ad+0RdCg@mail.gmail.com>
In-Reply-To: <CAK8P3a0iqe5V6uvaW+Eo0qiwzvyUVavVEfZGwXh4s8ad+0RdCg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 May 2021 07:56:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjjo+F8HVkq3eLg+=7hjZPF5mkA4JbgAU8FGE_oAw2MEg@mail.gmail.com>
Message-ID: <CAHk-=wjjo+F8HVkq3eLg+=7hjZPF5mkA4JbgAU8FGE_oAw2MEg@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] asm-generic: unaligned always use struct helpers
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 12:27 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > I wonder if the kernel should do the same, or whether there are still cases
> > where memcpy() isn't compiled optimally.  armv6/7 used to be one such case, but
> > it was fixed in gcc 6.
>
> It would have to be memmove(), not memcpy() in this case, right?

No, it would simply be something like

  #define __get_unaligned_t(type, ptr) \
        ({ type __val; memcpy(&__val, ptr, sizeof(type)); __val; })

  #define get_unaligned(ptr) \
        __get_unaligned_t(typeof(*(ptr)), ptr)

but honestly, the likelihood that the compiler generates something
horrible (possibly because of KASAN etc) is uncomfortably high.

I'd prefer the __packed thing. We don't actually use -O3, and it's
considered a bad idea, and the gcc bug is as such less likely than
just  the above generating unacceptable code (we have several cases
where "bad code generation" ends up being an actual bug, since we
depend on inlining and depend on some code sequences not generating
calls etc).

But I hate how gcc is buggy in so many places here, and the
straightforward thing is made to explicitly not work.

I absolutely despise compiler people who think it's ok to generate
known bad code based on pointless "undefined behavior" arguments - and
then those same clever optimizations break even when you do things
properly.  It's basically intellectual dishonesty - doing known
fragile things, blaming the user when it breaks, but then not
acknowledging that the fragile shit they did was broken even when the
user bent over backwards.

                Linus

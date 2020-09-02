Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A550C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 11:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 078FA20767
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 11:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoKgXsRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIBLgT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 07:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIBLgR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 07:36:17 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E85C061244
        for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2020 04:36:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g72so3942045qke.8
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2020 04:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MLLPk7NvmJ6VBdidlxADGwLEm/oJvwjIDd/BdqgjOPA=;
        b=AoKgXsRnjDpZvaS9gM7wKlK4fxxqY60oUaHywqusoAujffWJM6l2zw7E01Ky1j/Qrv
         Bd5hkZkricrPPv0omoqvw+GcYzyN57x++5mR09pNz5LDuF9PN6IpdHPsD5bhBzlOXqDf
         AWQmnvmFxZJLphdN4hXfO5V7cKtGzFTyAhR/L3JAnIR2k4Engwu2FioqQ+fd77U7GBWN
         427OuA5Lv1vjEUYPth9HaRK1jkgB/FYE5Q22iVKe5QxhAgim/9R4gxH3jcGHkdjllXmp
         rG2lQxOmqyaj8bin+nRTf/9C46GwKaNan7XTlpo+MT7p+yQQ/kETJn/TdTqe1xLMZ5vN
         0ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MLLPk7NvmJ6VBdidlxADGwLEm/oJvwjIDd/BdqgjOPA=;
        b=bOXMoprIsFAowTsp5IinRQijQhaKu8WU/nxocwd1odmY8dMpJlqT9QmX/C0RupS4ve
         9SwJ/1DMeYZmW22ZUsRuCmLZB3xDwoN0kRXOoSqNAnvrqKkSLAfuEbwb+BMZ8+6oh9DG
         xt28GI6UXToP4nLR5KWxWmfv/lt7OoIfE2iZC4dFIXE0GVAqN//FYvVxmHZ7BzWpH6b6
         pS3eBahKPLRIR/9sGL8K8lc/NOI0gTOTizd0hbzrk4eSnLoewq4+5MEcCVCfsWveJ9kH
         ISmBVF3AdTh9bJH+sGovvK2Yc97y07L9GVDN26cDmeI1jhawZZ+R8/LfvfFYzqsXPafM
         A3nw==
X-Gm-Message-State: AOAM532NltDV5YRsQcHWZA3VE4TKsKsfS4fOYlw8m/Y5PQ9wdzE4SlRT
        cpvXfOuUAEdc7Lp5+DYABXxIoiibW0iAeGt58BM=
X-Google-Smtp-Source: ABdhPJyJzw8btaColEDPcUFHG20sdnYUYEy58zDLEFmIDiQfD0K3Yv9298InY5pWiB6ngljFpnKbGXHh2lXEwK84wnc=
X-Received: by 2002:a37:68c7:: with SMTP id d190mr6220610qkc.127.1599046576101;
 Wed, 02 Sep 2020 04:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173058.94519-1-ubizjak@gmail.com> <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
 <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com>
 <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
 <CAFULd4ZH3s=9nsvNE8Sxf=r-KZJX5NKxFehNo7YU2=2ExwbsQQ@mail.gmail.com> <20200902091741.GX1362448@hirez.programming.kicks-ass.net>
In-Reply-To: <20200902091741.GX1362448@hirez.programming.kicks-ass.net>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 2 Sep 2020 13:36:05 +0200
Message-ID: <CAFULd4bJRuvzKvY7n76o-23fy0ik43Or2B_Os-u9u6269BrSKQ@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Karthik Bhargavan <karthikeyan.bhargavan@inria.fr>,
        Chris.Hawblitzel@microsoft.com,
        Jonathan Protzenko <protz@microsoft.com>,
        Aymeric Fromherz <fromherz@cmu.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 2, 2020 at 11:17 AM <peterz@infradead.org> wrote:
>
> On Wed, Sep 02, 2020 at 07:50:36AM +0200, Uros Bizjak wrote:
> > On Tue, Sep 1, 2020 at 9:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Tue, Sep 1, 2020 at 8:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > > operands are the same. Also, have you seen any measurable differences
> > > > when benching this? I can stick it into kbench9000 to see if you
> > > > haven't looked yet.
> > >
> > > On a Skylake server (Xeon Gold 5120), I'm unable to see any measurable
> > > difference with this, at all, no matter how much I median or mean or
> > > reduce noise by disabling interrupts.
> > >
> > > One thing that sticks out is that all the replacements of r8-r15 by
> > > their %r8d-r15d counterparts still have the REX prefix, as is
> > > necessary to access those registers. The only ones worth changing,
> > > then, are the legacy registers, and on a whole, this amounts to only
> > > 48 bytes of difference.
> >
> > The patch implements one of x86 target specific optimizations,
> > performed by gcc. The optimization results in code size savings of one
> > byte, where REX prefix is omitted with legacy registers, but otherwise
> > should have no measurable runtime effect. Since gcc applies this
> > optimization universally to all integer registers, I took the same
> > approach and implemented the same change to legacy and REX registers.
> > As measured above, 48 bytes saved is a good result for such a trivial
> > optimization.
>
> Could we instead implement this optimization in GAS ? Then we can leave
> the code as-is.

I don't think that e.g. "xorq %rax,%rax" should universally be
translated to "xorl %eax,%eax" in the assembler. Perhaps the author
expected exactly 3 bytes (to align the code or similar), and the
assembler would change the length to 2 bytes behind his back, breaking
the expectations.

Uros.

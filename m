Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381D3C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 15:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA882078E
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 15:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oiLdwJt5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIBPAX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:00:23 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:38823 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgIBPAT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 11:00:19 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f20b84ad
        for <linux-crypto@vger.kernel.org>;
        Wed, 2 Sep 2020 14:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=i9rH/PEnRK3NX/H+oGyvx4NJxYg=; b=oiLdwJ
        t5NqSXdIDEPqRdOhnWtIbYXIY7XJ8FXJq9of9nmVxZuJciZ2wid7+onwzCeIrIsl
        M0NPClRTGtwvYWhfF1AiL5vtKUXOXjMETSx1lksp2sRLZjaaFGVcQBZ6WnLpqqlb
        nOn38CMIN7h+T03rFEecPnsRZhkDZf98x4uC+NRwQyHrBeh4mxPbfm2xmPJRnxXP
        lcgs2+oWNFN21ceV9g2IOqet2pSyWtJAtkkgDL4Aai7liwHuSbpHjUKleau/Z6d9
        /ZJAQVEYS5KnRyYiK6HKNcE7shyd9jEc9m9E8NL+u4wvg4uv/xKNaQYQXG1SesrK
        /OyyMIQUEk3+nCSw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aaf55646 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Wed, 2 Sep 2020 14:32:08 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id b6so5578483iof.6
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2020 08:00:16 -0700 (PDT)
X-Gm-Message-State: AOAM530I1AlEXejUc0BrJbL8O4WX+9iQwfR68fchDn8edNkLZmAcMbfN
        3SqZ/q3lLEdku0NtJwEnnT9/fHGezoWAg9REZ+c=
X-Google-Smtp-Source: ABdhPJwnI30eVkOvK/xg7cqynC3X78cUfpqleORnbJv9unZuptoh1KNZvjq2Nhsf3ATaKqs3hp6eOdc91OQ/tmsHHkA=
X-Received: by 2002:a6b:7112:: with SMTP id q18mr3701689iog.79.1599058815143;
 Wed, 02 Sep 2020 08:00:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173058.94519-1-ubizjak@gmail.com> <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
 <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com>
 <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
 <CAFULd4ZH3s=9nsvNE8Sxf=r-KZJX5NKxFehNo7YU2=2ExwbsQQ@mail.gmail.com>
 <20200902091741.GX1362448@hirez.programming.kicks-ass.net> <CAFULd4bJRuvzKvY7n76o-23fy0ik43Or2B_Os-u9u6269BrSKQ@mail.gmail.com>
In-Reply-To: <CAFULd4bJRuvzKvY7n76o-23fy0ik43Or2B_Os-u9u6269BrSKQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Sep 2020 17:00:03 +0200
X-Gmail-Original-Message-ID: <CAHmME9qn1yLwaTiFabPBTpjYgjd2f+SiM0-DtmTAQ=Sz7qnidg@mail.gmail.com>
Message-ID: <CAHmME9qn1yLwaTiFabPBTpjYgjd2f+SiM0-DtmTAQ=Sz7qnidg@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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

On Wed, Sep 2, 2020 at 1:42 PM Uros Bizjak <ubizjak@gmail.com> wrote:
>
> On Wed, Sep 2, 2020 at 11:17 AM <peterz@infradead.org> wrote:
> >
> > On Wed, Sep 02, 2020 at 07:50:36AM +0200, Uros Bizjak wrote:
> > > On Tue, Sep 1, 2020 at 9:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > On Tue, Sep 1, 2020 at 8:13 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > > > operands are the same. Also, have you seen any measurable differences
> > > > > when benching this? I can stick it into kbench9000 to see if you
> > > > > haven't looked yet.
> > > >
> > > > On a Skylake server (Xeon Gold 5120), I'm unable to see any measurable
> > > > difference with this, at all, no matter how much I median or mean or
> > > > reduce noise by disabling interrupts.
> > > >
> > > > One thing that sticks out is that all the replacements of r8-r15 by
> > > > their %r8d-r15d counterparts still have the REX prefix, as is
> > > > necessary to access those registers. The only ones worth changing,
> > > > then, are the legacy registers, and on a whole, this amounts to only
> > > > 48 bytes of difference.
> > >
> > > The patch implements one of x86 target specific optimizations,
> > > performed by gcc. The optimization results in code size savings of one
> > > byte, where REX prefix is omitted with legacy registers, but otherwise
> > > should have no measurable runtime effect. Since gcc applies this
> > > optimization universally to all integer registers, I took the same
> > > approach and implemented the same change to legacy and REX registers.
> > > As measured above, 48 bytes saved is a good result for such a trivial
> > > optimization.
> >
> > Could we instead implement this optimization in GAS ? Then we can leave
> > the code as-is.
>
> I don't think that e.g. "xorq %rax,%rax" should universally be
> translated to "xorl %eax,%eax" in the assembler. Perhaps the author
> expected exactly 3 bytes (to align the code or similar), and the
> assembler would change the length to 2 bytes behind his back, breaking
> the expectations.

Are you sure that's something that GAS actually provides now? Seems
like a lot of mnemonics have ambiguous/injective encodings, and this
wouldn't make things any different. Most authors use .byte or .align
when they care about the actual bytes, no?

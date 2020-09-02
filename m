Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06B5C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 14:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDAB2078E
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 14:58:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="02gapqX7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgIBO6z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:58:55 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:34591 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgIBO6Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 10:58:25 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 11d4df21
        for <linux-crypto@vger.kernel.org>;
        Wed, 2 Sep 2020 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=0nCqNljMSjwOAKDwdZdX8MZKQ+8=; b=02gapq
        X7UC/SHQx3rh1OxxnQoh5pfOoSgp2IwRAVxhQ2en0yRGw9I04IQ/yt5+7zTzw5DX
        VkkmDXwShxsbfGiFy6K4WwSyjtDQwFlXyRHtWD3SnX3aOpJchwpLAucclsVo3voV
        Ma9ZXEwZW6okLVDdeH84WYchJby6dwI8RXaZMVc8VlqoA0sP82tKiNHkeSItvZOf
        m3Zk/ctLf76ACkedGcKeKpmRVOyi0pl+epGLkTeAjk6pdYS3rC6r/mtq+Y6PbYSf
        lewSq3FRQkvcNwpMBSY16q9Gw6+P6vCfIeTqnih9R0C6k8WDJUrO79FfECa4kMob
        vYUtulzOngP//GWQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 192d5b0b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Wed, 2 Sep 2020 14:30:11 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id m23so6084018iol.8
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2020 07:58:19 -0700 (PDT)
X-Gm-Message-State: AOAM530xao7rAs3Kai7SmzGtbFHRe7GVnzCj5/hUUZ5LBG257JcxRolE
        Uqm7Vm1mYCwJt+UHrbjdRqp3+i3E2tFMRO7Ck8o=
X-Google-Smtp-Source: ABdhPJwlDAhRzOW7eR8Ne4bX77l9oE7iYpzovBE5e54LqUB/XvsP3M3QCsr9zP/3zOUNdkEY055AKAVLY0yvJUeNpR8=
X-Received: by 2002:a6b:b98a:: with SMTP id j132mr3767983iof.67.1599058698024;
 Wed, 02 Sep 2020 07:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173058.94519-1-ubizjak@gmail.com> <CAMj1kXHChRSxAgMNPpHoT-Z2CFoVQOgtmpK6tCboe1G06xuF_w@mail.gmail.com>
 <CAHmME9p3f2ofwQtc2OZ-uuM_JggJtf93nXWVkuUdqYqxB6baYg@mail.gmail.com>
 <CAHmME9oemtY5PG9WjbOOtd_xxbMRPb1t5mPoo2rR-y3umYKd5Q@mail.gmail.com>
 <CAFULd4ZH3s=9nsvNE8Sxf=r-KZJX5NKxFehNo7YU2=2ExwbsQQ@mail.gmail.com> <20200902091741.GX1362448@hirez.programming.kicks-ass.net>
In-Reply-To: <20200902091741.GX1362448@hirez.programming.kicks-ass.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Sep 2020 16:58:06 +0200
X-Gmail-Original-Message-ID: <CAHmME9qUfAvmz+nb8pw7Fm4RVP3nj2ZiX1SJxkJYK=M7mBgC_g@mail.gmail.com>
Message-ID: <CAHmME9qUfAvmz+nb8pw7Fm4RVP3nj2ZiX1SJxkJYK=M7mBgC_g@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Uros Bizjak <ubizjak@gmail.com>,
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

On Wed, Sep 2, 2020 at 11:44 AM <peterz@infradead.org> wrote:
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

I rather like that idea. Though I wonder if some would balk at it for
smelling a bit like the MIPS assembler with its optimization pass...

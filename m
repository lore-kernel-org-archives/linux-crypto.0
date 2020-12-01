Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA8FC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01EE208C3
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKMiYKzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgLAWN0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgLAWNZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 17:13:25 -0500
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B240B2086A
        for <linux-crypto@vger.kernel.org>; Tue,  1 Dec 2020 22:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606860764;
        bh=53Kuug004oBRQ6G67nb1gdBv+0lLYRybJwxVfusFilw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fKMiYKzQ97aGcctRGbMTl/NUECWMbPtjG37v8z4/7mpffrxsl3oZFZw4ijxnJ+BGd
         5WNcNIjrTgVlSdSYhT2AyhzQKqFwQ7Zkr9OqSCXlUbNqW/4Ifi5p1TBM5HvEuoCBjA
         nKmnmkgm9nogNd2rPALS1hXj8styt9k2cWxX/KXI=
Received: by mail-ot1-f52.google.com with SMTP id e105so3246354ote.5
        for <linux-crypto@vger.kernel.org>; Tue, 01 Dec 2020 14:12:44 -0800 (PST)
X-Gm-Message-State: AOAM532WS4mYzS1O4FPPkIbLRLN643LBemzcRCLk3fcij6VjRfghb09U
        CcgermqLhWJ7rEOKyluYwiM8KtglDudk1ndKaDI=
X-Google-Smtp-Source: ABdhPJyGa9YJbiTvUEw6kJV/hYkiSJN4LWl1mFMgD+n9piE74WuYyCxOGdm1OSDc4RD50LOcjixniPCs3XsviqPekDY=
X-Received: by 2002:a05:6830:214c:: with SMTP id r12mr3426863otd.90.1606860763972;
 Tue, 01 Dec 2020 14:12:43 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com> <20201201220431.GA32072@gondor.apana.org.au>
In-Reply-To: <20201201220431.GA32072@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Dec 2020 23:12:32 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
Message-ID: <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 1 Dec 2020 at 23:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Dec 01, 2020 at 11:01:57PM +0100, Ard Biesheuvel wrote:
> >
> > This is not the first time this has come up. The point is that CCMP in
> > the wireless stack is not used in 99% of the cases, given that any
> > wifi hardware built in the last ~10 years can do it in hardware. Only
> > in exceptional cases, such as Ben's, is there a need for exercising
> > this interface.
>
> Either it matters or it doesn't.  If it doesn't matter why are we
> having this dicussion at all? If it does then fixing just one
> direction makes no sense.
>

What do you mean by just one direction? Ben just confirmed a
substantial speedup for his use case, which requires the use of
software encryption even on hardware that could support doing it in
hardware, and that software encryption currently only supports the
synchronous interface.

Even if it is nicer in theory, I don't see the point of implementing
support for the asynchronous interface, given that nobody is going to
wire up a AES accelerator to a wifi controller.

> > Also, care to explain why we have synchronous AEADs in the first place
> > if they are not supposed to be used?
>
> Sync AEADs would make sense if you were dealing with a very small
> amount of data, e.g., one block.
>

Why? The processing occurs in *exactly* the same way, given that the
wifi stack never calls into the AEAD from a context where the FPU is
unavailable. So we basically have to choose between a non-SIMD
fallback path that never gets exercised, or a SIMD async helper that
always relays the request directly, and never queues it for
asynchronous completion.

IOW, we are arguing a theoretical difference here, and the code paths
that actually get exercised are 100% the same.

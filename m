Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C16C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1385B21655
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="y7/AMJp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfJGPCJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 11:02:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38224 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGPCI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 11:02:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id w12so15746003wro.5
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 08:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gppf5ydLVlzLpYBKWg5uMeNal7mwzCjmiO49DJJEUFw=;
        b=y7/AMJp1p4yc87RqT8N+6573FN4qZ/ygLP3mwmyKX+U98jrg6Vg0a1TSyKlfKKfD0t
         9T5H/1tQPaASmsNS1G9v5aLVXpc4Zyd8nVcjywDIinzC7Y38lG1vi4d+paItNIgGu/+W
         mHD82Xl/zbTbCKQzN3g11uHer/fiyRZmdJG+La4puEhpx0sMZ0Rv5wpGZizQ1w16hp4e
         iwXvdz8Zl4kjRPMki7+MaR1XImco+vYdX09VAlSnHV5w8zlumedq+WWGroVqFQmR7YfN
         /hDf1ioc5DUJkdp1nAMr9tt27hLfd8lMYaNKtwNyJwV7zUGpeLLUfu986Fm2Cs5gf818
         Ikxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gppf5ydLVlzLpYBKWg5uMeNal7mwzCjmiO49DJJEUFw=;
        b=OaCYHtPDv1dSz6MNumHbtWCajwUIRc2tXKY8RuQRM4Quc6vuWPWWGkSmHzl4F+3L4X
         tX9OPxAbFmrZYsWX25xmufopOI9j+9PDi8MWjBW3gEt9NFBV6M4v3KYm9bDg6w7b3eK5
         h9efle8PmmACyg8BmEV/2OijPSDvBdBqSLQ4E6eqDOwIxT7eVRYzIGvUwGJhy0xyga36
         cHT2RqmkbgrPspYRlDi+6O3O1UA7IZh1VKDzhC3XZg4x//bp47wi/BNv90iXrn6QKl6A
         cNHgwXcUTS+2E9VyVZ6/7uXqL/rBOKDtRT8VqfB0GZINXDbvKzpMBssVN8pDiXPMUHEM
         DwYg==
X-Gm-Message-State: APjAAAWL+IZ+VAM6H9fSNOXC4wkXWFMX4UtypOfh8c9rmBzxwQHK9KmM
        3OL04j3+b0tGc6XdmZm9LFc9Dq1OfXMES10BfzYkmQ==
X-Google-Smtp-Source: APXvYqwpzNZt3H5NRm51SNYpFETcnDGrZgCg/r5gCkKNG3mQb/ZeNM7Lk8Bz2OyV2SCXW2vYjyzJJXGw/PmJu3kY6H4=
X-Received: by 2002:adf:dbc6:: with SMTP id e6mr22426377wrj.149.1570460526477;
 Mon, 07 Oct 2019 08:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
 <04D32F59-34D4-4EBF-80E3-69088D14C5D8@amacapital.net> <CAKv+Gu8s6AuZfdVUSmpgi-eY_9oZr-j4sdFygUOR3uvQXji+rQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu8s6AuZfdVUSmpgi-eY_9oZr-j4sdFygUOR3uvQXji+rQ@mail.gmail.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Mon, 7 Oct 2019 08:01:55 -0700
Message-ID: <CALCETrXWSu_fY5BetMah=iEOqSgkOphMOKcMrtiWyN0QqbZspw@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 6, 2019 at 10:24 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Mon, 7 Oct 2019 at 06:44, Andy Lutomirski <luto@amacapital.net> wrote:
> >

> > > Actually, this can be addressed by retaining the module dependencies
> > > as before, but permitting the arch module to be omitted at load time.
> >
> > I think that, to avoid surprises, you should refuse to load the arch module if the generic module is loaded, too.
> >
>
> Most arch code depends on CPU features that may not be available given
> the context, either because they are SIMD or because they are optional
> CPU instructions. So we need both modules at the same time anyway, so
> that we can fall back to the generic code at runtime.
>
> So what I'd like is to have the generic module provide the library
> interface, but rely on arch modules that are optional.
>
> We already have 95% of what we need with weak references. We have the
> ability to test for presence of the arch code at runtime, and we even
> have code patching for all architectures (through static relocations).
>
> However, one could argue that this is more a [space] optimization than
> anything else, so I am willing to park this discussion until support
> for static calls has been merged, and proceed with something simpler.

I'd suggest tabling it until static calls are merged.  PeterZ just
sent a new patchbomb for it anyway.

What I'm trying to get at here and apparently saying badly is that I
want to avoid a situation where lsmod shows the arch module loaded but
the arch code isn't actually executing.  Regardless of how everything
gets wired up (static calls, weak refs, etc), the system's behavior
should match the system's configuration, which means that we should
not allow any improper order of loading things so that everything
*appears* to be loaded but does not actually function.

Saying "modprobe will do the right thing and let's not worry about
silly admins using insmod directly" is not a good solution.

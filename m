Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE37C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 07:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24F02206B7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 07:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KL9ayUzJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbfI0HU7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 03:20:59 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:43763 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfI0HU7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 03:20:59 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 922ea3ef
        for <linux-crypto@vger.kernel.org>;
        Fri, 27 Sep 2019 06:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=1LvK4z4bebYeyRy2NWOqt/mYcs8=; b=KL9ayU
        zJc/qfmEI7nz+58bPgK9TifZviMg+DCK4yEz8hJKofLlQ3l0QZYwkZDaiuDWFXph
        JG9cPXitjtRxboN0da4MIPy0346bdNibRKo83z90mSLXDEOmgWHrztvkc/Af4bAR
        Cw6eDWJZ9b7bJndUiMtdy3p06lpwj3QlEkb5KKYKTqF5kV9xDUezWEQxnY260tar
        yLRHzqWGdR/eWpgqW1bjww634aDigrE6OTbLe/etR1xOBnwi1hQyZrkHoiZ9P46g
        QExWXor2Go0MAVSnmxQT7yra4ZlR8corlP3igk1RZqglSAq67oksZVOOiO1WZVvy
        inK1MY53z3oGuqww==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f869cbec (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 27 Sep 2019 06:34:58 +0000 (UTC)
Received: by mail-oi1-f177.google.com with SMTP id i185so4351130oif.9
        for <linux-crypto@vger.kernel.org>; Fri, 27 Sep 2019 00:20:57 -0700 (PDT)
X-Gm-Message-State: APjAAAVSi64NIrLeURMvcXYs17f1I6fuMFDXhIBKzjxylXaTEe5pxjHX
        IIwZYw4THrLQ/WHcXJH2Uxbkbnz06e+yzOn4C2Y=
X-Google-Smtp-Source: APXvYqwcUARmfyTwGS11cAsoNqWQhvZOTa+gXf/AbSx4BtYYIfTtEzP1YhJ3t2Kw2eJChwVE8O0CKAY+w40vgYaV5Kw=
X-Received: by 2002:a54:4807:: with SMTP id j7mr5461378oij.122.1569568856212;
 Fri, 27 Sep 2019 00:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
 <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com> <CALCETrUrbSGNfo=g=PS4=t1zzXqGAHSs5oUL46LwMgu+2aVh1Q@mail.gmail.com>
In-Reply-To: <CALCETrUrbSGNfo=g=PS4=t1zzXqGAHSs5oUL46LwMgu+2aVh1Q@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 27 Sep 2019 09:20:43 +0200
X-Gmail-Original-Message-ID: <CAHmME9pgrCY4MHcJ0Or+-5h+k3fWCjrbY50sUjNY4TdfeyBFxg@mail.gmail.com>
Message-ID: <CAHmME9pgrCY4MHcJ0Or+-5h+k3fWCjrbY50sUjNY4TdfeyBFxg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Andy,

Thanks for weighing in.

> inlining.  I'd be surprised for chacha20.  If you really want inlining
> to dictate the overall design, I think you need some real numbers for
> why it's necessary.  There also needs to be a clear story for how
> exactly making everything inline plays with the actual decision of
> which implementation to use.

Take a look at my description for the MIPS case: when on MIPS, the
arch code is *always* used since it's just straight up scalar
assembly. In this case, the chacha20_arch function *never* returns
false [1], which means it's always included [2], so the generic
implementation gets optimized out, saving disk and memory, which I
assume MIPS people care about.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/lib/zinc/chacha20/chacha20-mips-glue.c?h=jd/wireguard#n13
[2] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/lib/zinc/chacha20/chacha20.c?h=jd/wireguard#n118

I'm fine with considering this a form of "premature optimization",
though, and ditching the motivation there.

On Thu, Sep 26, 2019 at 11:37 PM Andy Lutomirski <luto@kernel.org> wrote:
> My suggestion from way back, which is at
> least a good deal of the way toward being doable, is to do static
> calls.  This means that the common code will call out to the arch code
> via a regular CALL instruction and will *not* inline the arch code.
> This means that the arch code could live in its own module, it can be
> selected at boot time, etc.

Alright, let's do static calls, then, to deal with the case of going
from the entry point implementation in lib/zinc (or lib/crypto, if you
want, Ard) to the arch-specific implementation in arch/${ARCH}/crypto.
And then within each arch, we can keep it simple, since everything is
already in the same directory.

Sound good?

Jason

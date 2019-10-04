Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2325C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C60EA20700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fupLeHwJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388870AbfJDOiQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:38:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35764 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388724AbfJDOiQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:38:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so6145938wmi.0
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XqGMWGqkSu2CUjbsrONmEy0BdBt4OpLHZ93iKxZQ8dg=;
        b=fupLeHwJfdVdxHqsSAb0Hf42rRylPl5igw2qQ2K3qvf0i8ogjEJYSf/eR1GLhZWVBa
         ornhw02W0fQvAuvEpWdtWr1Nh7ZjHJlSggUjjExhwVBBxn6NDxxmwOdpV5ix3uYLFNm6
         q3SItc9F7FvBWogCuKB+5n88JfcL/WEA0oMk8DibzugpbQVXoOFm/8g2E2Bm8y9rLnBf
         DL3zY65+RU9M7NLtvOyULEyRuQKyUvXJZGT4zwfpUJ1Bq/9UWf82dfozeTHCAJ6yU+l9
         kw/y1VJg9Fk+2K1hTvJ+3iXPXop0yjla1guDpR9C1g2FIonH1t+VRISyvwBk1WOV7B1i
         44Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XqGMWGqkSu2CUjbsrONmEy0BdBt4OpLHZ93iKxZQ8dg=;
        b=pVsbixWVBnZW+fVg+JkPzoJipARng2AkXRuUsulkYznEADVY2TSFTz3WGzHBDkiHau
         87cPVpb/HWuD5jnQd5mUtC/XZpj3ah+tzli+14CU/YZJIFCi5ZHwW1/afiCdNAHoa/Zw
         GhkGqPGcUvqtSk/5fb/9Fm8fvBes/NL4iOzjQYYIH6hGaXnAN4YjayMMkhWr992wty21
         DhbFX8HTd6izFv3ktFx260Af4qAG7Er7D5gjm6OS7ZFuiS6fH+TQJfODDpcBlZTVKwwq
         vpX9F9g0gzFkPs34UX/CGdkc1UXOdbIZ5WHCVy4k3cQzZMH5/kU//4Wb6+/60dQpp+xX
         cl7Q==
X-Gm-Message-State: APjAAAV1I6Yb57cGUF+aC4bCICPyfvA8aR23ctpyhhiKVwANDHPaD2vG
        t5Rvl9axtYL1K3tl3wtrQzl5yv/CS468W3/M98R1OA==
X-Google-Smtp-Source: APXvYqwq8uO1a+wQg/a97OpAdn5FjC1BsHiXOIqR5SD98Kyj0HrDG+xl+76O4YWecQcH3aVQvSRY90+6UESkndwublc=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr10493851wmc.136.1570199894184;
 Fri, 04 Oct 2019 07:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org> <20191004134644.GE112631@zx2c4.com>
In-Reply-To: <20191004134644.GE112631@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:38:01 +0200
Message-ID: <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 15:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 02, 2019 at 04:16:58PM +0200, Ard Biesheuvel wrote:
> > This integrates the accelerated MIPS 32r2 implementation of ChaCha
> > into both the API and library interfaces of the kernel crypto stack.
> >
> > The significance of this is that, in addition to becoming available
> > as an accelerated library implementation, it can also be used by
> > existing crypto API code such as Adiantum (for block encryption on
> > ultra low performance cores) or IPsec using chacha20poly1305. These
> > are use cases that have already opted into using the abstract crypto
> > API. In order to support Adiantum, the core assembler routine has
> > been adapted to take the round count as a function argument rather
> > than hardcoding it to 20.
>
> Could you resubmit this with first my original commit and then with your
> changes on top? I'd like to see and be able to review exactly what's
> changed. If I recall correctly, Ren=C3=A9 and I were really starved for
> registers and tried pretty hard to avoid spilling to the stack, so I'm
> interested to learn how you crammed a bit more sauce in there.
>

The round count is passed via the fifth function parameter, so it is
already on the stack. Reloading it for every block doesn't sound like
a huge deal to me.

> I also wonder if maybe it'd be better to just leave this as is with 20
> rounds, which it was previously optimized for, and just not do
> accelerated Adiantum for MIPS. Android has long since given up on the
> ISA entirely.

Adiantum does not depend on Android - anyone running linux on his MIPS
router can use it if they want encrypted storage.

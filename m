Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A57C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A7C6222C4
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cCRQm4Ah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbfJDOjF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:39:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37987 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389260AbfJDOjF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:39:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id w12so7549556wro.5
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1iRkJgnO4wVgTOHYGwPH4jyH8Xe5sWTO85OE+gYDCMw=;
        b=cCRQm4AhxWdJsZMyABy73ABvnGRYLxaQMBiPhGNjISMExnI1frj1bgCXIFqmxE7SWw
         QK7uzWDA07tkyyKaBJKPSMoKOlj4mgLA3kZ5bkYnnFyuXLlj7YeUZyYrmfWWNYuna9Tr
         5CFAtvEtMAmDztutPXVa6tVMO8T05k2NIf1eSWnRtoqe1wKBhhDIbUzvEXJJgBihse2J
         Sarajq0hcV/9yCe9wdyKoCbuYk9E3houO3PdZorYneyfTkhcILAL0eoA/JZGD/xQZFtD
         /TxzyYDTt9BmLAH+iiZAtVL0d7fn0ctUi4iYXzxlsMmYujtlPYPe1KaBdirUfd7SbTCN
         2DOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1iRkJgnO4wVgTOHYGwPH4jyH8Xe5sWTO85OE+gYDCMw=;
        b=DOTBxCALBZujD3pliHItYSfaU2jR7ozbeyoU/v/PO+FTlkzbiWkRHSsXiCxUM74i0x
         1kWArfLfnWUnEA/M2ZUw/dWrWBceyTwVc3m6wJoc5cb1jzbMy4dTmWqE08AvZQIXeLhv
         NcQWjg8u9ySc4ZSdIA/f+WQ2Uo4xKt+ffIWCSj3gl+3D1dhQHbkOy+oysxTA33Td9pH0
         68+xNihOJdkYysOKf/i+GUjnT6b6Wzxb9KEU8CSWPbWRDnQgypj+DtVamgSnEVW417pu
         C5uFyIYZJYTRgmw7bM3ViwCuwEOiLQ8YsYnK1VUveOL/mwjDgskB6DDOZqMoY62JsT2e
         LLzQ==
X-Gm-Message-State: APjAAAWNMSTqpEBPx2zVJMJgRcQKDOgcpe7N852q4HG9as5ijdkFlgKn
        bunlUg//rHaaywE9TwK8VZVf6kzlkLMqgd1cbLlXsw==
X-Google-Smtp-Source: APXvYqztaLKFLY9gajpNQOSrr4VRZ51eKi9gEacNa9s2A6Li85W8BlRVjnUHehfc80ge3jSnHU7q3NTYvXm0kJsj7l8=
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr11698232wrn.200.1570199943131;
 Fri, 04 Oct 2019 07:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org> <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:38:51 +0200
Message-ID: <CAKv+Gu8cuMcjqfDyzcShxd8cimjhKrBELjNoJ5xKgWmSzZ4S5g@mail.gmail.com>
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

On Fri, 4 Oct 2019 at 16:38, Ard Biesheuvel <ard.biesheuvel@linaro.org> wro=
te:
>
> On Fri, 4 Oct 2019 at 15:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Wed, Oct 02, 2019 at 04:16:58PM +0200, Ard Biesheuvel wrote:
> > > This integrates the accelerated MIPS 32r2 implementation of ChaCha
> > > into both the API and library interfaces of the kernel crypto stack.
> > >
> > > The significance of this is that, in addition to becoming available
> > > as an accelerated library implementation, it can also be used by
> > > existing crypto API code such as Adiantum (for block encryption on
> > > ultra low performance cores) or IPsec using chacha20poly1305. These
> > > are use cases that have already opted into using the abstract crypto
> > > API. In order to support Adiantum, the core assembler routine has
> > > been adapted to take the round count as a function argument rather
> > > than hardcoding it to 20.
> >
> > Could you resubmit this with first my original commit and then with you=
r
> > changes on top? I'd like to see and be able to review exactly what's
> > changed. If I recall correctly, Ren=C3=A9 and I were really starved for
> > registers and tried pretty hard to avoid spilling to the stack, so I'm
> > interested to learn how you crammed a bit more sauce in there.
> >
>
> The round count is passed via the fifth function parameter, so it is
> already on the stack. Reloading it for every block doesn't sound like
> a huge deal to me.
>
> > I also wonder if maybe it'd be better to just leave this as is with 20
> > rounds, which it was previously optimized for, and just not do
> > accelerated Adiantum for MIPS. Android has long since given up on the
> > ISA entirely.
>
> Adiantum does not depend on Android - anyone running linux on his MIPS
> router can use it if they want encrypted storage.

But to answer your first question: sure, i will split off the changes.

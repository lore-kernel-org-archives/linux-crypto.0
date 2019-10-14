Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D581C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 16:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5159920854
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 16:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bjQDgqCO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbfJNQHb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 12:07:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45901 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387778AbfJNQHb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 12:07:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so20340905wrm.12
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 09:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OzyZEeUp7DwxKDZLdbXyF8LuMW9/BfvpmbsTiHDXZVs=;
        b=bjQDgqCOYXjcC/4xlVUweIE1sLIVDDEvBbYuuGZ9F3ujf+bHlqPrEaTDgL2P7dKJ9e
         hDneiw2Y0tZq8xartpAB8e5CSxdo+yj7OzkAOr3QJePBg0dMGjKVueGExXxQET7tSnZz
         ELYg8xYtnDyz/DFuZpmYba34X1BUOsdlJN7uHc/yaEfuywvEh5pgH/W/XVFS64u2HuJ4
         63sDu8f4ZMDoP18d3NRRReX/LfOCHM6ZWWhGBLm0h6Jty4ft7Ton6IE53yayR5yzSjM9
         bJUXwNsl6DMacWff2T3DQBqImUa3Sg5nTOlT+rIjsMTu8xhabTvGDjfbGudLSDCdeg0g
         CdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OzyZEeUp7DwxKDZLdbXyF8LuMW9/BfvpmbsTiHDXZVs=;
        b=qGxDkQ01Ln2tT1MFbuAdAnZOowlSUxNu7/gJb18JoBgM/hu6xZ1RKBIJLF9sf4fskf
         9iSacYCtlEstyFWe30HHRBNZ5N2YNp0TEungeh5NCo34yHpv94rLMz6CS67bIZW6jkWP
         zx8NH5Bf8RRCcZ9JT91YzKHjIYbcu6hJY3CZUFRnAYW12KCf0+JCVe+i+JLHiW7zKTIS
         FxYZ2RoGL8G0t/Kc85Ybm2TwDrgBN29Pw/J2MwRFvLX16KF8p7fT8V8GGbAbMiZ8nLgI
         sHSTz3ncaQACkcpEO3nMia3s7ZYdEXmpOCHVs2gAgSznfzAD+pzV3O1+j/ndLjq4RNqe
         2giQ==
X-Gm-Message-State: APjAAAUkLoXChMutXqztLbi3aXmICkHhYT5qO9S3+89cBJGbx97ZUJwg
        bLLznfHkk34osnPWcnEjfRCsfz6F1lFkwWYHj+4Nfg==
X-Google-Smtp-Source: APXvYqx/1Pj+XHpEMnbZaCtZn6072TcFonfz6+uizN7MhjBBVFeAFqMLlbwx/cPRVQhpEEyeZOiVCeid6+4piuXaOWc=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr25375592wrf.325.1571069247407;
 Mon, 14 Oct 2019 09:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-25-ard.biesheuvel@linaro.org> <CAHmME9o5hHERnrT_V2EmL9GYRNGpOyos1pmwUHN71vt8yPb+ow@mail.gmail.com>
In-Reply-To: <CAHmME9o5hHERnrT_V2EmL9GYRNGpOyos1pmwUHN71vt8yPb+ow@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 18:07:15 +0200
Message-ID: <CAKv+Gu-b1gSoG0kc=yzfUE-j7vjZOo=JpD64dF6Lm8+eZruFbw@mail.gmail.com>
Subject: Re: [PATCH v3 24/29] crypto: lib/curve25519 - work around Clang stack
 spilling issue
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 14 Oct 2019 at 16:14, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Ard,
>
> On Mon, Oct 7, 2019 at 6:46 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Arnd reports that the 32-bit generic library code for Curve25119 ends
> > up using an excessive amount of stack space when built with Clang:
> >
> >   lib/crypto/curve25519-fiat32.c:756:6: error: stack frame size
> >       of 1384 bytes in function 'curve25519_generic'
> >       [-Werror,-Wframe-larger-than=]
> >
> > Let's give some hints to the compiler regarding which routines should
> > not be inlined, to prevent it from running out of registers and spilling
> > to the stack. The resulting code performs identically under both GCC
> > and Clang, and makes the warning go away.
>
> Are you *sure* about that? Couldn't we fix clang instead? I'd rather
> fixes go there instead of gimping this. The reason is that I noticed
> before that this code, performance-wise, was very inlining sensitive.
> Can you benchmark this on ARM32-noneon and on MIPS32? If there's a
> performance difference there, then maybe you can defer this part of
> the series until after the rest lands, and then we'll discuss at
> length various strategies? Alternatively, if you benchmark those and
> it also makes no difference, then it indeed makes no difference.
>

I tested this using a 32-bit ARM VM running under an 64-bit KVM
hypervisor, doing 100 iterations of the selftest.

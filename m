Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B15C47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C92FE222C5
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mA27ubQl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389320AbfJDPgM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:36:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37521 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389832AbfJDPgM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:36:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so6339465wmc.2
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 08:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SCtoEeRGNjG07y07m0UNSpYKMzdTvRskaVRwnMzqdrY=;
        b=mA27ubQl3yNLl8RXXywzv0QBbSNmZtw6kc7Q2PmvEU7bP/SzTGsmsnh3/9bZMJ9dsQ
         w6zMdvB5Y47dGUm292N+9ysxkg7+JjX8XQ25phsWYGolOFStNuRQxAMcxUNEPflDvzUO
         RNTJBVuBudabGp8f8zudnWXCzWYKePMGCk0AIgPm5Y1szg07cjt8VRD5hxrjUz/xE8TB
         B4zNN7FHWgtG6xsZZvYkvt1KuPyXeeetX0mrAznhj/tRSo4ymwBeG89i/oodhbC9d50l
         79aM9vbXPTRjCaYY1rFzExkkKGPcPOrvHv9nfT00EmBx21uqaaw5B9KnB/2AnC9bMuai
         sjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SCtoEeRGNjG07y07m0UNSpYKMzdTvRskaVRwnMzqdrY=;
        b=JVGXvapHgXRax1RhKiY41N2B/R7nIH6mPWT+wvM5QXQwrAzC1iZaxzjsfSHatrNPVn
         wwa6dPSTzSkvYfU+GKk9hYOTS9m3xvdCV3qgrB6QlAmyy5MgdOp2HEtafmPYbWZlDy6d
         YH+jz+FuLC2YIu1iFyUhw58l7mn3uQFbzoIpknR9cKEJhRnYKbrZMFl0qlbVhTkbgokm
         dwN+bANoKs4tPkqu7DEvmsNzRJ+qVzkIWX2V+6Hzt4KKqZDNU6Njd4V6Y6HJ2kq6utoT
         lucQObd8zGjwgWOg/57sEEoA1tj20t6kmdp0iaC6hkHYkI5n1T3y2S3CLRmvYWLVocJo
         W1gw==
X-Gm-Message-State: APjAAAXpdgOUzd/v37bEUk6ubN0EFMnEm/lr6IjsVqPKa586GiYoI6lG
        a9dpB33VEpMpexzlsYM+X5ELjb6mWEohqYCPMJt74mCXw1bklg==
X-Google-Smtp-Source: APXvYqzTWIxHVbJQb02K/GqkicU0L8qssHkiJM9t4pf5T3ijq3JtLe8N/mEj5XjCbkISrcQQ5IUoh14iKi0v1ekaci4=
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr2257611wmj.53.1570203370539;
 Fri, 04 Oct 2019 08:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-5-ard.biesheuvel@linaro.org> <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
 <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com> <CAK8P3a2At0YUwZ7xSOd12QPKcxvnjeG49nfMuDz3E4wO7Tr1fQ@mail.gmail.com>
In-Reply-To: <CAK8P3a2At0YUwZ7xSOd12QPKcxvnjeG49nfMuDz3E4wO7Tr1fQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 17:35:58 +0200
Message-ID: <CAKv+Gu-UGvpSVVrJ+QGoJ2jFXJGNMhCdmK_qysSty8EBK84YZA@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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

On Fri, 4 Oct 2019 at 17:24, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Oct 4, 2019 at 4:23 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > How is it relevant whether the boot CPU is A5 or A7? These are bL
> > little cores that only implement NEON for feature parity with their bl
> > big counterparts, but CPU intensive tasks are scheduled on big cores,
> > where NEON performance is much better than scalar.
> >
> > If we need a policy for this in the kernel, I'd prefer it to be one at
> > the arch/arm level where we disable kernel mode NEON entirely, either
> > via a command line option, or via a policy based on the the types of
> > all CPUs.
>
> I don't think there was ever a b.L system with an A5, and most of the
> A7+A15 systems did not age well, being high-end phone chips in
> 2014 that quickly got replaced with A53 parts and that no longer
> get kernel upgrades.
>
> The only chips I can think of that one might still care about here
> are Exynos 542x (Chromebook 2 EOL 2019, Odroid XU4 ) and
> Allwinner A80 (Cubieboard 4).
>
> Just checking for Cortex-A7 being the boot CPU is probably
> sufficient, that takes care of the common case of all the
> A7-only embedded chips that people definitely are going to care
> about for a long time.
>

But do you agree that disabling kernel mode NEON altogether for these
systems is probably more sensible than testing for CPU part IDs in an
arbitrary crypto driver?

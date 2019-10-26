Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22DCCA9EB9
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 16:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74D5D20684
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 16:22:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n+U9F8Jc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfJZQWK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 12:22:10 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35990 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfJZQWK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 12:22:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id w18so5582081wrt.3
        for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2019 09:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLO1ph3ryAzSVysk4eNr4qj6HHsF8IcLjQCe0XOS0oA=;
        b=n+U9F8Jcb04MRq7p+gwMZu5ai26TGgR3SuZHOaPaCa+6fakDAesvvyfmAamnMJi4Nd
         PGF3vPF+AhCXV7LKz2SK9EihWQEI5PS9TG/2tMNHrRf1V2B2xzDcXiAE1an7mwr5fUs0
         8bDlKRUmjh2Z7FUQMEGMr/wCD/6Hrb1S/SspbIiXSLuGR/S/H9OrFcNflubBqPwbZ2qr
         ARx39nejGHGZ8Mccexw0gJP2WIsZO4VokJ9phw0n5NPMFGENmV/h6D490NuxSCobp/Rw
         xDv3DR+lJ6DcgQhtJxipFXtIhrgjWfocmgdHbzTvSFHwA9G8wFcy2npa4ksLrWWxagwO
         oZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLO1ph3ryAzSVysk4eNr4qj6HHsF8IcLjQCe0XOS0oA=;
        b=k0BRjKnHEVmSTPsihwfquT1tVdAhTgn7O7OBYI2FsrwnBRSaeAvSgbJJPHdu4IKQyM
         BC/eUGIaCJAQSe0nGR4t0dQsAmMUgYJwrE1idx3hvzY89DP5qWizoIMC4sNSDBmHdMaP
         hVsPt1FITZLxQCtc2PXvVcwnjcnNglxA+UaV8hdTUi8a/AIyISkzzxmJbcGrHhqJ70cN
         Jth0XMwpP/xlJETXjoJ4MOTJcHQ+IPCQBt+oPaBLC3P9QJIuOwzgvntLMNzeGEQSeo5C
         2PUFvDdDDKzbxSxKauTTW5n6Bz5WtmTQeRHnwo8t5a0wXOC2oqIJipRuN7+KD6JckCnL
         IcRQ==
X-Gm-Message-State: APjAAAVowchZxsfmiIFux+q9T+1I+j0yQeZCGm4bzQ2tcIhZUK6td8SD
        p1b3Jtrq4XCcs7trY7p33AoNi5eaHAxvTYx4SLL7w5XLKxQ=
X-Google-Smtp-Source: APXvYqzVREHpC3D7dokgvDrus4OdpzR9ktdkeU+9ECa78K6Iqiker7s+ApEL6fJQU0W+VvkQlxvqotLcz8RmwVXugfQ=
X-Received: by 2002:adf:f685:: with SMTP id v5mr8283222wrp.246.1572106926795;
 Sat, 26 Oct 2019 09:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191025194113.217451-1-ebiggers@kernel.org> <CAKv+Gu8Y2AnWfz8Up9V6YF9v7n-s_BYsMXbxMQ7s4tMNw5eusQ@mail.gmail.com>
 <20191026161945.GA736@sol.localdomain>
In-Reply-To: <20191026161945.GA736@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 26 Oct 2019 18:22:05 +0200
Message-ID: <CAKv+Gu-734vGKkL8pGoKNgs2Bw3kfO0A-ci4F4MCQPJLsksb_Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: remove blkcipher
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 26 Oct 2019 at 18:19, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sat, Oct 26, 2019 at 05:32:05PM +0200, Ard Biesheuvel wrote:
> > On Fri, 25 Oct 2019 at 21:45, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > Now that all "blkcipher" algorithms have been converted to "skcipher",
> > > this series removes the blkcipher algorithm type.
> > >
> > > The skcipher (symmetric key cipher) algorithm type was introduced a few
> > > years ago to replace both blkcipher and ablkcipher (synchronous and
> > > asynchronous block cipher).  The advantages of skcipher include:
> > >
> > >   - A much less confusing name, since none of these algorithm types have
> > >     ever actually been for raw block ciphers, but rather for all
> > >     length-preserving encryption modes including block cipher modes of
> > >     operation, stream ciphers, and other length-preserving modes.
> > >
> > >   - It unified blkcipher and ablkcipher into a single algorithm type
> > >     which supports both synchronous and asynchronous implementations.
> > >     Note, blkcipher already operated only on scatterlists, so the fact
> > >     that skcipher does too isn't a regression in functionality.
> > >
> > >   - Better type safety by using struct skcipher_alg, struct
> > >     crypto_skcipher, etc. instead of crypto_alg, crypto_tfm, etc.
> > >
> > >   - It sometimes simplifies the implementations of algorithms.
> > >
> > > Also, the blkcipher API was no longer being tested.
> > >
> > > Eric Biggers (5):
> > >   crypto: unify the crypto_has_skcipher*() functions
> > >   crypto: remove crypto_has_ablkcipher()
> > >   crypto: rename crypto_skcipher_type2 to crypto_skcipher_type
> > >   crypto: remove the "blkcipher" algorithm type
> > >   crypto: rename the crypto_blkcipher module and kconfig option
> > >
> >
> >
> > For the series
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > although obviously, this needs to wait until my albkcipher purge
> > series is applied.
> >
>
> Why does it need to wait?  This just removes blkcipher, not ablkcipher.
>

OK, ignore me - I failed to notice that :-)

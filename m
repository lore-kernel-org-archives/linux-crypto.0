Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0166C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B02B220873
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pKypG2hI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388780AbfJDOMP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:12:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35240 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388625AbfJDOMP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:12:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so6041709wmi.0
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5uGInId4sF9LlKvHeQyYaRMbmmalDz+4mNwCCbu2AA=;
        b=pKypG2hIZHx2ezrMpcXUYF6q3NENgyiHtv3u+mQpX0ThFufXDol10mQVghaMLVu3F4
         aikKHnpm1BN5Jis09dN9xxK/6bcKSCDNI5kH/4cDxl8ZKzJJU3b3yqF5YspdITmOaxmF
         UF9ituMCcJzsZKA9vy8CwIrZ+2XYtU7K87KExeUGHpHluV6jBtdMzDSJvY3MgMoBTvep
         hDZP7Ugnh3mgNeZDqZqpC7Tl57wlr0sZKQv/YfaW5X4FFUtL5J+UTUYROPndqJa/Y7+5
         ljhhCnhiPPD5WH+Xmaj9SPLiV0PsgU6Y9C5lokzAPVr4LxqAt2ce3Q6DuS+Rcpkxf+FN
         6Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5uGInId4sF9LlKvHeQyYaRMbmmalDz+4mNwCCbu2AA=;
        b=Id//xRaaaLd58CQ4orJwiREFzYnNtZ0R5A+8RZfERIW13/a8/DQI4tNyyP/ZX50Fd9
         BWVPyVrmQLgLAY+KgqoFIjKTxy6dSWcytFu4pX/DPoLF7ttAxuj95WLz553V3Ca2Di+i
         hmu9R+6Cs3yDam9jnRAbCcglLwd9a/R2It+0MgdwU91lTk8fYYOedf94kNodse70jayh
         UMX7p9zeX1OMgveIHuEekd/NCdN4ZBLP3+xvroiLqdN9ub/hydiUCin4dNF9nj3lmKh7
         QrPVrJcPM7im3rzeGRFaBPxJ+5po1/dM2vXUyH0h/ZwrUIr1WBkig7n+roPMFhidPDb7
         drjg==
X-Gm-Message-State: APjAAAXfzQgWTpFXaBzB90AD5AlyR0TWXBFClYWijByltqQUcurCosUc
        zKHiyeTQuw6N+RgXFzu0lpzHtqEj1xQ/mq0WANdolw==
X-Google-Smtp-Source: APXvYqxKWNpU5mxiJwimy0N7eAPS23lRiC8zn8HWWr50MteLNNCLwEQi1+7P5YWEt/HMNS6il+7tUSUXyU5L5T9zuyw=
X-Received: by 2002:a7b:c451:: with SMTP id l17mr10075770wmi.61.1570198331733;
 Fri, 04 Oct 2019 07:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-19-ard.biesheuvel@linaro.org> <20191004140057.GB114360@zx2c4.com>
In-Reply-To: <20191004140057.GB114360@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:11:59 +0200
Message-ID: <CAKv+Gu-iyWkWcodh7PBqPcbH-NhDGQ+v4YzvrO8zO1q9fLG0OA@mail.gmail.com>
Subject: Re: [PATCH v2 18/20] crypto: arm/Curve25519 - wire up NEON implementation
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
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 16:01, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 02, 2019 at 04:17:11PM +0200, Ard Biesheuvel wrote:
> > +bool curve25519_arch(u8 out[CURVE25519_KEY_SIZE],
> > +                  const u8 scalar[CURVE25519_KEY_SIZE],
> > +                  const u8 point[CURVE25519_KEY_SIZE])
> > +{
> > +     if (!have_neon || !crypto_simd_usable())
> > +             return false;
> > +     kernel_neon_begin();
> > +     curve25519_neon(out, scalar, point);
> > +     kernel_neon_end();
> > +     return true;
> > +}
> > +EXPORT_SYMBOL(curve25519_arch);
>
> This now looks more like the Zinc way of doing things, with the _arch
> function returning true or false based on whether or not the
> implementation was available, allowing the generic implementation to
> run.
>
> I thought, from looking at the chacha commits earlier, you had done away
> with that style of things in favor of weak symbols, whereby the arch
> implementation would fall back to the generic one, instead of the other
> way around?

This will still use weak symbols, and so the NEON code is built into
its own module, which may fail to load or be blacklisted. Note that my
v3 working branch has already deviated a bit from the code here.

The difference between blake2s and curve25519 on the one hand and
chacha and poly on the other is that in the latter case, I am exposing
existing code via the library interface that is already being used via
the crypto API as well, which means that we have already duplicated
some of the boilerplate needed for, e.g., the init/update/final
interfaces.

blake2s and curve25519 are new to the kernel, and so we are not
exposing the same code via the shash interface and the library
interface at the same time. Taking blake2s as an example, there is a
core compress() transformation which gets overridden, while everything
else is provided by the base library.

In summary, it differs per library what the best approach is.

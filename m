Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0424C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D5420700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P1Gz0jPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbfJDODP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:03:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37432 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbfJDODP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:03:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id p14so6424175wro.4
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Er4SXIgxcEE4aax8T96FM3625i+T61N4koZmZMdahiY=;
        b=P1Gz0jPO/0QDPA+O8QhWsaRBWzJOIjWu5YAZFYoWor5mx3mVlq7r6ZDhWkJNudnBPm
         BMK+J8M6GcXZaefnaJP4WYSevLUnDQ36NiM8PUbNkshhkEPEI7yq/pqJZ/0jiqSNR6Xn
         mWYhoWjIzFjintOMIHoo7HkjjRz+Z/Xti4NueEtNmZLXqArM1Elqw7pOTB4MIPNYP0ZU
         d1PQ56Tuaho2BazpmXgHyGH9DIeegnKV1udKgIp6nb9wA/uR5n/OBVZK08Jpp54oE13S
         74+K00H+EMq8nqtQDyWq87qw0M8RGGw5JFZdEsEMAbdMqRhNmvu24s+6llinmFv8FkwI
         y7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Er4SXIgxcEE4aax8T96FM3625i+T61N4koZmZMdahiY=;
        b=JrMK4cISQ0B4TBMwQGRfAex0fIFI3R2DeK+qVsK2p0eWNUfBNGxUlvCOpls4N4dfhY
         QYYrqyBOMikfGVza4wzP37UNfSRD766djLPebP8aqtR1seCALG/sxZsrJeEEBMPMMycV
         Fwj4lze/N+RJPc1VT3PJBrc408ohcbnF//JGZ4t7E2ZvQO7lxTs7hVTea06HlXlt03Rk
         n5g0P1617N8T7fCHwHA9XHTb7nOPA5dxrTlOmqrg/iNJ/Nr+f0X/5FkmFN+Pqv0qqdf/
         L52801f0WqiBfUTo9M1xNL8r5d9U6X2mbga/Z7/s/9fK/zPfAtog/9YZNwx3L1W1XQW6
         lpbA==
X-Gm-Message-State: APjAAAVZB/vjYeVZEpnm75WrJ+PWReMW1gQDPMEre6kaxXsjFQ3E8/Fc
        l7DxmWULE+1TD9XxVbwLpEIB5T4c9IslCAWw1pwWIw==
X-Google-Smtp-Source: APXvYqwNBX5rK+71wVSaKh6+kqftc6hKfFvFgtDtJHaet9Or4UNM1VjLii7ln9o/gDIC2s5oVp38LQT3JF8oXrNuUQc=
X-Received: by 2002:a5d:61c8:: with SMTP id q8mr6169926wrv.325.1570197792258;
 Fri, 04 Oct 2019 07:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-15-ard.biesheuvel@linaro.org> <20191004135750.GA114360@zx2c4.com>
In-Reply-To: <20191004135750.GA114360@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:03:00 +0200
Message-ID: <CAKv+Gu9Gwu=Qzw=+iREro_JHzCWKAiqtbWrnFq8qozYazNn6XA@mail.gmail.com>
Subject: Re: [PATCH v2 14/20] crypto: Curve25519 - generic C library
 implementations and selftest
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

On Fri, 4 Oct 2019 at 15:57, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 02, 2019 at 04:17:07PM +0200, Ard Biesheuvel wrote:
> >        - replace .c #includes with Kconfig based object selection
>
> Cool!
>
> > +config CRYPTO_ARCH_HAVE_LIB_CURVE25519
> > +     tristate
> > +
> > +config CRYPTO_ARCH_HAVE_LIB_CURVE25519_BASE
> > +     bool
> > +
> > +config CRYPTO_LIB_CURVE25519
> > +     tristate "Curve25519 scalar multiplication library"
> > +     depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
>
> a || !a ==> true
>
> Did you mean for one of these to be _BASE? Or is this a Kconfig trick of
> a different variety that's intentional?
>

This ensures that the base module is not builtin when the arch one is
configured as a module, since in that case, the arch code never gets
called.

> > +libcurve25519-y                                      := curve25519-fiat32.o
> > +libcurve25519-$(CONFIG_ARCH_SUPPORTS_INT128) := curve25519-hacl64.o
>
> Nice idea.

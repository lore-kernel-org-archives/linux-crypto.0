Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D01AC432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 21:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0804321D79
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 21:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IqaKJoMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfIYVTi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:19:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35013 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfIYVTh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 17:19:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so283978wmi.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 14:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7YzOVzGpdhxsAdmwy0xS3DmtYyZj7aWsqnxFjthGFc=;
        b=IqaKJoMO5a38/jY9fU9cblH8HPi6GO9JpL0xjFCfIEhxR/LsbfLENFFYitNEVTiJ0p
         oH84clwPp8CYMies3vcW680s28VrIYdBXYSdySTp5S+c1yOxAbGUWhbEAecfpVZgs8r+
         3/3W6IEKHNuVei/kaJ15XKZjVqHJq4ZqiTZ5G63GWhhmcx5Pdh8B7Gqj23UnjdMWxt5f
         CWWObwM5dlWcWFKhkKhY40P248B/6/erylQo2oHEOSZ723m8ldTlz+vMxcnSCR7ZpoVR
         XjXUsR6Em/jLUMuYPsbogDZ5bX4TQrcTkQra1YppWFCQKgyxJgZ35cL4raMTUrvrUq0M
         4mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7YzOVzGpdhxsAdmwy0xS3DmtYyZj7aWsqnxFjthGFc=;
        b=Eeqf6djc6Phq2fQLcQpv79JY0TcnM5Kz0YOAwJCcR5tIGxXEJTssAfk4rWVgYbVUIy
         aXPQDYnzG6gA0jQE/EXVQbW5UO7T5lXBBG+9TMUb+tMz1EWZNBd9KK5q9zm+cYTnga8I
         oNgvZMK67NpsjEHOpehgLYTtMdCN25dENTDwPa1dhcjPZ9e84MUn5sLgn4AXLVvXw4Ju
         FeAkxRZwe7nZZXCPbzINs1JqxLtfECXI+VUy3T4PsELZ17RCe1ejNd/AvvVr2AkmAlc8
         mt2OiM+MVDrDmiTSdz5NB7k6E+VzfUauvBbu7FqEZcEhomF2EA0rTIXE7wpfMeO93AE2
         7OkA==
X-Gm-Message-State: APjAAAVghYRR26Jc0r4oTQkqfUvrzL8uc5nEWE5Y36bsymQkaSmqEuQl
        8u3ar0p3Qh6sItoRUMJgsboPYyrRXR5EqDHvBUpjXA==
X-Google-Smtp-Source: APXvYqwEXSfo+dCqw9kJmJKNqePzh1WBkwd8uth3KdgMMgR2+4y3WBpZOyuvPIGTdnR0xQnzmZcXLYPjemGrRtJOlU4=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr156255wma.119.1569446375423;
 Wed, 25 Sep 2019 14:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-12-ard.biesheuvel@linaro.org> <CAHk-=wi8+MHz8xGtx_mUZPBsRT6qkptGW7a_pOrK=SnTRAiecA@mail.gmail.com>
In-Reply-To: <CAHk-=wi8+MHz8xGtx_mUZPBsRT6qkptGW7a_pOrK=SnTRAiecA@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 25 Sep 2019 23:19:22 +0200
Message-ID: <CAKv+Gu9299nphaf88-SdF843w0ZbY0WD8MisAx+JMw5=GVVN9g@mail.gmail.com>
Subject: Re: [RFC PATCH 11/18] int128: move __uint128_t compiler test to Kconfig
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 25 Sep 2019 at 23:01, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Sep 25, 2019 at 9:14 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> >  config ARCH_SUPPORTS_INT128
> >         bool
> > +       depends on !$(cc-option,-D__SIZEOF_INT128__=0)
>
> Hmm. Does this actually work?
>
> If that "depends on" now ends up being 'n', afaik the people who
> _enable_ it just do a
>
>        select ARCH_SUPPORTS_INT128
>
> and now you'll end up with the Kconfig erroring out with
>
>    WARNING: unmet direct dependencies detected for ARCH_SUPPORTS_INT128
>
> and then you end up with CONFIG_ARCH_SUPPORTS_INT128 anyway, instead
> of the behavior you _want_ to get, which is to not get that CONFIG
> defined at all.
>
> So I heartily agree with your intent, but I don't think that model
> works. I think you need to change the cases that currently do
>
>        select ARCH_SUPPORTS_INT128
>
> to instead have that cc-option test.
>
> And take all the above with a pinch of salt. Maybe what you are doing
> works, and I am just missing some piece of the puzzle. But I _think_
> it's broken, and you didn't test with a compiler that doesn't support
> that thing properly.
>

I think you may be right.

Instead, I'll add a separate CC_HAS_INT128 symbol with the
$(cc-option) test, and replace occurrences of

select ARCH_SUPPORTS_INT128

with

select ARCH_SUPPORTS_INT128 if CC_HAS_INT128

which is a slightly cleaner approach in any case.

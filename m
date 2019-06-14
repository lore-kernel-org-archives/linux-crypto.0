Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BA6C31E44
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 10:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4641920665
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 10:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nze2vSNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfFNKHj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 06:07:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41542 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfFNKHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 06:07:39 -0400
Received: by mail-io1-f67.google.com with SMTP id w25so4456531ioc.8
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 03:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qf8PHbkL3B/l72GonBnfO+o+kfcHi+xlbv1V8+Yu9H8=;
        b=Nze2vSNWGMnDuIsmu9CwRv9sd1vXXAuBa/0XWY8Fqay26cpx6IQ0KmyQsXdNTEcAYz
         dEDHdnX6ik9X3LjP69Tzde3UwUYdG4rfucYSDcKyICp++OrZ+nqAxb7g+s1n+V0fMoR8
         oxwqMbWecoeiYUEdEhytkDtvByUfx0NH36EeVCzESgET/ZGoiuOLwu9ArzeRxvXLwrLE
         vlAJRvE7bnB9xWvY/tC6LvkALrIDpQMb9Se6NnKoLF/KZtOTV8RjmUxaysNbBphIaQ4G
         YDkVmA7cX6vA+aNzPFWQzuvxOuk7teP0u0t1GVLCLmQ6Xxd7pO+1cYncGG816IkecYyo
         qFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qf8PHbkL3B/l72GonBnfO+o+kfcHi+xlbv1V8+Yu9H8=;
        b=TQtrJLTH+q/57B2ns4rBJ2jUgSbaJ6KDj4/RfIuO8ZaBxFjtC984ZV5V8ALjdp5GuB
         1IfQ2jKYlmOD7WNZJcbRDy2vLwi+Z5CRfYh8VIyDLnLX92Ls2Hp4g3/wnnwgZN8Hw/99
         b1SRzv5mXw+rRe27RJ3VLN2W18VMhzByzxqKQZYP7QvRt101PjIhh3nrf3tG8vCM8/G9
         YB3JznDr+/di1FXV8CA0uk34KKLTvdS7TcaEzhNyXQRfAzyEekKNorTMFlk+DEzL5RMe
         bbwluh/MrG5v/0x+h02BLeV0uFC5suPThkECERgd/NnP50E81N01eWZUYSJoGkPRKSkn
         rgKQ==
X-Gm-Message-State: APjAAAUX9pGOPWgFILzFTtRD24yCrCikbv4E0Cmvk7OtoKljEcdA8ffp
        USJ9cN15kVDEQOlxnQBzzzwAjvj9Mq4X96YTfr3huaczapw=
X-Google-Smtp-Source: APXvYqzqZvOvNp9+a7Fxr8daBh+LynsviCQtwp9j/GWi1m8rr5CaY7dfhQUeT5IMXaQ/HxM6QR5qmRCk/L+k0JekNG4=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr54028927ion.65.1560506858876;
 Fri, 14 Jun 2019 03:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190614094353.23089-1-ard.biesheuvel@linaro.org> <20190614100536.GA8466@kroah.com>
In-Reply-To: <20190614100536.GA8466@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 14 Jun 2019 12:07:25 +0200
Message-ID: <CAKv+Gu9vRJpM6giRLfxdvR6_uA-Yht8+nnNeKh=hBkJ=iCp-wA@mail.gmail.com>
Subject: Re: [PATCH v2] wusb: switch to cbcmac transform
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb <linux-usb@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 14 Jun 2019 at 12:05, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 14, 2019 at 11:43:53AM +0200, Ard Biesheuvel wrote:
> > The wusb code takes a very peculiar approach at implementing CBC-MAC,
> > by using plain CBC into a scratch buffer, and taking the output IV
> > as the MAC.
> >
> > We can clean up this code substantially by switching to the cbcmac
> > shash, as exposed by the CCM template. To ensure that the module is
> > loaded on demand, add the cbcmac template name as a module alias.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > v2: - use finup()/digest() where possible, and process b0+b1 using a single
> >       call to update()
> >     - make 'stv_hsmic_hs' static const and remove comment regarding GCC 4.1
> >
> > NOTE: I don't have any hardware to test this, but the built-in selftest
> >       still passes.
>
> No one has this hardware :)
>

I kind of suspected that :-)

> I'll take this, but I think I'll be moving all of the wireless usb code
> to staging to drop it in a few kernel versions as there are no users of
> it anymore that I can tell.
>

That is fine. I just wanted to make sure it stops using an interface
that I am eager to make private to the crypto subsystem, but the
resulting code is arguably better in any case.

Thanks,

Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442D9C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 10:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1339421556
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 10:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAQ8RhQT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfLKKFX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 05:05:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34200 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfLKKFX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 05:05:23 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so22039700iof.1;
        Wed, 11 Dec 2019 02:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6+pzCvZCcIDCxscL/F2NTKLDHzaJQZFzo8UlrqTqymo=;
        b=OAQ8RhQT+BNhH5WtADE/JwpRUFq8FjSxLcLoHKg9BhA8CFuwWyRros3rT6ka5Ur4/+
         Ihml7KGm0Y4m4/XXTvPsq3lLnCdfzvm/y7ogVvxBUW63YsQggBu6Q/EsnrOv87po8LQT
         L1HTnnb7mESRAokBz9AV7RYDJ6bK+6uF9ajOBWDuq1AJsH+VEBdspzP8QU60fwLDZAY+
         aY+AiCuPlGavc2xAsguOm+mFP3bHPyVOqUlCj2eLmHgV/NGaeX4DsEFFV1cDvGguJI6I
         nDiSxVAaccq0FEnyYb7K0GSCJo9e/i7jtr2TX8RHlzK5X6nw5ifr1rVNHJWD+2ooxIr+
         WZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6+pzCvZCcIDCxscL/F2NTKLDHzaJQZFzo8UlrqTqymo=;
        b=CF+jeYuTg8LvEez+yCRVr6axGZ3wCXFXY+oI6LYqNIIf2MTlY3ZLL0xv6v6AMHnXce
         DMY4p2So/D2wG4kFUY6Vzx8qlCC9t3dCRo76e0r2GcWpqwpEmKQ1o7GLPwLyA5WslvKM
         8PVGDyqDQ/XFnPIPVTnNBOHlVT6ayQewyvnjahyOka8v0uuDzTY2mxrroOEZ2OTjxEkD
         i80x8uzXv9YPA/4cpobfUy1WvsyOxzQfIeoazFW6CaR1ehvarm36M5yFp6sKItoMdfdk
         vguwSHk5TwFT9jF3Rze+kKjZYtorw3Lbdfs6K2A/X71bpxVoj0Ayl/hj6nqVgnDFvQR7
         y3HA==
X-Gm-Message-State: APjAAAVrKWyQRHeh/j+jfk75KA1fnnTjHHP62LSx3/miq7a8b6OfIWQk
        2lZ6WI9WQbeM2RJU56smSOMhTOhVvvDC7eLvTQdGbQ==
X-Google-Smtp-Source: APXvYqzQQF2cztKd3cNyU8ZNYeCQxBqzhYSOLa4dn2jZiKW/BvdhA1lQKaPvEUrsQi7tB6c3eXGWxmzJ+mHnVwC7J58=
X-Received: by 2002:a02:a309:: with SMTP id q9mr2222824jai.141.1576058722472;
 Wed, 11 Dec 2019 02:05:22 -0800 (PST)
MIME-Version: 1.0
References: <20191211084112.971-1-linux.amoon@gmail.com> <a4610efc-844a-2d43-5db1-cf813102e701@baylibre.com>
 <20191211092741.totwucrkversjbav@gondor.apana.org.au>
In-Reply-To: <20191211092741.totwucrkversjbav@gondor.apana.org.au>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Wed, 11 Dec 2019 15:35:11 +0530
Message-ID: <CANAwSgSNKa2HgYZPhrFdsA4mwOgvaiBSzay_-eo-n80KqwXHLA@mail.gmail.com>
Subject: Re: [PATCHv1 0/3] Enable crypto module on Amlogic GXBB SoC platform
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Wed, 11 Dec 2019 at 14:57, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Dec 11, 2019 at 09:53:56AM +0100, Neil Armstrong wrote:
> >
> > On 11/12/2019 09:41, Anand Moon wrote:
> > > [sudo] password for alarm:
> > > [  903.867059] tcrypt:
> > > [  903.867059] testing speed of async ecb(aes) (ecb(aes-arm64)) encryption
> >
> > Wow, I'm surprised it works on GXBB, Amlogic completely removed HW crypto for GXBB in all their
> > vendor BSPs, in Linux, U-Boot and ATF chain.
> >
> > Could you run more tests to be sure it's really functional ?
>
> Well as you can see from the tcrypt output, it's actually using
> aes-arm64 which is certainly not the amlogic driver.  Presumably
> the amlogic driver failed to load/register.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Yes I think so you are correct.no Hardware Accelerated crypto on GXBB.
Failed to load the module.

-Anand

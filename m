Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D691DC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 09:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C8A6113E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 09:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhI1JCd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:02:33 -0400
Received: from mail-vs1-f41.google.com ([209.85.217.41]:42737 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbhI1JCd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 05:02:33 -0400
Received: by mail-vs1-f41.google.com with SMTP id z62so21220482vsz.9;
        Tue, 28 Sep 2021 02:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2LPnGpLh0Z/OFWhJ3bW6nNOAP+i5ywRc/ibvIJ8V0ZU=;
        b=ahdeUN3md/jKPjRspN5EIUzmln2WJmZ6FR/+5kqTRUNsvnfQPg/pNsXeO5Y5bbF1QF
         Uans8tcpacTgMKAJUoh/9D/7H8kOwTlelfXceb4JO6u5/UMyR5esuUWpHLEyR/swevrj
         On7Pvtbu31/0X0L2SUxPYqG+Kpx/A1xW07UT3fMR2TAIceVJVJAC0tl7Zi+RfIiNH8S8
         LWUwhA3CwW5xv33AWar+B/4o2rEcZCx9vYF1RSM/g4n27rwCc9D0JrHr1senncdtf/N0
         Yj1jum8BLPZX/EC6lXWv6hS4A5IuSLgzRUJBeFaowbfYhfc/J9h36T6gsoUPR4n+OOsr
         +IRw==
X-Gm-Message-State: AOAM531bDE+Ts7qNwEA1+1Lm8wGHekoXU6eDKxwUJrWTNQZGBRNFNDJ0
        Wdgy4wb9K+/V6pLzllqYcP0KEp0PQSHfl0LOagCH5A3ANic=
X-Google-Smtp-Source: ABdhPJyKCBGg8b+EUk7301gW1EQMjaY5eqfZE9QEHHk0EcY4l7Xt/v1Rn8gxQbSMp/ewzPBF7MH+2DTbO4Tgqmwiu4Y=
X-Received: by 2002:a67:cc1c:: with SMTP id q28mr3526995vsl.37.1632819653399;
 Tue, 28 Sep 2021 02:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
 <20210921213930.10366-2-linkmauve@linkmauve.fr> <CACPK8Xc+J0PbCdgheRxJbOVZ=OyyfsCA=cwkneMoboJLzC8TZQ@mail.gmail.com>
In-Reply-To: <CACPK8Xc+J0PbCdgheRxJbOVZ=OyyfsCA=cwkneMoboJLzC8TZQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Sep 2021 11:00:41 +0200
Message-ID: <CAMuHMdURNY5BRc6bfaYxX+k02w7mz2aRLOi9uW-qaoT3oBPFtQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: nintendo-aes - add a new AES driver
To:     Joel Stanley <joel@jms.id.au>
Cc:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Ash Logan <ash@heyquark.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.ne@posteo.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 22, 2021 at 4:12 AM Joel Stanley <joel@jms.id.au> wrote:
> On Tue, 21 Sept 2021 at 21:47, Emmanuel Gil Peyrot
> <linkmauve@linkmauve.fr> wrote:
> >
> > This engine implements AES in CBC mode, using 128-bit keys only.  It is
> > present on both the Wii and the Wii U, and is apparently identical in
> > both consoles.
> >
> > The hardware is capable of firing an interrupt when the operation is
> > done, but this driver currently uses a busy loop, I’m not too sure
> > whether it would be preferable to switch, nor how to achieve that.
> >
> > It also supports a mode where no operation is done, and thus could be
> > used as a DMA copy engine, but I don’t know how to expose that to the
> > kernel or whether it would even be useful.
> >
> > In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
> > aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> > speedup.
> >
> > This driver was written based on reversed documentation, see:
> > https://wiibrew.org/wiki/Hardware/AES
> >
> > Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> > Tested-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>  # on Wii U
> > ---
> >  drivers/crypto/Kconfig        |  11 ++
> >  drivers/crypto/Makefile       |   1 +
> >  drivers/crypto/nintendo-aes.c | 273 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 285 insertions(+)
> >  create mode 100644 drivers/crypto/nintendo-aes.c
> >
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index 9a4c275a1335..adc94ad7462d 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -871,4 +871,15 @@ config CRYPTO_DEV_SA2UL
> >
> >  source "drivers/crypto/keembay/Kconfig"
> >
> > +config CRYPTO_DEV_NINTENDO
> > +       tristate "Support for the Nintendo Wii U AES engine"
> > +       depends on WII || WIIU || COMPILE_TEST
>
> This current seteup will allow the driver to be compile tested for
> non-powerpc, which will fail on the dcbf instructions.
>
> Perhaps use this instead:
>
>        depends on WII || WIIU || (COMPILE_TEST && PPC)

Or:

    depends on PPC
    depends on WII || WIIU || COMPILE_TEST

to distinguish between hard and soft dependencies.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

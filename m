Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263D5C10F14
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB7502067B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OhSbn61m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfJOKbo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:31:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36666 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfJOKbn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 06:31:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so19711765wmc.1
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2019 03:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NyesQWTuvXO6kEAohzVxND+5nW0ZsL+t3l5nme1Rsn0=;
        b=OhSbn61m0jwUeoM2Gbtb8R350ZOWMXmrO8gesaATTj3rlHsl7HvG2SpwjW50lSEiBJ
         zt7g5hu0MbBC9PEdNN90xjkKR5C3i1ggatfNeTzAAVjntlp5dSLpCkAUQMqg0Q+lA1ix
         NrNbGvlFiTzv8S8RHToxrG/W/8mKaRdb6DHgQNNcorTlYIBQspVRq8QwiNYR93rsaqCT
         S9o5aXMHvOL7eiOWNnL78IDx4CTMWTrAbk0x73A+90DHlJI2BKha/1U0eLo6WftgWS1C
         Zvja1fgaH27eAByigY+5Xm71MFLBXwmk8I6VSmrXS8XpjeTFsErTqquR3YbubMh7tR5O
         7RGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NyesQWTuvXO6kEAohzVxND+5nW0ZsL+t3l5nme1Rsn0=;
        b=GM9gyKhTnKaSDQVECO8bOGh0GX0WDhM74sBkmVnv0aw5QZPhRiJtUdZA7A/dvUtcbF
         hgEpgx3kqw/VJtjUmXPsy6ni36O8Y4OirgKOSE1VF+D1aynEX1Rs+rw189cU1Oom1YrL
         oSpWcSOEjplnbDijGBGnGXAn9B61Cm7357X3j0sUCaWdVtAStmpbX8+A1LGbjapRgLFY
         zAI+DSNeYh05fr1G9puUZONG+uxnkpBl95g1ydg5xD08TmqAN9KpklSkRbD8FvdaOaFf
         oi/cAK5cUjIE1EDy7wJEa2wFD9XgTodxxFmMFLY/Pil0bdJMdG5/JixUBmjFSIb/4/oG
         7vrQ==
X-Gm-Message-State: APjAAAWM+HkAZ9yaOZPrEYY6hOJ8U9yXo5iiFOpgZkZIiG1h6AYiYvHK
        eJxG/6Lzs6OxELeyjL3mUTXs0lEPckcAeGYhIqUouQ==
X-Google-Smtp-Source: APXvYqwK8OH6ITdP8Q0rR5rvn0rGj0Xy6S+TZjr6jM71xBorVP8lcKUWlmOcxNuRU2ut7HUSNRPf7f05SmvXO5g7uEw=
X-Received: by 2002:a1c:a9c5:: with SMTP id s188mr17099745wme.61.1571135502001;
 Tue, 15 Oct 2019 03:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
 <20191014121910.7264-9-ard.biesheuvel@linaro.org> <2e544398-5407-430c-84b6-3f946f5dea0c@microchip.com>
In-Reply-To: <2e544398-5407-430c-84b6-3f946f5dea0c@microchip.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 15 Oct 2019 12:31:31 +0200
Message-ID: <CAKv+Gu_OueNR9ecHrqx5ROG9Pvvci69myASAW6kmj=KNuK26hQ@mail.gmail.com>
Subject: Re: [PATCH 08/25] crypto: atmel-aes - switch to skcipher API
To:     Tudor-Dan Ambarus <Tudor.Ambarus@microchip.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <Ludovic.Desroches@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Oct 2019 at 12:17, <Tudor.Ambarus@microchip.com> wrote:
>
> Hi, Ard,
>
> Thanks for working on this.
>
> On 10/14/2019 03:18 PM, Ard Biesheuvel wrote:
> > Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interfa=
ce")
> > dated 20 august 2015 introduced the new skcipher API which is supposed =
to
> > replace both blkcipher and ablkcipher. While all consumers of the API h=
ave
> > been converted long ago, some producers of the ablkcipher remain, forci=
ng
> > us to keep the ablkcipher support routines alive, along with the matchi=
ng
> > code to expose [a]blkciphers via the skcipher API.
> >
> > So switch this driver to the skcipher API, allowing us to finally drop =
the
> > blkcipher code in the near future.
> >
> > Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> > Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/crypto/atmel-aes.c | 507 ++++++++++----------
> >  1 file changed, 244 insertions(+), 263 deletions(-)
>
> drivers/crypto/atmel-aes.c: In function =E2=80=98atmel_aes_register_algs=
=E2=80=99:
> drivers/crypto/atmel-aes.c:2515:24: error: passing argument 1 of =E2=80=
=98crypto_unregister_alg=E2=80=99 from incompatible pointer type [-Werror=
=3Dincompatible-pointer-types]
>   crypto_unregister_alg(&aes_xts_alg);
>                         ^
> In file included from drivers/crypto/atmel-aes.c:32:0:
> ./include/linux/crypto.h:703:5: note: expected =E2=80=98struct crypto_alg=
 *=E2=80=99 but argument is of type =E2=80=98struct skcipher_alg *=E2=80=99
>  int crypto_unregister_alg(struct crypto_alg *alg);
>      ^~~~~~~~~~~~~~~~~~~~~
>

Apologies for that. I was pretty sure I build tested all patches, so I
should have spotted this myself.

> and when applying tdes:
> Applying: crypto: atmel-tdes - switch to skcipher API
> .git/rebase-apply/patch:637: trailing whitespace.
>
> warning: 1 line adds whitespace errors.
>
> I'll try to review the atmel part next week.
>
> Cheers,
> ta

Thanks,

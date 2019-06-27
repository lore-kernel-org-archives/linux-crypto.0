Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2221C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB6552133F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a4QfWV3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0QeT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:34:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39888 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0QeT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 12:34:19 -0400
Received: by mail-io1-f68.google.com with SMTP id r185so6138685iod.6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 09:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6azoPZNHeDHbP0I7IxK+K43/PZ7is495M5F46mew1rc=;
        b=a4QfWV3do3YEgEXFP3eth5cHxRsLzOWN+Jr8SlWUL3n3VPUsSzhZPJTDMKfsE+NvI4
         IZtbiyBGrgeRHyQck0a9P2nVSP99dufEF8fjg9bnbuEsmyUw79u+6j1aJ2KXmPTwn7VA
         m7kYVT3qN8JoU93qiLfq3Y0Hl1eQOEnmfvO17NBV9lRGojPgxanTkR+SJtuLo5QVQB81
         +PqP4n/TskpQaA5aS/v10SF0dDSUtaYyqnrAKJ6ZwWa0UVa1JYvAfuslaiH61SGUav/4
         tnO5k3GT8UYhlnsP2gufrxsUqFOgu5kDZkUZmVVVtcOzBwwnQ9MCmEbb427Ou4KHACEL
         pIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6azoPZNHeDHbP0I7IxK+K43/PZ7is495M5F46mew1rc=;
        b=n3JqpHdJNX8L0BpoakQhAy7R6Gil/7oQsZxtqNvQvmP3k+44Hpxp+M6VAdNFcYzL2p
         D8taEyP7lschhIVGHwjHWYKFMnK1aBlNDx9+k7lQ29wD8X1p17GoRDtHXrvIXTNEd7hW
         mFf47MXJ2Nz+p4zHqqU1SASezDeAfRYn0FUR1j/OdApJfJ2QPl4uakwqjhqAkW3jJ2em
         N6bEWP01/o7dd9vR0Q0ekr/817L93TIS+GrCJeRJOTbA2j08WuGVGCC2F5RVPVNWCk8E
         MUHcSuLgqEY4xoN0/DO8PbXkbnBcf8J8G5u1yLfjMz65NI0KW+IjJJKDvO0He+gzQx63
         eM/Q==
X-Gm-Message-State: APjAAAVoGzhb16gNu6/AkRgEm/+vt5CygOrzpcdNsTN33uR87FR1Wnu1
        IGuG3YdyOUaWywhGWNz2T+hqcFXunwKJkMXtW3N/zmQm
X-Google-Smtp-Source: APXvYqyllultLw115r1D9PjhQxknKvP4EWTgBB2VvF/8wVdgf2hRhmX587v80TDlrtlE9PLBTkGZ/t+6xeBeZEzYOnw=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr5555566ion.128.1561653258375;
 Thu, 27 Jun 2019 09:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
 <20190627120314.7197-12-ard.biesheuvel@linaro.org> <20190627161906.GB686@sol.localdomain>
In-Reply-To: <20190627161906.GB686@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 18:34:04 +0200
Message-ID: <CAKv+Gu-NP1p-MUJWVbCqnH_JOC=iHvbX9AwEXnvem73OjQLNXA@mail.gmail.com>
Subject: Re: [PATCH v2 11/30] crypto: hifn/des - switch to new verification routines
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 18:19, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jun 27, 2019 at 02:02:55PM +0200, Ard Biesheuvel wrote:
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/crypto/hifn_795x.c | 30 +++++---------------
> >  1 file changed, 7 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> > index d656be0a142b..000477e4a429 100644
> > --- a/drivers/crypto/hifn_795x.c
> > +++ b/drivers/crypto/hifn_795x.c
> > @@ -30,7 +30,7 @@
> >  #include <linux/ktime.h>
> >
> >  #include <crypto/algapi.h>
> > -#include <crypto/des.h>
> > +#include <crypto/internal/des.h>
> >
> >  static char hifn_pll_ref[sizeof("extNNN")] = "ext";
> >  module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
> > @@ -1948,25 +1948,13 @@ static void hifn_flush(struct hifn_device *dev)
> >  static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
> >               unsigned int len)
> >  {
> > -     struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> >       struct hifn_context *ctx = crypto_tfm_ctx(tfm);
> >       struct hifn_device *dev = ctx->dev;
> > +     int err;
>
> Also a build error here:
>
> drivers/crypto/hifn_795x.c: In function 'hifn_setkey':
> drivers/crypto/hifn_795x.c:1951:44: error: 'tfm' undeclared (first use in this function); did you mean 'tm'?
>   struct hifn_context *ctx = crypto_tfm_ctx(tfm);
>                                             ^~~
>                                             tm
> drivers/crypto/hifn_795x.c:1951:44: note: each undeclared identifier is reported only once for each function it appears in

Hum, I built allmodconfig for a bunch of architectures, but apparently
I missed this one and another one. I will double check these for the
next rev

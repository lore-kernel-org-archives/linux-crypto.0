Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DF7C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77CB1208C2
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hNRS9bFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfHOFBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 01:01:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38741 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfHOFBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 01:01:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so1131267wrr.5
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2019 22:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QPiCDehj5KfLjTayla1DpLWE9agAsJpKBwRt66M5ZoY=;
        b=hNRS9bFQCby4PHmaG9Oh2Q9VKwn250G04rB4Ly2/uwn97d+BC352VBUZvdYiMRX9vx
         0pCkD1g3i0l3mnkg+E82A636h5C/LromCdN6kJogbsWcBOV/pqpVQRnhNYxfiolKxtR0
         sxfkQi4pykpsEHUFNS1Q0ycatascGy3isCWFfkHp2l8vixRMVPAeXIx5/BIf2NcLgMPj
         nFZlwm7ynyVxulhwDsQtygpOKaxL2JZS+XC5snkyOMCwmanfAkH6XQNv3ua/TRo94WNo
         IBzZr7+lpV1EuRwJDM47+/JEQRjEu9xJp2YphUXQH2OBoojq3AsdpEihrPRw/g5pnM0m
         h2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QPiCDehj5KfLjTayla1DpLWE9agAsJpKBwRt66M5ZoY=;
        b=knbdJYg8CyjLMAe8M3gBDJikHqsuRUBWBFo7TK7PZdBxJeM3xcGSsPL+IeMnBPnpdd
         C6/3pEfZXWkgtXn/XWL6Bzwc6fB8eunz9o8ARtoUnP3v2/DooAMZgXMKK587G/2pbVfc
         lKE1Dr/pELwJFMzRiRqF37oZo25dKZKUuGfzWdxSRLg2B57UfQy36BxyjgYXrLJ66ldF
         jnfnSRUmKv9RXbNqeJ79fcFgsoRq0N7N3ueZ7vuXk6f8mrqaoKTMzHqOi3iCe9YO//aj
         1j3B82K0hH/hNoQkKqTFWyj0j6lK0g3pvFht5tsT2AAZm+LrIS85bWcMMA2jJ1QcohkL
         hagg==
X-Gm-Message-State: APjAAAWlEn652I9lgGmKh0BFOxoxDjeiU+2uDWU3HuctlxgayoqqOEEG
        KCtQyFKM05BZneAhnRf6m3bxvY0vq9Dors5l5e88gmJJbeGHnA==
X-Google-Smtp-Source: APXvYqwstSK8ZrZ9hTPS0VF6kGN10IGpWRxj6RQfedmDd57iYIEilTHKgKdA0BTtK26i9m3XdmYgTMMxd2LoBMd/jg0=
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr3203861wrx.241.1565845298567;
 Wed, 14 Aug 2019 22:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
 <20190805170037.31330-7-ard.biesheuvel@linaro.org> <20190815045421.GA24765@gondor.apana.org.au>
In-Reply-To: <20190815045421.GA24765@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 08:01:27 +0300
Message-ID: <CAKv+Gu93e1T0nzZYgzfvMdzQ6x=3WKHBTQ1vx7n+UHecQLVS6Q@mail.gmail.com>
Subject: Re: [PATCH v4 06/30] crypto: caam/des - switch to new verification routines
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 15 Aug 2019 at 07:54, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 05, 2019 at 08:00:13PM +0300, Ard Biesheuvel wrote:
> >
> > @@ -644,14 +643,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> >       if (keys.enckeylen != DES3_EDE_KEY_SIZE)
> >               goto badkey;
> >
> > -     flags = crypto_aead_get_flags(aead);
> > -     err = __des3_verify_key(&flags, keys.enckey);
> > -     if (unlikely(err)) {
> > -             crypto_aead_set_flags(aead, flags);
> > -             goto out;
> > -     }
> > -
> > -     err = aead_setkey(aead, key, keylen);
> > +     err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
> > +           aead_setkey(aead, key, keylen);
>
> Please don't use crypto_aead_tfm in new code (except in core crypto
> API code).
>
> You should instead provide separate helpers that are type-specific.
> So crypto_aead_des3_ede_verify_key or verify_aead_des3_key to be
> more succinct.
>

OK

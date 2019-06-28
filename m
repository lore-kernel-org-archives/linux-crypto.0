Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169A6C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D006B205ED
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yiHb9nBC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfF1JpW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:45:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33551 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfF1JpW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:45:22 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so11236518iop.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZEchM1qjffw8o6kgwI/WRhUWoDP8c6OravR8Vsi88Tg=;
        b=yiHb9nBChk0nXHY8DTstXfmLWET39cyFoM0OPP7tBZoPbK9EvwNZybvCvLeLRwLHZ4
         5j5JcdwiBo68Grjsu3EwTmTYIiAwroDnQRV4dHAgZEX8t47fkjEK47N0xeLJwivqETZd
         DbpgFpX4qGmniBbsZ4cih6QRQyqKC7YRkI2hJrX0q+l48xyJ4ONFLbrX1pZqtWc4Gq0V
         W9DRIBLPjk7iQqaupqckQ/a0jvE/sA5PO9olrhVAicDGFhOJgZHM+9s6cwHet3z4s/xD
         +kd7i+Y2+j9e3z2jVLKZulFwSiwSpPw3/c3dVzBJw+7mRm9PJ7q5lyX9tUfMdO2TRbi8
         9jJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZEchM1qjffw8o6kgwI/WRhUWoDP8c6OravR8Vsi88Tg=;
        b=pkh663hbnnzUuoRm4qMCIsponhlqN1kBXMOSQTbqrMxlCYg8gO0KjREW3J9KXitBSM
         BpLtA7H4tFo8FJE9kpbp6F1V2D6hZJ34IdUbQsuitv5/L3h0vpGVlL/1oyTJBo1kxQKP
         7KWARGDszkp6n+io5r3V8O1/O4IdrLt3qEWvQqa00PlvzycGWVX6WOLHGpQNVSrXuUm5
         kz/IaU6cGFAeRqxc93oruI2z4SPPBxm+AJnrU9/W7dWbF04TkAzsdJUC69z239hfn2SB
         +texcTCa8LM7bxgUgwmC6sl+gi4TUoR3lCQX68FeS3Fg7+kBD3pqJva1Y5tW4djwLSBf
         Ftow==
X-Gm-Message-State: APjAAAWFWYxLMr62r4R1Mop+14xaR5qgXbklL6t6AygBYPBeeOIarB9d
        u1wnKfkCg3YhWtz4Zyg/mAmDWVsknlymfFZ1hEWERw==
X-Google-Smtp-Source: APXvYqwBAjA74Wd1LyHPC4Kja2Uis9WWkkoocjEJfuUxOtscEdyQl6nugvn3CLiz9NK1PW3AThNMZl6gPUlyBBxtSD4=
X-Received: by 2002:a5e:d51a:: with SMTP id e26mr9929707iom.71.1561715121020;
 Fri, 28 Jun 2019 02:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
 <20190627102647.2992-29-ard.biesheuvel@linaro.org> <20190627175233.GI686@sol.localdomain>
In-Reply-To: <20190627175233.GI686@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 28 Jun 2019 11:45:09 +0200
Message-ID: <CAKv+Gu8vTXnHLUZUijC733+FA9OJyTVYnLRRc-+=x_j+kMOKAA@mail.gmail.com>
Subject: Re: [PATCH v3 28/32] crypto: lib/aes - export sbox and inverse sbox
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 19:52, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jun 27, 2019 at 12:26:43PM +0200, Ard Biesheuvel wrote:
> > There are a few copies of the AES S-boxes floating around, so export
> > the ones from the AES library so that we can reuse them in other
> > modules.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  include/crypto/aes.h | 3 +++
> >  lib/crypto/aes.c     | 6 ++++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> > index df8426fd8051..8e0f4cf948e5 100644
> > --- a/include/crypto/aes.h
> > +++ b/include/crypto/aes.h
> > @@ -67,4 +67,7 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8=
 *out, const u8 *in);
> >   */
> >  void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *=
in);
> >
> > +extern const u8 crypto_aes_sbox[];
> > +extern const u8 crypto_aes_inv_sbox[];
> > +
> >  #endif
> > diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> > index 9928b23e0a8a..467f0c35a0e0 100644
> > --- a/lib/crypto/aes.c
> > +++ b/lib/crypto/aes.c
> > @@ -82,6 +82,12 @@ static volatile const u8 __cacheline_aligned aes_inv=
_sbox[] =3D {
> >       0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
> >  };
> >
> > +extern const u8 crypto_aes_sbox[] __alias(aes_sbox);
> > +extern const u8 crypto_aes_inv_sbox[] __alias(aes_inv_sbox);
> > +
> > +EXPORT_SYMBOL(crypto_aes_sbox);
> > +EXPORT_SYMBOL(crypto_aes_inv_sbox);
>
> I got a compiler warning:
>
> In file included from ./include/linux/linkage.h:7,
>                  from ./include/linux/kernel.h:8,
>                  from ./include/linux/crypto.h:16,
>                  from ./include/crypto/aes.h:10,
>                  from lib/crypto/aes.c:6:
> lib/crypto/aes.c:88:15: warning: array =E2=80=98crypto_aes_sbox=E2=80=99 =
assumed to have one element
>  EXPORT_SYMBOL(crypto_aes_sbox);
>                ^~~~~~~~~~~~~~~
> ./include/linux/export.h:79:21: note: in definition of macro =E2=80=98___=
EXPORT_SYMBOL=E2=80=99
>   extern typeof(sym) sym;      \
>                      ^~~
> lib/crypto/aes.c:88:1: note: in expansion of macro =E2=80=98EXPORT_SYMBOL=
=E2=80=99
>  EXPORT_SYMBOL(crypto_aes_sbox);
>  ^~~~~~~~~~~~~
> lib/crypto/aes.c:89:15: warning: array =E2=80=98crypto_aes_inv_sbox=E2=80=
=99 assumed to have one element
>  EXPORT_SYMBOL(crypto_aes_inv_sbox);
>                ^~~~~~~~~~~~~~~~~~~
> ./include/linux/export.h:79:21: note: in definition of macro =E2=80=98___=
EXPORT_SYMBOL=E2=80=99
>   extern typeof(sym) sym;      \
>                      ^~~
> lib/crypto/aes.c:89:1: note: in expansion of macro =E2=80=98EXPORT_SYMBOL=
=E2=80=99
>  EXPORT_SYMBOL(crypto_aes_inv_sbox);
>  ^~~~~~~~~~~~~

OK, I'll need to apply the following hunk on top to fix that

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 467f0c35a0e0..4e100af38c51 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -82,8 +82,8 @@ static volatile const u8 __cacheline_aligned
aes_inv_sbox[] =3D {
        0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
 };

-extern const u8 crypto_aes_sbox[] __alias(aes_sbox);
-extern const u8 crypto_aes_inv_sbox[] __alias(aes_inv_sbox);
+extern const u8 crypto_aes_sbox[256] __alias(aes_sbox);
+extern const u8 crypto_aes_inv_sbox[256] __alias(aes_inv_sbox);

 EXPORT_SYMBOL(crypto_aes_sbox);
 EXPORT_SYMBOL(crypto_aes_inv_sbox);

I'll leave it up to Herbert to decide whether he wants that as a
follow up patch or whether I should respin and resend (assuming there
are no other reasons to do so)

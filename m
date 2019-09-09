Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A46C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 15:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C3820863
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 15:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="ri85efti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfIIP14 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 11:27:56 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:36104 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfIIP14 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 11:27:56 -0400
Received: by mail-ua1-f66.google.com with SMTP id n6so4427247uaq.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 08:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wLlD4Av2GPGNAH6mE8NHDj5nD9ZF60iyYdQqE3xMVqg=;
        b=ri85eftiEsv7cctmcn/hD6uXktuHydqh23KwIms16z3pl10birkubCRtJh1iL2cmwu
         TtOQKrdJ7E3jv3Ok+M11YcZt07F+4UaRTzLguI2/FchCqDrJsFd++ZrvEa4ElQhSay75
         WbyZL5xmEUbAal19NbKlr+6YYlgjf9K0gwEmuXcGUxz1wBj6WgGgZoqnqCGg29/ZNx0I
         f9+mzSOawnrqLJpc74E9Zpt/uFTY6IDwZQFq1qxNx/H4h+svm76gBiGloUCGS9GH9a8h
         u0nyoev8OtyjW+rDBOMzao39v5wn+b3B0x0uQ0ITrAK1gLR83MeIfCoY14Jzur4v6hvY
         q9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wLlD4Av2GPGNAH6mE8NHDj5nD9ZF60iyYdQqE3xMVqg=;
        b=GHuLWSaLDscJG3oAHbflHAmIXEzo4Rq2lnfLCh3eL2kgqRhnkASg0XrSj2uwnVDmHW
         i6vmBoWpIZdLCCVF1Jnwoe3ZURIyUg0I5DfVZ8cYahVcVXVYhANPpafOgbd/oeGgAgdo
         Wn+0sD03PUD1PHheFojl9lGwe3pYcDdPPDI/KgeTYiZlpRwY+yLK9133DfcUPxJ6zECq
         c4qwjQw48hs667ZyNS4BqZGVYmm80iWPN8ws5JePXTo6kzmMmO53js5Y2VR0AsfQ4O+x
         VvBC8+9C4e6K7lFwhHh0bR7XaMnF+/7rodbxI2C3cfQPm1fN82V1y1n0a6A99Ge1OOqd
         BH9A==
X-Gm-Message-State: APjAAAWTbCFc9kaByEdGn9crKtNkGXIQ2cnR90/8ei2cxdTKSClYyUf/
        hiEiCQeJsDVnDM/Oe229r88m+rONnWiRxxv04JxNAA==
X-Google-Smtp-Source: APXvYqyOLMYfxL7ASfmwLhmv9Km9eH3/3lu+COFpY6SB/SuAKRkeSY0vO4TGrUFEaLw221jT61HbpKSxlzWnhnH99sc=
X-Received: by 2002:ab0:4a48:: with SMTP id r8mr11014311uae.87.1568042875361;
 Mon, 09 Sep 2019 08:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
 <CAKv+Gu9tVkES12fA0cauMhUV+EZ6HZZwMopJo47qE6j8hsFv4w@mail.gmail.com>
 <CAOtvUMfqyYNEa6N32eKn=cVaOyEezYeiA1o-6fTrjxrzVHM80Q@mail.gmail.com> <CAKv+Gu_c2rp6JT4dzy8a_ubd5Jorsnfc8ra3kfocAHmyMTLTNg@mail.gmail.com>
In-Reply-To: <CAKv+Gu_c2rp6JT4dzy8a_ubd5Jorsnfc8ra3kfocAHmyMTLTNg@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 9 Sep 2019 18:27:44 +0300
Message-ID: <CAOtvUMdfgXe0YMUWunEVAOPoxmDCXYG4vo-9ryfb7hMvenfv8A@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - enable CTS support in AES-XTS
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Uri Shir <uri.shir@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 9, 2019 at 5:38 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
>
> On Mon, 9 Sep 2019 at 13:34, Gilad Ben-Yossef <gilad@benyossef.com> wrote=
:
> >
> > On Mon, Sep 9, 2019 at 3:20 PM Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
> > >
> > > On Sun, 8 Sep 2019 at 09:04, Uri Shir <uri.shir@arm.com> wrote:
> > > >
> > > > In XTS encryption/decryption the plaintext byte size
> > > > can be >=3D AES_BLOCK_SIZE. This patch enable the AES-XTS ciphertex=
t
> > > > stealing implementation in ccree driver.
> > > >
> > > > Signed-off-by: Uri Shir <uri.shir@arm.com>
> > > > ---
> > > >  drivers/crypto/ccree/cc_cipher.c | 16 ++++++----------
> > > >  1 file changed, 6 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccre=
e/cc_cipher.c
> > > > index 5b58226..a95d3bd 100644
> > > > --- a/drivers/crypto/ccree/cc_cipher.c
> > > > +++ b/drivers/crypto/ccree/cc_cipher.c
> > > > @@ -116,10 +116,6 @@ static int validate_data_size(struct cc_cipher=
_ctx *ctx_p,
> > > >         case S_DIN_to_AES:
> > > >                 switch (ctx_p->cipher_mode) {
> > > >                 case DRV_CIPHER_XTS:
> > > > -                       if (size >=3D AES_BLOCK_SIZE &&
> > > > -                           IS_ALIGNED(size, AES_BLOCK_SIZE))
> > > > -                               return 0;
> > > > -                       break;
> > >
> > > You should still check for size < block size.
> > Look again - he does via the fall through aspect of the case.
> >
>
> Ah right - I missed that.
>
> > >
> > > >                 case DRV_CIPHER_CBC_CTS:
> > > >                         if (size >=3D AES_BLOCK_SIZE)
> > > >                                 return 0;
> > > > @@ -945,7 +941,7 @@ static const struct cc_alg_template skcipher_al=
gs[] =3D {
> > > >         {
> > > >                 .name =3D "xts(paes)",
> > > >                 .driver_name =3D "xts-paes-ccree",
> > > > -               .blocksize =3D AES_BLOCK_SIZE,
> > > > +               .blocksize =3D 1,
> > >
> > > No need for these blocksize changes - just keep them as they are.
> >
> > hm... I'm a little confused about this.
> > Why do we have, say CTR template, announce a block size of 1 (which
> > makes sense since it effectively turns a block cipher to a stream
> > cipher) but here stick to the underlying block size?
> > I mean, you can request processing for any granularity (subject to the
> > bigger than 1 block), just like CTR so I'm not sure what information
> > is supposed to be conveyed here.
> >
>
> The blocksize is primarily used by the walking code to ensure that the
> input is a round multiple. In the XTS case, we can't blindly use the
> skcipher walk interface to go over the data anyway, since the last
> full block needs special handling as well.
>
> So the answer is really that we had no reason to change it for the
> other drivers, and changing it here will trigger a failure in the
> testing code that compares against the generic implementations.

I see. That makes sense. Thanks for the explanation.

Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

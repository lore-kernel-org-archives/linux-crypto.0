Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBF0C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0286C20863
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="rAvd92Iy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfIIMeQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:34:16 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:37842 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfIIMeP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:34:15 -0400
Received: by mail-vs1-f68.google.com with SMTP id q9so8614870vsl.4
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 05:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yqaQKnSXgEOuKm4oGzJw65dd73di70Ehfk5upO4VYVU=;
        b=rAvd92IyOIcEp2JGPDxVa3O8Mthr9unFTpoJSybNe+F9RDxBSdiZjkS/MPljb9c0kB
         mWQLvQfJjidpOmWmdrhDPQlRS7NzqU7G/EQpKu//qa6zt3M26SYCscnDGngcsjZPN7yf
         zCYlKOXEmXyf46eh0lTwSwjsLBI7kYpvYYLrDP8BrReOciGVFKx5Kc9H1D6aAoVmJyzZ
         KV1L4kWpgWuesKhM7ozDmu43Cgd9mBT6Rf1rY0oh8A4mXrQaFw8Ji7bpklexv/V9oHkH
         vR5RmcqDn546T3UgChP9eFNDIqz2OC6eKr+dGOMJbqLckoBIngrveMFQSY+4yOlAFgQp
         QJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yqaQKnSXgEOuKm4oGzJw65dd73di70Ehfk5upO4VYVU=;
        b=IaKC4xSRTHdD8XDF1RO2s0poCjUPN0fC27FeokXOy/B/+8gEHKEjHn4UnEleJ0PHOF
         b1qV+lgfRROjs53T08LHNWE7HVIcI7Al0pPf689ug5mBsVsl+BgOZ/MO+xcjGS9HYUAJ
         DQBd7qRAXBgSb02iMw+xPwEPV9QnA/Q/dmNcYMAsr88Z2Q/r+3f1OISFbSDRrpAoewO6
         od3aHt9Hc7QUoU8hjiLZRjflpIwPdLbra980hNHIcp91zefSRMdUuLbC+fpzIWpsISzr
         VBSTgOZSeyc1CsCIbLjyHlI+6aZcSEjWepj6mLCjsHfqlOZIJ7y3mJnU7XuRwCjKmqL5
         bZUA==
X-Gm-Message-State: APjAAAVnSsH5CMfgAQtDvEvVVbp09XXV7ItyhsKIyvR4Fgyz6qXnnNFx
        5JL409wkYYeMskGJbF4kk2I8kdL42lN/4WcIRQ9rNw==
X-Google-Smtp-Source: APXvYqzKvfgHG8TB4ASknI4xg01iSCBUXYnpfocu4okfaMmlZybwRZUT8nWW/SLK7wD2mtwQsvfcdnbZqg1zdk6rwTo=
X-Received: by 2002:a67:f08d:: with SMTP id i13mr13022815vsl.193.1568032454766;
 Mon, 09 Sep 2019 05:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <1567929866-7089-1-git-send-email-uri.shir@arm.com> <CAKv+Gu9tVkES12fA0cauMhUV+EZ6HZZwMopJo47qE6j8hsFv4w@mail.gmail.com>
In-Reply-To: <CAKv+Gu9tVkES12fA0cauMhUV+EZ6HZZwMopJo47qE6j8hsFv4w@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 9 Sep 2019 15:34:03 +0300
Message-ID: <CAOtvUMfqyYNEa6N32eKn=cVaOyEezYeiA1o-6fTrjxrzVHM80Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - enable CTS support in AES-XTS
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Uri Shir <uri.shir@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 9, 2019 at 3:20 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Sun, 8 Sep 2019 at 09:04, Uri Shir <uri.shir@arm.com> wrote:
> >
> > In XTS encryption/decryption the plaintext byte size
> > can be >= AES_BLOCK_SIZE. This patch enable the AES-XTS ciphertext
> > stealing implementation in ccree driver.
> >
> > Signed-off-by: Uri Shir <uri.shir@arm.com>
> > ---
> >  drivers/crypto/ccree/cc_cipher.c | 16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
> > index 5b58226..a95d3bd 100644
> > --- a/drivers/crypto/ccree/cc_cipher.c
> > +++ b/drivers/crypto/ccree/cc_cipher.c
> > @@ -116,10 +116,6 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
> >         case S_DIN_to_AES:
> >                 switch (ctx_p->cipher_mode) {
> >                 case DRV_CIPHER_XTS:
> > -                       if (size >= AES_BLOCK_SIZE &&
> > -                           IS_ALIGNED(size, AES_BLOCK_SIZE))
> > -                               return 0;
> > -                       break;
>
> You should still check for size < block size.
Look again - he does via the fall through aspect of the case.

>
> >                 case DRV_CIPHER_CBC_CTS:
> >                         if (size >= AES_BLOCK_SIZE)
> >                                 return 0;
> > @@ -945,7 +941,7 @@ static const struct cc_alg_template skcipher_algs[] = {
> >         {
> >                 .name = "xts(paes)",
> >                 .driver_name = "xts-paes-ccree",
> > -               .blocksize = AES_BLOCK_SIZE,
> > +               .blocksize = 1,
>
> No need for these blocksize changes - just keep them as they are.

hm... I'm a little confused about this.
Why do we have, say CTR template, announce a block size of 1 (which
makes sense since it effectively turns a block cipher to a stream
cipher) but here stick to the underlying block size?
I mean, you can request processing for any granularity (subject to the
bigger than 1 block), just like CTR so I'm not sure what information
is supposed to be conveyed here.

Thanks,
Gilad

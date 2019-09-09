Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A50DC4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 14:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C441218DE
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 14:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mrsnya/n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfIIOiY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 10:38:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50680 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfIIOiY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 10:38:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id c10so14214672wmc.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 07:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U1ZXW07cMLehJbh1lVrooORwDtzpTD5JCvLhgXu112k=;
        b=mrsnya/nGYQSiXqLzUJSjL7o7gmV/A1GBVqkR9Jl8C4XYM2THM13qDfRi9MbqNb2wH
         /zMyRe4+pof/9mgFByVDsC9qunZM0YsjQOt9v5/YvhU5srZ0Px7EC4gLYbvb0sIrk4KX
         hKcDOd2Cus2JYb/eIUOlbuCItFiB+AVPH+kezb0ABDkyk6In3PbufHKwFjWpu2/+RP7e
         2G2IQMBZssFPCqI0DiIrMYZ4D5gnQMiAj206Li0q7SbBLTz8VyT2eWGIm3h9r+DwIHO9
         2cYg1Ggom2aszI0x35iEBMwxLU4J8/sNaNaw1dmyhZuNQQnCNa5GK4P4LyGEddDge11S
         44RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U1ZXW07cMLehJbh1lVrooORwDtzpTD5JCvLhgXu112k=;
        b=gdCRT0zoFzUJsUY1tiGOvKc015LlwpujNSKlqXG0xJbwEi68j/u3jgtJY00uj+j7v2
         jGBv3obiDzqd0jsYAkNgjPP+bf4eKB98So4BlAJJ+raA3m3q6VL4Bd+jdvW/PMqSYJ7M
         QrsJPMvX+2bacTRm67DRDYCxmcZ21I4GIAFtzURXPimiVNetqGicZMOua40RmkDwq4Lo
         Hfj6s5UYLNtJIJgGGa86kJFf11HFCmtcxLLMVJsSpuz2vnzjjAaxdZqFzux0p7DF/o7P
         6r40ag8Me5J9uBA68fGDAYmWYnZb0Dt7fHFMUHRYK/hG9Db76GsHlyYN4xirXqFGpZ9o
         VeyA==
X-Gm-Message-State: APjAAAXFu06qm+60Kfh82liacSdbhcRIhJlhTw+ESqa2Qg70agpke5iM
        V4xZ6aVOiC2nhkw9jLFnNf7Xh2n7ENSxC0O3h+xe3w==
X-Google-Smtp-Source: APXvYqyPXHAutHfdn+UddN9t40WxEll9h8hkp0M3/0cTAG++O1tdHCc8bIyNyIEH68ll4lpJfQPzN0TMZddK7uV+mp0=
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr19540809wmg.53.1568039900416;
 Mon, 09 Sep 2019 07:38:20 -0700 (PDT)
MIME-Version: 1.0
References: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
 <CAKv+Gu9tVkES12fA0cauMhUV+EZ6HZZwMopJo47qE6j8hsFv4w@mail.gmail.com> <CAOtvUMfqyYNEa6N32eKn=cVaOyEezYeiA1o-6fTrjxrzVHM80Q@mail.gmail.com>
In-Reply-To: <CAOtvUMfqyYNEa6N32eKn=cVaOyEezYeiA1o-6fTrjxrzVHM80Q@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 9 Sep 2019 15:38:02 +0100
Message-ID: <CAKv+Gu_c2rp6JT4dzy8a_ubd5Jorsnfc8ra3kfocAHmyMTLTNg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - enable CTS support in AES-XTS
To:     Gilad Ben-Yossef <gilad@benyossef.com>
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

On Mon, 9 Sep 2019 at 13:34, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> On Mon, Sep 9, 2019 at 3:20 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Sun, 8 Sep 2019 at 09:04, Uri Shir <uri.shir@arm.com> wrote:
> > >
> > > In XTS encryption/decryption the plaintext byte size
> > > can be >= AES_BLOCK_SIZE. This patch enable the AES-XTS ciphertext
> > > stealing implementation in ccree driver.
> > >
> > > Signed-off-by: Uri Shir <uri.shir@arm.com>
> > > ---
> > >  drivers/crypto/ccree/cc_cipher.c | 16 ++++++----------
> > >  1 file changed, 6 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
> > > index 5b58226..a95d3bd 100644
> > > --- a/drivers/crypto/ccree/cc_cipher.c
> > > +++ b/drivers/crypto/ccree/cc_cipher.c
> > > @@ -116,10 +116,6 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
> > >         case S_DIN_to_AES:
> > >                 switch (ctx_p->cipher_mode) {
> > >                 case DRV_CIPHER_XTS:
> > > -                       if (size >= AES_BLOCK_SIZE &&
> > > -                           IS_ALIGNED(size, AES_BLOCK_SIZE))
> > > -                               return 0;
> > > -                       break;
> >
> > You should still check for size < block size.
> Look again - he does via the fall through aspect of the case.
>

Ah right - I missed that.

> >
> > >                 case DRV_CIPHER_CBC_CTS:
> > >                         if (size >= AES_BLOCK_SIZE)
> > >                                 return 0;
> > > @@ -945,7 +941,7 @@ static const struct cc_alg_template skcipher_algs[] = {
> > >         {
> > >                 .name = "xts(paes)",
> > >                 .driver_name = "xts-paes-ccree",
> > > -               .blocksize = AES_BLOCK_SIZE,
> > > +               .blocksize = 1,
> >
> > No need for these blocksize changes - just keep them as they are.
>
> hm... I'm a little confused about this.
> Why do we have, say CTR template, announce a block size of 1 (which
> makes sense since it effectively turns a block cipher to a stream
> cipher) but here stick to the underlying block size?
> I mean, you can request processing for any granularity (subject to the
> bigger than 1 block), just like CTR so I'm not sure what information
> is supposed to be conveyed here.
>

The blocksize is primarily used by the walking code to ensure that the
input is a round multiple. In the XTS case, we can't blindly use the
skcipher walk interface to go over the data anyway, since the last
full block needs special handling as well.

So the answer is really that we had no reason to change it for the
other drivers, and changing it here will trigger a failure in the
testing code that compares against the generic implementations.

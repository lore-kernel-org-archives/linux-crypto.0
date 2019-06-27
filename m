Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DBDC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 13:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E0720828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 13:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tapn1N/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfF0NpQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 09:45:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33223 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0NpQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 09:45:16 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so4890397iop.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 06:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zTU1BCR3y5H6UcQD/LO5/CTv37Ry7d396AOZchn/5bo=;
        b=tapn1N/q6m64rkSjQP+dtm/AYxx5pPBGRcXyB2vdwpVQrrVEBp3BwXlO3If+5rZbnz
         vXTxh/z75ixZ54bxWMVgngbGPEEgevcvZCC8t8gf3NkFq5WfuNZLolRTYuv8nVSTzu5c
         dnUJk8sdptRpJCy56maYkxzBsaC6pQmM/85cRoKFH6i+hA3FF2H05TVuxgf93vNDfwJn
         rQYt/tmGe7LipuXGo8oHN8KFXUOrfHU1Xu7sSgF/NL1WS3wuZsfFhy14PmEJGN3aiLFo
         eszmbwb0KVk6r8aoKzEG/R4d6aSZKn9m9Wq0X702Mzz+T2g8XUrLOjwPpzZ1u0b90CO2
         AXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zTU1BCR3y5H6UcQD/LO5/CTv37Ry7d396AOZchn/5bo=;
        b=FzWv04hQ87263/2bbjwALEw6a5rnCBeWHlssaR54XPg3/G5qD/aRd8AvvPj03U7oBV
         Bex+nZj0CoE/9pbI0CPXzcdy9tnv5ZUQxCeBf+9sCSmPOsJIOmGXUDAlkY5MEfE2DCux
         lfFrOgkalpS513NxXwb5tWPbRPYV9YvdFauPtTG2w0r5M90LmNAKOUhnc7V7tuR9v3B+
         pET+Wt2krYyNyBgIFrLvtfrjlu4ynIs/zgpcxtoSaHQV/e+0pQ/40CE/iSoBggf7Qbb4
         YyO8JUWiUuDuC/gpejcYZymxlbLq9Nekmjm0F+Zio0+lVpcL0BGMECV1szGiKnv+6GRW
         puqA==
X-Gm-Message-State: APjAAAXj54s30NYCdIPsePOGiDLv2Z4y8spTKS5FKnF4nPGln3OzsJgw
        o8tUEQQNUdqfGhSOS8s/F1cFdV2htVC693jo2rpjRw==
X-Google-Smtp-Source: APXvYqzLvGzsHmOQce9qole2UEBHLCjTNbQ02zxyjzIrBbbp2DujUb471abkGzmMUX5jp6hLAN8AMibTB6pk0tRvMaA=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr4439133ion.65.1561643115267;
 Thu, 27 Jun 2019 06:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
 <20190627120314.7197-7-ard.biesheuvel@linaro.org> <VI1PR0402MB348532DF646DA7522F7B689698FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348532DF646DA7522F7B689698FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 15:45:02 +0200
Message-ID: <CAKv+Gu8D5JUUHtaOv2=gDt2s7r0ekQEVbyNBJXG5PCOG4thsCg@mail.gmail.com>
Subject: Re: [PATCH v2 06/30] crypto: caam/des - switch to new verification routines
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 15:26, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 6/27/2019 3:03 PM, Ard Biesheuvel wrote:
> > @@ -785,20 +781,23 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
> >  static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
> >                              const u8 *key, unsigned int keylen)
> >  {
> > -     u32 tmp[DES3_EDE_EXPKEY_WORDS];
> > -     struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
> > +     int err;
> >
> > -     if (keylen == DES3_EDE_KEY_SIZE &&
> > -         __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
> > -             return -EINVAL;
> > -     }
> > +     err = crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key);
> > +     if (unlikely(err))
> > +             return err;
> >
> > -     if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
> > -         CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
> > -             crypto_skcipher_set_flags(skcipher,
> > -                                       CRYPTO_TFM_RES_WEAK_KEY);
> > -             return -EINVAL;
> > -     }
> > +     return skcipher_setkey(skcipher, key, keylen);
>
> This would be a bit more compact:
>
>         return unlikely(crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key)) ?:
>                skcipher_setkey(skcipher, key, keylen);
>
> and could be used in most places.
>
> Actually here:
>
> > @@ -697,8 +693,13 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
> >  static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
> >                               const u8 *key, unsigned int keylen)
> >  {
> > -     return unlikely(des3_verify_key(skcipher, key)) ?:
> > -            skcipher_setkey(skcipher, key, keylen);
> > +     int err;
> > +
> > +     err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
> > +     if (unlikely(err))
> > +             return err;
> > +
> > +     return skcipher_setkey(skcipher, key, keylen);
> >  }
>
> this pattern is already used, only the verification function
> has to be replaced.
>

OK, got it.

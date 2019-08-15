Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CD2C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4EDC2086C
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iDd/HFP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfHOFnv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 01:43:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45864 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfHOFnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 01:43:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so1157281wrj.12
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2019 22:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jsC+vll+0Hi+DHMsoqNM1KNt99J+HLSGwZ/qaqMGKuA=;
        b=iDd/HFP5dKBbq3DPltvx84KDTh1RBaEvnkRIDUBXNXp3aa9qie+oJMDkAe4ypJc/rU
         yWS7w2C4Hdf3s9lE2XeZg8ZbUVicL6JUnT8lPXMQgCXlochuCMT9BzHTz9ppKm2D4FKz
         PEKkT96PUTeX4TlKMHkbk4cMLTVhmphCpmZSkxD4C9AhqcB9LS4djX0iWL+BJitLM4pm
         yVS84ajHeHspdjOwxZoIuxuYD3PixakjtxMLIBazRL912t4wKJhjWV+1TlHYc/WjEm/4
         v5nFh2uUdMkc04h09HYU5QfG9PZzBSEiWumQDuwUKdaiU9CgZlxKqQfJuOGUDH14muSO
         pKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jsC+vll+0Hi+DHMsoqNM1KNt99J+HLSGwZ/qaqMGKuA=;
        b=Z7GOzxmTh1n6MjTBCkB/8ucVm+IFy0iL/IFFNBDQ7+CkqKH6ihBOAW5vCy9O6Lg5mt
         +SipQjNPGzlJYznAtaHfwFCQ2ruS5rz4W43XhwHKr0TeYr/MmprCGI/DEaZKbU8Ci2Sz
         DYKNijXnKL8M3L9j55DX9eIxlrWXpEHI9TBk8tMEZ0JBuaid719udLMmobnMoj8XKGN6
         cNF0G7ITipOaWkqoaEhXqYLMqzjNMOp1i7ZDS0YAoALwt/Oq5w5Tb67luX8fy3sef9sx
         PdJK6PN9gM3Agft91TiT7wiiAWLWvX0g/Z4SETNAo3cN8Q6KKaRo9OfCg+3FDlLTnsxK
         UTvw==
X-Gm-Message-State: APjAAAVfqrrQ6m4g16nmr8O0QLDp3RPoumj4LGlQh1RAB66Hc3OAndxj
        fuiw6MKrOl+RswCvtITNjwGNUZOkEfZnJbITt94Bmg==
X-Google-Smtp-Source: APXvYqztfIP57qqOkol+TXg3aGJAtxnZmSe0yrzb3gIpyPdejjl3F78Dh8UFK2p+eidW6qqrAfSVhKaTr47xGZPdYOw=
X-Received: by 2002:adf:9e09:: with SMTP id u9mr3317860wre.169.1565847829084;
 Wed, 14 Aug 2019 22:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
 <20190805170037.31330-7-ard.biesheuvel@linaro.org> <20190815045421.GA24765@gondor.apana.org.au>
 <CAKv+Gu93e1T0nzZYgzfvMdzQ6x=3WKHBTQ1vx7n+UHecQLVS6Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu93e1T0nzZYgzfvMdzQ6x=3WKHBTQ1vx7n+UHecQLVS6Q@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 08:43:38 +0300
Message-ID: <CAKv+Gu8aX_QQ4WuydX6pu+GZeRzi8_vZ24Dp0dJddpNLfcTxfQ@mail.gmail.com>
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

On Thu, 15 Aug 2019 at 08:01, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 15 Aug 2019 at 07:54, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Mon, Aug 05, 2019 at 08:00:13PM +0300, Ard Biesheuvel wrote:
> > >
> > > @@ -644,14 +643,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> > >       if (keys.enckeylen != DES3_EDE_KEY_SIZE)
> > >               goto badkey;
> > >
> > > -     flags = crypto_aead_get_flags(aead);
> > > -     err = __des3_verify_key(&flags, keys.enckey);
> > > -     if (unlikely(err)) {
> > > -             crypto_aead_set_flags(aead, flags);
> > > -             goto out;
> > > -     }
> > > -
> > > -     err = aead_setkey(aead, key, keylen);
> > > +     err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
> > > +           aead_setkey(aead, key, keylen);
> >
> > Please don't use crypto_aead_tfm in new code (except in core crypto
> > API code).
> >
> > You should instead provide separate helpers that are type-specific.
> > So crypto_aead_des3_ede_verify_key or verify_aead_des3_key to be
> > more succinct.
> >
>
> OK

So I will end up with

static inline int verify_skcipher_des_key(struct crypto_skcipher *tfm,
  const u8 *key)
static inline int verify_skcipher_des3_key(struct crypto_skcipher *tfm,
   const u8 *key)
static inline int verify_ablkcipher_des_key(struct crypto_skcipher *tfm,
    const u8 *key)
static inline int verify_ablkcipher_des3_key(struct crypto_skcipher *tfm,
     const u8 *key)
static inline int verify_aead_des3_key(struct crypto_aead *tfm, const u8 *key,
       int keylen)
static inline int verify_aead_des_key(struct crypto_aead *tfm, const u8 *key,
      int keylen)

Is that what you had in mind?

Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380DDC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 11:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E01E62085A
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 11:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TGX7p0j3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfF0LAm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 07:00:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33971 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0LAm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 07:00:42 -0400
Received: by mail-io1-f65.google.com with SMTP id k8so3794607iot.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 04:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GorRyE2r6qbb2Ytzd/AgezySPkRUSOeA/jyJMYQ4YTI=;
        b=TGX7p0j3megbCw0Oa5Gul9e46kUHQg0vF9sW8qH+GveGyMvFbMlu9Xo1bBsBetQ6AK
         gvP+B1aOcAAlq1x7XDKsvhxUGi4bDIB5sNN3Aohx+2IDxIGm/qJAQGwC7IUDw1lECGGD
         Mf0Ygd9wFrQaczk2bBaapjXT5PpF4BODMqGNWraiuT/KG2/6d5K3hwLeseofK0bA2Ybb
         EkyfGncPoLGrzrJoOhG3dHwYUmPaIpy6nVQFUqGX9dD5ivxJsh+lL57q8jhrCUDkJnIk
         NcdOP0YFpRA0FtgYoJgd4nLZKwYMWV1wGNRE7w61312l62vcE6EQjGVA4vPnAeOFZexR
         Gqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GorRyE2r6qbb2Ytzd/AgezySPkRUSOeA/jyJMYQ4YTI=;
        b=ZsiWydct+/VtOHatzk09vFIqJeeTuvNMbUIo209FZH0Mgx8FSNtuDUkv08nu1oLgWd
         UQ+Q0Cr+MmdqB/qdBX6WJo9IH5OA8tkqxRHFYyw75uZIrxl0n1e1eIemb7H3Fz3RO3bW
         sPsrng6Fdkfrpx7buuZRN2VQMAXstRErQDua/7aRGnt8dhvEq99fJpRe+5/9t8UsJ4mt
         r5RiK5MVIphs+extQn8GFRXWczeA0t7xooZQRhU9s5iTdJF2nhP8xBsRSh2jHamVqeVd
         /iowfO87m5qZXihwmarUjw7CgiXWezUYlSPTkZWtakRXVYZR2UFO80z2dX2iImycDQLh
         cbRg==
X-Gm-Message-State: APjAAAV2YVnEfJKQtiIa8a+WpxnNAzid26ASULrVZwRgfNmPJ8XRyH1l
        m2uxA6DeppIFgaaV228dqIir6RSMesZtTPet63Drx3nAwFY=
X-Google-Smtp-Source: APXvYqwQCcjhqwJZ8/lrmya3rsLrsh5KzKOohkvudA3jN3ulx9qfYNwXbfQT4FaAoGHeZY82GR/ymAIrKFqn3U5fGQg=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr3863398iob.49.1561633241305;
 Thu, 27 Jun 2019 04:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-7-ard.biesheuvel@linaro.org> <VI1PR0402MB34854404F8EBC4E158ED386F98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34854404F8EBC4E158ED386F98FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 13:00:29 +0200
Message-ID: <CAKv+Gu9K6ZEkFykLTdCQmX4-xCeutaBHmSZp1wD_-5b1ix812w@mail.gmail.com>
Subject: Re: [RFC PATCH 06/30] crypto: caam/des - switch to new verification routines
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@google.com" <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 11:58, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 6/22/2019 3:32 AM, Ard Biesheuvel wrote:
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/crypto/caam/caamalg.c     | 13 +++--------
> >  drivers/crypto/caam/caamalg_qi.c  | 23 ++++++++++----------
> >  drivers/crypto/caam/caamalg_qi2.c | 23 ++++++++++----------
> >  drivers/crypto/caam/compat.h      |  2 +-
> >  4 files changed, 26 insertions(+), 35 deletions(-)
> >
> Compiling the patch set, I get the following errors:
>

Thanks for the report, will fix for the next revision.


> drivers/crypto/caam/caamalg.c: In function 'des3_aead_setkey':
> drivers/crypto/caam/caamalg.c:642:51: error: 'tfm' undeclared (first use in this function)
>   err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey,
>                                                    ^
> drivers/crypto/caam/caamalg.c:642:51: note: each undeclared identifier is reported only once for each function it appears in
> drivers/crypto/caam/caamalg.c: In function 'des_skcipher_setkey':
> drivers/crypto/caam/caamalg.c:783:2: error: implicit declaration of function 'des_verify_key' [-Werror=implicit-function-declaration]
>   err = des_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);
>   ^
> drivers/crypto/caam/caamalg.c: In function 'des3_skcipher_setkey':
> drivers/crypto/caam/caamalg.c:795:28: warning: passing argument 1 of 'des3_ede_verify_key' from incompatible pointer type
>   err = des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);
>                             ^
> In file included from drivers/crypto/caam/compat.h:35:0,
>                  from drivers/crypto/caam/caamalg.c:49:
> ./include/crypto/internal/des.h:49:19: note: expected 'const u8 *' but argument is of type 'struct crypto_tfm *'
>  static inline int des3_ede_verify_key(const u8 *key, unsigned int key_len,
>                    ^
> drivers/crypto/caam/caamalg.c:795:59: warning: passing argument 2 of 'des3_ede_verify_key' makes integer from pointer without a cast
>   err = des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);
>                                                            ^
> In file included from drivers/crypto/caam/compat.h:35:0,
>                  from drivers/crypto/caam/caamalg.c:49:
> ./include/crypto/internal/des.h:49:19: note: expected 'unsigned int' but argument is of type 'const u8 *'
>  static inline int des3_ede_verify_key(const u8 *key, unsigned int key_len,
>                    ^
>
> > diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> > index 5d4fa65a015f..b4ab64146b21 100644
> > --- a/drivers/crypto/caam/caamalg.c
> > +++ b/drivers/crypto/caam/caamalg.c
> > @@ -633,23 +633,16 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> >                           unsigned int keylen)
> >  {
> >       struct crypto_authenc_keys keys;
> > -     u32 flags;
> >       int err;
> >
> >       err = crypto_authenc_extractkeys(&keys, key, keylen);
> >       if (unlikely(err))
> >               goto badkey;
> >
> > -     err = -EINVAL;
> > -     if (keys.enckeylen != DES3_EDE_KEY_SIZE)
> > -             goto badkey;
> > -
> > -     flags = crypto_aead_get_flags(aead);
> > -     err = __des3_verify_key(&flags, keys.enckey);
> > -     if (unlikely(err)) {
> > -             crypto_aead_set_flags(aead, flags);
> > +     err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey,
> > +                                      keys.enckeylen);
> > +     if (unlikely(err))
> >               goto out;
> > -     }
> >
> >       err = aead_setkey(aead, key, keylen);
> >
> > diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
> > index 32f0f8a72067..01d92ef0142a 100644
> > --- a/drivers/crypto/caam/caamalg_qi.c
> > +++ b/drivers/crypto/caam/caamalg_qi.c
> > @@ -296,23 +296,16 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> >                           unsigned int keylen)
> >  {
> >       struct crypto_authenc_keys keys;
> > -     u32 flags;
> >       int err;
> >
> >       err = crypto_authenc_extractkeys(&keys, key, keylen);
> >       if (unlikely(err))
> >               goto badkey;
> >
> > -     err = -EINVAL;
> > -     if (keys.enckeylen != DES3_EDE_KEY_SIZE)
> > -             goto badkey;
> > -
> > -     flags = crypto_aead_get_flags(aead);
> > -     err = __des3_verify_key(&flags, keys.enckey);
> > -     if (unlikely(err)) {
> > -             crypto_aead_set_flags(aead, flags);
> > +     err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,
> > +                                      keys.enckeylen);
> > +     if (unlikely(err))
> >               goto out;
> > -     }
> >
> >       err = aead_setkey(aead, key, keylen);
> >
> > @@ -697,8 +690,14 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
> >  static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
> >                               const u8 *key, unsigned int keylen)
> >  {
> > -     return unlikely(des3_verify_key(skcipher, key)) ?:
> > -            skcipher_setkey(skcipher, key, keylen);
> > +     int err;
> > +
> > +     err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key,
> > +                                      keylen);
> > +     if (unlikely(err))
> > +             return err;
> > +
> > +     return skcipher_setkey(skcipher, key, keylen);
> >  }
> >
> >  static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
> > diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> > index 06bf32c32cbd..074fbb8356e5 100644
> > --- a/drivers/crypto/caam/caamalg_qi2.c
> > +++ b/drivers/crypto/caam/caamalg_qi2.c
> > @@ -329,23 +329,16 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> >                           unsigned int keylen)
> >  {
> >       struct crypto_authenc_keys keys;
> > -     u32 flags;
> >       int err;
> >
> >       err = crypto_authenc_extractkeys(&keys, key, keylen);
> >       if (unlikely(err))
> >               goto badkey;
> >
> > -     err = -EINVAL;
> > -     if (keys.enckeylen != DES3_EDE_KEY_SIZE)
> > -             goto badkey;
> > -
> > -     flags = crypto_aead_get_flags(aead);
> > -     err = __des3_verify_key(&flags, keys.enckey);
> > -     if (unlikely(err)) {
> > -             crypto_aead_set_flags(aead, flags);
> > +     err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,
> > +                                      keys.enckeylen);
> > +     if (unlikely(err))
> >               goto out;
> > -     }
> >
> >       err = aead_setkey(aead, key, keylen);
> >
> > @@ -999,8 +992,14 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
> >  static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
> >                               const u8 *key, unsigned int keylen)
> >  {
> > -     return unlikely(des3_verify_key(skcipher, key)) ?:
> > -            skcipher_setkey(skcipher, key, keylen);
> > +     int err;
> > +
> > +     err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key,
> > +                                      keylen);
> > +     if (unlikely(err))
> > +             return err;
> > +
> > +     return skcipher_setkey(skcipher, key, keylen);
> >  }
> >
> >  static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
> > diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
> > index 8639b2df0371..60e2a54c19f1 100644
> > --- a/drivers/crypto/caam/compat.h
> > +++ b/drivers/crypto/caam/compat.h
> > @@ -32,7 +32,7 @@
> >  #include <crypto/null.h>
> >  #include <crypto/aes.h>
> >  #include <crypto/ctr.h>
> > -#include <crypto/des.h>
> > +#include <crypto/internal/des.h>
> >  #include <crypto/gcm.h>
> >  #include <crypto/sha.h>
> >  #include <crypto/md5.h>
> >
>

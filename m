Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3D53D9DF
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086197; cv=pass; b=tKNFE1+adGA7Ci4t7AXkqi/1f3vjBRlVwcW/0HkZefPIJqtF//eNU0VFo+5qaXBzWs5CSje8BTAJxo+HoqpWyQZ5VpzpaZhxcLKI+lwQfwchOj8TVuw9IloWXlIuB4mCD6nQEbal1iLUZvIjtqXyecLFE93Vz4To1WcxCr8VSlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086197; c=relaxed/simple;
	bh=ouZIw3iZo69Khbk3ADpLifIkS0RbQKYWlJW/NhSX2I8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bz4v2ecdocIX86Dx8GE7wKsMVq1IPmY6F3jQrz7nYhTzhFi6R1N8aJgeHlGF8ySbySKLuqehbl6FqbO4eTU7BQiUTX8TvY876k4l5Vbp15gJq28uaP7g2h0KGA6TZ71Jg3RLq3imukVKkxuwU7OCCNILG6hVC9BLbvEm9/5724U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=PBjPsrMu; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="PBjPsrMu"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5350d9ea106so67567581cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 10:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792086190; cv=none;
        d=google.com; s=arc-20260327;
        b=krLZN6deCqOewxO2x8seyb5tBfGCPLjEFuqzGTgZS7lGbFScJtKXEK+qfqVaoCHdNg
         r5Nb6fIbuZxCvZ7ELW1/vtK6Cx10K3QSjNrG6K0fRiesZNhrUYuKX4Rcej+ej9SFUDeD
         K8TLucxKcN4NHbQinU9+XY4vA72QCIo0m9+VPdF/6RF127yEQPRg4RaTD97HM+mGYiSl
         eobD1w5XGuGjI07N5mzZgumDeMGMh8Vv91klN8KPJ+sMW1RcJCjmb/1hJiiXLCu5ek0v
         Y0KCgkRxxMQBsQYNM4LkWd+/Xrxg9yJRGmAwn9UXdEijnLpP7PG81aTSqHjj91RPOcZB
         nlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DtehoLIZuXxFvvfEKkFhiUtbDfHZTL79xkMiYl5Ej+0=;
        fh=OUpgHz8gu+EFyREjScBnwgXxe9p5hHef04jJGlkpTWE=;
        b=Ul4iXv6Nlufl1qwmx8JS2U8peM22zVVEY/Dp407cWnk0wDU4P3n2txvTAdWwf0HPgX
         p0N8kFxWlZM0qmA51yZwPYHBYcx4hBiC4zHVs6wKjojlLugDR1tZ8zwtXdOFtFAPEKHZ
         rEmqRmI36ydVu/Z3+6z6YNbY3Iq1hmg+zdAcfIH4By3+uw/U7MxAgSZS/J9D/rNfnp8s
         391Y5YgFWhryEm6nLLhXX0IoD+XjoEgHNjKirQ4E9c41qihHkiLTffQ3LTBWNNcPcdRP
         XiZX/1AbVIg7OLcwhxENF7Lf57dYt+OBXkkaJRM7+hpj625MDgEHCPCLvhN7ili81RvS
         +sMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1792086190; x=1792690990; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DtehoLIZuXxFvvfEKkFhiUtbDfHZTL79xkMiYl5Ej+0=;
        b=PBjPsrMuKw3Cusj1fiHHBmkR1KWefRoQnYtYtcBlRClrgVzpTYdDqLhhiAZWX8Aei1
         Ovl+CabqJMeT+7h41TwcTyb6ofwuHJhRlsVk8c6mqKO9lSn3g8QYOt1XlNJ/9bCK3rP5
         /U2BuvHSP5yBiKj26d7H8im9GRo7d5wrdUAEA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792086190; x=1792690990;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DtehoLIZuXxFvvfEKkFhiUtbDfHZTL79xkMiYl5Ej+0=;
        b=t/ZPl0tyb6yL28aiGmMo5uhPUuj7sC0rM/ddYlMqhPP1c8wC1+bs0Yufbqlab2a5G3
         pu4+JdVUFJoLbC0HtH3jY7Kl/1CWKG+6uAHZcfSb3kspuDOFPw+ZhJ99NQ1ZeTE1LD/h
         BtI/zb7yQji8MKPvWbyu/yobvPlhzFNFu5JSIg/B1dFhcSscEs/W85gciWVrIHdFjgOZ
         e7CxqHRGi8V8ARDJZJv6AzOQm+6vuEwTikDbqrhSTqHgm1UmUOQ9/bAwydNk7WHSpVrQ
         cjBedGLyD+CwnxCpZNPk0tW8jyuKShQVyGfwN6s7tK/lGRIeXcPJr8eNxbKfLKOBld49
         uEWg==
X-Gm-Message-State: AFq9FYIrGjjemRYycQ3u5D215XLJveVtiBJXA9YMoC8eP3APje4DGDDT
	lgxrXMxJfXotCEpnzLqphxMQBsfL7TNO3RXu6Gt0Ciq/t2Ix7fQnYhFK3XAgTRfs/quC0RasGUi
	yBPkGESOYym0U0o2gaPdoWHA1u+u4nCKFgTbBE61HbA==
X-Gm-Gg: AYBFou35phBsJh1r+pB1FmRhvqCrosKasQQbY3p1UU5E6MoIFC0JpkWQczuKQuXyZQo
	uehzqxvyI8Jk0awC7ttF6U3i/fS8qsCFyfedcZyaawviAbN7OZm9R7dsMR9p4esCBKaCWPD7Dsz
	C6XUZy8gaLe/vllZU4aByZKHeEGlFHCZa6hl2L6zirMBYpdmyJSRlmrmQ5PJRD92iB7kGL98z5i
	bhRxmBPitHtd7f+V5OfH8+rTsjyxHj1Ph7o/haRdSZDlLxlz3dmT1LQ37grAxtRsuuIpN+7cgwX
	RNytF1XLq5MJjt3fuDPZCV7g+tavCkrJW3ZR6oqYOxr4KOOst9t1V+/ASoVF+RkNWGP3QDonXxP
	NzW8Pu9zHSucM2fMkSO0B2n1ORgqzSMbTOWFMzbe/lWe/JJXmTSarBsQdEYcYhGIpDQL7kq9i20
	4jm9hMq4bOuxH2i1b5D+bbUPUyy5pJAS5lUpSQd2MBlxU=
X-Received: by 2002:a05:622a:428b:b0:535:1cdd:a35a with SMTP id
 d75a77b69052e-5359f4864c6mr333448061cf.3.1792086190123; Thu, 15 Oct 2026
 10:43:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <asjT87HAZ_UUbbvm@gondor.apana.org.au> <CALxtO0=TXw68akF3AFPT0=J4tZ2XV+G5kuTOELGBzhbgBdN0RA@mail.gmail.com>
In-Reply-To: <CALxtO0=TXw68akF3AFPT0=J4tZ2XV+G5kuTOELGBzhbgBdN0RA@mail.gmail.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 15 Oct 2026 23:12:58 +0530
X-Gm-Features: AclHuK9S-yUl0Qqf07TUN79vtCcxM0kHlsWIQ4CIm-7gE7zBj_4ZMYR_-IqEGGY
Message-ID: <CALxtO0=w3jafDBj1gvoAZxcM8tRM0WRAiv-vc8c4+AjSmnOe8w@mail.gmail.com>
Subject: Re: [PATCH] crypto: aes - Add import_core/export_core to cmac/xcbc/cbcmac
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
   I applied this patch on top of cryptodev-2.6/master and ran the
crypto self-tests (CONFIG_CRYPTO_SELFTESTS=3Dy,
CONFIG_CRYPTO_SELFTESTS_FULL=3Dy) with the SPAcc driver. cmac(aes) and
xcbc(aes) now allocate their software fallback and pass all
self-tests, with no regressions on the other SPAcc hash/HMAC
algorithms.
I will push the SPAcc v26 patches. Please suggest otherwise.

Tested-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

Warm Regards,
PK
Vayavya Labs Pvt. Ltd.

On Mon, Oct 12, 2026 at 4:11=E2=80=AFPM Pavitrakumar Managutte
<pavitrakumarm@vayavyalabs.com> wrote:
>
> Hi Herbert,
>   I tested your patch with the SPAcc driver, all cmac(aes)/xcbc(aes)
> tests pass.
>
> Warm regards,
> PK
> Vayavya Labs Pvt. Ltd.
>
> On Fri, Oct 9, 2026 at 5:16=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
> >
> > The export format for cmac-aes-lib, xcbc-aes-lib and cbcmac-aes-lib
> > did not match that of the generic templates.  Add custom export and
> > import functions to align with the generic tempaltes.
> >
> > For cmac and xcbc, perform an extra encryption on the withheld block
> > for export_core so that the information isn't lost.
> >
> > Reported-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >
> > diff --git a/crypto/aes.c b/crypto/aes.c
> > index 94791f481e98..a1af4d5a7608 100644
> > --- a/crypto/aes.c
> > +++ b/crypto/aes.c
> > @@ -18,7 +18,10 @@
> >  #include <crypto/internal/hash.h>
> >  #include <crypto/internal/skcipher.h>
> >  #include <crypto/scatterwalk.h>
> > +#include <crypto/utils.h>
> > +#include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/string.h>
> >
> >  static_assert(__alignof__(struct aes_key) <=3D CRYPTO_MINALIGN);
> >  static_assert(__alignof__(struct aes_enckey) <=3D CRYPTO_MINALIGN);
> > @@ -95,6 +98,71 @@ static int __maybe_unused crypto_aes_cmac_digest(str=
uct shash_desc *desc,
> >         return 0;
> >  }
> >
> > +static int crypto_cmac_export_core(struct shash_desc *desc, void *out)
> > +{
> > +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> > +       struct aes_cmac_ctx ctx1;
> > +       u8 *h =3D ctx->h;
> > +
> > +       if (!ctx->partial_len)
> > +               ;
> > +       else if (ctx->partial_len !=3D AES_BLOCK_SIZE)
> > +               return -EINVAL;
> > +       else {
> > +               union {
> > +                       long l;
> > +                       char c;
> > +               } u =3D {};
> > +
> > +               BUILD_BUG_ON(sizeof(u) >=3D AES_BLOCK_SIZE);
> > +               ctx1 =3D *ctx;
> > +               aes_cmac_update(&ctx1, &u.c, sizeof(u));
> > +               h =3D ctx1.h;
> > +       }
> > +
> > +       memcpy(out, h, AES_BLOCK_SIZE);
> > +       memzero_explicit(&ctx1, sizeof(ctx1));
> > +       return 0;
> > +}
> > +
> > +static int crypto_cmac_import_core(struct shash_desc *desc, const void=
 *in)
> > +{
> > +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> > +
> > +       ctx->key =3D AES_CMAC_KEY(desc->tfm);
> > +       memcpy(ctx->h, in, AES_BLOCK_SIZE);
> > +       ctx->partial_len =3D 0;
> > +       return 0;
> > +}
> > +
> > +static int crypto_cmac_export(struct shash_desc *desc, void *out)
> > +{
> > +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> > +       unsigned int partial =3D ctx->partial_len;
> > +       u8 *p =3D out;
> > +
> > +       memcpy(p, ctx->h, AES_BLOCK_SIZE);
> > +       memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
> > +       p[AES_BLOCK_SIZE * 2] =3D partial;
> > +       return 0;
> > +}
> > +
> > +static int crypto_cmac_import(struct shash_desc *desc, const void *in)
> > +{
> > +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> > +       unsigned int partial;
> > +       const u8 *p =3D in;
> > +
> > +       crypto_cmac_import_core(desc, p);
> > +       p +=3D AES_BLOCK_SIZE;
> > +       partial =3D p[AES_BLOCK_SIZE];
> > +       if (partial > AES_BLOCK_SIZE)
> > +               return -EOVERFLOW;
> > +       crypto_xor(ctx->h, p, partial);
> > +       ctx->partial_len =3D partial;
> > +       return 0;
> > +}
> > +
> >  #define AES_CBCMAC_KEY(tfm) ((struct aes_enckey *)crypto_shash_ctx(tfm=
))
> >  #define AES_CBCMAC_CTX(desc) ((struct aes_cbcmac_ctx *)shash_desc_ctx(=
desc))
> >
> > @@ -136,6 +204,49 @@ static int __maybe_unused crypto_aes_cbcmac_digest=
(struct shash_desc *desc,
> >         return 0;
> >  }
> >
> > +static int crypto_cbcmac_export_core(struct shash_desc *desc, void *ou=
t)
> > +{
> > +       memcpy(out, AES_CBCMAC_CTX(desc)->h, AES_BLOCK_SIZE);
> > +       return 0;
> > +}
> > +
> > +static int crypto_cbcmac_import_core(struct shash_desc *desc, const vo=
id *in)
> > +{
> > +       struct aes_cbcmac_ctx *ctx =3D AES_CBCMAC_CTX(desc);
> > +
> > +       ctx->key =3D AES_CBCMAC_KEY(desc->tfm);
> > +       memcpy(ctx->h, in, AES_BLOCK_SIZE);
> > +       ctx->partial_len =3D 0;
> > +       return 0;
> > +}
> > +
> > +static int crypto_cbcmac_export(struct shash_desc *desc, void *out)
> > +{
> > +       struct aes_cbcmac_ctx *ctx =3D AES_CBCMAC_CTX(desc);
> > +       unsigned int partial =3D ctx->partial_len;
> > +       u8 *p =3D out;
> > +
> > +       memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
> > +       p[AES_BLOCK_SIZE * 2] =3D partial;
> > +       return crypto_cbcmac_export_core(desc, p);
> > +}
> > +
> > +static int crypto_cbcmac_import(struct shash_desc *desc, const void *i=
n)
> > +{
> > +       struct aes_cbcmac_ctx *ctx =3D AES_CBCMAC_CTX(desc);
> > +       unsigned int partial;
> > +       const u8 *p =3D in;
> > +
> > +       crypto_cbcmac_import_core(desc, p);
> > +       p +=3D AES_BLOCK_SIZE;
> > +       partial =3D p[AES_BLOCK_SIZE];
> > +       if (partial > AES_BLOCK_SIZE)
> > +               return -EOVERFLOW;
> > +       crypto_xor(ctx->h, p, partial);
> > +       ctx->partial_len =3D partial;
> > +       return 0;
> > +}
> > +
> >  static struct crypto_alg alg =3D {
> >         .cra_name =3D "aes",
> >         .cra_driver_name =3D "aes-lib",
> > @@ -166,7 +277,12 @@ static struct shash_alg mac_algs[] =3D {
> >                 .update =3D crypto_aes_cmac_update,
> >                 .final =3D crypto_aes_cmac_final,
> >                 .digest =3D crypto_aes_cmac_digest,
> > +               .export =3D crypto_cmac_export,
> > +               .import =3D crypto_cmac_import,
> > +               .export_core =3D crypto_cmac_export_core,
> > +               .import_core =3D crypto_cmac_import_core,
> >                 .descsize =3D sizeof(struct aes_cmac_ctx),
> > +               .statesize =3D AES_BLOCK_SIZE * 2 + 1,
> >         },
> >  #endif
> >  #if IS_ENABLED(CONFIG_CRYPTO_XCBC)
> > @@ -187,7 +303,12 @@ static struct shash_alg mac_algs[] =3D {
> >                 .update =3D crypto_aes_cmac_update,
> >                 .final =3D crypto_aes_cmac_final,
> >                 .digest =3D crypto_aes_cmac_digest,
> > +               .export =3D crypto_cmac_export,
> > +               .import =3D crypto_cmac_import,
> > +               .export_core =3D crypto_cmac_export_core,
> > +               .import_core =3D crypto_cmac_import_core,
> >                 .descsize =3D sizeof(struct aes_cmac_ctx),
> > +               .statesize =3D AES_BLOCK_SIZE * 2 + 1,
> >         },
> >  #endif
> >  #if IS_ENABLED(CONFIG_CRYPTO_CCM)
> > @@ -204,7 +325,12 @@ static struct shash_alg mac_algs[] =3D {
> >                 .update =3D crypto_aes_cbcmac_update,
> >                 .final =3D crypto_aes_cbcmac_final,
> >                 .digest =3D crypto_aes_cbcmac_digest,
> > +               .export =3D crypto_cbcmac_export,
> > +               .import =3D crypto_cbcmac_import,
> > +               .export_core =3D crypto_cbcmac_export_core,
> > +               .import_core =3D crypto_cbcmac_import_core,
> >                 .descsize =3D sizeof(struct aes_cbcmac_ctx),
> > +               .statesize =3D AES_BLOCK_SIZE * 2 + 1,
> >         },
> >  #endif
> >  };
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

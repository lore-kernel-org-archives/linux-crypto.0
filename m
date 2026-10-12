Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE6282F2C
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 10:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801682; cv=pass; b=eON79+teD51cbUOuj/SnaFBY6ZLNuhxon5VmSzfntOm8P3H5xo0Yb/NbdUa2S9hJanGkRnN13dydPSSMXE0sGWmTKRigiKb9rpXtFHWUuiwbFjqcrbuoOjh7codPgokSalMjXNOn7yQu1W/77ZJg/M1N4Lj2pVsW/xr3JKggFpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801682; c=relaxed/simple;
	bh=dyDkbf4tApIKHMRKlGvnnSGRaFxM/EK5HXOveYssYfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K7aSmh5uRKQoTcLbl78IROpt1K0PWXo8puY+YE/uFNDmecxgwnpY/TqHKwzHKjbkkD8E+V5swAGk04vqdvdPobtKr+g2VRdOWBAizLkGYdj6r+UBuBv7ahkr6Y9VBZA+3ArtFxybe6uwkuh475Ls4WN8IHvfy5EnBSgiTbySsUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=HrGbP5hZ; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="HrGbP5hZ"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-533952f3714so21447001cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 03:41:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791801679; cv=none;
        d=google.com; s=arc-20260327;
        b=gZ9ml6flwKgncvblRIzPgFY8kAMMQ1/9u2t3BFJm8+AyjozJEN99nZrvCqnPzce+aJ
         hYQBzqPq29eiW0Kh6dV2BxbQT1LlkKlMzA9Ns3gHqIKKAiWMU0Ehlz3qZLSmJAhuSHb5
         Sn3dVHvk+qoI7++5mRmGK0YjRowIII6mm9U7iz0eKAGXaIggjH4SxcieVcs/6fGAUJ5Y
         aNxVFmwY3bH8vfsViyBelo1LvCUS6PSxwYo+w982rxCXG1cPNGqiyCKvboCKR4ng5yby
         /tlUHfufvvd82ey/ISWwQcfRkGpkom5/54Ozbia1KMzcXCv44ihKEAVByUjYqVnkOJy9
         M5Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+xFSB7mA2/iOIBu3KdFK8kWp09+Xthh/N0K4ju2p7Ws=;
        fh=OUpgHz8gu+EFyREjScBnwgXxe9p5hHef04jJGlkpTWE=;
        b=iY4fLAchC2Z5/3b/ZqPnoXQsD0FusE3F1af0tsVjWUdbQD8ZghzI9JLd2Ec+VWg1vj
         R7jbOCbuRRj66auAByUGy46xL+NFCvVNboVdIRufznpLxdsBcHsA72JW/qmVE1LBvcII
         r+pdo5HsMsru8/VQTMe2LYdgKyUPUYkVTeJ+yAM1okXS0YxoutbsuGNuVpkzn01W1197
         c00L7re2zsdKFxGGxcEZcrWcdk1iHFIfRfwnHtVMygWepRzqgec3lrpF0Zg3yt0iFM/l
         +DPC/64Zp6JasnHsOxs/p0sewXBcQNhpHgvayKnWtimjKBhRB4WPF5b8/eUrgGw9wxJV
         cjww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1791801679; x=1792406479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+xFSB7mA2/iOIBu3KdFK8kWp09+Xthh/N0K4ju2p7Ws=;
        b=HrGbP5hZ/G46ouL8oj7u0tHoLw2an39QOYARSRAFQtxF+cLWftZw6hl/6oA4OvTu+z
         hAJAP4WS1RnL3Ww4Aa6OTH6iPU6fc95UXnIRqX/FgA+F5EXoyMc6pUOJ+PU9vjDj3w2r
         sQE7oQRdrX0VzWOJBQUSoE2esmlABvdPtMZlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791801679; x=1792406479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+xFSB7mA2/iOIBu3KdFK8kWp09+Xthh/N0K4ju2p7Ws=;
        b=HZFKlm4HTCVfVYy63P5wLSzCaHsiW3Ttl28ioQKiQiyZ5eun2QP/Q99KR4+H2SIhPe
         j0iyrpb5qkGHstOYtQjkUYsB/QrS483XuqGQgExBXxQTashMkB3M08bV+yxoovjMmfYi
         xwpPVleIT0/FLj9bm8PYDxDNyBW3pwft0JiHvzP2g1yvqd2wrSIOYHLM+ZBsAKBlYEoB
         FysIo63NLeQmWK6lKj81u/eH0JuMoMa7wsNGPFAcPxsbls/+XuAQFXCvwQ3VV6kWJbjM
         zfDBpFa0YZc/K10wCaNAkrXIiePmF4czY/ixScIdUdW/MAx0ty0n87wc0gYeeN+6fxLd
         lWRA==
X-Gm-Message-State: AFq9FYKQ9fN79K9F05U0Doa2pRijVnKU5PwwRve95AeYBegVP+PJsg30
	zdqe7+SipFKGVvfXXqOjS8H2sP2aKr9m2VQHlVwGpcHi6rus2UTutGA028a5KYCdmbq19jxhbW4
	6pVDzSzPZtCGRdB+WzvpFzppGXBrWCPXi+sWKK9r1jE58YsOui9/ArVw=
X-Gm-Gg: AYBFou3oWj9ku+NONYrR6ENJXfCizZ/0Is5fSSC0IMlNFZH0m9GaaS1HD5OwvTeOaK6
	SrDVBToxfK/ura+Xo0QzMRSZlDPXjC70an5uBfOkEg/nHHFmry5ASakmCgio0fKEA8dT96Ulvpm
	JPss5J14EoErAVwYtD1vW4slxTI3ef8G3puuDT7Jue7uADdcrpHwKc88mKmU0n92+SHJ4DKUA+Y
	hgbIqL6+N5wQOF+f35lLJGQmDvAhFjxt+N1mGuw6FWMqSjP6zrrGD78lBBKKv/1kgsqu+Jv8cYA
	4kVQx65GIJ+KHeryrtA1flqpCE70XfiIU+MUkhkpp8bXsngA9wQ4HdlMIQJnq8yDJizwyDTaR9D
	dMc4yTtByw5vh/dyJ7FAUqxGiNRVXUm4ql0EZbHYGohyjlSjM4ZUvYEm4ScYezC5FhIQrIG0Dwq
	DvfSwA8Od1wfNvKY5NkawAa4O7t1rbsqY=
X-Received: by 2002:a05:622a:1817:b0:533:3572:250f with SMTP id
 d75a77b69052e-5359fb4a7c8mr155431001cf.36.1791801679512; Mon, 12 Oct 2026
 03:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <asjT87HAZ_UUbbvm@gondor.apana.org.au>
In-Reply-To: <asjT87HAZ_UUbbvm@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Mon, 12 Oct 2026 16:11:08 +0530
X-Gm-Features: AclHuK9TX0ZvyDYt4B9H_Or25_gOyM2rCIhlKNdH80-m2I3Y0cpw-XgVaFFUNuw
Message-ID: <CALxtO0=TXw68akF3AFPT0=J4tZ2XV+G5kuTOELGBzhbgBdN0RA@mail.gmail.com>
Subject: Re: [PATCH] crypto: aes - Add import_core/export_core to cmac/xcbc/cbcmac
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
  I tested your patch with the SPAcc driver, all cmac(aes)/xcbc(aes)
tests pass.

Warm regards,
PK
Vayavya Labs Pvt. Ltd.

On Fri, Oct 9, 2026 at 5:16=E2=80=AFPM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> The export format for cmac-aes-lib, xcbc-aes-lib and cbcmac-aes-lib
> did not match that of the generic templates.  Add custom export and
> import functions to align with the generic tempaltes.
>
> For cmac and xcbc, perform an extra encryption on the withheld block
> for export_core so that the information isn't lost.
>
> Reported-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/aes.c b/crypto/aes.c
> index 94791f481e98..a1af4d5a7608 100644
> --- a/crypto/aes.c
> +++ b/crypto/aes.c
> @@ -18,7 +18,10 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
> +#include <crypto/utils.h>
> +#include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/string.h>
>
>  static_assert(__alignof__(struct aes_key) <=3D CRYPTO_MINALIGN);
>  static_assert(__alignof__(struct aes_enckey) <=3D CRYPTO_MINALIGN);
> @@ -95,6 +98,71 @@ static int __maybe_unused crypto_aes_cmac_digest(struc=
t shash_desc *desc,
>         return 0;
>  }
>
> +static int crypto_cmac_export_core(struct shash_desc *desc, void *out)
> +{
> +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> +       struct aes_cmac_ctx ctx1;
> +       u8 *h =3D ctx->h;
> +
> +       if (!ctx->partial_len)
> +               ;
> +       else if (ctx->partial_len !=3D AES_BLOCK_SIZE)
> +               return -EINVAL;
> +       else {
> +               union {
> +                       long l;
> +                       char c;
> +               } u =3D {};
> +
> +               BUILD_BUG_ON(sizeof(u) >=3D AES_BLOCK_SIZE);
> +               ctx1 =3D *ctx;
> +               aes_cmac_update(&ctx1, &u.c, sizeof(u));
> +               h =3D ctx1.h;
> +       }
> +
> +       memcpy(out, h, AES_BLOCK_SIZE);
> +       memzero_explicit(&ctx1, sizeof(ctx1));
> +       return 0;
> +}
> +
> +static int crypto_cmac_import_core(struct shash_desc *desc, const void *=
in)
> +{
> +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> +
> +       ctx->key =3D AES_CMAC_KEY(desc->tfm);
> +       memcpy(ctx->h, in, AES_BLOCK_SIZE);
> +       ctx->partial_len =3D 0;
> +       return 0;
> +}
> +
> +static int crypto_cmac_export(struct shash_desc *desc, void *out)
> +{
> +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> +       unsigned int partial =3D ctx->partial_len;
> +       u8 *p =3D out;
> +
> +       memcpy(p, ctx->h, AES_BLOCK_SIZE);
> +       memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
> +       p[AES_BLOCK_SIZE * 2] =3D partial;
> +       return 0;
> +}
> +
> +static int crypto_cmac_import(struct shash_desc *desc, const void *in)
> +{
> +       struct aes_cmac_ctx *ctx =3D AES_CMAC_CTX(desc);
> +       unsigned int partial;
> +       const u8 *p =3D in;
> +
> +       crypto_cmac_import_core(desc, p);
> +       p +=3D AES_BLOCK_SIZE;
> +       partial =3D p[AES_BLOCK_SIZE];
> +       if (partial > AES_BLOCK_SIZE)
> +               return -EOVERFLOW;
> +       crypto_xor(ctx->h, p, partial);
> +       ctx->partial_len =3D partial;
> +       return 0;
> +}
> +
>  #define AES_CBCMAC_KEY(tfm) ((struct aes_enckey *)crypto_shash_ctx(tfm))
>  #define AES_CBCMAC_CTX(desc) ((struct aes_cbcmac_ctx *)shash_desc_ctx(de=
sc))
>
> @@ -136,6 +204,49 @@ static int __maybe_unused crypto_aes_cbcmac_digest(s=
truct shash_desc *desc,
>         return 0;
>  }
>
> +static int crypto_cbcmac_export_core(struct shash_desc *desc, void *out)
> +{
> +       memcpy(out, AES_CBCMAC_CTX(desc)->h, AES_BLOCK_SIZE);
> +       return 0;
> +}
> +
> +static int crypto_cbcmac_import_core(struct shash_desc *desc, const void=
 *in)
> +{
> +       struct aes_cbcmac_ctx *ctx =3D AES_CBCMAC_CTX(desc);
> +
> +       ctx->key =3D AES_CBCMAC_KEY(desc->tfm);
> +       memcpy(ctx->h, in, AES_BLOCK_SIZE);
> +       ctx->partial_len =3D 0;
> +       return 0;
> +}
> +
> +static int crypto_cbcmac_export(struct shash_desc *desc, void *out)
> +{
> +       struct aes_cbcmac_ctx *ctx =3D AES_CBCMAC_CTX(desc);
> +       unsigned int partial =3D ctx->partial_len;
> +       u8 *p =3D out;
> +
> +       memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
> +       p[AES_BLOCK_SIZE * 2] =3D partial;
> +       return crypto_cbcmac_export_core(desc, p);
> +}
> +
> +static int crypto_cbcmac_import(struct shash_desc *desc, const void *in)
> +{
> +       struct aes_cbcmac_ctx *ctx =3D AES_CBCMAC_CTX(desc);
> +       unsigned int partial;
> +       const u8 *p =3D in;
> +
> +       crypto_cbcmac_import_core(desc, p);
> +       p +=3D AES_BLOCK_SIZE;
> +       partial =3D p[AES_BLOCK_SIZE];
> +       if (partial > AES_BLOCK_SIZE)
> +               return -EOVERFLOW;
> +       crypto_xor(ctx->h, p, partial);
> +       ctx->partial_len =3D partial;
> +       return 0;
> +}
> +
>  static struct crypto_alg alg =3D {
>         .cra_name =3D "aes",
>         .cra_driver_name =3D "aes-lib",
> @@ -166,7 +277,12 @@ static struct shash_alg mac_algs[] =3D {
>                 .update =3D crypto_aes_cmac_update,
>                 .final =3D crypto_aes_cmac_final,
>                 .digest =3D crypto_aes_cmac_digest,
> +               .export =3D crypto_cmac_export,
> +               .import =3D crypto_cmac_import,
> +               .export_core =3D crypto_cmac_export_core,
> +               .import_core =3D crypto_cmac_import_core,
>                 .descsize =3D sizeof(struct aes_cmac_ctx),
> +               .statesize =3D AES_BLOCK_SIZE * 2 + 1,
>         },
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_XCBC)
> @@ -187,7 +303,12 @@ static struct shash_alg mac_algs[] =3D {
>                 .update =3D crypto_aes_cmac_update,
>                 .final =3D crypto_aes_cmac_final,
>                 .digest =3D crypto_aes_cmac_digest,
> +               .export =3D crypto_cmac_export,
> +               .import =3D crypto_cmac_import,
> +               .export_core =3D crypto_cmac_export_core,
> +               .import_core =3D crypto_cmac_import_core,
>                 .descsize =3D sizeof(struct aes_cmac_ctx),
> +               .statesize =3D AES_BLOCK_SIZE * 2 + 1,
>         },
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_CCM)
> @@ -204,7 +325,12 @@ static struct shash_alg mac_algs[] =3D {
>                 .update =3D crypto_aes_cbcmac_update,
>                 .final =3D crypto_aes_cbcmac_final,
>                 .digest =3D crypto_aes_cbcmac_digest,
> +               .export =3D crypto_cbcmac_export,
> +               .import =3D crypto_cbcmac_import,
> +               .export_core =3D crypto_cbcmac_export_core,
> +               .import_core =3D crypto_cbcmac_import_core,
>                 .descsize =3D sizeof(struct aes_cbcmac_ctx),
> +               .statesize =3D AES_BLOCK_SIZE * 2 + 1,
>         },
>  #endif
>  };
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7CCC2D0A3
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 08:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E6D20870
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 08:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBJWadkv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgKLISh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 03:18:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgKLISh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 03:18:37 -0500
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D26A20870
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2020 08:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605169115;
        bh=0EOhYq+56EEI0pr9m52km2wCXAC/I+CXG5ykLnCxyVI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OBJWadkvkVft+ahubF/PkJGWxoJImkFDxZhs/pdEePpFtMsl9BVs0z5KVqECbX/qv
         /3sUntKbuc+rO7hh8Qd8BrH+tpTw+AGCDjxGCK6Q8K8XiyjxmZgHZa43aOZ2C1kEQ+
         KY4R+H+o/VdGqHAXRp0tpORQNPoo8XRx6bP2iOus=
Received: by mail-oo1-f49.google.com with SMTP id t10so1106907oon.4
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2020 00:18:35 -0800 (PST)
X-Gm-Message-State: AOAM531pa1iYMHCQrvORvXAYrxuUAFVWGplRwMzymnFfcMv5iNxuoug+
        qRSoJjlvASmTVbVMmgxgebG93SKtE19x/1UkqnA=
X-Google-Smtp-Source: ABdhPJwj7tyksthUahjHktvYIYu4Z1ZnAFlhsqhCHr9xBtWVebdqssxnl+hAmcgYkMaZQl41EPLzMC6c0/jIn6Bw2tA=
X-Received: by 2002:a4a:9806:: with SMTP id y6mr20166280ooi.45.1605169114343;
 Thu, 12 Nov 2020 00:18:34 -0800 (PST)
MIME-Version: 1.0
References: <20201110190444.10634-1-ardb@kernel.org> <20201110190444.10634-5-ardb@kernel.org>
 <CAAUqJDtoGY+KJZsPjKWO7M6e9yrySqHEYaaYYdcS3Gz7WudS1A@mail.gmail.com>
In-Reply-To: <CAAUqJDtoGY+KJZsPjKWO7M6e9yrySqHEYaaYYdcS3Gz7WudS1A@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 12 Nov 2020 09:18:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGtWAcNWghds9qOy=+r8mEXevf3ypLezvY4iwSaTGWMtg@mail.gmail.com>
Message-ID: <CAMj1kXGtWAcNWghds9qOy=+r8mEXevf3ypLezvY4iwSaTGWMtg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] crypto: aegis128 - expose SIMD code path as
 separate driver
To:     =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 11 Nov 2020 at 18:46, Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.co=
m> wrote:
>
> ut 10. 11. 2020 o 20:04 Ard Biesheuvel <ardb@kernel.org> nap=C3=ADsal(a):
> > Wiring the SIMD code into the generic driver has the unfortunate side
> > effect that the tcrypt testing code cannot distinguish them, and will
> > therefore not use the latter to fuzz test the former, as it does for
> > other algorithms.
>
> Looking back at cf3d41adcc35 ("crypto: aegis128 - add support for SIMD
> acceleration"), I see that that there are aegis128_do_simd()
> conditionals also in the generic block update functions, so the
> "generic" variant is really only "half" generic. But maybe that
> doesn't really matter for the fuzzing, since the code paths are
> significantly different anyway...
>

Thanks for pointing that out. I think we should be pedantic here, and
ensure that the generic code never takes the SIMD code path.

> >
> > So let's refactor the code a bit so we can register two implementations=
:
> > aegis128-generic and aegis128-simd.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/aegis128-core.c | 176 +++++++++++++-------
> >  1 file changed, 119 insertions(+), 57 deletions(-)
> >
> > diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
> > index 859c7b905618..19f38e8c1627 100644
> > --- a/crypto/aegis128-core.c
> > +++ b/crypto/aegis128-core.c
> [...]
> > @@ -482,42 +457,128 @@ static int crypto_aegis128_decrypt(struct aead_r=
equest *req)
> >         return 0;
> >  }
> >
> > -static struct aead_alg crypto_aegis128_alg =3D {
> > -       .setkey =3D crypto_aegis128_setkey,
> > -       .setauthsize =3D crypto_aegis128_setauthsize,
> > -       .encrypt =3D crypto_aegis128_encrypt,
> > -       .decrypt =3D crypto_aegis128_decrypt,
> > +static int crypto_aegis128_encrypt_simd(struct aead_request *req)
> > +{
> > +       struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> > +       union aegis_block tag =3D {};
> > +       unsigned int authsize =3D crypto_aead_authsize(tfm);
> > +       struct aegis_ctx *ctx =3D crypto_aead_ctx(tfm);
> > +       unsigned int cryptlen =3D req->cryptlen;
> > +       struct skcipher_walk walk;
> > +       struct aegis_state state;
> >
> > -       .ivsize =3D AEGIS128_NONCE_SIZE,
> > -       .maxauthsize =3D AEGIS128_MAX_AUTH_SIZE,
> > -       .chunksize =3D AEGIS_BLOCK_SIZE,
> > +       if (!aegis128_do_simd())
> > +               return crypto_aegis128_encrypt_generic(req);
> >
> > -       .base =3D {
> > -               .cra_blocksize =3D 1,
> > -               .cra_ctxsize =3D sizeof(struct aegis_ctx),
> > -               .cra_alignmask =3D 0,
> > +       skcipher_walk_aead_encrypt(&walk, req, false);
> > +       crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
> > +       crypto_aegis128_process_ad(&state, req->src, req->assoclen);
> > +       crypto_aegis128_process_crypt(&state, &walk,
> > +                                     crypto_aegis128_encrypt_chunk_sim=
d);
> > +       crypto_aegis128_final_simd(&state, &tag, req->assoclen, cryptle=
n, 0);
> >
> > -               .cra_priority =3D 100,
> > +       scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + c=
ryptlen,
> > +                                authsize, 1);
> > +       return 0;
> > +}
> >
> > -               .cra_name =3D "aegis128",
> > -               .cra_driver_name =3D "aegis128-generic",
> > +static int crypto_aegis128_decrypt_simd(struct aead_request *req)
> > +{
> > +       struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> > +       union aegis_block tag;
> > +       unsigned int authsize =3D crypto_aead_authsize(tfm);
> > +       unsigned int cryptlen =3D req->cryptlen - authsize;
> > +       struct aegis_ctx *ctx =3D crypto_aead_ctx(tfm);
> > +       struct skcipher_walk walk;
> > +       struct aegis_state state;
> > +
> > +       if (!aegis128_do_simd())
> > +               return crypto_aegis128_decrypt_generic(req);
> > +
> > +       scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + c=
ryptlen,
> > +                                authsize, 0);
> > +
> > +       skcipher_walk_aead_decrypt(&walk, req, false);
> > +       crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
> > +       crypto_aegis128_process_ad(&state, req->src, req->assoclen);
> > +       crypto_aegis128_process_crypt(&state, &walk,
> > +                                     crypto_aegis128_decrypt_chunk_sim=
d);
> >
> > -               .cra_module =3D THIS_MODULE,
> > +       if (unlikely(crypto_aegis128_final_simd(&state, &tag, req->asso=
clen,
> > +                                               cryptlen, authsize))) {
> > +               skcipher_walk_aead_decrypt(&walk, req, false);
> > +               crypto_aegis128_process_crypt(NULL, &walk,
> > +                                             crypto_aegis128_wipe_chun=
k);
> > +               return -EBADMSG;
> >         }
> > +       return 0;
> > +}
> > +
> > +static struct aead_alg crypto_aegis128_alg_generic =3D {
> > +       .setkey                 =3D crypto_aegis128_setkey,
> > +       .setauthsize            =3D crypto_aegis128_setauthsize,
> > +       .encrypt                =3D crypto_aegis128_encrypt_generic,
> > +       .decrypt                =3D crypto_aegis128_decrypt_generic,
> > +
> > +       .ivsize                 =3D AEGIS128_NONCE_SIZE,
> > +       .maxauthsize            =3D AEGIS128_MAX_AUTH_SIZE,
> > +       .chunksize              =3D AEGIS_BLOCK_SIZE,
> > +
> > +       .base.cra_blocksize     =3D 1,
> > +       .base.cra_ctxsize       =3D sizeof(struct aegis_ctx),
> > +       .base.cra_alignmask     =3D 0,
> > +       .base.cra_priority      =3D 100,
> > +       .base.cra_name          =3D "aegis128",
> > +       .base.cra_driver_name   =3D "aegis128-generic",
> > +};
> > +
> > +static struct aead_alg crypto_aegis128_alg_simd =3D {
> > +       .base.cra_module        =3D THIS_MODULE,
>
> This line is listed twice for "crypto_aegis128_alg_simd", but it's
> missing for "crypto_aegis128_alg_generic" - I think you meant to put
> this one three lines higher.
>

Oops. Will fix.

> > +       .setkey                 =3D crypto_aegis128_setkey,
> > +       .setauthsize            =3D crypto_aegis128_setauthsize,
> > +       .encrypt                =3D crypto_aegis128_encrypt_simd,
> > +       .decrypt                =3D crypto_aegis128_decrypt_simd,
> > +
> > +       .ivsize                 =3D AEGIS128_NONCE_SIZE,
> > +       .maxauthsize            =3D AEGIS128_MAX_AUTH_SIZE,
> > +       .chunksize              =3D AEGIS_BLOCK_SIZE,
> > +
> > +       .base.cra_blocksize     =3D 1,
> > +       .base.cra_ctxsize       =3D sizeof(struct aegis_ctx),
> > +       .base.cra_alignmask     =3D 0,
> > +       .base.cra_priority      =3D 200,
> > +       .base.cra_name          =3D "aegis128",
> > +       .base.cra_driver_name   =3D "aegis128-simd",
> > +       .base.cra_module        =3D THIS_MODULE,
> >  };
> >
> >  static int __init crypto_aegis128_module_init(void)
> >  {
> > +       int ret;
> > +
> > +       ret =3D crypto_register_aead(&crypto_aegis128_alg_generic);
> > +       if (ret)
> > +               return ret;
> > +
> >         if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
> > -           crypto_aegis128_have_simd())
> > +           crypto_aegis128_have_simd()) {
> > +               ret =3D crypto_register_aead(&crypto_aegis128_alg_simd)=
;
> > +               if (ret) {
> > +                       crypto_unregister_aead(&crypto_aegis128_alg_gen=
eric);
> > +                       return ret;
> > +               }
> >                 static_branch_enable(&have_simd);
> > -
> > -       return crypto_register_aead(&crypto_aegis128_alg);
> > +       }
> > +       return 0;
> >  }
> >
> >  static void __exit crypto_aegis128_module_exit(void)
> >  {
> > -       crypto_unregister_aead(&crypto_aegis128_alg);
> > +       if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
> > +           crypto_aegis128_have_simd())
> > +               crypto_unregister_aead(&crypto_aegis128_alg_simd);
> > +
> > +       crypto_unregister_aead(&crypto_aegis128_alg_generic);
> >  }
> >
> >  subsys_initcall(crypto_aegis128_module_init);
> > @@ -528,3 +589,4 @@ MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com=
>");
> >  MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm");
> >  MODULE_ALIAS_CRYPTO("aegis128");
> >  MODULE_ALIAS_CRYPTO("aegis128-generic");
> > +MODULE_ALIAS_CRYPTO("aegis128-simd");
> > --
> > 2.17.1
> >

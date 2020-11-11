Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5296BC4742C
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 17:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4BCE2072C
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 17:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tk70etYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKKRqX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Nov 2020 12:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgKKRqW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Nov 2020 12:46:22 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D166C0613D1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2020 09:46:22 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id i19so3881088ejx.9
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2020 09:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y0ZVbHQodAP27JegPzdY0bbBqnMlG/cPZE0bXN0WNEQ=;
        b=tk70etYzbxLGGdP+OWMSwW1bcAr+wjFdMY26yZJSklksyfmRbVowCIFgNy1NofEvr0
         LPQJJC72GLx24xEjr9mbsz5mrwl2esqfQrUeYKLLJ/fGE4mspkvwS3kZSgT2DL9q33w8
         RY2psjNta1iq1y4Upw1W3iw4sK4recFZZLckzpvpBncM45t5sTje1YPiVO2LWr33nh77
         ILrPPoGgfVINazzuijme1l9v18GawooyWuQ5neml7VMWZlW+NJgaVo9xNIe3AjjQ32rA
         xBAdgQQiMNPOukzGpHaZrWljM6Ol1sNFRH/mkJ8pAiM0COoMOiHKHgOxpXvGd3NM40PV
         QZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y0ZVbHQodAP27JegPzdY0bbBqnMlG/cPZE0bXN0WNEQ=;
        b=PxHAk1jWZzO0o3sdCEQtvKumbx51Ug/fQI9YilU6liadd/7LHg1xX5R1mtlfINYznN
         GDtfKuRvY6G/Kz8uuGA+EWJ77WlsV06wt+7kEc/Cl2IshdyN52xsgh45xMj2K19ksaJL
         gfv9tPsCBgjmOwx1aCYmB2pHwipHiIM9Xa1bRJO+LNDYYlJVzW0+NCXIT8HqTc3WTl8t
         Vyh1RRqvl/i6jdCBZhFRIluc2sL4FD/f4zkZrX9elLedNicuV2Z8P1Uhtr+Y10N2z/s+
         77XWsBJInIAucgaDS+or/FQUlK8xdQnYfTVqxLQzRVV/ngpUv+FEDAqKkTpvDpC2i/UV
         dFWA==
X-Gm-Message-State: AOAM531Jjeg2TKn1Rrqx5zUuHLFrAJ6ZiaQ12SN8YTuhwsHf+T7s1k5Y
        Kc6m5mSKV73P7jPXKrZwlQraKfwC6lcY/PbyIAI=
X-Google-Smtp-Source: ABdhPJy0v6iLhMdCMhQ5tL42QbJ7SuSQTD0oOg3Ksy/2KrBHaTgyjmzfjtiVpOlHrQiQLKWBsEQIlVRaoqcu+IShm/s=
X-Received: by 2002:a17:906:d20e:: with SMTP id w14mr25734723ejz.479.1605116781113;
 Wed, 11 Nov 2020 09:46:21 -0800 (PST)
MIME-Version: 1.0
References: <20201110190444.10634-1-ardb@kernel.org> <20201110190444.10634-5-ardb@kernel.org>
In-Reply-To: <20201110190444.10634-5-ardb@kernel.org>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 11 Nov 2020 18:46:10 +0100
Message-ID: <CAAUqJDtoGY+KJZsPjKWO7M6e9yrySqHEYaaYYdcS3Gz7WudS1A@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] crypto: aegis128 - expose SIMD code path as
 separate driver
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ut 10. 11. 2020 o 20:04 Ard Biesheuvel <ardb@kernel.org> nap=C3=ADsal(a):
> Wiring the SIMD code into the generic driver has the unfortunate side
> effect that the tcrypt testing code cannot distinguish them, and will
> therefore not use the latter to fuzz test the former, as it does for
> other algorithms.

Looking back at cf3d41adcc35 ("crypto: aegis128 - add support for SIMD
acceleration"), I see that that there are aegis128_do_simd()
conditionals also in the generic block update functions, so the
"generic" variant is really only "half" generic. But maybe that
doesn't really matter for the fuzzing, since the code paths are
significantly different anyway...

>
> So let's refactor the code a bit so we can register two implementations:
> aegis128-generic and aegis128-simd.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/aegis128-core.c | 176 +++++++++++++-------
>  1 file changed, 119 insertions(+), 57 deletions(-)
>
> diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
> index 859c7b905618..19f38e8c1627 100644
> --- a/crypto/aegis128-core.c
> +++ b/crypto/aegis128-core.c
[...]
> @@ -482,42 +457,128 @@ static int crypto_aegis128_decrypt(struct aead_req=
uest *req)
>         return 0;
>  }
>
> -static struct aead_alg crypto_aegis128_alg =3D {
> -       .setkey =3D crypto_aegis128_setkey,
> -       .setauthsize =3D crypto_aegis128_setauthsize,
> -       .encrypt =3D crypto_aegis128_encrypt,
> -       .decrypt =3D crypto_aegis128_decrypt,
> +static int crypto_aegis128_encrypt_simd(struct aead_request *req)
> +{
> +       struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> +       union aegis_block tag =3D {};
> +       unsigned int authsize =3D crypto_aead_authsize(tfm);
> +       struct aegis_ctx *ctx =3D crypto_aead_ctx(tfm);
> +       unsigned int cryptlen =3D req->cryptlen;
> +       struct skcipher_walk walk;
> +       struct aegis_state state;
>
> -       .ivsize =3D AEGIS128_NONCE_SIZE,
> -       .maxauthsize =3D AEGIS128_MAX_AUTH_SIZE,
> -       .chunksize =3D AEGIS_BLOCK_SIZE,
> +       if (!aegis128_do_simd())
> +               return crypto_aegis128_encrypt_generic(req);
>
> -       .base =3D {
> -               .cra_blocksize =3D 1,
> -               .cra_ctxsize =3D sizeof(struct aegis_ctx),
> -               .cra_alignmask =3D 0,
> +       skcipher_walk_aead_encrypt(&walk, req, false);
> +       crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
> +       crypto_aegis128_process_ad(&state, req->src, req->assoclen);
> +       crypto_aegis128_process_crypt(&state, &walk,
> +                                     crypto_aegis128_encrypt_chunk_simd)=
;
> +       crypto_aegis128_final_simd(&state, &tag, req->assoclen, cryptlen,=
 0);
>
> -               .cra_priority =3D 100,
> +       scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cry=
ptlen,
> +                                authsize, 1);
> +       return 0;
> +}
>
> -               .cra_name =3D "aegis128",
> -               .cra_driver_name =3D "aegis128-generic",
> +static int crypto_aegis128_decrypt_simd(struct aead_request *req)
> +{
> +       struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> +       union aegis_block tag;
> +       unsigned int authsize =3D crypto_aead_authsize(tfm);
> +       unsigned int cryptlen =3D req->cryptlen - authsize;
> +       struct aegis_ctx *ctx =3D crypto_aead_ctx(tfm);
> +       struct skcipher_walk walk;
> +       struct aegis_state state;
> +
> +       if (!aegis128_do_simd())
> +               return crypto_aegis128_decrypt_generic(req);
> +
> +       scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cry=
ptlen,
> +                                authsize, 0);
> +
> +       skcipher_walk_aead_decrypt(&walk, req, false);
> +       crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
> +       crypto_aegis128_process_ad(&state, req->src, req->assoclen);
> +       crypto_aegis128_process_crypt(&state, &walk,
> +                                     crypto_aegis128_decrypt_chunk_simd)=
;
>
> -               .cra_module =3D THIS_MODULE,
> +       if (unlikely(crypto_aegis128_final_simd(&state, &tag, req->assocl=
en,
> +                                               cryptlen, authsize))) {
> +               skcipher_walk_aead_decrypt(&walk, req, false);
> +               crypto_aegis128_process_crypt(NULL, &walk,
> +                                             crypto_aegis128_wipe_chunk)=
;
> +               return -EBADMSG;
>         }
> +       return 0;
> +}
> +
> +static struct aead_alg crypto_aegis128_alg_generic =3D {
> +       .setkey                 =3D crypto_aegis128_setkey,
> +       .setauthsize            =3D crypto_aegis128_setauthsize,
> +       .encrypt                =3D crypto_aegis128_encrypt_generic,
> +       .decrypt                =3D crypto_aegis128_decrypt_generic,
> +
> +       .ivsize                 =3D AEGIS128_NONCE_SIZE,
> +       .maxauthsize            =3D AEGIS128_MAX_AUTH_SIZE,
> +       .chunksize              =3D AEGIS_BLOCK_SIZE,
> +
> +       .base.cra_blocksize     =3D 1,
> +       .base.cra_ctxsize       =3D sizeof(struct aegis_ctx),
> +       .base.cra_alignmask     =3D 0,
> +       .base.cra_priority      =3D 100,
> +       .base.cra_name          =3D "aegis128",
> +       .base.cra_driver_name   =3D "aegis128-generic",
> +};
> +
> +static struct aead_alg crypto_aegis128_alg_simd =3D {
> +       .base.cra_module        =3D THIS_MODULE,

This line is listed twice for "crypto_aegis128_alg_simd", but it's
missing for "crypto_aegis128_alg_generic" - I think you meant to put
this one three lines higher.

> +       .setkey                 =3D crypto_aegis128_setkey,
> +       .setauthsize            =3D crypto_aegis128_setauthsize,
> +       .encrypt                =3D crypto_aegis128_encrypt_simd,
> +       .decrypt                =3D crypto_aegis128_decrypt_simd,
> +
> +       .ivsize                 =3D AEGIS128_NONCE_SIZE,
> +       .maxauthsize            =3D AEGIS128_MAX_AUTH_SIZE,
> +       .chunksize              =3D AEGIS_BLOCK_SIZE,
> +
> +       .base.cra_blocksize     =3D 1,
> +       .base.cra_ctxsize       =3D sizeof(struct aegis_ctx),
> +       .base.cra_alignmask     =3D 0,
> +       .base.cra_priority      =3D 200,
> +       .base.cra_name          =3D "aegis128",
> +       .base.cra_driver_name   =3D "aegis128-simd",
> +       .base.cra_module        =3D THIS_MODULE,
>  };
>
>  static int __init crypto_aegis128_module_init(void)
>  {
> +       int ret;
> +
> +       ret =3D crypto_register_aead(&crypto_aegis128_alg_generic);
> +       if (ret)
> +               return ret;
> +
>         if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
> -           crypto_aegis128_have_simd())
> +           crypto_aegis128_have_simd()) {
> +               ret =3D crypto_register_aead(&crypto_aegis128_alg_simd);
> +               if (ret) {
> +                       crypto_unregister_aead(&crypto_aegis128_alg_gener=
ic);
> +                       return ret;
> +               }
>                 static_branch_enable(&have_simd);
> -
> -       return crypto_register_aead(&crypto_aegis128_alg);
> +       }
> +       return 0;
>  }
>
>  static void __exit crypto_aegis128_module_exit(void)
>  {
> -       crypto_unregister_aead(&crypto_aegis128_alg);
> +       if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
> +           crypto_aegis128_have_simd())
> +               crypto_unregister_aead(&crypto_aegis128_alg_simd);
> +
> +       crypto_unregister_aead(&crypto_aegis128_alg_generic);
>  }
>
>  subsys_initcall(crypto_aegis128_module_init);
> @@ -528,3 +589,4 @@ MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>"=
);
>  MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm");
>  MODULE_ALIAS_CRYPTO("aegis128");
>  MODULE_ALIAS_CRYPTO("aegis128-generic");
> +MODULE_ALIAS_CRYPTO("aegis128-simd");
> --
> 2.17.1
>

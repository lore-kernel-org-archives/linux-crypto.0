From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH] crypto/morus(640,1280) - make crypto_...-algs static
Date: Thu, 27 Sep 2018 21:28:32 +0200
Message-ID: <CAAUqJDtaa-ABP9pRKPzG-qOSzFJShF7J8gZzDThi5Jrf87UAXA@mail.gmail.com>
References: <113445.1538002178@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: valdis.kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <113445.1538002178@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=C5=A1t 27. 9. 2018 o 0:50 <valdis.kletnieks@vt.edu> nap=C3=ADsal(a):
> sparse complains thusly:
>
>   CHECK   arch/x86/crypto/morus640-sse2-glue.c
> arch/x86/crypto/morus640-sse2-glue.c:38:1: warning: symbol 'crypto_morus6=
40_sse2_algs' was not declared. Should it be static?
>   CHECK   arch/x86/crypto/morus1280-sse2-glue.c
> arch/x86/crypto/morus1280-sse2-glue.c:38:1: warning: symbol 'crypto_morus=
1280_sse2_algs' was not declared. Should it be static?
>   CHECK   arch/x86/crypto/morus1280-avx2-glue.c
> arch/x86/crypto/morus1280-avx2-glue.c:38:1: warning: symbol 'crypto_morus=
1280_avx2_algs' was not declared. Should it be static?
>
> and sparse is correct - these don't need to be global and polluting the n=
amespace.
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Indeed, this should be fixed, thanks!

Acked-by: Ondrej Mosnacek <omosnacek@gmail.com>

> ---
> diff --git a/include/crypto/morus1280_glue.h b/include/crypto/morus1280_g=
lue.h
> index b26dd70efd9a..ba782e10065e 100644
> --- a/include/crypto/morus1280_glue.h
> +++ b/include/crypto/morus1280_glue.h
> @@ -82,7 +82,7 @@ void cryptd_morus1280_glue_exit_tfm(struct crypto_aead =
*aead);
>         { \
>         } \
>         \
> -       struct aead_alg crypto_morus1280_##id##_algs[] =3D {\
> +       static struct aead_alg crypto_morus1280_##id##_algs[] =3D {\
>                 { \
>                         .setkey =3D crypto_morus1280_glue_setkey, \
>                         .setauthsize =3D crypto_morus1280_glue_setauthsiz=
e, \
> diff --git a/include/crypto/morus640_glue.h b/include/crypto/morus640_glu=
e.h
> index 90c8db07e740..27fa790a2362 100644
> --- a/include/crypto/morus640_glue.h
> +++ b/include/crypto/morus640_glue.h
> @@ -82,7 +82,7 @@ void cryptd_morus640_glue_exit_tfm(struct crypto_aead *=
aead);
>         { \
>         } \
>         \
> -       struct aead_alg crypto_morus640_##id##_algs[] =3D {\
> +       static struct aead_alg crypto_morus640_##id##_algs[] =3D {\
>                 { \
>                         .setkey =3D crypto_morus640_glue_setkey, \
>                         .setauthsize =3D crypto_morus640_glue_setauthsize=
, \
>

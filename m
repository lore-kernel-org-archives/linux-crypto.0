From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: crypto: seqiv - Ensure that IV size is at least 8 bytes
Date: Fri, 16 Jan 2015 08:53:03 -0800
Message-ID: <CAHo-OoxgX1hP27jESZbJsO+8QicCtO_nAg7idunDqVkvWb9vow@mail.gmail.com>
References: <20150116085120.GA9863@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60274 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbbAPQxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2015 11:53:05 -0500
Received: by mail-lb0-f179.google.com with SMTP id z11so19423289lbi.10
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2015 08:53:04 -0800 (PST)
In-Reply-To: <20150116085120.GA9863@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 16, 2015 at 12:51 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Since seqiv is designed for IPsec we need to be able to accomodate
> the whole IPsec sequence number in order to ensure the uniqueness
> of the IV.
>
> This patch forbids any algorithm with an IV size of less than 8
> from using it.  This should have no impact on existing users since
> they all have an IV size of 8.
>
> Reported-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/seqiv.c b/crypto/seqiv.c
> index 9daa854c..b7bb9a2 100644
> --- a/crypto/seqiv.c
> +++ b/crypto/seqiv.c
> @@ -267,6 +267,12 @@ static struct crypto_instance *seqiv_ablkcipher_=
alloc(struct rtattr **tb)
>         if (IS_ERR(inst))
>                 goto out;
>
> +       if (inst->alg.cra_ablkcipher.ivsize < sizeof(u64)) {
> +               skcipher_geniv_free(inst);
> +               inst =3D ERR_PTR(-EINVAL);
> +               goto out;
> +       }
> +
>         inst->alg.cra_ablkcipher.givencrypt =3D seqiv_givencrypt_firs=
t;
>
>         inst->alg.cra_init =3D seqiv_init;
> @@ -287,6 +293,12 @@ static struct crypto_instance *seqiv_aead_alloc(=
struct rtattr **tb)
>         if (IS_ERR(inst))
>                 goto out;
>
> +       if (inst->alg.cra_aead.ivsize < sizeof(u64)) {
> +               aead_geniv_free(inst);
> +               inst =3D ERR_PTR(-EINVAL);
> +               goto out;
> +       }
> +
>         inst->alg.cra_aead.givencrypt =3D seqiv_aead_givencrypt_first=
;
>
>         inst->alg.cra_init =3D seqiv_aead_init;
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Acked-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>

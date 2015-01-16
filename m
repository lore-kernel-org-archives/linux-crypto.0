From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: crypto: cts - Remove bogus use of seqiv
Date: Fri, 16 Jan 2015 08:53:17 -0800
Message-ID: <CAHo-Ooxn2xPR+LAcRdqDE7SMaNXujAE8h8zb+j77+FmuUPvOLQ@mail.gmail.com>
References: <20150116070921.GA8992@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kevin Coffman <kwc@citi.umich.edu>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53461 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbbAPQxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2015 11:53:19 -0500
Received: by mail-lb0-f170.google.com with SMTP id 10so19448736lbg.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2015 08:53:17 -0800 (PST)
In-Reply-To: <20150116070921.GA8992@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 15, 2015 at 11:09 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> The seqiv generator is completely inappropriate for cts as it's
> designed for IPsec algorithms.  Since cts users do not actually
> use the IV generator we can just fall back to the default.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/cts.c b/crypto/cts.c
> index bd94058..6a8089c 100644
> --- a/crypto/cts.c
> +++ b/crypto/cts.c
> @@ -307,8 +307,6 @@ static struct crypto_instance *crypto_cts_alloc(s=
truct rtattr **tb)
>         inst->alg.cra_blkcipher.min_keysize =3D alg->cra_blkcipher.mi=
n_keysize;
>         inst->alg.cra_blkcipher.max_keysize =3D alg->cra_blkcipher.ma=
x_keysize;
>
> -       inst->alg.cra_blkcipher.geniv =3D "seqiv";
> -
>         inst->alg.cra_ctxsize =3D sizeof(struct crypto_cts_ctx);
>
>         inst->alg.cra_init =3D crypto_cts_init_tfm;
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Acked-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>

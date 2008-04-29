From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Correct kzalloc error test
Date: Tue, 29 Apr 2008 22:07:38 +0800
Message-ID: <E1JqqUc-0005Rg-00@gondolin.me.apana.org.au>
References: <Pine.LNX.4.58.0804291536220.1185@pc-041.diku.dk>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: julia@diku.dk (Julia Lawall)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40725 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbYD2OHn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Apr 2008 10:07:43 -0400
In-Reply-To: <Pine.LNX.4.58.0804291536220.1185@pc-041.diku.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Normally, kzalloc returns NULL or a valid pointer value, not a value to be
> tested using IS_ERR.

Ouch :)

> diff -u -p  a/crypto/cryptd.c b/crypto/cryptd.c
> --- a/crypto/cryptd.c   2008-04-16 13:27:56.000000000 +0200
> +++ b/crypto/cryptd.c   2008-04-29 15:29:54.000000000 +0200
> @@ -190,7 +190,7 @@ static struct crypto_instance *cryptd_al
>        int err;
> 
>        inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> -       if (IS_ERR(inst))
> +       if (!inst)
>                goto out;

However, this function is expected to return an ERR_PTR so you'll
need set it to ENOMEM first.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

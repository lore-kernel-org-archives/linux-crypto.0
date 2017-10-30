From: Romain Izard <romain.izard.pro@gmail.com>
Subject: Re: [PATCH] crypto: AF_ALG - remove locking in async callback
Date: Mon, 30 Oct 2017 18:15:32 +0100
Message-ID: <CAGkQfmO+c6m-1v9ztV-G68JXSupD+pMv0czpoieg0a5PyLQ_dg@mail.gmail.com>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
 <5260911.ZuXsrgFD2R@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:51378 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbdJ3RPx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 13:15:53 -0400
Received: by mail-qt0-f193.google.com with SMTP id h4so17324395qtk.8
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2017 10:15:53 -0700 (PDT)
In-Reply-To: <5260911.ZuXsrgFD2R@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-10-29 21:39 GMT+01:00 Stephan M=C3=BCller <smueller@chronox.de>:
> Am Mittwoch, 25. Oktober 2017, 17:26:31 CET schrieb Romain Izard:
>
> Hi Romain,
>
> the patch below should cover the issue you see. Would you mind testing it=
?
>
> Thanks
> Stephan
>
> ---8<---
>
> The code paths protected by the socket-lock do not use or modify the
> socket in a non-atomic fashion. The actions pertaining the socket do not
> even need to be handled as an atomic operation. Thus, the socket-lock
> can be safely ignored.
>
> This fixes a bug regarding scheduling in atomic as the callback function
> may be invoked in interrupt context.
>
> Fixes: 2d97591ef43d0 ("crypto: af_alg - consolidation of duplicate code")
> Reported-by: Romain Izard <romain.izard.pro@gmail.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Tested-by: Romain Izard <romain.izard.pro@gmail.com>

The issue observed with atmel-aes is not reproduced anymore.

> ---
>  crypto/af_alg.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 337cf382718e..a41f08642eee 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -1063,8 +1063,6 @@ void af_alg_async_cb(struct crypto_async_request *_=
req, int err)
>         struct kiocb *iocb =3D areq->iocb;
>         unsigned int resultlen;
>
> -       lock_sock(sk);
> -
>         /* Buffer size written by crypto operation. */
>         resultlen =3D areq->outlen;
>
> @@ -1073,8 +1071,6 @@ void af_alg_async_cb(struct crypto_async_request *_=
req, int err)
>         __sock_put(sk);
>
>         iocb->ki_complete(iocb, err ? err : resultlen, 0);
> -
> -       release_sock(sk);
>  }
>  EXPORT_SYMBOL_GPL(af_alg_async_cb);
>
> --
> 2.13.6
>
>

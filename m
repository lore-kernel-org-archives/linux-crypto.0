From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: [PATCH 1/1] crypto:drbg- Fixes panic in wait_for_completion call.
Date: Fri, 26 May 2017 16:09:53 +0530
Message-ID: <CAFXBA=mHNK6-eWnuz-u1EaLBjusvKKwuJP4VvZbDPvUgwGYjEw@mail.gmail.com>
References: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com> <12466881.1IDO9Q7xg5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34052 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966229AbdEZKjz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2017 06:39:55 -0400
Received: by mail-lf0-f68.google.com with SMTP id q24so660052lfb.1
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2017 03:39:54 -0700 (PDT)
In-Reply-To: <12466881.1IDO9Q7xg5@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 26, 2017 at 3:42 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Donnerstag, 25. Mai 2017, 17:23:47 CEST schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Initialise ctr_completion variable before use.
>
> Thank you very much for catching this.
>
> But I think the chosen function is wrong. When we have an HMAC or Hash DR=
BG, this completion function does not need to be initialized.
>
> May I ask you to check this patch?
Yup, Its working.
>
> Ciao
> Stephan
>
> ---8<---
>
> From 1ec5f753644eb9005ad758c9bfd75032602c9727 Mon Sep 17 00:00:00 2001
> From: Stephan Mueller <smueller@chronox.de>
> Date: Fri, 26 May 2017 12:11:31 +0200
> Subject: [PATCH] crypto: drbg- Fixes panic in wait_for_completion call
>
> Initialise ctr_completion variable before use.
>
> Signed-off-by: Harsh Jain <harshjain.prof@gmail.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index fa749f4..433c425 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1691,6 +1691,7 @@ static int drbg_init_sym_kernel(struct drbg_state *=
drbg)
>                 return PTR_ERR(sk_tfm);
>         }
>         drbg->ctr_handle =3D sk_tfm;
> +       init_completion(&drbg->ctr_completion);
>
>         req =3D skcipher_request_alloc(sk_tfm, GFP_KERNEL);
>         if (!req) {
> --
> 2.9.3
>
>

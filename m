From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: exynoes-rng: Set cra_ctxsize to 0
Date: Sun, 21 May 2017 08:26:09 +0200
Message-ID: <CAJKOXPfh21DLOqTUPSZ=mDUyuCE+L8Wn9m=ioM=N1nomT4Vs+g@mail.gmail.com>
References: <20170521060952.19055-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbdEUG0L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 02:26:11 -0400
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com [209.85.214.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DFC239B6
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 06:26:10 +0000 (UTC)
Received: by mail-it0-f46.google.com with SMTP id a10so1382351itg.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2017 23:26:10 -0700 (PDT)
In-Reply-To: <20170521060952.19055-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 21, 2017 at 8:09 AM, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> As cra_ctxsize is set but the allocated space is not used, set it 0.

Why do you think it is not used? Did you test our change on hardware?

Best regards,
Krzysztof

>
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  drivers/crypto/exynos-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
> index 451620b..d009df6 100644
> --- a/drivers/crypto/exynos-rng.c
> +++ b/drivers/crypto/exynos-rng.c
> @@ -260,7 +260,7 @@ static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
>                 .cra_name               = "stdrng",
>                 .cra_driver_name        = "exynos_rng",
>                 .cra_priority           = 100,
> -               .cra_ctxsize            = sizeof(struct exynos_rng_ctx),
> +               .cra_ctxsize            = 0,
>                 .cra_module             = THIS_MODULE,
>                 .cra_init               = exynos_rng_kcapi_init,
>         }
> --
> 1.8.5.6
>

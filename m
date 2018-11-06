Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:39895 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388493AbeKFXuC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 18:50:02 -0500
Received: by mail-it1-f196.google.com with SMTP id m15so17796433itl.4
        for <linux-crypto@vger.kernel.org>; Tue, 06 Nov 2018 06:24:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
References: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 6 Nov 2018 15:24:33 +0100
Message-ID: <CAKv+Gu-2-DkVCOzVb_dRqr=nfiaPuec5XQT9V7z3RxuBdd-k9g@mail.gmail.com>
Subject: Re: [PATCH] arm/crypto/aes-ce-glue.c: Remove duplicate header
To: Brajeswar Ghosh <brajeswar.linux@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, jrdr.linux@gmail.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sabyasachi.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6 November 2018 at 13:16, Brajeswar Ghosh <brajeswar.linux@gmail.com> wrote:
> Remove asm/hwcap.h which is included more than once
>
> Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/aes-ce-glue.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index d0a9cec73707..5affb8482379 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c
> @@ -10,7 +10,6 @@
>
>  #include <asm/hwcap.h>
>  #include <asm/neon.h>
> -#include <asm/hwcap.h>
>  #include <crypto/aes.h>
>  #include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
> --
> 2.17.1
>

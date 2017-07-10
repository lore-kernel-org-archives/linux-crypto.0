From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: cavium/nitrox - Remove default m setting from Kconfig
Date: Mon, 10 Jul 2017 11:51:42 -0700
Message-ID: <CA+55aFx1_-FD=cTvcNUP5JNzY6AQY6HcdNAKJ5fa7dLutvFjCg@mail.gmail.com>
References: <20170710101532.GA15004@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36347 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754734AbdGJSvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 14:51:43 -0400
Received: by mail-oi0-f67.google.com with SMTP id n2so12854979oig.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jul 2017 11:51:43 -0700 (PDT)
In-Reply-To: <20170710101532.GA15004@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Heh, I already did this in commit b4b8cbf679c4.

I complained because I want maintainers to be aware of this issue -
adding Kconfig options with defaults that don't make sense should be
caught earlier than when I do a test built..

                  Linus

On Mon, Jul 10, 2017 at 3:15 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Drivers should not enable themselves by default, unless they're
> an integral part of the platform.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/drivers/crypto/cavium/nitrox/Kconfig b/drivers/crypto/cavium/nitrox/Kconfig
> index 731e6a5..181a1df 100644
> --- a/drivers/crypto/cavium/nitrox/Kconfig
> +++ b/drivers/crypto/cavium/nitrox/Kconfig
> @@ -12,7 +12,6 @@ config CRYPTO_DEV_NITROX_CNN55XX
>         tristate "Support for Cavium CNN55XX driver"
>         depends on PCI_MSI && 64BIT
>         select CRYPTO_DEV_NITROX
> -       default m
>         help
>           Support for Cavium NITROX family CNN55XX driver
>           for accelerating crypto workloads.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

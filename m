Return-Path: <SRS0=gnyg=NA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB93CC67863
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 03:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23D420843
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 03:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="E0fRca7B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A23D420843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbeJTLpM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Oct 2018 07:45:12 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39096 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbeJTLpL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 07:45:11 -0400
Received: by mail-io1-f67.google.com with SMTP id z16-v6so24176590iol.6
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 20:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=JetETkZz58YSpa7TBF0LQ4b8VevGaMi232vEE+xJ/yU=;
        b=E0fRca7B17+o255dqlRN0Z0TLylq8T4BMunWhTvPLszZi79BrJnxmEmS6vNq+5FA7R
         qLZ+pMn94Z1G0dDrcAYLz8CU4HtXR1yCAAjPV7m4eyZ3EmKxb0hj+GL1Dsjl3SuCt8mF
         amfR11uqia7gD/D5wB2dQaByjfXXrPBKGRiKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=JetETkZz58YSpa7TBF0LQ4b8VevGaMi232vEE+xJ/yU=;
        b=LnVOrh2/3dQonLFMd+JyK0D2bx1Bgk35k1wj33/C/IF3mHBXzPX3QluxX1L54bPCtm
         /a7UhVosQp/M2C6pWcC2V9gGJFe0dAYneRNZ2sZSBDzzq9GAoMmM8KiQyA5oAPzEiMcL
         apiNHMMv/vqxB5kYnQjYBizUIfEI9sh4DyfYU1w8e+fzkN70zsMhDrlRQuHV7lR1G/BR
         QwFNa5Pn9gXvYGuHg5SQ9EGwARZS9tvJyynJUZQT4gR7d/fOO7NtRu7sGO1e6lhcI6Ja
         Pg7T8lw39ufD9eetBouYqKz4qC0uinIPd//eViCfBaJK2ZnzRmOJt8HSfHh+iEVj/YfU
         JjyA==
X-Gm-Message-State: AGRZ1gJMbnRU9iXSrUCs+qytqMrkywaSLkYqu0GUR2sYbWdX20oaLUPg
        IllNmkSnJn4+XNIbFQrIO5wsu7kanDf7xVw2bY+yMw==
X-Google-Smtp-Source: AJdET5enL6hn/0vPFzz+wq5rwhYGVA7D4KLaWvKkq/JuuyhzVzWGqXBHeW4DTjmWQtx/sBRhlghdN5nQL1I7qRKzb00=
X-Received: by 2002:a6b:5d12:: with SMTP id r18-v6mr4248786iob.170.1540006576409;
 Fri, 19 Oct 2018 20:36:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 20:36:15
 -0700 (PDT)
In-Reply-To: <20181015175424.97147-8-ebiggers@kernel.org>
References: <20181015175424.97147-1-ebiggers@kernel.org> <20181015175424.97147-8-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 20 Oct 2018 11:36:15 +0800
Message-ID:
 <CAKv+Gu91O99D48Dr-2UKrXdPrzGSFDGr_qH9zLpbvqDwd50DAw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/12] crypto: arm/chacha - add XChaCha12 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181020033615.4SiDYGaenT9ZoyawYGdU2N1_hbLn2ml2g5KEYlf0wX0@z>

On 16 October 2018 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Now that the 32-bit ARM NEON implementation of ChaCha20 and XChaCha20
> has been refactored to support varying the number of rounds, add support
> for XChaCha12.  This is identical to XChaCha20 except for the number of
> rounds, which is 12 instead of 20.
>
> XChaCha12 is faster than XChaCha20 but has a lower security margin,
> though still greater than AES-256's since the best known attacks make it
> through only 7 rounds.  See the patch "crypto: chacha - add XChaCha12
> support" for more details about why we need XChaCha12 support.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/Kconfig            |  2 +-
>  arch/arm/crypto/chacha-neon-glue.c | 21 ++++++++++++++++++++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 0aa1471f27d2e..cc932d9bba561 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -117,7 +117,7 @@ config CRYPTO_CRC32_ARM_CE
>         select CRYPTO_HASH
>
>  config CRYPTO_CHACHA20_NEON
> -       tristate "NEON accelerated ChaCha20 stream cipher algorithms"
> +       tristate "NEON accelerated ChaCha stream cipher algorithms"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_BLKCIPHER
>         select CRYPTO_CHACHA20
> diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
> index b236af4889c61..0b1b238227707 100644
> --- a/arch/arm/crypto/chacha-neon-glue.c
> +++ b/arch/arm/crypto/chacha-neon-glue.c
> @@ -1,5 +1,6 @@
>  /*
> - * ChaCha20 (RFC7539) and XChaCha20 stream ciphers, NEON accelerated
> + * ARM NEON accelerated ChaCha and XChaCha stream ciphers,
> + * including ChaCha20 (RFC7539)
>   *
>   * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
>   *
> @@ -160,6 +161,22 @@ static struct skcipher_alg algs[] = {
>                 .setkey                 = crypto_chacha20_setkey,
>                 .encrypt                = xchacha_neon,
>                 .decrypt                = xchacha_neon,
> +       }, {
> +               .base.cra_name          = "xchacha12",
> +               .base.cra_driver_name   = "xchacha12-neon",
> +               .base.cra_priority      = 300,
> +               .base.cra_blocksize     = 1,
> +               .base.cra_ctxsize       = sizeof(struct chacha_ctx),
> +               .base.cra_module        = THIS_MODULE,
> +
> +               .min_keysize            = CHACHA_KEY_SIZE,
> +               .max_keysize            = CHACHA_KEY_SIZE,
> +               .ivsize                 = XCHACHA_IV_SIZE,
> +               .chunksize              = CHACHA_BLOCK_SIZE,
> +               .walksize               = 4 * CHACHA_BLOCK_SIZE,
> +               .setkey                 = crypto_chacha12_setkey,
> +               .encrypt                = xchacha_neon,
> +               .decrypt                = xchacha_neon,
>         }
>  };
>
> @@ -186,3 +203,5 @@ MODULE_ALIAS_CRYPTO("chacha20");
>  MODULE_ALIAS_CRYPTO("chacha20-neon");
>  MODULE_ALIAS_CRYPTO("xchacha20");
>  MODULE_ALIAS_CRYPTO("xchacha20-neon");
> +MODULE_ALIAS_CRYPTO("xchacha12");
> +MODULE_ALIAS_CRYPTO("xchacha12-neon");
> --
> 2.19.1.331.ge82ca0e54c-goog
>

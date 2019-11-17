Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC18C432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 07:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8476120730
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 07:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vz+ZsF8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfKQH72 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 02:59:28 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33785 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfKQH72 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 02:59:28 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so15861010wrr.0
        for <linux-crypto@vger.kernel.org>; Sat, 16 Nov 2019 23:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EHzTmPabHB3f7pFdeyNG36fmhjbQWjLIfGD4KILGES0=;
        b=Vz+ZsF8uCMRFETY+lah2vd36ZQgcXMWlMmzSLkvkjbXdt7c5PeJvgtK+6p6PykHJx3
         BSNVodjLK9HUpLRud5B3oClqy3O0sHF7WN+xFvr7lp+04q7F4gP0nDZWqnNibcHeJfrF
         ZciqtYLY18VOAG+2O9K21b3QX+8mtVBAsl0+bEwIcDcsGGZ6L4l4ZXpBBSCCe1ynEb6K
         +c3X3dzoRy2aBkhfclMjigKKca/9WxP/rA5zwLMrX7S3fyO5C7otuyE22HP3zo7zJ9Xi
         q4rNgqeBpIi+TB4EtW9hRGFwdBq5EfKqrktNivomg9r7qyHBry+0HK3sRfNhrELzesIi
         p/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EHzTmPabHB3f7pFdeyNG36fmhjbQWjLIfGD4KILGES0=;
        b=pQTQZcOmiPjbdwGPK3cR6f+GIDQO5BbjfkrANLqeQbNHJdoXN9MWkLHKJuW+yf1o1v
         4lRrr3oBk/ELV9NWUtENoGoP7tpSoJ+fJNWfdP1ojw60u691d9imqCx8b3eU3RPzwBkB
         EJDH9pLhTx6xCFC7pVgqo9zj76slYKPyS5BVCy6giLUwEG77Wv4Xsm14K04Mps2fJuWt
         N5aDcCTloWl32kRxwp8IjcEe6nPrzsuml12jnCchlZi+8GGmdOC9G1BDng6aADupCP0e
         ommKuO+8Nt7/TO9zEHXNL7ztgpXalJ4at7NGVgcoIN6vhFdOTtU0sRRQwk2pxV3gKxQs
         J18w==
X-Gm-Message-State: APjAAAWCccGd2FZ2XrmoUimw+XXpDl2CsjiRHGCGcfXfwGanIXVBN6sz
        05APOL38i8UqsvGzRRbbv/X4Ixsl8WwCs3yb5t5m3a59fdG5AQ==
X-Google-Smtp-Source: APXvYqxY8TGxCLqmFVj1TCsYszRfg+rpwuwDw8LYKGyOy7Or3RdvX6onrk76DvutkWIMh3DW9x13GfBC2MVBsuSOTJo=
X-Received: by 2002:a5d:6508:: with SMTP id x8mr9793489wru.0.1573977565979;
 Sat, 16 Nov 2019 23:59:25 -0800 (PST)
MIME-Version: 1.0
References: <20191117025324.22929-1-ebiggers@kernel.org>
In-Reply-To: <20191117025324.22929-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 17 Nov 2019 08:59:14 +0100
Message-ID: <CAKv+Gu9h8TBgKo9ujZ0i+Nr1PRD2Wou-XXj1z=q1xxzRCMO8FA@mail.gmail.com>
Subject: Re: [PATCH] crypto: mips/chacha - select CRYPTO_SKCIPHER, not CRYPTO_BLKCIPHER
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 17 Nov 2019 at 03:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Another instance of CRYPTO_BLKCIPHER made it in just after it was
> renamed to CRYPTO_SKCIPHER.  Fix it.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks Eric

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 472c2ad36063..5575d48473bd 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1487,7 +1487,7 @@ config CRYPTO_CHACHA20_X86_64
>  config CRYPTO_CHACHA_MIPS
>         tristate "ChaCha stream cipher algorithms (MIPS 32r2 optimized)"
>         depends on CPU_MIPS32_R2
> -       select CRYPTO_BLKCIPHER
> +       select CRYPTO_SKCIPHER
>         select CRYPTO_ARCH_HAVE_LIB_CHACHA
>
>  config CRYPTO_SEED
> --
> 2.24.0
>

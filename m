Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CFBC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676C62171F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mEjvSue1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfCMKea (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:34:30 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:35015 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMKea (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:34:30 -0400
Received: by mail-it1-f195.google.com with SMTP id 188so2047044itb.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8XD7Tv6toIb4i5dUt6vZGgoxA9oC9ajVPAnYaXGXGbY=;
        b=mEjvSue1pXiVU0JlcdRwWxi4dz2f+6iYqElEpW4BuoRBnTIv9GeIGYu7JtOkxQeQ1P
         jV7ESRmgTPTWL8BAOJKa5dl20Zfx7ily2jWgcfjmbADWifDpQEoV5TeWrtXqb/uTKTBD
         Q+PSAj3mPCHVHM3A2vGss5T7MoKt+xagRDfxcW0CjKgaoBvcYpDj/4EyqeIwUX9DBHiD
         jsx1++vCFfqf4fFryIGQtxVfkxSunO3SzgjpStP20xKCbnykq0xIOXSBOALpBt6RNyha
         GmRItx3J5Q8s5YV+w6zvU/XosszvRB7TERpzFBmH7xN9+oSHRvouadWtUOvCptiYlFnD
         xGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8XD7Tv6toIb4i5dUt6vZGgoxA9oC9ajVPAnYaXGXGbY=;
        b=kFPcva78mMk6cbSis3uVg6dZA/Q8+cVK8/aIrmF2vjoXOAKenLDJsB/DApM+nxsImT
         E5gNSEQL+apHlBiFgUi8pEiw6HA4dqJaF4FfEmW4YyAik3pX6SvGaAgK66chf/u78o/J
         ca0nDb2cgoPZwmxD8sSqJshSwx2R7SIgJwUfGRN7LPOMVjQDUMybbCy36cvAGz9NW3V1
         ej2M4d/p00Gq0pTndgHMHn4XYyEidmVMb67NL7j5sLKqONcA20ApLA1NvViBZDxSXT48
         TPZtw5BgCn7LXdu4oPpMQm3tnwWT57t4oL6kPAASUQR78FyyJmedwkN/JOq23GuA/3kL
         qygA==
X-Gm-Message-State: APjAAAW1mLYrkawximfZyOi0D743rSSoVXY1zvXmnzyTqw7801oi8OSp
        JYOQu598IxrakZSxJX1V4Ep09PxptKSbaeaxp1wqMw==
X-Google-Smtp-Source: APXvYqzluLa7C4RVnb6RZeCUz93uKS2lOF92yumPeTzrM4NduRAQz1sejn3gzJ7MQUGXrfNNhgbUE9jEfwU9bbVkOyQ=
X-Received: by 2002:a24:32d0:: with SMTP id j199mr1346328ita.71.1552473269476;
 Wed, 13 Mar 2019 03:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-8-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-8-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:34:18 +0100
Message-ID: <CAKv+Gu_DNssHONf+RAR9voMc_aCQ6B=tWREPiZ-_54Z7i8r46w@mail.gmail.com>
Subject: Re: [PATCH 7/8] crypto: simd - convert to use crypto_simd_usable()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Mar 2019 at 06:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Replace all calls to may_use_simd() in the shared SIMD helpers with
> crypto_simd_usable(), in order to allow testing the no-SIMD code paths.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/simd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/simd.c b/crypto/simd.c
> index 7d62686d3a3f..3e3b1d1a6b1f 100644
> --- a/crypto/simd.c
> +++ b/crypto/simd.c
> @@ -85,7 +85,7 @@ static int simd_skcipher_encrypt(struct skcipher_request *req)
>         subreq = skcipher_request_ctx(req);
>         *subreq = *req;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
>                 child = &ctx->cryptd_tfm->base;
>         else
> @@ -106,7 +106,7 @@ static int simd_skcipher_decrypt(struct skcipher_request *req)
>         subreq = skcipher_request_ctx(req);
>         *subreq = *req;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
>                 child = &ctx->cryptd_tfm->base;
>         else
> @@ -336,7 +336,7 @@ static int simd_aead_encrypt(struct aead_request *req)
>         subreq = aead_request_ctx(req);
>         *subreq = *req;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
>                 child = &ctx->cryptd_tfm->base;
>         else
> @@ -357,7 +357,7 @@ static int simd_aead_decrypt(struct aead_request *req)
>         subreq = aead_request_ctx(req);
>         *subreq = *req;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
>                 child = &ctx->cryptd_tfm->base;
>         else
> --
> 2.21.0
>

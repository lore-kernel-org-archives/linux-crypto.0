Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0575C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835CC218AF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 12:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f9db/rN1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfIIMUZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:20:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54850 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbfIIMUZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 08:20:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so2013059wmp.4
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 05:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/aCWrDpHlFODosnbRwR6VukVgkzBdkMkGeczHUk1nlA=;
        b=f9db/rN1sgteqNvaH46/Oph+z1zM7Jndklz1GGm5xrZfMoiTXbygcFttY4oJp1ocgV
         Hx4xGBCVtp/RoChbTOgx9/VCj7id3W0hh6CRR7z7sAV+SgNu2JlCGb+Jh+5annPz7TND
         9/b8CgKxOoGvcxcaoLe+OOr/BnbAKZQIT4QVOcMYQyL+dTHSlrQNRI0YfjhTmHWvawO9
         VM79V+nMCBr8Qg15HZuMZcy4aX0S5K8AZ76vf7/ShLKLDtBTvvbjYDwQ7O9Y8hjCHqTT
         CFVhT/kuDhX/PXw9j1JZEQP143jqnlzbt4Eje/R98c0nv2kL3hCdXOgedRZbosdBSOb2
         0sLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/aCWrDpHlFODosnbRwR6VukVgkzBdkMkGeczHUk1nlA=;
        b=CsjeQLcP+UPpfLZlmhnjUS0ZjkXBKJabUwIoZn5YzboT9F5jmKhF3wagsP9jzAbZkP
         XUBSp+NLs2eXRYDKzR5/mDNdVggyXeX4cDG2vjn9giaLVa2JE0WwDqgSgEw90+XW7+zc
         Cxxigq/WyOEhvnsUfjwmr1udnZz6auwog0m/dWhfxnCEQhbJiRwai421+6lG/GZ57i//
         pyeGOvAoZeJIRRr2LTrkboGmmvuj4KsrBRwYhlvRl2Jyd6RG1wN7t64NBNJKQSxZIK/F
         FE/e5nfbHC1GA8Ic623myBlSQNMOFIr584bhStf0ZsALpJG6/UtPTupQp5sI4fqYUSY9
         rd5g==
X-Gm-Message-State: APjAAAVeHu8SI/L8BS6XclhUIYRJFykREp7pqRh7p7y7oe6dwR1oEB4W
        IT+qr5ajNdJzqlgQsGuSliYyvdkeKSdJBD3pOig0KjOSD64JrQ==
X-Google-Smtp-Source: APXvYqywHiyDZBf3TACY//23Ym2+w4hrJFZgGyAZaxw9v/3hY6LpBmaH/Lc7Q/TlG+UtkAbYwddLMHPKphOyDzWxWTY=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr18013166wma.119.1568031622732;
 Mon, 09 Sep 2019 05:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
In-Reply-To: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 9 Sep 2019 13:20:05 +0100
Message-ID: <CAKv+Gu9tVkES12fA0cauMhUV+EZ6HZZwMopJo47qE6j8hsFv4w@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - enable CTS support in AES-XTS
To:     Uri Shir <uri.shir@arm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Gilad <gilad@benyossef.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 8 Sep 2019 at 09:04, Uri Shir <uri.shir@arm.com> wrote:
>
> In XTS encryption/decryption the plaintext byte size
> can be >= AES_BLOCK_SIZE. This patch enable the AES-XTS ciphertext
> stealing implementation in ccree driver.
>
> Signed-off-by: Uri Shir <uri.shir@arm.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
> index 5b58226..a95d3bd 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -116,10 +116,6 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
>         case S_DIN_to_AES:
>                 switch (ctx_p->cipher_mode) {
>                 case DRV_CIPHER_XTS:
> -                       if (size >= AES_BLOCK_SIZE &&
> -                           IS_ALIGNED(size, AES_BLOCK_SIZE))
> -                               return 0;
> -                       break;

You should still check for size < block size.

>                 case DRV_CIPHER_CBC_CTS:
>                         if (size >= AES_BLOCK_SIZE)
>                                 return 0;
> @@ -945,7 +941,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "xts(paes)",
>                 .driver_name = "xts-paes-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,

No need for these blocksize changes - just keep them as they are.

>                 .template_skcipher = {
>                         .setkey = cc_cipher_sethkey,
>                         .encrypt = cc_cipher_encrypt,
> @@ -963,7 +959,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "xts512(paes)",
>                 .driver_name = "xts-paes-du512-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_sethkey,
>                         .encrypt = cc_cipher_encrypt,
> @@ -982,7 +978,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "xts4096(paes)",
>                 .driver_name = "xts-paes-du4096-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_sethkey,
>                         .encrypt = cc_cipher_encrypt,
> @@ -1203,7 +1199,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "xts(aes)",
>                 .driver_name = "xts-aes-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_setkey,
>                         .encrypt = cc_cipher_encrypt,
> @@ -1220,7 +1216,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "xts512(aes)",
>                 .driver_name = "xts-aes-du512-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_setkey,
>                         .encrypt = cc_cipher_encrypt,
> @@ -1238,7 +1234,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "xts4096(aes)",
>                 .driver_name = "xts-aes-du4096-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_setkey,
>                         .encrypt = cc_cipher_encrypt,
> --
> 2.7.4
>

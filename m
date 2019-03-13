Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D3AC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8553B214AE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FzCjqhRu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfCMK3g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:29:36 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52244 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfCMK3f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:29:35 -0400
Received: by mail-it1-f194.google.com with SMTP id g17so2025874ita.2
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cn4FrR13kTkZbjSkbNRPXvq9r/iiXGMIlYOJso/8khc=;
        b=FzCjqhRumMHtYsgEuXOi7pCLTzVDVJ09lk0izN5nQz44qjQ5mBKAiGUZlrFEawPHlm
         CtPNrL2YxLEI13du+KGtht9Qya7U8KgC/KszDT2mxPQGSvdh9m80Mp3CmD9A/nAMYyd4
         0ia8PHg2KBfV97HAFoNM87T3ThT82w6aYpY56Nn5wXWXCH3JpRT0IGYZP9KfQXSxkJQL
         jwuOfC8+BivjedxXQIiAQbbIKtZ8MA8Ct8qmiqtzRcTXcvzH0E6vFLj1xNro5b4zNUOF
         2KOe0v2uy+5/jbiQTJwY6x2VVbG3juZoqp+tRWn2MRjqSBxiJJ0bWynjdpwryZ6k3Ivf
         vuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cn4FrR13kTkZbjSkbNRPXvq9r/iiXGMIlYOJso/8khc=;
        b=TgO6CDFyJfGdVg8GfwsKCaW85t3CQfd2GJeEXCusWTxv0TLI23nQ8U/gWvyZpWR4WQ
         RzNUulCTg+hEkA7Ku/CidzlUaZtrUPviuZfGONMKBweeapjEEAnNSCywVNSoaHLplRq5
         jryqPHdM9WzLENodTttHb4UKmXgX4DscYHSihpp2spVhIgU4PnQUVZ8du4+020Dn/LLc
         SZGAbDVt+CHX8YtsX4l2Zh4n0UMHBqlpvdL6HYpyoRpTtLgYm3WozmEd5/nfZN5wNN7J
         dDVFX5HgbbRodYbSXOjzM++QLQMYlKw+hUtztGXc3uIOXWvqrvnSJh6/t94G1xcjgH0w
         bynQ==
X-Gm-Message-State: APjAAAVCvK0fOPgww97CVc2OSC3Kx9BMl50tg53hT3gRMH2lbBjW2H7o
        9i/BHGkPfoRFFBCIDLSRCFp9mppv38WlNhLeUcVsbw==
X-Google-Smtp-Source: APXvYqzzvRXzKBvAQQyW8/wtQas9Zlydw5JRhTqUOhpZ6A4qpEL54IsWvbUtQHsTpDqdvr07vhkNXpWbVnenVWLqGDE=
X-Received: by 2002:a24:1947:: with SMTP id b68mr1123359itb.121.1552472974673;
 Wed, 13 Mar 2019 03:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-3-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-3-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:29:23 +0100
Message-ID: <CAKv+Gu-fBm9ocqzF24ysaa7rLpr99FmznNVBz6Go4CEfJXy88g@mail.gmail.com>
Subject: Re: [PATCH 2/8] crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
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
> The arm64 gcm-aes-ce algorithm is failing the extra crypto self-tests
> following my patches to test the !may_use_simd() code paths, which
> previously were untested.  The problem is that in the !may_use_simd()
> case, an odd number of AES blocks can be processed within each step of
> the skcipher_walk.  However, the skcipher_walk is being done with a
> "stride" of 2 blocks and is advanced by an even number of blocks after
> each step.  This causes the encryption to produce the wrong ciphertext
> and authentication tag, and causes the decryption to incorrectly fail.
>
> Fix it by only processing an even number of blocks per step.
>
> Fixes: c2b24c36e0a3 ("crypto: arm64/aes-gcm-ce - fix scatterwalk API violation")
> Fixes: 71e52c278c54 ("crypto: arm64/aes-ce-gcm - operate on two input blocks at a time")
> Cc: <stable@vger.kernel.org> # v4.19+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> ---
>  arch/arm64/crypto/ghash-ce-glue.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
> index 791ad422c427..089b09286da7 100644
> --- a/arch/arm64/crypto/ghash-ce-glue.c
> +++ b/arch/arm64/crypto/ghash-ce-glue.c
> @@ -473,9 +473,11 @@ static int gcm_encrypt(struct aead_request *req)
>                 put_unaligned_be32(2, iv + GCM_IV_SIZE);
>
>                 while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
> -                       int blocks = walk.nbytes / AES_BLOCK_SIZE;
> +                       const int blocks =
> +                               walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
>                         u8 *dst = walk.dst.virt.addr;
>                         u8 *src = walk.src.virt.addr;
> +                       int remaining = blocks;
>
>                         do {
>                                 __aes_arm64_encrypt(ctx->aes_key.key_enc,
> @@ -485,9 +487,9 @@ static int gcm_encrypt(struct aead_request *req)
>
>                                 dst += AES_BLOCK_SIZE;
>                                 src += AES_BLOCK_SIZE;
> -                       } while (--blocks > 0);
> +                       } while (--remaining > 0);
>
> -                       ghash_do_update(walk.nbytes / AES_BLOCK_SIZE, dg,
> +                       ghash_do_update(blocks, dg,
>                                         walk.dst.virt.addr, &ctx->ghash_key,
>                                         NULL, pmull_ghash_update_p64);
>
> @@ -609,7 +611,7 @@ static int gcm_decrypt(struct aead_request *req)
>                 put_unaligned_be32(2, iv + GCM_IV_SIZE);
>
>                 while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
> -                       int blocks = walk.nbytes / AES_BLOCK_SIZE;
> +                       int blocks = walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
>                         u8 *dst = walk.dst.virt.addr;
>                         u8 *src = walk.src.virt.addr;
>
> --
> 2.21.0
>

Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3E5C432C3
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE1120730
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TueI4y8m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfKRH1C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:27:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43941 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfKRH1C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 02:27:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so18072452wra.10
        for <linux-crypto@vger.kernel.org>; Sun, 17 Nov 2019 23:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1PfRV59VdJePfpGbxWVys6e1lRpwcemANsdtiEh5XqM=;
        b=TueI4y8mXTuw0QlK79jadIyxwjrdWQof9XHZc+G9OcnLNGSxqQx8wZ3KFE+cAHDjuI
         YduAjWIhlIKnJ3SIP3RE1vvuEKnbPgiiRVWmVSVCCglzyloqFan++Fjdd8nLVbBKKBHZ
         4t8HiU0REg7Yhg3YsKU8ESvADOrVhaUXJ399g7WYBg3JqGxYE9dFPz5YcsNyD03kVTID
         11YgUL+UggiXLVJLqVBNAqSTsslUiH2XBNwnHkVqWQQUMDuokInFlegi1KhJ1pqd+MGc
         7zHT+TXaKfrk3rNAcQqOkBHmYVX3rU+unMCAQ5wj9T4EQ64vyMTs3dqJVupozyKKZwbk
         6Bjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1PfRV59VdJePfpGbxWVys6e1lRpwcemANsdtiEh5XqM=;
        b=evZqGL7MRDxkKTRjkUd6TyOnQMacairWIGI4nQx5qoudo9jb0Fw64a4hiK4qMItIWk
         rGAGr40z8ZK3yEjtKAroNmzVHnYRZobm6hJOtta3R1m96Zvxti3RasxvImoYN5vvYYZG
         OOaKL4dLrT1YPB8VJbBCkRQln9OQrNhDU8FAd8pdwRHVvLWOp1HO+FjSMg5Z0oAQrwMO
         xq9/UMcQWp9paAA9cmGSeFLIaOuNbIdafVcB0S1qbAvDmmy15cyXqYKWluHk7Q6cDKnG
         G0IyUllc7idMW0yiBxmcR8uL5i2IG/DFR3gLYtUOfMguX4ng9i1IvmhYsemH+NCwcTqz
         MjdA==
X-Gm-Message-State: APjAAAW4wLzKz7lpRyLgYwg3OhlQjJOxJPr7rpPILmhQpTxco6ncwMtT
        u1K+pncClMZ7hwIKMz2s7eGADrRPiXCLhRA9WsMQiYzkXMki+LW6
X-Google-Smtp-Source: APXvYqxIQKdq0Q7dOpPhreSQhm5IFi+BHLFWo3jxpKXGwsmQX1mj5cCktt+VDu5Hwe6blGvxrnKit8xVl+Q9ELCkkOs=
X-Received: by 2002:adf:ec42:: with SMTP id w2mr15172306wrn.32.1574062018558;
 Sun, 17 Nov 2019 23:26:58 -0800 (PST)
MIME-Version: 1.0
References: <20191118072129.467514-1-ebiggers@kernel.org>
In-Reply-To: <20191118072129.467514-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 18 Nov 2019 08:26:46 +0100
Message-ID: <CAKv+Gu-J9exRp+_eCcc-24Bx9ifmDMDAnuZE9QP6jNY=ngsMhQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: chacha_generic - remove unnecessary setkey() functions
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

On Mon, 18 Nov 2019 at 08:21, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Use chacha20_setkey() and chacha12_setkey() from
> <crypto/internal/chacha.h> instead of defining them again in
> chacha_generic.c.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/chacha_generic.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> index c1b147318393..8beea79ab117 100644
> --- a/crypto/chacha_generic.c
> +++ b/crypto/chacha_generic.c
> @@ -37,18 +37,6 @@ static int chacha_stream_xor(struct skcipher_request *req,
>         return err;
>  }
>
> -static int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
> -                                 unsigned int keysize)
> -{
> -       return chacha_setkey(tfm, key, keysize, 20);
> -}
> -
> -static int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
> -                                unsigned int keysize)
> -{
> -       return chacha_setkey(tfm, key, keysize, 12);
> -}
> -
>  static int crypto_chacha_crypt(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> @@ -91,7 +79,7 @@ static struct skcipher_alg algs[] = {
>                 .max_keysize            = CHACHA_KEY_SIZE,
>                 .ivsize                 = CHACHA_IV_SIZE,
>                 .chunksize              = CHACHA_BLOCK_SIZE,
> -               .setkey                 = crypto_chacha20_setkey,
> +               .setkey                 = chacha20_setkey,
>                 .encrypt                = crypto_chacha_crypt,
>                 .decrypt                = crypto_chacha_crypt,
>         }, {
> @@ -106,7 +94,7 @@ static struct skcipher_alg algs[] = {
>                 .max_keysize            = CHACHA_KEY_SIZE,
>                 .ivsize                 = XCHACHA_IV_SIZE,
>                 .chunksize              = CHACHA_BLOCK_SIZE,
> -               .setkey                 = crypto_chacha20_setkey,
> +               .setkey                 = chacha20_setkey,
>                 .encrypt                = crypto_xchacha_crypt,
>                 .decrypt                = crypto_xchacha_crypt,
>         }, {
> @@ -121,7 +109,7 @@ static struct skcipher_alg algs[] = {
>                 .max_keysize            = CHACHA_KEY_SIZE,
>                 .ivsize                 = XCHACHA_IV_SIZE,
>                 .chunksize              = CHACHA_BLOCK_SIZE,
> -               .setkey                 = crypto_chacha12_setkey,
> +               .setkey                 = chacha12_setkey,
>                 .encrypt                = crypto_xchacha_crypt,
>                 .decrypt                = crypto_xchacha_crypt,
>         }
> --
> 2.24.0
>

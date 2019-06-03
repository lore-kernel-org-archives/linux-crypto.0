Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC42C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D81F6263A6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:49:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f6vcLmSH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfFCGtL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:49:11 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:39111 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfFCGtL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:49:11 -0400
Received: by mail-it1-f194.google.com with SMTP id j204so19599952ite.4
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLdO2XOT4A5u8U75zYJw0dyWvkYCWbqlAF5uduaFre0=;
        b=f6vcLmSHiOAnChbA7R8+31QBvLq0WWapsAR5cesNNNPlyxQXfIJW4gVq6LCWVYAJ8S
         ZgEZH5+r6uG/afT9rh6yVQy69+E3yTxzpduTKN/SASdbIZwzdvD1kFiUzT0L8khtolb4
         ARV3YPFE+WgqCXXhkXL+Qd0SxoaRcB9rwbREFyORrIGQbAUTkfUl3MHhLWSmKZGIfJNT
         FmEYn6FIEel5IB7HtSCHp6dhetuhMXVufYgx4qafiWELtiEBJg42WQ/rNVL3ORN0evPJ
         PXIwB+gKG6yik1Ic46ne39hMWU0XtQpk23DKAs6vcyv9hcmX0OSZRHeEiV3e1ciTBdT0
         5neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLdO2XOT4A5u8U75zYJw0dyWvkYCWbqlAF5uduaFre0=;
        b=PeGwtVKwUFgssOM5JOj5bTP69DTGuGqVpbAOVXeuYUgJExsBScgFgVh/mw0CLUmI9z
         xYFvsx4DQEOEgxU5nbwu/CvF1y7OjIQmFHkhxkEYZJkouev5aaj1NKTFZveM6kqGMyCU
         h/s86ad7CmbKOjzmsOeuPJDIV2R9WSrbrdnUoReN/NkVcpUH+AxJTCIoZ4GubfSsLZcr
         nk84RqfMutfpMkWH0RR4Pl8nWW/1ZZWxsvDKKCI+jpgZVTKIpBPNmlCziy2r2CWzdQa1
         QRQZiLEd1XbwXd86+kBfnCMc1ToraqNuVqKhGqnsT6eYl6HFTf7//CqOXaNYRJeNJnko
         M7ww==
X-Gm-Message-State: APjAAAUFQCMLt+fQmSDPIJaUDeqlWj0dbgzeYT2EnwcuPPT8ulbTPJCy
        UKyP67p6HuJ/NwdYLc0bPPmivX/BhQizBZH8kuqQLtUfZihZFfoq
X-Google-Smtp-Source: APXvYqzIenANVaMq2X2/PVfZGNHhDLNRqtjiD5+ooUbwXYRexgD91br9lwKnLlviIz5e8MPYFWXESlIZYiuAxmsL4/0=
X-Received: by 2002:a24:1614:: with SMTP id a20mr1184258ita.153.1559544550067;
 Sun, 02 Jun 2019 23:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054551.6182-1-ebiggers@kernel.org>
In-Reply-To: <20190603054551.6182-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:48:57 +0200
Message-ID: <CAKv+Gu_H7r_z5StyCpW8zKMCHhRVPHQ1_JT5oZjCDESWQ=of_Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: skcipher - un-inline encrypt and decrypt functions
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:46, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> crypto_skcipher_encrypt() and crypto_skcipher_decrypt() have grown to be
> more than a single indirect function call.  They now also check whether
> a key has been set, and with CONFIG_CRYPTO_STATS=y they also update the
> crypto statistics.  That can add up to a lot of bloat at every call
> site.  Moreover, these always involve a function call anyway, which
> greatly limits the benefits of inlining.
>
> So change them to be non-inline.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/skcipher.c         | 34 ++++++++++++++++++++++++++++++++++
>  include/crypto/skcipher.h | 32 ++------------------------------
>  2 files changed, 36 insertions(+), 30 deletions(-)
>
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 2e66f312e2c4f..2828e27d7fbc0 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -842,6 +842,40 @@ static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>         return 0;
>  }
>
> +int crypto_skcipher_encrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct crypto_alg *alg = tfm->base.__crt_alg;
> +       unsigned int cryptlen = req->cryptlen;
> +       int ret;
> +
> +       crypto_stats_get(alg);
> +       if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> +               ret = -ENOKEY;
> +       else
> +               ret = tfm->encrypt(req);
> +       crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(crypto_skcipher_encrypt);
> +
> +int crypto_skcipher_decrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct crypto_alg *alg = tfm->base.__crt_alg;
> +       unsigned int cryptlen = req->cryptlen;
> +       int ret;
> +
> +       crypto_stats_get(alg);
> +       if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> +               ret = -ENOKEY;
> +       else
> +               ret = tfm->decrypt(req);
> +       crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
> +
>  static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
>  {
>         struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index e555294ed77fe..98547d1f18c53 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -484,21 +484,7 @@ static inline struct crypto_sync_skcipher *crypto_sync_skcipher_reqtfm(
>   *
>   * Return: 0 if the cipher operation was successful; < 0 if an error occurred
>   */
> -static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
> -{
> -       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> -       struct crypto_alg *alg = tfm->base.__crt_alg;
> -       unsigned int cryptlen = req->cryptlen;
> -       int ret;
> -
> -       crypto_stats_get(alg);
> -       if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else
> -               ret = tfm->encrypt(req);
> -       crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
> -       return ret;
> -}
> +int crypto_skcipher_encrypt(struct skcipher_request *req);
>
>  /**
>   * crypto_skcipher_decrypt() - decrypt ciphertext
> @@ -511,21 +497,7 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
>   *
>   * Return: 0 if the cipher operation was successful; < 0 if an error occurred
>   */
> -static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
> -{
> -       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> -       struct crypto_alg *alg = tfm->base.__crt_alg;
> -       unsigned int cryptlen = req->cryptlen;
> -       int ret;
> -
> -       crypto_stats_get(alg);
> -       if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else
> -               ret = tfm->decrypt(req);
> -       crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
> -       return ret;
> -}
> +int crypto_skcipher_decrypt(struct skcipher_request *req);
>
>  /**
>   * DOC: Symmetric Key Cipher Request Handle
> --
> 2.21.0
>

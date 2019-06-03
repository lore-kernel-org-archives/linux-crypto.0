Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546E2C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F0F8267DF
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ueQlyx/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfFCGtb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:49:31 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:39156 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfFCGtb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:49:31 -0400
Received: by mail-it1-f193.google.com with SMTP id j204so19600890ite.4
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/cJG2Dbrl0jj0kRFd00s3RmB1IC1rLB65btpppcNvBo=;
        b=ueQlyx/ahuJDXrK5pJxaHVYZ78GyvnhaBOQ7NKhOk7fejcMVhDvG88InQ4yEXDIGuU
         uwCffp36WWdM7HtqP3O8yfD0eecI+e2HKOV43Ys0+yT6c74b1R0s4ah41pWHgtOFxsnN
         fDW9rOaLFpDOmAJicNVLKZcZbqiHah1mlhIkuXNUDZvi7MULGXImY+c1AnwrVyTk5Eyz
         T1yMdDg6zNVevlLQW024Vz2eMfGdV2Rt4NtnKta8+SvMZQSrgjIQ/FF29W5jqrrqMSdY
         GdsKzDZqT+LOiLFLgEzjQrd/rGx8W12bfNRoQMKVCy8T0phdxXaZ83Eix9u7AMi4LuJg
         nMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/cJG2Dbrl0jj0kRFd00s3RmB1IC1rLB65btpppcNvBo=;
        b=mwOd5uPSPhdBCTgE3quKUlWE9lpsFagv10+wiZCViNUwEN/o440a/DhufyHkZdRdWg
         ro+zM4qrnKyupV0upeGIRXsNRH+ucysiO0xUja1yz2R4RdZceuwLfGCwvDaPhslynskh
         gIWGj+mf5NH3/40ld/s00oQxZGJqu7oXoQDf6lOoqEeJOwE4Xn+5DJI15lt1jG5g+h3P
         hEwB7PzsYb3K2dArIyMJBDwH8rUt1Et9jmMER8Hi2dzsuz14E0nBT4vkRQTV8HgjO6tv
         bSmqnmZaHcpf53KGVKSgjUROpzlqhzgpZlzyuNG/aCArXWma+uZxjEupeaRLJqgh49UD
         Xoow==
X-Gm-Message-State: APjAAAWvGHokGSZiUDDci4Yi9wXF6/EdRD37wlYghjh1zdGRz4KL4WBw
        v861j+Bb643L0E8L1OH8iguB2rcrzRh5tl8h2IMN7g==
X-Google-Smtp-Source: APXvYqz3gamNoWPvUcEDK8XZPpXw0UbW27TGApZ5WDDsxlPxZ//u7Z3OWUaZCJrQ0fO4T9kYGO0seCVPdn33heBJlKU=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr15771599jar.2.1559544570193;
 Sun, 02 Jun 2019 23:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054516.6080-1-ebiggers@kernel.org>
In-Reply-To: <20190603054516.6080-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:49:15 +0200
Message-ID: <CAKv+Gu-ESAdTrnHCYEV_GJcqK4_Qh4ZhF2ovWH4xzbFecEnVFA@mail.gmail.com>
Subject: Re: [PATCH] crypto: aead - un-inline encrypt and decrypt functions
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:45, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> crypto_aead_encrypt() and crypto_aead_decrypt() have grown to be more
> than a single indirect function call.  They now also check whether a key
> has been set, the decryption side checks whether the input is at least
> as long as the authentication tag length, and with CONFIG_CRYPTO_STATS=y
> they also update the crypto statistics.  That can add up to a lot of
> bloat at every call site.  Moreover, these always involve a function
> call anyway, which greatly limits the benefits of inlining.
>
> So change them to be non-inline.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/aead.c         | 36 ++++++++++++++++++++++++++++++++++++
>  include/crypto/aead.h | 34 ++--------------------------------
>  2 files changed, 38 insertions(+), 32 deletions(-)
>
> diff --git a/crypto/aead.c b/crypto/aead.c
> index 4908b5e846f0e..fc1d7ad8a487d 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -89,6 +89,42 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
>  }
>  EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
>
> +int crypto_aead_encrypt(struct aead_request *req)
> +{
> +       struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +       struct crypto_alg *alg = aead->base.__crt_alg;
> +       unsigned int cryptlen = req->cryptlen;
> +       int ret;
> +
> +       crypto_stats_get(alg);
> +       if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> +               ret = -ENOKEY;
> +       else
> +               ret = crypto_aead_alg(aead)->encrypt(req);
> +       crypto_stats_aead_encrypt(cryptlen, alg, ret);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(crypto_aead_encrypt);
> +
> +int crypto_aead_decrypt(struct aead_request *req)
> +{
> +       struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +       struct crypto_alg *alg = aead->base.__crt_alg;
> +       unsigned int cryptlen = req->cryptlen;
> +       int ret;
> +
> +       crypto_stats_get(alg);
> +       if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> +               ret = -ENOKEY;
> +       else if (req->cryptlen < crypto_aead_authsize(aead))
> +               ret = -EINVAL;
> +       else
> +               ret = crypto_aead_alg(aead)->decrypt(req);
> +       crypto_stats_aead_decrypt(cryptlen, alg, ret);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(crypto_aead_decrypt);
> +
>  static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
>  {
>         struct crypto_aead *aead = __crypto_aead_cast(tfm);
> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
> index 9ad595f97c65a..020d581373abd 100644
> --- a/include/crypto/aead.h
> +++ b/include/crypto/aead.h
> @@ -322,21 +322,7 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
>   *
>   * Return: 0 if the cipher operation was successful; < 0 if an error occurred
>   */
> -static inline int crypto_aead_encrypt(struct aead_request *req)
> -{
> -       struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -       struct crypto_alg *alg = aead->base.__crt_alg;
> -       unsigned int cryptlen = req->cryptlen;
> -       int ret;
> -
> -       crypto_stats_get(alg);
> -       if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else
> -               ret = crypto_aead_alg(aead)->encrypt(req);
> -       crypto_stats_aead_encrypt(cryptlen, alg, ret);
> -       return ret;
> -}
> +int crypto_aead_encrypt(struct aead_request *req);
>
>  /**
>   * crypto_aead_decrypt() - decrypt ciphertext
> @@ -360,23 +346,7 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
>   *        integrity of the ciphertext or the associated data was violated);
>   *        < 0 if an error occurred.
>   */
> -static inline int crypto_aead_decrypt(struct aead_request *req)
> -{
> -       struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -       struct crypto_alg *alg = aead->base.__crt_alg;
> -       unsigned int cryptlen = req->cryptlen;
> -       int ret;
> -
> -       crypto_stats_get(alg);
> -       if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
> -               ret = -ENOKEY;
> -       else if (req->cryptlen < crypto_aead_authsize(aead))
> -               ret = -EINVAL;
> -       else
> -               ret = crypto_aead_alg(aead)->decrypt(req);
> -       crypto_stats_aead_decrypt(cryptlen, alg, ret);
> -       return ret;
> -}
> +int crypto_aead_decrypt(struct aead_request *req);
>
>  /**
>   * DOC: Asynchronous AEAD Request Handle
> --
> 2.21.0
>

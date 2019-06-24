Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546E1C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 08:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 331052083D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 08:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfFXIDy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 04:03:54 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45339 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfFXIDy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 04:03:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so9061980oib.12
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 01:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQdKR3e6P3KOVxSzrChRiQwAOlZnuhWsgTUVY8GuX9M=;
        b=aeuCB3IQlJGsxF9gEl36qScWAhhcMuUw6e1MUMlubzRdoKzaY3Cc0IgozjacbIlOOA
         p3AwWs+a/KA9DKwLvTNjRnS5dHoulFl+vleJg9gGRd9ry28jF7aO1K3lWXCMeGkJ80RP
         EM43zBXeG1bdmIAciMQqltQse3GgSNXjOReXg2+tC1CQEtMrFBajqcG0qaTJWgMgk3+G
         rnICqkrFGngmIShqYtRZkVRgNnIsbTKbrNAfO7VXnwp4M9x7V6vYk2OhPuzm6HRuFMAC
         QGDC8t6XnPFAIdrHES+oQwd04oO5jt9s/njyZaZze/4jtTIuOM91sYKMCfttrhyl089p
         S42Q==
X-Gm-Message-State: APjAAAX0G8lknRV5nqU6xvIy07eBcV+Jpr5tlr425zRi+l6s543Cpoh1
        zsGOus1xH9Al7a6UkmubnraUCuz+K/TlVK58WQuS5A==
X-Google-Smtp-Source: APXvYqyqYjzo3ta2oUqyYLLNXRW4r3EL7WKEOqDGn111CcsOX3I3TFQcBNBkphIXTXILHk3S4HFm6Zrhaaz+G3dzguU=
X-Received: by 2002:aca:ab13:: with SMTP id u19mr10459881oie.127.1561363433876;
 Mon, 24 Jun 2019 01:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org> <20190624073818.29296-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20190624073818.29296-3-ard.biesheuvel@linaro.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 24 Jun 2019 10:03:42 +0200
Message-ID: <CAFqZXNs5fm9eqowmHe--Ygw4qvOXVjYnq0jOQhn5O-4gsD0vgg@mail.gmail.com>
Subject: Re: [PATCH 2/6] crypto: aegis - drop empty TFM init/exit routines
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 24, 2019 at 9:38 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> TFM init/exit routines are optional, so no need to provide empty ones.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

> ---
>  crypto/aegis128.c  | 11 -----------
>  crypto/aegis128l.c | 11 -----------
>  crypto/aegis256.c  | 11 -----------
>  3 files changed, 33 deletions(-)
>
> diff --git a/crypto/aegis128.c b/crypto/aegis128.c
> index 125e11246990..4f8f1cdef129 100644
> --- a/crypto/aegis128.c
> +++ b/crypto/aegis128.c
> @@ -403,22 +403,11 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
>         return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
>  }
>
> -static int crypto_aegis128_init_tfm(struct crypto_aead *tfm)
> -{
> -       return 0;
> -}
> -
> -static void crypto_aegis128_exit_tfm(struct crypto_aead *tfm)
> -{
> -}
> -
>  static struct aead_alg crypto_aegis128_alg = {
>         .setkey = crypto_aegis128_setkey,
>         .setauthsize = crypto_aegis128_setauthsize,
>         .encrypt = crypto_aegis128_encrypt,
>         .decrypt = crypto_aegis128_decrypt,
> -       .init = crypto_aegis128_init_tfm,
> -       .exit = crypto_aegis128_exit_tfm,
>
>         .ivsize = AEGIS128_NONCE_SIZE,
>         .maxauthsize = AEGIS128_MAX_AUTH_SIZE,
> diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
> index 9bca3d619a22..ef5bc2297a2c 100644
> --- a/crypto/aegis128l.c
> +++ b/crypto/aegis128l.c
> @@ -467,22 +467,11 @@ static int crypto_aegis128l_decrypt(struct aead_request *req)
>         return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
>  }
>
> -static int crypto_aegis128l_init_tfm(struct crypto_aead *tfm)
> -{
> -       return 0;
> -}
> -
> -static void crypto_aegis128l_exit_tfm(struct crypto_aead *tfm)
> -{
> -}
> -
>  static struct aead_alg crypto_aegis128l_alg = {
>         .setkey = crypto_aegis128l_setkey,
>         .setauthsize = crypto_aegis128l_setauthsize,
>         .encrypt = crypto_aegis128l_encrypt,
>         .decrypt = crypto_aegis128l_decrypt,
> -       .init = crypto_aegis128l_init_tfm,
> -       .exit = crypto_aegis128l_exit_tfm,
>
>         .ivsize = AEGIS128L_NONCE_SIZE,
>         .maxauthsize = AEGIS128L_MAX_AUTH_SIZE,
> diff --git a/crypto/aegis256.c b/crypto/aegis256.c
> index b47fd39595ad..b824ef4d1248 100644
> --- a/crypto/aegis256.c
> +++ b/crypto/aegis256.c
> @@ -418,22 +418,11 @@ static int crypto_aegis256_decrypt(struct aead_request *req)
>         return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
>  }
>
> -static int crypto_aegis256_init_tfm(struct crypto_aead *tfm)
> -{
> -       return 0;
> -}
> -
> -static void crypto_aegis256_exit_tfm(struct crypto_aead *tfm)
> -{
> -}
> -
>  static struct aead_alg crypto_aegis256_alg = {
>         .setkey = crypto_aegis256_setkey,
>         .setauthsize = crypto_aegis256_setauthsize,
>         .encrypt = crypto_aegis256_encrypt,
>         .decrypt = crypto_aegis256_decrypt,
> -       .init = crypto_aegis256_init_tfm,
> -       .exit = crypto_aegis256_exit_tfm,
>
>         .ivsize = AEGIS256_NONCE_SIZE,
>         .maxauthsize = AEGIS256_MAX_AUTH_SIZE,
> --
> 2.20.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.

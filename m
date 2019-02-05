Return-Path: <SRS0=AMvw=QM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2480BC282CB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02E420844
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfBEJbl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:31:41 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45954 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfBEJbl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Feb 2019 04:31:41 -0500
Received: by mail-ot1-f65.google.com with SMTP id 32so4521861ota.12
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2019 01:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bN9/2HSDmRF/WRFG+PwFoIg88KTpGVHD/p/tGFiyyY=;
        b=nsEVJxO/vpkI1DPGHRYPgEE/3D/NTLMmjGRJO7qDnb0zBaBlone8D2+QfGSjdGuzqp
         m9SnBJVTuTiuajPFXwhNJBpIcqZPsrPrFxAWICJTwAnFZzUWHV7XdF6+/FOAlzeMg8Nb
         4GGmk+B+bcFdzrQgSJ5pJpP2HXerG0nNncIaQiDmed7lFKrBu/fv1RNxDY1X0LH7yVL8
         KCGHdFjhdHLI9OQQfpfi2ebQbwUVicANKwbPo8mEr7BydekplqcY3Pb/v6w5pNniTKje
         n5cNg3JePJdbB40vsdLTp3OcoQZOoXV0PRhclYukc2UwP/uqH9Nj7cANuXfzTQ+vZTbD
         EPfw==
X-Gm-Message-State: AHQUAuYIFr/fMEiU0LGyrQm52XyLdL0chP7nw/48pQXxmt16gZr8LkAr
        p22XPa6gwdEdBPsmYUS/UN9R/h5ujN9CFjF4J6nF8Q==
X-Google-Smtp-Source: AHgI3Ia4Kb1Nm8t2f22myDzefqJzvvXHy2sRmyoha4sNzOtviWs08DJGJEWSXFug+0Cb0YA8AXlrAcrKFfjTE80HNOQ=
X-Received: by 2002:a9d:5d2:: with SMTP id 76mr2061385otd.78.1549359100418;
 Tue, 05 Feb 2019 01:31:40 -0800 (PST)
MIME-Version: 1.0
References: <20190201075150.18644-1-ebiggers@kernel.org> <20190201075150.18644-2-ebiggers@kernel.org>
In-Reply-To: <20190201075150.18644-2-ebiggers@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 5 Feb 2019 10:31:29 +0100
Message-ID: <CAFqZXNtOMGH2wsSBe11H82-6=m2o0B3PfZPBamK=46ic6+wK3A@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] crypto: aegis - fix handling chunked inputs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 1, 2019 at 8:52 AM Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The generic AEGIS implementations all fail the improved AEAD tests
> because they produce the wrong result with some data layouts.  The issue
> is that they assume that if the skcipher_walk API gives 'nbytes' not
> aligned to the walksize (a.k.a. walk.stride), then it is the end of the
> data.  In fact, this can happen before the end.  Fix them.
>
> Fixes: f606a88e5823 ("crypto: aegis - Add generic AEGIS AEAD implementations")
> Cc: <stable@vger.kernel.org> # v4.18+
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

> ---
>  crypto/aegis128.c  | 14 +++++++-------
>  crypto/aegis128l.c | 14 +++++++-------
>  crypto/aegis256.c  | 14 +++++++-------
>  3 files changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/crypto/aegis128.c b/crypto/aegis128.c
> index 96e078a8a00a1..3718a83413032 100644
> --- a/crypto/aegis128.c
> +++ b/crypto/aegis128.c
> @@ -286,19 +286,19 @@ static void crypto_aegis128_process_crypt(struct aegis_state *state,
>                                           const struct aegis128_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *src, *dst;
> -       unsigned int chunksize;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, chunksize);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>  }
>
> diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
> index a210e779b911b..275a8616d71bd 100644
> --- a/crypto/aegis128l.c
> +++ b/crypto/aegis128l.c
> @@ -349,19 +349,19 @@ static void crypto_aegis128l_process_crypt(struct aegis_state *state,
>                                            const struct aegis128l_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *src, *dst;
> -       unsigned int chunksize;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, chunksize);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>  }
>
> diff --git a/crypto/aegis256.c b/crypto/aegis256.c
> index 49882a28e93e9..ecd6b7f34a2d2 100644
> --- a/crypto/aegis256.c
> +++ b/crypto/aegis256.c
> @@ -299,19 +299,19 @@ static void crypto_aegis256_process_crypt(struct aegis_state *state,
>                                           const struct aegis256_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *src, *dst;
> -       unsigned int chunksize;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> -               chunksize = walk.nbytes;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, chunksize);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>  }
>
> --
> 2.20.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.

Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46C1C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 07:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BED72171F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 07:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZUezO3zB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfCMHuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:50:19 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55253 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfCMHuT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 03:50:19 -0400
Received: by mail-it1-f193.google.com with SMTP id w18so1336218itj.4
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 00:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QzFq2hChMls5Kx3OeofansiC04IDD29dSFjA41vtf2M=;
        b=ZUezO3zBTAg/q00BVKOOKBZXK4zbKi2Z3rmDi6Pzgz5Rjra+/MfB4k2tlKbN9s8DxI
         pNJua5ZC5sv3g2P2EU31uW2nVKHNNyGDPHg/W21B3iBOaptvokcDm3LQe9gR+47NcWQf
         nfFHXZ2LZJcp5uY81XJgc+bwNGFyjOFecWR9dQUy8J2kvz6/lx6rrimTv2ra5M7vUnn8
         9fSH7xwbqjpvhT/0J66VPMs7PvUHJXyn0nAwb+X0NSItnNNFO3LDxr90cEPD91dz/LFL
         dFOMo8CdeCLtEaHHFAZInapQQSvgz3jvSgzwn2DH9ciSRo0hHWOz7zBPb4Xxmxe1/WN6
         F5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QzFq2hChMls5Kx3OeofansiC04IDD29dSFjA41vtf2M=;
        b=oWMtuVoQOud1BaJbbcqQsoayVb1gKVrm25A4RY3j4Z9sRi4M1iH6NdJapeFQFdemQn
         EBCXY51/uK45/45esiqsitpHBksk/eCdlcKzUBNsRYHsKtITOivE8P1/CkIZ9rqPKkfA
         b3NahTvlEq+KyOg2PmcD1oC0lQJWiM1qw5wcQQFhRyiDKwumRijv/7xxkFcf4dtE99fc
         yBhDef0ahmovoHQa5wRDEHnnVuk2wjOwAKsGUaZ0B6ZwkR70jvuMnWgqZ32lZxigtqSV
         y4r5yu4CY56M5tIX/yqXkYlXzSy3G1Xz3XvpHBhn75bH0/mRFAm54fsh2c17Zf3jv9KH
         xWDw==
X-Gm-Message-State: APjAAAWZuVHKKT3Tp0s9yO+Rtlwd0DQEmdnZAS7XFkzWS1hqP8liylMZ
        zUuZbf0Dy2meccNroGJVVSOnxVBWMc9Qgre2JwxG+svF
X-Google-Smtp-Source: APXvYqwEvW9HXuI1zH7bbUjlnG6bU4aw4PJ69Cqg/ybT8jPgfaZmOVhpU+TmJlZUWnQ4zFdxGocsRD5azS3dqBcktFU=
X-Received: by 2002:a02:3342:: with SMTP id k2mr21896952jak.62.1552463418508;
 Wed, 13 Mar 2019 00:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-2-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-2-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 08:50:07 +0100
Message-ID: <CAKv+Gu9XA8h41xZSKqk3+NH6Yx9t6-sbRw-uhXSZWFtOqAa0eQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] crypto: chacha-generic - fix use as arm64 no-NEON fallback
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
> The arm64 implementations of ChaCha and XChaCha are failing the extra
> crypto self-tests following my patches to test the !may_use_simd() code
> paths, which previously were untested.  The problem is as follows:
>
> When !may_use_simd(), the arm64 NEON implementations fall back to the
> generic implementation, which uses the skcipher_walk API to iterate
> through the src/dst scatterlists.  Due to how the skcipher_walk API
> works, walk.stride is set from the skcipher_alg actually being used,
> which in this case is the arm64 NEON algorithm.  Thus walk.stride is
> 5*CHACHA_BLOCK_SIZE, not CHACHA_BLOCK_SIZE.
>
> This unnecessarily large stride shouldn't cause an actual problem.
> However, the generic implementation computes round_down(nbytes,
> walk.stride).  round_down() assumes the round amount is a power of 2,
> which 5*CHACHA_BLOCK_SIZE is not, so it gives the wrong result.
>
> This causes the following case in skcipher_walk_done() to be hit,
> causing a WARN() and failing the encryption operation:
>
>         if (WARN_ON(err)) {
>                 /* unexpected case; didn't process all bytes */
>                 err = -EINVAL;
>                 goto finish;
>         }
>
> Fix it by rounding down to CHACHA_BLOCK_SIZE instead of walk.stride.
>
> (Or we could replace round_down() with rounddown(), but that would add a
> slow division operation every time, which I think we should avoid.)
>
> Fixes: 2fe55987b262 ("crypto: arm64/chacha - use combined SIMD/ALU routine for more speed")
> Cc: <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/chacha_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> index 35b583101f4f..90ec0ec1b4f7 100644
> --- a/crypto/chacha_generic.c
> +++ b/crypto/chacha_generic.c
> @@ -52,7 +52,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> -                       nbytes = round_down(nbytes, walk.stride);
> +                       nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
>
>                 chacha_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
>                                nbytes, ctx->nrounds);
> --
> 2.21.0
>

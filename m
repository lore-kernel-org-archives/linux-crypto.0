Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9692CC282C6
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 12:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6764C20855
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 12:11:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="KeJi9ktC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfAXMLg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 07:11:36 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40861 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfAXMLg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 07:11:36 -0500
Received: by mail-io1-f65.google.com with SMTP id k2so4513306iog.7
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 04:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e7C6zUR07TLT9ym38kesf+PfYGHS00+KJqk/gsJOPwA=;
        b=KeJi9ktC73hG0Edi7qu7Tmvvn/boBH9yI43KQGl/d7UDP2uzWDvDimjGv+cul9CoKW
         UPAzcpbWYE1HxIr9dz4iTvWqrkB5MoQGvBlFuAozh3t3JVWLw7lD8MG5kATzd9cYcVHk
         YN8LJ5i1uETsG7w5QQpYEMgpOtg5JO/8CsGlA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e7C6zUR07TLT9ym38kesf+PfYGHS00+KJqk/gsJOPwA=;
        b=SNH5nc1UdeE1MIxH1IZiqg1FVTDecBVN7NQkp+0BuUtPf4RAXIemNvGCaM1qHmN1rl
         uXXWhyx2JeQhY6503z8/2g8zuaYF1/f2zRcAtjuq2E98xovN0X3bWlFZpQDTYkGXQaiF
         A1sreZX2fwfwpCHqrhJxDH5J2GvYJyzhkaeBn81FsYXtOxdjx8B7+ffNrDWmJRbkv8PE
         0XH3nSHBdMuSyonZR9Jl0iPguk/8ujVBy7QAcYhNLC/3S1ZAf3Sgdqx8GBJhVKRtkYaP
         NeCAMUBSgbFgLOr2EeyIl/FEq12//N+B246WcIkuj57KliFQAbmtTJkDKV3mdx/T/an/
         YMhg==
X-Gm-Message-State: AHQUAuagTOz5VtqcJ1LwXWXFCkrnn0IiuswM2kDqY6O45zL/ZeZLnk1L
        D99uEs4mOXHX7uOymj6WNZ0g4lAI2ieKO5Pmp2ctKNa7GZS4XA==
X-Google-Smtp-Source: AHgI3IZLSkcCGV0++rXRWvh7AAga1FfnNCIMra2nStLvcMeOpy4IUuJLOsNPI6DKmWiJme14rp4bRKhVtfTItlpTXhg=
X-Received: by 2002:a5e:c206:: with SMTP id v6mr3814134iop.60.1548331895362;
 Thu, 24 Jan 2019 04:11:35 -0800 (PST)
MIME-Version: 1.0
References: <20190123224926.250525-1-ebiggers@kernel.org> <20190123224926.250525-8-ebiggers@kernel.org>
In-Reply-To: <20190123224926.250525-8-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 24 Jan 2019 13:11:23 +0100
Message-ID: <CAKv+Gu_6ZhXVKZwgkiSh0ZvvgjXGS+ygz9b6E0QmCP8ViJrbmw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 07/15] crypto: arm64/aes-neonbs - fix returning
 final keystream block
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Jan 2019 at 23:52, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The arm64 NEON bit-sliced implementation of AES-CTR fails the improved
> skcipher tests because it sometimes produces the wrong ciphertext.  The
> bug is that the final keystream block isn't returned from the assembly
> code when the number of non-final blocks is zero.  This can happen if
> the input data ends a few bytes after a page boundary.  In this case the
> last bytes get "encrypted" by XOR'ing them with uninitialized memory.
>
> Fix the assembly code to return the final keystream block when needed.
>
> Fixes: 88a3f582bea9 ("crypto: arm64/aes - don't use IV buffer to return final keystream block")
> Cc: <stable@vger.kernel.org> # v4.11+
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/aes-neonbs-core.S | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> index e613a87f8b53..8432c8d0dea6 100644
> --- a/arch/arm64/crypto/aes-neonbs-core.S
> +++ b/arch/arm64/crypto/aes-neonbs-core.S
> @@ -971,18 +971,22 @@ CPU_LE(   rev             x8, x8          )
>
>  8:     next_ctr        v0
>         st1             {v0.16b}, [x24]
> -       cbz             x23, 0f
> +       cbz             x23, .Lctr_done
>
>         cond_yield_neon 98b
>         b               99b
>
> -0:     frame_pop
> +.Lctr_done:
> +       frame_pop
>         ret
>
>         /*
>          * If we are handling the tail of the input (x6 != NULL), return the
>          * final keystream block back to the caller.
>          */
> +0:     cbz             x25, 8b
> +       st1             {v0.16b}, [x25]
> +       b               8b
>  1:     cbz             x25, 8b
>         st1             {v1.16b}, [x25]
>         b               8b
> --
> 2.20.1.321.g9e740568ce-goog
>

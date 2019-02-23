Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4143C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 09:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 881DD206BA
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 09:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ixwMxwKj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfBWJY2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 04:24:28 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:47031 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfBWJY1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 04:24:27 -0500
Received: by mail-io1-f67.google.com with SMTP id k21so3744926ior.13
        for <linux-crypto@vger.kernel.org>; Sat, 23 Feb 2019 01:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5GEK9T81wP2kkW0fGPs84l3c71v8YZl8ebkkAOY+AUg=;
        b=ixwMxwKjOA02jOAfKReQH+U5dJf/7Bmtwf3QJaS+JfgRgYPnSWd5rEmC/uXwj2AYMk
         rs6WjAxjqWUcRnYQ3aJQwfS6XDolm1/HJ0QMKQgWAsoxsXjD3INaSmPG6W+FBEZh3GHR
         iLEb3JvdCg+cj5xo1eu+ew9JvCx3XyMVvLh+uYNOpKOMN77gpTaOn4gQK3FJuIdh6xeP
         bYEJGvxIRRVEQOtSim17Pgc6VMH0MlTsesDvi36k5ju7kEtGEckI/s2lDfkHS3NzPpwF
         T2YKr/R0h1D439jYfUHew7HaQWOb00Yz1tCOjmNU6ClDFvs9HfpolhOGME1KCw3Qd/D1
         VUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5GEK9T81wP2kkW0fGPs84l3c71v8YZl8ebkkAOY+AUg=;
        b=exV18Wvj93P3Tnlm/xmWO/KybUytWB8shB4H1SKSukImsxorBcMpJsCMvMbUcC5CET
         ktmUEswUmzwpJezsBo9lB3e/qOgHPIaVhWbL/DiYr2uapLWMytMn+JqTi3YnqnAQoDt2
         0NkULWXnMqSHER54M3O4H3f1RUuop5ylbl2YrRN/5cgS14qF2h898Td1vtF45BeNnkMc
         ZUuBrk0RdL4ClPHKwjd/U8vVMigJlTSvTj5mSh3Wht6Dnii6cUn6ofzcI3MtYGxMFGBs
         sFile0sapfgjnO+l3pmZepsVYSqnWlf2SR/KiLXhXluqXtITVfdhi1SsRZ2K51JjFRr3
         IcNA==
X-Gm-Message-State: AHQUAuahI36oGyX27STvt5cyWTHKpsCfIA/WwY5Jed/EIiMhvht3YMRn
        tNnuPlN+4AGAibdLs3BPdIM5rI/tbKFgtbHoTJkwQVl3DyQ=
X-Google-Smtp-Source: AHgI3IYioZEEo5dn3jF15pSfs4EhC5bMFtq0C3+fDzEYnTq5fNsnlhhErGYj6uKxNsjXoUV9gFrOfFC5rQ+QUsxPgto=
X-Received: by 2002:a5e:d609:: with SMTP id w9mr4457196iom.170.1550913866814;
 Sat, 23 Feb 2019 01:24:26 -0800 (PST)
MIME-Version: 1.0
References: <20190223065408.6279-1-ebiggers@kernel.org> <20190223065408.6279-3-ebiggers@kernel.org>
In-Reply-To: <20190223065408.6279-3-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 23 Feb 2019 10:24:15 +0100
Message-ID: <CAKv+Gu99nQc-eoOu4=Vxzmc0ypYecYhSThmsr3gu4T84tYStOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: arm64/chacha - fix hchacha_block_neon() for
 big endian
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 23 Feb 2019 at 07:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> On big endian arm64 kernels, the xchacha20-neon and xchacha12-neon
> self-tests fail because hchacha_block_neon() outputs little endian words
> but the C code expects native endianness.  Fix it to output the words in
> native endianness (which also makes it match the arm32 version).
>
> Fixes: cc7cf991e9eb ("crypto: arm64/chacha20 - add XChaCha20 support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/chacha-neon-core.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
> index bfb80e10ff7b0..706c4e10e9e29 100644
> --- a/arch/arm64/crypto/chacha-neon-core.S
> +++ b/arch/arm64/crypto/chacha-neon-core.S
> @@ -158,8 +158,8 @@ ENTRY(hchacha_block_neon)
>         mov             w3, w2
>         bl              chacha_permute
>
> -       st1             {v0.16b}, [x1], #16
> -       st1             {v3.16b}, [x1]
> +       st1             {v0.4s}, [x1], #16
> +       st1             {v3.4s}, [x1]
>
>         ldp             x29, x30, [sp], #16
>         ret
> --
> 2.20.1
>

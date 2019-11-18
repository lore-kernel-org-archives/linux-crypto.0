Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F74BC432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61E332075E
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dkEgJKKA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfKRH0m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:26:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40424 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfKRH0l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 02:26:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id q15so5299423wrw.7
        for <linux-crypto@vger.kernel.org>; Sun, 17 Nov 2019 23:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CDTJd128md3v8wiU1+Y74i2GEhRoIFw85EUJsBjzYok=;
        b=dkEgJKKAyUBU/NxfC8ZfNVMvQId/YvMNoF7hYhzlPqEI8d8ELjaSvXZ3qPf9pvD8N/
         xfxcd1FTpcqT6dCl0dh9u/fbwIJyOqMfHnruhW51Qv4LeKbJD3ol8cnGIzR1jlJ6PWrm
         +6G3cfqKieNU9/ykk1DZYEYA7wujRdNPBIVmbacHtBYLs6v+P5bBc3s5CJ9PcnU9xyO1
         MMTmiT8qwrFm9rasKLnbiMMhW2jFyF00wO7KcXSyR2yYxjUX9lV30PiZRalHFIHgUpbd
         pE8Yyrap/9+XBtGgQE0tJi+2m0GnBo3QO/TkYEW+EA2e9sdOA1iJLLMy0AVhcG3YEg8O
         CA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CDTJd128md3v8wiU1+Y74i2GEhRoIFw85EUJsBjzYok=;
        b=YuS5hxhEz7zSElhRBo8wAgAiUvPm9SUfPYwm3vvUkAkxBiXY5RWgSjTKB7SxReAUv7
         wAdspPItWtyOZCyG2aLPXq4sUzWw9PDIbDbTdLopD3cZ6CuhpZgbBZcScezpswHHppmd
         d6nbIBWE0+QdXe5Kia0t1QnMy7FTnwSCPFPYyA+S2wNHLIeDIKQ7BgBzeYOyyKXY5Unk
         nVD85Qyy6g9e8dyCh+o5EaNeN+kCWQqf7C6gb1iUMEw4pEw0/afWDAh/ek3fZRCo5sF5
         03khXhFXadJHKzPMeE9eXsx4Nv4AVqxcqdCWqcKavtgV2mcUTYU320gfE0m4JJMC9qDH
         51hQ==
X-Gm-Message-State: APjAAAXaLqSfmTzi28NFHSefl9eTyt1ath/fRtFu903a4uzDJH/8bazE
        Wal68NVkfJDGjdLDzMNkKWL+LRl0KcKz3EvoRWE9iQ==
X-Google-Smtp-Source: APXvYqzXHr28Sfyoh9tHS2xLKkjN75yttwMaPNTJ6lzoEdIHSyIh716vQfxTfqE3Ij24yNTAk8b0JGnpVhDi6POXv1A=
X-Received: by 2002:adf:f743:: with SMTP id z3mr27322448wrp.200.1574061999997;
 Sun, 17 Nov 2019 23:26:39 -0800 (PST)
MIME-Version: 1.0
References: <20191118072158.467616-1-ebiggers@kernel.org>
In-Reply-To: <20191118072158.467616-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 18 Nov 2019 08:26:28 +0100
Message-ID: <CAKv+Gu8K3v5_ChH57bA7BKkXCzNA9Xrv5XD4eaeKGk64ZigDzQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/chacha - only unregister algorithms if registered
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

On Mon, 18 Nov 2019 at 08:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> It's not valid to call crypto_unregister_skciphers() without a prior
> call to crypto_register_skciphers().
>
> Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/x86/crypto/chacha_glue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index b391e13a9e41..a94e30b6f941 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -304,7 +304,8 @@ static int __init chacha_simd_mod_init(void)
>
>  static void __exit chacha_simd_mod_fini(void)
>  {
> -       crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
> +       if (boot_cpu_has(X86_FEATURE_SSSE3))
> +               crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
>  }
>
>  module_init(chacha_simd_mod_init);
> --
> 2.24.0
>

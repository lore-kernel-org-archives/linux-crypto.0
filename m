Return-Path: <SRS0=phSf=Q6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D217C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 09:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32F9206BA
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Feb 2019 09:21:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yyKmattx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfBWJVh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Feb 2019 04:21:37 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:54550 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfBWJVg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Feb 2019 04:21:36 -0500
Received: by mail-it1-f194.google.com with SMTP id w18so5195995itj.4
        for <linux-crypto@vger.kernel.org>; Sat, 23 Feb 2019 01:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jO2yAy+2/DrGSuo8Mb/2diw4loSjrfq9Z9UTiFMxaQ4=;
        b=yyKmattxVj5pg78ekQ65pQNhpw1n5/CyCPH/x00PTR341Vd8ivampTF3P4iw326cyQ
         G/06KZbOriMDdU0Y3h4kMXA7Z44TAI/CPV4ykrEaNM0e1pdD0k8U2rRO6QGlhJiVndUY
         qtomCIF0tqD0YnytekB/4dO+WLfsJ4O4NH7q8w6+WVk+l+om+OSPXocHIipm83t5Fo6J
         YcTpOqvjSnPLBlWPrHAuBFmVq4SMpB3t0+j69BHsCTNJTXfw7J75qq5tn3QnedvcTzhR
         rfeq45QZif5Ivl2JrPmT5+3NADVgi6FPn74jxkQXfas9vrdmY88v6Lwxq3Nvaq7LgodR
         8KNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jO2yAy+2/DrGSuo8Mb/2diw4loSjrfq9Z9UTiFMxaQ4=;
        b=AEFO8l3epS6nbyY8bjJbV9CeDXZ90tCAiVODGrGCYF17QgqBXJewCZKdpZenZIkAEU
         ehdkaonTRQr5sSBH6/mu7ChpczwYnNmeCmYR9jrOCmCrsPdHb0AhAUbeF3uPDQyLgQRd
         or+siIdpmgktyvAfrIVrZupCeDN+kWXi9+eGoXiM6bvuVSyF3njkJZcYsmTmZoea+8X9
         Zn2dgZj+hRLmc/Ngb57l0s06dAb4aFJFEqipmJU9XSFA90aGMo6InSMTvv4fjpnMJhU1
         7x3/Lk3PEk45czHZ4gcSwEp/A2f4WxP50Jfstyi6UpuuvosMpMJnZVOx+EeK4e5bC0I8
         0Pfg==
X-Gm-Message-State: AHQUAualFqEf3R8+JN5ehVuAHRLlFrUhzxByOuOXB+IqwZKqYDzsVGjK
        AaQjg0Mx1qrlGi/ttzvhT7DIDDwiklrdFIjqXitzMsLn
X-Google-Smtp-Source: AHgI3IaRcsHtDW03uNXc2vPh39oKd8T5aDPBY3IdBwUmNcWxxEeVF+l9ASj0wvdJKSBzqwcHUcuQRRW74/hyja/uC0Y=
X-Received: by 2002:a02:3342:: with SMTP id k2mr4439773jak.62.1550913695492;
 Sat, 23 Feb 2019 01:21:35 -0800 (PST)
MIME-Version: 1.0
References: <20190223065408.6279-1-ebiggers@kernel.org> <20190223065408.6279-2-ebiggers@kernel.org>
In-Reply-To: <20190223065408.6279-2-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 23 Feb 2019 10:21:22 +0100
Message-ID: <CAKv+Gu-4dwMsukX9jf9U0GfCOtd7cGfaRfSeJ+xL+4cqBAsDmg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: arm64/chacha - fix chacha_4block_xor_neon()
 for big endian
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
> The change to encrypt a fifth ChaCha block using scalar instructions
> caused the chacha20-neon, xchacha20-neon, and xchacha12-neon self-tests
> to start failing on big endian arm64 kernels.  The bug is that the
> keystream block produced in 32-bit scalar registers is directly XOR'd
> with the data words, which are loaded and stored in native endianness.
> Thus in big endian mode the data bytes end up XOR'd with the wrong
> bytes.  Fix it by byte-swapping the keystream words in big endian mode.
>
> Fixes: 2fe55987b262 ("crypto: arm64/chacha - use combined SIMD/ALU routine for more speed")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/chacha-neon-core.S | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
> index 021bb9e9784b2..bfb80e10ff7b0 100644
> --- a/arch/arm64/crypto/chacha-neon-core.S
> +++ b/arch/arm64/crypto/chacha-neon-core.S
> @@ -532,6 +532,10 @@ ENTRY(chacha_4block_xor_neon)
>         add             v3.4s, v3.4s, v19.4s
>           add           a2, a2, w8
>           add           a3, a3, w9
> +CPU_BE(          rev           a0, a0          )
> +CPU_BE(          rev           a1, a1          )
> +CPU_BE(          rev           a2, a2          )
> +CPU_BE(          rev           a3, a3          )
>
>         ld4r            {v24.4s-v27.4s}, [x0], #16
>         ld4r            {v28.4s-v31.4s}, [x0]
> @@ -552,6 +556,10 @@ ENTRY(chacha_4block_xor_neon)
>         add             v7.4s, v7.4s, v23.4s
>           add           a6, a6, w8
>           add           a7, a7, w9
> +CPU_BE(          rev           a4, a4          )
> +CPU_BE(          rev           a5, a5          )
> +CPU_BE(          rev           a6, a6          )
> +CPU_BE(          rev           a7, a7          )
>
>         // x8[0-3] += s2[0]
>         // x9[0-3] += s2[1]
> @@ -569,6 +577,10 @@ ENTRY(chacha_4block_xor_neon)
>         add             v11.4s, v11.4s, v27.4s
>           add           a10, a10, w8
>           add           a11, a11, w9
> +CPU_BE(          rev           a8, a8          )
> +CPU_BE(          rev           a9, a9          )
> +CPU_BE(          rev           a10, a10        )
> +CPU_BE(          rev           a11, a11        )
>
>         // x12[0-3] += s3[0]
>         // x13[0-3] += s3[1]
> @@ -586,6 +598,10 @@ ENTRY(chacha_4block_xor_neon)
>         add             v15.4s, v15.4s, v31.4s
>           add           a14, a14, w8
>           add           a15, a15, w9
> +CPU_BE(          rev           a12, a12        )
> +CPU_BE(          rev           a13, a13        )
> +CPU_BE(          rev           a14, a14        )
> +CPU_BE(          rev           a15, a15        )
>
>         // interleave 32-bit words in state n, n+1
>           ldp           w6, w7, [x2], #64
> --
> 2.20.1
>

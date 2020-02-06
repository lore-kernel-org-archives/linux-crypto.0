Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C594FC352A2
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5F221927
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YydT7Nnq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgBFLr1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:47:27 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35157 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgBFLr0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 06:47:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id b17so6730341wmb.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 03:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KveIEjp3HbjihFmRx/reDDqbhCsUHinvQ25+hm8C1tk=;
        b=YydT7NnqGWyCRETCnbqdZJelhTj3IjqHBm3cOFxMglAa5HD8pV5kRCUc+0VIvBGvYw
         a/DaOnEA1ohejoUwsAb0hJtvS1iQMeo9SgNZGcaSHPBhgJ+4I0nMSzeC7xZSSM7wFqOA
         T1Btc68A7zYHLjxEGIWOFOnq+JutvVu1EMvtUTmhgeQLMvzo/sgvZ8vDg+mOalqiZZne
         D+3z10BLeC6D6Wta8BlWq+cSkD+WQjna5r9GKka5AHRieWMp2ZouSYy1DV5LQJqLIF6v
         TDKd7xBbOd+/Vrx/rQLOoUGKprU02AkUEAx7dhpxSHo94aLPlHHisOsUlUp8HUtJWnSs
         iK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KveIEjp3HbjihFmRx/reDDqbhCsUHinvQ25+hm8C1tk=;
        b=aTUHV/1p1jYMkN2OPlwDNuwpt4YRECDqwLke98NUKSOKZoJ1R4F1FT/HfbwSdPNi+/
         J631x37lPX+ZLBYMqhTRlGXO/BajAOKelk4iGcR/ypUqVijlcZpHYEGQrHeSECiGeWmP
         pYIpeDUo3w9NEPgn+2yV8kyj9M/6hCMyrb/XbEUc+vl0pFNSIlat6iaH/KIOAswota86
         pNL5qH8dh7tFMF2mX/nFzO3ifjusy2d863nCwdb83+wGzhCS7+RR4O4xYum3KpfUB/fN
         7sFbv3Qmrjf8Fpwzyr1qouMQPoPoBpj6TCx+8chjtSnF8fLPDYbpG6k396lnvdspA32S
         0qLw==
X-Gm-Message-State: APjAAAXhxBhXdpeBQdw31gXpSzlfFXt6p2SFzwPv21rJPfMxzpdz2yf+
        mn6askrSfw7XQ7OWLTyyO0hbESyjd6SBezt9n6D0Gw==
X-Google-Smtp-Source: APXvYqz0pB4pNruOvBQuGoGmwPVUwhdG3TW6OXes1JdtPNQDwzJU4cUTFVB8rrrsurVuigJ8IZmvGhyqeU0MrSnjXE0=
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr4140541wmj.1.1580989645523;
 Thu, 06 Feb 2020 03:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20200206114201.25438-1-Jason@zx2c4.com>
In-Reply-To: <20200206114201.25438-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Feb 2020 11:47:14 +0000
Message-ID: <CAKv+Gu8Zh3XmZVySHxHNX4Tgh22JFd0C7mJUGz5YBSEhxfCF6g@mail.gmail.com>
Subject: Re: [PATCH stable] crypto: chacha20poly1305 - prevent integer
 overflow on large input
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 6 Feb 2020 at 11:42, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> This code assigns src_len (size_t) to sl (int), which causes problems
> when src_len is very large. Probably nobody in the kernel should be
> passing this much data to chacha20poly1305 all in one go anyway, so I
> don't think we need to change the algorithm or introduce larger types
> or anything. But we should at least error out early in this case and
> print a warning so that we get reports if this does happen and can look
> into why anybody is possibly passing it that much data or if they're
> accidently passing -1 or similar.
>
> Fixes: d95312a3ccc0 ("crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine")
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org # 5.5+
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/chacha20poly1305.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index 6d83cafebc69..ad0699ce702f 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -235,6 +235,9 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>                 __le64 lens[2];
>         } b __aligned(16);
>
> +       if (WARN_ON(src_len > INT_MAX))
> +               return false;
> +
>         chacha_load_key(b.k, key);
>
>         b.iv[0] = 0;
> --
> 2.25.0
>

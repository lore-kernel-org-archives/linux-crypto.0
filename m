Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F630C001B0
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jul 2023 09:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbjGMJoq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jul 2023 05:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbjGMJo3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2023 05:44:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9FC4214;
        Thu, 13 Jul 2023 02:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3030B61AD8;
        Thu, 13 Jul 2023 09:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FACAC433CA;
        Thu, 13 Jul 2023 09:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689241370;
        bh=ORLqydtVMM+8rB9hFmMafDUI3s1uL+5DcG+3sInL+9Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jAG4H0o3rgs8CaGEFPo3CY2gdh+2RpQpyZwKMcK7xRHYpzn9UklAVZRZhsxtUusOm
         2d94ZUobSdlc+h6ESf/qLgNqdZrXiXiLT9u4o19qZ2A3EU2sa9KiYkJ3NJBXsUlJyW
         9jfM82t+wO4egp7Kjf9LvFkeqRrzr9nRt6oreO2A4bJX9tVEIqUDCcNemcikrNS/Hi
         bmKtjwHC+anUUB6zzurOqIWmCC4ghjiaMM0T8mm8Ny5IA0VueObyYUJ1vs8zZ41bR1
         h5VT2E3gnEOsV11AIy4YTIM6qcci3dJij5ujDleWqQXXRxGha9afz3URCwV/KHm4df
         FQUZYwiph7uyw==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b703cbfaf5so6710461fa.1;
        Thu, 13 Jul 2023 02:42:50 -0700 (PDT)
X-Gm-Message-State: ABy/qLYsMeLspvI3MfnHjcULN0IzLT6jis/iG8DLWyUreM+7Z2+CIFyN
        x1aBhf7VCGsrYH6gwqv2I/XqzzlRSpD2akz8jOw=
X-Google-Smtp-Source: APBJJlEvvKmCxhCjOsdBb4l+vHb6SbHZlkQVchTGXMqcq0ZPY9+mNSyWmawnS+Hv6wj2rs0hdv4lEyZJw38ajqmA3Yo=
X-Received: by 2002:a2e:878b:0:b0:2b6:dc50:19ac with SMTP id
 n11-20020a2e878b000000b002b6dc5019acmr1071789lji.31.1689241368585; Thu, 13
 Jul 2023 02:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_0DF4FE9D6A06DCE7069F936CA2A8154EC105@qq.com> <e6744137bd60578811fa763b39f50cf0@208suo.com>
In-Reply-To: <e6744137bd60578811fa763b39f50cf0@208suo.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Jul 2023 11:42:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFWQ1=mKytEpVxuKvV=vqqKtZqM+g3FkW35md9FYspe-Q@mail.gmail.com>
Message-ID: <CAMj1kXFWQ1=mKytEpVxuKvV=vqqKtZqM+g3FkW35md9FYspe-Q@mail.gmail.com>
Subject: Re: [PATCH] crypto:space required before the open brace '{'
To:     chenqingyun001@208suo.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 13 Jul 2023 at 10:59, <chenqingyun001@208suo.com> wrote:
>
> Maintain code readability and style consistency
>
> Signed-off-by: Qingyun Chen <chenqingyun001@208suo.com>

NAK

This is a cast operation, which doesn't require a trailing space.

If the tool you are using misidentifies this, please fix the tool instead.


> ---
>   arch/arm64/crypto/ghash-ce-glue.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/ghash-ce-glue.c
> b/arch/arm64/crypto/ghash-ce-glue.c
> index 97331b454ea8..cb1cd161c022 100644
> --- a/arch/arm64/crypto/ghash-ce-glue.c
> +++ b/arch/arm64/crypto/ghash-ce-glue.c
> @@ -241,7 +241,7 @@ static int gcm_aes_setkey(struct crypto_aead *tfm,
> const u8 *inkey,
>       if (ret)
>           return -EINVAL;
>
> -    aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
> +    aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]) {});
>
>       /* needed for the fallback */
>       memcpy(&ctx->ghash_key.k, key, GHASH_BLOCK_SIZE);

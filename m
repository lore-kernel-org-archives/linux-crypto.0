Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62CAC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Mar 2022 16:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbiCaQFB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Mar 2022 12:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbiCaQE4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Mar 2022 12:04:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFE91F1278
        for <linux-crypto@vger.kernel.org>; Thu, 31 Mar 2022 09:02:37 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bh17so269530ejb.8
        for <linux-crypto@vger.kernel.org>; Thu, 31 Mar 2022 09:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sweetwater-ai.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UOsM5fHRpbJTbGazwZ9GiS6zVSzVYyLU6fFhBXbjeRM=;
        b=BiUxkq9eAqApCSa7neVYcwP2HDDyO/cyl5dYWiP8k9WjKNqodLI7mhlEJsDAwvv5nG
         rimdHaw4zzHiI3v+GM1Gwu3n0m+bFjis9ht4sYTb3tLnrxyi3ZpdoZ+G09zk6NMK3V3h
         nGWQSW6hGRvqIdo5fpsKAhwM5CYXwdhqm055ttZkqUjCvC94NUJIOXUv0vdkgYFhDSLs
         UcsxpINNa0aNxWnzBuQzsr+5bZMfYrxQmclnkRK6sRVr4UZoSNNwhz/419yUR3V9vy5s
         Y3bKN2nKfp/hQwMBFBxeI1D/JQTpmSu2o0Kfwy9Y18cqRwXCoA1yANwIeKsyC7GUzQAx
         iS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UOsM5fHRpbJTbGazwZ9GiS6zVSzVYyLU6fFhBXbjeRM=;
        b=IE3oiNW55IT2TQO+ViJs5eas30jmPSY0Kntbcxgdy9JrVQdJdKInLaNK/iFF2cayY5
         Im38zdKfPdQNA0T9E/S1S9VVkodx5utY2+Hx0zIT/pxSGCymdCOwfKUNGGgwGUzUJdtS
         sSwrfnjDGJJwXMDzDViig3n4Y/k2Un3ZH2MyvW3f1W81btnSlb5tRZksIRIGpgboRhKS
         BFnjns/bH72cuRh+Fq8IOM/VcG62qr2f4u4g+a+rDoWJspCT2yz1RFUZtoXp4XSZTdHG
         0IW6I8r6dmGkTMS7HTt6TcHDvgBghmPXnpTjSvQRjDnEvMSZskI8l6n3Xho+1teqktFT
         /7wg==
X-Gm-Message-State: AOAM530YKkw61qtPdqgLLLPbyXX4qTVpLAvpQl4UM9WT+aax560YYc4N
        0r1qlXs5ZtbMGbzwJQosgEwrhF2lenxUgO0OV/Iz1Q==
X-Google-Smtp-Source: ABdhPJyoE+CVoRyGVXg+1A8+GHnoymttwhN3C/n20/DaHgqTLnG4/V+XvWWB9L68jg9tnaMekQ4ZlxJQD2DFKCUnryE=
X-Received: by 2002:a17:906:7304:b0:6da:9243:865 with SMTP id
 di4-20020a170906730400b006da92430865mr5583200ejc.665.1648742556371; Thu, 31
 Mar 2022 09:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220331150706.124075-1-Jason@zx2c4.com> <20220331152641.169301-1-Jason@zx2c4.com>
In-Reply-To: <20220331152641.169301-1-Jason@zx2c4.com>
From:   Michael Brooks <m@sweetwater.ai>
Date:   Thu, 31 Mar 2022 09:02:27 -0700
Message-ID: <CAOnCY6Sv1goLQMJkvjsVb+TGdowUk6_vQ4ELQ_GkHu8Wjs3PAA@mail.gmail.com>
Subject: Re: [PATCH v2] random: mix build-time latent entropy into pool at init
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

mix_pool_bytes() has numerous problems, as discussed in prior emails.
Do we still want to be putting so much effort into a development dead
end?

-Michael

On Thu, Mar 31, 2022 at 8:28 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Prior, the "input_pool_data" array needed no real initialization, and so
> it was easy to mark it with __latent_entropy to populate it during
> compile-time. In switching to using a hash function, this required us to
> specifically initialize it to some specific state, which means we
> dropped the __latent_entropy attribute. An unfortunate side effect was
> this meant the pool was no longer seeded using compile-time random data.
> In order to bring this back, we declare an array in rand_initialize()
> with __latent_entropy and call mix_pool_bytes() on that at init, which
> accomplishes the same thing as before. We make this __initconst, so that
> it doesn't take up space at runtime after init.
>
> Fixes: 6e8ec2552c7d ("random: use computational hash for entropy extraction")
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v1->v2:
> - Use __initconst.
>
>  drivers/char/random.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 40107f8b9e9e..1d8242969751 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -975,6 +975,11 @@ int __init rand_initialize(void)
>         bool arch_init = true;
>         unsigned long rv;
>
> +#if defined(LATENT_ENTROPY_PLUGIN)
> +       static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
> +       _mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
> +#endif
> +
>         for (i = 0; i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
>                 if (!arch_get_random_seed_long_early(&rv) &&
>                     !arch_get_random_long_early(&rv)) {
> --
> 2.35.1
>

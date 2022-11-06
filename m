Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67DAC43217
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 01:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKFBcA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 21:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKFBb7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 21:31:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667D8DF08
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 18:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF015B80317
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 01:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224CFC433C1
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 01:31:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="l7XrgoyL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667698312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mp9PiJC7iIMtS5hJEagp3EudpaOfLMhhJoh9KmuMMFE=;
        b=l7XrgoyL6lP3MtyoebQjfEc9NKPVEozOdW2Am9ZKEmrWyImV7cLUrsK53JhJa+d9N9MeiS
        zA51ovhPaDJEzqKfKIJR/S2RvNfGs7S1sUOy7kkU+wmJir+Iw1dmYbcBq0gvN00rIE/T4L
        7PJ9qvaKT6DiYBfGF0u3g9Eun84s1KU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 31cb8d14 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sun, 6 Nov 2022 01:31:52 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id e2so4586970vkd.13
        for <linux-crypto@vger.kernel.org>; Sat, 05 Nov 2022 18:31:52 -0700 (PDT)
X-Gm-Message-State: ACrzQf0CPU91eYFeZly40LkDz3W4GEAI7drCsz540jVum09skQvVMRY3
        VTYuOtXAXDbDn/L+gcUFjxE3FS5yzYL5aGMME5c=
X-Google-Smtp-Source: AMsMyM5JeIRHeqxAFQSojorckLO3+gfpLppTMLAJpOrovTUwAEK4TxkA7ycpoB//7LkqNvGOusfd3NS2kRdL2pyLzg4=
X-Received: by 2002:a1f:a013:0:b0:3a9:aa0b:e63f with SMTP id
 j19-20020a1fa013000000b003a9aa0be63fmr6361828vke.6.1667698310940; Sat, 05 Nov
 2022 18:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20221105204417.137001-1-Jason@zx2c4.com>
In-Reply-To: <20221105204417.137001-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 6 Nov 2022 02:31:39 +0100
X-Gmail-Original-Message-ID: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
Message-ID: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
Subject: Re: [PATCH] hw_random: use add_hwgenerator_randomness() for early entropy
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 5, 2022 at 9:44 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Rather than calling add_device_randomness(), the add_early_randomness()
> function should use add_hwgenerator_randomness(), so that the early
> entropy can be potentially credited, which allows for the RNG to
> initialize earlier without having to wait for the kthread to come up.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/hw_random/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index cc002b0c2f0c..8c0819ce2781 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -69,8 +69,10 @@ static void add_early_randomness(struct hwrng *rng)
>         mutex_lock(&reading_mutex);
>         bytes_read = rng_get_data(rng, rng_fillbuf, 32, 0);
>         mutex_unlock(&reading_mutex);
> -       if (bytes_read > 0)
> -               add_device_randomness(rng_fillbuf, bytes_read);
> +       if (bytes_read > 0) {
> +               size_t entropy = bytes_read * 8 * rng->quality / 1024;
> +               add_hwgenerator_randomness(rng_fillbuf, bytes_read, entropy);
> +       }

This will cause problems, because add_hwgenerator_randomness() will
sleep. I'll look into a more robust change.

Jason

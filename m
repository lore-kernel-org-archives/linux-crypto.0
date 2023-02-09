Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D500DC05027
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 14:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBIOUI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 09:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjBIOUH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 09:20:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2572BF06
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 06:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22B10B82159
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 14:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB583C4339C
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675952402;
        bh=TqNuisbtNjfvCHE76A2pmfjkoiECALMt/CCdpVJfkIg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k2Zm8ynAm5EFVWJf+QHS3jPJOypgblg0OPfhmK9lc7sdyiAivzxkoW3hcR3IVHtQg
         WGnusNE/gI+xJTqj51k2KoEHgKT1XjZHZnmXVz71ftnupOROm0satcc+hxgsrTkZPl
         18HphODfSU+n7prD6r7TXkuP0/fGwyzL8/vDj0QaSp8yxq3BvbGgE5s6FlupdI0+ti
         8secxtLy/qSv6CL4XAC4Gg2B2dW6kJnOLFIR2UXEOcyEm9yP5xTuBeyMVhcA//ekyr
         n23KvKnxOGLlzUVty/3Q9gnuCQ8iexkJTZ/R8Dha8SGykvIx5c8/Xkt2M7StByrmQD
         PAGhhPQy9X5gg==
Received: by mail-lj1-f169.google.com with SMTP id g14so2182295ljh.10
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 06:20:02 -0800 (PST)
X-Gm-Message-State: AO0yUKWVNGo+YgCk6Nv+DaXFnY3DxKC5uR3VsQuRDVJd2iTU8iEW69Bq
        3Hkz+P9sgOpaFmIiODMJpAHxHnxtHjFYabQFQo8=
X-Google-Smtp-Source: AK7set+X+Ip0CVXctp94NMwWsDXnEOzt+mXxPYkpTPzrVCupNsoz5q/t/Rssj7M/t40UPIHjVI01kCpk9fgQC0+x8RM=
X-Received: by 2002:a2e:b4b2:0:b0:290:66b3:53e5 with SMTP id
 q18-20020a2eb4b2000000b0029066b353e5mr2103273ljm.57.1675952400776; Thu, 09
 Feb 2023 06:20:00 -0800 (PST)
MIME-Version: 1.0
References: <Y+RJfZ5o59azXqSc@gondor.apana.org.au>
In-Reply-To: <Y+RJfZ5o59azXqSc@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 9 Feb 2023 15:19:49 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHOkqcfjceD9417e=2MrVM1=9ieiTXoj3hGz3jcywkCPA@mail.gmail.com>
Message-ID: <CAMj1kXHOkqcfjceD9417e=2MrVM1=9ieiTXoj3hGz3jcywkCPA@mail.gmail.com>
Subject: Re: [PATCH] crypto: proc - Print fips status
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 9 Feb 2023 at 02:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> As FIPS may disable algorithms it is useful to show their status
> in /proc/crypto.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>
> diff --git a/crypto/proc.c b/crypto/proc.c
> index 12fccb9c5205..56c7c78df297 100644
> --- a/crypto/proc.c
> +++ b/crypto/proc.c
> @@ -11,6 +11,7 @@
>  #include <linux/atomic.h>
>  #include <linux/init.h>
>  #include <linux/crypto.h>
> +#include <linux/fips.h>
>  #include <linux/module.h>      /* for module_name() */
>  #include <linux/rwsem.h>
>  #include <linux/proc_fs.h>
> @@ -48,6 +49,11 @@ static int c_show(struct seq_file *m, void *p)
>         seq_printf(m, "internal     : %s\n",
>                    (alg->cra_flags & CRYPTO_ALG_INTERNAL) ?
>                    "yes" : "no");
> +       if (fips_enabled) {
> +               seq_printf(m, "fips         : %s\n",
> +                          (alg->cra_flags & CRYPTO_ALG_FIPS_INTERNAL) ?
> +                          "no" : "yes");
> +       }
>
>         if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
>                 seq_printf(m, "type         : larval\n");
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

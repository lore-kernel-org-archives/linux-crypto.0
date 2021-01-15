Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F63AC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 17:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E64FC23382
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 17:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAOR0C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 12:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAOR0C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 12:26:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F6220691
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jan 2021 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610731521;
        bh=4QN/I+OlUF2ZKyYEIsCWUsX6tW72HgSbaHypjosoyIo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gsBYH845Dt/BQH9IvyrhH7Wjuj9w6Pm4PzKYQcbfEI5bjvzKuuqiKV9crOsXLMaRE
         TpEN6xSBOFVOuQjZa2u5DI8UMMl9+6sapfrcV4dDlATpRQSNB9eK9LYCyIGZlAFHC/
         pDAEcEzJf4xQyd+aV9gE3ydhC5jsehn2g0h1D7sx7YJNMHKdsgpEyd5pHSiAL83ZRo
         pX6QZ9gGHS+rsDVi/QHRn2Z1oIwo6x/Rr35zEaaSb8ELETqrdaLak4/Hnk5+HMTnIn
         Y29E+iAIMgp07UppvUFGYeUMnO/R0qCmVcPdFfhIAFERVqdlA6Ikopsk3WK3S2ZshR
         0mJlN5Mh63fxA==
Received: by mail-oi1-f172.google.com with SMTP id d203so10324189oia.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jan 2021 09:25:21 -0800 (PST)
X-Gm-Message-State: AOAM53276nJSN+B093tc4I5K5Kok+7YqnRMjngLzjBACrqPPF2W5lOYn
        Cy1bnAH7/bLAGW8woy9cH2gHk6kNpbLIT1MTPFA=
X-Google-Smtp-Source: ABdhPJw78k4iIfU1yJA2B89oXfZhJ5L0kI0nE8WQi/ZqIGqrVpYdWIOKg8UOlxuvs5R6l/psgRGoNuzPyX7ShrD8JZg=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr6395597oig.33.1610731520444;
 Fri, 15 Jan 2021 09:25:20 -0800 (PST)
MIME-Version: 1.0
References: <20210115171743.1559595-1-Jason@zx2c4.com>
In-Reply-To: <20210115171743.1559595-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 15 Jan 2021 18:25:09 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGKVvxrwo_rsT7ZhZk6AzTHiCR5spq7SFK-uak6r2FeXA@mail.gmail.com>
Message-ID: <CAMj1kXGKVvxrwo_rsT7ZhZk6AzTHiCR5spq7SFK-uak6r2FeXA@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - define empty module exit function
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Donnelly <john.p.donnelly@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 15 Jan 2021 at 18:17, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> With no mod_exit function, users are unable to load the module after
> use. I'm not aware of any reason why module unloading should be
> prohibited for this one, so this commit simply adds an empty exit
> function.
>
> Reported-by: John Donnelly <john.p.donnelly@oracle.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/chacha20poly1305.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index 5850f3b87359..c2fcdb98cc02 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -362,7 +362,12 @@ static int __init mod_init(void)
>         return 0;
>  }
>
> +static void __exit mod_exit(void)
> +{
> +}
> +
>  module_init(mod_init);
> +module_exit(mod_exit);
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("ChaCha20Poly1305 AEAD construction");
>  MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
> --
> 2.30.0
>

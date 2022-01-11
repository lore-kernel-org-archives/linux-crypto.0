Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72469C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 22:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiAKWXE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 17:23:04 -0500
Received: from mail-ed1-f54.google.com ([209.85.208.54]:40539 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiAKWXE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 17:23:04 -0500
Received: by mail-ed1-f54.google.com with SMTP id a18so2063640edj.7
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 14:23:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CuzKySws6n5OR2glsf73eCQoXBhCzg0Jsx2fve+nx2I=;
        b=6KMK5BM6WcHHuEpsmuBOSLECUsraKrqKVKffgvc9UI/7znFaBer7W7Op/rURIYhgcF
         RTIvOykghUaj9g5j6hfkoLRDmhf81zEGKqt26B05GkhvmEVZKkiKp194u9nantxQoHTb
         zv3e0aqYzvsfCFETz9NAkq1g6Ho46QUt66Mqet5I4ZbSlyESqCCFvs4n3wOW4Lw4/u3W
         sIKYOeH/UJq6HyuthvYEcryHJS818ioyZoJ5OqyJ9T49GT0oEQtQ7/ZVmZLvwSro/Rlk
         +aiDDnEjAIJgvnzHzHET3aci0Wni5H5Z8e7CKRj0/6a5SSyWt+s/FT9NiquGYguWQ7ot
         nHjA==
X-Gm-Message-State: AOAM530GgSNXl/7s1ItZpF1cwwJ3ksIRgy+4krooRZGTQ9ZEeT9oS78f
        DrHDk3iQt2wrIOBBVn+Nt+Z290jwNVqjhzn0OYdS4Q==
X-Google-Smtp-Source: ABdhPJwQ30cTWYhTAaM+U+x+DDuDbjkaoP7CrY/OeeJ/jRRws25WT0gfWFJGPVZrJpExbzO3PWqK/aVyKFZ3dQSz3M8=
X-Received: by 2002:a17:907:1c91:: with SMTP id nb17mr3248921ejc.712.1641939783274;
 Tue, 11 Jan 2022 14:23:03 -0800 (PST)
MIME-Version: 1.0
References: <20220111195309.634965-1-jforbes@fedoraproject.org> <CAHmME9pi1Y7urg1VQeCi7L6MxHRUk5g4wc6VKDywo4yPh9h_6w@mail.gmail.com>
In-Reply-To: <CAHmME9pi1Y7urg1VQeCi7L6MxHRUk5g4wc6VKDywo4yPh9h_6w@mail.gmail.com>
From:   Justin Forbes <jforbes@fedoraproject.org>
Date:   Tue, 11 Jan 2022 16:22:52 -0600
Message-ID: <CAFxkdAotp+bDWcp3gKMqt93CBaqmuLsAPD5kFuBtUBJ7YPn+hg@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: add prompts back to crypto libraries
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 4:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Justin,
>
> These are library variables, which means they really have no sense in
> being user selectable. Internal things to the kernel depend on them,
> or they don't. They're always only dependencies.

While this is correct in principle, it has not been that way in the
past.  The change had nothing to do with the patch it came in on, and
breaks existing configs used by some distros.  BIG_KEYS happened to be
our motivation for flipping those from module to built in, but I have
no way of knowing what else might be in a similar situation.  Worse,
many users will never know it is happening.  We simply have some
scripts that warn loudly if a config value is flipped from what it was
set to in our prebuild files.

> It sounds like CONFIG_BIG_KEYS might be declaring its dependencies
> wrong, and that's actually where the bug is? CC'ing David Howells just
> in case. Maybe things should be changed to:
>
> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index 64b81abd087e..2f1624c9eed9 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -60,7 +60,7 @@ config BIG_KEYS
>   bool "Large payload keys"
>   depends on KEYS
>   depends on TMPFS
> - depends on CRYPTO_LIB_CHACHA20POLY1305 = y
> + select CRYPTO_LIB_CHACHA20POLY1305
>   help
>     This option provides support for holding large keys within the kernel
>     (for example Kerberos ticket caches).  The data may be stored out to

This looks correct, and would likely alleviate our initial problem,
but it doesn't mean nothing else is impacted. I would still be in
favor of my patch going in to revert the dropped prompts for 5.17, and
then we can audit everything else that has any type of dep on the
crypto libs in question and provide a patch to fix everything up
correctly.  I am happy to do that audit, but probably wouldn't get the
time to do so until rc2 or later.  I do not see how the dropped
prompts for these libs have anything to do with the "blake2s: include
as built-in" that brought them in.

Justin

>
> Jason

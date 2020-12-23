Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CB6C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9391E224B0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgLWJIa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728194AbgLWJI3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 04:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF694224B8
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 09:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608714469;
        bh=CNdKTewC2nsXPDs0f0Q7jyU9vP7OawBh+Hc0pqPoVQ8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hP6MJa5t9Qu+OYxUwyaUsFzZzGMcqkm17cPJbh1aaoVtgGyjMSZU+D6r3w4vtdQJy
         Eobthj4TW5t5vd41gm1WbeiCZFgfcjhP+XHYVg45tlLEgHlIjXaEQWxdrlSnb5g+g4
         kidsZjNYpFEKhEXofNcILkuHJ0h+pnI+Bci8Sxw9+7q22o5VAOM5K1jv8cZtEGoyTy
         r6Wsed5qucdpFtZsVAcLrkn4heGWlTSSEBKRsEFBChxh97EDFDKprku7a11oimgqlx
         PU+fwKJhQc0Wm32zueULdDxsFiyHdIb0Yh/eo+qYnekOW9zgeeUNgBDtmr2KGo6aq8
         oxifKzhFHTv5w==
Received: by mail-oi1-f173.google.com with SMTP id 15so17630214oix.8
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 01:07:48 -0800 (PST)
X-Gm-Message-State: AOAM532Qzfq+3hL2Py8r8wT9O4E/pxirxySzp+Z1uoYxSvk7zB0d5tDS
        SSd9rRKYQbwcIOCqn4xMc7zAR4JXCnptW7phwXQ=
X-Google-Smtp-Source: ABdhPJyvJYm3GG8Zwnqk/CrQal/yiugcwOpoBiBipkiy5+tiMtKTk/ZkFrXwkQul1N5OxD6YjELLqzoVkQp8isX4Lc8=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr17140584oig.33.1608714468288;
 Wed, 23 Dec 2020 01:07:48 -0800 (PST)
MIME-Version: 1.0
References: <20201223081003.373663-1-ebiggers@kernel.org> <20201223081003.373663-10-ebiggers@kernel.org>
In-Reply-To: <20201223081003.373663-10-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 23 Dec 2020 10:07:37 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHDfUUHG3OCXh2U4DZ1m3UOJF9yUCYcL9vqZ_yue_aY3Q@mail.gmail.com>
Message-ID: <CAMj1kXHDfUUHG3OCXh2U4DZ1m3UOJF9yUCYcL9vqZ_yue_aY3Q@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] crypto: blake2s - include <linux/bug.h> instead
 of <asm/bug.h>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Dec 2020 at 09:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Address the following checkpatch warning:
>
>         WARNING: Use #include <linux/bug.h> instead of <asm/bug.h>
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/crypto/blake2s.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
> index 3f06183c2d804..bc3fb59442ce5 100644
> --- a/include/crypto/blake2s.h
> +++ b/include/crypto/blake2s.h
> @@ -6,12 +6,11 @@
>  #ifndef _CRYPTO_BLAKE2S_H
>  #define _CRYPTO_BLAKE2S_H
>
> +#include <linux/bug.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
>
> -#include <asm/bug.h>
> -
>  enum blake2s_lengths {
>         BLAKE2S_BLOCK_SIZE = 64,
>         BLAKE2S_HASH_SIZE = 32,
> --
> 2.29.2
>

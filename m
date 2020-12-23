Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA2DC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A1C20760
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 09:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgLWJIO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbgLWJIN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 04:08:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB59224B2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 09:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608714453;
        bh=5l5WK0+16C6Qx+jlJ87ReZtD03tEBzKw4eVm9I/VXQU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qvg8fnWBnqAnbsuKddUFVQ8jMVO02tlsEbLiYWjftb/XOFHASbeNTapbDsWdRUK6J
         +ueMaZKrKvsK/i4fBVOBbQB7XJYeoIgRl4Z8a0eVCY16bki/c7Gn9TtWVcq4lJDZNB
         MZA3zzG+b5k1mvAro4+Pjh3HZysUhIzGCFC5zH11RvZuWqXQdZ3vw4RfSSRzUyr9aZ
         HZsYkT7NsI7jaWPXnVNSc3wC6zdPuEiuG9qyNI3UJRraL3x3O724/2rZlq1kC8vo20
         9KeCTRpeABcu/LoVUCOre5Bvs3Pr2zAd2VEHJGo83r8NZMSjNtWFPKZHBhKTxqElLP
         q6rVyMLBAs5rg==
Received: by mail-ot1-f49.google.com with SMTP id d20so14472092otl.3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 01:07:32 -0800 (PST)
X-Gm-Message-State: AOAM532GaXmKHgfh4kD9H7mucsw30SMHq1yxJLGyzu2hk3i3k40N3irr
        pyQBFqaSo+78yb+jBZcQxLCLEoo0qBVI0OZA28A=
X-Google-Smtp-Source: ABdhPJxpryVGMXT3+j1RIsx8Tlo7Ig+GsNEKcn4a7SvRDcnGKHshdsa0y0WLu5Cmi2AFHCBoI8Jl72bdr2wBioeqh0Q=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr18519398otu.77.1608714452197;
 Wed, 23 Dec 2020 01:07:32 -0800 (PST)
MIME-Version: 1.0
References: <20201223081003.373663-1-ebiggers@kernel.org> <20201223081003.373663-9-ebiggers@kernel.org>
In-Reply-To: <20201223081003.373663-9-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 23 Dec 2020 10:07:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEuoGibZxnQU1zGJ2VfL5uR4KVONzHBLABsH+1OHQMMHw@mail.gmail.com>
Message-ID: <CAMj1kXEuoGibZxnQU1zGJ2VfL5uR4KVONzHBLABsH+1OHQMMHw@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] crypto: blake2s - adjust include guard naming
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
> Use the full path in the include guards for the BLAKE2s headers to avoid
> ambiguity and to match the convention for most files in include/crypto/.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/crypto/blake2s.h          | 6 +++---
>  include/crypto/internal/blake2s.h | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
> index f1c8330a61a91..3f06183c2d804 100644
> --- a/include/crypto/blake2s.h
> +++ b/include/crypto/blake2s.h
> @@ -3,8 +3,8 @@
>   * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>   */
>
> -#ifndef BLAKE2S_H
> -#define BLAKE2S_H
> +#ifndef _CRYPTO_BLAKE2S_H
> +#define _CRYPTO_BLAKE2S_H
>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> @@ -105,4 +105,4 @@ static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
>  void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
>                      const size_t keylen);
>
> -#endif /* BLAKE2S_H */
> +#endif /* _CRYPTO_BLAKE2S_H */
> diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
> index 867ef3753f5c1..8e50d487500f2 100644
> --- a/include/crypto/internal/blake2s.h
> +++ b/include/crypto/internal/blake2s.h
> @@ -4,8 +4,8 @@
>   * Keep this in sync with the corresponding BLAKE2b header.
>   */
>
> -#ifndef BLAKE2S_INTERNAL_H
> -#define BLAKE2S_INTERNAL_H
> +#ifndef _CRYPTO_INTERNAL_BLAKE2S_H
> +#define _CRYPTO_INTERNAL_BLAKE2S_H
>
>  #include <crypto/blake2s.h>
>  #include <crypto/internal/hash.h>
> @@ -116,4 +116,4 @@ static inline int crypto_blake2s_final(struct shash_desc *desc, u8 *out,
>         return 0;
>  }
>
> -#endif /* BLAKE2S_INTERNAL_H */
> +#endif /* _CRYPTO_INTERNAL_BLAKE2S_H */
> --
> 2.29.2
>

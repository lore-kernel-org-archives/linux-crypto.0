Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CCAC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 08:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C81AD23403
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 08:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbhAHIhQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 03:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbhAHIhQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 03:37:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 168A623447
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 08:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610094995;
        bh=pE4omyFuo/PogFNqti7CWJgb4vB5DOezJYAT6FBiXLE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RWM0zflutBa4pjD1siBh/yxnVJOvaxMGoNRK4AFPxLYw7UnrD3vuwFpNhgaJgFQLj
         MwJEUNT1QpzeEKYVWR1MY5LOOLDHZ4ljOiucj6JGIzRSyejGLDIMgv2WZqujPzrNe8
         PepYVsTwzTyL6e3NmLt3d38pKOdeip3nPCC4l+LMjQuU0bGKnqCuPo7CDNSiTw3ahm
         kDda4PyTaJypR24A5alZEbVjW8YBHZXEPWSruJpxkt3eHC265RaCgfZ5IURSy4Xd5r
         gF7raCQ4wvMgl2qK0U06GFFx8JgW7/c3IYL+w5/k8PrB/m60k0rZ/fdcd+Sk6ZlwrG
         xb/ZHTA8dUPOA==
Received: by mail-ot1-f41.google.com with SMTP id x13so8974988oto.8
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 00:36:35 -0800 (PST)
X-Gm-Message-State: AOAM532HwICXHYniQgpFx8ARbOsBwQpmFNKlBT4mOV4Zt51PvPH4GzCI
        4YcLA69tWD69A+8H6pkyAL/0kHyx7psQzjq12iw=
X-Google-Smtp-Source: ABdhPJy2Gjk5tiwGpuW79W2fFP8yR4Uh5uQevrdrnH9Gl9eZH2/gHOwDY9B/3ZR4p/n7Ssx2ZDGR8lOnMtOvKYa4EKo=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr1806199ote.108.1610094994272;
 Fri, 08 Jan 2021 00:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20210107124128.19791-1-ardb@kernel.org> <X/daxUIwf8iXkbxr@gmail.com>
In-Reply-To: <X/daxUIwf8iXkbxr@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 8 Jan 2021 09:36:23 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE_qHkuk0zmhS=F4uFYWHnZumEB_XWyzo4SYXj1vjqKmg@mail.gmail.com>
Message-ID: <CAMj1kXE_qHkuk0zmhS=F4uFYWHnZumEB_XWyzo4SYXj1vjqKmg@mail.gmail.com>
Subject: Re: [PATCH] crypto - shash: reduce minimum alignment of shash_desc structure
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 7 Jan 2021 at 20:02, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 07, 2021 at 01:41:28PM +0100, Ard Biesheuvel wrote:
> > Unlike many other structure types defined in the crypto API, the
> > 'shash_desc' structure is permitted to live on the stack, which
> > implies its contents may not be accessed by DMA masters. (This is
> > due to the fact that the stack may be located in the vmalloc area,
> > which requires a different virtual-to-physical translation than the
> > one implemented by the DMA subsystem)
> >
> > Our definition of CRYPTO_MINALIGN_ATTR is based on ARCH_KMALLOC_MINALIGN,
> > which may take DMA constraints into account on architectures that support
> > non-cache coherent DMA such as ARM and arm64. In this case, the value is
> > chosen to reflect the largest cacheline size in the system, in order to
> > ensure that explicit cache maintenance as required by non-coherent DMA
> > masters does not affect adjacent, unrelated slab allocations. On arm64,
> > this value is currently set at 128 bytes.
> >
> > This means that applying CRYPTO_MINALIGN_ATTR to struct shash_desc is both
> > unnecessary (as it is never used for DMA), and undesirable, given that it
> > wastes stack space (on arm64, performing the alignment costs 112 bytes in
> > the worst case, and the hole between the 'tfm' and '__ctx' members takes
> > up another 120 bytes, resulting in an increased stack footprint of up to
> > 232 bytes.) So instead, let's switch to the minimum SLAB alignment, which
> > does not take DMA constraints into account.
> >
> > Note that this is a no-op for x86.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  include/crypto/hash.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> > index af2ff31ff619..13f8a6a54ca8 100644
> > --- a/include/crypto/hash.h
> > +++ b/include/crypto/hash.h
> > @@ -149,7 +149,7 @@ struct ahash_alg {
> >
> >  struct shash_desc {
> >       struct crypto_shash *tfm;
> > -     void *__ctx[] CRYPTO_MINALIGN_ATTR;
> > +     void *__ctx[] __aligned(ARCH_SLAB_MINALIGN);
> >  };
> >
> >  #define HASH_MAX_DIGESTSIZE   64
> > @@ -162,9 +162,9 @@ struct shash_desc {
> >
> >  #define HASH_MAX_STATESIZE   512
> >
> > -#define SHASH_DESC_ON_STACK(shash, ctx)                                \
> > -     char __##shash##_desc[sizeof(struct shash_desc) +         \
> > -             HASH_MAX_DESCSIZE] CRYPTO_MINALIGN_ATTR; \
> > +#define SHASH_DESC_ON_STACK(shash, ctx)                                           \
> > +     char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
> > +             __aligned(__alignof__(struct shash_desc));                   \
> >       struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
>
> Looks good to me, but it would be helpful if the comment above the definition of
> CRYPTO_MINALIGN in include/linux/crypto.h was updated.
>

I'd be inclined to update CRYPTO_MINALIGN altogether, given that there
should be very few cases where this actually matter (we've had to fix
some non-coherent DMA issues in the past, but in the general case, all
buffers that are passed to devices for DMA should be described via
scatterlists, and I don't think we permit pointing the scatterlist
into request structures)

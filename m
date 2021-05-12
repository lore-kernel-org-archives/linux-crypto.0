Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E822FC43140
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5BDF61419
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 22:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhELWUz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 18:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387602AbhELVZa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 17:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C88E613E6
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620854661;
        bh=dpMpwE/+0xsrNEBWSrB3F2tfcXWYhcQJFd7Iugffe4g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TI6i2pnrjixOQ0EjSlyqNi776kSVB26wcmAwfSxkf8IAT8tjTGYETNOmQmVmIOozX
         uElNWaC2sIgq0uigB5eT9PK8DK5BlntjroQBeTrYDvFZighVUHMzI+pgjcrW6vnRfe
         zZ7avYbmJc5WDFYGTgU0KarRQRGSapYh6LcQALob12EIRLzIf8ZZJxG5DUpz6kyWZI
         luOwi9Bh/G6PbEEuKz6M3QEvh1k30qsZvjrcXNbjLRPmyVrNfN23pJozx0+UMq6hu2
         2uY2gXVqyEqafogjKgEXn2MURj5cOj6RcEMU2DYvGFde3MC+BkfQL8UZq5ZiBpR7Pc
         g5gfo45WZU7CQ==
Received: by mail-ot1-f54.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso21872159otg.9
        for <linux-crypto@vger.kernel.org>; Wed, 12 May 2021 14:24:21 -0700 (PDT)
X-Gm-Message-State: AOAM530koBdD/2PT2Wk9PgcHo7giVugBPq223w/tGZusQOrHqeaGpJHd
        StNyiG5JXCUHh5+hLR55I6pbonJMdo8WvmPy9Jg=
X-Google-Smtp-Source: ABdhPJz1crGpZ2a/Nstlgsq6mSlP9NuQT6jz7eZ0TUXDgP1IP3cYsDpVaNhe/4teRWkhB86fF1AT2AoSZl5bA/LQBAQ=
X-Received: by 2002:a9d:7cd8:: with SMTP id r24mr20523715otn.90.1620854660323;
 Wed, 12 May 2021 14:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210512184439.8778-1-ardb@kernel.org> <20210512184439.8778-2-ardb@kernel.org>
 <YJw01Z3oxwY5Sfpa@gmail.com>
In-Reply-To: <YJw01Z3oxwY5Sfpa@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 12 May 2021 23:24:09 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHofDrzEs4qc8VNCLpyL-Hc4PSg-JXKTckJvfD6qoK78Q@mail.gmail.com>
Message-ID: <CAMj1kXHofDrzEs4qc8VNCLpyL-Hc4PSg-JXKTckJvfD6qoK78Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] crypto: handle zero sized AEAD inputs correctly
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 May 2021 at 22:04, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 12, 2021 at 08:44:33PM +0200, Ard Biesheuvel wrote:
> > There are corner cases where skcipher_walk_aead_[en|de]crypt() may be
> > invoked with a zero sized input, which is not rejected by the walker
> > code, but results in the skcipher_walk structure to not be fully
> > initialized. This will leave stale values in its page and buffer
> > members, which will be subsequently passed to kfree() or free_page() by
> > skcipher_walk_done(), resulting in a crash if those routines fail to
> > identify them as in valid inputs.
> >
> > Fix this by setting page and buffer to NULL even if the size of the
> > input is zero.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Is this fixing an existing bug, or only a bug that got exposed by this patchset?
> It would be helpful to make that clear (and if it fixes an existing bug, include
> a Fixes tag).
>

The CCM change in the last patch uncovers this issue, and I don't
think it is likely we would ever hit it anywhere else.

> Also, skcipher_walk_virt() doesn't set page and buffer to NULL, as it is
> currently expected that skcipher_walk_done() is only called when
> walk.nbytes != 0.  Is something different for skcipher_walk_aead_[en|de]crypt()?
>

The difference is that zero sized inputs never make sense for
skciphers, but for AEADs, they could occur, even if they are uncommon
(the AEAD could have associated data only, and no plain/ciphertext)

But in the general case, I would assume that skcipher_walk_done() can
be called on a walk that was successfully started with
skcipher_walk_virt() without crashing, even if the scatterlist has
size zero, so perhaps we should fix that one as well.

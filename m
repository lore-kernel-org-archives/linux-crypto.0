Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8822C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF8060FEF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhEUJh5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 05:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232672AbhEUJh4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 05:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E2B2613BB
        for <linux-crypto@vger.kernel.org>; Fri, 21 May 2021 09:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621589307;
        bh=1I8foG06rEXlhMwld0O8rH07GAVgSOgPSPCkjvHDyZw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bEONvf/o+jtIegvQCRc9Ha1tRRuKZgeRXKPolNAJDr0xVpSV2OG22BDpOX/R/j1RT
         YI6kmHB1VkXWc2iDH4rWofshyP7VFAi/xoCJcAD3lxd+J1Kpv/erTX3WS+BSCzLNdV
         4XSkIWBCNQPsZeiu8ob5HWqzFGiq7YzoGjZ2Y+RbnADimc/QU8p17qkJOl0leofnN/
         7RvJY99rBy5na4PROovh+mXrVK46GXOASc2/ukuw8w0TyMOO3d5Nsu/0pkc01uTVPe
         9CoLlNdE/TtnupIOUwp9Z9WCPN6D/1r1wBPeDiEpENw/j0Ypvs1hc0hYJhycsbzqBF
         fYCrF45x59C5A==
Received: by mail-oo1-f42.google.com with SMTP id q17-20020a4a33110000b029020ebab0e615so2510501ooq.8
        for <linux-crypto@vger.kernel.org>; Fri, 21 May 2021 02:28:27 -0700 (PDT)
X-Gm-Message-State: AOAM531VnnTuhwSVpd+AKN3UvuZgo8Px+cmLSTn9T96dzRA5DBJ/5dYK
        e+SEyhBhbBnbIXxRgeLzchyDj6XqbUn6RdncJmI=
X-Google-Smtp-Source: ABdhPJyJSjU9wUg8bhKp05QNCWGrUTSHlMV2o0Pxe6m1A42xw39EOxOs4BsMHF5nBZWyaskxPO7nkbh8OXfvXaBxT4Q=
X-Received: by 2002:a4a:300b:: with SMTP id q11mr4954517oof.45.1621589306096;
 Fri, 21 May 2021 02:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210512184439.8778-1-ardb@kernel.org> <20210512184439.8778-2-ardb@kernel.org>
 <YJw01Z3oxwY5Sfpa@gmail.com> <CAMj1kXHofDrzEs4qc8VNCLpyL-Hc4PSg-JXKTckJvfD6qoK78Q@mail.gmail.com>
 <20210521075544.kywxswbfyoauvhmg@gondor.apana.org.au>
In-Reply-To: <20210521075544.kywxswbfyoauvhmg@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 21 May 2021 11:28:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEnk=N+pk5-HKPLfB7YJshR0gZ4Mf3uD_8xTfUsEm68xg@mail.gmail.com>
Message-ID: <CAMj1kXEnk=N+pk5-HKPLfB7YJshR0gZ4Mf3uD_8xTfUsEm68xg@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] crypto: handle zero sized AEAD inputs correctly
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 21 May 2021 at 09:55, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, May 12, 2021 at 11:24:09PM +0200, Ard Biesheuvel wrote:
> >
> > The difference is that zero sized inputs never make sense for
> > skciphers, but for AEADs, they could occur, even if they are uncommon
> > (the AEAD could have associated data only, and no plain/ciphertext)
>
> I don't see what a zero-sized input has to do with this though.
> When the walk->nbytes is zero, that means that you must never
> call the done function, because the walk state could be in error
> in which case everything would have been freed already and calling
> the done function may potentially cause a double-free.
>
> I don't understand why in the case of AEAD you cannot structure
> your code such that the done function is not called when nbytes
> is zero.
>

OK.

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15054C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 06:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiBWGpg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 01:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiBWGpf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 01:45:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFA06D874
        for <linux-crypto@vger.kernel.org>; Tue, 22 Feb 2022 22:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8755161484
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 06:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB11FC340E7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 06:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645598708;
        bh=6xg8D/XX6WqodUh2YEOZYBPRCmDxcytkiqDeRi/LDEA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sIwX1W4XS9acxVOtG6Fy3wuMnh2z9X3fhSZbW4Bu2RzeXVu+lrWD7TvVoDTl/5IVX
         Qe9TK1WWFTPczBxNhY74Leg6jM96e/dks4YBlSCH+Rujsn/zhi9l/H+8ZUtwPcCOVJ
         bkCuAVkG4FKKw1WCliyxgDvVRc2g5ATARwyS4JHBCvl3wXFhO3yV7SXXJQ6Ar+b/vH
         myJjplATr0N2IRWuwoRhevijuoQBbU4JlzOFqLcYQsuKJvMR01svf6jDaUvW3DvDIa
         oHnamT81IZguh8Fjj079+wSuQsUcCvbVXGyNMzi/hUqPhotuRPgU8e8JpDBXilSgLy
         oDFy+LOIJhFIw==
Received: by mail-yb1-f171.google.com with SMTP id j12so45959853ybh.8
        for <linux-crypto@vger.kernel.org>; Tue, 22 Feb 2022 22:45:07 -0800 (PST)
X-Gm-Message-State: AOAM532CSU9/dM6UFimZ96JiGlVVEj+CkO6hPWpfRzknstzPjOoCSyWJ
        cCc9LC7zDI4+SvBm85+YzlVyWBKnN6iOAxcTbwg=
X-Google-Smtp-Source: ABdhPJyUgqPkbXsadF8xEnnF7GCIcnHphT7ekNfN4L68PkcN7f/xTRZWl/E8RlS4QSokjdzpmldx5+GypBXkulsB318=
X-Received: by 2002:a25:24ce:0:b0:61e:1276:bfcf with SMTP id
 k197-20020a2524ce000000b0061e1276bfcfmr26619857ybk.299.1645598707010; Tue, 22
 Feb 2022 22:45:07 -0800 (PST)
MIME-Version: 1.0
References: <20220215105717.184572-1-ardb@kernel.org> <YhWg246ql3Xa0MRR@gondor.apana.org.au>
In-Reply-To: <YhWg246ql3Xa0MRR@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 23 Feb 2022 07:44:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGKtLagHZsZV2KMGNqp3Cn8V6c8CJvLhrFJ63ND33XNqQ@mail.gmail.com>
Message-ID: <CAMj1kXGKtLagHZsZV2KMGNqp3Cn8V6c8CJvLhrFJ63ND33XNqQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: crypto_xor - use helpers for unaligned accesses
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Feb 2022 at 03:50, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Feb 15, 2022 at 11:57:17AM +0100, Ard Biesheuvel wrote:
> > Dereferencing a misaligned pointer is undefined behavior in C, and may
> > result in codegen on architectures such as ARM that trigger alignments
> > traps and expensive fixups in software.
> >
> > Instead, use the get_aligned()/put_aligned() accessors, which are cheap
> > or even completely free when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y.
> >
> > In the converse case, the prior alignment checks ensure that the casts
> > are safe, and so no unaligned accessors are necessary.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/algapi.c         | 24 +++++++++++++++++++++---
> >  include/crypto/algapi.h | 11 +++++++++--
> >  2 files changed, 30 insertions(+), 5 deletions(-)
>
> Ard, could you please take a look at the two kbuild reports and
> see if there is an issue that needs to be resolved?
>

My patch is flawed - I'll fix it and send a v2.

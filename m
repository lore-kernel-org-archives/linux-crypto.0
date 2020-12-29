Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2F1C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Dec 2020 10:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A71F21D1B
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Dec 2020 10:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgL2Kx3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Dec 2020 05:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgL2Kx3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Dec 2020 05:53:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 481E5208BA;
        Tue, 29 Dec 2020 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609239168;
        bh=E/xsiexKKesozJBG2Y4XKyEp7msEUePwUdUPTQbQKh8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i9I7WlwKNEVsZw69FqnzAqPRGBrr2B4w34TP/hJiI+0rjZ69UndRAUKnDHvpFvPtQ
         JrOesakwSUq5o4HbdZmQ6qsWRZhHwhWKsU0RxqdawUWtCVvXFh8RNsGImGzv80fmH/
         hK/WNGY1/31rzGo07wtdsHDya04DEZfxJofQI4uJD+20LXTctl7NvTOe6+w9BWhmEl
         oioG5MeFgZ6OpAH0j6WahLZ0Cftl65dQn8I7dm1mhn7Yy62JXeJDADuTucFBbkqXRw
         i7fpdydg+tNdNqG3q9MLtv1xT5nXyeSuby5lT1RoiVz7AqmKLPt9KNYhh0mNFd/u1z
         5XXG4D88Vu0pg==
Received: by mail-ot1-f46.google.com with SMTP id j12so11501216ota.7;
        Tue, 29 Dec 2020 02:52:48 -0800 (PST)
X-Gm-Message-State: AOAM531Rt5yYklSrwAYWXk90tJJoZvODHtEuUYQuyXl26MgnCuAJAPZ8
        tkgSZo0X8lS5FtSHUgj96z8tylHs/Na/cqFCctI=
X-Google-Smtp-Source: ABdhPJyGC/+oU8v/j930GVgRs9M0NiUTalJ+wKk8+AXZhgk4/+Kvha5AdLVyP3QiSFBuEnfz90b++eKfkcFiEA+hWmA=
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr35552735oto.90.1609239167669;
 Tue, 29 Dec 2020 02:52:47 -0800 (PST)
MIME-Version: 1.0
References: <20201222160629.22268-1-ardb@kernel.org> <X+Y6G0pHja1C61s9@sol.localdomain>
In-Reply-To: <X+Y6G0pHja1C61s9@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 29 Dec 2020 11:52:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGk08hi-mto6JmHkVfW6WYzeiiMHpGj1YHXZQNdvSf2EQ@mail.gmail.com>
Message-ID: <CAMj1kXGk08hi-mto6JmHkVfW6WYzeiiMHpGj1YHXZQNdvSf2EQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: x86/aes-ni-xts - recover and improve performance
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Dec 2020 at 20:14, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Dec 22, 2020 at 05:06:27PM +0100, Ard Biesheuvel wrote:
> > The AES-NI implementation of XTS was impacted significantly by the retpoline
> > changes, which is due to the fact that both its asm helper and the chaining
> > mode glue library use indirect calls for processing small quantitities of
> > data
> >
> > So let's fix this, by:
> > - creating a minimal, backportable fix that recovers most of the performance,
> >   by reducing the number of indirect calls substantially;
> > - for future releases, rewrite the XTS implementation completely, and replace
> >   the glue helper with a core asm routine that is more flexible, making the C
> >   code wrapper much more straight-forward.
> >
> > This results in a substantial performance improvement: around ~2x for 1k and
> > 4k blocks, and more than 3x for ~1k blocks that require ciphertext stealing
> > (benchmarked using tcrypt using 1420 byte blocks - full results below)
> >
> > It also allows us to enable the same driver for i386.
> >
> > Cc: Megha Dey <megha.dey@intel.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >
> > Ard Biesheuvel (2):
> >   crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> >   crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper
> >
> >  arch/x86/crypto/aesni-intel_asm.S  | 353 ++++++++++++++++----
> >  arch/x86/crypto/aesni-intel_glue.c | 230 +++++++------
> >  2 files changed, 412 insertions(+), 171 deletions(-)
> >
> > --
> > 2.17.1
> >
> > Benchmarked using tcrypt on a Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
>
> Thanks for doing this!  I didn't realize that there was such a big performance
> regression here.  Getting rid of these indirect calls looks like the right
> approach; this all seems to have been written for a world where indirect calls
> are much faster...
>
> I did some quick benchmarks on Zen ("AMD Ryzen Threadripper 1950X 16-Core
> Processor") with CONFIG_RETPOLINE=y and confirmed the speedup on 4096-byte
> blocks is around 2x there too.  (It's over 2x for AES-128-XTS and AES-192-XTS,
> and a bit under 2x for AES-256-XTS.  And most of the speedup comes from the
> first patch.)  Also, the extra self-tests are passing.
>
> So feel free to add:
>
>         Tested-by: Eric Biggers <ebiggers@google.com> # x86_64
>
> Note that this patch series didn't apply cleanly, as it seems to depend on some
> other patches you've sent out recently.  So I actually tested your
> "for-kernelci" branch instead of applying these directly.
>

Thanks Eric. I have some other stuff queued up locally as well, so
there are some non-functional conflicts there. The only prerequisite
for this series is the one that adds CTS-CBC support to AES-NI, give
that the XTS implementation reuses the permute table.

I will rebase and resend.

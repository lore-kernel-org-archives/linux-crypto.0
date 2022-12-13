Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AFDC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Dec 2022 20:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiLMU7D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Dec 2022 15:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbiLMU7C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2022 15:59:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF49420F5A
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 12:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE61B815BE
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 20:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE8EC433EF
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 20:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670965138;
        bh=vZjfMJv+YQaExGmli9Ja2HeEpcwcey5Y8WObXJ817ww=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZvUY+XmHRtfKkPpKtbKp6OZ+5hnFbKFl5476PWHKY+X6/MZag7tOf4pEjHDTP8rWk
         B3B77NEi7KUOIT9iWhvbJXbMSMEk6HPKlLs/zHvOM6Ryv4+GvNJsBFEfUcO094p9Sk
         rV8Cl2GJcwQFGcwdn3X4rcyXEoGuEFh1ykT2ytRkux6s4ruVwuVBn9lAuFD+EOW006
         zKhH/rn7vkIQnsGuVPDpRRhiIhpusrM9bpxkgatu4YOE65+Hy/2L7I/EwwTYfhGzcX
         C2hgXy+nTRjJUh7BEmw60vXcd0mx/25pLl1N6G6UUVzK7/OZdZTbpfmB771j1wzytC
         zSyP9+If/L+Tw==
Received: by mail-lj1-f178.google.com with SMTP id v11so4647846ljk.12
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 12:58:58 -0800 (PST)
X-Gm-Message-State: ANoB5plY0JPZDbxbjQi19T3Y8/K0nLpiv9NP29n7qbw/N2ccPYZ3DPje
        xVuZ2XIoRNkXYs2JPprL29NWwlT+vWUu8kiHL0A=
X-Google-Smtp-Source: AA0mqf6UxqYLH0sXxFVitXepgNPslAh+iP6Cedj2iWuIpH0O/wk/HY9h+LnFdKAHZO+WKN8X3Q+DCVPz8jnOE3z5bQQ=
X-Received: by 2002:a05:651c:153:b0:279:bbff:a928 with SMTP id
 c19-20020a05651c015300b00279bbffa928mr12041866ljd.415.1670965136065; Tue, 13
 Dec 2022 12:58:56 -0800 (PST)
MIME-Version: 1.0
References: <20221213161310.2205802-1-ardb@kernel.org> <Y5jXnE8e2SRHFRQN@sol.localdomain>
In-Reply-To: <Y5jXnE8e2SRHFRQN@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 13 Dec 2022 21:58:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFKhoLMMW8R8UbWrUf6W3xYBwzeD+w0mQwBn_=3qJJ+dA@mail.gmail.com>
Message-ID: <CAMj1kXFKhoLMMW8R8UbWrUf6W3xYBwzeD+w0mQwBn_=3qJJ+dA@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: use kmap_local() not kmap_atomic()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 13 Dec 2022 at 20:50, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Dec 13, 2022 at 05:13:10PM +0100, Ard Biesheuvel wrote:
> > kmap_atomic() is used to create short-lived mappings of pages that may
> > not be accessible via the kernel direct map. This is only needed on
> > 32-bit architectures that implement CONFIG_HIGHMEM, but it can be used
> > on 64-bit other architectures too, where the returned mapping is simply
> > the kernel direct address of the page.
> >
> > However, kmap_atomic() does not support migration on CONFIG_HIGHMEM
> > configurations, due to the use of per-CPU kmap slots, and so it disables
> > preemption on all architectures, not just the 32-bit ones. This implies
> > that all scatterwalk based crypto routines essentially execute with
> > preemption disabled all the time, which is less than ideal.
> >
> > So let's switch scatterwalk_map/_unmap and the shash/ahash routines to
> > kmap_local() instead, which serves a similar purpose, but without the
> > resulting impact on preemption on architectures that have no need for
> > CONFIG_HIGHMEM.
> >
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/ahash.c               | 4 ++--
> >  crypto/shash.c               | 4 ++--
> >  include/crypto/scatterwalk.h | 4 ++--
> >  3 files changed, 6 insertions(+), 6 deletions(-)
> >
>
> Thanks Ard, this looks good to me, especially given the broader effort to
> replace kmap_atomic() with kmap_local_page() in the kernel.
>
> One question: should the kmap_atomic() in crypto/skcipher.c be replaced as well?
>

Yeah, probably, but that one does not actually affect 64-bit at the
moment, so it matters less.

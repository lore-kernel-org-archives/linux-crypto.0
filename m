Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6E4C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C18720708
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603753608;
	bh=hnU9R5si+qo0PuKVl2TBh14NK9VyyVyOXO57vJdjBIE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=nbDKDCTHrhyeAllotSnekvXZ5AnLspOll2/AdY4U1hWOc+3foJoPJeVcqbTzL+lus
	 D5PS9KfYO7md6qjI88zsloidMLfbu6hHzWelToZC01Y5wdHB21dweQj/vS2p4a9up2
	 OgFO8triRjtcdannHn7MT3O2Es+kQRhIwD2LoH7I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395430AbgJZXGr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395428AbgJZXGr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 19:06:47 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00AC207DE
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603753606;
        bh=hnU9R5si+qo0PuKVl2TBh14NK9VyyVyOXO57vJdjBIE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CTG8rA48dHZowtjTrjhjStaBojKcaDKSTfaLwaqUkm91kfnhpSljWvuRbiHimAZ8K
         aHdBR6foTY0Q/P7cxK+M84zW2tapJNik5QsUqmwkcLxQ5qQAaZJ+nfVmsC6TT414ju
         au/FXCHYTAX4Hr+CGoV7GAoFNqGVXnEZe4/S8Pmw=
Received: by mail-oi1-f176.google.com with SMTP id h10so12244272oie.5
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:06:46 -0700 (PDT)
X-Gm-Message-State: AOAM530y9zEGiP8A8CYGRYximYAWsqLfo/wTYycxYJyai73lW30IU38M
        tR3BkY79lYdkAua1SRFbqqKxlI2gvX5mwp0plhI=
X-Google-Smtp-Source: ABdhPJz5zg8zHbhuixKEJgGN/sspeEGXPnTACn9R0EA+uzQJCdyHldT22tXZS393Klgid2xlq+J/jbEFaTzB++st5hw=
X-Received: by 2002:aca:5157:: with SMTP id f84mr1458478oib.33.1603753605949;
 Mon, 26 Oct 2020 16:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201026230027.25813-1-ardb@kernel.org> <20201026230323.GA1947033@gmail.com>
 <CAMj1kXGYgxe_=1kQjKZKOxc7KkxjM4g7D5jsexBfrM++_FAiGw@mail.gmail.com>
In-Reply-To: <CAMj1kXGYgxe_=1kQjKZKOxc7KkxjM4g7D5jsexBfrM++_FAiGw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 27 Oct 2020 00:06:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE6nxmwbyJb3kJdThmpf1wGQEe73Zh=2e7zcj=9wh3MxQ@mail.gmail.com>
Message-ID: <CAMj1kXE6nxmwbyJb3kJdThmpf1wGQEe73Zh=2e7zcj=9wh3MxQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/poly1305-neon - reorder PAC authentication
 with SP update
To:     Eric Biggers <ebiggers@kernel.org>,
        Andy Polyakov <appro@cryptogams.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Andy)

On Tue, 27 Oct 2020 at 00:04, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 27 Oct 2020 at 00:03, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Oct 27, 2020 at 12:00:27AM +0100, Ard Biesheuvel wrote:
> > > PAC pointer authentication signs the return address against the value
> > > of the stack pointer, to prevent stack overrun exploits from corrupting
> > > the control flow. However, this requires that the AUTIASP is issued with
> > > SP holding the same value as it held when the PAC value was generated.
> > > The Poly1305 NEON code got this wrong, resulting in crashes on PAC
> > > capable hardware.
> > >
> > > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS ...")
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm64/crypto/poly1305-armv8.pl       | 2 +-
> > >  arch/arm64/crypto/poly1305-core.S_shipped | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > This needs to be fixed at https://github.com/dot-asm/cryptogams too, I assume?
> >
>
> Yes, and in OpenSSL.

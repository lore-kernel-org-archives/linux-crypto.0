Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC18CC4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F476207DE
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 23:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603753473;
	bh=gNMl/eq1RrAMyEDP83Z8txuUiMHi1aHaSC4AHYKyW50=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=mM3fshdVqH0f0CPCf+aTBSorwTFBSY+bMx+K2k6uPkj5pMkgWRR4Gad0B38Tr6Fki
	 ehqqwfqfc1D3N1gP390JY02/wRwgOWlOCbiJHBAMDBdToj6DrWDG5IuTNS0+UFXcfS
	 mmssbIHW3GXeW23+ZLfSP99fv6XBWNy1ebHFzgdM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395254AbgJZXEd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395248AbgJZXEc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 19:04:32 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C752020780
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 23:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603753471;
        bh=gNMl/eq1RrAMyEDP83Z8txuUiMHi1aHaSC4AHYKyW50=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HPFpB8iC4LzjVICIAQ90sOAZnDct5UfWnPhb3KF7iswRpje8Se3fcgeJQkwQ9sFKB
         y1SiOqAfqqXoWmY294Ug5tv9LrcQEZh8y74PDPLB87qyze6pD9wQknpE1r+KcRoDux
         eK3/U2fvOMS6fXeol+D7L/CzM+aB4tTBAhN+GUJ4=
Received: by mail-oi1-f174.google.com with SMTP id x1so4418523oic.13
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:04:31 -0700 (PDT)
X-Gm-Message-State: AOAM531ABqBoWmHe0vghGINgeYCILuywichen6KiUg1//R18ITxb2k0W
        pjvBQX2G8Bj3Ct/+RNjnOE8rI4d0TSIIcJZpFR4=
X-Google-Smtp-Source: ABdhPJzJ/e+kKJASatDcMDV4n7rbXOqRz/2g1vQfRUQdaCjxQ7XS82HqZd4ZB7lCi7XLa7OgQ/+HSZSIY6P2XJNf9QI=
X-Received: by 2002:aca:d64f:: with SMTP id n76mr16288556oig.174.1603753471106;
 Mon, 26 Oct 2020 16:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201026230027.25813-1-ardb@kernel.org> <20201026230323.GA1947033@gmail.com>
In-Reply-To: <20201026230323.GA1947033@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 27 Oct 2020 00:04:19 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGYgxe_=1kQjKZKOxc7KkxjM4g7D5jsexBfrM++_FAiGw@mail.gmail.com>
Message-ID: <CAMj1kXGYgxe_=1kQjKZKOxc7KkxjM4g7D5jsexBfrM++_FAiGw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/poly1305-neon - reorder PAC authentication
 with SP update
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 27 Oct 2020 at 00:03, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Oct 27, 2020 at 12:00:27AM +0100, Ard Biesheuvel wrote:
> > PAC pointer authentication signs the return address against the value
> > of the stack pointer, to prevent stack overrun exploits from corrupting
> > the control flow. However, this requires that the AUTIASP is issued with
> > SP holding the same value as it held when the PAC value was generated.
> > The Poly1305 NEON code got this wrong, resulting in crashes on PAC
> > capable hardware.
> >
> > Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS ...")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/crypto/poly1305-armv8.pl       | 2 +-
> >  arch/arm64/crypto/poly1305-core.S_shipped | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
>
> This needs to be fixed at https://github.com/dot-asm/cryptogams too, I assume?
>

Yes, and in OpenSSL.

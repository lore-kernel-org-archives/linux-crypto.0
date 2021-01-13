Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7060FC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 08:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3248223340
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 08:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbhAMIT0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 03:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbhAMITY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 03:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 768AD23341
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2021 08:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610525923;
        bh=/Ygp7cJULdR7ZsbFgEkM3xMU8xFYWY8rkUktd5UQqw0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mrjB/PuJgBhnnqHPingE0FTyYh6QzwwrmdG1lcgZuuX9nChYZWpKwzK5fsjGBQV72
         o8zMZgqBHM69w2sIv4D6oFcryj+M46xv+tXirEDnw6tI7PYxf3dHwuHJ531Xi7BhZ+
         Jo3++5s60VgeIv0Fg7uux+uI3gbhFr+RCsjxDaPCBDa7a+e+os9fOe4/7LmnAR+EK0
         gA5UbahdOPxAlFAc7PSeEj9Fxrvf39z/DfewvmM9IJadmvPl1ewV8Jn6QKnFX/B3gv
         l4efhBZveS6UD49iOT2iBR4X8+vyOgK79ikaaT4XtGWxmQ53Ia0fri8tkwM/4r6pdy
         B1rSNMNcSZx4w==
Received: by mail-ot1-f45.google.com with SMTP id r9so1120267otk.11
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2021 00:18:43 -0800 (PST)
X-Gm-Message-State: AOAM531l698QBy0+JRaVVPccnlVl/cxg27CA5z/OrhD25kxiGIap1gIz
        4+FvcpxhHK6H8Ss5qPHawHgVmSEsL8x7QHSxtFk=
X-Google-Smtp-Source: ABdhPJw6cnN6ZNq4yJeEwmw2kQ6V9hrAcO3hit8A2gfIRDtoLZieKgOKMLfQZMLTpke+JGlBIlwD6s+Jv27qTZwz6Xo=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr476627otu.77.1610525922660;
 Wed, 13 Jan 2021 00:18:42 -0800 (PST)
MIME-Version: 1.0
References: <20210108171706.10306-1-ardb@kernel.org> <X/jLtI1m96DD+QLO@sol.localdomain>
 <CAMj1kXE8SPE+2HazN6whvYr5anZWJJ8n4UAVyotPV1XySkk0Rg@mail.gmail.com> <20210113062652.GA12495@gondor.apana.org.au>
In-Reply-To: <20210113062652.GA12495@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 13 Jan 2021 09:18:31 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHaZJMKsCVc1ROFMxZg5TnPAsy-UDfD_8C_0UqqdvSVKg@mail.gmail.com>
Message-ID: <CAMj1kXHaZJMKsCVc1ROFMxZg5TnPAsy-UDfD_8C_0UqqdvSVKg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: reduce minimum alignment of on-stack structures
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Jan 2021 at 07:27, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jan 08, 2021 at 11:49:32PM +0100, Ard Biesheuvel wrote:
> >
> > The assumption is that ARCH_SLAB_MINALIGN should be sufficient for any
> > POD type, But I guess that in order to be fully correct, the actual
> > alignment of the struct type should be ARCH_SLAB_MINALIGN, and __ctx
> > should just be padded out so it appears at an offset that is a
> > multiple of ARCH_KMALLOC_ALIGN.
>
> How about just leaving the skcpiher alone for now and change shash
> only?
>

Good point. I'll spin a v3 with only the shash_desc change and the
updated comment for CRYPTO_MINALIGN.

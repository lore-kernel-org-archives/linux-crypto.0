Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69BFC2B9F7
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 09:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B6C6143C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 09:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhEZJP6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 05:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhEZJP6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 05:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D18D61248
        for <linux-crypto@vger.kernel.org>; Wed, 26 May 2021 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622020467;
        bh=dXdnX56Dp8n+ZTGKiJD0nb2UHMRh0G34i2mPLUC97+A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s9jHdOo2+iOjD99FkcK/KmAm9zQ4gQldFrFuWpx9Bz8JKCJI7+vaZBH0QHy0p2fTo
         Q5EvHTF18G303rGuRaRt7XfbEnT8PqweI6hGLMg+F48kJdroB9wXdCvTBXnlsLyVBs
         tJKbAAIJJu4se0/dykxT21obsiTolxs/5MH7r2SQtTqsDLzpHI+yOxrmq8J52t2uUg
         XqrIny4pRBHxMBU/Q/8Xqc1yiSp6HiiqbCs4mzrfJ6RefRt6wXoZedH8JxP8F9KHU6
         stZPta+9+sM6M5MXQFEhqAtEgwNZIPyARcvMab0ECRXAsEtedY2nLIEFDQiyem/l+9
         aj1hA1prVB59A==
Received: by mail-oo1-f41.google.com with SMTP id f22-20020a4aeb160000b029021135f0f404so130263ooj.6
        for <linux-crypto@vger.kernel.org>; Wed, 26 May 2021 02:14:27 -0700 (PDT)
X-Gm-Message-State: AOAM530z3sz7rmZhLSELV2PFQJV12fMwvGCNHoPrj9oGIXISmhyX8LBd
        Kr05A+7os9ZfV1RG8UVwLVBnhWyUXBLx34mjJzs=
X-Google-Smtp-Source: ABdhPJxbJUFHef2JLTz1mCkGwEC1fRY8XWqNv9KpH8rSprp9ybofHbUAxQ08chiQebj4O5/OzTqtgbimyI1SrS/QD3A=
X-Received: by 2002:a4a:8706:: with SMTP id z6mr1423776ooh.41.1622020466796;
 Wed, 26 May 2021 02:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210521102053.66609-1-ardb@kernel.org> <20210521102053.66609-6-ardb@kernel.org>
 <YKwgSnb4RJr40Ns2@gmail.com>
In-Reply-To: <YKwgSnb4RJr40Ns2@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 May 2021 11:14:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGRj+OUuJRXgi6QoCGMzjArYH0Hx08hvsvsbPqOLwD3wQ@mail.gmail.com>
Message-ID: <CAMj1kXGRj+OUuJRXgi6QoCGMzjArYH0Hx08hvsvsbPqOLwD3wQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 24 May 2021 at 23:53, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, May 21, 2021 at 12:20:53PM +0200, Ard Biesheuvel wrote:
> > With the SIMD code path removed, we can clean up the CCM auth-only path
> > a bit further, by passing the 'macp' input buffer pointer by value,
> > rather than by reference, and taking the output value from the
> > function's return value.
> >
> > This way, the compiler is no longer forced to allocate macp on the
> > stack. This is not expected to make any difference in practice, it just
> > makes for slightly cleaner code.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/crypto/aes-ce-ccm-core.S | 23 ++++++++++----------
> >  arch/arm64/crypto/aes-ce-ccm-glue.c | 17 +++++----------
> >  2 files changed, 17 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
> > index 8adff299fcd3..b03f7f71f893 100644
> > --- a/arch/arm64/crypto/aes-ce-ccm-core.S
> > +++ b/arch/arm64/crypto/aes-ce-ccm-core.S
> > @@ -12,22 +12,21 @@
> >       .arch   armv8-a+crypto
> >
> >       /*
> > -      * void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
> > -      *                           u32 *macp, u8 const rk[], u32 rounds);
> > +      * u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
> > +      *                          u32 macp, u8 const rk[], u32 rounds);
>
> How is this different from 'u8 mac[]' which is already one of the parameters?
>

mac[] is the combined digest/input buffer, and macp is the index into
it that keeps track on how much new input we have accumulated. I.e.,
instead of having a separate buffer of the same size, and accumulating
bytes until we can perform the XOR + AES transformation, the partial
input is accumulated into mac[] using XOR directly.

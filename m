Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BA2C4332D
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 22:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF26F23A80
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 22:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbhAHWu0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 17:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbhAHWuZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 17:50:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72C3923A9F
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 22:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610146184;
        bh=nklGzFhTSz6ugK7vHFSK3VFA9welm/1LPsh+zA+j+8w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bPQ8hhqwV94tTO0lCUNU5CYMCvO95yG4rohkCtt8yzBfZ3/zkfQq+pSaImMMEpbH7
         H+Jb+Pf/dqS9d4so75BtaXh1khCUchImoyMK9sl1i7dFwxxSNKPBzXP3ZzP5HQLCus
         YkWA0AdjGarF6t6xDccSmrwQForzhQDgmDXKkaRFZL5OaZNqW1u2OeQZUve88JFABE
         yqVN5gY20jBU980dkKS++NXOOG3b5XHWO7YUXwFlRJSRLYCNvfpYjC3Q1EaVPWxLHz
         g7YxfMrYqyVn+ZhgaP5caWm01n98m0r4TasIxfuL8ttgO47kHh21dR4lzDHPQljA9M
         x4HlbMe7HT3Kg==
Received: by mail-ot1-f44.google.com with SMTP id d8so11264559otq.6
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 14:49:44 -0800 (PST)
X-Gm-Message-State: AOAM533mLvVT5dJzrLoG4dX0nLCHbKA25z1zXreDA9ERwbGcEB7Pz/op
        I9AUzdMuQyPzOYdmGHjTdWROVB1BeTQXPTEFuns=
X-Google-Smtp-Source: ABdhPJwnVOcCs4ugcmNd1Ac/azG8iII4FMmv+TbAw/2QoqriIpNN/EiM76H4MsCqK4pHdOSvxvbwYH7ZOPY7JY4VNyI=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr4041879otu.77.1610146183806;
 Fri, 08 Jan 2021 14:49:43 -0800 (PST)
MIME-Version: 1.0
References: <20210108171706.10306-1-ardb@kernel.org> <X/jLtI1m96DD+QLO@sol.localdomain>
In-Reply-To: <X/jLtI1m96DD+QLO@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 8 Jan 2021 23:49:32 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE8SPE+2HazN6whvYr5anZWJJ8n4UAVyotPV1XySkk0Rg@mail.gmail.com>
Message-ID: <CAMj1kXE8SPE+2HazN6whvYr5anZWJJ8n4UAVyotPV1XySkk0Rg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: reduce minimum alignment of on-stack structures
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Jan 2021 at 22:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jan 08, 2021 at 06:17:06PM +0100, Ard Biesheuvel wrote:
> > diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> > index 6a733b171a5d..aa133dc3bf39 100644
> > --- a/include/crypto/skcipher.h
> > +++ b/include/crypto/skcipher.h
> > @@ -128,7 +128,7 @@ struct skcipher_alg {
> >                            MAX_SYNC_SKCIPHER_REQSIZE + \
> >                            (!(sizeof((struct crypto_sync_skcipher *)1 == \
> >                                      (typeof(tfm))1))) \
> > -                         ] CRYPTO_MINALIGN_ATTR; \
> > +                         ] __aligned(ARCH_SLAB_MINALIGN); \
> >       struct skcipher_request *name = (void *)__##name##_desc
> >
>
> Are you sure this is okay?  __alignof__(struct skcipher_request) will still be
> CRYPTO_MINALIGN_ATTR, since it contains a field with that alignment.  So
> technically isn't the full alignment still needed, as the compiler can assume
> that struct skcipher_request is CRYPTO_MINALIGN_ATTR-aligned?
>

The assumption is that ARCH_SLAB_MINALIGN should be sufficient for any
POD type, But I guess that in order to be fully correct, the actual
alignment of the struct type should be ARCH_SLAB_MINALIGN, and __ctx
should just be padded out so it appears at an offset that is a
multiple of ARCH_KMALLOC_ALIGN.

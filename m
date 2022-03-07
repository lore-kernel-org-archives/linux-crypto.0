Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491BEC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Mar 2022 12:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbiCGMse (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 07:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242507AbiCGMsd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 07:48:33 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982A95F68
        for <linux-crypto@vger.kernel.org>; Mon,  7 Mar 2022 04:47:34 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id u10so10836857ybd.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Mar 2022 04:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eFuv1CZ1FCJvRh23WLfkSzv/heaOZIC7c/13FaNc3Wo=;
        b=2TAsd6PKCXUlgIYEC6sOsRFGGOkyw4qtPi3sHqqzwqVeNt8xoIqr4ya+hu98UH+oZp
         9nStNtbMrEplhF7ylmE7V8+iGZ0D/g8UktjAXaXEK5Ef7u7l0BW6wUluEX6bcH44IB5a
         QSA8dd5KHnfphZ2xnrUU3qmNHWJDYfdUagRgyUc7WT+Y9+Dl7r6hG+jh5cWBlKcg6VOi
         3zv9gy5eEFkjVnHXKBudMe8eA6JKj7hcc86GrBfVsOIT3NBM94YOoYPRTeLflTLhOIA/
         XAerpQxZdma6VuD/ALzQzgvqOzgEDApXsGzBsxOOXG345TY7QqTC4kNJMdYK69quy70W
         kYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eFuv1CZ1FCJvRh23WLfkSzv/heaOZIC7c/13FaNc3Wo=;
        b=rETI6pUZ2fbHMMMkj4SzoKNz0h8ya9srpjt/XRRzw3B2Qh/l59YTKO4roUIh0Ga33J
         6iSucu5UViT9vrIo0yc7kMUxKRyhbADRMGPiJzvo4eBRMcgmFp25zepQoR6qn44E/ezh
         coGqYZHqn/mAIn55kBADhJP+Zb33U93nms+gImo5CzLWJkEM4MiFX1epHExFM7riyO4r
         +P7TKxpSwpgLW1/SjYPgMiphIOOGUDcL6pRyMEgjEfa+tzLYTwaphb2KZDAt1jViMZBZ
         Fs30ysStj7PVykBKH4jtag0fk/Xz4gqqRZ5DuDff8jisH5OMXcQGkRd6d9QXx1eVQPZ+
         P0nQ==
X-Gm-Message-State: AOAM530xrXEs5JZloVlcsqJKsvfT0ymUiO5fo5b/BN+xL6LlQcWRDZe+
        Bizu/qb6UsE3vsgXXNTJfOQgp2iWmbfbCdD/jl6E4A==
X-Google-Smtp-Source: ABdhPJy7A9l6pgeT9iD8kwzothv8rOOmhOR5TCpERcX/K56cv0Decwr3OQIeVGeijmRGnFQO/VzxBFXZqGXRiun68q0=
X-Received: by 2002:a25:5509:0:b0:622:1c12:4230 with SMTP id
 j9-20020a255509000000b006221c124230mr7750645ybb.416.1646657253810; Mon, 07
 Mar 2022 04:47:33 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMeoYcVm7OQdqXd1V5iPSXW_BkVxx6TA6nF7zTLVeHe0Ww@mail.gmail.com>
 <CAOtvUMfy1fF35B2sfbOMui8n9Q4iCke9rgn5TiYMUMjd8gqHsA@mail.gmail.com>
 <YhKV55t90HWm6bhv@Red> <CAOtvUMdRU4wnRCXsC+U5XBDp+b+u8w7W7JCUKW2+ohuJz3PVhQ@mail.gmail.com>
 <YhOcEQEjIKBrbMIZ@Red> <CAOtvUMfN8U4+eG-TEVW4bSE6kOzuOSsJE4dOYGXYuWQKNzv7wQ@mail.gmail.com>
 <CAOtvUMeRb=j=NDrc88x8aB-3=D1mxZ_-aA1d4FfvJmj7Jrbi4w@mail.gmail.com>
 <YiIUXtxd44ut5uzV@Red> <YiUsWosH+MKMF7DQ@gondor.apana.org.au>
 <CAOtvUMcudG3ySU+VeE7hfneDVWGLKFTnws-xjhq4hgFYSj0qOg@mail.gmail.com>
 <YiXjCcXXk0f18FDL@Red> <aca4117c-b7a5-f7eb-eb03-4e1f1a93a730@arm.com>
 <CAOtvUMePFR4e2jgHZKOvs3J3Xt4NzRbzD_=vr_49Qgs5HTrvHw@mail.gmail.com> <6cf91f43-df23-3ac9-e9b5-958d99d37422@arm.com>
In-Reply-To: <6cf91f43-df23-3ac9-e9b5-958d99d37422@arm.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 7 Mar 2022 14:47:23 +0200
Message-ID: <CAOtvUMedqSNKx9Aah0R_aAyjKO0pn4K75MrCnbh_zX+Zw9vRQA@mail.gmail.com>
Subject: Re: [BUG] crypto: ccree: driver does not handle case where cryptlen =
 authsize =0
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Christoph Hellwig <hch@lst.de>, m.szyprowski@samsung.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 7, 2022 at 2:36 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2022-03-07 12:17, Gilad Ben-Yossef wrote:
> > On Mon, Mar 7, 2022 at 1:14 PM Robin Murphy <robin.murphy@arm.com> wrot=
e:
> >
> >> The "overlap" is in the sense of having more than one mapping within t=
he
> >> same cacheline:
> >>
> >> [  142.458120] DMA-API: add_dma_entry start P=3Dba79f200 N=3Dba79f
> >> D=3Dba79f200 L=3D10 DMA_FROM_DEVICE attrs=3D0
> >> [  142.458156] DMA-API: add_dma_entry start P=3D445dc010 N=3D445dc
> >> D=3D445dc010 L=3D10 DMA_TO_DEVICE attrs=3D0
> >> [  142.458178] sun8i-ss 1c15000.crypto: SRC 0/1/1 445dc000 len=3D16 bi=
=3D0
> >> [  142.458215] sun8i-ss 1c15000.crypto: DST 0/1/1 ba79f200 len=3D16 bi=
=3D0
> >> [  142.458234] DMA-API: add_dma_entry start P=3Dba79f210 N=3Dba79f
> >> D=3Dba79f210 L=3D10 DMA_FROM_DEVICE attrs=3D0
> >>
> >> This actually illustrates exactly the reason why this is unsupportable=
.
> >> ba79f200 is mapped for DMA_FROM_DEVICE, therefore subsequently mapping
> >> ba79f210 for DMA_TO_DEVICE may cause the cacheline covering the range
> >> ba79f200-ba79f23f to be written back over the top of data that the
> >> device has already started to write to memory. Hello data corruption.
> >>
> >> Separate DMA mappings should be from separate memory allocations,
> >> respecting ARCH_DMA_MINALIGN.
> >
> > hmm... I know I'm missing something here, but how does this align with
> > the following from active_cacheline_insert() in kernel/dma/debug.c ?
> >
> >          /* If the device is not writing memory then we don't have any
> >           * concerns about the cpu consuming stale data.  This mitigate=
s
> >           * legitimate usages of overlapping mappings.
> >           */
> >          if (entry->direction =3D=3D DMA_TO_DEVICE)
> >                  return 0;
>
> It's OK to have multiple mappings that are *all* DMA_TO_DEVICE, which
> looks to be the case that this check was intended to allow. However I
> think you're right that it should still actually check for conflicting
> directions between the new entry and any existing ones, otherwise it
> ends up a bit too lenient.
>
> Cheers,
> Robin.

I understand what you are saying about why checking for conflicting
directions may be a good thing, but given that the code is as it is
right now, how are we seeing the warning for two mapping that one of
them is DMA_TO_DEVICE?

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

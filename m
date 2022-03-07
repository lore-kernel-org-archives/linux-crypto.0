Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36012C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Mar 2022 13:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiCGNXG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Mar 2022 08:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242908AbiCGNXE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Mar 2022 08:23:04 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A367A9A0
        for <linux-crypto@vger.kernel.org>; Mon,  7 Mar 2022 05:22:10 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2d07ae0b1c0so163514397b3.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Mar 2022 05:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7oDoWa/WXO0HRiAR3FYfDPHuuMG9SE634o9q9OLcXr4=;
        b=zyZStyBdAViuPZW9wkcsXwR7+fT9bJrITQ2ZKvu3QTWVKxlWLy5mrmZ19yZxqPmpyI
         VkAXmRizMHDJh/MFSFGxk5NJA2cVrrmKt4U/hdrGDscEVzujD5VMRyzLGnQJU3v+OYcQ
         brxCntmql2y/zoTn7yXUn9bN9lRsoD66D9zQgQ9CMWcENYen15Z05vI8LBSCCceSyFuC
         zcEkIAR2P2AoneetJjwo3iniEadu3BeXE/fuyDeAjsi6XfEUnzd/a5pEDGJsODMZh7k3
         9XzRm1hCzWr2NN/drttHWY0ZQr6etkSbnTytwsAYutdn5clAjadxkuWsaAd+DlmEP+nb
         caaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7oDoWa/WXO0HRiAR3FYfDPHuuMG9SE634o9q9OLcXr4=;
        b=ZT/5JBDetnc6Ppyw8gjtjxKeZSKtNxzKgEpewMm4RuBFlgH3GWSFd7lQMoePnCVqHO
         hJk6kao1V/5pPjYLRnCDZ7sQockg4y9w0pu+RO1jps8+WjuuNvfK/gAGtQgz8a/sgE7W
         UScag9AILTTG366Xmr9BOFBBO+ws9MaAtjwfp4poC/xGFjOvLUo4Rk+QG6Mm3bi4zYVw
         hfiv3ZnhGN7z9wELwasIrA1MDdM3lFajhWXNG1pzNec9FmxtO22g8N9n4JPgSIILgQKv
         rO2z5WJbXqrrRR/8a4XJVnXeLDdrNou2xKUgeeYBD9hIuPS9u3XhvAn5+oQSCNB05PDq
         +b6g==
X-Gm-Message-State: AOAM532+Q+/ZyNo54YKDAJPrgLj2V4YLmgRhedtaVFZgpqo8cXuj2JMz
        mVZa9q0YjcjnpNuQFxlI7x3An/l3/GpKgB75JjQqLg==
X-Google-Smtp-Source: ABdhPJwWHyCRmEtXGbQdVI93JxNWbSQv1j1WSn4xgNCCimNig7ktZEtlxXBn4d3h3waSXP57EYn48/o/1hPC6BYVksE=
X-Received: by 2002:a81:6c6:0:b0:2dc:616b:468b with SMTP id
 189-20020a8106c6000000b002dc616b468bmr8087023ywg.472.1646659329804; Mon, 07
 Mar 2022 05:22:09 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMeoYcVm7OQdqXd1V5iPSXW_BkVxx6TA6nF7zTLVeHe0Ww@mail.gmail.com>
 <CAOtvUMfy1fF35B2sfbOMui8n9Q4iCke9rgn5TiYMUMjd8gqHsA@mail.gmail.com>
 <YhKV55t90HWm6bhv@Red> <CAOtvUMdRU4wnRCXsC+U5XBDp+b+u8w7W7JCUKW2+ohuJz3PVhQ@mail.gmail.com>
 <YhOcEQEjIKBrbMIZ@Red> <CAOtvUMfN8U4+eG-TEVW4bSE6kOzuOSsJE4dOYGXYuWQKNzv7wQ@mail.gmail.com>
 <CAOtvUMeRb=j=NDrc88x8aB-3=D1mxZ_-aA1d4FfvJmj7Jrbi4w@mail.gmail.com>
 <YiIUXtxd44ut5uzV@Red> <YiUsWosH+MKMF7DQ@gondor.apana.org.au>
 <CAOtvUMcudG3ySU+VeE7hfneDVWGLKFTnws-xjhq4hgFYSj0qOg@mail.gmail.com>
 <YiXjCcXXk0f18FDL@Red> <aca4117c-b7a5-f7eb-eb03-4e1f1a93a730@arm.com>
 <CAOtvUMePFR4e2jgHZKOvs3J3Xt4NzRbzD_=vr_49Qgs5HTrvHw@mail.gmail.com>
 <6cf91f43-df23-3ac9-e9b5-958d99d37422@arm.com> <CAOtvUMedqSNKx9Aah0R_aAyjKO0pn4K75MrCnbh_zX+Zw9vRQA@mail.gmail.com>
 <371ef3f2-883d-91ab-ed96-da8921efb465@arm.com> <b7a3e828-c848-2d42-9f91-d282b9c1ac9e@arm.com>
In-Reply-To: <b7a3e828-c848-2d42-9f91-d282b9c1ac9e@arm.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 7 Mar 2022 15:21:58 +0200
Message-ID: <CAOtvUMf_LPN80MV_GmnA6P2y8-PiazZ8nahDp_Gdpz-Ns3n8pw@mail.gmail.com>
Subject: Re: [BUG] crypto: ccree: driver does not handle case where cryptlen =
 authsize =0
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 7, 2022 at 3:12 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2022-03-07 13:03, Robin Murphy wrote:
> > On 2022-03-07 12:47, Gilad Ben-Yossef wrote:
> >> On Mon, Mar 7, 2022 at 2:36 PM Robin Murphy <robin.murphy@arm.com> wro=
te:
> >>>
> >>> On 2022-03-07 12:17, Gilad Ben-Yossef wrote:
> >>>> On Mon, Mar 7, 2022 at 1:14 PM Robin Murphy <robin.murphy@arm.com>
> >>>> wrote:
> >>>>
> >>>>> The "overlap" is in the sense of having more than one mapping
> >>>>> within the
> >>>>> same cacheline:
> >>>>>
> >>>>> [  142.458120] DMA-API: add_dma_entry start P=3Dba79f200 N=3Dba79f
> >>>>> D=3Dba79f200 L=3D10 DMA_FROM_DEVICE attrs=3D0
> >>>>> [  142.458156] DMA-API: add_dma_entry start P=3D445dc010 N=3D445dc
> >>>>> D=3D445dc010 L=3D10 DMA_TO_DEVICE attrs=3D0
> >>>>> [  142.458178] sun8i-ss 1c15000.crypto: SRC 0/1/1 445dc000 len=3D16=
 bi=3D0
> >>>>> [  142.458215] sun8i-ss 1c15000.crypto: DST 0/1/1 ba79f200 len=3D16=
 bi=3D0
> >>>>> [  142.458234] DMA-API: add_dma_entry start P=3Dba79f210 N=3Dba79f
> >>>>> D=3Dba79f210 L=3D10 DMA_FROM_DEVICE attrs=3D0
> >>>>>
> >>>>> This actually illustrates exactly the reason why this is
> >>>>> unsupportable.
> >>>>> ba79f200 is mapped for DMA_FROM_DEVICE, therefore subsequently mapp=
ing
> >>>>> ba79f210 for DMA_TO_DEVICE may cause the cacheline covering the ran=
ge
> >>>>> ba79f200-ba79f23f to be written back over the top of data that the
> >>>>> device has already started to write to memory. Hello data corruptio=
n.
> >>>>>
> >>>>> Separate DMA mappings should be from separate memory allocations,
> >>>>> respecting ARCH_DMA_MINALIGN.
> >>>>
> >>>> hmm... I know I'm missing something here, but how does this align wi=
th
> >>>> the following from active_cacheline_insert() in kernel/dma/debug.c ?
> >>>>
> >>>>           /* If the device is not writing memory then we don't have =
any
> >>>>            * concerns about the cpu consuming stale data.  This
> >>>> mitigates
> >>>>            * legitimate usages of overlapping mappings.
> >>>>            */
> >>>>           if (entry->direction =3D=3D DMA_TO_DEVICE)
> >>>>                   return 0;
> >>>
> >>> It's OK to have multiple mappings that are *all* DMA_TO_DEVICE, which
> >>> looks to be the case that this check was intended to allow. However I
> >>> think you're right that it should still actually check for conflictin=
g
> >>> directions between the new entry and any existing ones, otherwise it
> >>> ends up a bit too lenient.
> >>>
> >>> Cheers,
> >>> Robin.
> >>
> >> I understand what you are saying about why checking for conflicting
> >> directions may be a good thing, but given that the code is as it is
> >> right now, how are we seeing the warning for two mapping that one of
> >> them is DMA_TO_DEVICE?
> >
> > Because it's the second one that isn't. The warning is triggered by
> > adding the DMA_FROM_DEVICE entry, which *is* checked, and finds the
> > DMA_TO_DEVICE entry already present. What's not great is that if those
> > two mappings happened to be made in the opposite order then it would be
> > missed entirely.
>
> Urgh, no, sorry, that's some imaginary conflation of the cacheline radix
> tree with the entry hash bucket...
>
> What's actually happened here is that I've failed to read the log
> properly and they're both DMA_FROM_DEVICE. But the potential problem of
> mixed-direction mappings being missed does still stand in general.

Ah, right!

OK, Now I feel a little better.

You know, I think that dma debug logic is oversimplified a bit in
other ways too.

Think for example about the scenario that started this - a (crypto,
but it doesn't matter) gets two sg lists - src and dst.
It will map the src for DMA_TO_DEVICE and the dst as DMA_FROM_DEVICE.

Now the two sg list might actually be one and the same or they might
be two different sg lists but referring to the exact same buffers.

So long as  the driver DMA maps, says, the src first and then the dst,
or vice versa, and does not initiate any read/write from either the
CPU or device until the 2nd mapping, I would claim that this is
perfectly safe (same thing for not touching the buffer post the first
unmap and before the 2nd) and it does simplify the driver quite a bit
- but the dma debug logic will consider it an error right now.

Gilad




--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

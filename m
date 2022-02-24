Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC03C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Feb 2022 07:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiBXHIU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Feb 2022 02:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiBXHIT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Feb 2022 02:08:19 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30EE1662C2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 23:07:48 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id c6so2054655ybk.3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Feb 2022 23:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1X6aiDuwhzrhMyLMxYmlkSZVVGDy4novfqX5OK+BUaw=;
        b=yBrrp+o4e+xRvueTJTUzMUS9L7289KvNfyOzMa6N5Dz/BSJguc2ibe0r+xaMv8nFeI
         AQ51uWIo4c0vl0Q791m2xPwyIFJY2RaOVsJy3dq7evFkRyePEnUiozkICP5Oht7ka79E
         ox8EMcDpU7n0GQFh0MZ/oNkTggBxzcGZKGpvIclmL04m4AaOQ6qhttWjPQP2zytw18/z
         LrXsef12VaY22DKwgWsUf6T+2pRbpQRB/NvGPYZ96U5ddBmHmWUXX+HJlg+YXUk77jba
         nbBNuXR6ov8A9Dma5qq0YGHovRbPU4knS83TV/9XyVjcAc8bytFMR8HtQIilq2jUMDf5
         9itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1X6aiDuwhzrhMyLMxYmlkSZVVGDy4novfqX5OK+BUaw=;
        b=FNm7xnrZfQvHYRdhoPHtZ8FUjnkKaA1M8jQkfg9WCjV4aaVTOsmHWtBPCyxYUTz59L
         q4rSBe0IxEOQDvalGB4XXnJce43T/5kABcvkFFefyvcR5Nm9K/HRlwaZOazh1LhqEzmZ
         l721Tzf13Hhtdtb9OIELUkSYnnOZH+FmiDqASe/IovVhO2mvydDaHJtGNM2AsSg56gN2
         ATgJpvidBsJlp85GUvxQs2hYODsvDWeBabBSd9pUbK+1p5dKtmfeaZQgY7wYIJlSX4Y+
         K8JqhLr13xzpRiYnlb2kBTHyW7Q1kUTyXlcUFMG7OUqpIr2+U+6iwHLf/ZMl9sRWzYDw
         D6sw==
X-Gm-Message-State: AOAM530xQLCdit3Lqsw8QaB2O1UE2gQ6iMCqA2bt3evwemCfk7nwxdyN
        hWv2pMg0MmRYpFJWhEq8i5xbObM5DAV47Z0OtFxYlA==
X-Google-Smtp-Source: ABdhPJyp/KOIEtD2wrL2LzN1PJUF8ONtxv1pZdvrxErgXNHHhZ0TAnZqMlP/DnoV0zfMVz9WyL/VwYUk2dEI+VQUvXc=
X-Received: by 2002:a25:9d81:0:b0:622:7df3:ff6c with SMTP id
 v1-20020a259d81000000b006227df3ff6cmr1232527ybp.617.1645686468075; Wed, 23
 Feb 2022 23:07:48 -0800 (PST)
MIME-Version: 1.0
References: <20220223080400.139367-1-gilad@benyossef.com> <Yhbjq3cVsMVUQLio@sol.localdomain>
 <YhblA1qQ9XLb2nmO@sol.localdomain>
In-Reply-To: <YhblA1qQ9XLb2nmO@sol.localdomain>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 24 Feb 2022 09:07:47 +0200
Message-ID: <CAOtvUMfFhQABmmZe7EH-o=ULEChm_t=KY7ORBRgm94O=1MiuFw@mail.gmail.com>
Subject: Re: [PATCH] crypto: drbg: fix crypto api abuse
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Thu, Feb 24, 2022 at 3:53 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Feb 23, 2022 at 05:47:25PM -0800, Eric Biggers wrote:
> > On Wed, Feb 23, 2022 at 10:04:00AM +0200, Gilad Ben-Yossef wrote:
> > > the drbg code was binding the same buffer to two different
> > > scatter gather lists and submitting those as source and
> > > destination to a crypto api operation, thus potentially
> > > causing HW crypto drivers to perform overlapping DMA
> > > mappings which are not aware it is the same buffer.
> > >
> > > This can have serious consequences of data corruption of
> > > internal DRBG buffers and wrong RNG output.
> > >
> > > Fix this by reusing the same scatter gatther list for both
> > > src and dst.
> > >
> > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > > Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > > Tested-on: r8a7795-salvator-x
> > > Tested-on: xilinx-zc706
> > > Fixes: 43490e8046b5d ("crypto: drbg - in-place cipher operation for C=
TR")
> > > Cc: stable@vger.kernel.org
> >
> > Where is it documented and tested that the API doesn't allow this?
> > I wasn't aware of this case; it sounds perfectly allowed to me.
> > There might be a lot of other users who do this, not just drbg.c.
> >
>
> Just quickly looking through the code I maintain, there is another place =
that
> uses scatterlists like this: in fscrypt_crypt_block() in fs/crypto/crypto=
.c, the
> source and destination can be the same.  That's just the code I maintain;=
 I'm
> sure if you looked through the whole kernel you'd find a lot more.
>
> This sounds more like a driver bug, and a case we need to add self-tests =
for.

Thank you for the feedback. That is a very good question. Indeed, I
agree with you that in an ideal world the internal implementation details o=
f DMA
mapping would not pop up and interfere with higher level layer logic.

Let me describe my point of view and I would be very happy to hear
where I am wrong:

The root cause underlying this is that, of course,  hardware crypto
drivers map the sglists passed to them for DMA . Indeed, we require
input to crypto
API as sglists of DMAable buffers (and not, say stack allocated buffers) be=
cause
of this. So far I am just stating the obvious...

Now, it looks like the DMA api, accessed via dma_map_sg(), does not
like overlapping mappings. The bug report that triggered this patch (see:
https://lkml.org/lkml/2022/2/20/240) was an oops message including this
warning: "DMA-API: ccree e6601000.crypto: cacheline tracking EEXIST,
overlapping mappings aren't supported".

The messages comes from add_dma_entry() in kernel.dma/debug.c,
because, as stated in the commit message that added this check in May 2021:

"Since, overlapping mappings are not supported by the DMA API we
should report an error if active_cacheline_insert returns -EEXIST."
(https://lkml.org/lkml/2021/5/18/572)

For now, I will take it at a given that this is proper and you do not
consider this
an issue in the DMA API.

Now, driver writers are of course aware of this DMA API limitation and thus=
 we
check if the src sglist is the same as the dst sglist and if so only map on=
ce.
However, the underlying assumption is that the buffers pointed by different
sglists do not overlap. We do not iterate over all the sglist trying
to find overlaps.

When I see "we", it is because this behavior is not unique to the ccree dri=
ver:

Here is the same logic from a marvell cesa driver:
https://elixir.bootlin.com/linux/latest/source/drivers/crypto/marvell/cesa/=
cipher.c#L326

Here it is again in the camm driver:
https://elixir.bootlin.com/linux/latest/source/drivers/crypto/caam/caamalg.=
c#L1619

I do believe that at least all crypto HW drivers apply the same logic.

Of course, we can ask that every HW crypto driver (and possibly any other
sglist using HW driver) will add logic that scans each sglist for
overlapping buffers
and if found use a more sophisticated mapping (easy for a simple
sglist that has one buffer
identical to some other sglist, maybe more complicated if the overlap
is not identity).
The storage drivers sort of already do on some level, although I think
on a higher abstraction
layer than the drivers themselves if I'm not mistaken, though for
performance reasons.
This is certainly DOABLE in the sense that it can be achieved.

However, I don't think this is desirable. This will add non trivial
code with non trivial runtime
costs just to spot these cases. And we will need to fix ALL the hw
drivers, because, to the best
of my knowledge, none of them do this right now.

The remaining option is to enforce the rule of no overlap between
different sglists passed to the
crypto API. This seems much easier to me. Indeed, the fix I sent is a
one liner. I suspect all
other fixes are similar and I assume (but did not check) that there
are not many of those.
Indeed, I think it is much easier to impose the required limitation at
the API caller level.
It is not pretty, nor "just", but easier, I think.

I hope I've managed to explain my logic here.

I will note that even if we decide to follow the other route, we do
need to document and fix
probably every hw crypto (and possibly others) driver out there,
because AFAIK, no one is taking
into account this possibility right now.

Cheers,
Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

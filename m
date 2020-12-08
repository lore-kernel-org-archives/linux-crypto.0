Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14430C4361B
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 07:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA39423A40
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 07:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLHHog (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Dec 2020 02:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgLHHof (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Dec 2020 02:44:35 -0500
X-Gm-Message-State: AOAM5334J88SjrqH4GiILDyUUQw55i1LTmIS7oA2vHJY8+khCmw6H2sa
        BCh0PlgR9Dd6XOnNY0fOS8Am5hGz/CydeZi+bw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607413435;
        bh=20DbjnPlaklqjatnkgYSMVf9swPCDsVDbpGCQDuacg8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FldNkRWgSdyCM4hOMRzZM9jxOvFQLnhRpOt2zW9GAWokS713f42KIa8B44A4gNEx6
         6QRzXL5gO5H7bq+jjEyfAI0l49DGZYGzRudpKp/FVsbe1gNF4B/VbUeoO62PkOfaNQ
         I/V+3j2aVfUWTKlvKnHvkeoPWiPRPfc4EwvvaAlYAgkopYsC3o4c9OGCftW/xFgwyo
         4adYw4VHnZyV6bLlJ+TuwKEL93TaSWURFO6SzZef9f1yhRD7IvIvNf1TRB4X0Z0L6s
         d/T3VOGzCUpke/jn4WRPjmyKCQNVRJS50BZmoZPeqo6mj7uMkg+cU7NeEnrqRCzWub
         lkBWX6Q+VRe/A==
X-Google-Smtp-Source: ABdhPJxU+ZwhhlFtR8DkkAjOqDYntm3ovy3aMEkO7v14OAd7DR02MBBHiXO9I1mlt4EX8dj4EFeM3cUkRagW/1wSbRk=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr15465189otk.108.1607413434140;
 Mon, 07 Dec 2020 23:43:54 -0800 (PST)
MIME-Version: 1.0
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
 <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com> <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
 <6ab2e280-a699-67c6-2066-af0b7ea9b709@nxp.com>
In-Reply-To: <6ab2e280-a699-67c6-2066-af0b7ea9b709@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 8 Dec 2020 08:43:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGah=p7nOs3dBxhytpJYLQKctHjupeYRGAui+SGxOvezw@mail.gmail.com>
Message-ID: <CAMj1kXGah=p7nOs3dBxhytpJYLQKctHjupeYRGAui+SGxOvezw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 7 Dec 2020 at 14:50, Horia Geant=C4=83 <horia.geanta@nxp.com> wrote=
:
>
> On 11/26/2020 9:09 AM, Ard Biesheuvel wrote:
> > On Wed, 25 Nov 2020 at 22:39, Iuliana Prodan <iuliana.prodan@nxp.com> w=
rote:
> >>
> >> On 11/25/2020 11:16 PM, Ard Biesheuvel wrote:
> >>> On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
> >>> <iuliana.prodan@oss.nxp.com> wrote:
> >>>>
> >>>> From: Iuliana Prodan <iuliana.prodan@nxp.com>
> >>>>
> >>>> Add the option to allocate the crypto request object plus any extra =
space
> >>>> needed by the driver into a DMA-able memory.
> >>>>
> >>>> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
> >>>> indicate to crypto API the need to allocate GFP_DMA memory
> >>>> for private contexts of the crypto requests.
> >>>>
> >>>
> >>> These are always directional DMA mappings, right? So why can't we use
> >>> bounce buffering here?
> >>>
> >> The idea was to avoid allocating any memory in crypto drivers.
> >> We want to be able to use dm-crypt with CAAM, which needs DMA-able
> >> memory and increasing reqsize is not enough.
> >
> > But what does 'needs DMA-able memory' mean? DMA operations are
> > asynchronous by definition, and so the DMA layer should be able to
> > allocate bounce buffers when needed. This will cost some performance
> > in cases where the hardware cannot address all of memory directly, but
> > this is a consequence of the design, and I don't think we should
> > burden the generic API with this.
> >
> The performance loss due to bounce buffering is non-negligible.
> Previous experiments we did showed a 35% gain (when forcing all data,
> including I/O buffers, in ZONE_DMA32).
>
> I don't have the exact numbers for bounce buffering introduced by allowin=
g
> only by the control data structures (descriptors etc.) in high memory,
> but I don't think it's fair to easily dismiss this topic,
> given the big performance drop and relatively low impact
> on the generic API.
>

It is not about the impact on the API. It is about the layering
violation: all masters in a system will be affected by DMA addressing
limitations, and all will be affected by the performance impact of
bounce buffering when it is needed. DMA accessible memory is generally
'owned' by the DMA layer so it can be used for bounce buffering for
all masters. If one device starts claiming DMA-able memory for its own
use, other masters could be adversely affected, given that they may
not be able to do DMA at all (not even via bounce buffers) once a
single master uses up all DMA-able memory.

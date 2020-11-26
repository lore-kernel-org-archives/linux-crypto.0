Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF548C63798
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 17:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84AA821D46
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 17:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oc4jSHVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391237AbgKZRNJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 12:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390083AbgKZRNI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 12:13:08 -0500
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1C821D7E;
        Thu, 26 Nov 2020 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606410787;
        bh=wPvtDOtQvxniPFVl/LtU6cPrB5mf3Raj/1WlT/Ggv6Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oc4jSHVfy9GORY2wT6dfxUnKoTjvyys61BlKvTVi8MqAcRvU99Jq5n/URrjRNvJxe
         o17umLkiAfUsMawd5bpzcJPUtTSi8SfcM3VmPLRDAskySgJRhgGUpbADR9cZMalwjL
         DCGg5volwaRwgwQ5L/XP8nz+QCTNcrnc/2tXuKBk=
Received: by mail-ot1-f45.google.com with SMTP id f12so2395628oto.10;
        Thu, 26 Nov 2020 09:13:07 -0800 (PST)
X-Gm-Message-State: AOAM532LMx89bLksXmcUHoZefHFkuvWXAy8QWI02BP4VD+VZpSAyrF8W
        BFxgNYF+mVf89/c5K7UqHurXZ/6w2BKF4tdhSL8=
X-Google-Smtp-Source: ABdhPJwkA4GlgPVz4Bt9VWOXX3qijUlz/gcbzcTYFwKGQPldclFt9VwbtT9goDD5RR9K4hKUF53+36Y6b0t6TkWWaSE=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3022467otk.108.1606410786716;
 Thu, 26 Nov 2020 09:13:06 -0800 (PST)
MIME-Version: 1.0
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
 <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com> <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
 <50866e6a-e352-3728-a6c4-1fcc33af13f9@nxp.com>
In-Reply-To: <50866e6a-e352-3728-a6c4-1fcc33af13f9@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 26 Nov 2020 18:12:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGNqY18R7f=oOvrjeboVHVNZ415ASV6EOiwvXU_UKB5fQ@mail.gmail.com>
Message-ID: <CAMj1kXGNqY18R7f=oOvrjeboVHVNZ415ASV6EOiwvXU_UKB5fQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>,
        "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Nov 2020 at 17:00, Iuliana Prodan <iuliana.prodan@nxp.com> wrote=
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
> Ard, I believe you're right.
>
> In CAAM, for req->src and req->dst, which comes from crypto request, we
> use DMA mappings without knowing if the memory is DMAable or not.
>
> We should do the same for CAAM's hw descriptors commands and link
> tables. That's the extra memory allocated by increasing reqsize.
>

It depends on whether any such mappings are non-directional. But I
would not expect per-request mappings to be modifiable by both the CPU
and the device at the same time.


> Horia, do you see any limitations, in CAAM, for not using the above
> approach?
>
>
> >> It started from here
> >> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flo=
re.kernel.org%2Flinux-crypto%2F71b6f739-d4a8-8b26-bf78-ce9acf9a0f99%40nxp.c=
om%2FT%2F%23m39684173a2f0f4b83d8bcbec223e98169273d1e4&amp;data=3D04%7C01%7C=
iuliana.prodan%40nxp.com%7C436d50e009434fd1c52808d891da3c8f%7C686ea1d3bc2b4=
c6fa92cd99c5c301635%7C0%7C0%7C637419713794116972%7CUnknown%7CTWFpbGZsb3d8ey=
JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp=
;sdata=3D38rJuxFhPWDJXWc2R66Hu%2Fn7vve9u%2BeF0Evp%2BFAhCwQ%3D&amp;reserved=
=3D0
> >>
> >>>> For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
> >>>> esp_alloc_tmp() function for IPv4 and IPv6.
> >>>>
> >>>> This series includes an example of how a driver can use
> >>>> CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
> >>>> to avoid allocating memory at crypto request runtime.
> >>>> The extra size needed by the driver is added to the reqsize field
> >>>> that indicates how much memory could be needed per request.
> >>>>
> >>>> Iuliana Prodan (4):
> >>>>     crypto: add CRYPTO_TFM_REQ_DMA flag
> >>>>     net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto r=
equest
> >>>>     crypto: caam - avoid allocating memory at crypto request runtime=
 for
> >>>>       skcipher
> >>>>     crypto: caam - avoid allocating memory at crypto request runtime=
 for
> >>>>       aead
> >>>>
> >>>>    drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++----=
-----
> >>>>    include/crypto/aead.h         |   4 ++
> >>>>    include/crypto/akcipher.h     |  21 ++++++
> >>>>    include/crypto/hash.h         |   4 ++
> >>>>    include/crypto/skcipher.h     |   4 ++
> >>>>    include/linux/crypto.h        |   1 +
> >>>>    net/ipv4/esp4.c               |   7 +-
> >>>>    net/ipv6/esp6.c               |   7 +-
> >>>>    8 files changed, 144 insertions(+), 34 deletions(-)
> >>>>
> >>>> --
> >>>> 2.17.1
> >>>>

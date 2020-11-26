Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD62C56202
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 07:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8716620DD4
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 07:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTPKkC6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbgKZHJh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732858AbgKZHJg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 02:09:36 -0500
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9E8C2173E;
        Thu, 26 Nov 2020 07:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606374575;
        bh=gYDXlgsZWpJlTH5IBwMhLQhIJLkIkRHpENlBolMjrRQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oTPKkC6TsVMIEnC/CTomrBg//U4TJzkVKLZPJezjAholGF4ySAZnGaUHA5d8iBdkH
         pOgLmXiZL3XKYShAZJ36hwsdMJjtLl6CnIlCopNshGNVWqQr/si1E7f5JAixsvJMTi
         LDbTVjIeDjcJKPwMd1qLQuCtLnn67y/oEgOWeplg=
Received: by mail-ot1-f49.google.com with SMTP id n12so1097281otk.0;
        Wed, 25 Nov 2020 23:09:35 -0800 (PST)
X-Gm-Message-State: AOAM532/jdB2J5DKHuulFG4y0Yg7zI+BeCs5rEJGe9c5VvR16JbLaHPq
        Fn24QWVVA4W1iURtPjnO0RlsnsKnKb7J9A4PU9o=
X-Google-Smtp-Source: ABdhPJxb6SkEpbP9FZ17Y7abobH0uFO90UL2ggP1AOv7Vd0TF9BEx3AsmKbBbTz5TzOCM157l9+R8Tom6UCeughD9cU=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr1486485otk.108.1606374574919;
 Wed, 25 Nov 2020 23:09:34 -0800 (PST)
MIME-Version: 1.0
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
 <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com> <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com>
In-Reply-To: <20b1493d-bfb6-d0bc-3b73-740b216db5f2@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 26 Nov 2020 08:09:23 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
Message-ID: <CAMj1kXGBa7st9duOu1Z1y28_-Xci3ur7kevAP+pPFp6+xvcy2Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 25 Nov 2020 at 22:39, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> On 11/25/2020 11:16 PM, Ard Biesheuvel wrote:
> > On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
> > <iuliana.prodan@oss.nxp.com> wrote:
> >>
> >> From: Iuliana Prodan <iuliana.prodan@nxp.com>
> >>
> >> Add the option to allocate the crypto request object plus any extra space
> >> needed by the driver into a DMA-able memory.
> >>
> >> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
> >> indicate to crypto API the need to allocate GFP_DMA memory
> >> for private contexts of the crypto requests.
> >>
> >
> > These are always directional DMA mappings, right? So why can't we use
> > bounce buffering here?
> >
> The idea was to avoid allocating any memory in crypto drivers.
> We want to be able to use dm-crypt with CAAM, which needs DMA-able
> memory and increasing reqsize is not enough.

But what does 'needs DMA-able memory' mean? DMA operations are
asynchronous by definition, and so the DMA layer should be able to
allocate bounce buffers when needed. This will cost some performance
in cases where the hardware cannot address all of memory directly, but
this is a consequence of the design, and I don't think we should
burden the generic API with this.


> It started from here
> https://lore.kernel.org/linux-crypto/71b6f739-d4a8-8b26-bf78-ce9acf9a0f99@nxp.com/T/#m39684173a2f0f4b83d8bcbec223e98169273d1e4
>
> >> For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
> >> esp_alloc_tmp() function for IPv4 and IPv6.
> >>
> >> This series includes an example of how a driver can use
> >> CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
> >> to avoid allocating memory at crypto request runtime.
> >> The extra size needed by the driver is added to the reqsize field
> >> that indicates how much memory could be needed per request.
> >>
> >> Iuliana Prodan (4):
> >>    crypto: add CRYPTO_TFM_REQ_DMA flag
> >>    net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
> >>    crypto: caam - avoid allocating memory at crypto request runtime for
> >>      skcipher
> >>    crypto: caam - avoid allocating memory at crypto request runtime for
> >>      aead
> >>
> >>   drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++---------
> >>   include/crypto/aead.h         |   4 ++
> >>   include/crypto/akcipher.h     |  21 ++++++
> >>   include/crypto/hash.h         |   4 ++
> >>   include/crypto/skcipher.h     |   4 ++
> >>   include/linux/crypto.h        |   1 +
> >>   net/ipv4/esp4.c               |   7 +-
> >>   net/ipv6/esp6.c               |   7 +-
> >>   8 files changed, 144 insertions(+), 34 deletions(-)
> >>
> >> --
> >> 2.17.1
> >>

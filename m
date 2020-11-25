Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F970C56202
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E352067D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 21:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRRjETqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbgKYVRL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731796AbgKYVRK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 16:17:10 -0500
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BA52083E;
        Wed, 25 Nov 2020 21:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606339029;
        bh=58337+gs43iP+cFDxloCX/PrwkDLWOuPYltM2JNApwc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZRRjETqAJR47pcyuqxnSuqvNCs2wh1ZDuFvp/uMjJ3UwnmfsbDC9VPx89WbkUJww2
         s+YUXJIPU+174mRAbEaDi1XKTP0HLR4Ufb8M6bUubvE7J6ZuYK+ia31bmXh/qaJoAI
         kq0inx9G5xv318ShlNc2SGMBB/YSgZSyLvlhf5oo=
Received: by mail-oi1-f169.google.com with SMTP id f11so4405165oij.6;
        Wed, 25 Nov 2020 13:17:09 -0800 (PST)
X-Gm-Message-State: AOAM532zmpcekmyJl5dIvnolhIoqB41KiQfx8opLUkpX9gj5LHdI42DQ
        AdZjcScgGNQHqvIpYn/23IRB4GFd1yqjpDy7qdM=
X-Google-Smtp-Source: ABdhPJxJBVmNIOvtJujpgR3VJApzRuQTSlu+F6vP6jX1mMfwH0XWfyKUvBrlni2i6l267ZnZRFSxuEvkOczTLR6PN4Y=
X-Received: by 2002:aca:c657:: with SMTP id w84mr5748oif.47.1606339029021;
 Wed, 25 Nov 2020 13:17:09 -0800 (PST)
MIME-Version: 1.0
References: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
In-Reply-To: <20201125211311.2179-1-iuliana.prodan@oss.nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Nov 2020 22:16:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
Message-ID: <CAMj1kXH=gyCz7NQXaAoNC4cf37t9E8znngyLFVPv+dO79=Z9oQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] crypto: add CRYPTO_TFM_REQ_DMA flag
To:     "Iuliana Prodan (OSS)" <iuliana.prodan@oss.nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 25 Nov 2020 at 22:14, Iuliana Prodan (OSS)
<iuliana.prodan@oss.nxp.com> wrote:
>
> From: Iuliana Prodan <iuliana.prodan@nxp.com>
>
> Add the option to allocate the crypto request object plus any extra space
> needed by the driver into a DMA-able memory.
>
> Add CRYPTO_TFM_REQ_DMA flag to be used by backend implementations to
> indicate to crypto API the need to allocate GFP_DMA memory
> for private contexts of the crypto requests.
>

These are always directional DMA mappings, right? So why can't we use
bounce buffering here?

> For IPsec use cases, CRYPTO_TFM_REQ_DMA flag is also checked in
> esp_alloc_tmp() function for IPv4 and IPv6.
>
> This series includes an example of how a driver can use
> CRYPTO_TFM_REQ_DMA flag while setting reqsize to a larger value
> to avoid allocating memory at crypto request runtime.
> The extra size needed by the driver is added to the reqsize field
> that indicates how much memory could be needed per request.
>
> Iuliana Prodan (4):
>   crypto: add CRYPTO_TFM_REQ_DMA flag
>   net: esp: check CRYPTO_TFM_REQ_DMA flag when allocating crypto request
>   crypto: caam - avoid allocating memory at crypto request runtime for
>     skcipher
>   crypto: caam - avoid allocating memory at crypto request runtime for
>     aead
>
>  drivers/crypto/caam/caamalg.c | 130 +++++++++++++++++++++++++---------
>  include/crypto/aead.h         |   4 ++
>  include/crypto/akcipher.h     |  21 ++++++
>  include/crypto/hash.h         |   4 ++
>  include/crypto/skcipher.h     |   4 ++
>  include/linux/crypto.h        |   1 +
>  net/ipv4/esp4.c               |   7 +-
>  net/ipv6/esp6.c               |   7 +-
>  8 files changed, 144 insertions(+), 34 deletions(-)
>
> --
> 2.17.1
>

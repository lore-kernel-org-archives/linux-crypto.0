Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED138C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B8224683
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgAVKNt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:13:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39094 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbgAVKNt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:13:49 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iuD15-0000VG-IR; Wed, 22 Jan 2020 18:13:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iuD12-00041s-0C; Wed, 22 Jan 2020 18:13:40 +0800
Date:   Wed, 22 Jan 2020 18:13:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tudor.Ambarus@microchip.com
Cc:     peter.ujfalusi@ti.com, Nicolas.Ferre@microchip.com,
        alexandre.belloni@bootlin.com, Ludovic.Desroches@microchip.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: atmel-{aes,sha,tdes} - Retire
 crypto_platform_data
Message-ID: <20200122101339.3myva6w3l5zhqzwt@gondor.apana.org.au>
References: <20200115125347.269203-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115125347.269203-1-tudor.ambarus@microchip.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 15, 2020 at 12:53:53PM +0000, Tudor.Ambarus@microchip.com wrote:
> From: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> These drivers no longer need it as they are only probed via DT.
> crypto_platform_data was allocated but unused, so remove it.
> This is a follow up for:
> commit 45a536e3a7e0 ("crypto: atmel-tdes - Retire dma_request_slave_channel_compat()")
> commit db28512f48e2 ("crypto: atmel-sha - Retire dma_request_slave_channel_compat()")
> commit 62f72cbdcf02 ("crypto: atmel-aes - Retire dma_request_slave_channel_compat()")
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/crypto/atmel-aes.c                 | 32 +-------------------
>  drivers/crypto/atmel-sha.c                 | 35 +---------------------
>  drivers/crypto/atmel-tdes.c                | 35 +---------------------
>  include/linux/platform_data/crypto-atmel.h | 23 --------------
>  4 files changed, 3 insertions(+), 122 deletions(-)
>  delete mode 100644 include/linux/platform_data/crypto-atmel.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

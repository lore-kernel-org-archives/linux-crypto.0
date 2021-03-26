Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6B2C433C1
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F08B561A36
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCZJaQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 05:30:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35340 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhCZJ3m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 05:29:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lPimY-0003Ro-So; Fri, 26 Mar 2021 20:29:32 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Mar 2021 20:29:30 +1100
Date:   Fri, 26 Mar 2021 20:29:30 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     clabbe.montjoie@gmail.com, clabbe@baylibre.com,
        gcherian@marvell.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH v2 0/4] Fix the parameter of dma_map_sg()
Message-ID: <20210326092930.GC12658@gondor.apana.org.au>
References: <1615859726-57062-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615859726-57062-1-git-send-email-chenxiang66@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 16, 2021 at 09:55:22AM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> According to Documentation/core-api/dma-api-howto.rst, the parameters
> of dma_unmap_sg() must be the same as those which are passed in to the
> scatter/gather mapping API.
> But for some drivers under crypto, the <nents> parameter of dma_unmap_sg()
> is number of elements after mapping. So fix them.
> 
> Part of the document is as follows:
> 
> To unmap a scatterlist, just call::
> 
>         dma_unmap_sg(dev, sglist, nents, direction);
> 	
> Again, make sure DMA activity has already finished.
> 	
>         .. note::
> 		
> 	    The 'nents' argument to the dma_unmap_sg call must be
> 	    the _same_ one you passed into the dma_map_sg call,
> 	    it should _NOT_ be the 'count' value _returned_ from the
> 	    dma_map_sg call.
> 
> Change Log:
> v1 -> v2: Remove changing the count passed to create_sg_component 
> in driver cavium;
> 
> Xiang Chen (4):
>   crypto: amlogic - Fix the parameter of dma_unmap_sg()
>   crypto: cavium - Fix the parameter of dma_unmap_sg()
>   crypto: ux500 - Fix the parameter of dma_unmap_sg()
>   crypto: allwinner - Fix the parameter of dma_unmap_sg()
> 
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 ++++++---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 3 ++-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 ++++++---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 ++-
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 6 +++---
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c        | 9 +++++----
>  drivers/crypto/ux500/cryp/cryp_core.c               | 4 ++--
>  drivers/crypto/ux500/hash/hash_core.c               | 2 +-
>  8 files changed, 27 insertions(+), 18 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

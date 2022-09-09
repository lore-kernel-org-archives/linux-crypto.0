Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440AEECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 09:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiIIJIx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiIIJIe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 05:08:34 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5424A024B;
        Fri,  9 Sep 2022 02:08:31 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oWZzp-002oF4-Td; Fri, 09 Sep 2022 19:08:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Sep 2022 17:08:21 +0800
Date:   Fri, 9 Sep 2022 17:08:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Koba Ko <koba.ko@canonical.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] crypto: ccp - Release dma channels before dmaengine
 unrgister
Message-ID: <YxsCheU982Xqkuhx@gondor.apana.org.au>
References: <20220901144712.1192698-1-koba.ko@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901144712.1192698-1-koba.ko@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 01, 2022 at 10:47:12PM +0800, Koba Ko wrote:
> A warning is shown during shutdown,
> 
> __dma_async_device_channel_unregister called while 2 clients hold a reference
> WARNING: CPU: 15 PID: 1 at drivers/dma/dmaengine.c:1110 __dma_async_device_channel_unregister+0xb7/0xc0
> 
> Call dma_release_channel for occupied channles before dma_async_device_unregister.
> 
> Fixes: 54cce8ecb925 ("crypto: ccp - ccp_dmaengine_unregister release dma channels")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Koba Ko <koba.ko@canonical.com>
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> ---
> V2: Fix the unused warning
> V3: Fix the Fixes: tag.
> ---
>  drivers/crypto/ccp/ccp-dmaengine.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

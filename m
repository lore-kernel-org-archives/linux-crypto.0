Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A188CC001DB
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Aug 2023 04:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjHDEft (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Aug 2023 00:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHDEfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Aug 2023 00:35:48 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BFB4207;
        Thu,  3 Aug 2023 21:35:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qRmXE-003WdT-45; Fri, 04 Aug 2023 12:35:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Aug 2023 12:35:32 +0800
Date:   Fri, 4 Aug 2023 12:35:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gaurav Jain <gaurav.jain@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Varun Sethi <V.Sethi@nxp.com>,
        Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: use dma align for crypt tfm ctx
Message-ID: <ZMyAFINQvlbk+MYF@gondor.apana.org.au>
References: <20230803102901.3116858-1-gaurav.jain@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803102901.3116858-1-gaurav.jain@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 03, 2023 at 03:59:01PM +0530, Gaurav Jain wrote:
> enginectx is not set when use crypto_tfm_ctx.
> fixing this by modifying to crypto_tfm_ctx_dma
> 
> Fixes: 4cb4f7c11dee ("crypto: caam - Set DMA alignment explicitly")
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> ---
>  crypto/crypto_engine.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for catching this.  Unfortunately this fix will break other
drivers that do not use ctx_dma.

I'll try to fix by getting rid of enginectx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

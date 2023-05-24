Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F39FC77B7A
	for <linux-crypto@archiver.kernel.org>; Wed, 24 May 2023 10:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjEXKPc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 May 2023 06:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjEXKOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2023 06:14:48 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53CFE4F;
        Wed, 24 May 2023 03:14:44 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q1lVq-00Cl03-NB; Wed, 24 May 2023 18:14:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 May 2023 18:14:34 +0800
Date:   Wed, 24 May 2023 18:14:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hwrng: imx-rngc - two simple cleanups
Message-ID: <ZG3jivQk335S1Gln@gondor.apana.org.au>
References: <20230519161119.287268-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519161119.287268-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 19, 2023 at 06:11:17PM +0200, Martin Kaiser wrote:
> Here's two more simple cleanups for imx-rngc. We can drop .data = NULL in the
> imx_rngc_dt_ids. And the probe function can be marked as __init as we don't
> support hotplugging.
> 
> Martin Kaiser (2):
>   hwrng: imx-rngc - mark the probe function as __init
>   hwrng: imx-rngc - don't init of_device_id's data
> 
>  drivers/char/hw_random/imx-rngc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> 2.30.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

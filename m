Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFD6C7EE22
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 05:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjEKFRH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 01:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjEKFRG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 01:17:06 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73111420B;
        Wed, 10 May 2023 22:17:01 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pwyfU-007a2A-HF; Thu, 11 May 2023 13:16:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 May 2023 13:16:45 +0800
Date:   Thu, 11 May 2023 13:16:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hwrng: imx-rngc - use bitfield macros to read fifo
 level
Message-ID: <ZFx6PXL9LzyDRoER@gondor.apana.org.au>
References: <20230427185357.923412-1-martin@kaiser.cx>
 <20230427185357.923412-2-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427185357.923412-2-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 27, 2023 at 08:53:55PM +0200, Martin Kaiser wrote:
>
> @@ -133,9 +133,7 @@ static int imx_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  			break;
>  
>  		/* how many random numbers are in FIFO? [0-16] */
> -		level = (status & RNGC_STATUS_FIFO_LEVEL_MASK) >>
> -			RNGC_STATUS_FIFO_LEVEL_SHIFT;
> -
> +		level = FIELD_GET(RNGC_STATUS_FIFO_LEVEL, status);

Wouldn't it be simpler to just get rid of the shift?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

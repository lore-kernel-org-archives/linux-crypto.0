Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1217C0015E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jul 2023 02:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjGVCOL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jul 2023 22:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjGVCOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2023 22:14:11 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3733C03;
        Fri, 21 Jul 2023 19:14:08 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qN288-002D88-LV; Sat, 22 Jul 2023 12:14:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Jul 2023 14:13:53 +1200
Date:   Sat, 22 Jul 2023 14:13:53 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     olivier@sobrie.be, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] hwrng: ba431 - trivial cleanups
Message-ID: <ZLs7YZ+b+BwiEeSe@gondor.apana.org.au>
References: <20230713070446.230978-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713070446.230978-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 13, 2023 at 09:04:43AM +0200, Martin Kaiser wrote:
> Here's three trivial clenaups of the ba431 driver. Compile-tested only.
> 
> Martin Kaiser (3):
>   hwrng: ba431 - do not set drvdata
>   hwrng: ba431 - don't init of_device_id's data
>   hwrng: ba431 - use dev_err_probe after failed registration
> 
>  drivers/char/hw_random/ba431-rng.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> -- 
> 2.30.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3169EB64DD
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jun 2023 08:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjFWIYM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jun 2023 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjFWIYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2023 04:24:10 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AF3212E;
        Fri, 23 Jun 2023 01:24:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qCc5G-006Kd0-OV; Fri, 23 Jun 2023 16:23:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jun 2023 16:23:58 +0800
Date:   Fri, 23 Jun 2023 16:23:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] hwrng: st - fix potential race condition
Message-ID: <ZJVWnjcfIJfB6tGI@gondor.apana.org.au>
References: <20230616083618.1320824-1-martin@kaiser.cx>
 <20230616085813.1323082-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616085813.1323082-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 16, 2023 at 09:58:11AM +0100, Martin Kaiser wrote:
> Fix a potential race condition in the st-rng driver. There's a short timeframe
> where the driver is still registered but its peripheral clock is disabled.
> 
> Add support for compile-testing the driver. I do not have any hardware that
> supports st-rng.
> 
> v2: Remove some more obsolete code and rephrase the explanation. The point is
>     that devres does now disable the clock.
> 
> Martin Kaiser (2):
>   hwrng: st - support compile-testing
>   hwrng: st - keep clock enabled while hwrng is registered
> 
>  drivers/char/hw_random/Kconfig  |  2 +-
>  drivers/char/hw_random/st-rng.c | 21 +--------------------
>  2 files changed, 2 insertions(+), 21 deletions(-)
> 
> -- 
> 2.30.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

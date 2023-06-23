Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7EFC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jun 2023 08:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjFWIYK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jun 2023 04:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjFWIYH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2023 04:24:07 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2642120;
        Fri, 23 Jun 2023 01:24:06 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qCc58-006Kad-4c; Fri, 23 Jun 2023 16:23:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jun 2023 16:23:50 +0800
Date:   Fri, 23 Jun 2023 16:23:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc - fix the timeout for init and self check
Message-ID: <ZJVWlkj+TmywIEY/@gondor.apana.org.au>
References: <20230615144959.1171085-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615144959.1171085-1-martin@kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 15, 2023 at 03:49:59PM +0100, Martin Kaiser wrote:
> Fix the timeout that is used for the initialisation and for the self
> test. wait_for_completion_timeout expects a timeout in jiffies, but
> RNGC_TIMEOUT is in milliseconds. Call msecs_to_jiffies to do the
> conversion.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/char/hw_random/imx-rngc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

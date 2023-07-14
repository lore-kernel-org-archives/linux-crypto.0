Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A81EB64DC
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 08:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbjGNI7O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbjGNI7G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 04:59:06 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91119273B;
        Fri, 14 Jul 2023 01:59:05 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qKEde-001Ri9-Ly; Fri, 14 Jul 2023 18:58:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jul 2023 18:58:51 +1000
Date:   Fri, 14 Jul 2023 18:58:51 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yangtao Li <frank.li@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: omap-des - Use
 devm_platform_get_and_ioremap_resource()
Message-ID: <ZLEOS+ejdb344Bq2@gondor.apana.org.au>
References: <20230705072159.77221-1-frank.li@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705072159.77221-1-frank.li@vivo.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 05, 2023 at 03:21:54PM +0800, Yangtao Li wrote:
> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to devm_platform_get_and_ioremap_resource(), as this is exactly
> what this function does.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
>  drivers/crypto/omap-des.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

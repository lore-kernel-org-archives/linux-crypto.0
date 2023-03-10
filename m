Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EDBC64EC4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCJL24 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCJL2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 06:28:39 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1396FFE4;
        Fri, 10 Mar 2023 03:28:30 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paaur-002XzN-EU; Fri, 10 Mar 2023 19:28:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 19:28:05 +0800
Date:   Fri, 10 Mar 2023 19:28:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, joel@jms.id.au, andrew@aj.id.au,
        neal_liu@aspeedtech.com, linux-aspeed@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: Use devm_platform_ioremap_resource()
Message-ID: <ZAsURY/nI6LywTuh@gondor.apana.org.au>
References: <20230220123921.7191-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220123921.7191-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 20, 2023 at 08:39:21PM +0800, Yang Li wrote:
> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to Use devm_platform_ioremap_resource(), as this is exactly
> what this function does.
> 
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/crypto/aspeed/aspeed-acry.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

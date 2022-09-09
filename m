Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CA9ECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 09:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiIIJHu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiIIJHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 05:07:38 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75714B9F8D;
        Fri,  9 Sep 2022 02:07:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oWZyY-002oCL-6i; Fri, 09 Sep 2022 19:07:03 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Sep 2022 17:07:02 +0800
Date:   Fri, 9 Sep 2022 17:07:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sun Ke <sunke32@huawei.com>
Cc:     neal_liu@aspeedtech.com, davem@davemloft.net, joel@jms.id.au,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: aspeed: fix return value check in
 aspeed_hace_probe()
Message-ID: <YxsCNv21af5ODo28@gondor.apana.org.au>
References: <20220830031347.810217-1-sunke32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830031347.810217-1-sunke32@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 30, 2022 at 11:13:47AM +0800, Sun Ke wrote:
> In case of error, the function devm_ioremap_resource() returns
> ERR_PTR() not NULL. The NULL test in the return value check must be
> replaced with IS_ERR().
> 
> Fixes: 108713a713c7 ("crypto: aspeed - Add HACE hash driver")
> Signed-off-by: Sun Ke <sunke32@huawei.com>
> ---
>  drivers/crypto/aspeed/aspeed-hace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] fix:caam:ctrl:add missing header dependencies
Date: Wed, 31 Aug 2016 23:18:24 +0800
Message-ID: <20160831151824.GC28366@gondor.apana.org.au>
References: <1472205384-29888-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, arnd@arndb.de, tudor-dan.ambarus@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        xie.baoyou@zte.com.cn
To: Baoyou Xie <baoyou.xie@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53399 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964863AbcHaPSu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 11:18:50 -0400
Content-Disposition: inline
In-Reply-To: <1472205384-29888-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 26, 2016 at 05:56:24PM +0800, Baoyou Xie wrote:
> We get 1 warning when biuld kernel with W=1:
> drivers/crypto/caam/ctrl.c:398:5: warning: no previous prototype for 'caam_get_era' [-Wmissing-prototypes]
> 
> In fact, this function is declared in drivers/crypto/caam/ctrl.h,
> so this patch add missing header dependencies.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

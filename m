From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: mediatek - remove ARM dependencies
Date: Fri, 13 Jan 2017 00:44:36 +0800
Message-ID: <20170112164435.GB20313@gondor.apana.org.au>
References: <20170111135104.3961730-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42465 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750803AbdALQpF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:45:05 -0500
Content-Disposition: inline
In-Reply-To: <20170111135104.3961730-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 11, 2017 at 02:50:19PM +0100, Arnd Bergmann wrote:
> Building the mediatek driver on an older ARM architecture results in a
> harmless warning:
> 
> warning: (ARCH_OMAP2PLUS_TYPICAL && CRYPTO_DEV_MEDIATEK) selects NEON which has unmet direct dependencies (VFPv3 && CPU_V7)
> 
> We could add an explicit dependency on CPU_V7, but it seems nicer to
> open up the build to additional configurations. This replaces the ARM
> optimized algorithm selection with the normal one that all other drivers
> use, and that in turn lets us relax the dependency on ARM and drop
> a number of the unrelated 'select' statements.
> 
> Obviously a real user would still select those other optimized drivers
> as a fallback, but as there is no strict dependency, we can leave that
> up to the user.
> 
> Fixes: 785e5c616c84 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

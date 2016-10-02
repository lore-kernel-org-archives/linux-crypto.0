From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sunxi-ss: mark sun4i_hash() static
Date: Sun, 2 Oct 2016 22:37:36 +0800
Message-ID: <20161002143736.GB18268@gondor.apana.org.au>
References: <1474691326-15541-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
To: Baoyou Xie <baoyou.xie@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54823 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbcJBOiC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Oct 2016 10:38:02 -0400
Content-Disposition: inline
In-Reply-To: <1474691326-15541-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 24, 2016 at 12:28:46PM +0800, Baoyou Xie wrote:
> We get 1 warning when building kernel with W=1:
> drivers/crypto/sunxi-ss/sun4i-ss-hash.c:168:5: warning: no previous prototype for 'sun4i_hash' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is
> declared and don't need a declaration, but can be made static.
> So this patch marks it 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

This patch has already been applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

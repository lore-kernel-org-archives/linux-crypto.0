Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEDAC77B61
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Apr 2023 07:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDIHrO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Apr 2023 03:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDIHrN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Apr 2023 03:47:13 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC84259EB;
        Sun,  9 Apr 2023 00:47:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1plPlL-00E301-Cu; Sun, 09 Apr 2023 15:47:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Apr 2023 15:46:59 +0800
Date:   Sun, 9 Apr 2023 15:46:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Zanussi <tom.zanussi@linux.intel.com>
Cc:     clabbe@baylibre.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: ixp4xx - Do not check word size when compile testing
Message-ID: <ZDJtc7C6YBgknbTq@gondor.apana.org.au>
References: <37694343f8b89dc0469d4a1718dad8f5f8c765bd.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37694343f8b89dc0469d4a1718dad8f5f8c765bd.camel@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 07, 2023 at 02:37:44PM -0500, Tom Zanussi wrote:
> COMPILE_TEST was added during the move to drivers/crypto/intel/ but
> shouldn't have been as it triggers a build bug when not compiled by
> the target compiler.  So remove it to match the original.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304061846.G6cpPXiQ-lkp@intel.com/
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  drivers/crypto/intel/ixp4xx/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

We could also fix it by making the BUILD_BUG_ON conditional:

---8<---
The BUILD_BUG_ON preventing compilation on foreign architectures
should be disabled when we're doing compile testing.

Fixes: 1bc7fdbf2677 ("crypto: ixp4xx - Move driver to...")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304061846.G6cpPXiQ-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index b63e2359a133..5d640f13ad1c 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -263,7 +263,8 @@ static int setup_crypt_desc(void)
 {
 	struct device *dev = &pdev->dev;
 
-	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_COMPILE_TEST) &&
+		     sizeof(struct crypt_ctl) != 64);
 	crypt_virt = dma_alloc_coherent(dev,
 					NPE_QLEN * sizeof(struct crypt_ctl),
 					&crypt_phys, GFP_ATOMIC);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

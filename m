Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8741ACD4936
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 23:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjITXUv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 19:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjITXUu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 19:20:50 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78CEC1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 16:20:42 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qj6UY-00GYrX-T8; Thu, 21 Sep 2023 07:20:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Sep 2023 07:20:25 +0800
Date:   Thu, 21 Sep 2023 07:20:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: [PATCH] ipsec: Select CRYPTO_AEAD
Message-ID: <ZQt+OWt0squwZr+z@gondor.apana.org.au>
References: <202309202112.33V1Ezb1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202309202112.33V1Ezb1-lkp@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 20, 2023 at 09:57:20PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   1c43c0f1f84aa59dfc98ce66f0a67b2922aa7f9d
> commit: a1383e2ab102c4e0d25304c07c66232c23ee0d9b [47/64] ipsec: Stop using crypto_has_alg
> config: arc-defconfig (https://download.01.org/0day-ci/archive/20230920/202309202112.33V1Ezb1-lkp@intel.com/config)
> compiler: arc-elf-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230920/202309202112.33V1Ezb1-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202309202112.33V1Ezb1-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arc-elf-ld: net/xfrm/xfrm_algo.o: in function `xfrm_aead_get_byname':
> >> xfrm_algo.c:(.text+0x46c): undefined reference to `crypto_has_aead'
> >> arc-elf-ld: xfrm_algo.c:(.text+0x46c): undefined reference to `crypto_has_aead'

---8<---
Select CRYPTO_AEAD so that crypto_has_aead is available.

Fixes: 1383e2ab102c ("ipsec: Stop using crypto_has_alg")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309202112.33V1Ezb1-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 3adf31a83a79..d7b16f2c23e9 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -15,6 +15,7 @@ config XFRM_ALGO
 	tristate
 	select XFRM
 	select CRYPTO
+	select CRYPTO_AEAD
 	select CRYPTO_HASH
 	select CRYPTO_SKCIPHER
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

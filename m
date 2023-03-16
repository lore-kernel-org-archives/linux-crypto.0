Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C4DC6FD1F
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Mar 2023 05:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjCPFan (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 01:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCPFam (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 01:30:42 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8581C332
        for <linux-crypto@vger.kernel.org>; Wed, 15 Mar 2023 22:30:32 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pcgBi-0050Ka-Qi; Thu, 16 Mar 2023 13:30:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Mar 2023 13:30:06 +0800
Date:   Thu, 16 Mar 2023 13:30:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        oe-kbuild-all@lists.linux.dev,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: ccree - Depend on HAS_IOMEM
Message-ID: <ZBKpXuRuEz3IRCZf@gondor.apana.org.au>
References: <202303161354.T2OZFUFZ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202303161354.T2OZFUFZ-lkp@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add dependency on HAS_IOMEM as the build will fail without it.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202303161354.T2OZFUFZ-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 351d05db39cf..ea0a1036c6e3 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -774,7 +774,7 @@ config CRYPTO_DEV_ARTPEC6
 config CRYPTO_DEV_CCREE
 	tristate "Support for ARM TrustZone CryptoCell family of security processors"
 	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
-	default n
+	depends on HAS_IOMEM
 	select CRYPTO_HASH
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_DES
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

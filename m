Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F80C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Mar 2022 03:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiCIDVF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDVE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 22:21:04 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276131598D7
        for <linux-crypto@vger.kernel.org>; Tue,  8 Mar 2022 19:20:06 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nRmrq-0002wc-2I; Wed, 09 Mar 2022 14:20:03 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Mar 2022 15:20:02 +1200
Date:   Wed, 9 Mar 2022 15:20:01 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harsha <harsha.harsha@xilinx.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: crypto: xilinx - Turn SHA into a tristate and allow COMPILE_TEST
Message-ID: <Yigc4cQlTJRRZsQg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch turns the new SHA driver into a tristate and also allows
compile testing.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5d7508230b7d..97455a5f05c1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -809,8 +809,8 @@ config CRYPTO_DEV_ZYNQMP_AES
 	  for AES algorithms.
 
 config CRYPTO_DEV_ZYNQMP_SHA3
-	bool "Support for Xilinx ZynqMP SHA3 hardware accelerator"
-	depends on ZYNQMP_FIRMWARE
+	tristate "Support for Xilinx ZynqMP SHA3 hardware accelerator"
+	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
 	select CRYPTO_SHA3
 	help
 	  Xilinx ZynqMP has SHA3 engine used for secure hash calculation.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

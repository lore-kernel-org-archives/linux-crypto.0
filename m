Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B50C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 09:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242624AbiDUJ7a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 05:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiDUJ73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 05:59:29 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D758521250
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 02:56:39 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nhTYC-005CyX-GS; Thu, 21 Apr 2022 19:56:38 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Apr 2022 17:56:36 +0800
Date:   Thu, 21 Apr 2022 17:56:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] hwrng: cn10k - Enable compile testing
Message-ID: <YmEqVLcteYSrDYr6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch enables COMPILE_TEST for cn10k.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index dad084c0ecee..faf0116fa9de 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -540,7 +540,7 @@ config HW_RANDOM_ARM_SMCCC_TRNG
 
 config HW_RANDOM_CN10K
        tristate "Marvell CN10K Random Number Generator support"
-       depends on HW_RANDOM && PCI && ARM64
+       depends on HW_RANDOM && PCI && (ARM64 || COMPILE_TEST)
        default HW_RANDOM
        help
 	 This driver provides support for the True Random Number
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D690DC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Apr 2022 08:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351401AbiDOIkT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiDOIkS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Apr 2022 04:40:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34556B647D;
        Fri, 15 Apr 2022 01:37:51 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nfHSc-003EWI-VJ; Fri, 15 Apr 2022 18:37:48 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Apr 2022 16:37:47 +0800
Date:   Fri, 15 Apr 2022 16:37:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     conor.dooley@microchip.com
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: hwrng: mpfs - Enable COMPILE_TEST
Message-ID: <Ylku27J41IMmMe7x@gondor.apana.org.au>
References: <20220408100911.1638478-1-conor.dooley@microchip.com>
 <20220408100911.1638478-2-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408100911.1638478-2-conor.dooley@microchip.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The dependency on HW_RANDOM is redundant so this patch removes it.
As this driver seems to cross-compile just fine we could also enable
COMPILE_TEST.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 18aa97974b8b..dad084c0ecee 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -387,7 +387,7 @@ config HW_RANDOM_PIC32
 
 config HW_RANDOM_POLARFIRE_SOC
 	tristate "Microchip PolarFire SoC Random Number Generator support"
-	depends on HW_RANDOM && POLARFIRE_SOC_SYS_CTRL
+	depends on POLARFIRE_SOC_SYS_CTRL || COMPILE_TEST
 	help
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on PolarFire SoC (MPFS).
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

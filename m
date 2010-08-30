From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] crypto: Fix spelling error in crypto/Kconfig
Date: Mon, 30 Aug 2010 18:41:09 +0200
Message-ID: <201008301841.09535.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:44552 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab0H3RG6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Aug 2010 13:06:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: <stable@kernel.org>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..27484e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,7 +102,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_PCOMP2
 
 config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
+	bool "Run algorithms' self-tests"
 	default y
 	depends on CRYPTO_MANAGER2
 	help

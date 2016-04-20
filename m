From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Ensure all dependencies are specified
Date: Wed, 20 Apr 2016 09:55:12 -0500
Message-ID: <20160420145512.4178.27624.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:18512
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752853AbcDTOze (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 10:55:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A DMA_ENGINE requires DMADEVICES in Kconfig

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 79cabfb..2238f77 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -4,6 +4,7 @@ config CRYPTO_DEV_CCP_DD
 	default m
 	select HW_RANDOM
 	select DMA_ENGINE
+	select DMADEVICES
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	help

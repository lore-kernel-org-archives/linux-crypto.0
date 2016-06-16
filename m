From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH] crypto: caam - replace deprecated EXTRA_CFLAGS
Date: Thu, 16 Jun 2016 16:32:55 +0300
Message-ID: <1466083975-27054-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <horia.geanta@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0088.outbound.protection.outlook.com ([157.56.110.88]:21472
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754409AbcFPNdF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jun 2016 09:33:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

EXTRA_CFLAGS is still supported but its usage is deprecated.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 drivers/crypto/caam/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 399ad55..3e9d3e1 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the CAAM backend and dependent components
 #
 ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
-	EXTRA_CFLAGS := -DDEBUG
+	ccflags-y := -DDEBUG
 endif
 
 ccflags-y += -I$(srctree)/crypto
-- 
1.8.3.1

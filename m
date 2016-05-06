From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [PATCH] crypto: caam: fix caam_jr_alloc() ret code
Date: Fri, 6 May 2016 16:18:53 +0300
Message-ID: <1462540733-2170-2-git-send-email-cata.vasile@nxp.com>
References: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
	<alexandru.porosanu@nxp.com>, <scott.wood@nxp.com>,
	Catalin Vasile <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:60288
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756585AbcEFNvH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 May 2016 09:51:07 -0400
In-Reply-To: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam_jr_alloc() used to return NULL if a JR device could not be
allocated for a session. In turn, every user of this function used
IS_ERR() function to verify if anything went wrong, which does NOT look
for NULL values. This made the kernel crash if the sanity check failed,
because the driver continued to think it had allocated a valid JR dev
instance to the session and at some point it tries to do a caam_jr_free()
on a NULL JR dev pointer.
This patch is a fix for this issue.

Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
---
 drivers/crypto/caam/jr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6fd63a6..5ef4be2 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -248,7 +248,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 struct device *caam_jr_alloc(void)
 {
 	struct caam_drv_private_jr *jrpriv, *min_jrpriv = NULL;
-	struct device *dev = NULL;
+	struct device *dev = ERR_PTR(-ENODEV);
 	int min_tfm_cnt	= INT_MAX;
 	int tfm_cnt;
 
-- 
1.8.3.1

From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: caam: fix error reporting
Date: Fri, 31 Oct 2014 18:57:33 +0200
Message-ID: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <horia.geanta@freescale.com>,
	<marex@denx.de>, Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0125.outbound.protection.outlook.com ([65.55.169.125]:11834
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751485AbaJaROk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2014 13:14:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The error code returned by hardware is four bits wide with an expected
zero MSB. A hardware error condition where the error code can get between
0x8 and 0xf will trigger an out of bound array access on the error
message table.
This patch fixes the invalid array access following such an error and
reports the condition.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/error.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6531054..c4483ad 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -213,7 +213,7 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		void (*report_ssed)(struct device *jrdev, const u32 status,
 				    const char *error);
 		const char *error;
-	} status_src[] = {
+	} status_src[16] = {
 		{ NULL, "No error" },
 		{ NULL, NULL },
 		{ report_ccb_status, "CCB" },
@@ -222,18 +222,23 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		{ NULL, NULL },
 		{ report_jr_status, "Job Ring" },
 		{ report_cond_code_status, "Condition Code" },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
+		{ NULL, NULL },
 	};
 	u32 ssrc = status >> JRSTA_SSRC_SHIFT;
 	const char *error = status_src[ssrc].error;
 
-	/*
-	 * If there is no further error handling function, just
-	 * print the error code, error string and exit. Otherwise
-	 * call the handler function.
-	 */
-	if (!status_src[ssrc].report_ssed)
-		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
-	else
+	if (status_src[ssrc].report_ssed)
 		status_src[ssrc].report_ssed(jrdev, status, error);
+	else if (error)
+		dev_err(jrdev, "%d: %s\n", ssrc, error);
+	else
+		dev_err(jrdev, "%d: unknown error code\n", ssrc);
 }
 EXPORT_SYMBOL(caam_jr_strstatus);
-- 
1.8.3.1

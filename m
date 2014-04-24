From: Marek Vasut <marex@denx.de>
Subject: [PATCH 05/11] crypto: caam: Kill the easy targets
Date: Thu, 24 Apr 2014 20:05:16 +0200
Message-ID: <1398362722-16430-6-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35612 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588AbaDXSFg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:36 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the functions which can be obviously done right with a simple
dev_err() now. While at it, further press the on-stack allocation
of buffer for sprintf() voodoo down into the abominated functions.

This patch cleans up most of the functions and leaves just two
remaining functions, report_ccb_status() and report_deco_status()
ugly and unhappy.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 7ce1d03..a8736abd7 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -182,8 +182,10 @@ static void report_jump_idx(u32 status, char *outstr)
 }
 
 static void report_ccb_status(struct device *jrdev, u32 status,
-			      const char *error, char *outstr)
+			      const char *error, char *__outstr)
 {
+	char outstr[CAAM_ERROR_STR_MAX];
+
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
 	u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
@@ -213,18 +215,22 @@ static void report_ccb_status(struct device *jrdev, u32 status,
 		SPRINTFCAT(outstr, "unidentified err_id value 0x%02x",
 			   err_id, sizeof("ff"));
 	}
+
+	dev_err(jrdev, "%08x: %s\n", status, outstr);
 }
 
 static void report_jump_status(struct device *jrdev, u32 status,
 			       const char *error, char *outstr)
 {
-	sprintf(outstr, "%s: ", error);
-	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
+	dev_err(jrdev, "%08x: %s: %s() not implemented\n",
+		status, error, __func__);
 }
 
 static void report_deco_status(struct device *jrdev, u32 status,
-			       const char *error, char *outstr)
+			       const char *error, char *__outstr)
 {
+	char outstr[CAAM_ERROR_STR_MAX];
+
 	u8 desc_error = status & JRSTA_DECOERR_ERROR_MASK;
 	int i;
 	sprintf(outstr, "%s: ", error);
@@ -242,25 +248,26 @@ static void report_deco_status(struct device *jrdev, u32 status,
 		SPRINTFCAT(outstr, "unidentified error value 0x%02x",
 			   desc_error, sizeof("ff"));
 	}
+
+	dev_err(jrdev, "%08x: %s\n", status, outstr);
 }
 
 static void report_jr_status(struct device *jrdev, u32 status,
 			     const char *error, char *outstr)
 {
-	sprintf(outstr, "%s: ", error);
-	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
+	dev_err(jrdev, "%08x: %s: %s() not implemented\n",
+		status, error, __func__);
 }
 
 static void report_cond_code_status(struct device *jrdev, u32 status,
 				    const char *error, char *outstr)
 {
-	sprintf(outstr, "%s: ", error);
-	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
+	dev_err(jrdev, "%08x: %s: %s() not implemented\n",
+		status, error, __func__);
 }
 
 void caam_jr_strstatus(struct device *jrdev, u32 status)
 {
-	char outstr[CAAM_ERROR_STR_MAX];
 	static const struct stat_src {
 		void (*report_ssed)(struct device *jrdev, u32 status,
 				    const char *error, char *outstr);
@@ -287,8 +294,6 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 	}
 
 	status_src[ssrc].report_ssed(jrdev, status,
-			status_src[ssrc].error, outstr);
-
-	dev_err(jrdev, "%08x: %s\n", status, outstr);
+			status_src[ssrc].error, NULL);
 }
 EXPORT_SYMBOL(caam_jr_strstatus);
-- 
1.9.2

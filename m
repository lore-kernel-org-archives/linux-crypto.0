From: Marek Vasut <marex@denx.de>
Subject: [PATCH 10/11] crypto: caam: Sweep the remnants
Date: Thu, 24 Apr 2014 20:05:21 +0200
Message-ID: <1398362722-16430-11-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35612 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbaDXSFh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:37 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Clean up the remnants from the rework. Constify function arguments.

Note that checkpatch again complains about this space before newline,
but this is the original code behavior, so I'm keeping it.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 7ed2e4f..0f4725c 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -13,7 +13,7 @@
 
 static const struct {
 	u8 value;
-	char *error_text;
+	const char *error_text;
 } desc_error_list[] = {
 	{ 0x00, "No error." },
 	{ 0x01, "SGT Length Error. The descriptor is trying to read "
@@ -158,8 +158,8 @@ static const char * const rng_err_id_list[] = {
 	"Secure key generation",
 };
 
-static void report_ccb_status(struct device *jrdev, u32 status,
-			      const char *error, char *__outstr)
+static void report_ccb_status(struct device *jrdev, const u32 status,
+			      const char *error)
 {
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
@@ -198,21 +198,21 @@ static void report_ccb_status(struct device *jrdev, u32 status,
 		err_str, err_err_code);
 }
 
-static void report_jump_status(struct device *jrdev, u32 status,
-			       const char *error, char *outstr)
+static void report_jump_status(struct device *jrdev, const u32 status,
+			       const char *error)
 {
 	dev_err(jrdev, "%08x: %s: %s() not implemented\n",
 		status, error, __func__);
 }
 
-static void report_deco_status(struct device *jrdev, u32 status,
-			       const char *error, char *__outstr)
+static void report_deco_status(struct device *jrdev, const u32 status,
+			       const char *error)
 {
 	u8 err_id = status & JRSTA_DECOERR_ERROR_MASK;
 	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
 		  JRSTA_DECOERR_INDEX_SHIFT;
 	char *idx_str;
-	char *err_str = "unidentified error value 0x";
+	const char *err_str = "unidentified error value 0x";
 	char err_err_code[3] = { 0 };
 	int i;
 
@@ -234,15 +234,15 @@ static void report_deco_status(struct device *jrdev, u32 status,
 		status, error, idx_str, idx, err_str, err_err_code);
 }
 
-static void report_jr_status(struct device *jrdev, u32 status,
-			     const char *error, char *outstr)
+static void report_jr_status(struct device *jrdev, const u32 status,
+			     const char *error)
 {
 	dev_err(jrdev, "%08x: %s: %s() not implemented\n",
 		status, error, __func__);
 }
 
-static void report_cond_code_status(struct device *jrdev, u32 status,
-				    const char *error, char *outstr)
+static void report_cond_code_status(struct device *jrdev, const u32 status,
+				    const char *error)
 {
 	dev_err(jrdev, "%08x: %s: %s() not implemented\n",
 		status, error, __func__);
@@ -251,8 +251,8 @@ static void report_cond_code_status(struct device *jrdev, u32 status,
 void caam_jr_strstatus(struct device *jrdev, u32 status)
 {
 	static const struct stat_src {
-		void (*report_ssed)(struct device *jrdev, u32 status,
-				    const char *error, char *outstr);
+		void (*report_ssed)(struct device *jrdev, const u32 status,
+				    const char *error);
 		const char *error;
 	} status_src[] = {
 		{ NULL, "No error" },
@@ -265,17 +265,16 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		{ report_cond_code_status, "Condition Code" },
 	};
 	u32 ssrc = status >> JRSTA_SSRC_SHIFT;
+	const char *error = status_src[ssrc].error;
 
 	/*
 	 * If there is no further error handling function, just
-	 * print the error code, error string and exit.
+	 * print the error code, error string and exit. Otherwise
+	 * call the handler function.
 	 */
-	if (!status_src[ssrc].report_ssed) {
+	if (!status_src[ssrc].report_ssed)
 		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
-		return;
-	}
-
-	status_src[ssrc].report_ssed(jrdev, status,
-			status_src[ssrc].error, NULL);
+	else
+		status_src[ssrc].report_ssed(jrdev, status, error);
 }
 EXPORT_SYMBOL(caam_jr_strstatus);
-- 
1.9.2

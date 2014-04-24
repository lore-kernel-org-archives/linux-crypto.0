From: Marek Vasut <marex@denx.de>
Subject: [PATCH 08/11] crypto: caam: Clean up report_deco_status()
Date: Thu, 24 Apr 2014 20:05:19 +0200
Message-ID: <1398362722-16430-9-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:55517 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbaDXSFg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:36 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Clean this function up and rework it into sensible shape. This function
now contains one single dev_err() instead of the previous insanity full
of memory allocation, chaotic string handling and use of SPRINTFCAT().

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

NOTE: This one I am unsure about. This _should_ work with me printing
      the numeric codes into $cha_err_code, $err_err_code using snprintf(),
      but please verify thoroughly.

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 91cc5fc..66a7461 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -218,35 +218,30 @@ static void report_jump_status(struct device *jrdev, u32 status,
 static void report_deco_status(struct device *jrdev, u32 status,
 			       const char *error, char *__outstr)
 {
-	char outstr[CAAM_ERROR_STR_MAX];
-
-	u8 desc_error = status & JRSTA_DECOERR_ERROR_MASK;
+	u8 err_id = status & JRSTA_DECOERR_ERROR_MASK;
 	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
 		  JRSTA_DECOERR_INDEX_SHIFT;
-
+	char *idx_str;
+	char *err_str = "unidentified error value 0x";
+	char err_err_code[3] = { 0 };
 	int i;
-	sprintf(outstr, "%s: ", error);
 
 	if (status & JRSTA_DECOERR_JUMP)
-		strcat(outstr, "jump tgt desc idx ");
+		idx_str = "jump tgt desc idx";
 	else
-		strcat(outstr, "desc idx ");
-
-	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
+		idx_str = "desc idx";
 
 	for (i = 0; i < ARRAY_SIZE(desc_error_list); i++)
-		if (desc_error_list[i].value == desc_error)
+		if (desc_error_list[i].value == err_id)
 			break;
 
-	if (i != ARRAY_SIZE(desc_error_list) && desc_error_list[i].error_text) {
-		SPRINTFCAT(outstr, "%s", desc_error_list[i].error_text,
-			   strlen(desc_error_list[i].error_text));
-	} else {
-		SPRINTFCAT(outstr, "unidentified error value 0x%02x",
-			   desc_error, sizeof("ff"));
-	}
+	if (i != ARRAY_SIZE(desc_error_list) && desc_error_list[i].error_text)
+		err_str = desc_error_list[i].error_text;
+	else
+		snprintf(err_err_code, sizeof(err_err_code), "%02x", err_id);
 
-	dev_err(jrdev, "%08x: %s\n", status, outstr);
+	dev_err(jrdev, "%08x: %s: %s %d: %s%s\n",
+		status, error, idx_str, idx, err_str, err_err_code);
 }
 
 static void report_jr_status(struct device *jrdev, u32 status,
-- 
1.9.2

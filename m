From: Marek Vasut <marex@denx.de>
Subject: [PATCH 07/11] crypto: caam: Clean up report_ccb_status()
Date: Thu, 24 Apr 2014 20:05:18 +0200
Message-ID: <1398362722-16430-8-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:50334 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbaDXSFc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:32 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Clean this function up and rework it into sensible shape. This function
now contains one single dev_err() instead of the previous insanity full
of memory allocation, possible stack overwriting, chaotic string handling
and use of SPRINTFCAT().

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

NOTE: This one I am unsure about. This _should_ work with me printing
      the numeric codes into $cha_err_code, $err_err_code using snprintf(),
      but please verify thoroughly.

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index aa7d5cf..91cc5fc 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -171,46 +171,41 @@ static const char * const rng_err_id_list[] = {
 static void report_ccb_status(struct device *jrdev, u32 status,
 			      const char *error, char *__outstr)
 {
-	char outstr[CAAM_ERROR_STR_MAX];
-
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
 	u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
 	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
 		  JRSTA_DECOERR_INDEX_SHIFT;
-
-	sprintf(outstr, "%s: ", error);
+	char *idx_str;
+	const char *cha_str = "unidentified cha_id value 0x";
+	char cha_err_code[3] = { 0 };
+	const char *err_str = "unidentified err_id value 0x";
+	char err_err_code[3] = { 0 };
 
 	if (status & JRSTA_DECOERR_JUMP)
-		strcat(outstr, "jump tgt desc idx ");
+		idx_str = "jump tgt desc idx";
 	else
-		strcat(outstr, "desc idx ");
-
-	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
+		idx_str = "desc idx";
 
-	if (cha_id < ARRAY_SIZE(cha_id_list)) {
-		SPRINTFCAT(outstr, "%s: ", cha_id_list[cha_id],
-			   strlen(cha_id_list[cha_id]));
-	} else {
-		SPRINTFCAT(outstr, "unidentified cha_id value 0x%02x: ",
-			   cha_id, sizeof("ff"));
-	}
+	if (cha_id < ARRAY_SIZE(cha_id_list))
+		cha_str = cha_id_list[cha_id];
+	else
+		snprintf(cha_err_code, sizeof(cha_err_code), "%02x", cha_id);
 
 	if ((cha_id << JRSTA_CCBERR_CHAID_SHIFT) == JRSTA_CCBERR_CHAID_RNG &&
 	    err_id < ARRAY_SIZE(rng_err_id_list) &&
 	    strlen(rng_err_id_list[err_id])) {
 		/* RNG-only error */
-		SPRINTFCAT(outstr, "%s", rng_err_id_list[err_id],
-			   strlen(rng_err_id_list[err_id]));
-	} else if (err_id < ARRAY_SIZE(err_id_list)) {
-		SPRINTFCAT(outstr, "%s", err_id_list[err_id],
-			   strlen(err_id_list[err_id]));
-	} else {
-		SPRINTFCAT(outstr, "unidentified err_id value 0x%02x",
-			   err_id, sizeof("ff"));
-	}
+		err_str = rng_err_id_list[err_id];
+	} else if (err_id < ARRAY_SIZE(err_id_list))
+		err_str = err_id_list[err_id];
+	else
+		snprintf(err_err_code, sizeof(err_err_code), "%02x", err_id);
 
-	dev_err(jrdev, "%08x: %s\n", status, outstr);
+	dev_err(jrdev, "%08x: %s: %s %d: %s%s: %s%s\n",
+		status, error, idx_str, idx,
+		cha_str, cha_err_code,
+		err_str, err_err_code);
 }
 
 static void report_jump_status(struct device *jrdev, u32 status,
-- 
1.9.2

From: Marek Vasut <marex@denx.de>
Subject: [PATCH 06/11] crypto: caam: Dissolve report_jump_idx()
Date: Thu, 24 Apr 2014 20:05:17 +0200
Message-ID: <1398362722-16430-7-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:59640 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbaDXSFc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:32 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Just dissolve this function so it's not in the way of applying
further white magic cleanup down the line.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index a8736abd7..aa7d5cf 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -168,19 +168,6 @@ static const char * const rng_err_id_list[] = {
 	kfree(tmp);						\
 }
 
-static void report_jump_idx(u32 status, char *outstr)
-{
-	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
-		  JRSTA_DECOERR_INDEX_SHIFT;
-
-	if (status & JRSTA_DECOERR_JUMP)
-		strcat(outstr, "jump tgt desc idx ");
-	else
-		strcat(outstr, "desc idx ");
-
-	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
-}
-
 static void report_ccb_status(struct device *jrdev, u32 status,
 			      const char *error, char *__outstr)
 {
@@ -189,10 +176,17 @@ static void report_ccb_status(struct device *jrdev, u32 status,
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
 	u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
+	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
+		  JRSTA_DECOERR_INDEX_SHIFT;
 
 	sprintf(outstr, "%s: ", error);
 
-	report_jump_idx(status, outstr);
+	if (status & JRSTA_DECOERR_JUMP)
+		strcat(outstr, "jump tgt desc idx ");
+	else
+		strcat(outstr, "desc idx ");
+
+	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
 
 	if (cha_id < ARRAY_SIZE(cha_id_list)) {
 		SPRINTFCAT(outstr, "%s: ", cha_id_list[cha_id],
@@ -232,10 +226,18 @@ static void report_deco_status(struct device *jrdev, u32 status,
 	char outstr[CAAM_ERROR_STR_MAX];
 
 	u8 desc_error = status & JRSTA_DECOERR_ERROR_MASK;
+	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
+		  JRSTA_DECOERR_INDEX_SHIFT;
+
 	int i;
 	sprintf(outstr, "%s: ", error);
 
-	report_jump_idx(status, outstr);
+	if (status & JRSTA_DECOERR_JUMP)
+		strcat(outstr, "jump tgt desc idx ");
+	else
+		strcat(outstr, "desc idx ");
+
+	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
 
 	for (i = 0; i < ARRAY_SIZE(desc_error_list); i++)
 		if (desc_error_list[i].value == desc_error)
-- 
1.9.2

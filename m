From: Marek Vasut <marex@denx.de>
Subject: [PATCH 04/11] crypto: caam: Pass error type into the functions
Date: Thu, 24 Apr 2014 20:05:15 +0200
Message-ID: <1398362722-16430-5-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:55517 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560AbaDXSFg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:36 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pass the error type string into the functions, so they can handle
the printing of the string. This is now still using the very unsafe
sprintf(), but we will fix that.

While at this, pass the device pointer too, so we can dev_err()
functions readily when we start fixing this proper.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 961331d..7ce1d03 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -181,12 +181,15 @@ static void report_jump_idx(u32 status, char *outstr)
 	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
 }
 
-static void report_ccb_status(u32 status, char *outstr)
+static void report_ccb_status(struct device *jrdev, u32 status,
+			      const char *error, char *outstr)
 {
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
 	u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
 
+	sprintf(outstr, "%s: ", error);
+
 	report_jump_idx(status, outstr);
 
 	if (cha_id < ARRAY_SIZE(cha_id_list)) {
@@ -212,15 +215,19 @@ static void report_ccb_status(u32 status, char *outstr)
 	}
 }
 
-static void report_jump_status(u32 status, char *outstr)
+static void report_jump_status(struct device *jrdev, u32 status,
+			       const char *error, char *outstr)
 {
+	sprintf(outstr, "%s: ", error);
 	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
 }
 
-static void report_deco_status(u32 status, char *outstr)
+static void report_deco_status(struct device *jrdev, u32 status,
+			       const char *error, char *outstr)
 {
 	u8 desc_error = status & JRSTA_DECOERR_ERROR_MASK;
 	int i;
+	sprintf(outstr, "%s: ", error);
 
 	report_jump_idx(status, outstr);
 
@@ -237,13 +244,17 @@ static void report_deco_status(u32 status, char *outstr)
 	}
 }
 
-static void report_jr_status(u32 status, char *outstr)
+static void report_jr_status(struct device *jrdev, u32 status,
+			     const char *error, char *outstr)
 {
+	sprintf(outstr, "%s: ", error);
 	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
 }
 
-static void report_cond_code_status(u32 status, char *outstr)
+static void report_cond_code_status(struct device *jrdev, u32 status,
+				    const char *error, char *outstr)
 {
+	sprintf(outstr, "%s: ", error);
 	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
 }
 
@@ -251,8 +262,9 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 {
 	char outstr[CAAM_ERROR_STR_MAX];
 	static const struct stat_src {
-		void (*report_ssed)(u32 status, char *outstr);
-		char *error;
+		void (*report_ssed)(struct device *jrdev, u32 status,
+				    const char *error, char *outstr);
+		const char *error;
 	} status_src[] = {
 		{ NULL, "No error" },
 		{ NULL, NULL },
@@ -274,9 +286,8 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 		return;
 	}
 
-	sprintf(outstr, "%s: ", status_src[ssrc].error);
-
-	status_src[ssrc].report_ssed(status, outstr);
+	status_src[ssrc].report_ssed(jrdev, status,
+			status_src[ssrc].error, outstr);
 
 	dev_err(jrdev, "%08x: %s\n", status, outstr);
 }
-- 
1.9.2

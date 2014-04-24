From: Marek Vasut <marex@denx.de>
Subject: [PATCH 03/11] crypto: caam: Implement fast-path for error codes with no handler
Date: Thu, 24 Apr 2014 20:05:14 +0200
Message-ID: <1398362722-16430-4-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:55517 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbaDXSFd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:33 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement fast-path error code printout for errors with no associated
handler function. This reduces calls to this kmalloc() nonsense in
SPRINTFCAT() already.

Note that the format of output is compatible with the old code, even
if -- exposed like this -- it looks a bit weird. Checkpatch complains
on this one as well.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 3d7be4c..961331d 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -265,10 +265,18 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
 	};
 	u32 ssrc = status >> JRSTA_SSRC_SHIFT;
 
+	/*
+	 * If there is no further error handling function, just
+	 * print the error code, error string and exit.
+	 */
+	if (!status_src[ssrc].report_ssed) {
+		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
+		return;
+	}
+
 	sprintf(outstr, "%s: ", status_src[ssrc].error);
 
-	if (status_src[ssrc].report_ssed)
-		status_src[ssrc].report_ssed(status, outstr);
+	status_src[ssrc].report_ssed(status, outstr);
 
 	dev_err(jrdev, "%08x: %s\n", status, outstr);
 }
-- 
1.9.2

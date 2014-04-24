From: Marek Vasut <marex@denx.de>
Subject: [PATCH 09/11] crypto: caam: Kill SPRINTFCAT() with fire
Date: Thu, 24 Apr 2014 20:05:20 +0200
Message-ID: <1398362722-16430-10-git-send-email-marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:58444 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397AbaDXSFc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:32 -0400
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This macro is just like an encyclopedia of string handling done wrong.
This must die. This is so wrong on so many levels.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/error.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 66a7461..7ed2e4f 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -158,16 +158,6 @@ static const char * const rng_err_id_list[] = {
 	"Secure key generation",
 };
 
-#define SPRINTFCAT(str, format, param, max_alloc)		\
-{								\
-	char *tmp;						\
-								\
-	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
-	sprintf(tmp, format, param);				\
-	strcat(str, tmp);					\
-	kfree(tmp);						\
-}
-
 static void report_ccb_status(struct device *jrdev, u32 status,
 			      const char *error, char *__outstr)
 {
-- 
1.9.2

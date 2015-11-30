From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] crypto: caam - pass the correct buffer length
Date: Mon, 30 Nov 2015 11:03:58 -0200
Message-ID: <1448888638-7921-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <horia.geanta@freescale.com>, <linux-crypto@vger.kernel.org>,
	"Fabio Estevam" <fabio.estevam@freescale.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:60736
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017AbbK3NSf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Nov 2015 08:18:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When buffer 0 is used we should use buflen_0 instead of buflen_1.

Fix it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Untested.

 drivers/crypto/caam/caamhash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index fe9c156..5845d4a 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1596,7 +1596,7 @@ static int ahash_export(struct ahash_request *req, void *out)
 		len = state->buflen_1;
 	} else {
 		buf = state->buf_0;
-		len = state->buflen_1;
+		len = state->buflen_0;
 	}
 
 	memcpy(export->buf, buf, len);
-- 
1.9.1

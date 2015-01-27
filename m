From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: tcrypt: fix buflen reminder calculation
Date: Tue, 27 Jan 2015 11:54:27 +0200
Message-ID: <1422352467-1849-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0128.outbound.protection.outlook.com ([207.46.100.128]:16353
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757716AbbA0Jyo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2015 04:54:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- This fixes the intent of the code to limit the last scatterlist to
  either a full PAGE or a fraction of it, depending on the number of
  pages needed by buflen and the available space advertised by XBUFLEN.

  The original code always sets the last scatterlist to a fraction of a
  PAGE because the first 'if' is never executed.

- Rearrange the second part of the code to remove the conditional from
  the loop

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/tcrypt.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0043495..2b2486a 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -250,19 +250,19 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
 	int np = (buflen + PAGE_SIZE - 1)/PAGE_SIZE;
 	int k, rem;
 
-	np = (np > XBUFSIZE) ? XBUFSIZE : np;
-	rem = buflen % PAGE_SIZE;
 	if (np > XBUFSIZE) {
 		rem = PAGE_SIZE;
 		np = XBUFSIZE;
+	} else {
+		rem = buflen % PAGE_SIZE;
 	}
+
 	sg_init_table(sg, np);
-	for (k = 0; k < np; ++k) {
-		if (k == (np-1))
-			sg_set_buf(&sg[k], xbuf[k], rem);
-		else
-			sg_set_buf(&sg[k], xbuf[k], PAGE_SIZE);
-	}
+	np--;
+	for (k = 0; k < np; k++)
+		sg_set_buf(&sg[k], xbuf[k], PAGE_SIZE);
+
+	sg_set_buf(&sg[k], xbuf[k], rem);
 }
 
 static void test_aead_speed(const char *algo, int enc, unsigned int secs,
-- 
2.2.0

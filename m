From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 1/3] crypto: drbg - fix drbg_generate return val check
Date: Sat, 18 Apr 2015 19:35:45 +0200
Message-ID: <1729166.VkzVhhzA8R@myon.chronox.de>
References: <1702481.h2hMdNkdaF@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34199 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbbDRRin (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 13:38:43 -0400
In-Reply-To: <1702481.h2hMdNkdaF@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The drbg_generate returns 0 in success case. That means that
drbg_generate_long will always only generate drbg_max_request_bytes at
most. Longer requests will be truncated to drbg_max_request_bytes.

Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b69409c..3f62440 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1442,19 +1442,19 @@ static int drbg_generate_long(struct drbg_state *drbg,
 			      unsigned char *buf, unsigned int buflen,
 			      struct drbg_string *addtl)
 {
-	int len = 0;
+	unsigned int len = 0;
 	unsigned int slice = 0;
 	do {
-		int tmplen = 0;
+		int err = 0;
 		unsigned int chunk = 0;
 		slice = ((buflen - len) / drbg_max_request_bytes(drbg));
 		chunk = slice ? drbg_max_request_bytes(drbg) : (buflen - len);
-		tmplen = drbg_generate(drbg, buf + len, chunk, addtl);
-		if (0 >= tmplen)
-			return tmplen;
-		len += tmplen;
+		err = drbg_generate(drbg, buf + len, chunk, addtl);
+		if (0 > err)
+			return err;
+		len += chunk;
 	} while (slice > 0 && (len < buflen));
-	return len;
+	return 0;
 }
 
 /*
-- 
2.1.0

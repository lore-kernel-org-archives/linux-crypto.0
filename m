From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: testmgr: limit IV copy length in aead tests
Date: Wed, 28 Jan 2015 11:03:05 +0200
Message-ID: <1422435785-31259-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:64934
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756518AbbA1UgE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2015 15:36:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The working copy of IV is the same size as the transformation's IV.
It is not necessary to copy more than that from the template since
iv_len is usually less than MAX_IVLEN and the rest of the copied data
is garbage.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 758d028..f4ed6d4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -429,7 +429,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	struct scatterlist *sgout;
 	const char *e, *d;
 	struct tcrypt_result result;
-	unsigned int authsize;
+	unsigned int authsize, iv_len;
 	void *input;
 	void *output;
 	void *assoc;
@@ -500,10 +500,11 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 		memcpy(input, template[i].input, template[i].ilen);
 		memcpy(assoc, template[i].assoc, template[i].alen);
+		iv_len = crypto_aead_ivsize(tfm);
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			memcpy(iv, template[i].iv, iv_len);
 		else
-			memset(iv, 0, MAX_IVLEN);
+			memset(iv, 0, iv_len);
 
 		crypto_aead_clear_flags(tfm, ~0);
 		if (template[i].wk)
-- 
2.2.0

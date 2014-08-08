From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 3/3] crypto: testmgr.c: delay execution of set-up code
Date: Fri, 8 Aug 2014 14:27:52 +0300
Message-ID: <1407497272-9161-3-git-send-email-cristian.stoica@freescale.com>
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Prepare IV array only if the dependent code is executed.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 36f45ff..365f8a3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -969,16 +969,15 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
+		if (template[i].np && !template[i].also_non_np)
+			continue;
+
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (template[i].np && !template[i].also_non_np)
-			continue;
-
 		j++;
-
 		ret = -EINVAL;
 		if (WARN_ON(align_offset + template[i].ilen > PAGE_SIZE))
 			goto out;
@@ -1046,16 +1045,15 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		if (align_offset != 0)
 			break;
 
+		if (!template[i].np)
+			continue;
+
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (!template[i].np)
-			continue;
-
 		j++;
-
 		crypto_ablkcipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
 			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-- 
1.8.3.1

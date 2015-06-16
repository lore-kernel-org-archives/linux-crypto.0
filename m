From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/2] crypto: testmgr: test IV value after a cipher operation
Date: Tue, 16 Jun 2015 11:46:46 +0200
Message-ID: <1434448007-9537-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1434448007-9537-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: linux-kernel@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:56060 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756500AbbFPJqx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 05:46:53 -0400
In-Reply-To: <1434448007-9537-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto drivers are supposed to update the IV passed to the crypto
request before calling the completion callback.
Test for the IV value before considering the test as successful.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 crypto/testmgr.c | 12 +++++++++++-
 crypto/testmgr.h |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9bce3d..e6b5f24 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1013,12 +1013,22 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 		q = data;
 		if (memcmp(q, template[i].result, template[i].rlen)) {
-			pr_err("alg: skcipher%s: Test %d failed on %s for %s\n",
+			pr_err("alg: skcipher%s: Test %d failed (invalid result) on %s for %s\n",
 			       d, j, e, algo);
 			hexdump(q, template[i].rlen);
 			ret = -EINVAL;
 			goto out;
 		}
+
+		if (template[i].iv_out &&
+		    memcmp(iv, template[i].iv_out,
+			   crypto_ablkcipher_ivsize(tfm))) {
+			pr_err("alg: skcipher%s: Test %d failed (invalid output IV) on %s for %s\n",
+			       d, j, e, algo);
+			hexdump(iv, crypto_ablkcipher_ivsize(tfm));
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	j = 0;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 62e2485..03320f9 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -49,6 +49,7 @@ struct hash_testvec {
 struct cipher_testvec {
 	char *key;
 	char *iv;
+	char *iv_out;
 	char *input;
 	char *result;
 	unsigned short tap[MAX_TAP];
-- 
1.9.1

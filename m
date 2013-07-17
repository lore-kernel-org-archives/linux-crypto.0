From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 07/20] ima: provide dedicated hash algo allocation function
Date: Wed, 17 Jul 2013 19:51:27 -0400
Message-ID: <1374105100-25880-8-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:36364 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab3GQXwA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 19:52:00 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 17 Jul 2013 17:52:00 -0600
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

This patch provides dedicated hash algo allocation and
deallocation function which can be used by different clients.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_crypto.c | 43 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 872c669..e5d3ebf 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -39,6 +39,28 @@ int ima_init_crypto(void)
 	return 0;
 }
 
+static struct crypto_shash *ima_alloc_tfm(enum hash_algo algo)
+{
+	struct crypto_shash *tfm = ima_shash_tfm;
+	int rc;
+
+	if (algo != ima_hash_algo && algo < HASH_ALGO__LAST) {
+		tfm = crypto_alloc_shash(hash_algo_name[algo], 0, 0);
+		if (IS_ERR(tfm)) {
+			rc = PTR_ERR(tfm);
+			pr_err("Can not allocate %s (reason: %d)\n",
+			       hash_algo_name[algo], rc);
+		}
+	}
+	return tfm;
+}
+
+static void ima_free_tfm(struct crypto_shash *tfm)
+{
+	if (tfm != ima_shash_tfm)
+		crypto_free_shash(tfm);
+}
+
 /*
  * Calculate the MD5/SHA1 file digest
  */
@@ -57,6 +79,8 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	desc.shash.tfm = tfm;
 	desc.shash.flags = 0;
 
+	hash->length = crypto_shash_digestsize(tfm);
+
 	rc = crypto_shash_init(&desc.shash);
 	if (rc != 0)
 		return rc;
@@ -98,25 +122,16 @@ out:
 
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 {
-	struct crypto_shash *tfm = ima_shash_tfm;
+	struct crypto_shash *tfm;
 	int rc;
 
-	if (hash->algo != ima_hash_algo && hash->algo < HASH_ALGO__LAST) {
-		tfm = crypto_alloc_shash(hash_algo_name[hash->algo], 0, 0);
-		if (IS_ERR(tfm)) {
-			rc = PTR_ERR(tfm);
-			pr_err("Can not allocate %s (reason: %d)\n",
-			       hash_algo_name[hash->algo], rc);
-			return rc;
-		}
-	}
-
-	hash->length = crypto_shash_digestsize(tfm);
+	tfm = ima_alloc_tfm(hash->algo);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 
 	rc = ima_calc_file_hash_tfm(file, hash, tfm);
 
-	if (tfm != ima_shash_tfm)
-		crypto_free_shash(tfm);
+	ima_free_tfm(tfm);
 
 	return rc;
 }
-- 
1.8.1.4

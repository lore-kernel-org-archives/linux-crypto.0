From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 08/20] ima: support arbitrary hash algorithms in ima_calc_buffer_hash
Date: Wed, 17 Jul 2013 19:51:28 -0400
Message-ID: <1374105100-25880-9-git-send-email-zohar@linux.vnet.ibm.com>
References: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46489 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab3GQXwA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 19:52:00 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 17 Jul 2013 17:52:00 -0600
In-Reply-To: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>

ima_calc_buffer_hash will be used with different hash algorithms.
This patch provides support for arbitrary hash algorithms in
ima_calc_buffer_hash.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_api.c    |  3 +++
 security/integrity/ima/ima_crypto.c | 28 ++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 2cc5dcc..bc1d128 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/xattr.h>
 #include <linux/evm.h>
+#include <crypto/hash_info.h>
 #include "ima.h"
 
 static const char *IMA_TEMPLATE_NAME = "ima";
@@ -54,6 +55,8 @@ int ima_store_template(struct ima_template_entry *entry,
 	entry->template_len = sizeof(entry->template);
 
 	if (!violation) {
+		/* this function uses default algo */
+		hash.hdr.algo = HASH_ALGO_SHA1;
 		result = ima_calc_buffer_hash(&entry->template,
 					      entry->template_len, &hash.hdr);
 		if (result < 0) {
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index e5d3ebf..e2be252 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -139,23 +139,39 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 /*
  * Calculate the hash of a given buffer
  */
-int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
+static int ima_calc_buffer_hash_tfm(const void *buf, int len,
+				    struct ima_digest_data *hash,
+				    struct crypto_shash *tfm)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ima_shash_tfm)];
+		char ctx[crypto_shash_descsize(tfm)];
 	} desc;
 
-	desc.shash.tfm = ima_shash_tfm;
+	desc.shash.tfm = tfm;
 	desc.shash.flags = 0;
 
-	/* this function uses default algo */
-	hash->algo = ima_hash_algo;
-	hash->length = crypto_shash_digestsize(ima_shash_tfm);
+	hash->length = crypto_shash_digestsize(tfm);
 
 	return crypto_shash_digest(&desc.shash, buf, len, hash->digest);
 }
 
+int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
+{
+	struct crypto_shash *tfm;
+	int rc;
+
+	tfm = ima_alloc_tfm(hash->algo);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	rc = ima_calc_buffer_hash_tfm(buf, len, hash, tfm);
+
+	ima_free_tfm(tfm);
+
+	return rc;
+}
+
 static void __init ima_pcrread(int idx, u8 *pcr)
 {
 	if (!ima_used_chip)
-- 
1.8.1.4

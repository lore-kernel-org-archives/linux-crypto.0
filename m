From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v2 4/4] crypto: testmgr - Add a test case for import()/export()
Date: Wed, 27 Jan 2016 17:08:38 +0800
Message-ID: <1453885718-24599-5-git-send-email-rui.y.wang@intel.com>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Cc: tim.c.chen@linux.intel.com, rui.y.wang@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53274 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbcA0J2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 04:28:48 -0500
In-Reply-To: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify __test_hash() so that hash import/export can be tested
from within the kernel by simply adding .partial = 1 to a hash
algo's struct hash_testvec where .np > 1.

v2: Leverage template[i].np as suggested by Tim Chen

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 crypto/testmgr.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |   4 +-
 2 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..3d0c65a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -198,6 +198,62 @@ static int wait_async_op(struct tcrypt_result *tr, int ret)
 	return ret;
 }
 
+static int ahash_partial_update(struct ahash_request **preq,
+	struct crypto_ahash *tfm, struct hash_testvec *template,
+	void *hash_buff, int k, int temp, struct scatterlist *sg,
+	const char *algo, char *result, struct tcrypt_result *tresult)
+{
+	char *state;
+	struct ahash_request *req;
+	int statesize, ret = -EINVAL;
+
+	req = *preq;
+	statesize = crypto_ahash_statesize(
+			crypto_ahash_reqtfm(req));
+	state = kmalloc(statesize, GFP_KERNEL);
+	if (!state) {
+		pr_err("alt: hash: Failed to alloc state for %s\n", algo);
+		ahash_request_free(req);
+		goto out_nostate;
+	}
+	ret = crypto_ahash_export(req, state);
+	if (ret) {
+		pr_err("alt: hash: Failed to export() for %s\n", algo);
+		goto out;
+	}
+	ahash_request_free(req);
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("alg: hash: Failed to alloc request for %s\n", algo);
+		goto out_noreq;
+	}
+	ahash_request_set_callback(req,
+		CRYPTO_TFM_REQ_MAY_BACKLOG,
+		tcrypt_complete, tresult);
+
+	memcpy(hash_buff, template->plaintext + temp,
+		template->tap[k]);
+	sg_init_one(&sg[0], hash_buff, template->tap[k]);
+	ahash_request_set_crypt(req, sg, result, template->tap[k]);
+	ret = crypto_ahash_import(req, state);
+	if (ret) {
+		pr_err("alg: hash: Failed to import() for %s\n", algo);
+		goto out;
+	}
+	ret = wait_async_op(tresult, crypto_ahash_update(req));
+	if (ret)
+		goto out;
+	*preq = req;
+	ret = 0;
+	goto out_noreq;
+out:
+	ahash_request_free(req);
+out_noreq:
+	kfree(state);
+out_nostate:
+	return ret;
+}
+
 static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		       unsigned int tcount, bool use_digest,
 		       const int align_offset)
@@ -385,6 +441,87 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		}
 	}
 
+	/* partial update exercise */
+	j = 0;
+	for (i = 0; i < tcount; i++) {
+		/* alignment tests are only done with continuous buffers */
+		if (align_offset != 0)
+			break;
+
+		if (template[i].np < 2)
+			continue;
+
+		if (!template[i].partial)
+			continue;
+
+		j++;
+		memset(result, 0, MAX_DIGEST_SIZE);
+
+		ret = -EINVAL;
+		hash_buff = xbuf[0];
+		memcpy(hash_buff, template[i].plaintext,
+			template[i].tap[0]);
+		sg_init_one(&sg[0], hash_buff, template[i].tap[0]);
+
+		if (template[i].ksize) {
+			crypto_ahash_clear_flags(tfm, ~0);
+			if (template[i].ksize > MAX_KEYLEN) {
+				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
+					j, algo, template[i].ksize, MAX_KEYLEN);
+				ret = -EINVAL;
+				goto out;
+			}
+			memcpy(key, template[i].key, template[i].ksize);
+			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
+			if (ret) {
+				pr_err("alg: hash: setkey failed on test %d for %s: ret=%d\n",
+					j, algo, -ret);
+				goto out;
+			}
+		}
+
+		ahash_request_set_crypt(req, sg, result, template[i].tap[0]);
+		ret = wait_async_op(&tresult, crypto_ahash_init(req));
+		if (ret) {
+			pr_err("alt: hash: init failed on test %d for %s: ret=%d\n",
+				j, algo, -ret);
+			goto out;
+		}
+		ret = wait_async_op(&tresult, crypto_ahash_update(req));
+		if (ret) {
+			pr_err("alt: hash: update failed on test %d for %s: ret=%d\n",
+				j, algo, -ret);
+			goto out;
+		}
+
+		temp = template[i].tap[0];
+		for (k = 1; k < template[i].np; k++) {
+			ret = ahash_partial_update(&req, tfm, &template[i],
+				hash_buff, k, temp, &sg[0], algo, result,
+				&tresult);
+			if (ret) {
+				pr_err("hash: partial update failed on test %d for %s: ret=%d\n",
+					j, algo, -ret);
+				goto out_noreq;
+			}
+			temp += template[i].tap[k];
+		}
+		ret = wait_async_op(&tresult, crypto_ahash_final(req));
+		if (ret) {
+			pr_err("alt: hash: final failed on test %d for %s: ret=%d\n",
+				j, algo, -ret);
+			goto out;
+		}
+		if (memcmp(result, template[i].digest,
+			   crypto_ahash_digestsize(tfm))) {
+			pr_err("alg: hash: Partial Test %d failed for %s\n",
+			       j, algo);
+			hexdump(result, crypto_ahash_digestsize(tfm));
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
 	ret = 0;
 
 out:
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index da0a8fd..451e7eb 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -44,6 +44,7 @@ struct hash_testvec {
 	unsigned short psize;
 	unsigned char np;
 	unsigned char ksize;
+	unsigned char partial;
 };
 
 /*
@@ -772,7 +773,8 @@ static struct hash_testvec sha1_tv_template[] = {
 		.digest	= "\x97\x01\x11\xc4\xe7\x7b\xcc\x88\xcc\x20"
 			  "\x45\x9c\x02\xb6\x9b\x4a\xa8\xf5\x82\x17",
 		.np	= 4,
-		.tap	= { 63, 64, 31, 5 }
+		.tap	= { 63, 64, 31, 5 },
+		.partial = 1,
 	}, {
 		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
 		.psize	= 64,
-- 
1.8.3.1

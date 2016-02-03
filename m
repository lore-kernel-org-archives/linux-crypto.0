From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v3 4/4] crypto: testmgr - Add a test case for import()/export()
Date: Wed,  3 Feb 2016 18:26:57 +0800
Message-ID: <7a0ac9250bd971a5451fb856322cfd0e5b0b52b8.1454494348.git.rui.y.wang@intel.com>
References: <20160202144448.GB17909@gondor.apana.org.au>
Cc: rui.y.wang@intel.com, tim.c.chen@linux.intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbcBCKqe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 05:46:34 -0500
In-Reply-To: <20160202144448.GB17909@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify __test_hash() so that hash import/export can be tested
from within the kernel. The test is unconditionally done when
a struct hash_testvec has its .np > 1.

v3: make the test unconditional
v2: Leverage template[i].np as suggested by Tim Chen

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 crypto/testmgr.c | 133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..3afae37 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -198,6 +198,61 @@ static int wait_async_op(struct tcrypt_result *tr, int ret)
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
@@ -385,6 +440,84 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
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
-- 
1.8.3.1

From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [RFC 1/2] crypto: tcrypt - Add acipher bandwidth tests support
Date: Fri, 29 Jan 2016 15:33:06 +0200
Message-ID: <1454074387-8321-2-git-send-email-cata.vasile@nxp.com>
References: <1454074387-8321-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
	<cristian.stoica@nxp.com>, <alexandru.porosanu@nxp.com>,
	Catalin Vasile <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:12989
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752959AbcA2Nru (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 08:47:50 -0500
In-Reply-To: <1454074387-8321-1-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
---
 crypto/tcrypt.c | 501 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 501 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 270bc4b..f56419d 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -35,6 +35,7 @@
 #include <linux/jiffies.h>
 #include <linux/timex.h>
 #include <linux/interrupt.h>
+#include <linux/mempool.h>
 #include "tcrypt.h"
 
 /*
@@ -1021,6 +1022,300 @@ out:
 	crypto_free_ahash(tfm);
 }
 
+
+struct band_session_ctx {
+	mempool_t *req_mpool;
+	int job_size;
+	void *tfm;
+};
+
+struct band_req_ctx {
+	struct completion completion;
+	int err;
+	struct scatterlist sg[TVMEMSIZE];
+	struct band_session_ctx *session;
+	char iv[128];
+};
+atomic_t band_async_done;
+
+static inline void band_free_request(struct crypto_async_request *req)
+{
+	struct band_req_ctx *res = req->data;
+	struct band_session_ctx *ses_ctx = res->session;
+
+	kfree(sg_virt(res->sg));
+	mempool_free(req, ses_ctx->req_mpool);
+}
+
+static void band_complete(struct crypto_async_request *req, int err)
+{
+	struct band_req_ctx *res = req->data;
+
+	res->err = err;
+
+	/* if it previously was -EBUSY */
+	if (err == -EINPROGRESS) {
+		complete(&res->completion);
+	} else {
+		if (unlikely(err < 0))
+			pr_err("failed bandwidth acipher job with error: %d\n",
+			       err);
+		band_free_request(req);
+		atomic_inc(&band_async_done);
+	}
+}
+
+static inline int band_alloc_req(struct band_session_ctx *ses_ctx,
+				 void **req,
+				 void **buf_sg)
+{
+	*req = mempool_alloc(ses_ctx->req_mpool, GFP_KERNEL);
+	if (unlikely(!*req))
+		goto out;
+
+	*buf_sg = kmalloc(ses_ctx->job_size, GFP_KERNEL);
+	if (unlikely(!*buf_sg))
+		goto out_free_req;
+
+	return 0;
+
+out_free_req:
+	mempool_free(req, ses_ctx->req_mpool);
+out:
+	pr_err("out of memory for bandwidth benchmark request\n");
+	return -ENOMEM;
+}
+
+static inline struct ablkcipher_request
+*band_acipher_alloc_req(struct band_session_ctx *ses_ctx)
+{
+	struct ablkcipher_request *req;
+	struct band_req_ctx *br;
+	void *buf_sg;
+	size_t req_size = sizeof(struct ablkcipher_request) +
+			  crypto_ablkcipher_reqsize(ses_ctx->tfm);
+	size_t no_sg_entries = DIV_ROUND_UP(ses_ctx->job_size, PAGE_SIZE);
+	int rv;
+	int i;
+
+	rv = band_alloc_req(ses_ctx, (void **)&req, (void **)&buf_sg);
+	if (unlikely(rv))
+		return NULL;
+
+	br = ((void *)req) + req_size;
+	sg_init_table(br->sg, no_sg_entries);
+	if (ses_ctx->job_size < PAGE_SIZE)
+		sg_set_buf(br->sg, buf_sg, ses_ctx->job_size);
+	else
+		for (i = 0; i < no_sg_entries; i++) {
+			sg_set_buf(br->sg + i, buf_sg, PAGE_SIZE);
+			buf_sg += PAGE_SIZE;
+		}
+	ablkcipher_request_set_tfm(req, ses_ctx->tfm);
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					band_complete, br);
+	ablkcipher_request_set_crypt(req, br->sg, br->sg,
+				     ses_ctx->job_size, br->iv);
+
+	init_completion(&br->completion);
+	br->session = ses_ctx;
+
+	return req;
+}
+
+static inline int do_one_band_op(struct crypto_async_request *req, int ret)
+{
+	struct band_req_ctx *br = req->data;
+
+	if (ret == -EBUSY) {
+		wait_for_completion(&br->completion);
+		reinit_completion(&br->completion);
+		ret = br->err;
+	} else {
+		if (ret != -EINPROGRESS) {
+			band_free_request(req);
+			atomic_inc(&band_async_done);
+		}
+	}
+
+	return ret;
+}
+
+static int band_acipher_jiffies(struct band_session_ctx *ses_ctx,
+				int enc, int secs)
+{
+	struct ablkcipher_request *req;
+	unsigned long start, end;
+	unsigned long stop;
+	int elapsed_secs;
+	int bcount;
+	int no_jobs_done;
+	int ret = 0;
+	unsigned long long band;
+
+	for (start = jiffies, end = start + secs * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		req = band_acipher_alloc_req(ses_ctx);
+		if (unlikely(req == NULL))
+			break;
+		if (enc)
+			ret = do_one_band_op(&req->base,
+						crypto_ablkcipher_encrypt(req));
+		else
+			ret = do_one_band_op(&req->base,
+						crypto_ablkcipher_decrypt(req));
+
+		if (unlikely(ret != -EINPROGRESS && ret))
+			break;
+	}
+
+	stop = jiffies;
+	no_jobs_done = atomic_read(&band_async_done);
+	elapsed_secs = (stop - start) / HZ;
+
+	while (atomic_read(&band_async_done) < bcount)
+		cpu_relax();
+
+	band = ses_ctx->job_size;
+	band = no_jobs_done * band;
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		no_jobs_done, elapsed_secs, band);
+
+	if (likely(ret == -EINPROGRESS || ret))
+		ret = 0;
+
+	return ret;
+}
+
+static inline int
+band_acipher_init_session_ctx(const char *algo,
+			      struct band_session_ctx *ses_ctx)
+{
+	struct crypto_ablkcipher *tfm;
+	struct kmem_cache *req_cache;
+	mempool_t *req_mpool;
+	size_t req_size;
+	int err;
+
+	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n", algo,
+		       PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	req_size = sizeof(struct ablkcipher_request) +
+		   crypto_ablkcipher_reqsize(tfm) +
+		   sizeof(struct band_req_ctx);
+	req_cache = kmem_cache_create("tcrypt-band-acipher-req",
+				      req_size, 0, 0, NULL);
+	if (unlikely(!req_cache)) {
+		pr_err("failed to allocate request cache memory\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	req_mpool = mempool_create(1024, mempool_alloc_slab, mempool_free_slab,
+				   req_cache);
+	if (unlikely(!req_mpool)) {
+		pr_err("failed to allocate request memory pool\n");
+		err = -ENOMEM;
+		goto out_free_cache;
+	}
+
+	ses_ctx->req_mpool = req_mpool;
+	ses_ctx->tfm = tfm;
+
+	return 0;
+
+out_free_cache:
+	kmem_cache_destroy(req_cache);
+out:
+	crypto_free_ablkcipher(tfm);
+	return err;
+}
+
+static inline void
+band_acipher_destroy_session_ctx(struct band_session_ctx *ses_ctx)
+{
+	struct kmem_cache *req_cache = ses_ctx->req_mpool->pool_data;
+
+	mempool_destroy(ses_ctx->req_mpool);
+	kmem_cache_destroy(req_cache);
+	crypto_free_ablkcipher(ses_ctx->tfm);
+}
+
+static void band_acipher(const char *algo, int enc, unsigned int secs,
+			 struct cipher_speed_template *template,
+			 unsigned int tcount, u8 *keysize)
+{
+	struct band_session_ctx ses_ctx;
+	int ret, i, j;
+	const char *key;
+	const char *e;
+	u32 *b_size;
+
+	if (!secs)
+		return;
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	ret = band_acipher_init_session_ctx(algo, &ses_ctx);
+	if (unlikely(ret))
+		return;
+
+	pr_info("\ntesting band of async %s (%s) %s\n", algo,
+			get_driver_name(crypto_ablkcipher, ses_ctx.tfm), e);
+
+	i = 0;
+	do {
+		b_size = aead_sizes;
+
+		do {
+			pr_info("test %u (%d bit key, %d byte blocks): ", i,
+				*keysize * 8, *b_size);
+
+			memset(tvmem[0], 0xff, PAGE_SIZE);
+
+			/* set key, plain text and IV */
+			key = tvmem[0];
+			for (j = 0; j < tcount; j++) {
+				if (template[j].klen == *keysize) {
+					key = template[j].key;
+					break;
+				}
+			}
+
+			crypto_ablkcipher_clear_flags(ses_ctx.tfm, ~0);
+
+			ret = crypto_ablkcipher_setkey(ses_ctx.tfm,
+						       key, *keysize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x\n",
+				    crypto_ablkcipher_get_flags(ses_ctx.tfm));
+				break;
+			}
+
+			ses_ctx.job_size = *b_size;
+			atomic_set(&band_async_done, 0);
+			ret = band_acipher_jiffies(&ses_ctx, enc, secs);
+			if (ret) {
+				pr_err("%s() failed flags=%x\n", e,
+				    crypto_ablkcipher_get_flags(ses_ctx.tfm));
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
+
+	band_acipher_destroy_session_ctx(&ses_ctx);
+}
+
 static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
@@ -2189,7 +2484,213 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		test_acipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_32);
 		break;
+	case 600:
+		band_acipher("ecb(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ecb(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("cbc(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("cbc(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("lrw(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		band_acipher("lrw(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		band_acipher("xts(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		band_acipher("xts(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		band_acipher("ctr(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ctr(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("cfb(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("cfb(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ofb(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ofb(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("rfc3686(ctr(aes))", ENCRYPT, sec, NULL, 0,
+				   speed_template_20_28_36);
+		band_acipher("rfc3686(ctr(aes))", DECRYPT, sec, NULL, 0,
+				   speed_template_20_28_36);
+		break;
+
+	case 601:
+		band_acipher("ecb(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("ecb(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("cbc(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("cbc(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("cfb(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("cfb(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("ofb(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		band_acipher("ofb(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		break;
+
+	case 602:
+		band_acipher("ecb(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("ecb(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("cbc(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("cbc(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("cfb(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("cfb(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("ofb(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		band_acipher("ofb(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		break;
+
+	case 603:
+		band_acipher("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ecb(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("cbc(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ctr(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		band_acipher("lrw(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		band_acipher("xts(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		band_acipher("xts(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		break;
+
+	case 604:
+		band_acipher("ecb(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ecb(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("cbc(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("cbc(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("ctr(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		band_acipher("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		band_acipher("lrw(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		band_acipher("xts(twofish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48_64);
+		band_acipher("xts(twofish)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48_64);
+		break;
 
+	case 605:
+		band_acipher("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		break;
+
+	case 606:
+		band_acipher("ecb(cast5)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_16);
+		band_acipher("ecb(cast5)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_16);
+		band_acipher("cbc(cast5)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_16);
+		band_acipher("cbc(cast5)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_16);
+		band_acipher("ctr(cast5)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_16);
+		band_acipher("ctr(cast5)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_16);
+		break;
+
+	case 607:
+		band_acipher("ecb(cast6)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ecb(cast6)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("cbc(cast6)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("cbc(cast6)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ctr(cast6)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ctr(cast6)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("lrw(cast6)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		band_acipher("lrw(cast6)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		band_acipher("xts(cast6)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		band_acipher("xts(cast6)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		break;
+
+	case 608:
+		band_acipher("ecb(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ecb(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("cbc(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("cbc(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("ctr(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_32);
+		band_acipher("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		band_acipher("lrw(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		band_acipher("xts(camellia)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		band_acipher("xts(camellia)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		break;
+
+	case 609:
+		band_acipher("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		band_acipher("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		band_acipher("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		band_acipher("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		band_acipher("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		band_acipher("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+				   speed_template_8_32);
+		break;
 	case 1000:
 		test_available();
 		break;
-- 
1.8.3.1

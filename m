From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [RFC 2/2] crypto: tcrypt - Add ahash digest bandwidth tests support
Date: Fri, 29 Jan 2016 15:33:07 +0200
Message-ID: <1454074387-8321-3-git-send-email-cata.vasile@nxp.com>
References: <1454074387-8321-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
	<cristian.stoica@nxp.com>, <alexandru.porosanu@nxp.com>,
	Catalin Vasile <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0066.outbound.protection.outlook.com ([157.56.111.66]:30812
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756078AbcA2Ntq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 08:49:46 -0500
In-Reply-To: <1454074387-8321-1-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
---
 crypto/tcrypt.c | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 190 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f56419d..02a3856 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1316,6 +1316,176 @@ static void band_acipher(const char *algo, int enc, unsigned int secs,
 	band_acipher_destroy_session_ctx(&ses_ctx);
 }
 
+static inline struct ahash_request
+*band_ahash_alloc_req_digest(struct band_session_ctx *ses_ctx)
+{
+	struct ahash_request *req;
+	struct band_req_ctx *br;
+	void *buf_sg;
+	u8 *icv;
+	size_t req_size = sizeof(struct ahash_request) +
+			  crypto_ahash_reqsize(ses_ctx->tfm);
+	size_t src_size = ses_ctx->job_size -
+			  crypto_ahash_digestsize(ses_ctx->tfm);
+	size_t no_sg_entries = DIV_ROUND_UP(src_size, PAGE_SIZE);
+	int rv;
+	int i;
+
+	rv = band_alloc_req(ses_ctx, (void **)&req, (void **)&buf_sg);
+	if (unlikely(rv))
+		return NULL;
+
+	br = ((void *)req) + req_size;
+	icv = buf_sg + src_size;
+	sg_init_table(br->sg, no_sg_entries);
+	if (src_size < PAGE_SIZE)
+		sg_set_buf(br->sg, buf_sg, src_size);
+	else
+		for (i = 0; i < no_sg_entries; i++) {
+			sg_set_buf(br->sg + i, buf_sg, PAGE_SIZE);
+			buf_sg += PAGE_SIZE;
+		}
+	ahash_request_set_tfm(req, ses_ctx->tfm);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					band_complete, br);
+	ahash_request_set_crypt(req, br->sg, icv, src_size);
+
+	init_completion(&br->completion);
+	br->session = ses_ctx;
+
+	return req;
+}
+
+static int band_ahash_jiffies_digest(struct band_session_ctx *ses_ctx, int secs)
+{
+	struct ahash_request *req;
+	unsigned long start, end;
+	unsigned long stop;
+	int elapsed_secs;
+	int bcount;
+	int no_jobs_done;
+	int ret;
+	unsigned long long band;
+
+	for (start = jiffies, end = start + secs * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		req = band_ahash_alloc_req_digest(ses_ctx);
+		if (unlikely(req == NULL))
+			break;
+		ret = do_one_band_op(&req->base, crypto_ahash_digest(req));
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
+	band = ses_ctx->job_size - crypto_ahash_digestsize(ses_ctx->tfm);
+	band = no_jobs_done * band;
+	pr_cont("%d operations in %d seconds (%llu bytes processed)\n",
+		bcount, secs, band);
+
+	return 0;
+}
+
+static inline int
+band_ahash_init_session_ctx(const char *algo,
+			    struct band_session_ctx *ses_ctx)
+{
+	struct crypto_ahash *tfm;
+	struct kmem_cache *req_cache;
+	mempool_t *req_mpool;
+	size_t req_size;
+	int err;
+
+	tfm = crypto_alloc_ahash(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n",
+		       algo, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	req_size = sizeof(struct ahash_request) +
+		   crypto_ahash_reqsize(tfm) +
+		   sizeof(struct band_req_ctx);
+	req_cache = kmem_cache_create("tcrypt-band-ahash-req",
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
+	crypto_free_ahash(tfm);
+	return err;
+}
+
+static inline void
+band_ahash_destroy_session_ctx(struct band_session_ctx *ses_ctx)
+{
+	struct kmem_cache *req_cache = ses_ctx->req_mpool->pool_data;
+
+	mempool_destroy(ses_ctx->req_mpool);
+	kmem_cache_destroy(req_cache);
+	crypto_free_ahash(ses_ctx->tfm);
+}
+
+static void band_ahash_digest(const char *algo, unsigned int secs)
+{
+	struct band_session_ctx ses_ctx;
+	u32 *b_size;
+	int i, ret;
+
+	if (!secs)
+		return;
+
+	ret = band_ahash_init_session_ctx(algo, &ses_ctx);
+	if (unlikely(ret))
+		return;
+
+	pr_info("\ntesting band of async %s (%s)\n", algo,
+		get_driver_name(crypto_ahash, ses_ctx.tfm));
+
+	b_size = aead_sizes;
+	i = 0;
+	do {
+		pr_info("test %u (%d byte blocks): ", i, *b_size);
+
+		ses_ctx.job_size = *b_size +
+				   crypto_ahash_digestsize(ses_ctx.tfm);
+		atomic_set(&band_async_done, 0);
+		ret = band_ahash_jiffies_digest(&ses_ctx, secs);
+		if (ret) {
+			pr_err("hashing failed ret=%d\n", ret);
+			break;
+		}
+		b_size++;
+		i++;
+	} while (*b_size);
+
+	band_ahash_destroy_session_ctx(&ses_ctx);
+}
+
 static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
@@ -2691,6 +2861,26 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		band_acipher("ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_32);
 		break;
+	case 700:
+		if (alg) {
+			band_ahash_digest(alg, sec);
+			break;
+		}
+	case 701:
+		band_ahash_digest("md5", sec);
+		break;
+	case 702:
+		band_ahash_digest("sha1", sec);
+		break;
+	case 703:
+		band_ahash_digest("sha256", sec);
+		break;
+	case 704:
+		band_ahash_digest("sha384", sec);
+		break;
+	case 705:
+		band_ahash_digest("sha512", sec);
+		break;
 	case 1000:
 		test_available();
 		break;
-- 
1.8.3.1

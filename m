From: Megha Dey <megha.dey@linux.intel.com>
Subject: [PATCH v5 7/7] crypto: AES CBC multi-buffer tcrypt
Date: Mon, 26 Sep 2016 10:27:39 -0700
Message-ID: <1474910859-11713-8-git-send-email-megha.dey@linux.intel.com>
References: <1474910859-11713-1-git-send-email-megha.dey@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
        megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:45768 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161617AbcIZRUr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 13:20:47 -0400
In-Reply-To: <1474910859-11713-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tim Chen <tim.c.chen@linux.intel.com>

The tcrypt test framework for CBC multi-buffer testing is
laid out in this patch. Tcrypt has been extended to validate
the functionality and performance of AES CBC multi-buffer support.

A new test(mode=600) has been added to test the speed of the multibuffer
case, as multi-buffer encrypt will wait for additional encrypt requests
that never arrive to kick off computation. So we always incur the extra
delay before flush timer expires to trigger the computation in the (mode=500)
test. We create the new tests that will send out these additional requests
that can be aggregated and computed in parallel for true throughput speed test
of the multi-buffer encrypt test case.case.

The enhanced CBC tests create multiple transforms and exercise
the multi-buffer implementation. Crafted requests are sent at once
to the multiple transforms created and the returned responses
are compared with expected results. The test vectors are so chosen
as to exercise the scatter-gather list to the maximum allowable limit
within the framework.

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/tcrypt.c  | 257 ++++++++++++++++++-
 crypto/testmgr.c | 759 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 crypto/testmgr.h |  64 ++++-
 3 files changed, 1054 insertions(+), 26 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ae22f05..671f5bf 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -36,6 +36,7 @@
 #include <linux/jiffies.h>
 #include <linux/timex.h>
 #include <linux/interrupt.h>
+#include <linux/crypto.h>
 #include "tcrypt.h"
 
 /*
@@ -82,7 +83,7 @@ struct tcrypt_result {
 	int err;
 };
 
-static void tcrypt_complete(struct crypto_async_request *req, int err)
+void tcrypt_complete(struct crypto_async_request *req, int err)
 {
 	struct tcrypt_result *res = req->data;
 
@@ -181,6 +182,11 @@ static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
 
 #define XBUFSIZE 8
 #define MAX_IVLEN 32
+#define MB_WIDTH 8
+struct scatterlist mb_sg[MB_WIDTH][XBUFSIZE];
+struct skcipher_request *mb_req[MB_WIDTH];
+struct tcrypt_result mb_tresult[MB_WIDTH];
+char *mb_xbuf[MB_WIDTH][XBUFSIZE];
 
 static int testmgr_alloc_buf(char *buf[XBUFSIZE])
 {
@@ -778,6 +784,46 @@ static inline int do_one_acipher_op(struct skcipher_request *req, int ret)
 	return ret;
 }
 
+
+/*
+ * Perform a maximum of MB_WIDTH operations.
+ * Await the results and measure performance.
+ */
+cycles_t mb_start, mb_end;
+static int mb_err[MB_WIDTH];
+
+static inline int do_multi_acipher_op(
+	struct skcipher_request *req[MB_WIDTH], int enc)
+{
+	int i, ret, comp_ret = 0;
+	bool is_async;
+
+	for (i = 0; i < MB_WIDTH; ++i) {
+		ret = enc == ENCRYPT ? crypto_skcipher_encrypt(req[i])
+					: crypto_skcipher_decrypt(req[i]);
+		mb_err[i] = ret;
+		if (ret == -EINPROGRESS || ret == -EBUSY)
+			continue; /* on with next req */
+		/* any other error, bail out */
+		if (ret)
+			return ret;
+	}
+	for (i = 0; i < MB_WIDTH; ++i) {
+		struct tcrypt_result *tr = req[i]->base.data;
+
+		is_async = mb_err[i] == -EINPROGRESS || mb_err[i] == -EBUSY;
+		if (is_async) {
+			wait_for_completion(&tr->completion);
+			reinit_completion(&tr->completion);
+		}
+		comp_ret = tr->err;
+		if (comp_ret)
+			pr_info("multi_acipher_op error\n");
+	}
+
+	return comp_ret;
+}
+
 static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 				int blen, int secs)
 {
@@ -925,6 +971,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 			if (ret) {
 				pr_err("setkey() failed flags=%x\n",
 					crypto_skcipher_get_flags(tfm));
+
 				goto out_free_req;
 			}
 
@@ -978,6 +1025,203 @@ out:
 	crypto_free_skcipher(tfm);
 }
 
+static int test_mb_acipher_jiffies(
+	struct skcipher_request *req[MB_WIDTH], int enc, int blen, int secs)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	/* initiate a maximum of MB_WIDTH operations and measure performance */
+	for (start = jiffies, end = start + secs * HZ, bcount = 0;
+		time_before(jiffies, end); bcount += MB_WIDTH) {
+		ret = do_multi_acipher_op(req, enc);
+		if (ret)
+		return ret;
+	}
+
+	pr_cont("%d operations in %d seconds (%ld bytes)\n",
+		bcount, secs, (long)bcount * blen);
+	return 0;
+}
+
+#define ITR 8
+static int test_mb_acipher_cycles(
+	struct skcipher_request *req[MB_WIDTH], int enc, int blen)
+{
+	cycles_t cycles = 0;
+	int ret = 0;
+	int i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		ret = do_multi_acipher_op(req, enc);
+
+		if (ret)
+			goto out;
+	}
+	/*
+	 * Initiate a maximum of MB_WIDTH operations per loop
+	 * Measure performance over MB_WIDTH iterations
+	 * Let do_multi_acipher_op count the cycles
+	 */
+	for (i = 0; i < ITR; i++) {
+		mb_start = get_cycles();
+		ret = do_multi_acipher_op(req, enc);
+
+		mb_end = get_cycles();
+		cycles += mb_end - mb_start;
+		if (ret)
+			goto out;
+	}
+
+out:
+	if (ret == 0)
+		pr_cont("1 operation in %llu cycles (%d bytes)\n",
+			(cycles + 4) / (ITR*MB_WIDTH), blen);
+
+	return ret;
+}
+
+static void test_mb_acipher_speed(const char *algo, int enc, unsigned int secs,
+				struct cipher_speed_template *template,
+				unsigned int tcount, u8 *keysize)
+{
+	unsigned int ret, i, j, k, iv_len, r;
+	const char *key;
+	char iv[128];
+	struct crypto_skcipher *tfm;
+	const char *e, *driver;
+	u32 *b_size;
+
+	pr_info("test_mb_acipher_speed: test algo %s\n", algo);
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	tfm = crypto_alloc_skcipher(algo, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n", algo,
+			PTR_ERR(tfm));
+		return;
+	}
+
+       /* FIXME: do we need to check this? */
+	driver = get_driver_name(crypto_skcipher, tfm);
+	pr_info("\ntesting speed of async %s (%s) %s\n", algo, driver, e);
+
+	/* set up multiple requests for the transform */
+	for (r = 0; r < MB_WIDTH; ++r) {
+		init_completion(&mb_tresult[r].completion);
+		mb_req[r] = skcipher_request_alloc(tfm, GFP_KERNEL);
+		if (!mb_req[r]) {
+			pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
+					algo);
+			goto out;
+		}
+
+		skcipher_request_set_callback(mb_req[r],
+				CRYPTO_TFM_REQ_MAY_BACKLOG,
+				tcrypt_complete, &mb_tresult[r]);
+	}
+
+	/* loop through different data sizes to encrypt/decrypt */
+	i = 0;
+	do {
+		b_size = block_sizes;
+
+		do {
+			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+				pr_err("template (%u) too big for tvmem (%lu)\n",
+				*keysize + *b_size, TVMEMSIZE * PAGE_SIZE);
+				goto out_free_req;
+			}
+
+			pr_info("test %u (%d bit key, %d byte blocks): ", i,
+					*keysize * 8, *b_size);
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
+			crypto_skcipher_clear_flags(tfm, ~0);
+
+			ret = crypto_skcipher_setkey(tfm, key, *keysize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x keysize=%d\n",
+					crypto_skcipher_get_flags(tfm),
+					*keysize);
+				goto out_free_req;
+			}
+
+			/* set scatter-gather list of data */
+			for (r = 0; r < MB_WIDTH; ++r) {
+				sg_init_table(mb_sg[r], TVMEMSIZE);
+
+				k = *keysize + *b_size;
+				if (k > PAGE_SIZE) {
+					sg_set_buf(mb_sg[r],
+							tvmem[0] + *keysize,
+							PAGE_SIZE - *keysize);
+					k -= PAGE_SIZE;
+					j = 1;
+					while (k > PAGE_SIZE) {
+						sg_set_buf(&mb_sg[r][j],
+							tvmem[j], PAGE_SIZE);
+						memset(tvmem[j], 0xff,
+								PAGE_SIZE);
+						j++;
+						k -= PAGE_SIZE;
+					}
+					sg_set_buf(&mb_sg[r][j], tvmem[j], k);
+					memset(tvmem[j], 0xff, k);
+				} else {
+					sg_set_buf(mb_sg[r],
+						tvmem[0] + *keysize, *b_size);
+				}
+
+				iv_len = crypto_skcipher_ivsize(tfm);
+				if (iv_len)
+					memset(&iv, 0xff, iv_len);
+
+				skcipher_request_set_crypt(mb_req[r],
+						mb_sg[r], mb_sg[r],
+						*b_size, iv);
+			}
+			if (secs)
+				ret = test_mb_acipher_jiffies(mb_req, enc,
+						*b_size, secs);
+			else
+				ret = test_mb_acipher_cycles(mb_req, enc,
+						*b_size);
+
+			if (ret) {
+				pr_err("%s() failed flags=%x\n", e,
+					crypto_skcipher_get_flags(tfm));
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
+
+out_free_req:
+	for (r = 0; r < MB_WIDTH; ++r)
+		skcipher_request_free(mb_req[r]);
+out:
+	crypto_free_skcipher(tfm);
+}
+
 static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 			       struct cipher_speed_template *template,
 			       unsigned int tcount, u8 *keysize)
@@ -2035,6 +2279,17 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				   speed_template_8_32);
 		break;
 
+	case 600:
+		/* Measure performance of aes-cbc multibuffer support */
+		test_mb_acipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+			speed_template_16_24_32);
+		test_mb_acipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+			speed_template_16_24_32);
+		break;
+	case 601:
+		ret += tcrypt_test("cbc(aes)");
+		break;
+
 	case 1000:
 		test_available();
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0b01c3d..a26b9b0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1,3 +1,4 @@
+
 /*
  * Algorithm testing framework and tests.
  *
@@ -146,6 +147,23 @@ struct alg_test_desc {
 
 static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 
+#ifdef CONFIG_CRYPTO_AES_CBC_MB
+/*
+ * Indexes into the xbuf to simulate cross-page access for multibuffer tests.
+ */
+#define MB_IDX1                32
+#define MB_IDX2                32400
+#define MB_IDX3                4222
+#define MB_IDX4                8193
+#define MB_IDX5                22222
+#define MB_IDX6                17101
+#define MB_IDX7                27333
+#define MB_IDX8                13222
+static unsigned int MB_IDX[8] = {
+	MB_IDX1, MB_IDX2, MB_IDX3, MB_IDX4,
+	MB_IDX5, MB_IDX6, MB_IDX7, MB_IDX8 };
+#endif /* CONFIG_CRYPTO_AES_CBC_MB */
+
 static void hexdump(unsigned char *buf, unsigned int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
@@ -383,7 +401,7 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		ret = -EINVAL;
 		for (k = 0; k < template[i].np; k++) {
 			if (WARN_ON(offset_in_page(IDX[k]) +
-				    template[i].tap[k] > PAGE_SIZE))
+				   template[i].tap[k] > PAGE_SIZE))
 				goto out;
 			sg_set_buf(&sg[k],
 				   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
@@ -1025,30 +1043,33 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 			crypto_cipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 
 		ret = crypto_cipher_setkey(tfm, template[i].key,
-					   template[i].klen);
+				template[i].klen);
 		if (template[i].fail == !ret) {
 			printk(KERN_ERR "alg: cipher: setkey failed "
-			       "on test %d for %s: flags=%x\n", j,
-			       algo, crypto_cipher_get_flags(tfm));
+					"on test %d for %s: flags=%x\n", j,
+					algo, crypto_cipher_get_flags(tfm));
 			goto out;
 		} else if (ret)
 			continue;
 
 		for (k = 0; k < template[i].ilen;
-		     k += crypto_cipher_blocksize(tfm)) {
+				k += crypto_cipher_blocksize(tfm)) {
 			if (enc)
 				crypto_cipher_encrypt_one(tfm, data + k,
-							  data + k);
+						data + k);
 			else
 				crypto_cipher_decrypt_one(tfm, data + k,
-							  data + k);
+						data + k);
 		}
 
 		q = data;
 		if (memcmp(q, template[i].result, template[i].rlen)) {
 			printk(KERN_ERR "alg: cipher: Test %d failed "
-			       "on %s for %s\n", j, e, algo);
+					"on %s for %s\n", j, e, algo);
 			hexdump(q, template[i].rlen);
+			printk(KERN_ERR "alg: cipher: Test %d expected on %s for %s\n",
+				j, e, algo);
+			hexdump(template[i].result, template[i].rlen);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1180,8 +1201,14 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 			pr_err("alg: skcipher%s: Test %d failed (invalid result) on %s for %s\n",
 			       d, j, e, algo);
 			hexdump(q, template[i].rlen);
+			pr_err("alg: skcipher%s: Test %d expected %s for %s\n",
+				d, j, e, algo);
+			hexdump(template[i].result, template[i].rlen);
 			ret = -EINVAL;
 			goto out;
+		pr_err("alg: skcipher%s: Test %d expected %s for %s\n",
+				d, j, e, algo);
+			hexdump(template[i].result, template[i].rlen);
 		}
 
 		if (template[i].iv_out &&
@@ -1296,9 +1323,18 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 			if (memcmp(q, template[i].result + temp,
 				   template[i].tap[k])) {
 				pr_err("alg: skcipher%s: Chunk test %d failed on %s at page %u for %s\n",
-				       d, j, e, k, algo);
+					d, j, e, k, algo);
 				hexdump(q, template[i].tap[k]);
+				pr_err(
+	"alg: skcipher%s: Chunk test %d expected on %s at page %u for %s\n",
+					d, j, e, k, algo);
+				hexdump(template[i].result + temp,
+					template[i].tap[k]);
 				goto out;
+			} else {
+				pr_err(
+	"alg: skcipher%s: Chunk test %d succeeded on %s at page %u for %s klen %d\n",
+					d, j, e, k, algo, template[i].klen);
 			}
 
 			q += template[i].tap[k];
@@ -1558,29 +1594,718 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_CRYPTO_AES_CBC_MB
+/*
+ * AES CBC multibuffer implementation can encrypt
+ * a maximum of 8 requests at once. Therefore, the
+ * MAX_REQ should be set >= 8 for better performance.
+ * The MAX_XFM allows multiple transforms created within
+ * the test framework.
+ *
+ * The multibuffer tests set up several requests and
+ * hand them off to the multibuffer driver. Error processing
+* does not simply bail out. The test code walks through all
+ * requests and awaits their completion. Indiscriminate premature
+ * bailout on error while other requests are in progress will cause
+ * trouble.
+ */
+
+#define MAX_REQ        16
+#define MAX_XFM        MAX_REQ
+static struct skcipher_request *mb_req[MAX_REQ][MAX_REQ];
+static struct scatterlist mb_sg[MAX_REQ][MAX_REQ][8];
+static struct scatterlist mb_sgout[MAX_REQ][MAX_REQ][8];
+static struct tcrypt_result mb_result[MAX_REQ][MAX_REQ];
+static char *mb_xbuf[MAX_REQ][MAX_REQ][XBUFSIZE];
+static char *mb_xoutbuf[MAX_REQ][MAX_REQ][XBUFSIZE];
+static int mb_err[MAX_REQ][MAX_REQ];
+static char ivec[MAX_REQ][MAX_REQ][MAX_IVLEN];
+/* random data for cbc multibuffer tests */
+static struct cipher_test_suite mb_cbc_cipher[] = {
+	{
+		{
+			.vecs = aes_cbc_enc_tv_template_rnddata_klenmix,
+			.count = AES_CBC_ENC_TV_TEMPLATE_RNDDATA_KEY16_VEC_COUNT
+		},
+		{
+			.vecs = aes_cbc_dec_tv_template_rnddata_klen16,
+			.count = AES_CBC_DEC_TV_TEMPLATE_RNDDATA_KEY16_VEC_COUNT
+		}
+	},
+};
+
+/*
+ * Test multibuffer version AES CBC crypto algorithm via multiple transforms.
+ * The test iterates through a set of MAX_REQ requests with identical key,
+ * but unique input and IV.
+ */
+
+/*
+ * Test multibuffer version AES CBC crypto algorithm via multiple transforms.
+ * The test iterates through the test vectors sending MAX_REQ requests with
+ * the same vector and IV.
+ */
+/* free buffers allocated for testing multibuffer cbc */
+
+static void free_mbxbuf(int tidx)
+{
+	int i;
+
+	for (i = 0; i < MAX_REQ; ++i) {
+		if (mb_xbuf[tidx][i])
+			testmgr_free_buf(mb_xbuf[tidx][i]);
+	}
+}
+
+/* free  MAX_REQ mb_xout buffers for a given transform */
+
+static void free_mbxoutbuf(int tidx)
+{
+	int i;
+
+	for (i = 0; i < MAX_REQ; ++i) {
+		if (mb_xoutbuf[tidx][i])
+			testmgr_free_buf(mb_xoutbuf[tidx][i]);
+	}
+}
+
+/* free MAX_REQ requests for a given transform */
+
+static void free_mbreq(int tidx)
+{
+	int i;
+
+	for (i = 0; i < MAX_REQ; ++i)
+		skcipher_request_free(mb_req[tidx][i]);
+}
+
+/* For a given transform, allocate buffers to test multibuffer cbc */
+
+static int allocbuf_mb(int tidx, struct crypto_skcipher *tfm,
+			const bool diff_dst, const char *algo)
+{
+	int r, n, err = 0;
+	char *ybuf[XBUFSIZE];
+
+	for (r = 0; r < MAX_REQ; ++r) {
+		if (testmgr_alloc_buf(ybuf))
+			goto out_nobuf;
+
+		for (n = 0; n < XBUFSIZE; ++n)
+			mb_xbuf[tidx][r][n] = ybuf[n];
+
+		if (diff_dst) {
+			if (testmgr_alloc_buf(ybuf))
+				goto out_nooutbuf;
+			for (n = 0; n < XBUFSIZE; ++n)
+				mb_xoutbuf[tidx][r][n] = ybuf[n];
+		}
+
+		init_completion(&mb_result[tidx][r].completion);
+
+		mb_req[tidx][r] = skcipher_request_alloc(
+				tfm,
+				GFP_KERNEL);
+		if (!mb_req[tidx][r]) {
+			err = -ENOMEM;
+			pr_err(
+				"alg: __test_skcipher: Failed to allocate request for %s\n",
+				algo);
+			goto out;
+		}
+		skcipher_request_set_callback(mb_req[tidx][r],
+			CRYPTO_TFM_REQ_MAY_BACKLOG,
+			tcrypt_complete, &mb_result[tidx][r]);
+	}
+	return 0;
+
+out:
+	free_mbreq(tidx);
+	if (diff_dst)
+		free_mbxoutbuf(tidx);
+
+out_nooutbuf:
+	free_mbxbuf(tidx);
+
+out_nobuf:
+	return err;
+}
+
+static void set_mb_input(unsigned int tidx, unsigned int vidx,
+			struct cipher_testvec *template,
+			const int align_offset, bool uniq_vec)
+{
+	void *data;
+	struct cipher_testvec *tvec;
+
+	tvec = &template[vidx] + tidx;
+	data = mb_xbuf[tidx][0][0];
+	data += align_offset;
+	memcpy(data, tvec->input, tvec->ilen);
+}
+
+static void send_mb_req(int tidx, unsigned int vidx, int enc,
+			const bool diff_dst, const int align_offset,
+			struct cipher_testvec *template, bool uniq_vec,
+			const char *algo)
+{
+	int ret;
+	void *data;
+	char *iv, *d, *e;
+	unsigned short ilen;
+	struct cipher_testvec *tvec;
+	char *thisiv;
+
+	tvec = &template[vidx] + tidx;
+	iv = tvec->iv;
+	ilen = tvec->ilen;
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	memset(&mb_err[tidx][0], 0, MAX_REQ); /* no error to begin with */
+
+	data = mb_xbuf[tidx][0][0];
+	data += align_offset;
+	sg_init_one(&mb_sg[tidx][0][0], data, ilen);
+	if (diff_dst) {
+		data = mb_xoutbuf[tidx][0][0];
+		data += align_offset;
+		sg_init_one(&mb_sgout[tidx][0][0], data, ilen);
+	}
+
+	thisiv = ivec[tidx][0];
+	memcpy(thisiv, iv, MAX_IVLEN);
+	skcipher_request_set_crypt(
+			mb_req[tidx][0],
+			mb_sg[tidx][0],
+			(diff_dst) ? mb_sgout[tidx][0]
+			: mb_sg[tidx][0],
+			ilen, thisiv);
+	ret = enc ?
+		crypto_skcipher_encrypt(
+				mb_req[tidx][0])
+		:
+		crypto_skcipher_decrypt(
+				mb_req[tidx][0]);
+
+	if (ret == -EINPROGRESS || ret == -EBUSY || ret == 0) {
+		/* deal with return status properly */
+		mb_err[tidx][0] = ret;
+	} else if (ret) {
+		unsigned int id;
+
+		mb_err[tidx][0] = ret;
+		id = vidx;
+		/* error */
+		pr_err("skcipher%s: %s failed on test %d for %s: ret=%d\n",
+				d, e, id, algo, -ret);
+		pr_err("skcipher%s: req=%d failed\n",
+				d, tidx);
+	}
+}
+
+static void await_mb_result(int tidx)
+{
+	int ret;
+	struct tcrypt_result *tr = &mb_result[tidx][0];
+
+	if (mb_err[tidx][0]) {
+		if (mb_err[tidx][0] != -EINPROGRESS &&
+				mb_err[tidx][0] != -EBUSY) {
+			pr_err("skcipher error\n"); /* skip reqs that failed */
+			return;
+		}
+		/* wait on async completions */
+		wait_for_completion(&tr->completion);
+		ret = tr->err;
+		mb_err[tidx][0] = ret;
+		if (!ret) {
+			/* no error, on with next */
+			reinit_completion(&tr->completion);
+		} else {
+			pr_err("skcipher: xfm=%d completion error %d\n",
+					tidx, ret);
+		}
+	}
+	/* no wait on synchronous completions */
+}
+
+static void check_mb_result(int tidx, unsigned int vidx, int enc,
+			const bool diff_dst, const int align_offset,
+			struct cipher_testvec *template, bool uniq_vec,
+			const char *algo)
+{
+	void *data;
+	char *q, *d, *e;
+	struct cipher_testvec *tvec;
+
+	tvec = &template[vidx] + tidx;
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+
+	/* the request resulted in error, move on */
+	if (mb_err[tidx][0])
+		return;
+
+	if (diff_dst) {
+		data = mb_xoutbuf[tidx][0][0];
+		data += align_offset;
+	} else {
+		data = mb_xbuf[tidx][0][0];
+		data += align_offset;
+	}
+	q = data;
+	if (memcmp(q, tvec->result, tvec->rlen)) {
+		pr_err("skcipher%s: Test %d(%d) failed on %s for %s\n",
+				d, tidx, vidx, e, algo);
+		pr_err("skcipher: xfm=%d result mismatch\n",
+				tidx);
+		pr_err("Expected result for xfm=%d\n", tidx);
+		hexdump(tvec->result,
+				tvec->rlen);
+		pr_err("Encountered result for xfm=%d\n",
+				tidx);
+		hexdump(q, tvec->rlen);
+	} else {
+		pr_err("skcipher%s: Test %d(%d) succeeded on %s for %s\n",
+				d, tidx, vidx, e, algo);
+	}
+}
+
+static void check_mb_sg_result(int tidx, unsigned int vidx, int enc,
+			bool diff_dst, struct cipher_testvec *template,
+			bool uniq_vec, const char *algo)
+{
+	unsigned int k, n;
+	unsigned int temp;
+	char *q, *d, *e;
+	struct cipher_testvec *tvec;
+	unsigned int cor_pg, cor_bytes;
+	unsigned int id; /* test id */
+
+	tvec = &template[vidx] + tidx;
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	temp = 0;
+	id = vidx;
+	if (mb_err[tidx][0])
+		return; /* on with other reqs */
+	for (k = 0; k < tvec->np; k++) {
+		unsigned int pg;
+
+		pg = MB_IDX[k] >> PAGE_SHIFT;
+		if (diff_dst)
+			q = mb_xoutbuf[tidx][0][pg] +
+				offset_in_page(MB_IDX[k]);
+		else
+			q = mb_xbuf[tidx][0][pg] +
+				offset_in_page(MB_IDX[k]);
+
+		cor_bytes = tvec->tap[k];
+		cor_pg = k;
+		if (memcmp(q, tvec->result + temp, tvec->tap[k])) {
+			pr_err(
+				"skcipher%s: chunk test %d failed/corruption %s @pg %u for %s:%u bytes:\n",
+					d, id, e, cor_pg, algo, cor_bytes);
+			hexdump(q, cor_bytes);
+			return;
+		}
+		pr_err(
+			"skcipher%s: chunk test %d succeeded %s @pg %u for %s:%u bytes:\n",
+				d, id, e, cor_pg, algo, cor_bytes);
+
+		q += tvec->tap[k];
+		for (n = 0; offset_in_page(q + n) && q[n]; n++)
+			;
+		if (n) {
+			cor_bytes = n;
+			cor_pg = k;
+			pr_err(
+				"skcipher%s: chunk test %d result corruption %s @pg %u for %s:%u bytes:\n",
+					d, id, e, cor_pg, algo, cor_bytes);
+			hexdump(q, cor_bytes);
+			break; /* on with next request */
+		}
+		temp += tvec->tap[k];
+	}
+}
+
+static void send_mb_sg_req(int tidx, unsigned int vidx, int enc,
+			   bool diff_dst, struct cipher_testvec *template,
+			   bool uniq_vec, const char *algo)
+{
+	unsigned int k, n;
+	unsigned int temp;
+	int ret;
+	char *q, *d, *e;
+	char *ybuf[XBUFSIZE];
+	struct cipher_testvec *tvec;
+	char *thisiv;
+
+	tvec = &template[vidx] + tidx;
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	memset(&mb_err[tidx][0], 0, MAX_REQ);
+
+	temp = 0;
+	sg_init_table(&mb_sg[tidx][0][0], tvec->np);
+	if (diff_dst)
+		sg_init_table(&mb_sgout[tidx][0][0], tvec->np);
+
+	for (k = 0; k < tvec->np; ++k) {
+		unsigned int pg;
+
+		if (WARN_ON((offset_in_page(MB_IDX[k]) + tvec->tap[k]) >
+					PAGE_SIZE)) {
+			pr_err("skcipher%s: %s Invalid sg for %s\n",
+					d, e, algo);
+			pr_err("offset + tap(%d) > PAGE_SIZE(%lu)\n",
+					tvec->tap[k], PAGE_SIZE);
+			pr_err("req=%d k=%d tap(%d)\n",
+					tidx, k, tvec->tap[k]);
+			break;  /* skip this */
+		}
+
+		for (n = 0; n < XBUFSIZE; ++n)
+			ybuf[n] = mb_xbuf[tidx][0][n];
+		pg = MB_IDX[k] >> PAGE_SHIFT;
+		q = ybuf[pg] + offset_in_page(MB_IDX[k]);
+
+		memcpy(q, tvec->input + temp, tvec->tap[k]);
+
+		if ((offset_in_page(q) + tvec->tap[k]) < PAGE_SIZE)
+			q[tvec->tap[k]] = 0;
+
+		sg_set_buf(&mb_sg[tidx][0][k], q, tvec->tap[k]);
+		if (diff_dst) {
+			unsigned int segs;
+
+			segs = tvec->tap[k];
+			q = mb_xoutbuf[tidx][0][pg] +
+				offset_in_page(MB_IDX[k]);
+
+			sg_set_buf(&mb_sgout[tidx][0][k], q, segs);
+
+			memset(q, 0, tvec->tap[k]);
+			if ((offset_in_page(q) + tvec->tap[k]) <
+					PAGE_SIZE)
+				q[segs] = 0;
+		}
+
+		temp += tvec->tap[k];
+	}
+
+	thisiv = ivec[tidx][0];
+	memcpy(thisiv, tvec->iv, MAX_IVLEN);
+	skcipher_request_set_crypt(
+			mb_req[tidx][0],
+			&mb_sg[tidx][0][0],
+			(diff_dst) ? &mb_sgout[tidx][0][0]
+			: &mb_sg[tidx][0][0],
+			tvec->ilen,
+			thisiv);
+
+	ret = enc ? crypto_skcipher_encrypt(
+			mb_req[tidx][0])
+		: crypto_skcipher_decrypt(
+				mb_req[tidx][0]);
+
+	if (ret == -EBUSY || ret == -EINPROGRESS || ret == 0) {
+		/* deal with return status properly */
+		mb_err[tidx][0] = ret;
+		if (uniq_vec)
+			++tvec;
+	} else if (ret) {
+		mb_err[tidx][0] = ret;
+		pr_err("skcipher%s: xfm=%d failed for %s algo %s\n",
+				d, tidx, e, algo);
+	}
+}
+
+static int __test_mb_skcipher(struct crypto_skcipher *tfm[MAX_REQ],
+			      int enc, struct cipher_testvec *template,
+			      unsigned int tcount,
+			      const bool diff_dst, const int align_offset)
+{
+	const char *algo;
+	unsigned int i, j;
+	const char *e, *d;
+	int ret = -ENOMEM;
+	bool sent[MAX_REQ];
+
+	/* same algorithm, multiple xfms */
+	algo = crypto_tfm_alg_driver_name(
+			crypto_skcipher_tfm(tfm[0]));
+
+	memset(mb_xbuf, '\0', sizeof(mb_xbuf));
+	memset(mb_xoutbuf, '\0', sizeof(mb_xoutbuf));
+
+	for (i = 0; i < MAX_REQ; ++i) {
+		if (allocbuf_mb(i, tfm[i], diff_dst, algo))
+			goto out_nobuf;
+	}
+
+	if (diff_dst)
+		d = "-ddst";
+	else
+		d = "";
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	for (i = 0; i < MAX_REQ; ++i)
+		sent[i] = false;
+
+	/* multi xfm, and send multi requests for all xfms and await results */
+	j = 0;
+	for (i = 0; i < tcount; i++) {
+		if (template[i].np && !template[i].also_non_np)
+			continue;
+		/* ensure that the vector data is within page size */
+		if (template[i].ilen > PAGE_SIZE)
+			continue;
+
+		ret = -EINVAL;
+		if (WARN_ON(align_offset + template[i].ilen > PAGE_SIZE))
+			goto out;
+
+		/* set the data for multiple xfms */
+		set_mb_input(i, 0, template,
+				align_offset, false);
+
+		/*
+		 * Set the key for multiple xfms.
+		 * To proceed with test all xfms should be successful
+		 */
+
+		crypto_skcipher_clear_flags(tfm[i], ~0);
+		if (template[i].wk)
+			crypto_skcipher_set_flags(tfm[i],
+					CRYPTO_TFM_REQ_WEAK_KEY);
+
+		ret = crypto_skcipher_setkey(tfm[i], template[i].key,
+				template[i].klen);
+		if (!ret == template[i].fail) {
+			pr_err(
+					"alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
+					d, i, algo,
+					crypto_skcipher_get_flags(tfm[i]));
+			goto out;
+		} else if (ret)
+			break;
+		/* move on to next test if key could not be setup */
+		if (ret)
+			continue;
+
+		j++;
+
+		sent[i] = true;
+		send_mb_req(i, 0, enc, diff_dst, align_offset,
+				template, false, algo);
+
+	}
+	/* await results from multiple requests from multiple xfms */
+	for (i = 0; i < tcount; ++i) {
+		if (sent[i])
+			await_mb_result(i);
+	}
+
+	/* check results from multiple requests from multiple xfms */
+	for (i = 0; i < tcount; ++i) {
+		if (sent[i])
+			check_mb_result(i, 0, enc, diff_dst,
+					align_offset, template, false, algo);
+		sent[i] = false;
+	}
+
+	j = 0;
+	for (i = 0; i < tcount; i++) {
+		/* alignment tests are only done with continuous buffers */
+
+		if (align_offset != 0)
+			break;
+		if (!template[i].np)
+			continue;
+
+		j++;
+		/* set the key for multiple transforms */
+		crypto_skcipher_clear_flags(tfm[i], ~0);
+		if (template[i].wk)
+			crypto_skcipher_set_flags(
+					tfm[i],
+					CRYPTO_TFM_REQ_WEAK_KEY);
+
+		ret = crypto_skcipher_setkey(tfm[i], template[i].key,
+				template[i].klen);
+		if (!ret == template[i].fail) {
+			pr_err(
+					"skcipher%s: setkey failed on chunk test %d xfm=%d for %s: flags=%x\n",
+					d, j, i, algo,
+					crypto_skcipher_get_flags(tfm[i]));
+			goto out;
+		} else if (ret)
+			break;
+		if (ret)
+			continue; /* on to next test */
+
+		/* iterate the test over multiple requests & xfms */
+
+		sent[i] = true;
+		send_mb_sg_req(i, 0, enc, diff_dst,
+				template, false, algo);
+	}
+
+	/* wait for completion from all xfms */
+	for (i = 0; i < tcount; ++i) {
+		if (sent[i])
+			await_mb_result(i);
+	}
+
+	/* check results from all xfms */
+	for (i = 0; i < tcount; ++i) {
+		if (sent[i])
+			check_mb_sg_result(i, 0, enc, diff_dst,
+					template, false, algo);
+	}
+
+	ret = 0;
+out:
+	for (i = 0; i < MAX_REQ; ++i)
+		free_mbreq(i);
+
+	if (diff_dst) {
+		for (i = 0; i < MAX_REQ; ++i)
+			free_mbxoutbuf(i);
+	}
+	for (i = 0; i < MAX_REQ; ++i)
+		free_mbxbuf(i);
+
+out_nobuf:
+	return ret;
+}
+
+static int test_mb_skcipher(struct crypto_skcipher *tfm[MAX_XFM],
+			    int enc, struct cipher_testvec *template,
+			    unsigned int tcount)
+{
+	int ret;
+
+	/* test 'dst == src' case */
+	ret = __test_mb_skcipher(tfm, enc, template, tcount, false, 0);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int alg_test_mb_skcipher(const struct alg_test_desc *desc,
+				const char *driver, u32 type, u32 mask)
+{
+	struct crypto_skcipher *tfm[MAX_REQ];
+	int err = 0;
+	int i;
+
+	/* create multiple transforms to test AES CBC */
+	for (i = 0; i < MAX_REQ; i++) {
+		tfm[i] = crypto_alloc_skcipher(driver,
+				type | CRYPTO_ALG_INTERNAL, mask);
+		if (IS_ERR(tfm[i])) {
+			printk(KERN_ERR "alg: skcipher: Failed to load transform for %s: %ld\n",
+					driver, PTR_ERR(tfm[i]));
+			return PTR_ERR(tfm[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mb_cbc_cipher); ++i) {
+		err = test_mb_skcipher(
+				tfm,
+				ENCRYPT,
+				mb_cbc_cipher[i].enc.vecs,
+				mb_cbc_cipher[i].enc.count
+				);
+		if (err)
+			goto out;
+
+		err = test_mb_skcipher(
+				tfm,
+				DECRYPT,
+				mb_cbc_cipher[i].dec.vecs,
+				mb_cbc_cipher[i].dec.count
+				);
+		if (err)
+			goto out;
+
+	}
+out:
+	for (i = 0; i < MAX_REQ; i++)
+		crypto_free_skcipher(tfm[i]);
+
+	return err;
+}
+#endif /* CONFIG_CRYPTO_AES_CBC_MB */
+
 static int alg_test_skcipher(const struct alg_test_desc *desc,
-			     const char *driver, u32 type, u32 mask)
+			const char *driver, u32 type, u32 mask)
 {
 	struct crypto_skcipher *tfm;
 	int err = 0;
 
+#ifdef CONFIG_CRYPTO_AES_CBC_MB
+	/* invoke the comprehensive cbc multibuffer tests */
+	if (desc->alg && (strcmp(desc->alg, "cbc(aes)") == 0))
+		return alg_test_mb_skcipher(desc, driver, type, mask);
+#endif
+
 	tfm = crypto_alloc_skcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
-		       "%s: %ld\n", driver, PTR_ERR(tfm));
+				"%s: %ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
 
 	if (desc->suite.cipher.enc.vecs) {
 		err = test_skcipher(tfm, ENCRYPT, desc->suite.cipher.enc.vecs,
-				    desc->suite.cipher.enc.count);
+				desc->suite.cipher.enc.count);
 		if (err)
 			goto out;
 	}
 
 	if (desc->suite.cipher.dec.vecs)
 		err = test_skcipher(tfm, DECRYPT, desc->suite.cipher.dec.vecs,
-				    desc->suite.cipher.dec.count);
+				desc->suite.cipher.dec.count);
 
 out:
 	crypto_free_skcipher(tfm);
@@ -2110,6 +2835,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "__driver-cbc-aes-aesni-mb",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "__driver-cbc-camellia-aesni",
 		.test = alg_test_null,
 	}, {
@@ -3615,6 +4344,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "mcryptd(__driver-cbc-aes-aesni-mb)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "md4",
 		.test = alg_test_hash,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index da99f89..ee6b223 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -34546,19 +34546,59 @@ static struct comp_testvec lz4hc_decomp_tv_template[] = {
 };
 
 #ifdef CONFIG_CRYPTO_AES_CBC_MB
-static struct cipher_testvec aes_cbc_enc_tv_template_rnddata_klen16[] = {
+static struct cipher_testvec aes_cbc_enc_tv_template_rnddata_klenmix[] = {
 {
-	.key =
-"\xd7\x0c\x4c\x6d\x11\x02\xb0\x31\x63\x9b\x82\x76\x9e\x03\x26\xdf",
-	.klen = 16,
-	.iv =
-"\xc1\x62\x66\x62\xb8\x65\x28\xfa\x5f\x36\xd3\x09\xb1\x2c\xa1\xa3",
-	.input =
-"\x4f\x6c\x63\xa5\xd0\x19\x08\x4e\xd4\x58\x33\xf6\x2b\xeb\x26\xb9",
-	.ilen = 16,
-	.result =
-"\xa0\x35\xb0\x33\xc0\x2e\xe5\xbb\xbc\xe6\x01\x9e\xf4\x67\x11\x14",
-	.rlen = 16,
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ilen	= 64,
+		.result	= "\xf5\x8c\x4c\x04\xd6\xe5\xf1\xba"
+			  "\x77\x9e\xab\xfb\x5f\x7b\xfb\xd6"
+			  "\x9c\xfc\x4e\x96\x7e\xdb\x80\x8d"
+			  "\x67\x9f\x77\x7b\xc6\x70\x2c\x7d"
+			  "\x39\xf2\x33\x69\xa9\xd9\xba\xcf"
+			  "\xa5\x30\xe2\x63\x04\x23\x14\x61"
+			  "\xb2\xeb\x05\xe2\xc3\x9b\xe9\xfc"
+			  "\xda\x6c\x19\x07\x8c\x6a\x9d\x1b",
+		.rlen	= 64,
+},
+{ /* From NIST SP800-38A */
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.input	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ilen	= 64,
+		.result	= "\x4f\x02\x1d\xb2\x43\xbc\x63\x3d"
+			  "\x71\x78\x18\x3a\x9f\xa0\x71\xe8"
+			  "\xb4\xd9\xad\xa9\xad\x7d\xed\xf4"
+			  "\xe5\xe7\x38\x76\x3f\x69\x14\x5a"
+			  "\x57\x1b\x24\x20\x12\xfb\x7a\xe0"
+			  "\x7f\xa9\xba\xac\x3d\xf1\x02\xe0"
+			  "\x08\xb0\xe2\x79\x88\x59\x88\x81"
+			  "\xd9\x20\xa9\xe6\x4f\x56\x15\xcd",
+		.rlen	= 64,
 },
 {
 	.key =
-- 
1.9.1

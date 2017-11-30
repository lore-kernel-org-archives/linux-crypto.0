From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 6/6] crypto: tcrypt: add multibuf aead speed test
Date: Thu, 30 Nov 2017 10:09:32 +0000
Message-ID: <1512036574-26665-7-git-send-email-gilad@benyossef.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The performance of some aead tfm providers is affected by
the amount of parallelism possible with the processing.

Introduce an async aead concurrent multiple buffer
processing speed test to be able to test performance of such
tfm providers.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 432 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 376 insertions(+), 56 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f1417e3..a05648e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -80,6 +80,62 @@ static char *check[] = {
 	NULL
 };
 
+static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
+static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
+
+#define XBUFSIZE 8
+#define MAX_IVLEN 32
+
+static int testmgr_alloc_buf(char *buf[XBUFSIZE])
+{
+	int i;
+
+	for (i = 0; i < XBUFSIZE; i++) {
+		buf[i] = (void *)__get_free_page(GFP_KERNEL);
+		if (!buf[i])
+			goto err_free_buf;
+	}
+
+	return 0;
+
+err_free_buf:
+	while (i-- > 0)
+		free_page((unsigned long)buf[i]);
+
+	return -ENOMEM;
+}
+
+static void testmgr_free_buf(char *buf[XBUFSIZE])
+{
+	int i;
+
+	for (i = 0; i < XBUFSIZE; i++)
+		free_page((unsigned long)buf[i]);
+}
+
+static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
+			unsigned int buflen)
+{
+	int np = (buflen + PAGE_SIZE - 1)/PAGE_SIZE;
+	int k, rem;
+
+	if (np > XBUFSIZE) {
+		rem = PAGE_SIZE;
+		np = XBUFSIZE;
+	} else {
+		rem = buflen % PAGE_SIZE;
+	}
+
+	sg_init_table(sg, np + 1);
+	if (rem)
+		np--;
+	for (k = 0; k < np; k++)
+		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
+
+	if (rem)
+		sg_set_buf(&sg[k + 1], xbuf[k], rem);
+}
+
 static inline int do_one_aead_op(struct aead_request *req, int ret)
 {
 	struct crypto_wait *wait = req->base.data;
@@ -87,6 +143,299 @@ static inline int do_one_aead_op(struct aead_request *req, int ret)
 	return crypto_wait_req(ret, wait);
 }
 
+struct test_mb_aead_data {
+	struct scatterlist sg[XBUFSIZE];
+	struct scatterlist sgout[XBUFSIZE];
+	struct aead_request *req;
+	struct crypto_wait wait;
+	char *xbuf[XBUFSIZE];
+	char *xoutbuf[XBUFSIZE];
+	char *axbuf[XBUFSIZE];
+};
+
+static int do_mult_aead_op(struct test_mb_aead_data *data, int enc,
+				u32 num_mb)
+{
+	int i, rc[num_mb], err = 0;
+
+	/* Fire up a bunch of concurrent requests */
+	for (i = 0; i < num_mb; i++) {
+		if (enc == ENCRYPT)
+			rc[i] = crypto_aead_encrypt(data[i].req);
+		else
+			rc[i] = crypto_aead_decrypt(data[i].req);
+	}
+
+	/* Wait for all requests to finish */
+	for (i = 0; i < num_mb; i++) {
+		rc[i] = crypto_wait_req(rc[i], &data[i].wait);
+
+		if (rc[i]) {
+			pr_info("concurrent request %d error %d\n", i, rc[i]);
+			err = rc[i];
+		}
+	}
+
+	return err;
+}
+
+static int test_mb_aead_jiffies(struct test_mb_aead_data *data, int enc,
+				int blen, int secs, u32 num_mb)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + secs * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		ret = do_mult_aead_op(data, enc, num_mb);
+		if (ret)
+			return ret;
+	}
+
+	pr_cont("%d operations in %d seconds (%ld bytes)\n",
+		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	return 0;
+}
+
+static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
+			       int blen, u32 num_mb)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		ret = do_mult_aead_op(data, enc, num_mb);
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		ret = do_mult_aead_op(data, enc, num_mb);
+		end = get_cycles();
+
+		if (ret)
+			goto out;
+
+		cycles += end - start;
+	}
+
+out:
+	if (ret == 0)
+		pr_cont("1 operation in %lu cycles (%d bytes)\n",
+			(cycles + 4) / (8 * num_mb), blen);
+
+	return ret;
+}
+
+static void test_mb_aead_speed(const char *algo, int enc, int secs,
+			       struct aead_speed_template *template,
+			       unsigned int tcount, u8 authsize,
+			       unsigned int aad_size, u8 *keysize, u32 num_mb)
+{
+	struct test_mb_aead_data *data;
+	struct crypto_aead *tfm;
+	unsigned int i, j, iv_len;
+	const char *key;
+	const char *e;
+	void *assoc;
+	u32 *b_size;
+	char *iv;
+	int ret;
+
+
+	if (aad_size >= PAGE_SIZE) {
+		pr_err("associate data length (%u) too big\n", aad_size);
+		return;
+	}
+
+	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
+	if (!iv)
+		return;
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	data = kcalloc(num_mb, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto out_free_iv;
+
+	tfm = crypto_alloc_aead(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n",
+			algo, PTR_ERR(tfm));
+		goto out_free_data;
+	}
+
+	ret = crypto_aead_setauthsize(tfm, authsize);
+
+	for (i = 0; i < num_mb; ++i)
+		if (testmgr_alloc_buf(data[i].xbuf)) {
+			while (i--)
+				testmgr_free_buf(data[i].xbuf);
+			goto out_free_tfm;
+		}
+
+	for (i = 0; i < num_mb; ++i)
+		if (testmgr_alloc_buf(data[i].axbuf)) {
+			while (i--)
+				testmgr_free_buf(data[i].axbuf);
+			goto out_free_xbuf;
+		}
+
+	for (i = 0; i < num_mb; ++i)
+		if (testmgr_alloc_buf(data[i].xoutbuf)) {
+			while (i--)
+				testmgr_free_buf(data[i].axbuf);
+			goto out_free_axbuf;
+		}
+
+	for (i = 0; i < num_mb; ++i) {
+		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
+		if (!data[i].req) {
+			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			       algo);
+			while (i--)
+				aead_request_free(data[i].req);
+			goto out_free_xoutbuf;
+		}
+	}
+
+	for (i = 0; i < num_mb; ++i) {
+		crypto_init_wait(&data[i].wait);
+		aead_request_set_callback(data[i].req,
+					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  crypto_req_done, &data[i].wait);
+	}
+
+	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+		get_driver_name(crypto_aead, tfm), e);
+
+	i = 0;
+	do {
+		b_size = aead_sizes;
+		do {
+			if (*b_size + authsize > XBUFSIZE * PAGE_SIZE) {
+				pr_err("template (%u) too big for bufufer (%lu)\n",
+				       authsize + *b_size,
+				       XBUFSIZE * PAGE_SIZE);
+				goto out;
+			}
+
+			pr_info("test %u (%d bit key, %d byte blocks): ", i,
+				*keysize * 8, *b_size);
+
+			/* Set up tfm global state, i.e. the key */
+
+			memset(tvmem[0], 0xff, PAGE_SIZE);
+			key = tvmem[0];
+			for (j = 0; j < tcount; j++) {
+				if (template[j].klen == *keysize) {
+					key = template[j].key;
+					break;
+				}
+			}
+
+			crypto_aead_clear_flags(tfm, ~0);
+
+			ret = crypto_aead_setkey(tfm, key, *keysize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x\n",
+				       crypto_aead_get_flags(tfm));
+				goto out;
+			}
+
+			iv_len = crypto_aead_ivsize(tfm);
+			if (iv_len)
+				memset(iv, 0xff, iv_len);
+
+			/* Now setup per request stuff, i.e. buffers */
+
+			for (j = 0; j < num_mb; ++j) {
+				struct test_mb_aead_data *cur = &data[j];
+
+				assoc = cur->axbuf[0];
+				memset(assoc, 0xff, aad_size);
+
+				sg_init_aead(cur->sg, cur->xbuf,
+					     *b_size + (enc ? 0 : authsize));
+
+				sg_init_aead(cur->sgout, cur->xoutbuf,
+					     *b_size + (enc ? authsize : 0));
+
+				sg_set_buf(cur->sg, assoc, aad_size);
+				sg_set_buf(cur->sgout, assoc, aad_size);
+
+				aead_request_set_ad(cur->req, aad_size);
+
+				if (!enc) {
+
+					aead_request_set_crypt(cur->req,
+							       cur->sgout,
+							       cur->sg,
+							       *b_size, iv);
+					ret = crypto_aead_encrypt(cur->req);
+					ret = do_one_aead_op(cur->req, ret);
+
+					if (ret) {
+						pr_err("calculating auth failed failed (%d)\n",
+						       ret);
+						break;
+					}
+				}
+
+				aead_request_set_crypt(cur->req, cur->sg,
+						       cur->sgout, *b_size +
+						       (enc ? 0 : authsize),
+						       iv);
+
+			}
+
+			if (secs)
+				ret = test_mb_aead_jiffies(data, enc, *b_size,
+							   secs, num_mb);
+			else
+				ret = test_mb_aead_cycles(data, enc, *b_size,
+							  num_mb);
+
+			if (ret) {
+				pr_err("%s() failed return code=%d\n", e, ret);
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
+
+out:
+	for (i = 0; i < num_mb; ++i)
+		aead_request_free(data[i].req);
+out_free_xoutbuf:
+	for (i = 0; i < num_mb; ++i)
+		testmgr_free_buf(data[i].xoutbuf);
+out_free_axbuf:
+	for (i = 0; i < num_mb; ++i)
+		testmgr_free_buf(data[i].axbuf);
+out_free_xbuf:
+	for (i = 0; i < num_mb; ++i)
+		testmgr_free_buf(data[i].xbuf);
+out_free_tfm:
+	crypto_free_aead(tfm);
+out_free_data:
+	kfree(data);
+out_free_iv:
+	kfree(iv);
+}
+
 static int test_aead_jiffies(struct aead_request *req, int enc,
 				int blen, int secs)
 {
@@ -152,62 +501,6 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 	return ret;
 }
 
-static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
-static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
-
-#define XBUFSIZE 8
-#define MAX_IVLEN 32
-
-static int testmgr_alloc_buf(char *buf[XBUFSIZE])
-{
-	int i;
-
-	for (i = 0; i < XBUFSIZE; i++) {
-		buf[i] = (void *)__get_free_page(GFP_KERNEL);
-		if (!buf[i])
-			goto err_free_buf;
-	}
-
-	return 0;
-
-err_free_buf:
-	while (i-- > 0)
-		free_page((unsigned long)buf[i]);
-
-	return -ENOMEM;
-}
-
-static void testmgr_free_buf(char *buf[XBUFSIZE])
-{
-	int i;
-
-	for (i = 0; i < XBUFSIZE; i++)
-		free_page((unsigned long)buf[i]);
-}
-
-static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
-			unsigned int buflen)
-{
-	int np = (buflen + PAGE_SIZE - 1)/PAGE_SIZE;
-	int k, rem;
-
-	if (np > XBUFSIZE) {
-		rem = PAGE_SIZE;
-		np = XBUFSIZE;
-	} else {
-		rem = buflen % PAGE_SIZE;
-	}
-
-	sg_init_table(sg, np + 1);
-	if (rem)
-		np--;
-	for (k = 0; k < np; k++)
-		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
-
-	if (rem)
-		sg_set_buf(&sg[k + 1], xbuf[k], rem);
-}
-
 static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			    struct aead_speed_template *template,
 			    unsigned int tcount, u8 authsize,
@@ -1910,6 +2203,33 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				  speed_template_32);
 		break;
 
+	case 215:
+		test_mb_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec, NULL,
+				   0, 16, 16, aead_speed_template_20, num_mb);
+		test_mb_aead_speed("gcm(aes)", ENCRYPT, sec, NULL, 0, 16, 8,
+				   speed_template_16_24_32, num_mb);
+		test_mb_aead_speed("rfc4106(gcm(aes))", DECRYPT, sec, NULL,
+				   0, 16, 16, aead_speed_template_20, num_mb);
+		test_mb_aead_speed("gcm(aes)", DECRYPT, sec, NULL, 0, 16, 8,
+				   speed_template_16_24_32, num_mb);
+		break;
+
+	case 216:
+		test_mb_aead_speed("rfc4309(ccm(aes))", ENCRYPT, sec, NULL, 0,
+				   16, 16, aead_speed_template_19, num_mb);
+		test_mb_aead_speed("rfc4309(ccm(aes))", DECRYPT, sec, NULL, 0,
+				   16, 16, aead_speed_template_19, num_mb);
+		break;
+
+	case 217:
+		test_mb_aead_speed("rfc7539esp(chacha20,poly1305)", ENCRYPT,
+				   sec, NULL, 0, 16, 8, aead_speed_template_36,
+				   num_mb);
+		test_mb_aead_speed("rfc7539esp(chacha20,poly1305)", DECRYPT,
+				   sec, NULL, 0, 16, 8, aead_speed_template_36,
+				   num_mb);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
-- 
2.7.4

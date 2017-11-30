From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 5/6] crypto: tcrypt: add multibuf skcipher speed test
Date: Thu, 30 Nov 2017 10:09:31 +0000
Message-ID: <1512036574-26665-6-git-send-email-gilad@benyossef.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The performance of some skcipher tfm providers is affected by
the amount of parallelism possible with the processing.

Introduce an async skcipher concurrent multiple buffer
processing speed test to be able to test performance of such
tfm providers.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/tcrypt.c | 460 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 460 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index cf9b44f..f1417e3 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -816,6 +816,254 @@ static void test_hash_speed(const char *algo, unsigned int secs,
 	return test_ahash_speed_common(algo, secs, speed, CRYPTO_ALG_ASYNC);
 }
 
+struct test_mb_skcipher_data {
+	struct scatterlist sg[XBUFSIZE];
+	struct skcipher_request *req;
+	struct crypto_wait wait;
+	char *xbuf[XBUFSIZE];
+};
+
+static int do_mult_acipher_op(struct test_mb_skcipher_data *data, int enc,
+				u32 num_mb)
+{
+	int i, rc[num_mb], err = 0;
+
+	/* Fire up a bunch of concurrent requests */
+	for (i = 0; i < num_mb; i++) {
+		if (enc == ENCRYPT)
+			rc[i] = crypto_skcipher_encrypt(data[i].req);
+		else
+			rc[i] = crypto_skcipher_decrypt(data[i].req);
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
+static int test_mb_acipher_jiffies(struct test_mb_skcipher_data *data, int enc,
+				int blen, int secs, u32 num_mb)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + secs * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		ret = do_mult_acipher_op(data, enc, num_mb);
+		if (ret)
+			return ret;
+	}
+
+	pr_cont("%d operations in %d seconds (%ld bytes)\n",
+		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	return 0;
+}
+
+static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
+			       int blen, u32 num_mb)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		ret = do_mult_acipher_op(data, enc, num_mb);
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		ret = do_mult_acipher_op(data, enc, num_mb);
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
+static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
+				   struct cipher_speed_template *template,
+				   unsigned int tcount, u8 *keysize, u32 num_mb)
+{
+	struct test_mb_skcipher_data *data;
+	struct crypto_skcipher *tfm;
+	unsigned int i, j, iv_len;
+	const char *key;
+	const char *e;
+	u32 *b_size;
+	char iv[128];
+	int ret;
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	data = kcalloc(num_mb, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	tfm = crypto_alloc_skcipher(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n",
+			algo, PTR_ERR(tfm));
+		goto out_free_data;
+	}
+
+	for (i = 0; i < num_mb; ++i)
+		if (testmgr_alloc_buf(data[i].xbuf)) {
+			while (i--)
+				testmgr_free_buf(data[i].xbuf);
+			goto out_free_tfm;
+		}
+
+
+	for (i = 0; i < num_mb; ++i)
+		if (testmgr_alloc_buf(data[i].xbuf)) {
+			while (i--)
+				testmgr_free_buf(data[i].xbuf);
+			goto out_free_tfm;
+		}
+
+
+	for (i = 0; i < num_mb; ++i) {
+		data[i].req = skcipher_request_alloc(tfm, GFP_KERNEL);
+		if (!data[i].req) {
+			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			       algo);
+			while (i--)
+				skcipher_request_free(data[i].req);
+			goto out_free_xbuf;
+		}
+	}
+
+	for (i = 0; i < num_mb; ++i) {
+		skcipher_request_set_callback(data[i].req,
+					      CRYPTO_TFM_REQ_MAY_BACKLOG,
+					      crypto_req_done, &data[i].wait);
+		crypto_init_wait(&data[i].wait);
+	}
+
+	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+		get_driver_name(crypto_skcipher, tfm), e);
+
+	i = 0;
+	do {
+		b_size = block_sizes;
+		do {
+			if (*b_size > XBUFSIZE * PAGE_SIZE) {
+				pr_err("template (%u) too big for bufufer (%lu)\n",
+				       *b_size, XBUFSIZE * PAGE_SIZE);
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
+			crypto_skcipher_clear_flags(tfm, ~0);
+
+			ret = crypto_skcipher_setkey(tfm, key, *keysize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x\n",
+				       crypto_skcipher_get_flags(tfm));
+				goto out;
+			}
+
+			iv_len = crypto_skcipher_ivsize(tfm);
+			if (iv_len)
+				memset(&iv, 0xff, iv_len);
+
+			/* Now setup per request stuff, i.e. buffers */
+
+			for (j = 0; j < num_mb; ++j) {
+				struct test_mb_skcipher_data *cur = &data[j];
+				unsigned int k = *b_size;
+				unsigned int pages = DIV_ROUND_UP(k, PAGE_SIZE);
+				unsigned int p = 0;
+
+				sg_init_table(cur->sg, pages);
+
+				while (k > PAGE_SIZE) {
+					sg_set_buf(cur->sg + p, cur->xbuf[p],
+						   PAGE_SIZE);
+					memset(cur->xbuf[p], 0xff, PAGE_SIZE);
+					p++;
+					k -= PAGE_SIZE;
+				}
+
+				sg_set_buf(cur->sg + p, cur->xbuf[p], k);
+				memset(cur->xbuf[p], 0xff, k);
+
+				skcipher_request_set_crypt(cur->req, cur->sg,
+							   cur->sg, *b_size,
+							   iv);
+			}
+
+			if (secs)
+				ret = test_mb_acipher_jiffies(data, enc,
+							      *b_size, secs,
+							      num_mb);
+			else
+				ret = test_mb_acipher_cycles(data, enc,
+							     *b_size, num_mb);
+
+			if (ret) {
+				pr_err("%s() failed flags=%x\n", e,
+				       crypto_skcipher_get_flags(tfm));
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
+		skcipher_request_free(data[i].req);
+out_free_xbuf:
+	for (i = 0; i < num_mb; ++i)
+		testmgr_free_buf(data[i].xbuf);
+out_free_tfm:
+	crypto_free_skcipher(tfm);
+out_free_data:
+	kfree(data);
+}
+
 static inline int do_one_acipher_op(struct skcipher_request *req, int ret)
 {
 	struct crypto_wait *wait = req->base.data;
@@ -2100,6 +2348,218 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				   speed_template_8_32);
 		break;
 
+	case 600:
+		test_mb_skcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_40_48, num_mb);
+		test_mb_skcipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_40_48, num_mb);
+		test_mb_skcipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		test_mb_skcipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		test_mb_skcipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ofb(aes)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ofb(aes)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("rfc3686(ctr(aes))", ENCRYPT, sec, NULL,
+				       0, speed_template_20_28_36, num_mb);
+		test_mb_skcipher_speed("rfc3686(ctr(aes))", DECRYPT, sec, NULL,
+				       0, speed_template_20_28_36, num_mb);
+		break;
+
+	case 601:
+		test_mb_skcipher_speed("ecb(des3_ede)", ENCRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("ecb(des3_ede)", DECRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("cbc(des3_ede)", ENCRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("cbc(des3_ede)", DECRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("cfb(des3_ede)", ENCRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("cfb(des3_ede)", DECRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("ofb(des3_ede)", ENCRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		test_mb_skcipher_speed("ofb(des3_ede)", DECRYPT, sec,
+				       des3_speed_template, DES3_SPEED_VECTORS,
+				       speed_template_24, num_mb);
+		break;
+
+	case 602:
+		test_mb_skcipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("cfb(des)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("cfb(des)", DECRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("ofb(des)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		test_mb_skcipher_speed("ofb(des)", DECRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		break;
+
+	case 603:
+		test_mb_skcipher_speed("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ecb(serpent)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("cbc(serpent)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_48, num_mb);
+		test_mb_skcipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_48, num_mb);
+		test_mb_skcipher_speed("xts(serpent)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		test_mb_skcipher_speed("xts(serpent)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		break;
+
+	case 604:
+		test_mb_skcipher_speed("ecb(twofish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ecb(twofish)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cbc(twofish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_24_32, num_mb);
+		test_mb_skcipher_speed("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_40_48, num_mb);
+		test_mb_skcipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_40_48, num_mb);
+		test_mb_skcipher_speed("xts(twofish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_48_64, num_mb);
+		test_mb_skcipher_speed("xts(twofish)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_48_64, num_mb);
+		break;
+
+	case 605:
+		test_mb_skcipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8, num_mb);
+		break;
+
+	case 606:
+		test_mb_skcipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8_16, num_mb);
+		test_mb_skcipher_speed("ecb(cast5)", DECRYPT, sec, NULL, 0,
+				       speed_template_8_16, num_mb);
+		test_mb_skcipher_speed("cbc(cast5)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8_16, num_mb);
+		test_mb_skcipher_speed("cbc(cast5)", DECRYPT, sec, NULL, 0,
+				       speed_template_8_16, num_mb);
+		test_mb_skcipher_speed("ctr(cast5)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8_16, num_mb);
+		test_mb_skcipher_speed("ctr(cast5)", DECRYPT, sec, NULL, 0,
+				       speed_template_8_16, num_mb);
+		break;
+
+	case 607:
+		test_mb_skcipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("cbc(cast6)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("cbc(cast6)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(cast6)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(cast6)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("lrw(cast6)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_48, num_mb);
+		test_mb_skcipher_speed("lrw(cast6)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_48, num_mb);
+		test_mb_skcipher_speed("xts(cast6)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		test_mb_skcipher_speed("xts(cast6)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		break;
+
+	case 608:
+		test_mb_skcipher_speed("ecb(camellia)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ecb(camellia)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("cbc(camellia)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(camellia)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_48, num_mb);
+		test_mb_skcipher_speed("lrw(camellia)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_48, num_mb);
+		test_mb_skcipher_speed("xts(camellia)", ENCRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		test_mb_skcipher_speed("xts(camellia)", DECRYPT, sec, NULL, 0,
+				       speed_template_32_64, num_mb);
+		break;
+
+	case 609:
+		test_mb_skcipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8_32, num_mb);
+		test_mb_skcipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+				       speed_template_8_32, num_mb);
+		test_mb_skcipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8_32, num_mb);
+		test_mb_skcipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+				       speed_template_8_32, num_mb);
+		test_mb_skcipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+				       speed_template_8_32, num_mb);
+		test_mb_skcipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+				       speed_template_8_32, num_mb);
+		break;
+
 	case 1000:
 		test_available();
 		break;
-- 
2.7.4

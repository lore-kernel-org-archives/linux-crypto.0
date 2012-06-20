From: Arun Murthy <arun.murthy@stericsson.com>
Subject: [PATCH] crypto: tcrypt - Add mode 500 for ablkcipher test
Date: Wed, 20 Jun 2012 16:41:44 +0530
Message-ID: <1340190704-6445-1-git-send-email-arun.murthy@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <arun.murthy@stericsson.com>,
	Berne Hebark <berne.hebark@stericsson.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:44967 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab2FTLM3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jun 2012 07:12:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The existing mode 200 performs ecb(aes), cbc(aes), ctr(aes), ecb(des), cbc(des)
ecb(des3_ede), cbc(des3_ede) for synchronous block cihper. For crypto hardware
drivers ablkcipher's are used and hence add new mode 500 and its variants to
perform the tests in asynchronous block cipher.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Signed-off-by: Berne Hebark <berne.hebark@stericsson.com>
Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 crypto/tcrypt.c |  265 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 249 insertions(+), 16 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2222617..75f0747 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -67,6 +67,87 @@ static char *check[] = {
 	"lzo", "cts", "zlib", NULL
 };
 
+struct tcrypt_result {
+	struct completion completion;
+	int err;
+};
+
+static int test_ablkcipher_jiffies(struct ablkcipher_request *req, int enc,
+			       int blen, int sec)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + sec * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		if (enc)
+			ret = crypto_ablkcipher_encrypt(req);
+		else
+			ret = crypto_ablkcipher_decrypt(req);
+
+		if (ret) {
+			printk("\n [test_cipher_jiffies] "
+				"crypto_ablkcipher_encrypt/decrypt: enc: %d, "
+				"ret = %x \n", enc, ret);
+			return ret;
+		}
+	}
+
+	printk("%d operations in %d seconds (%ld bytes)\n",
+	       bcount, sec, (long)bcount * blen);
+	return 0;
+}
+
+static int test_ablkcipher_cycles(struct ablkcipher_request *req,
+			      int enc, int blen)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	local_bh_disable();
+	local_irq_disable();
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		if (enc)
+			ret = crypto_ablkcipher_encrypt(req);
+		else
+			ret = crypto_ablkcipher_decrypt(req);
+
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		if (enc)
+			ret = crypto_ablkcipher_encrypt(req);
+		else
+			ret = crypto_ablkcipher_decrypt(req);
+		end = get_cycles();
+
+		if (ret)
+			goto out;
+
+		cycles += end - start;
+	}
+
+out:
+	local_irq_enable();
+	local_bh_enable();
+
+	if (ret == 0)
+		printk("1 operation in %lu cycles (%d bytes)\n",
+		       (cycles + 4) / 8, blen);
+
+	return ret;
+}
+
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
 			       struct scatterlist *sg, int blen, int sec)
 {
@@ -139,8 +220,130 @@ out:
 	return ret;
 }
 
+static u32 ablock_sizes[] = { 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 24576, 0 };
 static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
 
+static void tcrypt_complete(struct crypto_async_request *req, int err)
+{
+	struct tcrypt_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+static void test_ablkcipher_speed(const char *algo, int enc, unsigned int sec,
+				struct cipher_speed_template *template,
+				unsigned int tcount, u8 *keysize)
+{
+	unsigned int ret, i, j, iv_len;
+	const char *key;
+	char iv[128];
+	const char *e;
+	u32 *b_size;
+	struct tcrypt_result result;
+	struct crypto_ablkcipher *tfm;
+	struct ablkcipher_request *req;
+
+	if (enc == ENCRYPT)
+	        e = "encryption";
+	else
+		e = "decryption";
+
+	printk("\ntesting speed of %s %s\n", algo, e);
+	init_completion(&result.completion);
+
+	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		printk("failed to load transform for %s: %ld\n", algo,
+		       PTR_ERR(tfm));
+		return;
+	}
+	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_ERR "alg: cipher_speed: Failed to allocate request "
+		       "for %s\n", algo);
+		return;
+	}
+
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					tcrypt_complete, &result);
+
+	i = 0;
+	do {
+
+		b_size = ablock_sizes;
+		do {
+			struct scatterlist sg[TVMEMSIZE];
+
+			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+				printk("template (%u) too big for "
+				       "tvmem (%lu)\n", *keysize + *b_size,
+				       TVMEMSIZE * PAGE_SIZE);
+				goto out;
+			}
+
+			printk("test %u (%d bit key, %d byte blocks): ", i,
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
+			ret = crypto_ablkcipher_setkey(tfm, key, *keysize);
+			if (ret) {
+				printk("setkey() failed flags=%x\n",
+						crypto_ablkcipher_get_flags(tfm));
+				goto out;
+			}
+
+			sg_init_table(sg, TVMEMSIZE);
+			sg_set_buf(sg, tvmem[0] + *keysize,
+				   (PAGE_SIZE - *keysize) -
+				   ((PAGE_SIZE - *keysize)) % 16);
+			for (j = 1; j < TVMEMSIZE; j++) {
+				sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
+				memset (tvmem[j], 0xff, PAGE_SIZE);
+			}
+
+			iv_len = crypto_ablkcipher_ivsize(tfm);
+			if (iv_len) {
+				memset(&iv, 0xff, iv_len);
+			}
+			ablkcipher_request_set_crypt(req, sg, sg,
+						     *b_size, iv);
+
+			if (sec)
+				ret = test_ablkcipher_jiffies(req, enc,
+							  *b_size, sec);
+			else
+				ret = test_ablkcipher_cycles(req, enc,
+							 *b_size);
+
+			if (ret) {
+				printk("%s() failed flags=%x\n", e,
+					crypto_ablkcipher_get_flags(tfm));
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
+
+out:
+	ablkcipher_request_free(req);
+	crypto_free_ablkcipher(tfm);
+}
+
 static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 			      struct cipher_speed_template *template,
 			      unsigned int tcount, u8 *keysize)
@@ -475,22 +678,6 @@ out:
 	crypto_free_hash(tfm);
 }
 
-struct tcrypt_result {
-	struct completion completion;
-	int err;
-};
-
-static void tcrypt_complete(struct crypto_async_request *req, int err)
-{
-	struct tcrypt_result *res = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	res->err = err;
-	complete(&res->completion);
-}
-
 static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
@@ -1230,7 +1417,53 @@ static int do_test(int m)
 
 	case 499:
 		break;
+	case 500:
+		test_ablkcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_ablkcipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_ablkcipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_ablkcipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_ablkcipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_32_40_48);
+		test_ablkcipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_32_40_48);
+		test_ablkcipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_32_48_64);
+		test_ablkcipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_32_48_64);
+		test_ablkcipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		test_ablkcipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+				speed_template_16_24_32);
+		break;
+	case 501:
+		test_ablkcipher_speed("ecb(des3_ede)", ENCRYPT, sec,
+				des3_speed_template, DES3_SPEED_VECTORS,
+				speed_template_24);
+		test_ablkcipher_speed("ecb(des3_ede)", DECRYPT, sec,
+				des3_speed_template, DES3_SPEED_VECTORS,
+				speed_template_24);
+		test_ablkcipher_speed("cbc(des3_ede)", ENCRYPT, sec,
+				des3_speed_template, DES3_SPEED_VECTORS,
+				speed_template_24);
+		test_ablkcipher_speed("cbc(des3_ede)", DECRYPT, sec,
+				des3_speed_template, DES3_SPEED_VECTORS,
+				speed_template_24);
+		break;
 
+	case 504:
+		test_ablkcipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
+				  speed_template_8);
+		test_ablkcipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
+				  speed_template_8);
+		test_ablkcipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
+				  speed_template_8);
+		test_ablkcipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
+				  speed_template_8);
+		break;
 	case 1000:
 		test_available();
 		break;
-- 
1.7.4.3

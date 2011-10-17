From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/7] crypto: tcrypt: add test_acipher_speed
Date: Tue, 18 Oct 2011 00:02:58 +0300
Message-ID: <20111017210258.13543.18191.stgit@localhost6.localdomain6>
References: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37694 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1JQVDA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 17:03:00 -0400
In-Reply-To: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add test_acipher_speed for testing async block ciphers.

Also include tests for aes/des/des3/ede as these appear to have ablk_cipher
implementations available.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |  250 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 250 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ac9e4d2..dd3a0f8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -719,6 +719,207 @@ out:
 	crypto_free_ahash(tfm);
 }
 
+static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
+{
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		struct tcrypt_result *tr = req->base.data;
+
+		ret = wait_for_completion_interruptible(&tr->completion);
+		if (!ret)
+			ret = tr->err;
+		INIT_COMPLETION(tr->completion);
+	}
+
+	return ret;
+}
+
+static int test_acipher_jiffies(struct ablkcipher_request *req, int enc,
+				int blen, int sec)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + sec * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		if (enc)
+			ret = do_one_acipher_op(req,
+						crypto_ablkcipher_encrypt(req));
+		else
+			ret = do_one_acipher_op(req,
+						crypto_ablkcipher_decrypt(req));
+
+		if (ret)
+			return ret;
+	}
+
+	pr_cont("%d operations in %d seconds (%ld bytes)\n",
+		bcount, sec, (long)bcount * blen);
+	return 0;
+}
+
+static int test_acipher_cycles(struct ablkcipher_request *req, int enc,
+			       int blen)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		if (enc)
+			ret = do_one_acipher_op(req,
+						crypto_ablkcipher_encrypt(req));
+		else
+			ret = do_one_acipher_op(req,
+						crypto_ablkcipher_decrypt(req));
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
+			ret = do_one_acipher_op(req,
+						crypto_ablkcipher_encrypt(req));
+		else
+			ret = do_one_acipher_op(req,
+						crypto_ablkcipher_decrypt(req));
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
+			(cycles + 4) / 8, blen);
+
+	return ret;
+}
+
+static void test_acipher_speed(const char *algo, int enc, unsigned int sec,
+			       struct cipher_speed_template *template,
+			       unsigned int tcount, u8 *keysize)
+{
+	unsigned int ret, i, j, iv_len;
+	struct tcrypt_result tresult;
+	const char *key;
+	char iv[128];
+	struct ablkcipher_request *req;
+	struct crypto_ablkcipher *tfm;
+	const char *e;
+	u32 *b_size;
+
+	if (enc == ENCRYPT)
+		e = "encryption";
+	else
+		e = "decryption";
+
+	pr_info("\ntesting speed of async %s %s\n", algo, e);
+
+	init_completion(&tresult.completion);
+
+	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n", algo,
+		       PTR_ERR(tfm));
+		return;
+	}
+
+	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
+		       algo);
+		goto out;
+	}
+
+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					tcrypt_complete, &tresult);
+
+	i = 0;
+	do {
+		b_size = block_sizes;
+
+		do {
+			struct scatterlist sg[TVMEMSIZE];
+
+			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
+				pr_err("template (%u) too big for "
+				       "tvmem (%lu)\n", *keysize + *b_size,
+				       TVMEMSIZE * PAGE_SIZE);
+				goto out_free_req;
+			}
+
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
+			crypto_ablkcipher_clear_flags(tfm, ~0);
+
+			ret = crypto_ablkcipher_setkey(tfm, key, *keysize);
+			if (ret) {
+				pr_err("setkey() failed flags=%x\n",
+					crypto_ablkcipher_get_flags(tfm));
+				goto out_free_req;
+			}
+
+			sg_init_table(sg, TVMEMSIZE);
+			sg_set_buf(sg, tvmem[0] + *keysize,
+				   PAGE_SIZE - *keysize);
+			for (j = 1; j < TVMEMSIZE; j++) {
+				sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
+				memset(tvmem[j], 0xff, PAGE_SIZE);
+			}
+
+			iv_len = crypto_ablkcipher_ivsize(tfm);
+			if (iv_len)
+				memset(&iv, 0xff, iv_len);
+
+			ablkcipher_request_set_crypt(req, sg, sg, *b_size, iv);
+
+			if (sec)
+				ret = test_acipher_jiffies(req, enc,
+							   *b_size, sec);
+			else
+				ret = test_acipher_cycles(req, enc,
+							  *b_size);
+
+			if (ret) {
+				pr_err("%s() failed flags=%x\n", e,
+					crypto_ablkcipher_get_flags(tfm));
+				break;
+			}
+			b_size++;
+			i++;
+		} while (*b_size);
+		keysize++;
+	} while (*keysize);
+
+out_free_req:
+	ablkcipher_request_free(req);
+out:
+	crypto_free_ablkcipher(tfm);
+}
+
 static void test_available(void)
 {
 	char **name = check;
@@ -1243,6 +1444,55 @@ static int do_test(int m)
 	case 499:
 		break;
 
+	case 500:
+		test_acipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		test_acipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_40_48);
+		test_acipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48_64);
+		test_acipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48_64);
+		test_acipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		break;
+
+	case 501:
+		test_acipher_speed("ecb(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		test_acipher_speed("ecb(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		test_acipher_speed("cbc(des3_ede)", ENCRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		test_acipher_speed("cbc(des3_ede)", DECRYPT, sec,
+				   des3_speed_template, DES3_SPEED_VECTORS,
+				   speed_template_24);
+		break;
+
+	case 502:
+		test_acipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		test_acipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		test_acipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
+				   speed_template_8);
+		test_acipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
+				   speed_template_8);
+		break;
+
 	case 1000:
 		test_available();
 		break;

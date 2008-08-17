From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: cryptomgr - Test ciphers using ECB
Date: Sun, 17 Aug 2008 22:27:59 +1000
Message-ID: <20080817122759.GA26253@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44679 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbYHQM2C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2008 08:28:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KUhMV-0005JC-K5
	for <linux-crypto@vger.kernel.org>; Sun, 17 Aug 2008 22:27:59 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KUhMV-0006uz-00
	for <linux-crypto@vger.kernel.org>; Sun, 17 Aug 2008 22:27:59 +1000
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

The newly added tcrypt infrastructure didn't help the simple cipher
users since we only test skcipher transforms.  Most notably this
would mean that ansi_cprng would get an untested cipher as its
engine which is unacceptable.  So here's a patch to fix that.

commit 413ffa5070e6c3c26e9c5cb59037ed417ec2e045
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Aug 17 17:01:56 2008 +1000

    crypto: cryptomgr - Test ciphers using ECB
    
    As it is we only test ciphers when combined with a mode.  That means
    users that do not invoke a mode of operations may get an untested
    cipher.
    
    This patch tests all ciphers using the ECB mode so that simple cipher
    users such as ansi-cprng are also protected.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algboss.c b/crypto/algboss.c
index b36f1b1..a635784 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -205,10 +205,7 @@ static int cryptomgr_test(void *data)
 	      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV))
 		goto skiptest;
 
-	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER)
-		goto skiptest;
-
-	err = alg_test(param->driver, param->alg, 0, CRYPTO_ALG_TESTED);
+	err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
 
 skiptest:
 	crypto_alg_tested(param->driver, err);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f34f798..9b5c1d9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -540,9 +540,74 @@ out:
 	return ret;
 }
 
-static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
+static int test_cipher(struct crypto_cipher *tfm, int enc,
 		       struct cipher_testvec *template, unsigned int tcount)
 {
+	const char *algo = crypto_tfm_alg_driver_name(crypto_cipher_tfm(tfm));
+	unsigned int i, j, k;
+	int ret;
+	char *q;
+	const char *e;
+	void *data;
+
+	if (enc == ENCRYPT)
+	        e = "encryption";
+	else
+		e = "decryption";
+
+	j = 0;
+	for (i = 0; i < tcount; i++) {
+		if (template[i].np)
+			continue;
+
+		j++;
+
+		data = xbuf[0];
+		memcpy(data, template[i].input, template[i].ilen);
+
+		crypto_cipher_clear_flags(tfm, ~0);
+		if (template[i].wk)
+			crypto_cipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+
+		ret = crypto_cipher_setkey(tfm, template[i].key,
+					   template[i].klen);
+		if (!ret == template[i].fail) {
+			printk(KERN_ERR "alg: cipher: setkey failed "
+			       "on test %d for %s: flags=%x\n", j,
+			       algo, crypto_cipher_get_flags(tfm));
+			goto out;
+		} else if (ret)
+			continue;
+
+		for (k = 0; k < template[i].ilen;
+		     k += crypto_cipher_blocksize(tfm)) {
+			if (enc)
+				crypto_cipher_encrypt_one(tfm, data + k,
+							  data + k);
+			else
+				crypto_cipher_decrypt_one(tfm, data + k,
+							  data + k);
+		}
+
+		q = data;
+		if (memcmp(q, template[i].result, template[i].rlen)) {
+			printk(KERN_ERR "alg: cipher: Test %d failed "
+			       "on %s for %s\n", j, e, algo);
+			hexdump(q, template[i].rlen);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
+			 struct cipher_testvec *template, unsigned int tcount)
+{
 	const char *algo =
 		crypto_tfm_alg_driver_name(crypto_ablkcipher_tfm(tfm));
 	unsigned int i, j, k, n, temp;
@@ -564,8 +629,8 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 
 	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		printk(KERN_ERR "alg: cipher: Failed to allocate request for "
-		       "%s\n", algo);
+		printk(KERN_ERR "alg: skcipher: Failed to allocate request "
+		       "for %s\n", algo);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -594,7 +659,7 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: cipher: setkey failed "
+				printk(KERN_ERR "alg: skcipher: setkey failed "
 				       "on test %d for %s: flags=%x\n", j,
 				       algo, crypto_ablkcipher_get_flags(tfm));
 				goto out;
@@ -622,7 +687,7 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: cipher: %s failed on "
+				printk(KERN_ERR "alg: skcipher: %s failed on "
 				       "test %d for %s: ret=%d\n", e, j, algo,
 				       -ret);
 				goto out;
@@ -630,8 +695,8 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 
 			q = data;
 			if (memcmp(q, template[i].result, template[i].rlen)) {
-				printk(KERN_ERR "alg: cipher: Test %d failed "
-				       "on %s for %s\n", j, e, algo);
+				printk(KERN_ERR "alg: skcipher: Test %d "
+				       "failed on %s for %s\n", j, e, algo);
 				hexdump(q, template[i].rlen);
 				ret = -EINVAL;
 				goto out;
@@ -658,7 +723,7 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: cipher: setkey failed "
+				printk(KERN_ERR "alg: skcipher: setkey failed "
 				       "on chunk test %d for %s: flags=%x\n",
 				       j, algo,
 				       crypto_ablkcipher_get_flags(tfm));
@@ -709,7 +774,7 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: cipher: %s failed on "
+				printk(KERN_ERR "alg: skcipher: %s failed on "
 				       "chunk test %d for %s: ret=%d\n", e, j,
 				       algo, -ret);
 				goto out;
@@ -723,7 +788,7 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 
 				if (memcmp(q, template[i].result + temp,
 					   template[i].tap[k])) {
-					printk(KERN_ERR "alg: cipher: Chunk "
+					printk(KERN_ERR "alg: skcipher: Chunk "
 					       "test %d failed on %s at page "
 					       "%u for %s\n", j, e, k, algo);
 					hexdump(q, template[i].tap[k]);
@@ -734,7 +799,7 @@ static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 				for (n = 0; offset_in_page(q + n) && q[n]; n++)
 					;
 				if (n) {
-					printk("alg: cipher: Result buffer "
+					printk("alg: skcipher: Result buffer "
 					       "corruption in chunk test %d "
 					       "on %s at page %u for %s: %u "
 					       "bytes:\n", j, e, k, algo, n);
@@ -847,10 +912,10 @@ out:
 static int alg_test_cipher(const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
 {
-	struct crypto_ablkcipher *tfm;
+	struct crypto_cipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_ablkcipher(driver, type, mask);
+	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -869,6 +934,35 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 				  desc->suite.cipher.dec.count);
 
 out:
+	crypto_free_cipher(tfm);
+	return err;
+}
+
+static int alg_test_skcipher(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	struct crypto_ablkcipher *tfm;
+	int err = 0;
+
+	tfm = crypto_alloc_ablkcipher(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
+		       "%s: %ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	if (desc->suite.cipher.enc.vecs) {
+		err = test_skcipher(tfm, ENCRYPT, desc->suite.cipher.enc.vecs,
+				    desc->suite.cipher.enc.count);
+		if (err)
+			goto out;
+	}
+
+	if (desc->suite.cipher.dec.vecs)
+		err = test_skcipher(tfm, DECRYPT, desc->suite.cipher.dec.vecs,
+				    desc->suite.cipher.dec.count);
+
+out:
 	crypto_free_ablkcipher(tfm);
 	return err;
 }
@@ -918,7 +1012,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "cbc(aes)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -933,7 +1027,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cbc(anubis)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -948,7 +1042,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cbc(blowfish)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -963,7 +1057,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cbc(camellia)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -978,7 +1072,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cbc(des)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -993,7 +1087,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cbc(des3_ede)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1008,7 +1102,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cbc(twofish)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1047,7 +1141,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cts(cbc(aes))",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1077,7 +1171,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(aes)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1092,7 +1186,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(anubis)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1107,7 +1201,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(arc4)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1122,7 +1216,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(blowfish)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1137,7 +1231,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(camellia)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1152,7 +1246,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(cast5)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1167,7 +1261,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(cast6)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1182,7 +1276,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(des)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1197,7 +1291,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(des3_ede)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1212,7 +1306,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(khazad)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1227,7 +1321,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(seed)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1242,7 +1336,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(serpent)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1257,7 +1351,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(tea)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1272,7 +1366,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(tnepres)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1287,7 +1381,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(twofish)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1302,7 +1396,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(xeta)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1317,7 +1411,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(xtea)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1419,7 +1513,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "lrw(aes)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1476,7 +1570,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "pcbc(fcrypt)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1491,7 +1585,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rfc3686(ctr(aes))",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1542,7 +1636,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "salsa20",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1661,7 +1755,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "xts(aes)",
-		.test = alg_test_cipher,
+		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1677,7 +1771,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	},
 };
 
-int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
+static int alg_find_test(const char *alg)
 {
 	int start = 0;
 	int end = ARRAY_SIZE(alg_test_descs);
@@ -1696,10 +1790,38 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 			continue;
 		}
 
-		return alg_test_descs[i].test(alg_test_descs + i, driver,
-					      type, mask);
+		return i;
+	}
+
+	return -1;
+}
+
+int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
+{
+	int i;
+
+	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
+		char nalg[CRYPTO_MAX_ALG_NAME];
+
+		if (snprintf(nalg, sizeof(nalg), "ecb(%s)", alg) >=
+		    sizeof(nalg))
+			return -ENAMETOOLONG;
+
+		i = alg_find_test(nalg);
+		if (i < 0)
+			goto notest;
+
+		return alg_test_cipher(alg_test_descs + i, driver, type, mask);
 	}
 
+	i = alg_find_test(alg);
+	if (i < 0)
+		goto notest;
+
+	return alg_test_descs[i].test(alg_test_descs + i, driver,
+				      type, mask);
+
+notest:
 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
 	return 0;
 }

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

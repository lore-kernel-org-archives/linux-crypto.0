From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH 6/6] crypto: tcrypt: add ECDSA test modes
Date: Fri, 20 Jan 2017 17:06:01 +0530
Message-ID: <1484912161-5932-7-git-send-email-nkumbhar@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2455 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdATLg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 06:36:57 -0500
In-Reply-To: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update tcrypt module to include a new ECDSA test
modes. It includes:

tcrypt.ko mode=560 for ECDSA sign/verify validation.
tcrypt.ko mode=561 for ECDSA sign/verify op perf in cycles.
tcrypt.ko mode=561 sec=<seconds> for number of ECDSA sign
  verify ops in given time.

Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
---
 crypto/tcrypt.c |  250 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 crypto/tcrypt.h |  122 +++++++++++++++++++++++++++
 2 files changed, 368 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ae22f05d5936..0e4547fe23a8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
+ * Copyright (c) 2017 NVIDIA Corporation
  *
  * Updated RFC4106 AES-GCM testing.
  *    Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
@@ -25,6 +26,7 @@
 #include <crypto/aead.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <crypto/akcipher.h>
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/init.h>
@@ -44,10 +46,12 @@
 #define TVMEMSIZE	4
 
 /*
-* Used by test_cipher_speed()
-*/
-#define ENCRYPT 1
-#define DECRYPT 0
+ * Used by test_cipher_speed()
+ */
+#define DECRYPT		0
+#define ENCRYPT		1
+#define SIGN		2
+#define VERIFY		3
 
 #define MAX_DIGEST_SIZE		64
 
@@ -994,6 +998,223 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
 				   false);
 }
 
+static inline int do_one_akcipher_op(struct akcipher_request *r, int ret)
+{
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		struct tcrypt_result *tr = r->base.data;
+
+		wait_for_completion(&tr->completion);
+		reinit_completion(&tr->completion);
+		ret = tr->err;
+	}
+	return ret;
+}
+
+static int test_akcipher_jiffies(struct akcipher_request *r, int op, int secs)
+{
+	unsigned long start, end;
+	int count, ret;
+
+	for (start = jiffies, end = start + secs * HZ, count = 0;
+	     time_before(jiffies, end); count++) {
+
+		switch (op) {
+		case SIGN:
+			ret = do_one_akcipher_op(r, crypto_akcipher_sign(r));
+			break;
+		case VERIFY:
+			ret = do_one_akcipher_op(r, crypto_akcipher_verify(r));
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		if (ret)
+			return ret;
+	}
+
+	pr_info("%d operations in %d seconds\n", count, secs);
+	return 0;
+}
+
+static int test_akcipher_cycles(struct akcipher_request *r, int op)
+{
+	unsigned long cycles = 0;
+	int ret = 0;
+	int i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		switch (op) {
+		case SIGN:
+			ret = do_one_akcipher_op(r, crypto_akcipher_sign(r));
+			break;
+		case VERIFY:
+			ret = do_one_akcipher_op(r, crypto_akcipher_verify(r));
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		switch (op) {
+		case SIGN:
+			ret = do_one_akcipher_op(r, crypto_akcipher_sign(r));
+			break;
+		case VERIFY:
+			ret = do_one_akcipher_op(r, crypto_akcipher_verify(r));
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		end = get_cycles();
+
+		if (ret)
+			goto out;
+
+		cycles += end - start;
+	}
+out:
+	if (ret == 0)
+		pr_info("1 operation in %lu cycles\n", (cycles + 4) / 8);
+
+	return ret;
+}
+
+static void test_akcipher_speed(const char *algo, int op, unsigned int secs,
+				struct akcipher_speed_template *template,
+				unsigned int tcount, u8 *keysize)
+{
+	unsigned int ret, i, j;
+	struct tcrypt_result tresult;
+	const char *key;
+	struct akcipher_request *req;
+	struct crypto_akcipher *tfm;
+	unsigned int m_size = 0;
+	unsigned int nbytes = 0;
+	const char *o;
+
+	if (op == SIGN)
+		o = "sign";
+	else if (op == VERIFY)
+		o = "verify";
+	else
+		return;
+
+	tfm = crypto_alloc_akcipher(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n", algo,
+		       PTR_ERR(tfm));
+		return;
+	}
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("tcrypt: akcipher: Failed to allocate request for %s\n",
+		       algo);
+		goto out;
+	}
+
+	init_completion(&tresult.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &tresult);
+
+	i = 0;
+	do {
+		struct scatterlist sg[TVMEMSIZE];
+
+		memset(tvmem[0], 0xff, PAGE_SIZE);
+
+		/* set key */
+		key = tvmem[0];
+		for (j = 0; j < tcount; j++) {
+			if (template[j].key_len == *keysize) {
+				key = template[j].key;
+				break;
+			}
+		}
+
+		ret = crypto_akcipher_set_pub_key(tfm, key, *keysize);
+		if (ret) {
+			pr_err("set_pub_key() failed\n");
+			goto out_free_req;
+		}
+
+		ret = crypto_akcipher_set_priv_key(tfm, key, *keysize);
+		if (ret) {
+			pr_err("set_priv_key() failed\n");
+			goto out_free_req;
+		}
+
+		/* set up src/dst buffs */
+		sg_init_table(sg, TVMEMSIZE);
+		if (op == SIGN) {
+			m_size = template[j].m_size;
+			nbytes = template[j].c_size / 3;
+
+			memcpy(tvmem[0], template[j].m, m_size);
+
+			sg_set_buf(&sg[0], tvmem[0], m_size);
+			akcipher_request_set_crypt(req, sg, sg,
+						   m_size, PAGE_SIZE);
+		} else if (op == VERIFY) {
+			m_size = template[j].m_size;
+			nbytes = template[j].c_size / 3;
+
+			memcpy(tvmem[0], template[j].m, m_size);
+			memcpy(tvmem[1], (u8 *)(template[j].c) + nbytes,
+			       nbytes);
+			memcpy(tvmem[2], (u8 *)(template[j].c) + 2 * nbytes,
+			       nbytes);
+
+			sg_set_buf(&sg[0], tvmem[0], m_size);
+			sg_set_buf(&sg[1], tvmem[1], nbytes);
+			sg_set_buf(&sg[2], tvmem[2], nbytes);
+
+			akcipher_request_set_crypt(req, sg, sg,
+						   m_size + 2 * nbytes,
+						   PAGE_SIZE);
+		} else {
+			pr_err("invalid op\n");
+			ret = -EINVAL;
+			goto out_free_req;
+		}
+
+
+		pr_info("\ntesting speed of %s (%s) %s with keysize %d\n",
+			algo, get_driver_name(crypto_akcipher, tfm), o,
+			nbytes * 8);
+
+		if (secs)
+			ret = test_akcipher_jiffies(req, op, secs);
+		else
+			ret = test_akcipher_cycles(req, op);
+
+		if (ret) {
+			pr_err("%s() failed\n", o);
+			break;
+		}
+
+		i++;
+		keysize++;
+
+	} while (*keysize);
+
+out_free_req:
+	akcipher_request_free(req);
+out:
+	crypto_free_akcipher(tfm);
+}
+
 static void test_available(void)
 {
 	char **name = check;
@@ -2035,6 +2256,27 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				   speed_template_8_32);
 		break;
 
+	case 560:
+		ret += tcrypt_test("ecdsa");
+		break;
+
+	case 561:
+#ifndef CONFIG_CRYPTO_FIPS
+		test_akcipher_speed("ecdsa", SIGN, sec,
+				    ecdsa_speed_template, ECDSA_SPEED_VECTORS,
+				    akc_speed_template_P192);
+		test_akcipher_speed("ecdsa", VERIFY, sec,
+				    ecdsa_speed_template, ECDSA_SPEED_VECTORS,
+				    akc_speed_template_P192);
+#endif
+		test_akcipher_speed("ecdsa", SIGN, sec,
+				    ecdsa_speed_template, ECDSA_SPEED_VECTORS,
+				    akc_speed_template_P256);
+		test_akcipher_speed("ecdsa", VERIFY, sec,
+				    ecdsa_speed_template, ECDSA_SPEED_VECTORS,
+				    akc_speed_template_P256);
+		break;
+
 	case 1000:
 		test_available();
 		break;
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index f0bfee1bb293..bd6a4b1cbcbe 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -7,6 +7,7 @@
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
+ * Copyright (c) 2017 NVIDIA Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -17,6 +18,16 @@
 #ifndef _CRYPTO_TCRYPT_H
 #define _CRYPTO_TCRYPT_H
 
+struct akcipher_speed_template {
+	unsigned char *key;
+	unsigned char *m;
+	unsigned char *c;
+	unsigned int key_len;
+	unsigned int m_size;
+	unsigned int c_size;
+	bool public_key_vec;
+};
+
 struct cipher_speed_template {
 	const char *key;
 	unsigned int klen;
@@ -48,6 +59,117 @@ struct hash_speed {
 };
 
 /*
+ * ECDSA test vectors.
+ */
+#ifdef CONFIG_CRYPTO_FIPS
+#define ECDSA_SPEED_VECTORS	1
+#else
+#define ECDSA_SPEED_VECTORS	2
+#endif
+
+static struct akcipher_speed_template ecdsa_speed_template[] = {
+	{
+#ifndef CONFIG_CRYPTO_FIPS
+		/* [P-192,SHA-256] */
+		.m =
+		/* Msg / Hash */
+		"\xd0\xd8\xc0\x99\xe0\xe2\xf7\xf8"
+		"\x87\xe1\x6d\x11\xe1\xcc\x20\x43"
+		"\xaf\xc0\x80\xdb\x47\x72\xfa\xe3"
+		"\x95\xe5\xd1\x34\x7d\x31\xe8\x5a",
+		.m_size = 32,
+		.key =
+		/* version */
+		"\x01"
+		/* curve_id */
+		"\x01"
+		/* d */
+		"\x47\x7a\xf2\x5c\x86\xef\x09\x08"
+		"\xa4\x9a\x47\x53\x06\xfc\x61\xbc"
+		"\xa5\x6f\xdd\x7d\x2f\xd2\xed\x24"
+		/* Qx */
+		"\xdc\x14\xd4\xd8\x2e\x1e\x25\x2f"
+		"\x66\x28\xaa\x80\xbc\x38\x6a\x07"
+		"\x8a\x70\xb7\x74\x71\x2d\xf1\x9b"
+		/* Qy */
+		"\x98\x34\x57\x11\xb0\xdc\x3d\xff"
+		"\xfc\xdc\xfe\xa2\x1c\x47\x9e\x4e"
+		"\x82\x08\xfc\x7d\xd0\xc8\x54\x48",
+		.key_len = 74,
+		.c =
+		/* k */
+		"\x3e\x70\xc7\x86\xaf\xaa\x71\x7c"
+		"\x68\x96\xc5\xc3\xec\xb8\x29\xa3"
+		"\xfa\xf7\xa5\x36\xa2\x17\xc8\xa5"
+		/* R */
+		"\xf8\xef\x13\xa8\x86\xe6\x73\x85"
+		"\xdf\x2e\x88\x99\x91\x9b\xc2\x90"
+		"\xea\x1f\x36\xf4\xec\xba\x4a\x35"
+		/* S */
+		"\xc1\x82\x9e\x94\xb7\x58\x2c\x63"
+		"\x8e\xd7\x15\x5a\x38\x47\x30\x9b"
+		"\x1c\x11\x86\xac\x00\x00\xf5\x80",
+		.c_size = 72,
+	}, {
+#endif
+		/* [P-256,SHA-256] */
+		.m =
+		/* Msg / Hash */
+		"\x56\xec\x33\xa1\xa6\xe7\xc4\xdb"
+		"\x77\x03\x90\x1a\xfb\x2e\x1e\x4e"
+		"\x50\x09\xfe\x04\x72\x89\xc5\xc2"
+		"\x42\x13\x6c\xe3\xb7\xf6\xac\x44",
+		.m_size = 32,
+		.key =
+		/* version */
+		"\x01"
+		/* curve_id */
+		"\x02"
+		/* d */
+		"\x64\xb4\x72\xda\x6d\xa5\x54\xca"
+		"\xac\x3e\x4e\x0b\x13\xc8\x44\x5b"
+		"\x1a\x77\xf4\x59\xee\xa8\x4f\x1f"
+		"\x58\x8b\x5f\x71\x3d\x42\x9b\x51"
+		/* Qx */
+		"\x83\xbf\x71\xc2\x46\xff\x59\x3c"
+		"\x2f\xb1\xbf\x4b\xe9\x5d\x56\xd3"
+		"\xcc\x8f\xdb\x48\xa2\xbf\x33\xf0"
+		"\xf4\xc7\x5f\x07\x1c\xe9\xcb\x1c"
+		/* Qy */
+		"\xa9\x4c\x9a\xa8\x5c\xcd\x7c\xdc"
+		"\x78\x4e\x40\xb7\x93\xca\xb7\x6d"
+		"\xe0\x13\x61\x0e\x2c\xdb\x1f\x1a"
+		"\xa2\xf9\x11\x88\xc6\x14\x40\xce",
+		.key_len = 98,
+		.c =
+		/* k */
+		"\xde\x68\x2a\x64\x87\x07\x67\xb9"
+		"\x33\x5d\x4f\x82\x47\x62\x4a\x3b"
+		"\x7f\x3c\xe9\xf9\x45\xf2\x80\xa2"
+		"\x61\x6a\x90\x4b\xb1\xbb\xa1\x94"
+		/* R */
+		"\xac\xc2\xc8\x79\x6f\x5e\xbb\xca"
+		"\x7a\x5a\x55\x6a\x1f\x6b\xfd\x2a"
+		"\xed\x27\x95\x62\xd6\xe3\x43\x88"
+		"\x5b\x79\x14\xb5\x61\x80\xac\xf3"
+		/* S */
+		"\x03\x89\x05\xcc\x2a\xda\xcd\x3c"
+		"\x5a\x17\x6f\xe9\x18\xb2\x97\xef"
+		"\x1c\x37\xf7\x2b\x26\x76\x6c\x78"
+		"\xb2\xa6\x05\xca\x19\x78\xf7\x8b",
+		.c_size = 96,
+	},
+};
+
+/*
+ * AKCipher speed tests
+ */
+#ifndef CONFIG_CRYPTO_FIPS
+static u8 akc_speed_template_P192[] = {74, 0};
+#endif
+static u8 akc_speed_template_P256[] = {98, 0};
+
+/*
  * Cipher speed tests
  */
 static u8 speed_template_8[] = {8, 0};
-- 
1.7.6.3

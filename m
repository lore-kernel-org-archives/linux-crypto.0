From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2] Speed testing support for ghash
Date: Wed, 03 Mar 2010 11:18:16 +0800
Message-ID: <1267586296.1640.205.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58285 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0CCDST (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 22:18:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Because ghash needs setkey, the setkey and keysize template support
for test_hash_speed is added.

v2:

 - Move klen into struct hash_speed.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/tcrypt.c |    7 +++++++
 crypto/tcrypt.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -437,6 +437,9 @@ static void test_hash_speed(const char *
 			goto out;
 		}
 
+		if (speed[i].klen)
+			crypto_hash_setkey(tfm, tvmem[0], speed[i].klen);
+
 		printk(KERN_INFO "test%3u "
 		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
 		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
@@ -881,6 +884,10 @@ static int do_test(int m)
 		test_hash_speed("rmd320", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 318:
+		test_hash_speed("ghash-generic", sec, hash_speed_template_16);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -25,6 +25,7 @@ struct cipher_speed_template {
 struct hash_speed {
 	unsigned int blen;	/* buffer length */
 	unsigned int plen;	/* per-update length */
+	unsigned int klen;	/* key length */
 };
 
 /*
@@ -83,4 +84,32 @@ static struct hash_speed generic_hash_sp
 	{  .blen = 0,	.plen = 0, }
 };
 
+static struct hash_speed hash_speed_template_16[] = {
+	{ .blen = 16,	.plen = 16,	.klen = 16, },
+	{ .blen = 64,	.plen = 16,	.klen = 16, },
+	{ .blen = 64,	.plen = 64,	.klen = 16, },
+	{ .blen = 256,	.plen = 16,	.klen = 16, },
+	{ .blen = 256,	.plen = 64,	.klen = 16, },
+	{ .blen = 256,	.plen = 256,	.klen = 16, },
+	{ .blen = 1024,	.plen = 16,	.klen = 16, },
+	{ .blen = 1024,	.plen = 256,	.klen = 16, },
+	{ .blen = 1024,	.plen = 1024,	.klen = 16, },
+	{ .blen = 2048,	.plen = 16,	.klen = 16, },
+	{ .blen = 2048,	.plen = 256,	.klen = 16, },
+	{ .blen = 2048,	.plen = 1024,	.klen = 16, },
+	{ .blen = 2048,	.plen = 2048,	.klen = 16, },
+	{ .blen = 4096,	.plen = 16,	.klen = 16, },
+	{ .blen = 4096,	.plen = 256,	.klen = 16, },
+	{ .blen = 4096,	.plen = 1024,	.klen = 16, },
+	{ .blen = 4096,	.plen = 4096,	.klen = 16, },
+	{ .blen = 8192,	.plen = 16,	.klen = 16, },
+	{ .blen = 8192,	.plen = 256,	.klen = 16, },
+	{ .blen = 8192,	.plen = 1024,	.klen = 16, },
+	{ .blen = 8192,	.plen = 4096,	.klen = 16, },
+	{ .blen = 8192,	.plen = 8192,	.klen = 16, },
+
+	/* End marker */
+	{  .blen = 0,	.plen = 0,	.klen = 0, }
+};
+
 #endif	/* _CRYPTO_TCRYPT_H */



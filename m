From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/4] crypto: testmgr - test skciphers with unaligned buffers
Date: Thu, 13 Jun 2013 17:37:45 +0300
Message-ID: <20130613143745.31765.20237.stgit@localhost6.localdomain6>
References: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:37951 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3FMOhv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jun 2013 10:37:51 -0400
In-Reply-To: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds unaligned buffer tests for blkciphers.

The first new test is with one byte offset and the second test checks if
cra_alignmask for driver is big enough; for example, for testing a case
where cra_alignmask is set to 7, but driver really needs buffers to be
aligned to 16 bytes.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/testmgr.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a81c154..8bd185f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -820,7 +820,7 @@ out_nobuf:
 
 static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			   struct cipher_testvec *template, unsigned int tcount,
-			   const bool diff_dst)
+			   const bool diff_dst, const int align_offset)
 {
 	const char *algo =
 		crypto_tfm_alg_driver_name(crypto_ablkcipher_tfm(tfm));
@@ -876,10 +876,12 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			j++;
 
 			ret = -EINVAL;
-			if (WARN_ON(template[i].ilen > PAGE_SIZE))
+			if (WARN_ON(align_offset + template[i].ilen >
+				    PAGE_SIZE))
 				goto out;
 
 			data = xbuf[0];
+			data += align_offset;
 			memcpy(data, template[i].input, template[i].ilen);
 
 			crypto_ablkcipher_clear_flags(tfm, ~0);
@@ -900,6 +902,7 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			sg_init_one(&sg[0], data, template[i].ilen);
 			if (diff_dst) {
 				data = xoutbuf[0];
+				data += align_offset;
 				sg_init_one(&sgout[0], data, template[i].ilen);
 			}
 
@@ -941,6 +944,9 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
+		/* alignment tests are only done with continuous buffers */
+		if (align_offset != 0)
+			break;
 
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
@@ -1075,15 +1081,34 @@ out_nobuf:
 static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			 struct cipher_testvec *template, unsigned int tcount)
 {
+	unsigned int alignmask;
 	int ret;
 
 	/* test 'dst == src' case */
-	ret = __test_skcipher(tfm, enc, template, tcount, false);
+	ret = __test_skcipher(tfm, enc, template, tcount, false, 0);
 	if (ret)
 		return ret;
 
 	/* test 'dst != src' case */
-	return __test_skcipher(tfm, enc, template, tcount, true);
+	ret = __test_skcipher(tfm, enc, template, tcount, true, 0);
+	if (ret)
+		return ret;
+
+	/* test unaligned buffers, check with one byte offset */
+	ret = __test_skcipher(tfm, enc, template, tcount, true, 1);
+	if (ret)
+		return ret;
+
+	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
+	if (alignmask) {
+		/* Check if alignment mask for tfm is correctly set. */
+		ret = __test_skcipher(tfm, enc, template, tcount, true,
+				      alignmask + 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,

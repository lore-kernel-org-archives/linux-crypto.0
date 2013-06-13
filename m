From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 3/4] crypto: testmgr - test AEADs with unaligned buffers
Date: Thu, 13 Jun 2013 17:37:50 +0300
Message-ID: <20130613143750.31765.4558.stgit@localhost6.localdomain6>
References: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:33887 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3FMOiv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jun 2013 10:38:51 -0400
In-Reply-To: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds unaligned buffer tests for AEADs.

The first new test is with one byte offset and the second test checks if
cra_alignmask for driver is big enough; for example, for testing a case
where cra_alignmask is set to 7, but driver really needs buffers to be
aligned to 16 bytes.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/testmgr.c |   37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8bd185f..f205386 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -360,7 +360,7 @@ out_nobuf:
 
 static int __test_aead(struct crypto_aead *tfm, int enc,
 		       struct aead_testvec *template, unsigned int tcount,
-		       const bool diff_dst)
+		       const bool diff_dst, const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
 	unsigned int i, j, k, n, temp;
@@ -423,15 +423,16 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		if (!template[i].np) {
 			j++;
 
-			/* some tepmplates have no input data but they will
+			/* some templates have no input data but they will
 			 * touch input
 			 */
 			input = xbuf[0];
+			input += align_offset;
 			assoc = axbuf[0];
 
 			ret = -EINVAL;
-			if (WARN_ON(template[i].ilen > PAGE_SIZE ||
-				    template[i].alen > PAGE_SIZE))
+			if (WARN_ON(align_offset + template[i].ilen >
+				    PAGE_SIZE || template[i].alen > PAGE_SIZE))
 				goto out;
 
 			memcpy(input, template[i].input, template[i].ilen);
@@ -470,6 +471,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 			if (diff_dst) {
 				output = xoutbuf[0];
+				output += align_offset;
 				sg_init_one(&sgout[0], output,
 					    template[i].ilen +
 						(enc ? authsize : 0));
@@ -530,6 +532,10 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	}
 
 	for (i = 0, j = 0; i < tcount; i++) {
+		/* alignment tests are only done with continuous buffers */
+		if (align_offset != 0)
+			break;
+
 		if (template[i].np) {
 			j++;
 
@@ -732,15 +738,34 @@ out_noxbuf:
 static int test_aead(struct crypto_aead *tfm, int enc,
 		     struct aead_testvec *template, unsigned int tcount)
 {
+	unsigned int alignmask;
 	int ret;
 
 	/* test 'dst == src' case */
-	ret = __test_aead(tfm, enc, template, tcount, false);
+	ret = __test_aead(tfm, enc, template, tcount, false, 0);
 	if (ret)
 		return ret;
 
 	/* test 'dst != src' case */
-	return __test_aead(tfm, enc, template, tcount, true);
+	ret = __test_aead(tfm, enc, template, tcount, true, 0);
+	if (ret)
+		return ret;
+
+	/* test unaligned buffers, check with one byte offset */
+	ret = __test_aead(tfm, enc, template, tcount, true, 1);
+	if (ret)
+		return ret;
+
+	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
+	if (alignmask) {
+		/* Check if alignment mask for tfm is correctly set. */
+		ret = __test_aead(tfm, enc, template, tcount, true,
+				  alignmask + 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int test_cipher(struct crypto_cipher *tfm, int enc,

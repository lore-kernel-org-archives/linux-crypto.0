From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 4/4] crypto: testmgr - test hash implementations with
 unaligned buffers
Date: Thu, 13 Jun 2013 17:37:55 +0300
Message-ID: <20130613143755.31765.58282.stgit@localhost6.localdomain6>
References: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:58861 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3FMOiA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jun 2013 10:38:00 -0400
In-Reply-To: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds unaligned buffer tests for hashes.

The first new test is with one byte offset and the second test checks if
cra_alignmask for driver is big enough; for example, for testing a case
where cra_alignmask is set to 7, but driver really needs buffers to be
aligned to 16 bytes.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/testmgr.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f205386..2f00607 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -184,8 +184,9 @@ static int do_one_async_hash_op(struct ahash_request *req,
 	return ret;
 }
 
-static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
-		     unsigned int tcount, bool use_digest)
+static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
+		       unsigned int tcount, bool use_digest,
+		       const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 	unsigned int i, j, k, temp;
@@ -216,10 +217,15 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		if (template[i].np)
 			continue;
 
+		ret = -EINVAL;
+		if (WARN_ON(align_offset + template[i].psize > PAGE_SIZE))
+			goto out;
+
 		j++;
 		memset(result, 0, 64);
 
 		hash_buff = xbuf[0];
+		hash_buff += align_offset;
 
 		memcpy(hash_buff, template[i].plaintext, template[i].psize);
 		sg_init_one(&sg[0], hash_buff, template[i].psize);
@@ -281,6 +287,10 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
+		/* alignment tests are only done with continuous buffers */
+		if (align_offset != 0)
+			break;
+
 		if (template[i].np) {
 			j++;
 			memset(result, 0, 64);
@@ -358,6 +368,33 @@ out_nobuf:
 	return ret;
 }
 
+static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
+		     unsigned int tcount, bool use_digest)
+{
+	unsigned int alignmask;
+	int ret;
+
+	ret = __test_hash(tfm, template, tcount, use_digest, 0);
+	if (ret)
+		return ret;
+
+	/* test unaligned buffers, check with one byte offset */
+	ret = __test_hash(tfm, template, tcount, use_digest, 1);
+	if (ret)
+		return ret;
+
+	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
+	if (alignmask) {
+		/* Check if alignment mask for tfm is correctly set. */
+		ret = __test_hash(tfm, template, tcount, use_digest,
+				  alignmask + 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int __test_aead(struct crypto_aead *tfm, int enc,
 		       struct aead_testvec *template, unsigned int tcount,
 		       const bool diff_dst, const int align_offset)

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/10] crypto: crc32c - Test descriptor context format
Date: Fri, 07 Nov 2008 16:37:05 +0800
Message-ID: <E1KyMq1-0002lf-CN@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39131 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689AbYKGIhH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:07 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMq1-0006Ae-J2
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:37:06 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: crc32c - Test descriptor context format

This patch adds a test for the requirement that all crc32c algorithms
shall store the partial result in the first four bytes of the descriptor
context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 308d9cf..67dce77 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1010,6 +1010,55 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+static int alg_test_crc32c(const struct alg_test_desc *desc,
+			   const char *driver, u32 type, u32 mask)
+{
+	struct crypto_shash *tfm;
+	u32 val;
+	int err;
+
+	err = alg_test_hash(desc, driver, type, mask);
+	if (err)
+		goto out;
+
+	tfm = crypto_alloc_shash(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		err = PTR_ERR(tfm);
+		goto out;
+	}
+
+	do {
+		struct {
+			struct shash_desc shash;
+			char ctx[crypto_shash_descsize(tfm)];
+		} sdesc;
+
+		sdesc.shash.tfm = tfm;
+		sdesc.shash.flags = 0;
+
+		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
+		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
+		if (err) {
+			printk(KERN_ERR "alg: crc32c: Operation failed for "
+			       "%s: %d\n", driver, err);
+			break;
+		}
+
+		if (val != ~420553207) {
+			printk(KERN_ERR "alg: crc32c: Test failed for %s: "
+			       "%d\n", driver, val);
+			err = -EINVAL;
+		}
+	} while (0);
+
+	crypto_free_shash(tfm);
+
+out:
+	return err;
+}
+
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
@@ -1134,7 +1183,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "crc32c",
-		.test = alg_test_hash,
+		.test = alg_test_crc32c,
 		.suite = {
 			.hash = {
 				.vecs = crc32c_tv_template,

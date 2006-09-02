From: rsnel@cube.dyndns.org
Subject: [PATCHv2 2/6] crypto: benbi IV, big endian narrow block count for LRW-32-AES
Date: Sat, 02 Sep 2006 03:00:23 +0200
Message-ID: <11571588302090-git-send-email-rsnel@cube.dyndns.org>
References: <20060901103707.GA17110@gondor.apana.org.au>
Reply-To: rsnel@cube.dyndns.org
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:35340 "EHLO
	smtp-vbr13.xs4all.nl") by vger.kernel.org with ESMTP
	id S1750770AbWIBBAp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Sep 2006 21:00:45 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <20060901103707.GA17110@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rik Snel <rsnel@cube.dyndns.org>

LRW-32-AES needs a certain IV. This IV should be provided dm-crypt.
The block cipher mode could, in principle generate the correct IV from
the plain IV, but I think that it is cleaner to supply the right IV
directly.

The sector -> narrow block calculation uses a shift for performance reasons.
This shift is computed in .ctr and stored in cc->iv_gen_private (as a void*).

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 drivers/md/dm-crypt.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 06961f7..df399d6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -106,6 +106,9 @@ static kmem_cache_t *_crypt_io_pool;
  *        encrypted with the bulk cipher using a salt as key. The salt
  *        should be derived from the bulk cipher's key via hashing.
  *
+ * benbi: the 64-bit "big-endian 'narrow block'-count", starting at 1
+ * 	  (needed for LRW-32-AES and possible other narrow block modes)
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -200,6 +203,49 @@ static int crypt_iv_essiv_gen(struct cry
 	return 0;
 }
 
+static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
+			      const char *opts)
+{
+	unsigned int bs = crypto_blkcipher_blocksize(cc->tfm);
+	int log = long_log2(bs);
+
+	/* we need to calculate how far we must shift the sector count
+	 * to get the cipher block count, we use this shift in _gen */
+
+	if (1 << log != bs) {
+		ti->error = "cypher blocksize is not a power of 2";
+		return -EINVAL;
+	}
+
+	if (log > 9) {
+		ti->error = "cypher blocksize is > 512";
+		return -EINVAL;
+	}
+
+	if (crypto_blkcipher_ivsize(cc->tfm) < sizeof(u64)) {
+		ti->error = "cypher ivsize is < 8";
+		return -EINVAL;
+	}
+
+	cc->iv_gen_private = (void *)(9 - log);
+
+	return 0;
+}
+
+static void crypt_iv_benbi_dtr(struct crypt_config *cc)
+{
+	cc->iv_gen_private = NULL;
+}
+
+static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+{
+	memset(iv, 0, cc->iv_size - sizeof(u64)); /* rest is cleared below */
+	*(u64 *)(iv + cc->iv_size - sizeof(u64)) =
+		cpu_to_be64(((u64)sector << (u32)cc->iv_gen_private) + 1);
+
+	return 0;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -210,6 +256,11 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_essiv_gen
 };
 
+static struct crypt_iv_operations crypt_iv_benbi_ops = {
+	.ctr	   = crypt_iv_benbi_ctr,
+	.dtr	   = crypt_iv_benbi_dtr,
+	.generator = crypt_iv_benbi_gen
+};
 
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
@@ -579,7 +630,8 @@ static int crypt_ctr(struct dm_target *t
 	cc->tfm = tfm;
 
 	/*
-	 * Choose ivmode. Valid modes: "plain", "essiv:<esshash>".
+	 * Choose ivmode. Valid modes: "plain", "essiv:<esshash>", "benbi".
+	 *
 	 * See comments at iv code
 	 */
 
@@ -589,6 +641,8 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_gen_ops = &crypt_iv_plain_ops;
 	else if (strcmp(ivmode, "essiv") == 0)
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
+	else if (strcmp(ivmode, "benbi") == 0)
+		cc->iv_gen_ops = &crypt_iv_benbi_ops;
 	else {
 		ti->error = "Invalid IV mode";
 		goto bad2;
-- 
1.4.1.1


-- 
VGER BF report: U 0.499935

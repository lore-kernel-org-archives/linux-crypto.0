From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: [PATCH 1/2] crypto: bewbi IV, big endian wide block count for ABL-32-AES
Date: Sat, 23 Sep 2006 19:41:03 +0200
Message-ID: <11590332652186-git-send-email-rsnel@cube.dyndns.org>
References: <11590332641118-git-send-email-rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:31237 "EHLO
	smtp-vbr8.xs4all.nl") by vger.kernel.org with ESMTP
	id S1751366AbWIWRlV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Sep 2006 13:41:21 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <11590332641118-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rik Snel <rsnel@cube.dyndns.org>

ABL-32-AES needs a certain IV. This IV should be provided dm-crypt.
The block cipher mode could, in principle, generate the correct IV from
the plain IV, but I think that it is cleaner to supply the right IV
directly.

The sector -> wide block calculation is currently just a conversion
to bigendian and an increment, but if dm-crypt will support cypher
blocksizes larger than 512 bytes (which would be interesting for
wide blocks) the conversion will include a shift also.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 drivers/md/dm-crypt.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c09c8e0..10cc227 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -109,6 +109,9 @@ static kmem_cache_t *_crypt_io_pool;
  * benbi: the 64-bit "big-endian 'narrow block'-count", starting at 1
  * 	  (needed for LRW-32-AES and possible other narrow block modes)
  *
+ * bewbi: the 64-bit "big-endian 'wide block'-count", starting at 1
+ *        (needed for ABL-32-AES and possible other wide block modes)
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -248,6 +251,14 @@ static int crypt_iv_benbi_gen(struct cry
 	return 0;
 }
 
+static int crypt_iv_bewbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+{
+	memset(iv, 0, cc->iv_size - sizeof(u32));
+	*((u32*)iv + 3) = cpu_to_be32((sector & 0xffffffff) + 1);
+
+	return 0;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -264,6 +275,10 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_benbi_gen
 };
 
+static struct crypt_iv_operations crypt_iv_bewbi_ops = {
+	.generator = crypt_iv_bewbi_gen
+};
+
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
                           struct scatterlist *in, unsigned int length,
@@ -632,7 +647,8 @@ static int crypt_ctr(struct dm_target *t
 	cc->tfm = tfm;
 
 	/*
-	 * Choose ivmode. Valid modes: "plain", "essiv:<esshash>", "benbi".
+	 * Choose ivmode. Valid modes: "plain", "essiv:<esshash>",
+	 *	"benbi", "bewbi".
 	 *
 	 * See comments at iv code
 	 */
@@ -645,6 +661,8 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
 	else if (strcmp(ivmode, "benbi") == 0)
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ivmode, "bewbi") == 0)
+		cc->iv_gen_ops = &crypt_iv_bewbi_ops;
 	else {
 		ti->error = "Invalid IV mode";
 		goto bad2;
-- 
1.4.2.1


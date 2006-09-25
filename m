From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: [BLOCK] dm-crypt: add support for very wide (>512 bytes) block modes
Date: Mon, 25 Sep 2006 20:03:57 +0200
Message-ID: <1159207437453-git-send-email-rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:20997 "EHLO
	smtp-vbr4.xs4all.nl") by vger.kernel.org with ESMTP
	id S1750793AbWIYSEV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Sep 2006 14:04:21 -0400
To: herbert@gondor.apana.org.au
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rik Snel <rsnel@cube.dyndns.org>

By default dm-crypt sends and receives chunks of 512 bytes to and from
the crypto layer. For implementing deniable harddisk encryption it is
useful to make these chunks larger; i.e. equal to the filesystem block
size. If a wide block cipher mode (like ABL) is used, then a single bit
modification of the filesystem block will result in a total change of the
corresponding cipher block.

This patch adds an optional argument to dm-crypt, the 'extra sector size
shift'.  The blocksize for communicating with the crypto layer will be
512<<'extra sector size shift'. The resulting size may not be larger
than PAGE_SIZE. Care is taken to also enlarge the hardsector_size as needed.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
Note: I don't have a thorough understanding of the block IO layer, this patch 
may be entirely wrong, but it works for me.

 drivers/md/dm-crypt.c |   50 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 10cc227..68c1590 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -87,6 +87,7 @@ struct crypt_config {
 	char chainmode[CRYPTO_MAX_ALG_NAME];
 	struct crypto_blkcipher *tfm;
 	unsigned int key_size;
+	int extra_shift;
 	u8 key[0];
 };
 
@@ -254,7 +255,8 @@ static int crypt_iv_benbi_gen(struct cry
 static int crypt_iv_bewbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 {
 	memset(iv, 0, cc->iv_size - sizeof(u32));
-	*((u32*)iv + 3) = cpu_to_be32((sector & 0xffffffff) + 1);
+	*((u32*)iv + 3) =
+		cpu_to_be32((sector >> cc->extra_shift & 0xffffffff) + 1);
 
 	return 0;
 }
@@ -341,12 +343,12 @@ static int crypt_convert(struct crypt_co
 		struct scatterlist sg_in = {
 			.page = bv_in->bv_page,
 			.offset = bv_in->bv_offset + ctx->offset_in,
-			.length = 1 << SECTOR_SHIFT
+			.length = (1 << SECTOR_SHIFT) << cc->extra_shift
 		};
 		struct scatterlist sg_out = {
 			.page = bv_out->bv_page,
 			.offset = bv_out->bv_offset + ctx->offset_out,
-			.length = 1 << SECTOR_SHIFT
+			.length = (1 << SECTOR_SHIFT) << cc->extra_shift
 		};
 
 		ctx->offset_in += sg_in.length;
@@ -575,7 +577,7 @@ static void crypt_encode_key(char *hex, 
 
 /*
  * Construct an encryption mapping:
- * <cipher> <key> <iv_offset> <dev_path> <start>
+ * <cipher> <key> <iv_offset> <dev_path> <start> [<extra_shift>]
  */
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -589,11 +591,16 @@ static int crypt_ctr(struct dm_target *t
 	unsigned int key_size;
 	unsigned long long tmpll;
 
-	if (argc != 5) {
+	if (argc < 5) {
 		ti->error = "Not enough arguments";
 		return -EINVAL;
 	}
 
+	if (argc > 6) {
+		ti->error = "Too many arguments";
+		return -EINVAL;
+	}
+
 	tmp = argv[0];
 	cipher = strsep(&tmp, "-");
 	chainmode = strsep(&tmp, "-");
@@ -715,12 +722,42 @@ static int crypt_ctr(struct dm_target *t
 	}
 	cc->start = tmpll;
 
+	if (argc > 5) {
+		if (sscanf(argv[5], "%llu", &tmpll) != 1) {
+			ti->error = "Invalid extra sector size shift";
+			goto bad5;
+		}
+		if (tmpll < 1) {
+			ti->error = "Invalid extra sector size shift, "
+				"must be positive";
+			goto bad5;
+		}
+		if (tmpll > PAGE_SHIFT - SECTOR_SHIFT) {
+			ti->error = "Invalid extra sector size shift, "
+				"must be <= PAGE_SHIFT - SECTOR_SHIFT";
+			goto bad5;
+		}
+		cc->extra_shift = tmpll;
+	 } else cc->extra_shift = 0;
+
 	if (dm_get_device(ti, argv[3], cc->start, ti->len,
 	                  dm_table_get_mode(ti->table), &cc->dev)) {
 		ti->error = "Device lookup failed";
 		goto bad5;
 	}
 
+	if (cc->extra_shift) {
+		/* update hardsector_size */
+		if (ti->limits.hardsect_size%(1 << SECTOR_SHIFT)) {
+			ti->error = "Weird sector size, too small or "
+				"not a power of 2";
+			goto bad5;
+		}
+		while (ti->limits.hardsect_size <
+				(1 << SECTOR_SHIFT) << cc->extra_shift)
+			ti->limits.hardsect_size <<= 1;
+	}
+
 	if (ivmode && cc->iv_gen_ops) {
 		if (ivopts)
 			*(ivopts - 1) = ':';
@@ -950,6 +987,9 @@ static int crypt_status(struct dm_target
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
+		if (cc->extra_shift)
+			DMEMIT(" %llu", (unsigned long long)cc->extra_shift);
+
 		break;
 	}
 	return 0;
-- 
1.4.2.1


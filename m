From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] squashfs: Make SquashFS 4 use the new pcomp crypto interface
Date: Tue, 13 Jan 2009 16:59:46 +0100
Message-ID: <1231862386-11128-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Phillip Lougher <phillip@lougher.demon.co.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47649 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753339AbZAMP77 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 10:59:59 -0500
In-Reply-To: <1231862386-11128-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify SquashFS 4 to use the new "pcomp" crypto interface for decompression,
instead of calling the underlying zlib library directly. This simplifies e.g.
the addition of support for hardware decompression and different decompression
algorithms.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/Kconfig                   |    3 +-
 fs/squashfs/block.c          |   81 ++++++++++++++++++++++++------------------
 fs/squashfs/squashfs_fs_sb.h |    2 +-
 fs/squashfs/super.c          |   36 ++++++++++++++----
 4 files changed, 77 insertions(+), 45 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 51307b0..6636018 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -935,7 +935,8 @@ config CRAMFS
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
 	depends on BLOCK
-	select ZLIB_INFLATE
+	select CRYPTO
+	select CRYPTO_DEFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index c837dfc..959e993 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -32,7 +32,8 @@
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
-#include <linux/zlib.h>
+
+#include <crypto/compress.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -153,7 +154,9 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 	}
 
 	if (compressed) {
-		int zlib_err = 0, zlib_init = 0;
+		int error = 0, decomp_init = 0;
+		struct comp_request req;
+		unsigned int produced = 0;
 
 		/*
 		 * Uncompress block.
@@ -161,12 +164,13 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 
 		mutex_lock(&msblk->read_data_mutex);
 
-		msblk->stream.avail_out = 0;
-		msblk->stream.avail_in = 0;
+		req.avail_out = 0;
+		req.avail_in = 0;
 
 		bytes = length;
+		length = 0;
 		do {
-			if (msblk->stream.avail_in == 0 && k < b) {
+			if (req.avail_in == 0 && k < b) {
 				avail = min(bytes, msblk->devblksize - offset);
 				bytes -= avail;
 				wait_on_buffer(bh[k]);
@@ -179,50 +183,57 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 					continue;
 				}
 
-				msblk->stream.next_in = bh[k]->b_data + offset;
-				msblk->stream.avail_in = avail;
+				req.next_in = bh[k]->b_data + offset;
+				req.avail_in = avail;
 				offset = 0;
 			}
 
-			if (msblk->stream.avail_out == 0) {
-				msblk->stream.next_out = buffer[page++];
-				msblk->stream.avail_out = PAGE_CACHE_SIZE;
+			if (req.avail_out == 0) {
+				req.next_out = buffer[page++];
+				req.avail_out = PAGE_CACHE_SIZE;
 			}
 
-			if (!zlib_init) {
-				zlib_err = zlib_inflateInit(&msblk->stream);
-				if (zlib_err != Z_OK) {
-					ERROR("zlib_inflateInit returned"
-						" unexpected result 0x%x,"
-						" srclength %d\n", zlib_err,
-						srclength);
+			if (!decomp_init) {
+				error = crypto_pcomp_decompress_init(msblk->tfm);
+				if (error) {
+					ERROR("crypto_pcomp_decompress_init "
+						"returned %d, srclength %d\n",
+						error, srclength);
 					goto release_mutex;
 				}
-				zlib_init = 1;
+				decomp_init = 1;
+			}
+
+			produced = req.avail_out;
+			error = crypto_pcomp_decompress_update(msblk->tfm,
+							       &req);
+			if (error) {
+				ERROR("crypto_pcomp_decompress_update "
+					"returned %d, srclength %d, avail_in "
+					"%d, avail_out %d\n", error, srclength,
+					req.avail_in, req.avail_out);
+				goto release_mutex;
 			}
+			produced -= req.avail_out;
 
-			zlib_err = zlib_inflate(&msblk->stream, Z_NO_FLUSH);
+			length += produced;
 
-			if (msblk->stream.avail_in == 0 && k < b)
+			if (req.avail_in == 0 && k < b)
 				put_bh(bh[k++]);
-		} while (zlib_err == Z_OK);
-
-		if (zlib_err != Z_STREAM_END) {
-			ERROR("zlib_inflate returned unexpected result"
-				" 0x%x, srclength %d, avail_in %d,"
-				" avail_out %d\n", zlib_err, srclength,
-				msblk->stream.avail_in,
-				msblk->stream.avail_out);
-			goto release_mutex;
-		}
 
-		zlib_err = zlib_inflateEnd(&msblk->stream);
-		if (zlib_err != Z_OK) {
-			ERROR("zlib_inflateEnd returned unexpected result 0x%x,"
-				" srclength %d\n", zlib_err, srclength);
+		} while (bytes || produced);
+
+		produced = req.avail_out;
+		error = crypto_pcomp_decompress_final(msblk->tfm, &req);
+		if (error) {
+			ERROR("crypto_pcomp_decompress_final returned %d, "
+				"srclength %d\n", error, srclength);
 			goto release_mutex;
 		}
-		length = msblk->stream.total_out;
+		produced -= req.avail_out;
+
+		length += produced;
+
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
 		/*
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index c8c6561..4eae75b 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -64,7 +64,7 @@ struct squashfs_sb_info {
 	struct mutex		read_data_mutex;
 	struct mutex		meta_index_mutex;
 	struct meta_index	*meta_index;
-	z_stream		stream;
+	struct crypto_pcomp	*tfm;
 	__le64			*inode_lookup_table;
 	u64			inode_table;
 	u64			directory_table;
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index a0466d7..e6c4a1b 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -36,11 +36,17 @@
 #include <linux/module.h>
 #include <linux/zlib.h>
 
+#include <crypto/compress.h>
+
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
 
+
+#define SQUASHFS_CRYPTO_ALG	"deflate"
+
+
 static struct file_system_type squashfs_fs_type;
 static struct super_operations squashfs_super_ops;
 
@@ -74,6 +80,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned short flags;
 	unsigned int fragments;
 	u64 lookup_table_start;
+	struct deflate_comp_params params;
 	int err;
 
 	TRACE("Entered squashfs_fill_superblock\n");
@@ -85,16 +92,29 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	msblk = sb->s_fs_info;
 
-	msblk->stream.workspace = kmalloc(zlib_inflate_workspacesize(),
-		GFP_KERNEL);
-	if (msblk->stream.workspace == NULL) {
-		ERROR("Failed to allocate zlib workspace\n");
+	msblk->tfm = crypto_alloc_pcomp(SQUASHFS_CRYPTO_ALG, 0,
+					CRYPTO_ALG_ASYNC);
+	if (IS_ERR(msblk->tfm)) {
+		ERROR("Failed to load %s crypto module\n",
+		      SQUASHFS_CRYPTO_ALG);
+		msblk->tfm = NULL;
+		err = -ENOMEM;
+		goto failure;
+	}
+
+	params.enable_comp = 0;
+	params.enable_decomp = 1;
+	params.windowBits = DEF_WBITS;
+	err = crypto_pcomp_setup(msblk->tfm, &params);
+	if (err) {
+		ERROR("Failed to set up decompression parameters\n");
 		goto failure;
 	}
 
 	sblk = kzalloc(sizeof(*sblk), GFP_KERNEL);
 	if (sblk == NULL) {
 		ERROR("Failed to allocate squashfs_super_block\n");
+		err = -ENOMEM;
 		goto failure;
 	}
 
@@ -283,17 +303,17 @@ failed_mount:
 	kfree(msblk->inode_lookup_table);
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
-	kfree(msblk->stream.workspace);
+	crypto_free_pcomp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 	kfree(sblk);
 	return err;
 
 failure:
-	kfree(msblk->stream.workspace);
+	crypto_free_pcomp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
-	return -ENOMEM;
+	return err;
 }
 
 
@@ -332,7 +352,7 @@ static void squashfs_put_super(struct super_block *sb)
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
 		kfree(sbi->meta_index);
-		kfree(sbi->stream.workspace);
+		crypto_free_pcomp(sbi->tfm);
 		kfree(sb->s_fs_info);
 		sb->s_fs_info = NULL;
 	}
-- 
1.6.0.4


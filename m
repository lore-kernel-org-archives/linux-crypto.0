From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 4/4] squashfs: Make SquashFS 4 use the new "zlib" crypto
 module
Date: Mon, 24 Nov 2008 17:14:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811241713290.9844@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
 <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au>
 <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
 <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
 <Pine.LNX.4.64.0811241712390.9844@vixen.sonytel.be>
 <Pine.LNX.4.64.0811241713070.9844@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51183 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752989AbYKXQOJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 11:14:09 -0500
In-Reply-To: <Pine.LNX.4.64.0811241713070.9844@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify SquashFS 4 to use the new "zlib" crypto module as a proof-of-con=
cept for
the partial decompression CRYPTO API enhancements.

Note: Patch against squashfs-2.6.git, as SquashFS is not yet in mainlin=
e

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 Kconfig                   |    3 +-
 squashfs/block.c          |   67 +++++++++++++++++++++++++++----------=
---------
 squashfs/squashfs_fs_sb.h |    4 ++
 squashfs/super.c          |   20 ++++++++-----
 4 files changed, 58 insertions(+), 36 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 1d7a5f9..8eebe53 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -934,7 +934,8 @@ config CRAMFS
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
 	depends on BLOCK
-	select ZLIB_INFLATE
+	select CRYPTO
+	select CRYPTO_ZLIB
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index da5f88b..9a681cb 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -32,7 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
-#include <linux/zlib.h>
+#include <linux/crypto.h>
=20
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -150,7 +150,8 @@ int squashfs_read_data(struct super_block *sb, void=
 *buffer,
 	}
=20
 	if (compressed) {
-		int zlib_err =3D 0;
+		int error =3D 0;
+		struct comp_request req;
=20
 		/*
 		 * Uncompress block.
@@ -158,8 +159,8 @@ int squashfs_read_data(struct super_block *sb, void=
 *buffer,
=20
 		mutex_lock(&msblk->read_data_mutex);
=20
-		msblk->stream.next_out =3D buffer;
-		msblk->stream.avail_out =3D srclength;
+		req.next_out =3D buffer;
+		req.avail_out =3D srclength;
=20
 		for (bytes =3D 0; k < b; k++) {
 			avail =3D min(c_byte - bytes, msblk->devblksize - offset);
@@ -168,16 +169,19 @@ int squashfs_read_data(struct super_block *sb, vo=
id *buffer,
 			if (!buffer_uptodate(bh[k]))
 				goto release_mutex;
=20
-			msblk->stream.next_in =3D bh[k]->b_data + offset;
-			msblk->stream.avail_in =3D avail;
+			req.next_in =3D bh[k]->b_data + offset;
+			req.avail_in =3D avail;
=20
 			if (k =3D=3D 0) {
-				zlib_err =3D zlib_inflateInit(&msblk->stream);
-				if (zlib_err !=3D Z_OK) {
-					ERROR("zlib_inflateInit returned"
-						" unexpected result 0x%x,"
-						" srclength %d\n", zlib_err,
-						srclength);
+				error =3D crypto_comp_decompress_init(msblk->tfm,
+								    &req);
+				if (error && error !=3D -EAGAIN) {
+					ERROR("crypto_comp_decompress_init "
+					      "returned unexpected result %d, "
+					      "srclength %d, avail_in %u, "
+					      "avail_out %u\n",
+					      error, srclength, req.avail_in,
+					      req.avail_out);
 					goto release_mutex;
 				}
=20
@@ -186,15 +190,25 @@ int squashfs_read_data(struct super_block *sb, vo=
id *buffer,
 					brelse(bh[k]);
 					continue;
 				}
+
+			} else {
+				error =3D crypto_comp_decompress_update(msblk->tfm,
+								      &req);
+				if (error) {
+					ERROR("crypto_comp_decompress_update "
+					      "returned unexpected result %d, "
+					      "srclength %d, avail_in %u, "
+					      "avail_out %u\n",
+					      error, srclength, req.avail_in,
+					      req.avail_out);
+					goto release_mutex;
+				}
 			}
=20
-			zlib_err =3D zlib_inflate(&msblk->stream, Z_NO_FLUSH);
-			if (zlib_err !=3D Z_OK && zlib_err !=3D Z_STREAM_END) {
-				ERROR("zlib_inflate returned unexpected result"
-					" 0x%x, srclength %d, avail_in %d,"
-					" avail_out %d\n", zlib_err, srclength,
-					msblk->stream.avail_in,
-					msblk->stream.avail_out);
+			if (req.avail_in) {
+				ERROR("crypto_comp_decompress_* did not "
+				      "consume all input data (%u left)\n",
+				      req.avail_in);
 				goto release_mutex;
 			}
=20
@@ -203,16 +217,15 @@ int squashfs_read_data(struct super_block *sb, vo=
id *buffer,
 			brelse(bh[k]);
 		}
=20
-		if (zlib_err !=3D Z_STREAM_END)
-			goto release_mutex;
-
-		zlib_err =3D zlib_inflateEnd(&msblk->stream);
-		if (zlib_err !=3D Z_OK) {
-			ERROR("zlib_inflateEnd returned unexpected result 0x%x,"
-				" srclength %d\n", zlib_err, srclength);
+		error =3D crypto_comp_decompress_final(msblk->tfm, &req);
+		if (error) {
+			ERROR("crypto_comp_decompress_final returned "
+			      "unexpected result %d, srclength %d, avail_in "
+			      "%u, avail_out %u\n",
+			      error, srclength, req.avail_in, req.avail_out);
 			goto release_mutex;
 		}
-		bytes =3D msblk->stream.total_out;
+		bytes =3D req.next_out - buffer;
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
 		/*
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.=
h
index 18e5af4..769bbef 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -23,6 +23,8 @@
  * squashfs_fs_sb.h
  */
=20
+#include <linux/crypto.h>
+
 #include "squashfs_fs.h"
=20
 struct squashfs_cache_entry {
@@ -63,7 +65,7 @@ struct squashfs_sb_info {
 	struct mutex		read_data_mutex;
 	struct mutex		meta_index_mutex;
 	struct meta_index	*meta_index;
-	z_stream		stream;
+	struct crypto_comp	*tfm;
 	__le64			*inode_lookup_table;
 	long long		inode_table;
 	long long		directory_table;
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 44f94aa..38e0535 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -35,13 +35,17 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/zlib.h>
+#include <linux/crypto.h>
=20
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
=20
+
+#define SQUASHFS_CRYPTO_ALG	"zlib"
+
+
 static struct file_system_type squashfs_fs_type;
 static struct super_operations squashfs_super_ops;
=20
@@ -86,9 +90,11 @@ static int squashfs_fill_super(struct super_block *s=
b, void *data, int silent)
 	}
 	msblk =3D sb->s_fs_info;
=20
-	msblk->stream.workspace =3D vmalloc(zlib_inflate_workspacesize());
-	if (msblk->stream.workspace =3D=3D NULL) {
-		ERROR("Failed to allocate zlib workspace\n");
+	msblk->tfm =3D crypto_alloc_comp(SQUASHFS_CRYPTO_ALG, 0,
+				       CRYPTO_ALG_ASYNC);
+	if (IS_ERR(msblk->tfm)) {
+		ERROR("Failed to load %s crypto module\n", SQUASHFS_CRYPTO_ALG);
+		msblk->tfm =3D NULL;
 		goto failure;
 	}
=20
@@ -284,14 +290,14 @@ failed_mount:
 	kfree(msblk->inode_lookup_table);
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
-	vfree(msblk->stream.workspace);
+	crypto_free_comp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info =3D NULL;
 	kfree(sblk);
 	return err;
=20
 failure:
-	vfree(msblk->stream.workspace);
+	crypto_free_comp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info =3D NULL;
 	return -ENOMEM;
@@ -333,7 +339,7 @@ static void squashfs_put_super(struct super_block *=
sb)
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
 		kfree(sbi->meta_index);
-		vfree(sbi->stream.workspace);
+		crypto_free_comp(sbi->tfm);
 		kfree(sb->s_fs_info);
 		sb->s_fs_info =3D NULL;
 	}

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

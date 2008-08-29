From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 3/3] squashfs: Switch from zlib/inflate to "zlib" crypto module
Date: Fri, 29 Aug 2008 15:42:01 +0200
Message-ID: <20080829134419.000609936@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33850 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756758AbYH2Noo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2008 09:44:44 -0400
Content-Disposition: inline; filename=crypto/squashfs-use-crypto-api-for-orig.diff
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Modify SquashFS 3.4 to use the "zlib" crypto module instead of making d=
irect
calls to the zlib/inflate library

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 fs/Kconfig                     |    3 +
 fs/squashfs/inode.c            |   65 +++++++++++++++++++++-----------=
---------
 include/linux/squashfs_fs_sb.h |    3 +
 3 files changed, 38 insertions(+), 33 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1350,7 +1350,8 @@ config CRAMFS
=20
 config SQUASHFS
 	tristate "SquashFS 3.4 - Squashed file system support"
-	select ZLIB_INFLATE
+	select CRYPTO
+	select CRYPTO_ZLIB
 	help
 	  Saying Y here includes support for SquashFS 3.4 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -23,7 +23,6 @@
=20
 #include <linux/squashfs_fs.h>
 #include <linux/module.h>
-#include <linux/zlib.h>
 #include <linux/fs.h>
 #include <linux/squashfs_fs_sb.h>
 #include <linux/squashfs_fs_i.h>
@@ -36,6 +35,9 @@
=20
 #include "squashfs.h"
=20
+#define SQUASHFS_CRYPTO_ALG	"zlib"
+
+
 static struct dentry *squashfs_fh_to_dentry(struct super_block *s,
 		struct fid *fid, int fh_len, int fh_type);
 static struct dentry *squashfs_fh_to_parent(struct super_block *s,
@@ -236,7 +238,10 @@ SQSH_EXTERN unsigned int squashfs_read_d
 	}
=20
 	if (compressed) {
-		int zlib_err =3D 0;
+		int error =3D 0;
+		void *next_out;
+		int avail_out;
+		unsigned int total_out =3D 0, dlen;
=20
 		/*
 	 	* uncompress block
@@ -244,8 +249,8 @@ SQSH_EXTERN unsigned int squashfs_read_d
=20
 		mutex_lock(&msblk->read_data_mutex);
=20
-		msblk->stream.next_out =3D buffer;
-		msblk->stream.avail_out =3D srclength;
+		next_out =3D buffer;
+		avail_out =3D srclength;
=20
 		for (bytes =3D 0; k < b; k++) {
 			avail_bytes =3D min(c_byte - bytes, msblk->devblksize - offset);
@@ -254,16 +259,8 @@ SQSH_EXTERN unsigned int squashfs_read_d
 			if (!buffer_uptodate(bh[k]))
 				goto release_mutex;
=20
-			msblk->stream.next_in =3D bh[k]->b_data + offset;
-			msblk->stream.avail_in =3D avail_bytes;
-
 			if (k =3D=3D 0) {
-				zlib_err =3D zlib_inflateInit(&msblk->stream);
-				if (zlib_err !=3D Z_OK) {
-					ERROR("zlib_inflateInit returned unexpected result 0x%x,"
-						" srclength %d\n", zlib_err, srclength);
-					goto release_mutex;
-				}
+				total_out =3D 0;
=20
 				if (avail_bytes =3D=3D 0) {
 					offset =3D 0;
@@ -272,29 +269,32 @@ SQSH_EXTERN unsigned int squashfs_read_d
 				}
 			}
=20
-			zlib_err =3D zlib_inflate(&msblk->stream, Z_NO_FLUSH);
-			if (zlib_err !=3D Z_OK && zlib_err !=3D Z_STREAM_END) {
-				ERROR("zlib_inflate returned unexpected result 0x%x,"
-					" srclength %d, avail_in %d, avail_out %d\n", zlib_err,
-					srclength, msblk->stream.avail_in, msblk->stream.avail_out);
+			dlen =3D avail_out;
+			error =3D crypto_comp_decompress(msblk->tfm,
+						       bh[k]->b_data + offset,
+						       avail_bytes, next_out,
+						       &dlen);
+			if (error && error !=3D -EAGAIN) {
+				ERROR("crypto_comp_decompress returned "
+				      "unexpected result %d, srclength %d, "
+				      "avail_bytes %d, avail_out %d\n",
+				      error, srclength, avail_bytes,
+				      avail_out);
 				goto release_mutex;
 			}
+			next_out +=3D dlen;
+			avail_out -=3D dlen;
+			total_out +=3D dlen;
=20
 			bytes +=3D avail_bytes;
 			offset =3D 0;
 			brelse(bh[k]);
 		}
=20
-		if (zlib_err !=3D Z_STREAM_END)
+		if (error)
 			goto release_mutex;
=20
-		zlib_err =3D zlib_inflateEnd(&msblk->stream);
-		if (zlib_err !=3D Z_OK) {
-			ERROR("zlib_inflateEnd returned unexpected result 0x%x,"
-				" srclength %d\n", zlib_err, srclength);
-			goto release_mutex;
-		}
-		bytes =3D msblk->stream.total_out;
+		bytes =3D total_out;
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
 		int i;
@@ -1104,9 +1104,12 @@ static int squashfs_fill_super(struct su
 	}
 	msblk =3D s->s_fs_info;
=20
-	msblk->stream.workspace =3D vmalloc(zlib_inflate_workspacesize());
-	if (msblk->stream.workspace =3D=3D NULL) {
-		ERROR("Failed to allocate zlib workspace\n");
+	msblk->tfm =3D crypto_alloc_comp(SQUASHFS_CRYPTO_ALG, 0,
+				       CRYPTO_ALG_ASYNC);
+	if (IS_ERR(msblk->tfm)) {
+		ERROR("Failed to load %s crypto module\n",
+		      SQUASHFS_CRYPTO_ALG);
+		msblk->tfm =3D NULL;
 		goto failure;
 	}
 	sblk =3D &msblk->sblk;
@@ -1273,7 +1276,7 @@ failed_mount:
 	vfree(msblk->read_page);
 	squashfs_cache_delete(msblk->block_cache);
 	kfree(msblk->fragment_index_2);
-	vfree(msblk->stream.workspace);
+	crypto_free_comp(msblk->tfm);
 	kfree(s->s_fs_info);
 	s->s_fs_info =3D NULL;
 	return -EINVAL;
@@ -2084,7 +2087,7 @@ static void squashfs_put_super(struct su
 		kfree(sbi->fragment_index);
 		kfree(sbi->fragment_index_2);
 		kfree(sbi->meta_index);
-		vfree(sbi->stream.workspace);
+		crypto_free_comp(sbi->tfm);
 		kfree(s->s_fs_info);
 		s->s_fs_info =3D NULL;
 	}
--- a/include/linux/squashfs_fs_sb.h
+++ b/include/linux/squashfs_fs_sb.h
@@ -24,6 +24,7 @@
  */
=20
 #include <linux/squashfs_fs.h>
+#include <linux/crypto.h>
=20
 struct squashfs_cache_entry {
 	long long	block;
@@ -67,7 +68,7 @@ struct squashfs_sb_info {
 	struct mutex		read_page_mutex;
 	struct mutex		meta_index_mutex;
 	struct meta_index	*meta_index;
-	z_stream		stream;
+	struct crypto_comp	*tfm;
 	long long		*inode_lookup_table;
 	int			(*read_inode)(struct inode *i,  squashfs_inode_t \
 				inode);

--=20
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

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 8/8] squashfs: Make SquashFS 4 use the new pcomp crypto interface
Date: Wed, 17 Dec 2008 17:36:43 +0100
Message-ID: <20081217164036.910767182@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Phillip Lougher <phillip@lougher.demon.co.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65213 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752078AbYLQQmG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:06 -0500
Content-Disposition: inline; filename=squashfs-use-crypto-pcomp.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Modify SquashFS 4 to use the new "pcomp" crypto interface for decompres=
sion,
instead of calling the underlying zlib library directly. This simplifie=
s e.g.
the addition of support for hardware decompression and different decomp=
ression
algorithms.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/Kconfig                   |    3 +
 fs/squashfs/block.c          |   67 +++++++++++++++++++++++++---------=
---------
 fs/squashfs/squashfs_fs_sb.h |    2 -
 fs/squashfs/super.c          |   33 ++++++++++++++++-----
 4 files changed, 69 insertions(+), 36 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -934,7 +934,8 @@ config CRAMFS
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
 	depends on BLOCK
-	select ZLIB_INFLATE
+	select CRYPTO
+	select CRYPTO_DEFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
 	  Read-Only File System).  Squashfs is a highly compressed read-only
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
@@ -150,7 +150,8 @@ int squashfs_read_data(struct super_bloc
 	}
=20
 	if (compressed) {
-		int zlib_err =3D 0;
+		int error =3D 0;
+		struct comp_request req;
=20
 		/*
 		 * Uncompress block.
@@ -158,8 +159,8 @@ int squashfs_read_data(struct super_bloc
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
@@ -168,16 +169,19 @@ int squashfs_read_data(struct super_bloc
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
+				error =3D crypto_pcomp_decompress_init(msblk->tfm,
+								     &req);
+				if (error && error !=3D -EAGAIN) {
+					ERROR("crypto_pcomp_decompress_init "
+					      "returned unexpected result %d, "
+					      "srclength %d, avail_in %u, "
+					      "avail_out %u\n",
+					      error, srclength, req.avail_in,
+					      req.avail_out);
 					goto release_mutex;
 				}
=20
@@ -186,15 +190,25 @@ int squashfs_read_data(struct super_bloc
 					brelse(bh[k]);
 					continue;
 				}
+
+			} else {
+				error =3D crypto_pcomp_decompress_update(msblk->tfm,
+								       &req);
+				if (error) {
+					ERROR("crypto_pcomp_decompress_update "
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
+				ERROR("crypto_pcomp_decompress_* did not "
+				      "consume all input data (%u left)\n",
+				      req.avail_in);
 				goto release_mutex;
 			}
=20
@@ -203,16 +217,15 @@ int squashfs_read_data(struct super_bloc
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
+		error =3D crypto_pcomp_decompress_final(msblk->tfm, &req);
+		if (error) {
+			ERROR("crypto_pcomp_decompress_final returned "
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
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -63,7 +63,7 @@ struct squashfs_sb_info {
 	struct mutex		read_data_mutex;
 	struct mutex		meta_index_mutex;
 	struct meta_index	*meta_index;
-	z_stream		stream;
+	struct crypto_pcomp	*tfm;
 	__le64			*inode_lookup_table;
 	long long		inode_table;
 	long long		directory_table;
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -35,6 +35,7 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/crypto.h>
 #include <linux/zlib.h>
=20
 #include "squashfs_fs.h"
@@ -42,6 +43,10 @@
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
=20
+
+#define SQUASHFS_CRYPTO_ALG	"deflate"
+
+
 static struct file_system_type squashfs_fs_type;
 static struct super_operations squashfs_super_ops;
=20
@@ -75,6 +80,7 @@ static int squashfs_fill_super(struct su
 	unsigned short flags;
 	unsigned int fragments;
 	long long lookup_table_start;
+	struct deflate_comp_params params;
 	int err;
=20
 	TRACE("Entered squashfs_fill_superblock\n");
@@ -86,15 +92,28 @@ static int squashfs_fill_super(struct su
 	}
 	msblk =3D sb->s_fs_info;
=20
-	msblk->stream.workspace =3D vmalloc(zlib_inflate_workspacesize());
-	if (msblk->stream.workspace =3D=3D NULL) {
-		ERROR("Failed to allocate zlib workspace\n");
+	msblk->tfm =3D crypto_alloc_pcomp(SQUASHFS_CRYPTO_ALG, 0,
+					CRYPTO_ALG_ASYNC);
+	if (IS_ERR(msblk->tfm)) {
+		ERROR("Failed to load %s crypto module\n", SQUASHFS_CRYPTO_ALG);
+		msblk->tfm =3D NULL;
+		err =3D -ENOMEM;
+		goto failure;
+	}
+
+	params.enable_comp =3D 0;
+	params.enable_decomp =3D 1;
+	params.windowBits =3D DEF_WBITS;
+	err =3D crypto_pcomp_setup(msblk->tfm, &params);
+	if (err) {
+		ERROR("Failed to set up decompression parameters\n");
 		goto failure;
 	}
=20
 	sblk =3D kzalloc(sizeof(*sblk), GFP_KERNEL);
 	if (sblk =3D=3D NULL) {
 		ERROR("Failed to allocate squashfs_super_block\n");
+		err =3D -ENOMEM;
 		goto failure;
 	}
=20
@@ -284,17 +303,17 @@ failed_mount:
 	kfree(msblk->inode_lookup_table);
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
-	vfree(msblk->stream.workspace);
+	crypto_free_pcomp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info =3D NULL;
 	kfree(sblk);
 	return err;
=20
 failure:
-	vfree(msblk->stream.workspace);
+	crypto_free_pcomp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info =3D NULL;
-	return -ENOMEM;
+	return err;
 }
=20
=20
@@ -333,7 +352,7 @@ static void squashfs_put_super(struct su
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
 		kfree(sbi->meta_index);
-		vfree(sbi->stream.workspace);
+		crypto_free_pcomp(sbi->tfm);
 		kfree(sb->s_fs_info);
 		sb->s_fs_info =3D NULL;
 	}

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

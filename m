From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 6/6] squashfs: Make SquashFS 4 use the new pcomp crypto
 interface
Date: Tue, 17 Mar 2009 13:44:58 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0903171343500.7595@vixen.sonytel.be>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Phillip Lougher <phillip@lougher.demon.co.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40118 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753119AbZCQMpD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2009 08:45:03 -0400
In-Reply-To: <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 25 Feb 2009, Geert Uytterhoeven wrote:
> Modify SquashFS 4 to use the new "pcomp" crypto interface for decompr=
ession,
> instead of calling the underlying zlib library directly. This simplif=
ies e.g.
> the addition of support for hardware decompression and different deco=
mpression
> algorithms.

This is an updated patch, to accomodate for the recent changes in Squas=
hFS.
---
=46rom 46b8e0ab105e9b414d455c0a7205a7c79f0517e8 Mon Sep 17 00:00:00 200=
1
=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Thu, 18 Dec 2008 14:35:22 +0100
Subject: [PATCH] squashfs: Make SquashFS 4 use the new pcomp crypto int=
erface

Modify SquashFS 4 to use the new "pcomp" crypto interface for decompres=
sion,
instead of calling the underlying zlib library directly. This simplifie=
s e.g.
the addition of support for hardware decompression and different decomp=
ression
algorithms.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/Kconfig          |    3 +-
 fs/squashfs/block.c          |   70 ++++++++++++++++++++++++----------=
-------
 fs/squashfs/squashfs_fs_sb.h |    2 +-
 fs/squashfs/super.c          |   44 +++++++++++++++++++++-----
 4 files changed, 80 insertions(+), 39 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 25a00d1..18e33a6 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,7 +1,8 @@
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
index 2a79603..6196821 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -32,7 +32,8 @@
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
-#include <linux/zlib.h>
+
+#include <crypto/compress.h>
=20
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -153,7 +154,9 @@ int squashfs_read_data(struct super_block *sb, void=
 **buffer, u64 index,
 	}
=20
 	if (compressed) {
-		int zlib_err =3D 0, zlib_init =3D 0;
+		int error =3D 0, decomp_init =3D 0;
+		struct comp_request req;
+		unsigned int produced =3D 0;
=20
 		/*
 		 * Uncompress block.
@@ -161,12 +164,13 @@ int squashfs_read_data(struct super_block *sb, vo=
id **buffer, u64 index,
=20
 		mutex_lock(&msblk->read_data_mutex);
=20
-		msblk->stream.avail_out =3D 0;
-		msblk->stream.avail_in =3D 0;
+		req.avail_out =3D 0;
+		req.avail_in =3D 0;
=20
 		bytes =3D length;
+		length =3D 0;
 		do {
-			if (msblk->stream.avail_in =3D=3D 0 && k < b) {
+			if (req.avail_in =3D=3D 0 && k < b) {
 				avail =3D min(bytes, msblk->devblksize - offset);
 				bytes -=3D avail;
 				wait_on_buffer(bh[k]);
@@ -179,45 +183,53 @@ int squashfs_read_data(struct super_block *sb, vo=
id **buffer, u64 index,
 					continue;
 				}
=20
-				msblk->stream.next_in =3D bh[k]->b_data + offset;
-				msblk->stream.avail_in =3D avail;
+				req.next_in =3D bh[k]->b_data + offset;
+				req.avail_in =3D avail;
 				offset =3D 0;
 			}
=20
-			if (msblk->stream.avail_out =3D=3D 0 && page < pages) {
-				msblk->stream.next_out =3D buffer[page++];
-				msblk->stream.avail_out =3D PAGE_CACHE_SIZE;
+			if (req.avail_out =3D=3D 0 && page < pages) {
+				req.next_out =3D buffer[page++];
+				req.avail_out =3D PAGE_CACHE_SIZE;
 			}
=20
-			if (!zlib_init) {
-				zlib_err =3D zlib_inflateInit(&msblk->stream);
-				if (zlib_err !=3D Z_OK) {
-					ERROR("zlib_inflateInit returned"
-						" unexpected result 0x%x,"
-						" srclength %d\n", zlib_err,
-						srclength);
+			if (!decomp_init) {
+				error =3D crypto_decompress_init(msblk->tfm);
+				if (error) {
+					ERROR("crypto_decompress_init "
+						"returned %d, srclength %d\n",
+						error, srclength);
 					goto release_mutex;
 				}
-				zlib_init =3D 1;
+				decomp_init =3D 1;
+			}
+
+			produced =3D req.avail_out;
+			error =3D crypto_decompress_update(msblk->tfm, &req);
+			if (error) {
+				ERROR("crypto_decompress_update returned %d, "
+					"data probably corrupt\n", error);
+				goto release_mutex;
 			}
+			produced -=3D req.avail_out;
=20
-			zlib_err =3D zlib_inflate(&msblk->stream, Z_SYNC_FLUSH);
+			length +=3D produced;
=20
-			if (msblk->stream.avail_in =3D=3D 0 && k < b)
+			if (req.avail_in =3D=3D 0 && k < b)
 				put_bh(bh[k++]);
-		} while (zlib_err =3D=3D Z_OK);
+		} while (bytes || produced);
=20
-		if (zlib_err !=3D Z_STREAM_END) {
-			ERROR("zlib_inflate error, data probably corrupt\n");
+		produced =3D req.avail_out;
+		error =3D crypto_decompress_final(msblk->tfm, &req);
+		if (error) {
+			ERROR("crypto_decompress_final returned %d, data "
+				"probably corrupt\n", error);
 			goto release_mutex;
 		}
+		produced -=3D req.avail_out;
+
+		length +=3D produced;
=20
-		zlib_err =3D zlib_inflateEnd(&msblk->stream);
-		if (zlib_err !=3D Z_OK) {
-			ERROR("zlib_inflate error, data probably corrupt\n");
-			goto release_mutex;
-		}
-		length =3D msblk->stream.total_out;
 		mutex_unlock(&msblk->read_data_mutex);
 	} else {
 		/*
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.=
h
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
index 681ec0d..2b63f54 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -37,11 +37,19 @@
 #include <linux/zlib.h>
 #include <linux/magic.h>
=20
+#include <crypto/compress.h>
+
+#include <net/netlink.h>
+
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
@@ -75,6 +83,16 @@ static int squashfs_fill_super(struct super_block *s=
b, void *data, int silent)
 	unsigned short flags;
 	unsigned int fragments;
 	u64 lookup_table_start;
+	struct {
+		struct nlattr nla;
+		int val;
+	} params =3D {
+		.nla =3D {
+			.nla_len	=3D nla_attr_size(sizeof(int)),
+			.nla_type	=3D ZLIB_DECOMP_WINDOWBITS,
+		},
+		.val			=3D DEF_WBITS,
+	};
 	int err;
=20
 	TRACE("Entered squashfs_fill_superblock\n");
@@ -86,16 +104,25 @@ static int squashfs_fill_super(struct super_block =
*sb, void *data, int silent)
 	}
 	msblk =3D sb->s_fs_info;
=20
-	msblk->stream.workspace =3D kmalloc(zlib_inflate_workspacesize(),
-		GFP_KERNEL);
-	if (msblk->stream.workspace =3D=3D NULL) {
-		ERROR("Failed to allocate zlib workspace\n");
+	msblk->tfm =3D crypto_alloc_pcomp(SQUASHFS_CRYPTO_ALG, 0,
+					CRYPTO_ALG_ASYNC);
+	if (IS_ERR(msblk->tfm)) {
+		ERROR("Failed to load %s crypto module\n",
+		      SQUASHFS_CRYPTO_ALG);
+		err =3D PTR_ERR(msblk->tfm);
+		goto failed_pcomp;
+	}
+
+	err =3D crypto_decompress_setup(msblk->tfm, &params, sizeof(params));
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
@@ -284,17 +311,18 @@ failed_mount:
 	kfree(msblk->inode_lookup_table);
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
-	kfree(msblk->stream.workspace);
+	crypto_free_pcomp(msblk->tfm);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info =3D NULL;
 	kfree(sblk);
 	return err;
=20
 failure:
-	kfree(msblk->stream.workspace);
+	crypto_free_pcomp(msblk->tfm);
+failed_pcomp:
 	kfree(sb->s_fs_info);
 	sb->s_fs_info =3D NULL;
-	return -ENOMEM;
+	return err;
 }
=20
=20
@@ -333,7 +361,7 @@ static void squashfs_put_super(struct super_block *=
sb)
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
 		kfree(sbi->meta_index);
-		kfree(sbi->stream.workspace);
+		crypto_free_pcomp(sbi->tfm);
 		kfree(sb->s_fs_info);
 		sb->s_fs_info =3D NULL;
 	}
--=20
1.6.0.4


With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

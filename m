From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 2/2] zram: use crypto API to compress the page
Date: Thu, 13 Aug 2015 14:21:46 +0900
Message-ID: <20150813052146.GA459@swordfish>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1439432654-23322-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150813035113.GB17958@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36257 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbHMFVK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 01:21:10 -0400
Content-Disposition: inline
In-Reply-To: <20150813035113.GB17958@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Removed Herbert, David, Stephan not spam their mail boxes.


I'd rather investigate something like this. 

WARNING!!! NOT TESTED AT ALL! like for real... only compile tested.

RFC


define ZLIB backend the same way as we already do. and introduce
compression frontend ->flags field. backend that requires zstream
for read op will set it to ZCOMP_NEED_READ_STRM. zram checks this
flag in read() path and does slow zcomp_strm_find()/zcomp_strm_release()
if backend requires it; otherwise we have our fast "just decompress it"
path.


this is very ugly and quick. just as an idea at the moment.
I will return to this a bit later.


not-yet-signed-off-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>

---
 drivers/block/zram/Kconfig      |  12 ++++-
 drivers/block/zram/Makefile     |   1 +
 drivers/block/zram/zcomp.c      |  21 +++++++-
 drivers/block/zram/zcomp.h      |   9 +++-
 drivers/block/zram/zcomp_lz4.c  |   2 +-
 drivers/block/zram/zcomp_lzo.c  |   2 +-
 drivers/block/zram/zcomp_zlib.c | 115 ++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp_zlib.h |  17 ++++++
 drivers/block/zram/zram_drv.c   |  15 ++++--
 9 files changed, 184 insertions(+), 10 deletions(-)
 create mode 100644 drivers/block/zram/zcomp_zlib.c
 create mode 100644 drivers/block/zram/zcomp_zlib.h

diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 386ba3d..7afd2ac 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -23,4 +23,14 @@ config ZRAM_LZ4_COMPRESS
 	default n
 	help
 	  This option enables LZ4 compression algorithm support. Compression
-	  algorithm can be changed using `comp_algorithm' device attribute.
\ No newline at end of file
+	  algorithm can be changed using `comp_algorithm' device attribute.
+
+config ZRAM_ZLIB_COMPRESS
+	bool "Enable ZLIB algorithm support"
+	depends on ZRAM
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	default n
+	help
+	  This option enables ZLIB compression algorithm support. Compression
+	  algorithm can be changed using `comp_algorithm' device attribute.
diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index be0763f..0922f54 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -1,5 +1,6 @@
 zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
 
 zram-$(CONFIG_ZRAM_LZ4_COMPRESS) += zcomp_lz4.o
+zram-$(CONFIG_ZRAM_ZLIB_COMPRESS) += zcomp_zlib.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 965d1af..4f04186 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -19,6 +19,9 @@
 #ifdef CONFIG_ZRAM_LZ4_COMPRESS
 #include "zcomp_lz4.h"
 #endif
+#ifdef CONFIG_ZRAM_ZLIB_COMPRESS
+#include "zcomp_zlib.h"
+#endif
 
 /*
  * single zcomp_strm backend
@@ -48,6 +51,9 @@ static struct zcomp_backend *backends[] = {
 #ifdef CONFIG_ZRAM_LZ4_COMPRESS
 	&zcomp_lz4,
 #endif
+#ifdef CONFIG_ZRAM_ZLIB_COMPRESS
+	&zcomp_zlib,
+#endif
 	NULL
 };
 
@@ -313,10 +319,16 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 			zstrm->private);
 }
 
-int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src,
 		size_t src_len, unsigned char *dst)
 {
-	return comp->backend->decompress(src, src_len, dst);
+	void *private = NULL;
+
+	if (unlikely(zstrm))
+		private = zstrm->private;
+
+	return comp->backend->decompress(src, src_len, dst, private);
 }
 
 void zcomp_destroy(struct zcomp *comp)
@@ -354,5 +366,10 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 		kfree(comp);
 		return ERR_PTR(-ENOMEM);
 	}
+
+	/* FIXME quick dirty and ugly. ONLY for testing purposes */
+	if (sysfs_streq(compress, "zlib"))
+		comp->flags |= ZCOMP_NEED_READ_STRM;
+
 	return comp;
 }
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 46e2b9f..e3ac8d3 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -12,6 +12,8 @@
 
 #include <linux/mutex.h>
 
+#define ZCOMP_NEED_READ_STRM	(1 << 0)
+
 struct zcomp_strm {
 	/* compression/decompression buffer */
 	void *buffer;
@@ -31,7 +33,7 @@ struct zcomp_backend {
 			size_t *dst_len, void *private);
 
 	int (*decompress)(const unsigned char *src, size_t src_len,
-			unsigned char *dst);
+			unsigned char *dst, void *private);
 
 	void *(*create)(void);
 	void (*destroy)(void *private);
@@ -44,6 +46,8 @@ struct zcomp {
 	void *stream;
 	struct zcomp_backend *backend;
 
+	int flags;
+
 	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
 	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
 	bool (*set_max_streams)(struct zcomp *comp, int num_strm);
@@ -62,7 +66,8 @@ void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		const unsigned char *src, size_t *dst_len);
 
-int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src,
 		size_t src_len, unsigned char *dst);
 
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
diff --git a/drivers/block/zram/zcomp_lz4.c b/drivers/block/zram/zcomp_lz4.c
index f2afb7e..52c85f9 100644
--- a/drivers/block/zram/zcomp_lz4.c
+++ b/drivers/block/zram/zcomp_lz4.c
@@ -31,7 +31,7 @@ static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
 }
 
 static int zcomp_lz4_decompress(const unsigned char *src, size_t src_len,
-		unsigned char *dst)
+		unsigned char *dst, void *private)
 {
 	size_t dst_len = PAGE_SIZE;
 	/* return  : Success if return 0 */
diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
index da1bc47..11ba295 100644
--- a/drivers/block/zram/zcomp_lzo.c
+++ b/drivers/block/zram/zcomp_lzo.c
@@ -31,7 +31,7 @@ static int lzo_compress(const unsigned char *src, unsigned char *dst,
 }
 
 static int lzo_decompress(const unsigned char *src, size_t src_len,
-		unsigned char *dst)
+		unsigned char *dst, void *private)
 {
 	size_t dst_len = PAGE_SIZE;
 	int ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
diff --git a/drivers/block/zram/zcomp_zlib.c b/drivers/block/zram/zcomp_zlib.c
new file mode 100644
index 0000000..f9ddcd7
--- /dev/null
+++ b/drivers/block/zram/zcomp_zlib.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2015 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/zlib.h>
+
+#include "zcomp_zlib.h"
+
+#define ZLIB_COMPRESSION_LEVEL	3
+
+static void *zlib_create(void)
+{
+	z_stream *stream;
+	size_t size;
+
+	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
+	if (!stream)
+		return NULL;
+
+	size = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
+			zlib_inflate_workspacesize());
+	stream->workspace = vmalloc(size);
+	if (!stream->workspace) {
+		kfree(stream);
+		stream = NULL;
+	}
+
+	return stream;
+}
+
+static void zlib_destroy(void *private)
+{
+	z_stream *stream = private;
+
+	vfree(stream->workspace);
+	kfree(stream);
+}
+
+static int zlib_compress(const unsigned char *src, unsigned char *dst,
+		size_t *dst_len, void *private)
+{
+	z_stream *stream = private;
+	int err;
+
+	err = zlib_deflateInit(stream, ZLIB_COMPRESSION_LEVEL);
+	if (err != Z_OK)
+		goto out;
+
+	stream->next_in = src;
+	stream->avail_in = PAGE_SIZE;
+	stream->total_in = 0;
+	stream->next_out = dst;
+	stream->avail_out = PAGE_SIZE;
+	stream->total_out = 0;
+
+	err = zlib_deflate(stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto out;
+
+	err = zlib_deflateEnd(stream);
+	if (err != Z_OK)
+		goto out;
+
+	if (stream->total_out >= stream->total_in)
+		goto out;
+
+	*dst_len = stream->total_out;
+out:
+	return err == Z_OK ? 0 : err;
+}
+
+static int zlib_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, void *private)
+{
+	z_stream *stream = private;
+	int err;
+
+	err = zlib_inflateInit(stream);
+	if (err != Z_OK)
+		goto out;
+
+	stream->next_in = src;
+	stream->avail_in = src_len;
+	stream->total_in = 0;
+	stream->next_out = dst;
+	stream->avail_out = PAGE_SIZE;
+	stream->total_out = 0;
+
+	err = zlib_inflate(stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto out;
+
+	err = zlib_inflateEnd(stream);
+	if (err != Z_OK)
+		goto out;
+
+out:
+	return err == Z_OK ? 0 : err;
+}
+
+struct zcomp_backend zcomp_zlib = {
+	.compress = zlib_compress,
+	.decompress = zlib_decompress,
+	.create = zlib_create,
+	.destroy = zlib_destroy,
+	.name = "zlib",
+};
diff --git a/drivers/block/zram/zcomp_zlib.h b/drivers/block/zram/zcomp_zlib.h
new file mode 100644
index 0000000..d0e4fa0
--- /dev/null
+++ b/drivers/block/zram/zcomp_zlib.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2015 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_ZLIB_H_
+#define _ZCOMP_ZLIB_H_
+
+#include "zcomp.h"
+
+extern struct zcomp_backend zcomp_zlib;
+
+#endif /* _ZCOMP_ZLIB_H_ */
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b6fdafc..72b0b0f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -587,10 +587,19 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	}
 
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
-	if (size == PAGE_SIZE)
+	if (size == PAGE_SIZE) {
 		copy_page(mem, cmem);
-	else
-		ret = zcomp_decompress(zram->comp, cmem, size, mem);
+	} else {
+		struct zcomp_strm *zstrm = NULL;
+
+		if (unlikely(zram->comp->flags & ZCOMP_NEED_READ_STRM))
+			zstrm = zcomp_strm_find(zram->comp);
+
+		ret = zcomp_decompress(zram->comp, zstrm, cmem, size, mem);
+
+		if (unlikely(zstrm))
+			zcomp_strm_release(zram->comp, zstrm);
+	}
 	zs_unmap_object(meta->mem_pool, handle);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
-- 
2.5.0.234.gefc8a62

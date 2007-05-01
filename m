From: Richard Purdie <rpurdie@openedhand.com>
Subject: [PATCH 2/5] jffs2: Add LZO compression support to jffs2
Date: Tue, 01 May 2007 15:47:03 +0100
Message-ID: <1178030823.5883.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, herbert@gondor.apana.org.au
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Add LZO1X compression/decompression support to jffs2.

LZO's interface doesn't entirely match that required by jffs2 so a
buffer and memcpy is unavoidable.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
---
 fs/Kconfig            |   10 ++++
 fs/jffs2/Makefile     |    1 +
 fs/jffs2/compr.c      |    6 +++
 fs/jffs2/compr.h      |    7 +++-
 fs/jffs2/compr_lzo.c  |  110 +++++++++++++++++++++++++++++++++++++++++++++=
++++
 include/linux/jffs2.h |    1 +
 6 files changed, 134 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index a42f767..1645dfa 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1310,6 +1310,16 @@ config JFFS2_ZLIB
 =

           Say 'Y' if unsure.
 =

+config JFFS2_LZO
+	bool "JFFS2 LZO compression support" if JFFS2_COMPRESSION_OPTIONS
+	select LZO
+	depends on JFFS2_FS
+	default y
+        help
+          minilzo-based compression. Generally works better than Zlib.
+
+          Say 'Y' if unsure.
+
 config JFFS2_RTIME
 	bool "JFFS2 RTIME compression support" if JFFS2_COMPRESSION_OPTIONS
 	depends on JFFS2_FS
diff --git a/fs/jffs2/Makefile b/fs/jffs2/Makefile
index c32b241..60e5d49 100644
--- a/fs/jffs2/Makefile
+++ b/fs/jffs2/Makefile
@@ -17,4 +17,5 @@ jffs2-$(CONFIG_JFFS2_FS_POSIX_ACL)	+=3D acl.o
 jffs2-$(CONFIG_JFFS2_RUBIN)	+=3D compr_rubin.o
 jffs2-$(CONFIG_JFFS2_RTIME)	+=3D compr_rtime.o
 jffs2-$(CONFIG_JFFS2_ZLIB)	+=3D compr_zlib.o
+jffs2-$(CONFIG_JFFS2_LZO)	+=3D compr_lzo.o
 jffs2-$(CONFIG_JFFS2_SUMMARY)   +=3D summary.o
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index 485d065..6a23408 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -285,6 +285,9 @@ int __init jffs2_compressors_init(void)
         jffs2_rubinmips_init();
         jffs2_dynrubin_init();
 #endif
+#ifdef CONFIG_JFFS2_LZO
+        jffs2_lzo_init();
+#endif
 /* Setting default compression mode */
 #ifdef CONFIG_JFFS2_CMODE_NONE
         jffs2_compression_mode =3D JFFS2_COMPR_MODE_NONE;
@@ -303,6 +306,9 @@ int __init jffs2_compressors_init(void)
 int jffs2_compressors_exit(void)
 {
 /* Unregistering compressors */
+#ifdef CONFIG_JFFS2_LZO
+        jffs2_lzo_exit();
+#endif
 #ifdef CONFIG_JFFS2_RUBIN
         jffs2_dynrubin_exit();
         jffs2_rubinmips_exit();
diff --git a/fs/jffs2/compr.h b/fs/jffs2/compr.h
index 68cc701..8c6b2af 100644
--- a/fs/jffs2/compr.h
+++ b/fs/jffs2/compr.h
@@ -27,9 +27,10 @@
 #define JFFS2_RUBINMIPS_PRIORITY 10
 #define JFFS2_DYNRUBIN_PRIORITY  20
 #define JFFS2_LZARI_PRIORITY     30
-#define JFFS2_LZO_PRIORITY       40
 #define JFFS2_RTIME_PRIORITY     50
 #define JFFS2_ZLIB_PRIORITY      60
+#define JFFS2_LZO_PRIORITY       80
+
 =

 #define JFFS2_RUBINMIPS_DISABLED /* RUBINs will be used only */
 #define JFFS2_DYNRUBIN_DISABLED  /*        for decompression */
@@ -90,5 +91,9 @@ void jffs2_rtime_exit(void);
 int jffs2_zlib_init(void);
 void jffs2_zlib_exit(void);
 #endif
+#ifdef CONFIG_JFFS2_LZO
+int jffs2_lzo_init(void);
+void jffs2_lzo_exit(void);
+#endif
 =

 #endif /* __JFFS2_COMPR_H__ */
diff --git a/fs/jffs2/compr_lzo.c b/fs/jffs2/compr_lzo.c
new file mode 100644
index 0000000..6396682
--- /dev/null
+++ b/fs/jffs2/compr_lzo.c
@@ -0,0 +1,110 @@
+/*
+ * JFFS2 -- Journalling Flash File System, Version 2.
+ *
+ * LZO Compression Interface
+ *
+ * Copyright =A9 2007 Nokia Corporation. All rights reserved.
+ *
+ * Created by Richard Purdie <rpurdie@openedhand.com>
+ *
+ * For licensing information, see the file 'LICENCE' in this directory.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/init.h>
+#include <linux/lzo.h>
+#include "compr.h"
+
+static void *lzo_mem;
+static void *lzo_compress_buf;
+static DEFINE_MUTEX(deflate_mutex);
+
+static void free_workspace(void)
+{
+	vfree(lzo_mem);
+	vfree(lzo_compress_buf);
+}
+
+static int __init alloc_workspace(void)
+{
+	lzo_mem =3D vmalloc(LZO1X_MEM_COMPRESS);
+	lzo_compress_buf =3D vmalloc(lzo1x_worst_compress(PAGE_SIZE));
+
+	if (!lzo_mem || !lzo_compress_buf) {
+		printk(KERN_WARNING "Failed to allocate lzo deflate workspace\n");
+		free_workspace();
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int jffs2_lzo_compress(unsigned char *data_in, unsigned char *cpage=
_out,
+			      uint32_t *sourcelen, uint32_t *dstlen, void *model)
+{
+	unsigned long compress_size;
+	int ret;
+
+	mutex_lock(&deflate_mutex);
+	ret =3D lzo1x_1_compress(data_in, *sourcelen, lzo_compress_buf, &compress=
_size, lzo_mem);
+	mutex_unlock(&deflate_mutex);
+
+	if (ret !=3D LZO_E_OK)
+		return -1;
+
+	if (compress_size > *dstlen)
+		return -1;
+
+	memcpy(cpage_out, lzo_compress_buf, compress_size);
+	*dstlen =3D compress_size;
+
+	return 0;
+}
+
+static int jffs2_lzo_decompress(unsigned char *data_in, unsigned char *cpa=
ge_out,
+				 uint32_t srclen, uint32_t destlen, void *model)
+{
+	unsigned long dl =3D destlen;
+	int ret;
+
+	ret =3D lzo1x_decompress_safe(data_in, srclen, cpage_out, &dl, NULL);
+
+	if (ret !=3D LZO_E_OK || dl !=3D destlen)
+		return -1;
+
+	return 0;
+}
+
+static struct jffs2_compressor jffs2_lzo_comp =3D {
+	.priority =3D JFFS2_LZO_PRIORITY,
+	.name =3D "lzo",
+	.compr =3D JFFS2_COMPR_LZO,
+	.compress =3D &jffs2_lzo_compress,
+	.decompress =3D &jffs2_lzo_decompress,
+	.disabled =3D 0,
+};
+
+int __init jffs2_lzo_init(void)
+{
+	int ret;
+
+	ret =3D alloc_workspace();
+	if (ret < 0)
+		return ret;
+
+	ret =3D jffs2_register_compressor(&jffs2_lzo_comp);
+	if (ret)
+		free_workspace();
+
+	return ret;
+}
+
+void jffs2_lzo_exit(void)
+{
+	jffs2_unregister_compressor(&jffs2_lzo_comp);
+	free_workspace();
+}
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 840631f..6b563ca 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -46,6 +46,7 @@
 #define JFFS2_COMPR_COPY	0x04
 #define JFFS2_COMPR_DYNRUBIN	0x05
 #define JFFS2_COMPR_ZLIB	0x06
+#define JFFS2_COMPR_LZO		0x07
 /* Compatibility flags. */
 #define JFFS2_COMPAT_MASK 0xc000      /* What do to if an unknown nodetype=
 is found */
 #define JFFS2_NODE_ACCURATE 0x2000




______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 9/9] pstore: Use crypto_comp_zbufsize()
Date: Thu,  2 Aug 2018 14:51:18 -0700
Message-ID: <20180802215118.17752-10-keescook@chromium.org>
References: <20180802215118.17752-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802215118.17752-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that the crypto compression API has a zbufsize interface, use that
instead, so pstore doesn't need to keep getting updated for each new
compression algo that gets added to the kernel. This reorganizes the
code slightly at initialization time (since we must allocate the algo
first now), but otherwise is a massive cleanup of the code, making
pstore kernel code algorithm-agnostic now.

The Kconfig is also adjusted to continue to provide build-time "default
algorithm" selection while minimizing what is needed when new algorithms
are added.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/Kconfig    |  91 +++++++----------------
 fs/pstore/inode.c    |   2 -
 fs/pstore/internal.h |   3 -
 fs/pstore/platform.c | 171 +++++++++----------------------------------
 4 files changed, 61 insertions(+), 206 deletions(-)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 09c19ef91526..1010304e0996 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -1,6 +1,5 @@
 config PSTORE
 	tristate "Persistent store support"
-	select CRYPTO if PSTORE_COMPRESS
 	default n
 	help
 	   This option enables generic access to platform level
@@ -13,88 +12,54 @@ config PSTORE
 	   If you don't have a platform persistent store driver,
 	   say N.
 
-config PSTORE_DEFLATE_COMPRESS
-	tristate "DEFLATE (ZLIB) compression"
-	default y
-	depends on PSTORE
-	select CRYPTO_DEFLATE
-	help
-	  This option enables DEFLATE (also known as ZLIB) compression
-	  algorithm support.
-
-config PSTORE_LZO_COMPRESS
-	tristate "LZO compression"
-	depends on PSTORE
-	select CRYPTO_LZO
-	help
-	  This option enables LZO compression algorithm support.
-
-config PSTORE_LZ4_COMPRESS
-	tristate "LZ4 compression"
-	depends on PSTORE
-	select CRYPTO_LZ4
-	help
-	  This option enables LZ4 compression algorithm support.
-
-config PSTORE_LZ4HC_COMPRESS
-	tristate "LZ4HC compression"
-	depends on PSTORE
-	select CRYPTO_LZ4HC
-	help
-	  This option enables LZ4HC (high compression) mode algorithm.
-
-config PSTORE_842_COMPRESS
-	bool "842 compression"
-	depends on PSTORE
-	select CRYPTO_842
-	help
-	  This option enables 842 compression algorithm support.
-
 config PSTORE_COMPRESS
-	def_bool y
+	bool "Perform compression on pstore records"
 	depends on PSTORE
-	depends on PSTORE_DEFLATE_COMPRESS || PSTORE_LZO_COMPRESS ||	\
-		   PSTORE_LZ4_COMPRESS || PSTORE_LZ4HC_COMPRESS ||	\
-		   PSTORE_842_COMPRESS
+	default y
+	select CRYPTO
+	help
+	  Normally, pstore will store records uncompressed. However,
+	  since some backends have limited storage and records can get
+	  long, it may be more efficient to have pstore compress the
+	  records. Enabling this feature will enable compression
+	  support.
 
 choice
 	prompt "Default pstore compression algorithm"
 	depends on PSTORE_COMPRESS
 	help
 	  This option chooses the default active compression algorithm.
-	  This change be changed at boot with "pstore.compress=..." on
-	  the kernel command line.
-
-	  Currently, pstore has support for 5 compression algorithms:
-	  deflate, lzo, lz4, lz4hc and 842.
+	  Selecting "None" means an algorithm must be chosen on the
+	  kernel command line via "pstore.compress=..."
 
-	  The default compression algorithm is deflate.
+	config PSTORE_COMPRESS_DEFAULT_DEFLATE
+		bool "deflate" if CRYPTO_DEFLATE
 
-	config PSTORE_DEFLATE_COMPRESS_DEFAULT
-		bool "deflate" if PSTORE_DEFLATE_COMPRESS
+	config PSTORE_COMPRESS_DEFAULT_LZO
+		bool "lzo" if CRYPTO_LZO
 
-	config PSTORE_LZO_COMPRESS_DEFAULT
-		bool "lzo" if PSTORE_LZO_COMPRESS
+	config PSTORE_COMPRESS_DEFAULT_LZ4
+		bool "lz4" if CRYPTO_LZ4
 
-	config PSTORE_LZ4_COMPRESS_DEFAULT
-		bool "lz4" if PSTORE_LZ4_COMPRESS
+	config PSTORE_COMPRESS_DEFAULT_LZ4HC
+		bool "lz4hc" if CRYPTO_LZ4HC
 
-	config PSTORE_LZ4HC_COMPRESS_DEFAULT
-		bool "lz4hc" if PSTORE_LZ4HC_COMPRESS
+	config PSTORE_COMPRESS_DEFAULT_842
+		bool "842" if CRYPTO_842
 
-	config PSTORE_842_COMPRESS_DEFAULT
-		bool "842" if PSTORE_842_COMPRESS
+	config PSTORE_COMPRESS_DEFAULT_NONE
+		bool "None"
 
 endchoice
 
 config PSTORE_COMPRESS_DEFAULT
 	string
 	depends on PSTORE_COMPRESS
-	default "deflate" if PSTORE_DEFLATE_COMPRESS_DEFAULT
-	default "lzo" if PSTORE_LZO_COMPRESS_DEFAULT
-	default "lz4" if PSTORE_LZ4_COMPRESS_DEFAULT
-	default "lz4hc" if PSTORE_LZ4HC_COMPRESS_DEFAULT
-	default "842" if PSTORE_842_COMPRESS_DEFAULT
+	default "deflate" if PSTORE_COMPRESS_DEFAULT_DEFLATE
+	default "lzo" if PSTORE_COMPRESS_DEFAULT_LZO
+	default "lz4" if PSTORE_COMPRESS_DEFAULT_LZ4
+	default "lz4hc" if PSTORE_COMPRESS_DEFAULT_LZ4HC
+	default "842" if PSTORE_COMPRESS_DEFAULT_842
 
 config PSTORE_CONSOLE
 	bool "Log kernel console messages"
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 5fcb845b9fec..d814723fb27d 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -486,8 +486,6 @@ static int __init init_pstore_fs(void)
 {
 	int err;
 
-	pstore_choose_compression();
-
 	/* Create a convenient mount point for people to access pstore */
 	err = sysfs_create_mount_point(fs_kobj, "pstore");
 	if (err)
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index fb767e28aeb2..c029314478fa 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -37,7 +37,4 @@ extern bool	pstore_is_mounted(void);
 extern void	pstore_record_init(struct pstore_record *record,
 				   struct pstore_info *psi);
 
-/* Called during module_init() */
-extern void __init pstore_choose_compression(void);
-
 #endif
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index c238ab8ba31d..eca7588afa92 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -28,12 +28,6 @@
 #include <linux/console.h>
 #include <linux/module.h>
 #include <linux/pstore.h>
-#if IS_ENABLED(CONFIG_PSTORE_LZO_COMPRESS)
-#include <linux/lzo.h>
-#endif
-#if IS_ENABLED(CONFIG_PSTORE_LZ4_COMPRESS) || IS_ENABLED(CONFIG_PSTORE_LZ4HC_COMPRESS)
-#include <linux/lz4.h>
-#endif
 #include <linux/crypto.h>
 #include <linux/string.h>
 #include <linux/timer.h>
@@ -82,13 +76,8 @@ static char *compress =
 /* Compression parameters */
 static struct crypto_comp *tfm;
 
-struct pstore_zbackend {
-	int (*zbufsize)(size_t size);
-	const char *name;
-};
-
 static char *big_oops_buf;
-static size_t big_oops_buf_sz;
+static unsigned int big_oops_buf_sz;
 
 /* How much of the console log to snapshot */
 unsigned long kmsg_bytes = PSTORE_DEFAULT_KMSG_BYTES;
@@ -142,92 +131,6 @@ bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
 }
 EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
 
-#if IS_ENABLED(CONFIG_PSTORE_DEFLATE_COMPRESS)
-static int zbufsize_deflate(size_t size)
-{
-	size_t cmpr;
-
-	switch (size) {
-	/* buffer range for efivars */
-	case 1000 ... 2000:
-		cmpr = 56;
-		break;
-	case 2001 ... 3000:
-		cmpr = 54;
-		break;
-	case 3001 ... 3999:
-		cmpr = 52;
-		break;
-	/* buffer range for nvram, erst */
-	case 4000 ... 10000:
-		cmpr = 45;
-		break;
-	default:
-		cmpr = 60;
-		break;
-	}
-
-	return (size * 100) / cmpr;
-}
-#endif
-
-#if IS_ENABLED(CONFIG_PSTORE_LZO_COMPRESS)
-static int zbufsize_lzo(size_t size)
-{
-	return lzo1x_worst_compress(size);
-}
-#endif
-
-#if IS_ENABLED(CONFIG_PSTORE_LZ4_COMPRESS) || IS_ENABLED(CONFIG_PSTORE_LZ4HC_COMPRESS)
-static int zbufsize_lz4(size_t size)
-{
-	return LZ4_compressBound(size);
-}
-#endif
-
-#if IS_ENABLED(CONFIG_PSTORE_842_COMPRESS)
-static int zbufsize_842(size_t size)
-{
-	return size;
-}
-#endif
-
-static const struct pstore_zbackend *zbackend __ro_after_init;
-
-static const struct pstore_zbackend zbackends[] = {
-#if IS_ENABLED(CONFIG_PSTORE_DEFLATE_COMPRESS)
-	{
-		.zbufsize	= zbufsize_deflate,
-		.name		= "deflate",
-	},
-#endif
-#if IS_ENABLED(CONFIG_PSTORE_LZO_COMPRESS)
-	{
-		.zbufsize	= zbufsize_lzo,
-		.name		= "lzo",
-	},
-#endif
-#if IS_ENABLED(CONFIG_PSTORE_LZ4_COMPRESS)
-	{
-		.zbufsize	= zbufsize_lz4,
-		.name		= "lz4",
-	},
-#endif
-#if IS_ENABLED(CONFIG_PSTORE_LZ4HC_COMPRESS)
-	{
-		.zbufsize	= zbufsize_lz4,
-		.name		= "lz4hc",
-	},
-#endif
-#if IS_ENABLED(CONFIG_PSTORE_842_COMPRESS)
-	{
-		.zbufsize	= zbufsize_842,
-		.name		= "842",
-	},
-#endif
-	{ }
-};
-
 static int pstore_compress(const void *in, void *out,
 			   unsigned int inlen, unsigned int outlen)
 {
@@ -256,42 +159,48 @@ static int pstore_decompress(void *in, void *out,
 	return outlen;
 }
 
+static void free_buf_for_compression(void)
+{
+	if (IS_ENABLED(CONFIG_PSTORE_COMPRESS) && !IS_ERR_OR_NULL(tfm))
+		crypto_free_comp(tfm);
+	tfm = NULL;
+	kfree(big_oops_buf);
+	big_oops_buf = NULL;
+	big_oops_buf_sz = 0;
+}
+
 static void allocate_buf_for_compression(void)
 {
-	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESS) || !zbackend)
+	if (!IS_ENABLED(CONFIG_PSTORE_COMPRESS) || !compress)
 		return;
 
-	if (!crypto_has_comp(zbackend->name, 0, 0)) {
-		pr_err("No %s compression\n", zbackend->name);
-		return;
+	if (!crypto_has_comp(compress, 0, 0)) {
+		pr_err("No %s compression available\n", compress);
+		goto fail;
 	}
 
-	big_oops_buf_sz = zbackend->zbufsize(psinfo->bufsize);
-	if (big_oops_buf_sz <= 0)
-		return;
+	tfm = crypto_alloc_comp(compress, 0, 0);
+	if (IS_ERR_OR_NULL(tfm)) {
+		pr_err("crypto_alloc_comp(\"%s\") failed!\n", compress);
+		goto fail;
+	}
+
+	if (crypto_comp_zbufsize(tfm, psinfo->bufsize, &big_oops_buf_sz)) {
+		pr_err("crypto_comp_zbufsize() for %s failed!\n", compress);
+		goto fail;
+	}
 
 	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 	if (!big_oops_buf) {
 		pr_err("allocate compression buffer error!\n");
-		return;
+		goto fail;
 	}
 
-	tfm = crypto_alloc_comp(zbackend->name, 0, 0);
-	if (IS_ERR_OR_NULL(tfm)) {
-		kfree(big_oops_buf);
-		big_oops_buf = NULL;
-		pr_err("crypto_alloc_comp() failed!\n");
-		return;
-	}
-}
+	return;
 
-static void free_buf_for_compression(void)
-{
-	if (IS_ENABLED(CONFIG_PSTORE_COMPRESS) && !IS_ERR_OR_NULL(tfm))
-		crypto_free_comp(tfm);
-	kfree(big_oops_buf);
-	big_oops_buf = NULL;
-	big_oops_buf_sz = 0;
+fail:
+	compress = NULL;
+	free_buf_for_compression();
 }
 
 /*
@@ -587,7 +496,9 @@ int pstore_register(struct pstore_info *psi)
 	 */
 	backend = psi->name;
 
-	pr_info("Registered %s as persistent store backend\n", psi->name);
+	pr_info("Registered %s as backend%s%s.\n",
+		psi->name, compress ? " compressed with " : "",
+		compress ?: "");
 
 	module_put(owner);
 
@@ -748,22 +659,6 @@ static void pstore_timefunc(struct timer_list *unused)
 			  jiffies + msecs_to_jiffies(pstore_update_ms));
 }
 
-void __init pstore_choose_compression(void)
-{
-	const struct pstore_zbackend *step;
-
-	if (!compress)
-		return;
-
-	for (step = zbackends; step->name; step++) {
-		if (!strcmp(compress, step->name)) {
-			zbackend = step;
-			pr_info("using %s compression\n", zbackend->name);
-			return;
-		}
-	}
-}
-
 module_param(compress, charp, 0444);
 MODULE_PARM_DESC(compress, "Pstore compression to use");
 
-- 
2.17.1

From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 2/2] crypto: replace NX842_MEM_COMPRESS with function
Date: Fri, 12 Jun 2015 10:58:47 -0400
Message-ID: <1434121127-14508-3-git-send-email-ddstreet@ieee.org>
References: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace the NX842_MEM_COMPRESS define with a function that returns the
specific platform driver's required working memory size.

The common nx-842.c driver refuses to load if there is no platform
driver present, so instead of defining an approximate working memory
size that's the maximum approximate size of both platform driver's
size requirements, the platform driver can directly provide its
specific, i.e. sizeof(struct nx842_workmem), size requirements which
the 842-nx crypto compression driver will use.

This saves memory by both reducing the required size of each driver
to the specific sizeof() amount, as well as using the specific loaded
platform driver's required amount, instead of the maximum of both.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-crypto.c  |  2 +-
 drivers/crypto/nx/nx-842-powernv.c | 11 +++++++----
 drivers/crypto/nx/nx-842-pseries.c |  7 +++----
 drivers/crypto/nx/nx-842.c         | 11 +++++++++++
 drivers/crypto/nx/nx-842.h         |  9 +++------
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-crypto.c b/drivers/crypto/nx/nx-842-crypto.c
index 95066f3..d53a1dc 100644
--- a/drivers/crypto/nx/nx-842-crypto.c
+++ b/drivers/crypto/nx/nx-842-crypto.c
@@ -136,7 +136,7 @@ static int nx842_crypto_init(struct crypto_tfm *tfm)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->wmem = kmalloc(NX842_MEM_COMPRESS, GFP_KERNEL);
+	ctx->wmem = kmalloc(nx842_workmem_size(), GFP_KERNEL);
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index c388dba..33b3b0a 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -367,7 +367,8 @@ static int wait_for_csb(struct nx842_workmem *wmem,
  * @inlen: input buffer size
  * @out: output buffer pointer
  * @outlenp: output buffer size pointer
- * @workmem: working memory buffer pointer, must be at least NX842_MEM_COMPRESS
+ * @workmem: working memory buffer pointer, size determined by
+ *           nx842_powernv_driver.workmem_size
  * @fc: function code, see CCW Function Codes in nx-842.h
  *
  * Returns:
@@ -477,7 +478,8 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
  * @inlen: input buffer size
  * @out: output buffer pointer
  * @outlenp: output buffer size pointer
- * @workmem: working memory buffer pointer, must be at least NX842_MEM_COMPRESS
+ * @workmem: working memory buffer pointer, size determined by
+ *           nx842_powernv_driver.workmem_size
  *
  * Returns: see @nx842_powernv_function()
  */
@@ -504,7 +506,8 @@ static int nx842_powernv_compress(const unsigned char *in, unsigned int inlen,
  * @inlen: input buffer size
  * @out: output buffer pointer
  * @outlenp: output buffer size pointer
- * @workmem: working memory buffer pointer, must be at least NX842_MEM_COMPRESS
+ * @workmem: working memory buffer pointer, size determined by
+ *           nx842_powernv_driver.workmem_size
  *
  * Returns: see @nx842_powernv_function()
  */
@@ -572,6 +575,7 @@ static struct nx842_constraints nx842_powernv_constraints = {
 static struct nx842_driver nx842_powernv_driver = {
 	.name =		KBUILD_MODNAME,
 	.owner =	THIS_MODULE,
+	.workmem_size =	sizeof(struct nx842_workmem),
 	.constraints =	&nx842_powernv_constraints,
 	.compress =	nx842_powernv_compress,
 	.decompress =	nx842_powernv_decompress,
@@ -582,7 +586,6 @@ static __init int nx842_powernv_init(void)
 	struct device_node *dn;
 
 	/* verify workmem size/align restrictions */
-	BUILD_BUG_ON(sizeof(struct nx842_workmem) > NX842_MEM_COMPRESS);
 	BUILD_BUG_ON(WORKMEM_ALIGN % CRB_ALIGN);
 	BUILD_BUG_ON(CRB_ALIGN % DDE_ALIGN);
 	BUILD_BUG_ON(CRB_SIZE % DDE_ALIGN);
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 41bc551..da52d8e 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -284,7 +284,7 @@ static int nx842_validate_result(struct device *dev,
  * @out: Pointer to output buffer
  * @outlen: Length of output buffer
  * @wrkmem: ptr to buffer for working memory, size determined by
- *          NX842_MEM_COMPRESS
+ *          nx842_pseries_driver.workmem_size
  *
  * Returns:
  *   0		Success, output of length @outlen stored in the buffer at @out
@@ -411,7 +411,7 @@ unlock:
  * @out: Pointer to output buffer
  * @outlen: Length of output buffer
  * @wrkmem: ptr to buffer for working memory, size determined by
- *          NX842_MEM_COMPRESS
+ *          nx842_pseries_driver.workmem_size
  *
  * Returns:
  *   0		Success, output of length @outlen stored in the buffer at @out
@@ -963,6 +963,7 @@ static struct attribute_group nx842_attribute_group = {
 static struct nx842_driver nx842_pseries_driver = {
 	.name =		KBUILD_MODNAME,
 	.owner =	THIS_MODULE,
+	.workmem_size =	sizeof(struct nx842_workmem),
 	.constraints =	&nx842_pseries_constraints,
 	.compress =	nx842_pseries_compress,
 	.decompress =	nx842_pseries_decompress,
@@ -1084,8 +1085,6 @@ static int __init nx842_init(void)
 
 	pr_info("Registering IBM Power 842 compression driver\n");
 
-	BUILD_BUG_ON(sizeof(struct nx842_workmem) > NX842_MEM_COMPRESS);
-
 	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
 		return -ENODEV;
 
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 9f391d6..6e5e0d6 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -53,6 +53,17 @@ int nx842_constraints(struct nx842_constraints *c)
 }
 EXPORT_SYMBOL_GPL(nx842_constraints);
 
+/**
+ * nx842_workmem_size
+ *
+ * Get the amount of working memory the driver requires.
+ */
+size_t nx842_workmem_size(void)
+{
+	return nx842_platform_driver()->workmem_size;
+}
+EXPORT_SYMBOL_GPL(nx842_workmem_size);
+
 int nx842_compress(const unsigned char *in, unsigned int ilen,
 		   unsigned char *out, unsigned int *olen, void *wmem)
 {
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 4dbac11..f6821b6 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -11,12 +11,6 @@
 #include <linux/mm.h>
 #include <linux/ratelimit.h>
 
-#define __NX842_PSERIES_MEM_COMPRESS	(10240)
-#define __NX842_POWERNV_MEM_COMPRESS	(1024)
-
-#define NX842_MEM_COMPRESS	(max_t(unsigned int,			\
-	__NX842_PSERIES_MEM_COMPRESS, __NX842_POWERNV_MEM_COMPRESS))
-
 /* Restrictions on Data Descriptor List (DDL) and Entry (DDE) buffers
  *
  * From NX P8 workbook, sec 4.9.1 "842 details"
@@ -119,6 +113,7 @@ struct nx842_constraints {
 struct nx842_driver {
 	char *name;
 	struct module *owner;
+	size_t workmem_size;
 
 	struct nx842_constraints *constraints;
 
@@ -136,6 +131,8 @@ void nx842_platform_driver_unset(struct nx842_driver *driver);
 bool nx842_platform_driver_get(void);
 void nx842_platform_driver_put(void);
 
+size_t nx842_workmem_size(void);
+
 int nx842_constraints(struct nx842_constraints *constraints);
 
 int nx842_compress(const unsigned char *in, unsigned int in_len,
-- 
2.1.0

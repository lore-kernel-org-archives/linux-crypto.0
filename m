From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 1/2] crypto: move include/linux/nx842.h into drivers/crypto/nx/nx-842.h
Date: Fri, 12 Jun 2015 10:58:46 -0400
Message-ID: <1434121127-14508-2-git-send-email-ddstreet@ieee.org>
References: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the contents of the include/linux/nx842.h header file into the
drivers/crypto/nx/nx-842.h header file.  Remove the nx842.h header
file and its entry in the MAINTAINERS file.

The include/linux/nx842.h header originally was there because the
crypto/842.c driver needed it to communicate with the nx-842 hw
driver.  However, that crypto compression driver was moved into
the drivers/crypto/nx/ directory, and now can directly include the
nx-842.h header.  Nothing else needs the public include/linux/nx842.h
header file, as all use of the nx-842 hardware driver will be through
the "842-nx" crypto compression driver, since the direct nx-842 api is
very limited in the buffer alignments and sizes that it will accept,
and the crypto compression interface handles those limitations and
allows any alignment and size buffers.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 MAINTAINERS                       |  1 -
 drivers/crypto/nx/nx-842-crypto.c |  3 ++-
 drivers/crypto/nx/nx-842.h        | 21 ++++++++++++++++++++-
 include/linux/nx842.h             | 24 ------------------------
 4 files changed, 22 insertions(+), 27 deletions(-)
 delete mode 100644 include/linux/nx842.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 912c9d9..fb06e1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4862,7 +4862,6 @@ IBM Power 842 compression accelerator
 M:	Dan Streetman <ddstreet@us.ibm.com>
 S:	Supported
 F:	drivers/crypto/nx/nx-842*
-F:	include/linux/nx842.h
 F:	include/linux/sw842.h
 F:	crypto/842.c
 F:	lib/842/
diff --git a/drivers/crypto/nx/nx-842-crypto.c b/drivers/crypto/nx/nx-842-crypto.c
index 2ffa103..95066f3 100644
--- a/drivers/crypto/nx/nx-842-crypto.c
+++ b/drivers/crypto/nx/nx-842-crypto.c
@@ -58,10 +58,11 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
-#include <linux/nx842.h>
 #include <linux/sw842.h>
 #include <linux/ratelimit.h>
 
+#include "nx-842.h"
+
 /* The first 5 bits of this magic are 0x1f, which is an invalid 842 5-bit
  * template (see lib/842/842.h), so this magic number will never appear at
  * the start of a raw 842 compressed buffer.  That is important, as any buffer
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 1730f4da..4dbac11 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -4,7 +4,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/nx842.h>
 #include <linux/sw842.h>
 #include <linux/of.h>
 #include <linux/slab.h>
@@ -12,6 +11,12 @@
 #include <linux/mm.h>
 #include <linux/ratelimit.h>
 
+#define __NX842_PSERIES_MEM_COMPRESS	(10240)
+#define __NX842_POWERNV_MEM_COMPRESS	(1024)
+
+#define NX842_MEM_COMPRESS	(max_t(unsigned int,			\
+	__NX842_PSERIES_MEM_COMPRESS, __NX842_POWERNV_MEM_COMPRESS))
+
 /* Restrictions on Data Descriptor List (DDL) and Entry (DDE) buffers
  *
  * From NX P8 workbook, sec 4.9.1 "842 details"
@@ -104,6 +109,13 @@ static inline unsigned long nx842_get_pa(void *addr)
 #define GET_FIELD(v, m)		(((v) & (m)) >> MASK_LSH(m))
 #define SET_FIELD(v, m, val)	(((v) & ~(m)) | (((val) << MASK_LSH(m)) & (m)))
 
+struct nx842_constraints {
+	int alignment;
+	int multiple;
+	int minimum;
+	int maximum;
+};
+
 struct nx842_driver {
 	char *name;
 	struct module *owner;
@@ -124,4 +136,11 @@ void nx842_platform_driver_unset(struct nx842_driver *driver);
 bool nx842_platform_driver_get(void);
 void nx842_platform_driver_put(void);
 
+int nx842_constraints(struct nx842_constraints *constraints);
+
+int nx842_compress(const unsigned char *in, unsigned int in_len,
+		   unsigned char *out, unsigned int *out_len, void *wrkmem);
+int nx842_decompress(const unsigned char *in, unsigned int in_len,
+		     unsigned char *out, unsigned int *out_len, void *wrkmem);
+
 #endif /* __NX_842_H__ */
diff --git a/include/linux/nx842.h b/include/linux/nx842.h
deleted file mode 100644
index 4ddf68d..0000000
--- a/include/linux/nx842.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef __NX842_H__
-#define __NX842_H__
-
-#define __NX842_PSERIES_MEM_COMPRESS	(10240)
-#define __NX842_POWERNV_MEM_COMPRESS	(1024)
-
-#define NX842_MEM_COMPRESS	(max_t(unsigned int,			\
-	__NX842_PSERIES_MEM_COMPRESS, __NX842_POWERNV_MEM_COMPRESS))
-
-struct nx842_constraints {
-	int alignment;
-	int multiple;
-	int minimum;
-	int maximum;
-};
-
-int nx842_constraints(struct nx842_constraints *constraints);
-
-int nx842_compress(const unsigned char *in, unsigned int in_len,
-		   unsigned char *out, unsigned int *out_len, void *wrkmem);
-int nx842_decompress(const unsigned char *in, unsigned int in_len,
-		     unsigned char *out, unsigned int *out_len, void *wrkmem);
-
-#endif
-- 
2.1.0

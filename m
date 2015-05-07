From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 07/10] drivers/crypto/nx: add nx842 constraints
Date: Thu,  7 May 2015 13:49:18 -0400
Message-ID: <1431020961-22285-8-git-send-email-ddstreet@ieee.org>
References: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add "constraints" for the NX-842 driver.  The constraints are used to
indicate what the current NX-842 platform driver is capable of.  The
constraints tell the NX-842 user what alignment, min and max length, and
length multiple each provided buffers should conform to.  These are
required because the 842 hardware requires buffers to meet specific
constraints that vary based on platform - for example, the pSeries
max length is much lower than the PowerNV max length.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 10 ++++++++++
 drivers/crypto/nx/nx-842.c         | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/nx/nx-842.h         |  2 ++
 include/linux/nx842.h              |  9 +++++++++
 4 files changed, 59 insertions(+)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 9b83c9e..cb481d8 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -40,6 +40,13 @@ MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
 /* IO buffer must be 128 byte aligned */
 #define IO_BUFFER_ALIGN 128
 
+static struct nx842_constraints nx842_pseries_constraints = {
+	.alignment =	IO_BUFFER_ALIGN,
+	.multiple =	DDE_BUFFER_LAST_MULT,
+	.minimum =	IO_BUFFER_ALIGN,
+	.maximum =	PAGE_SIZE, /* dynamic, max_sync_size */
+};
+
 struct nx842_header {
 	int blocks_nr; /* number of compressed blocks */
 	int offset; /* offset of the first block (from beginning of header) */
@@ -842,6 +849,8 @@ static int nx842_OF_upd_maxsyncop(struct nx842_devdata *devdata,
 		goto out;
 	}
 
+	nx842_pseries_constraints.maximum = devdata->max_sync_size;
+
 	devdata->max_sync_sg = (unsigned int)min(maxsynccop->comp_sg_limit,
 						maxsynccop->decomp_sg_limit);
 	if (devdata->max_sync_sg < 1) {
@@ -1115,6 +1124,7 @@ static struct attribute_group nx842_attribute_group = {
 
 static struct nx842_driver nx842_pseries_driver = {
 	.owner =	THIS_MODULE,
+	.constraints =	&nx842_pseries_constraints,
 	.compress =	nx842_pseries_compress,
 	.decompress =	nx842_pseries_decompress,
 };
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index f1f378e..160fe2d 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -86,6 +86,44 @@ static void put_driver(struct nx842_driver *driver)
 	module_put(driver->owner);
 }
 
+/**
+ * nx842_constraints
+ *
+ * This provides the driver's constraints.  Different nx842 implementations
+ * may have varying requirements.  The constraints are:
+ *   @alignment:	All buffers should be aligned to this
+ *   @multiple:		All buffer lengths should be a multiple of this
+ *   @minimum:		Buffer lengths must not be less than this amount
+ *   @maximum:		Buffer lengths must not be more than this amount
+ *
+ * The constraints apply to all buffers and lengths, both input and output,
+ * for both compression and decompression, except for the minimum which
+ * only applies to compression input and decompression output; the
+ * compressed data can be less than the minimum constraint.  It can be
+ * assumed that compressed data will always adhere to the multiple
+ * constraint.
+ *
+ * The driver may succeed even if these constraints are violated;
+ * however the driver can return failure or suffer reduced performance
+ * if any constraint is not met.
+ */
+int nx842_constraints(struct nx842_constraints *c)
+{
+	struct nx842_driver *driver = get_driver();
+	int ret = 0;
+
+	if (!driver)
+		return -ENODEV;
+
+	BUG_ON(!c);
+	memcpy(c, driver->constraints, sizeof(*c));
+
+	put_driver(driver);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nx842_constraints);
+
 int nx842_compress(const unsigned char *in, unsigned int in_len,
 		   unsigned char *out, unsigned int *out_len,
 		   void *wrkmem)
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 2a5d4e1..c6ceb0f 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -12,6 +12,8 @@
 struct nx842_driver {
 	struct module *owner;
 
+	struct nx842_constraints *constraints;
+
 	int (*compress)(const unsigned char *in, unsigned int in_len,
 			unsigned char *out, unsigned int *out_len,
 			void *wrkmem);
diff --git a/include/linux/nx842.h b/include/linux/nx842.h
index d919c22..aa1a97e9 100644
--- a/include/linux/nx842.h
+++ b/include/linux/nx842.h
@@ -5,6 +5,15 @@
 
 #define NX842_MEM_COMPRESS	__NX842_PSERIES_MEM_COMPRESS
 
+struct nx842_constraints {
+	int alignment;
+	int multiple;
+	int minimum;
+	int maximum;
+};
+
+int nx842_constraints(struct nx842_constraints *constraints);
+
 int nx842_compress(const unsigned char *in, unsigned int in_len,
 		   unsigned char *out, unsigned int *out_len, void *wrkmem);
 int nx842_decompress(const unsigned char *in, unsigned int in_len,
-- 
2.1.0

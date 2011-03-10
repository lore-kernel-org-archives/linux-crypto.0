From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/3] crypto: add support for the Freescale SEC4/CAAM
Date: Wed, 9 Mar 2011 18:54:54 -0600
Message-ID: <20110309185454.8b5d794b.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<devicetree-discuss@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53443
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab1CJAzJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Mar 2011 19:55:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SEC4 supercedes the SEC2.x/3.x as Freescale's
Integrated Security Engine.  Its programming model is
incompatible with all prior versions of the SEC (talitos).

The SEC4 is also known as the Cryptographic Accelerator
and Assurance Module (CAAM); this driver is named caam.

This initial submission does not include support for Data Path
mode operation - AEAD descriptors are submitted via the job
ring interface, while the Queue Interface (QI) is enabled
for use by others.  Only AEAD algorithms are implemented
at this time, for use with IPsec.

Many thanks to the Freescale STC team for their contributions
to this driver.

Signed-off-by: Steve Cornelius <sec@pobox.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
Documentation for this device has not been released to the public yet.
A high level description of the device is available on pp. 44-51 of:

http://www.freescale.com/files/ftf_2010/Americas/WBNR_FTF10_NET_F0446_PDF.pdf

 drivers/crypto/Kconfig            |    2 +
 drivers/crypto/Makefile           |    1 +
 drivers/crypto/caam/Kconfig       |   72 +++
 drivers/crypto/caam/Makefile      |    8 +
 drivers/crypto/caam/caamalg.c     | 1163 +++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/compat.h      |   35 ++
 drivers/crypto/caam/ctrl.c        |  270 +++++++++
 drivers/crypto/caam/desc_constr.h |  204 +++++++
 drivers/crypto/caam/error.c       |  248 ++++++++
 drivers/crypto/caam/error.h       |   10 +
 drivers/crypto/caam/intern.h      |  113 ++++
 drivers/crypto/caam/jr.c          |  523 +++++++++++++++++
 drivers/crypto/caam/jr.h          |   21 +
 13 files changed, 2670 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/caam/Kconfig
 create mode 100644 drivers/crypto/caam/Makefile
 create mode 100644 drivers/crypto/caam/caamalg.c
 create mode 100644 drivers/crypto/caam/compat.h
 create mode 100644 drivers/crypto/caam/ctrl.c
 create mode 100644 drivers/crypto/caam/desc_constr.h
 create mode 100644 drivers/crypto/caam/error.c
 create mode 100644 drivers/crypto/caam/error.h
 create mode 100644 drivers/crypto/caam/intern.h
 create mode 100644 drivers/crypto/caam/jr.c
 create mode 100644 drivers/crypto/caam/jr.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e541852..a27224a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -200,6 +200,8 @@ config CRYPTO_DEV_HIFN_795X_RNG
 	  Select this option if you want to enable the random number generator
 	  on the HIFN 795x crypto adapters.
 
+source drivers/crypto/caam/Kconfig
+
 config CRYPTO_DEV_TALITOS
 	tristate "Talitos Freescale Security Engine (SEC)"
 	select CRYPTO_ALGAPI
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 5203e34..663c5ef 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,6 +6,7 @@ n2_crypto-y := n2_core.o n2_asm.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
 obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
+obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
 obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
new file mode 100644
index 0000000..2d876bb
--- /dev/null
+++ b/drivers/crypto/caam/Kconfig
@@ -0,0 +1,72 @@
+config CRYPTO_DEV_FSL_CAAM
+	tristate "Freescale CAAM-Multicore driver backend"
+	depends on FSL_SOC
+	help
+	  Enables the driver module for Freescale's Cryptographic Accelerator
+	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4).
+	  This module adds a job ring operation interface, and configures h/w
+	  to operate as a DPAA component automatically, depending
+	  on h/w feature availability.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called caam.
+
+config CRYPTO_DEV_FSL_CAAM_RINGSIZE
+	int "Job Ring size"
+	depends on CRYPTO_DEV_FSL_CAAM
+	range 2 9
+	default "9"
+	help
+	  Select size of Job Rings as a power of 2, within the
+	  range 2-9 (ring size 4-512).
+	  Examples:
+		2 => 4
+		3 => 8
+		4 => 16
+		5 => 32
+		6 => 64
+		7 => 128
+		8 => 256
+		9 => 512
+
+config CRYPTO_DEV_FSL_CAAM_INTC
+	bool "Job Ring interrupt coalescing"
+	depends on CRYPTO_DEV_FSL_CAAM
+	default y
+	help
+	  Enable the Job Ring's interrupt coalescing feature.
+
+config CRYPTO_DEV_FSL_CAAM_INTC_COUNT_THLD
+	int "Job Ring interrupt coalescing count threshold"
+	depends on CRYPTO_DEV_FSL_CAAM_INTC
+	range 1 255
+	default 255
+	help
+	  Select number of descriptor completions to queue before
+	  raising an interrupt, in the range 1-255. Note that a selection
+	  of 1 functionally defeats the coalescing feature, and a selection
+	  equal or greater than the job ring size will force timeouts.
+
+config CRYPTO_DEV_FSL_CAAM_INTC_TIME_THLD
+	int "Job Ring interrupt coalescing timer threshold"
+	depends on CRYPTO_DEV_FSL_CAAM_INTC
+	range 1 65535
+	default 2048
+	help
+	  Select number of bus clocks/64 to timeout in the case that one or
+	  more descriptor completions are queued without reaching the count
+	  threshold. Range is 1-65535.
+
+config CRYPTO_DEV_FSL_CAAM_CRYPTO_API
+	tristate "Register algorithm implementations with the Crypto API"
+	depends on CRYPTO_DEV_FSL_CAAM
+	default y
+	select CRYPTO_ALGAPI
+	select CRYPTO_AUTHENC
+	help
+	  Selecting this will offload crypto for users of the
+	  scatterlist crypto API (such as the linux native IPSec
+	  stack) to the SEC4 via job ring.
+
+	  To compile this as a module, choose M here: the module
+	  will be called caamalg.
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
new file mode 100644
index 0000000..ef39011
--- /dev/null
+++ b/drivers/crypto/caam/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the CAAM backend and dependent components
+#
+
+obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
+obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
+
+caam-objs := ctrl.o jr.o error.o
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
new file mode 100644
index 0000000..d7fe3d3
--- /dev/null
+++ b/drivers/crypto/caam/caamalg.c
@@ -0,0 +1,1163 @@
+/*
+ * caam - Freescale FSL CAAM support for crypto API
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ *
+ * Based on talitos crypto API driver.
+ *
+ * relationship of job descriptors to shared descriptors (SteveC Dec 10 2008):
+ *
+ * ---------------                     ---------------
+ * | JobDesc #1  |-------------------->|  ShareDesc  |
+ * | *(packet 1) |                     |   (PDB)     |
+ * ---------------      |------------->|  (hashKey)  |
+ *       .              |              | (cipherKey) |
+ *       .              |    |-------->| (operation) |
+ * ---------------      |    |         ---------------
+ * | JobDesc #2  |------|    |
+ * | *(packet 2) |           |
+ * ---------------           |
+ *       .                   |
+ *       .                   |
+ * ---------------           |
+ * | JobDesc #3  |------------
+ * | *(packet 3) |
+ * ---------------
+ *
+ * The SharedDesc never changes for a connection unless rekeyed, but
+ * each packet will likely be in a different place. So all we need
+ * to know to process the packet is where the input is, where the
+ * output goes, and what context we want to process with. Context is
+ * in the SharedDesc, packet references in the JobDesc.
+ *
+ * So, a job desc looks like:
+ *
+ * ---------------------
+ * | Header            |
+ * | ShareDesc Pointer |
+ * | SEQ_OUT_PTR       |
+ * | (output buffer)   |
+ * | SEQ_IN_PTR        |
+ * | (input buffer)    |
+ * | LOAD (to DECO)    |
+ * ---------------------
+ */
+
+#include "compat.h"
+
+#include "regs.h"
+#include "intern.h"
+#include "desc_constr.h"
+#include "jr.h"
+#include "error.h"
+
+/*
+ * crypto alg
+ */
+#define CAAM_CRA_PRIORITY		3000
+/* max key is sum of AES_MAX_KEY_SIZE, max split key size */
+#define CAAM_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + \
+					 SHA512_DIGEST_SIZE * 2)
+/* max IV is max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
+#define CAAM_MAX_IV_LENGTH		16
+
+#ifdef DEBUG
+/* for print_hex_dumps with line references */
+#define xstr(s) str(s)
+#define str(s) #s
+#define debug(format, arg...) printk(format, arg)
+#else
+#define debug(format, arg...)
+#endif
+
+/*
+ * per-session context
+ */
+struct caam_ctx {
+	struct device *jrdev;
+	u32 *sh_desc;
+	dma_addr_t shared_desc_phys;
+	u32 class1_alg_type;
+	u32 class2_alg_type;
+	u32 alg_op;
+	u8 *key;
+	dma_addr_t key_phys;
+	unsigned int keylen;
+	unsigned int enckeylen;
+	unsigned int authkeylen;
+	unsigned int split_key_len;
+	unsigned int split_key_pad_len;
+	unsigned int authsize;
+};
+
+static int aead_authenc_setauthsize(struct crypto_aead *authenc,
+				    unsigned int authsize)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+
+	ctx->authsize = authsize;
+
+	return 0;
+}
+
+struct split_key_result {
+	struct completion completion;
+	int err;
+};
+
+static void split_key_done(struct device *dev, u32 *desc, u32 err,
+			   void *context)
+{
+	struct split_key_result *res = context;
+
+#ifdef DEBUG
+	dev_err(dev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+	if (err) {
+		char tmp[256];
+
+		dev_err(dev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
+	}
+
+	res->err = err;
+
+	complete(&res->completion);
+}
+
+/*
+get a split ipad/opad key
+
+Split key generation-----------------------------------------------
+
+[00] 0xb0810008    jobdesc: stidx=1 share=never len=8
+[01] 0x04000014        key: class2->keyreg len=20
+			@0xffe01000
+[03] 0x84410014  operation: cls2-op sha1 hmac init dec
+[04] 0x24940000     fifold: class2 msgdata-last2 len=0 imm
+[05] 0xa4000001       jump: class2 local all ->1 [06]
+[06] 0x64260028    fifostr: class2 mdsplit-jdk len=40
+			@0xffe04000
+*/
+static u32 gen_split_key(struct caam_ctx *ctx, const u8 *key_in, u32 authkeylen)
+{
+	struct device *jrdev = ctx->jrdev;
+	u32 *desc;
+	struct split_key_result result;
+	dma_addr_t dma_addr_in, dma_addr_out;
+	int ret = 0;
+
+	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
+
+	init_job_desc(desc, 0);
+
+	dma_addr_in = dma_map_single(jrdev, (void *)key_in, authkeylen,
+				     DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, dma_addr_in)) {
+		dev_err(jrdev, "unable to map key input memory\n");
+		kfree(desc);
+		return -ENOMEM;
+	}
+	append_key(desc, dma_addr_in, authkeylen, CLASS_2 |
+		       KEY_DEST_CLASS_REG);
+
+	/* Sets MDHA up into an HMAC-INIT */
+	append_operation(desc, ctx->alg_op | OP_ALG_DECRYPT |
+			     OP_ALG_AS_INIT);
+
+	/*
+	 * do a FIFO_LOAD of zero, this will trigger the internal key expansion
+	   into both pads inside MDHA
+	 */
+	append_fifo_load_as_imm(desc, NULL, 0, LDST_CLASS_2_CCB |
+				FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST2);
+
+	/*
+	 * FIFO_STORE with the explicit split-key content store
+	 * (0x26 output type)
+	 */
+	dma_addr_out = dma_map_single(jrdev, ctx->key, ctx->split_key_pad_len,
+				      DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, dma_addr_out)) {
+		dev_err(jrdev, "unable to map key output memory\n");
+		kfree(desc);
+		return -ENOMEM;
+	}
+	append_fifo_store(desc, dma_addr_out, ctx->split_key_len,
+			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, authkeylen, 1);
+	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+#endif
+
+	result.err = 0;
+	init_completion(&result.completion);
+
+	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
+	if (!ret) {
+		/* in progress */
+		wait_for_completion_interruptible(&result.completion);
+		ret = result.err;
+#ifdef DEBUG
+		print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+			       DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
+			       ctx->split_key_pad_len, 1);
+#endif
+	}
+
+	dma_unmap_single(jrdev, dma_addr_out, ctx->split_key_pad_len,
+			 DMA_FROM_DEVICE);
+	dma_unmap_single(jrdev, dma_addr_in, authkeylen, DMA_TO_DEVICE);
+
+	kfree(desc);
+
+	return ret;
+}
+
+static int build_sh_desc_ipsec(struct caam_ctx *ctx)
+{
+	struct device *jrdev = ctx->jrdev;
+	u32 *sh_desc;
+	u32 *jump_cmd;
+
+	/* build shared descriptor for this session */
+	sh_desc = kmalloc(CAAM_CMD_SZ * 4 + ctx->split_key_pad_len +
+			  ctx->enckeylen, GFP_DMA | GFP_KERNEL);
+	if (!sh_desc) {
+		dev_err(jrdev, "could not allocate shared descriptor\n");
+		return -ENOMEM;
+	}
+
+	init_sh_desc(sh_desc, HDR_SAVECTX | HDR_SHARE_SERIAL);
+
+	jump_cmd = append_jump(sh_desc, CLASS_BOTH | JUMP_TEST_ALL |
+			       JUMP_COND_SHRD | JUMP_COND_SELF);
+
+	/* process keys, starting with class 2/authentication */
+	append_key_as_imm(sh_desc, ctx->key, ctx->split_key_pad_len,
+			  ctx->split_key_len,
+			  CLASS_2 | KEY_DEST_MDHA_SPLIT | KEY_ENC);
+
+	append_key_as_imm(sh_desc, (void *)ctx->key + ctx->split_key_pad_len,
+			  ctx->enckeylen, ctx->enckeylen,
+			  CLASS_1 | KEY_DEST_CLASS_REG);
+
+	/* update jump cmd now that we are at the jump target */
+	set_jump_tgt_here(sh_desc, jump_cmd);
+
+	ctx->shared_desc_phys = dma_map_single(jrdev, sh_desc,
+					       desc_bytes(sh_desc),
+					       DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->shared_desc_phys)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		kfree(sh_desc);
+		return -ENOMEM;
+	}
+
+	ctx->sh_desc = sh_desc;
+
+	return 0;
+}
+
+static int aead_authenc_setkey(struct crypto_aead *aead,
+			       const u8 *key, unsigned int keylen)
+{
+	/* Sizes for MDHA pads (*not* keys): MD5, SHA1, 224, 256, 384, 512 */
+	static const u8 mdpadlen[] = { 16, 20, 32, 32, 64, 64 };
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	struct rtattr *rta = (void *)key;
+	struct crypto_authenc_key_param *param;
+	unsigned int authkeylen;
+	unsigned int enckeylen;
+	int ret = 0;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+
+	if (keylen < enckeylen)
+		goto badkey;
+
+	authkeylen = keylen - enckeylen;
+
+	if (keylen > CAAM_MAX_KEY_SIZE)
+		goto badkey;
+
+	/* Pick class 2 key length from algorithm submask */
+	ctx->split_key_len = mdpadlen[(ctx->alg_op & OP_ALG_ALGSEL_SUBMASK) >>
+				      OP_ALG_ALGSEL_SHIFT] * 2;
+	ctx->split_key_pad_len = ALIGN(ctx->split_key_len, 16);
+
+#ifdef DEBUG
+	printk(KERN_ERR "keylen %d enckeylen %d authkeylen %d\n",
+	       keylen, enckeylen, authkeylen);
+	printk(KERN_ERR "split_key_len %d split_key_pad_len %d\n",
+	       ctx->split_key_len, ctx->split_key_pad_len);
+	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
+#endif
+	ctx->key = kmalloc(ctx->split_key_pad_len + enckeylen,
+			   GFP_KERNEL | GFP_DMA);
+	if (!ctx->key) {
+		dev_err(jrdev, "could not allocate key output memory\n");
+		return -ENOMEM;
+	}
+
+	ret = gen_split_key(ctx, key, authkeylen);
+	if (ret) {
+		kfree(ctx->key);
+		goto badkey;
+	}
+
+	/* postpend encryption key to auth split key */
+	memcpy(ctx->key + ctx->split_key_pad_len, key + authkeylen, enckeylen);
+
+	ctx->key_phys = dma_map_single(jrdev, ctx->key, ctx->split_key_pad_len +
+				       enckeylen, DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->key_phys)) {
+		dev_err(jrdev, "unable to map key i/o memory\n");
+		kfree(ctx->key);
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ctx.key@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
+		       ctx->split_key_pad_len + enckeylen, 1);
+#endif
+
+	ctx->keylen = keylen;
+	ctx->enckeylen = enckeylen;
+	ctx->authkeylen = authkeylen;
+
+	ret = build_sh_desc_ipsec(ctx);
+	if (ret) {
+		dma_unmap_single(jrdev, ctx->key_phys, ctx->split_key_pad_len +
+				 enckeylen, DMA_TO_DEVICE);
+		kfree(ctx->key);
+	}
+
+	return ret;
+badkey:
+	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+struct link_tbl_entry {
+	u64 ptr;
+	u32 len;
+	u8 reserved;
+	u8 buf_pool_id;
+	u16 offset;
+};
+
+/*
+ * ipsec_esp_edesc - s/w-extended ipsec_esp descriptor
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @assoc_nents: number of segments in associated data (SPI+Seq) scatterlist
+ * @desc: h/w descriptor (variable length; must not exceed MAX_CAAM_DESCSIZE)
+ * @link_tbl_bytes: length of dma mapped link_tbl space
+ * @link_tbl_dma: bus physical mapped address of h/w link table
+ * @hw_desc: the h/w job descriptor followed by any referenced link tables
+ */
+struct ipsec_esp_edesc {
+	int assoc_nents;
+	int src_nents;
+	int dst_nents;
+	int link_tbl_bytes;
+	dma_addr_t link_tbl_dma;
+	struct link_tbl_entry *link_tbl;
+	u32 hw_desc[0];
+};
+
+static void ipsec_esp_unmap(struct device *dev,
+			    struct ipsec_esp_edesc *edesc,
+			    struct aead_request *areq)
+{
+	dma_unmap_sg(dev, areq->assoc, edesc->assoc_nents, DMA_TO_DEVICE);
+
+	if (unlikely(areq->dst != areq->src)) {
+		dma_unmap_sg(dev, areq->src, edesc->src_nents,
+			     DMA_TO_DEVICE);
+		dma_unmap_sg(dev, areq->dst, edesc->dst_nents,
+			     DMA_FROM_DEVICE);
+	} else {
+		dma_unmap_sg(dev, areq->src, edesc->src_nents,
+			     DMA_BIDIRECTIONAL);
+	}
+
+	if (edesc->link_tbl_bytes)
+		dma_unmap_single(dev, edesc->link_tbl_dma,
+				 edesc->link_tbl_bytes,
+				 DMA_TO_DEVICE);
+}
+
+/*
+ * ipsec_esp descriptor callbacks
+ */
+static void ipsec_esp_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				   void *context)
+{
+	struct aead_request *areq = context;
+	struct ipsec_esp_edesc *edesc;
+#ifdef DEBUG
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	int ivsize = crypto_aead_ivsize(aead);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+
+	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+	edesc = (struct ipsec_esp_edesc *)((char *)desc -
+		 offsetof(struct ipsec_esp_edesc, hw_desc));
+
+	if (err) {
+		char tmp[256];
+
+		dev_err(jrdev, "%s\n", caam_jr_strstatus(tmp, err));
+		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
+	}
+
+	ipsec_esp_unmap(jrdev, edesc, areq);
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->assoc),
+		       areq->assoclen , 1);
+	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src) - ivsize,
+		       edesc->src_nents ? 100 : ivsize, 1);
+	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src),
+		       edesc->src_nents ? 100 : areq->cryptlen +
+		       ctx->authsize + 4, 1);
+#endif
+
+	kfree(edesc);
+
+	aead_request_complete(areq, err);
+}
+
+static void ipsec_esp_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				   void *context)
+{
+	struct aead_request *areq = context;
+	struct ipsec_esp_edesc *edesc;
+#ifdef DEBUG
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+
+	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+	edesc = (struct ipsec_esp_edesc *)((char *)desc -
+		 offsetof(struct ipsec_esp_edesc, hw_desc));
+
+	if (err) {
+		char tmp[256];
+
+		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
+	}
+
+	ipsec_esp_unmap(jrdev, edesc, areq);
+
+	/*
+	 * verify hw auth check passed else return -EBADMSG
+	 */
+	if ((err & JRSTA_CCBERR_ERRID_MASK) == JRSTA_CCBERR_ERRID_ICVCHK)
+		err = -EBADMSG;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "iphdrout@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4,
+		       ((char *)sg_virt(areq->assoc) - sizeof(struct iphdr)),
+		       sizeof(struct iphdr) + areq->assoclen +
+		       ((areq->cryptlen > 1500) ? 1500 : areq->cryptlen) +
+		       ctx->authsize + 36, 1);
+	if (!err && edesc->link_tbl_bytes) {
+		struct scatterlist *sg = sg_last(areq->src, edesc->src_nents);
+		print_hex_dump(KERN_ERR, "sglastout@"xstr(__LINE__)": ",
+			       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(sg),
+			sg->length + ctx->authsize + 16, 1);
+	}
+#endif
+	kfree(edesc);
+
+	aead_request_complete(areq, err);
+}
+
+/*
+ * convert scatterlist to h/w link table format
+ * scatterlist must have been previously dma mapped
+ */
+static void sg_to_link_tbl(struct scatterlist *sg, int sg_count,
+			   struct link_tbl_entry *link_tbl_ptr, u32 offset)
+{
+	while (sg_count) {
+		link_tbl_ptr->ptr = sg_dma_address(sg);
+		link_tbl_ptr->len = sg_dma_len(sg);
+		link_tbl_ptr->reserved = 0;
+		link_tbl_ptr->buf_pool_id = 0;
+		link_tbl_ptr->offset = offset;
+		link_tbl_ptr++;
+		sg = sg_next(sg);
+		sg_count--;
+	}
+
+	/* set Final bit (marks end of link table) */
+	link_tbl_ptr--;
+	link_tbl_ptr->len |= 0x40000000;
+}
+
+/*
+ * fill in and submit ipsec_esp job descriptor
+ */
+static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
+		     u32 encrypt,
+		     void (*callback) (struct device *dev, u32 *desc,
+				       u32 err, void *context))
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	u32 *desc = edesc->hw_desc, options;
+	int ret, sg_count, assoc_sg_count;
+	int ivsize = crypto_aead_ivsize(aead);
+	int authsize = ctx->authsize;
+	dma_addr_t ptr, dst_dma, src_dma;
+#ifdef DEBUG
+	u32 *sh_desc = ctx->sh_desc;
+
+	debug("assoclen %d cryptlen %d authsize %d\n",
+	      areq->assoclen, areq->cryptlen, authsize);
+	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->assoc),
+		       areq->assoclen , 1);
+	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src) - ivsize,
+		       edesc->src_nents ? 100 : ivsize, 1);
+	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(areq->src),
+			edesc->src_nents ? 100 : areq->cryptlen + authsize, 1);
+	print_hex_dump(KERN_ERR, "shrdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
+		       desc_bytes(sh_desc), 1);
+#endif
+	assoc_sg_count = dma_map_sg(jrdev, areq->assoc, edesc->assoc_nents ?: 1,
+				    DMA_TO_DEVICE);
+	if (areq->src == areq->dst)
+		sg_count = dma_map_sg(jrdev, areq->src, edesc->src_nents ? : 1,
+				      DMA_BIDIRECTIONAL);
+	else
+		sg_count = dma_map_sg(jrdev, areq->src, edesc->src_nents ? : 1,
+				      DMA_TO_DEVICE);
+
+	/* start auth operation */
+	append_operation(desc, ctx->class2_alg_type | OP_ALG_AS_INITFINAL |
+			 (encrypt ? : OP_ALG_ICV_ON));
+
+	/* Load FIFO with data for Class 2 CHA */
+	options = FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG;
+	if (!edesc->assoc_nents) {
+		ptr = sg_dma_address(areq->assoc);
+	} else {
+		sg_to_link_tbl(areq->assoc, edesc->assoc_nents,
+			       edesc->link_tbl, 0);
+		ptr = edesc->link_tbl_dma;
+		options |= LDST_SGF;
+	}
+	append_fifo_load(desc, ptr, areq->assoclen, options);
+
+	/* copy iv from cipher/class1 input context to class2 infifo */
+	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
+
+	/* start class 1 (cipher) operation */
+	append_operation(desc, ctx->class1_alg_type | OP_ALG_AS_INITFINAL |
+			 encrypt);
+
+	/* load payload & instruct to class2 to snoop class 1 if encrypting */
+	options = 0;
+	if (!edesc->src_nents) {
+		src_dma = sg_dma_address(areq->src);
+	} else {
+		sg_to_link_tbl(areq->src, edesc->src_nents, edesc->link_tbl +
+			       edesc->assoc_nents, 0);
+		src_dma = edesc->link_tbl_dma + edesc->assoc_nents *
+			  sizeof(struct link_tbl_entry);
+		options |= LDST_SGF;
+	}
+	append_seq_in_ptr(desc, src_dma, areq->cryptlen + authsize, options);
+	append_seq_fifo_load(desc, areq->cryptlen, FIFOLD_CLASS_BOTH |
+			     FIFOLD_TYPE_LASTBOTH |
+			     (encrypt ? FIFOLD_TYPE_MSG1OUT2
+				      : FIFOLD_TYPE_MSG));
+
+	/* specify destination */
+	if (areq->src == areq->dst) {
+		dst_dma = src_dma;
+	} else {
+		sg_count = dma_map_sg(jrdev, areq->dst, edesc->dst_nents ? : 1,
+				      DMA_FROM_DEVICE);
+		if (!edesc->dst_nents) {
+			dst_dma = sg_dma_address(areq->dst);
+			options = 0;
+		} else {
+			sg_to_link_tbl(areq->dst, edesc->dst_nents,
+				       edesc->link_tbl + edesc->assoc_nents +
+				       edesc->src_nents, 0);
+			dst_dma = edesc->link_tbl_dma + (edesc->assoc_nents +
+				  edesc->src_nents) *
+				  sizeof(struct link_tbl_entry);
+			options = LDST_SGF;
+		}
+	}
+	append_seq_out_ptr(desc, dst_dma, areq->cryptlen + authsize, options);
+	append_seq_fifo_store(desc, areq->cryptlen, FIFOST_TYPE_MESSAGE_DATA);
+
+	/* ICV */
+	if (encrypt)
+		append_seq_store(desc, authsize, LDST_CLASS_2_CCB |
+				 LDST_SRCDST_BYTE_CONTEXT);
+	else
+		append_seq_fifo_load(desc, authsize, FIFOLD_CLASS_CLASS2 |
+				     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_ICV);
+
+#ifdef DEBUG
+	debug("job_desc_len %d\n", desc_len(desc));
+	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc) , 1);
+	print_hex_dump(KERN_ERR, "jdlinkt@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->link_tbl,
+			edesc->link_tbl_bytes, 1);
+#endif
+
+	ret = caam_jr_enqueue(jrdev, desc, callback, areq);
+	if (!ret)
+		ret = -EINPROGRESS;
+	else {
+		ipsec_esp_unmap(jrdev, edesc, areq);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
+/*
+ * derive number of elements in scatterlist
+ */
+static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
+{
+	struct scatterlist *sg = sg_list;
+	int sg_nents = 0;
+
+	*chained = 0;
+	while (nbytes > 0) {
+		sg_nents++;
+		nbytes -= sg->length;
+		if (!sg_is_last(sg) && (sg + 1)->length == 0)
+			*chained = 1;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	return sg_nents;
+}
+
+/*
+ * allocate and map the ipsec_esp extended descriptor
+ */
+static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
+						     int desc_bytes)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	gfp_t flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+		      GFP_ATOMIC;
+	int assoc_nents, src_nents, dst_nents = 0, chained, link_tbl_bytes;
+	struct ipsec_esp_edesc *edesc;
+
+	assoc_nents = sg_count(areq->assoc, areq->assoclen, &chained);
+	BUG_ON(chained);
+	if (likely(assoc_nents == 1))
+		assoc_nents = 0;
+
+	src_nents = sg_count(areq->src, areq->cryptlen + ctx->authsize,
+			     &chained);
+	BUG_ON(chained);
+	if (src_nents == 1)
+		src_nents = 0;
+
+	if (unlikely(areq->dst != areq->src)) {
+		dst_nents = sg_count(areq->dst, areq->cryptlen + ctx->authsize,
+				     &chained);
+		BUG_ON(chained);
+		if (dst_nents == 1)
+			dst_nents = 0;
+	}
+
+	link_tbl_bytes = (assoc_nents + src_nents + dst_nents) *
+			 sizeof(struct link_tbl_entry);
+	debug("link_tbl_bytes %d\n", link_tbl_bytes);
+
+	/* allocate space for base edesc and hw desc commands, link tables */
+	edesc = kmalloc(sizeof(struct ipsec_esp_edesc) + desc_bytes +
+			link_tbl_bytes, GFP_DMA | flags);
+	if (!edesc) {
+		dev_err(jrdev, "could not allocate extended descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edesc->assoc_nents = assoc_nents;
+	edesc->src_nents = src_nents;
+	edesc->dst_nents = dst_nents;
+	edesc->link_tbl = (void *)edesc + sizeof(struct ipsec_esp_edesc) +
+			  desc_bytes;
+	edesc->link_tbl_dma = dma_map_single(jrdev, edesc->link_tbl,
+					     link_tbl_bytes, DMA_TO_DEVICE);
+	edesc->link_tbl_bytes = link_tbl_bytes;
+
+	return edesc;
+}
+
+static int aead_authenc_encrypt(struct aead_request *areq)
+{
+	struct ipsec_esp_edesc *edesc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	int ivsize = crypto_aead_ivsize(aead);
+	u32 *desc;
+	dma_addr_t iv_dma;
+
+	/* allocate extended descriptor */
+	edesc = ipsec_esp_edesc_alloc(areq, 21 * sizeof(u32));
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	desc = edesc->hw_desc;
+
+	/* insert shared descriptor pointer */
+	init_job_desc_shared(desc, ctx->shared_desc_phys,
+			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
+
+	iv_dma = dma_map_single(jrdev, areq->iv, ivsize, DMA_TO_DEVICE);
+	/* check dma error */
+
+	append_load(desc, iv_dma, ivsize,
+		    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT);
+
+	return ipsec_esp(edesc, areq, OP_ALG_ENCRYPT, ipsec_esp_encrypt_done);
+}
+
+static int aead_authenc_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	int ivsize = crypto_aead_ivsize(aead);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	struct ipsec_esp_edesc *edesc;
+	u32 *desc;
+	dma_addr_t iv_dma;
+
+	req->cryptlen -= ctx->authsize;
+
+	/* allocate extended descriptor */
+	edesc = ipsec_esp_edesc_alloc(req, 21 * sizeof(u32));
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	desc = edesc->hw_desc;
+
+	/* insert shared descriptor pointer */
+	init_job_desc_shared(desc, ctx->shared_desc_phys,
+			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
+
+	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
+	/* check dma error */
+
+	append_load(desc, iv_dma, ivsize,
+		    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT);
+
+	return ipsec_esp(edesc, req, !OP_ALG_ENCRYPT, ipsec_esp_decrypt_done);
+}
+
+static int aead_authenc_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct aead_request *areq = &req->areq;
+	struct ipsec_esp_edesc *edesc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	int ivsize = crypto_aead_ivsize(aead);
+	dma_addr_t iv_dma;
+	u32 *desc;
+
+	iv_dma = dma_map_single(jrdev, req->giv, ivsize, DMA_FROM_DEVICE);
+
+	debug("%s: giv %p\n", __func__, req->giv);
+
+	/* allocate extended descriptor */
+	edesc = ipsec_esp_edesc_alloc(areq, 27 * sizeof(u32));
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	desc = edesc->hw_desc;
+
+	/* insert shared descriptor pointer */
+	init_job_desc_shared(desc, ctx->shared_desc_phys,
+			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
+
+	/*
+	 * LOAD IMM Info FIFO
+	 * to DECO, Last, Padding, Random, Message, 16 bytes
+	 */
+	append_load_imm_u32(desc, NFIFOENTRY_DEST_DECO | NFIFOENTRY_LC1 |
+			    NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DTYPE_MSG |
+			    NFIFOENTRY_PTYPE_RND | ivsize,
+			    LDST_SRCDST_WORD_INFO_FIFO);
+
+	/*
+	 * disable info fifo entries since the above serves as the entry
+	 * this way, the MOVE command won't generate an entry.
+	 * Note that this isn't required in more recent versions of
+	 * SEC as a MOVE that doesn't do info FIFO entries is available.
+	 */
+	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
+
+	/* MOVE DECO Alignment -> C1 Context 16 bytes */
+	append_move(desc, MOVE_WAITCOMP | MOVE_SRC_INFIFO |
+		    MOVE_DEST_CLASS1CTX | ivsize);
+
+	/* re-enable info fifo entries */
+	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
+
+	/* MOVE C1 Context -> OFIFO 16 bytes */
+	append_move(desc, MOVE_WAITCOMP | MOVE_SRC_CLASS1CTX |
+		    MOVE_DEST_OUTFIFO | ivsize);
+
+	append_fifo_store(desc, iv_dma, ivsize, FIFOST_TYPE_MESSAGE_DATA);
+
+	return ipsec_esp(edesc, areq, OP_ALG_ENCRYPT, ipsec_esp_encrypt_done);
+}
+
+struct caam_alg_template {
+	char name[CRYPTO_MAX_ALG_NAME];
+	char driver_name[CRYPTO_MAX_ALG_NAME];
+	unsigned int blocksize;
+	struct aead_alg aead;
+	u32 class1_alg_type;
+	u32 class2_alg_type;
+	u32 alg_op;
+};
+
+static struct caam_alg_template driver_algs[] = {
+	/* single-pass ipsec_esp descriptor */
+	{
+		.name = "authenc(hmac(sha1),cbc(aes))",
+		.driver_name = "authenc-hmac-sha1-cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(aes))",
+		.driver_name = "authenc-hmac-sha256-cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha1),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha1-cbc-des3_ede-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(des3_ede))",
+		.driver_name = "authenc-hmac-sha256-cbc-des3_ede-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha1),cbc(des))",
+		.driver_name = "authenc-hmac-sha1-cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha256),cbc(des))",
+		.driver_name = "authenc-hmac-sha256-cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+	},
+};
+
+struct caam_crypto_alg {
+	struct list_head entry;
+	struct device *ctrldev;
+	int class1_alg_type;
+	int class2_alg_type;
+	int alg_op;
+	struct crypto_alg crypto_alg;
+};
+
+static int caam_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct caam_crypto_alg *caam_alg =
+		 container_of(alg, struct caam_crypto_alg, crypto_alg);
+	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct caam_drv_private *priv = dev_get_drvdata(caam_alg->ctrldev);
+	int tgt_jr = atomic_inc_return(&priv->tfm_count);
+
+	/*
+	 * distribute tfms across job rings to ensure in-order
+	 * crypto request processing per tfm
+	 */
+	ctx->jrdev = priv->algapi_jr[(tgt_jr / 2) % priv->num_jrs_for_algapi];
+
+	/* copy descriptor header template value */
+	ctx->class1_alg_type = OP_TYPE_CLASS1_ALG | caam_alg->class1_alg_type;
+	ctx->class2_alg_type = OP_TYPE_CLASS2_ALG | caam_alg->class2_alg_type;
+	ctx->alg_op = OP_TYPE_CLASS2_ALG | caam_alg->alg_op;
+
+	return 0;
+}
+
+static void caam_cra_exit(struct crypto_tfm *tfm)
+{
+	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (!dma_mapping_error(ctx->jrdev, ctx->shared_desc_phys))
+		dma_unmap_single(ctx->jrdev, ctx->shared_desc_phys,
+				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
+	kfree(ctx->sh_desc);
+}
+
+static void __exit caam_algapi_exit(void)
+{
+
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev;
+	struct caam_drv_private *priv;
+	struct caam_crypto_alg *t_alg, *n;
+	int i, err;
+
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+	if (!dev_node)
+		return;
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return;
+
+	ctrldev = &pdev->dev;
+	of_node_put(dev_node);
+	priv = dev_get_drvdata(ctrldev);
+
+	if (!priv->alg_list.next)
+		return;
+
+	list_for_each_entry_safe(t_alg, n, &priv->alg_list, entry) {
+		crypto_unregister_alg(&t_alg->crypto_alg);
+		list_del(&t_alg->entry);
+		kfree(t_alg);
+	}
+
+	for (i = 0; i < priv->total_jobrs; i++) {
+		err = caam_jr_deregister(priv->algapi_jr[i]);
+		if (err < 0)
+			break;
+	}
+	kfree(priv->algapi_jr);
+}
+
+static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
+					      struct caam_alg_template
+					      *template)
+{
+	struct caam_crypto_alg *t_alg;
+	struct crypto_alg *alg;
+
+	t_alg = kzalloc(sizeof(struct caam_crypto_alg), GFP_KERNEL);
+	if (!t_alg) {
+		dev_err(ctrldev, "failed to allocate t_alg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	alg = &t_alg->crypto_alg;
+
+	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
+	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 template->driver_name);
+	alg->cra_module = THIS_MODULE;
+	alg->cra_init = caam_cra_init;
+	alg->cra_exit = caam_cra_exit;
+	alg->cra_priority = CAAM_CRA_PRIORITY;
+	alg->cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	alg->cra_blocksize = template->blocksize;
+	alg->cra_alignmask = 0;
+	alg->cra_type = &crypto_aead_type;
+	alg->cra_ctxsize = sizeof(struct caam_ctx);
+	alg->cra_u.aead = template->aead;
+
+	t_alg->class1_alg_type = template->class1_alg_type;
+	t_alg->class2_alg_type = template->class2_alg_type;
+	t_alg->alg_op = template->alg_op;
+	t_alg->ctrldev = ctrldev;
+
+	return t_alg;
+}
+
+static int __init caam_algapi_init(void)
+{
+	struct device_node *dev_node;
+	struct platform_device *pdev;
+	struct device *ctrldev, **jrdev;
+	struct caam_drv_private *priv;
+	int i = 0, err = 0;
+
+	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+	if (!dev_node)
+		return -ENODEV;
+
+	pdev = of_find_device_by_node(dev_node);
+	if (!pdev)
+		return -ENODEV;
+
+	ctrldev = &pdev->dev;
+	priv = dev_get_drvdata(ctrldev);
+	of_node_put(dev_node);
+
+	INIT_LIST_HEAD(&priv->alg_list);
+
+	jrdev = kmalloc(sizeof(*jrdev) * priv->total_jobrs, GFP_KERNEL);
+	if (!jrdev)
+		return -ENOMEM;
+
+	for (i = 0; i < priv->total_jobrs; i++) {
+		err = caam_jr_register(ctrldev, &jrdev[i]);
+		if (err < 0)
+			break;
+	}
+	if (err < 0 && i == 0) {
+		dev_err(ctrldev, "algapi error in job ring registration: %d\n",
+			err);
+		return err;
+	}
+
+	priv->num_jrs_for_algapi = i;
+	priv->algapi_jr = jrdev;
+	atomic_set(&priv->tfm_count, -1);
+
+	/* register crypto algorithms the device supports */
+	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
+		/* TODO: check if h/w supports alg */
+		struct caam_crypto_alg *t_alg;
+
+		t_alg = caam_alg_alloc(ctrldev, &driver_algs[i]);
+		if (IS_ERR(t_alg)) {
+			err = PTR_ERR(t_alg);
+			dev_warn(ctrldev, "%s alg allocation failed\n",
+				 t_alg->crypto_alg.cra_driver_name);
+			continue;
+		}
+
+		err = crypto_register_alg(&t_alg->crypto_alg);
+		if (err) {
+			dev_warn(ctrldev, "%s alg registration failed\n",
+				t_alg->crypto_alg.cra_driver_name);
+			kfree(t_alg);
+		} else {
+			list_add_tail(&t_alg->entry, &priv->alg_list);
+			dev_info(ctrldev, "%s\n",
+				 t_alg->crypto_alg.cra_driver_name);
+		}
+	}
+
+	return err;
+}
+
+module_init(caam_algapi_init);
+module_exit(caam_algapi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("FSL CAAM support for crypto API");
+MODULE_AUTHOR("Freescale Semiconductor - NMG/STC");
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
new file mode 100644
index 0000000..9504503
--- /dev/null
+++ b/drivers/crypto/caam/compat.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#ifndef CAAM_COMPAT_H
+#define CAAM_COMPAT_H
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/crypto.h>
+#include <linux/hw_random.h>
+#include <linux/of_platform.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/rtnetlink.h>
+#include <linux/in.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/debugfs.h>
+#include <linux/circ_buf.h>
+#include <net/xfrm.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/sha.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
+
+#endif /* !defined(CAAM_COMPAT_H) */
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
new file mode 100644
index 0000000..aa22161
--- /dev/null
+++ b/drivers/crypto/caam/ctrl.c
@@ -0,0 +1,270 @@
+/*
+ * CAAM control-plane driver backend
+ * Controller-level driver, kernel property detection, initialization
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#include "compat.h"
+#include "regs.h"
+#include "intern.h"
+#include "jr.h"
+
+static int caam_remove(struct platform_device *pdev)
+{
+	struct device *ctrldev;
+	struct caam_drv_private *ctrlpriv;
+	struct caam_drv_private_jr *jrpriv;
+	struct caam_full __iomem *topregs;
+	int ring, ret = 0;
+
+	ctrldev = &pdev->dev;
+	ctrlpriv = dev_get_drvdata(ctrldev);
+	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
+
+	/* shut down JobRs */
+	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
+		ret |= caam_jr_shutdown(ctrlpriv->jrdev[ring]);
+		jrpriv = dev_get_drvdata(ctrlpriv->jrdev[ring]);
+		irq_dispose_mapping(jrpriv->irq);
+	}
+
+	/* Shut down debug views */
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(ctrlpriv->dfs_root);
+#endif
+
+	/* Unmap controller region */
+	iounmap(&topregs->ctrl);
+
+	kfree(ctrlpriv->jrdev);
+	kfree(ctrlpriv);
+
+	return ret;
+}
+
+/* Probe routine for CAAM top (controller) level */
+static int caam_probe(struct platform_device *pdev,
+		      const struct of_device_id *devmatch)
+{
+	int d, ring, rspec;
+	struct device *dev;
+	struct device_node *nprop, *np;
+	struct caam_ctrl __iomem *ctrl;
+	struct caam_full __iomem *topregs;
+	struct caam_drv_private *ctrlpriv;
+	struct caam_perfmon *perfmon;
+	struct caam_deco **deco;
+	u32 deconum;
+
+	ctrlpriv = kzalloc(sizeof(struct caam_drv_private), GFP_KERNEL);
+	if (!ctrlpriv)
+		return -ENOMEM;
+
+	dev = &pdev->dev;
+	dev_set_drvdata(dev, ctrlpriv);
+	ctrlpriv->pdev = pdev;
+	nprop = pdev->dev.of_node;
+
+	/* Get configuration properties from device tree */
+	/* First, get register page */
+	ctrl = of_iomap(nprop, 0);
+	if (ctrl == NULL) {
+		dev_err(dev, "caam: of_iomap() failed\n");
+		return -ENOMEM;
+	}
+	ctrlpriv->ctrl = (struct caam_ctrl __force *)ctrl;
+
+	/* topregs used to derive pointers to CAAM sub-blocks only */
+	topregs = (struct caam_full __iomem *)ctrl;
+
+	/* Get the IRQ of the controller (for security violations only) */
+	ctrlpriv->secvio_irq = of_irq_to_resource(nprop, 0, NULL);
+
+	/*
+	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
+	 * 36-bit pointers in master configuration register
+	 */
+	setbits32(&topregs->ctrl.mcr, MCFGR_WDENABLE |
+		  (sizeof(dma_addr_t) == sizeof(u64) ? MCFGR_LONG_PTR : 0));
+
+	if (sizeof(dma_addr_t) == sizeof(u64))
+		dma_set_mask(dev, DMA_BIT_MASK(36));
+
+	/* Find out how many DECOs are present */
+	deconum = (rd_reg64(&topregs->ctrl.perfmon.cha_num) &
+		   CHA_NUM_DECONUM_MASK) >> CHA_NUM_DECONUM_SHIFT;
+
+	ctrlpriv->deco = kmalloc(deconum * sizeof(struct caam_deco *),
+				 GFP_KERNEL);
+
+	deco = (struct caam_deco __force **)&topregs->deco;
+	for (d = 0; d < deconum; d++)
+		ctrlpriv->deco[d] = deco[d];
+
+	/*
+	 * Detect and enable JobRs
+	 * First, find out how many ring spec'ed, allocate references
+	 * for all, then go probe each one.
+	 */
+	rspec = 0;
+	for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring")
+		rspec++;
+	ctrlpriv->jrdev = kzalloc(sizeof(struct device *) * rspec, GFP_KERNEL);
+	if (ctrlpriv->jrdev == NULL) {
+		iounmap(&topregs->ctrl);
+		return -ENOMEM;
+	}
+
+	ring = 0;
+	ctrlpriv->total_jobrs = 0;
+	for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring") {
+		caam_jr_probe(pdev, np, ring);
+		ctrlpriv->total_jobrs++;
+		ring++;
+	}
+
+	/* Check to see if QI present. If so, enable */
+	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
+				  CTPR_QI_MASK);
+	if (ctrlpriv->qi_present) {
+		ctrlpriv->qi = (struct caam_queue_if __force *)&topregs->qi;
+		/* This is all that's required to physically enable QI */
+		wr_reg32(&topregs->qi.qi_control_lo, QICTL_DQEN);
+	}
+
+	/* If no QI and no rings specified, quit and go home */
+	if ((!ctrlpriv->qi_present) && (!ctrlpriv->total_jobrs)) {
+		dev_err(dev, "no queues configured, terminating\n");
+		caam_remove(pdev);
+		return -ENOMEM;
+	}
+
+	/* NOTE: RTIC detection ought to go here, around Si time */
+
+	/* Initialize queue allocator lock */
+	spin_lock_init(&ctrlpriv->jr_alloc_lock);
+
+	/* Report "alive" for developer to see */
+	dev_info(dev, "device ID = 0x%016llx\n",
+		 rd_reg64(&topregs->ctrl.perfmon.caam_id));
+	dev_info(dev, "job rings = %d, qi = %d\n",
+		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
+
+#ifdef CONFIG_DEBUG_FS
+	/*
+	 * FIXME: needs better naming distinction, as some amalgamation of
+	 * "caam" and nprop->full_name. The OF name isn't distinctive,
+	 * but does separate instances
+	 */
+	perfmon = (struct caam_perfmon __force *)&ctrl->perfmon;
+
+	ctrlpriv->dfs_root = debugfs_create_dir("caam", NULL);
+	ctrlpriv->ctl = debugfs_create_dir("ctl", ctrlpriv->dfs_root);
+
+	/* Controller-level - performance monitor counters */
+	ctrlpriv->ctl_rq_dequeued =
+		debugfs_create_u64("rq_dequeued",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->req_dequeued);
+	ctrlpriv->ctl_ob_enc_req =
+		debugfs_create_u64("ob_rq_encrypted",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->ob_enc_req);
+	ctrlpriv->ctl_ib_dec_req =
+		debugfs_create_u64("ib_rq_decrypted",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->ib_dec_req);
+	ctrlpriv->ctl_ob_enc_bytes =
+		debugfs_create_u64("ob_bytes_encrypted",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->ob_enc_bytes);
+	ctrlpriv->ctl_ob_prot_bytes =
+		debugfs_create_u64("ob_bytes_protected",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->ob_prot_bytes);
+	ctrlpriv->ctl_ib_dec_bytes =
+		debugfs_create_u64("ib_bytes_decrypted",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->ib_dec_bytes);
+	ctrlpriv->ctl_ib_valid_bytes =
+		debugfs_create_u64("ib_bytes_validated",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->ib_valid_bytes);
+
+	/* Controller level - global status values */
+	ctrlpriv->ctl_faultaddr =
+		debugfs_create_u64("fault_addr",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->faultaddr);
+	ctrlpriv->ctl_faultdetail =
+		debugfs_create_u32("fault_detail",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->faultdetail);
+	ctrlpriv->ctl_faultstatus =
+		debugfs_create_u32("fault_status",
+				   S_IFCHR | S_IRUSR | S_IRGRP | S_IROTH,
+				   ctrlpriv->ctl, &perfmon->status);
+
+	/* Internal covering keys (useful in non-secure mode only) */
+	ctrlpriv->ctl_kek_wrap.data = &ctrlpriv->ctrl->kek[0];
+	ctrlpriv->ctl_kek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
+	ctrlpriv->ctl_kek = debugfs_create_blob("kek",
+						S_IFCHR | S_IRUSR |
+						S_IRGRP | S_IROTH,
+						ctrlpriv->ctl,
+						&ctrlpriv->ctl_kek_wrap);
+
+	ctrlpriv->ctl_tkek_wrap.data = &ctrlpriv->ctrl->tkek[0];
+	ctrlpriv->ctl_tkek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
+	ctrlpriv->ctl_tkek = debugfs_create_blob("tkek",
+						 S_IFCHR | S_IRUSR |
+						 S_IRGRP | S_IROTH,
+						 ctrlpriv->ctl,
+						 &ctrlpriv->ctl_tkek_wrap);
+
+	ctrlpriv->ctl_tdsk_wrap.data = &ctrlpriv->ctrl->tdsk[0];
+	ctrlpriv->ctl_tdsk_wrap.size = KEK_KEY_SIZE * sizeof(u32);
+	ctrlpriv->ctl_tdsk = debugfs_create_blob("tdsk",
+						 S_IFCHR | S_IRUSR |
+						 S_IRGRP | S_IROTH,
+						 ctrlpriv->ctl,
+						 &ctrlpriv->ctl_tdsk_wrap);
+#endif
+	return 0;
+}
+
+static struct of_device_id caam_match[] = {
+	{
+		.compatible = "fsl,sec4.0",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, caam_match);
+
+static struct of_platform_driver caam_driver = {
+	.driver = {
+		.name = "caam",
+		.owner = THIS_MODULE,
+		.of_match_table = caam_match,
+	},
+	.probe       = caam_probe,
+	.remove      = __devexit_p(caam_remove),
+};
+
+static int __init caam_base_init(void)
+{
+	return of_register_platform_driver(&caam_driver);
+}
+
+static void __exit caam_base_exit(void)
+{
+	return of_unregister_platform_driver(&caam_driver);
+}
+
+module_init(caam_base_init);
+module_exit(caam_base_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("FSL CAAM request backend");
+MODULE_AUTHOR("Freescale Semiconductor - NMG/STC");
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
new file mode 100644
index 0000000..c224f39
--- /dev/null
+++ b/drivers/crypto/caam/desc_constr.h
@@ -0,0 +1,204 @@
+/*
+ * caam descriptor construction helper functions
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#include "desc.h"
+
+#define IMMEDIATE (1 << 23)
+#define CAAM_CMD_SZ sizeof(u32)
+#define CAAM_PTR_SZ sizeof(dma_addr_t)
+
+#ifdef DEBUG
+#define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
+			      &__func__[sizeof("append")]); } while (0)
+#else
+#define PRINT_POS
+#endif
+
+#define DISABLE_AUTO_INFO_FIFO (IMMEDIATE | LDST_CLASS_DECO | \
+				LDST_SRCDST_WORD_DECOCTRL | \
+				(LDOFF_DISABLE_AUTO_NFIFO << LDST_OFFSET_SHIFT))
+#define ENABLE_AUTO_INFO_FIFO (IMMEDIATE | LDST_CLASS_DECO | \
+			       LDST_SRCDST_WORD_DECOCTRL | \
+			       (LDOFF_ENABLE_AUTO_NFIFO << LDST_OFFSET_SHIFT))
+
+static inline int desc_len(u32 *desc)
+{
+	return *desc & HDR_DESCLEN_MASK;
+}
+
+static inline int desc_bytes(void *desc)
+{
+	return desc_len(desc) * CAAM_CMD_SZ;
+}
+
+static inline u32 *desc_end(u32 *desc)
+{
+	return desc + desc_len(desc);
+}
+
+static inline void *sh_desc_pdb(u32 *desc)
+{
+	return desc + 1;
+}
+
+static inline void init_desc(u32 *desc, u32 options)
+{
+	*desc = options | HDR_ONE | 1;
+}
+
+static inline void init_sh_desc(u32 *desc, u32 options)
+{
+	PRINT_POS;
+	init_desc(desc, CMD_SHARED_DESC_HDR | options);
+}
+
+static inline void init_sh_desc_pdb(u32 *desc, u32 options, size_t pdb_bytes)
+{
+	u32 pdb_len = pdb_bytes / CAAM_CMD_SZ + 1;
+
+	init_sh_desc(desc, ((pdb_len << HDR_START_IDX_SHIFT) + pdb_len) |
+		     options);
+}
+
+static inline void init_job_desc(u32 *desc, u32 options)
+{
+	init_desc(desc, CMD_DESC_HDR | options);
+}
+
+static inline void append_ptr(u32 *desc, dma_addr_t ptr)
+{
+	dma_addr_t *offset = (dma_addr_t *)desc_end(desc);
+
+	*offset = ptr;
+
+	(*desc) += CAAM_PTR_SZ / CAAM_CMD_SZ;
+}
+
+static inline void init_job_desc_shared(u32 *desc, dma_addr_t ptr, int len,
+					u32 options)
+{
+	PRINT_POS;
+	init_job_desc(desc, HDR_SHARED | options |
+		      (len << HDR_START_IDX_SHIFT));
+	append_ptr(desc, ptr);
+}
+
+static inline void append_data(u32 *desc, void *data, int len)
+{
+	u32 *offset = desc_end(desc);
+
+	if (len) /* avoid sparse warning: memcpy with byte count of 0 */
+		memcpy(offset, data, len);
+
+	(*desc) += (len + CAAM_CMD_SZ - 1) / CAAM_CMD_SZ;
+}
+
+static inline void append_cmd(u32 *desc, u32 command)
+{
+	u32 *cmd = desc_end(desc);
+
+	*cmd = command;
+
+	(*desc)++;
+}
+
+static inline void append_cmd_ptr(u32 *desc, dma_addr_t ptr, int len,
+				  u32 command)
+{
+	append_cmd(desc, command | len);
+	append_ptr(desc, ptr);
+}
+
+static inline void append_cmd_data(u32 *desc, void *data, int len,
+				   u32 command)
+{
+	append_cmd(desc, command | IMMEDIATE | len);
+	append_data(desc, data, len);
+}
+
+static inline u32 *append_jump(u32 *desc, u32 options)
+{
+	u32 *cmd = desc_end(desc);
+
+	PRINT_POS;
+	append_cmd(desc, CMD_JUMP | options);
+
+	return cmd;
+}
+
+static inline void set_jump_tgt_here(u32 *desc, u32 *jump_cmd)
+{
+	*jump_cmd = *jump_cmd | (desc_len(desc) - (jump_cmd - desc));
+}
+
+#define APPEND_CMD(cmd, op) \
+static inline void append_##cmd(u32 *desc, u32 options) \
+{ \
+	PRINT_POS; \
+	append_cmd(desc, CMD_##op | options); \
+}
+APPEND_CMD(operation, OPERATION)
+APPEND_CMD(move, MOVE)
+
+#define APPEND_CMD_LEN(cmd, op) \
+static inline void append_##cmd(u32 *desc, unsigned int len, u32 options) \
+{ \
+	PRINT_POS; \
+	append_cmd(desc, CMD_##op | len | options); \
+}
+APPEND_CMD_LEN(seq_store, SEQ_STORE)
+APPEND_CMD_LEN(seq_fifo_load, SEQ_FIFO_LOAD)
+APPEND_CMD_LEN(seq_fifo_store, SEQ_FIFO_STORE)
+
+#define APPEND_CMD_PTR(cmd, op) \
+static inline void append_##cmd(u32 *desc, dma_addr_t ptr, unsigned int len, \
+				u32 options) \
+{ \
+	PRINT_POS; \
+	append_cmd_ptr(desc, ptr, len, CMD_##op | options); \
+}
+APPEND_CMD_PTR(key, KEY)
+APPEND_CMD_PTR(seq_in_ptr, SEQ_IN_PTR)
+APPEND_CMD_PTR(seq_out_ptr, SEQ_OUT_PTR)
+APPEND_CMD_PTR(load, LOAD)
+APPEND_CMD_PTR(store, STORE)
+APPEND_CMD_PTR(fifo_load, FIFO_LOAD)
+APPEND_CMD_PTR(fifo_store, FIFO_STORE)
+
+#define APPEND_CMD_PTR_TO_IMM(cmd, op) \
+static inline void append_##cmd##_as_imm(u32 *desc, void *data, \
+					 unsigned int len, u32 options) \
+{ \
+	PRINT_POS; \
+	append_cmd_data(desc, data, len, CMD_##op | options); \
+}
+APPEND_CMD_PTR_TO_IMM(load, LOAD);
+APPEND_CMD_PTR_TO_IMM(fifo_load, FIFO_LOAD);
+
+/*
+ * 2nd variant for commands whose specified immediate length differs
+ * from length of immediate data provided, e.g., split keys
+ */
+#define APPEND_CMD_PTR_TO_IMM2(cmd, op) \
+static inline void append_##cmd##_as_imm(u32 *desc, void *data, \
+					 unsigned int data_len, \
+					 unsigned int len, u32 options) \
+{ \
+	PRINT_POS; \
+	append_cmd(desc, CMD_##op | IMMEDIATE | len | options); \
+	append_data(desc, data, data_len); \
+}
+APPEND_CMD_PTR_TO_IMM2(key, KEY);
+
+#define APPEND_CMD_RAW_IMM(cmd, op, type) \
+static inline void append_##cmd##_imm_##type(u32 *desc, type immediate, \
+					     u32 options) \
+{ \
+	PRINT_POS; \
+	append_cmd(desc, CMD_##op | IMMEDIATE | options | sizeof(type)); \
+	append_cmd(desc, immediate); \
+}
+APPEND_CMD_RAW_IMM(load, LOAD, u32);
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
new file mode 100644
index 0000000..bd57a68
--- /dev/null
+++ b/drivers/crypto/caam/error.c
@@ -0,0 +1,248 @@
+/*
+ * CAAM Error Reporting
+ *
+ * Copyright 2009-2011 Freescale Semiconductor, Inc.
+ */
+
+#include "compat.h"
+#include "regs.h"
+#include "intern.h"
+#include "desc.h"
+#include "jr.h"
+#include "error.h"
+
+#define SPRINTFCAT(str, format, param, max_alloc)		\
+{								\
+	char *tmp;						\
+								\
+	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
+	sprintf(tmp, format, param);				\
+	strcat(str, tmp);					\
+	kfree(tmp);						\
+}
+
+static void report_jump_idx(u32 status, char *outstr)
+{
+	u8 idx = (status & JRSTA_DECOERR_INDEX_MASK) >>
+		  JRSTA_DECOERR_INDEX_SHIFT;
+
+	if (status & JRSTA_DECOERR_JUMP)
+		strcat(outstr, "jump tgt desc idx ");
+	else
+		strcat(outstr, "desc idx ");
+
+	SPRINTFCAT(outstr, "%d: ", idx, sizeof("255"));
+}
+
+static void report_ccb_status(u32 status, char *outstr)
+{
+	char *cha_id_list[] = {
+		"",
+		"AES",
+		"DES, 3DES",
+		"ARC4",
+		"MD5, SHA-1, SH-224, SHA-256, SHA-384, SHA-512",
+		"RNG",
+		"SNOW f8",
+		"Kasumi f8, f9",
+		"All Public Key Algorithms",
+		"CRC",
+		"SNOW f9",
+	};
+	char *err_id_list[] = {
+		"None. No error.",
+		"Mode error.",
+		"Data size error.",
+		"Key size error.",
+		"PKHA A memory size error.",
+		"PKHA B memory size error.",
+		"Data arrived out of sequence error.",
+		"PKHA divide-by-zero error.",
+		"PKHA modulus even error.",
+		"DES key parity error.",
+		"ICV check failed.",
+		"Hardware error.",
+		"Unsupported CCM AAD size.",
+		"Class 1 CHA is not reset",
+		"Invalid CHA combination was selected",
+		"Invalid CHA selected.",
+	};
+	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
+		    JRSTA_CCBERR_CHAID_SHIFT;
+	u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
+
+	report_jump_idx(status, outstr);
+
+	if (cha_id < sizeof(cha_id_list)) {
+		SPRINTFCAT(outstr, "%s: ", cha_id_list[cha_id],
+			   strlen(cha_id_list[cha_id]));
+	} else {
+		SPRINTFCAT(outstr, "unidentified cha_id value 0x%02x: ",
+			   cha_id, sizeof("ff"));
+	}
+
+	if (err_id < sizeof(err_id_list)) {
+		SPRINTFCAT(outstr, "%s", err_id_list[err_id],
+			   strlen(err_id_list[err_id]));
+	} else {
+		SPRINTFCAT(outstr, "unidentified err_id value 0x%02x",
+			   err_id, sizeof("ff"));
+	}
+}
+
+static void report_jump_status(u32 status, char *outstr)
+{
+	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
+}
+
+static void report_deco_status(u32 status, char *outstr)
+{
+	const struct {
+		u8 value;
+		char *error_text;
+	} desc_error_list[] = {
+		{ 0x00, "None. No error." },
+		{ 0x01, "SGT Length Error. The descriptor is trying to read "
+			"more data than is contained in the SGT table." },
+		{ 0x02, "Reserved." },
+		{ 0x03, "Job Ring Control Error. There is a bad value in the "
+			"Job Ring Control register." },
+		{ 0x04, "Invalid Descriptor Command. The Descriptor Command "
+			"field is invalid." },
+		{ 0x05, "Reserved." },
+		{ 0x06, "Invalid KEY Command" },
+		{ 0x07, "Invalid LOAD Command" },
+		{ 0x08, "Invalid STORE Command" },
+		{ 0x09, "Invalid OPERATION Command" },
+		{ 0x0A, "Invalid FIFO LOAD Command" },
+		{ 0x0B, "Invalid FIFO STORE Command" },
+		{ 0x0C, "Invalid MOVE Command" },
+		{ 0x0D, "Invalid JUMP Command. A nonlocal JUMP Command is "
+			"invalid because the target is not a Job Header "
+			"Command, or the jump is from a Trusted Descriptor to "
+			"a Job Descriptor, or because the target Descriptor "
+			"contains a Shared Descriptor." },
+		{ 0x0E, "Invalid MATH Command" },
+		{ 0x0F, "Invalid SIGNATURE Command" },
+		{ 0x10, "Invalid Sequence Command. A SEQ IN PTR OR SEQ OUT PTR "
+			"Command is invalid or a SEQ KEY, SEQ LOAD, SEQ FIFO "
+			"LOAD, or SEQ FIFO STORE decremented the input or "
+			"output sequence length below 0. This error may result "
+			"if a built-in PROTOCOL Command has encountered a "
+			"malformed PDU." },
+		{ 0x11, "Skip data type invalid. The type must be 0xE or 0xF."},
+		{ 0x12, "Shared Descriptor Header Error" },
+		{ 0x13, "Header Error. Invalid length or parity, or certain "
+			"other problems." },
+		{ 0x14, "Burster Error. Burster has gotten to an illegal "
+			"state" },
+		{ 0x15, "Context Register Length Error. The descriptor is "
+			"trying to read or write past the end of the Context "
+			"Register. A SEQ LOAD or SEQ STORE with the VLF bit "
+			"set was executed with too large a length in the "
+			"variable length register (VSOL for SEQ STORE or VSIL "
+			"for SEQ LOAD)." },
+		{ 0x16, "DMA Error" },
+		{ 0x17, "Reserved." },
+		{ 0x1A, "Job failed due to JR reset" },
+		{ 0x1B, "Job failed due to Fail Mode" },
+		{ 0x1C, "DECO Watchdog timer timeout error" },
+		{ 0x1D, "DECO tried to copy a key from another DECO but the "
+			"other DECO's Key Registers were locked" },
+		{ 0x1E, "DECO attempted to copy data from a DECO that had an "
+			"unmasked Descriptor error" },
+		{ 0x1F, "LIODN error. DECO was trying to share from itself or "
+			"from another DECO but the two Non-SEQ LIODN values "
+			"didn't match or the 'shared from' DECO's Descriptor "
+			"required that the SEQ LIODNs be the same and they "
+			"aren't." },
+		{ 0x20, "DECO has completed a reset initiated via the DRR "
+			"register" },
+		{ 0x21, "Nonce error. When using EKT (CCM) key encryption "
+			"option in the FIFO STORE Command, the Nonce counter "
+			"reached its maximum value and this encryption mode "
+			"can no longer be used." },
+		{ 0x22, "Meta data is too large (> 511 bytes) for TLS decap "
+			"(input frame; block ciphers) and IPsec decap (output "
+			"frame, when doing the next header byte update) and "
+			"DCRC (output frame)." },
+		{ 0x80, "DNR (do not run) error" },
+		{ 0x81, "undefined protocol command" },
+		{ 0x82, "invalid setting in PDB" },
+		{ 0x83, "Anti-replay LATE error" },
+		{ 0x84, "Anti-replay REPLAY error" },
+		{ 0x85, "Sequence number overflow" },
+		{ 0x86, "Sigver invalid signature" },
+		{ 0x87, "DSA Sign Illegal test descriptor" },
+		{ 0x88, "Protocol Format Error - A protocol has seen an error "
+			"in the format of data received. When running RSA, "
+			"this means that formatting with random padding was "
+			"used, and did not follow the form: 0x00, 0x02, 8-to-N "
+			"bytes of non-zero pad, 0x00, F data." },
+		{ 0x89, "Protocol Size Error - A protocol has seen an error in "
+			"size. When running RSA, pdb size N < (size of F) when "
+			"no formatting is used; or pdb size N < (F + 11) when "
+			"formatting is used." },
+		{ 0xC1, "Blob Command error: Undefined mode" },
+		{ 0xC2, "Blob Command error: Secure Memory Blob mode error" },
+		{ 0xC4, "Blob Command error: Black Blob key or input size "
+			"error" },
+		{ 0xC5, "Blob Command error: Invalid key destination" },
+		{ 0xC8, "Blob Command error: Trusted/Secure mode error" },
+		{ 0xF0, "IPsec TTL or hop limit field either came in as 0, "
+			"or was decremented to 0" },
+		{ 0xF1, "3GPP HFN matches or exceeds the Threshold" },
+	};
+	u8 desc_error = status & JRSTA_DECOERR_ERROR_MASK;
+	int i;
+
+	report_jump_idx(status, outstr);
+
+	for (i = 0; i < sizeof(desc_error_list); i++)
+		if (desc_error_list[i].value == desc_error)
+			break;
+
+	if (i != sizeof(desc_error_list) && desc_error_list[i].error_text) {
+		SPRINTFCAT(outstr, "%s", desc_error_list[i].error_text,
+			   strlen(desc_error_list[i].error_text));
+	} else {
+		SPRINTFCAT(outstr, "unidentified error value 0x%02x",
+			   desc_error, sizeof("ff"));
+	}
+}
+
+static void report_jr_status(u32 status, char *outstr)
+{
+	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
+}
+
+static void report_cond_code_status(u32 status, char *outstr)
+{
+	SPRINTFCAT(outstr, "%s() not implemented", __func__, sizeof(__func__));
+}
+
+char *caam_jr_strstatus(char *outstr, u32 status)
+{
+	struct stat_src {
+		void (*report_ssed)(u32 status, char *outstr);
+		char *error;
+	} status_src[] = {
+		{ NULL, "No error" },
+		{ NULL, NULL },
+		{ report_ccb_status, "CCB" },
+		{ report_jump_status, "Jump" },
+		{ report_deco_status, "DECO" },
+		{ NULL, NULL },
+		{ report_jr_status, "Job Ring" },
+		{ report_cond_code_status, "Condition Code" },
+	};
+	u32 ssrc = status >> JRSTA_SSRC_SHIFT;
+
+	sprintf(outstr, "%s: ", status_src[ssrc].error);
+
+	if (status_src[ssrc].report_ssed)
+		status_src[ssrc].report_ssed(status, outstr);
+
+	return outstr;
+}
+EXPORT_SYMBOL(caam_jr_strstatus);
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
new file mode 100644
index 0000000..067afc1
--- /dev/null
+++ b/drivers/crypto/caam/error.h
@@ -0,0 +1,10 @@
+/*
+ * CAAM Error Reporting code header
+ *
+ * Copyright 2009-2011 Freescale Semiconductor, Inc.
+ */
+
+#ifndef CAAM_ERROR_H
+#define CAAM_ERROR_H
+extern char *caam_jr_strstatus(char *outstr, u32 status);
+#endif /* CAAM_ERROR_H */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
new file mode 100644
index 0000000..a34be01
--- /dev/null
+++ b/drivers/crypto/caam/intern.h
@@ -0,0 +1,113 @@
+/*
+ * CAAM/SEC 4.x driver backend
+ * Private/internal definitions between modules
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ *
+ */
+
+#ifndef INTERN_H
+#define INTERN_H
+
+#define JOBR_UNASSIGNED 0
+#define JOBR_ASSIGNED 1
+
+/* Currently comes from Kconfig param as a ^2 (driver-required) */
+#define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
+
+/* Kconfig params for interrupt coalescing if selected (else zero) */
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_INTC
+#define JOBR_INTC JRCFG_ICEN
+#define JOBR_INTC_TIME_THLD CONFIG_CRYPTO_DEV_FSL_CAAM_INTC_TIME_THLD
+#define JOBR_INTC_COUNT_THLD CONFIG_CRYPTO_DEV_FSL_CAAM_INTC_COUNT_THLD
+#else
+#define JOBR_INTC 0
+#define JOBR_INTC_TIME_THLD 0
+#define JOBR_INTC_COUNT_THLD 0
+#endif
+
+/*
+ * Storage for tracking each in-process entry moving across a ring
+ * Each entry on an output ring needs one of these
+ */
+struct caam_jrentry_info {
+	void (*callbk)(struct device *dev, u32 *desc, u32 status, void *arg);
+	void *cbkarg;	/* Argument per ring entry */
+	u32 *desc_addr_virt;	/* Stored virt addr for postprocessing */
+	dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
+	u32 desc_size;	/* Stored size for postprocessing, header derived */
+};
+
+/* Private sub-storage for a single JobR */
+struct caam_drv_private_jr {
+	struct device *parentdev;	/* points back to controller dev */
+	int ridx;
+	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
+	struct tasklet_struct irqtask[NR_CPUS];
+	int irq;			/* One per queue */
+	int assign;			/* busy/free */
+
+	/* Job ring info */
+	int ringsize;	/* Size of rings (assume input = output) */
+	struct caam_jrentry_info *entinfo;	/* Alloc'ed 1 per ring entry */
+	spinlock_t inplock ____cacheline_aligned; /* Input ring index lock */
+	int inp_ring_write_index;	/* Input index "tail" */
+	int head;			/* entinfo (s/w ring) head index */
+	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
+	spinlock_t outlock ____cacheline_aligned; /* Output ring index lock */
+	int out_ring_read_index;	/* Output index "tail" */
+	int tail;			/* entinfo (s/w ring) tail index */
+	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */
+};
+
+/*
+ * Driver-private storage for a single CAAM block instance
+ */
+struct caam_drv_private {
+
+	struct device *dev;
+	struct device **jrdev; /* Alloc'ed array per sub-device */
+	spinlock_t jr_alloc_lock;
+	struct platform_device *pdev;
+
+	/* Physical-presence section */
+	struct caam_ctrl *ctrl; /* controller region */
+	struct caam_deco **deco; /* DECO/CCB views */
+	struct caam_assurance *ac;
+	struct caam_queue_if *qi; /* QI control region */
+
+	/*
+	 * Detected geometry block. Filled in from device tree if powerpc,
+	 * or from register-based version detection code
+	 */
+	u8 total_jobrs;		/* Total Job Rings in device */
+	u8 qi_present;		/* Nonzero if QI present in device */
+	int secvio_irq;		/* Security violation interrupt number */
+
+	/* which jr allocated to scatterlist crypto */
+	atomic_t tfm_count ____cacheline_aligned;
+	int num_jrs_for_algapi;
+	struct device **algapi_jr;
+	/* list of registered crypto algorithms (mk generic context handle?) */
+	struct list_head alg_list;
+
+	/*
+	 * debugfs entries for developer view into driver/device
+	 * variables at runtime.
+	 */
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dfs_root;
+	struct dentry *ctl; /* controller dir */
+	struct dentry *ctl_rq_dequeued, *ctl_ob_enc_req, *ctl_ib_dec_req;
+	struct dentry *ctl_ob_enc_bytes, *ctl_ob_prot_bytes;
+	struct dentry *ctl_ib_dec_bytes, *ctl_ib_valid_bytes;
+	struct dentry *ctl_faultaddr, *ctl_faultdetail, *ctl_faultstatus;
+
+	struct debugfs_blob_wrapper ctl_kek_wrap, ctl_tkek_wrap, ctl_tdsk_wrap;
+	struct dentry *ctl_kek, *ctl_tkek, *ctl_tdsk;
+#endif
+};
+
+void caam_jr_algapi_init(struct device *dev);
+void caam_jr_algapi_remove(struct device *dev);
+#endif /* INTERN_H */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
new file mode 100644
index 0000000..68cb9af
--- /dev/null
+++ b/drivers/crypto/caam/jr.c
@@ -0,0 +1,523 @@
+/*
+ * CAAM/SEC 4.x transport/backend driver
+ * JobR backend functionality
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#include "compat.h"
+#include "regs.h"
+#include "jr.h"
+#include "desc.h"
+#include "intern.h"
+
+/* Main per-ring interrupt handler */
+static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
+{
+	struct device *dev = st_dev;
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	u32 irqstate;
+
+	/*
+	 * Check the output ring for ready responses, kick
+	 * tasklet if jobs done.
+	 */
+	irqstate = rd_reg32(&jrp->rregs->jrintstatus);
+	if (!irqstate)
+		return IRQ_NONE;
+
+	/*
+	 * If JobR error, we got more development work to do
+	 * Flag a bug now, but we really need to shut down and
+	 * restart the queue (and fix code).
+	 */
+	if (irqstate & JRINT_JR_ERROR) {
+		dev_err(dev, "job ring error: irqstate: %08x\n", irqstate);
+		BUG();
+	}
+
+	/* mask valid interrupts */
+	setbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+
+	/* Have valid interrupt at this point, just ACK and trigger */
+	wr_reg32(&jrp->rregs->jrintstatus, irqstate);
+
+	preempt_disable();
+	tasklet_schedule(&jrp->irqtask[smp_processor_id()]);
+	preempt_enable();
+
+	return IRQ_HANDLED;
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void caam_jr_dequeue(unsigned long devarg)
+{
+	int hw_idx, sw_idx, i, head, tail;
+	struct device *dev = (struct device *)devarg;
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
+	u32 *userdesc, userstatus;
+	void *userarg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&jrp->outlock, flags);
+
+	head = ACCESS_ONCE(jrp->head);
+	sw_idx = tail = jrp->tail;
+
+	while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
+	       rd_reg32(&jrp->rregs->outring_used)) {
+
+		hw_idx = jrp->out_ring_read_index;
+		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
+			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
+
+			smp_read_barrier_depends();
+
+			if (jrp->outring[hw_idx].desc ==
+			    jrp->entinfo[sw_idx].desc_addr_dma)
+				break; /* found */
+		}
+		/* we should never fail to find a matching descriptor */
+		BUG_ON(CIRC_CNT(head, tail + i, JOBR_DEPTH) <= 0);
+
+		/* Unmap just-run descriptor so we can post-process */
+		dma_unmap_single(dev, jrp->outring[hw_idx].desc,
+				 jrp->entinfo[sw_idx].desc_size,
+				 DMA_TO_DEVICE);
+
+		/* mark completed, avoid matching on a recycled desc addr */
+		jrp->entinfo[sw_idx].desc_addr_dma = 0;
+
+		/* Stash callback params for use outside of lock */
+		usercall = jrp->entinfo[sw_idx].callbk;
+		userarg = jrp->entinfo[sw_idx].cbkarg;
+		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
+		userstatus = jrp->outring[hw_idx].jrstatus;
+
+		smp_mb();
+
+		jrp->out_ring_read_index = (jrp->out_ring_read_index + 1) &
+					   (JOBR_DEPTH - 1);
+
+		/*
+		 * if this job completed out-of-order, do not increment
+		 * the tail.  Otherwise, increment tail by 1 plus the
+		 * number of subsequent jobs already completed out-of-order
+		 */
+		if (sw_idx == tail) {
+			do {
+				tail = (tail + 1) & (JOBR_DEPTH - 1);
+				smp_read_barrier_depends();
+			} while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
+				 jrp->entinfo[tail].desc_addr_dma == 0);
+
+			jrp->tail = tail;
+		}
+
+		/* set done */
+		wr_reg32(&jrp->rregs->outring_rmvd, 1);
+
+		spin_unlock_irqrestore(&jrp->outlock, flags);
+
+		/* Finally, execute user's callback */
+		usercall(dev, userdesc, userstatus, userarg);
+
+		spin_lock_irqsave(&jrp->outlock, flags);
+
+		head = ACCESS_ONCE(jrp->head);
+		sw_idx = tail = jrp->tail;
+	}
+
+	spin_unlock_irqrestore(&jrp->outlock, flags);
+
+	/* reenable / unmask IRQs */
+	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+}
+
+/**
+ * caam_jr_register() - Alloc a ring for someone to use as needed. Returns
+ * an ordinal of the rings allocated, else returns -ENODEV if no rings
+ * are available.
+ * @ctrldev: points to the controller level dev (parent) that
+ *           owns rings available for use.
+ * @dev:     points to where a pointer to the newly allocated queue's
+ *           dev can be written to if successful.
+ **/
+int caam_jr_register(struct device *ctrldev, struct device **rdev)
+{
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_drv_private_jr *jrpriv = NULL;
+	unsigned long flags;
+	int ring;
+
+	/* Lock, if free ring - assign, unlock */
+	spin_lock_irqsave(&ctrlpriv->jr_alloc_lock, flags);
+	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
+		jrpriv = dev_get_drvdata(ctrlpriv->jrdev[ring]);
+		if (jrpriv->assign == JOBR_UNASSIGNED) {
+			jrpriv->assign = JOBR_ASSIGNED;
+			*rdev = ctrlpriv->jrdev[ring];
+			spin_unlock_irqrestore(&ctrlpriv->jr_alloc_lock, flags);
+			return ring;
+		}
+	}
+
+	/* If assigned, write dev where caller needs it */
+	spin_unlock_irqrestore(&ctrlpriv->jr_alloc_lock, flags);
+	*rdev = NULL;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(caam_jr_register);
+
+/**
+ * caam_jr_deregister() - Deregister an API and release the queue.
+ * Returns 0 if OK, -EBUSY if queue still contains pending entries
+ * or unprocessed results at the time of the call
+ * @dev     - points to the dev that identifies the queue to
+ *            be released.
+ **/
+int caam_jr_deregister(struct device *rdev)
+{
+	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(rdev);
+	struct caam_drv_private *ctrlpriv;
+	unsigned long flags;
+
+	/* Get the owning controller's private space */
+	ctrlpriv = dev_get_drvdata(jrpriv->parentdev);
+
+	/*
+	 * Make sure ring empty before release
+	 */
+	if (rd_reg32(&jrpriv->rregs->outring_used) ||
+	    (rd_reg32(&jrpriv->rregs->inpring_avail) != JOBR_DEPTH))
+		return -EBUSY;
+
+	/* Release ring */
+	spin_lock_irqsave(&ctrlpriv->jr_alloc_lock, flags);
+	jrpriv->assign = JOBR_UNASSIGNED;
+	spin_unlock_irqrestore(&ctrlpriv->jr_alloc_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(caam_jr_deregister);
+
+/**
+ * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,
+ * -EBUSY if the queue is full, -EIO if it cannot map the caller's
+ * descriptor.
+ * @dev:  device of the job ring to be used. This device should have
+ *        been assigned prior by caam_jr_register().
+ * @desc: points to a job descriptor that execute our request. All
+ *        descriptors (and all referenced data) must be in a DMAable
+ *        region, and all data references must be physical addresses
+ *        accessible to CAAM (i.e. within a PAMU window granted
+ *        to it).
+ * @cbk:  pointer to a callback function to be invoked upon completion
+ *        of this request. This has the form:
+ *        callback(struct device *dev, u32 *desc, u32 stat, void *arg)
+ *        where:
+ *        @dev:    contains the job ring device that processed this
+ *                 response.
+ *        @desc:   descriptor that initiated the request, same as
+ *                 "desc" being argued to caam_jr_enqueue().
+ *        @status: untranslated status received from CAAM. See the
+ *                 reference manual for a detailed description of
+ *                 error meaning, or see the JRSTA definitions in the
+ *                 register header file
+ *        @areq:   optional pointer to an argument passed with the
+ *                 original request
+ * @areq: optional pointer to a user argument for use at callback
+ *        time.
+ **/
+int caam_jr_enqueue(struct device *dev, u32 *desc,
+		    void (*cbk)(struct device *dev, u32 *desc,
+				u32 status, void *areq),
+		    void *areq)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_jrentry_info *head_entry;
+	unsigned long flags;
+	int head, tail, desc_size;
+	dma_addr_t desc_dma;
+
+	desc_size = (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
+	desc_dma = dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, desc_dma)) {
+		dev_err(dev, "caam_jr_enqueue(): can't map jobdesc\n");
+		return -EIO;
+	}
+
+	spin_lock_irqsave(&jrp->inplock, flags);
+
+	head = jrp->head;
+	tail = ACCESS_ONCE(jrp->tail);
+
+	if (!rd_reg32(&jrp->rregs->inpring_avail) ||
+	    CIRC_SPACE(head, tail, JOBR_DEPTH) <= 0) {
+		spin_unlock_irqrestore(&jrp->inplock, flags);
+		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);
+		return -EBUSY;
+	}
+
+	head_entry = &jrp->entinfo[head];
+	head_entry->desc_addr_virt = desc;
+	head_entry->desc_size = desc_size;
+	head_entry->callbk = (void *)cbk;
+	head_entry->cbkarg = areq;
+	head_entry->desc_addr_dma = desc_dma;
+
+	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
+
+	smp_wmb();
+
+	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
+				    (JOBR_DEPTH - 1);
+	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
+
+	wmb();
+
+	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
+
+	spin_unlock_irqrestore(&jrp->inplock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(caam_jr_enqueue);
+
+static int caam_reset_hw_jr(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	unsigned int timeout = 100000;
+
+	/*
+	 * FIXME: disabling IRQs here inhibits proper job completion
+	 * and error propagation
+	 */
+	disable_irq(jrp->irq);
+
+	/* initiate flush (required prior to reset) */
+	wr_reg32(&jrp->rregs->jrcommand, JRCR_RESET);
+	while (((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) ==
+		JRINT_ERR_HALT_INPROGRESS) && --timeout)
+		cpu_relax();
+
+	if ((rd_reg32(&jrp->rregs->jrintstatus) & JRINT_ERR_HALT_MASK) !=
+	    JRINT_ERR_HALT_COMPLETE || timeout == 0) {
+		dev_err(dev, "failed to flush job ring %d\n", jrp->ridx);
+		return -EIO;
+	}
+
+	/* initiate reset */
+	timeout = 100000;
+	wr_reg32(&jrp->rregs->jrcommand, JRCR_RESET);
+	while ((rd_reg32(&jrp->rregs->jrcommand) & JRCR_RESET) && --timeout)
+		cpu_relax();
+
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset job ring %d\n", jrp->ridx);
+		return -EIO;
+	}
+
+	enable_irq(jrp->irq);
+
+	return 0;
+}
+
+/*
+ * Init JobR independent of platform property detection
+ */
+static int caam_jr_init(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp;
+	dma_addr_t inpbusaddr, outbusaddr;
+	int i, error;
+
+	jrp = dev_get_drvdata(dev);
+
+	error = caam_reset_hw_jr(dev);
+	if (error)
+		return error;
+
+	jrp->inpring = kzalloc(sizeof(dma_addr_t) * JOBR_DEPTH,
+			       GFP_KERNEL | GFP_DMA);
+	jrp->outring = kzalloc(sizeof(struct jr_outentry) *
+			       JOBR_DEPTH, GFP_KERNEL | GFP_DMA);
+
+	jrp->entinfo = kzalloc(sizeof(struct caam_jrentry_info) * JOBR_DEPTH,
+			       GFP_KERNEL);
+
+	if ((jrp->inpring == NULL) || (jrp->outring == NULL) ||
+	    (jrp->entinfo == NULL)) {
+		dev_err(dev, "can't allocate job rings for %d\n",
+			jrp->ridx);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < JOBR_DEPTH; i++)
+		jrp->entinfo[i].desc_addr_dma = !0;
+
+	/* Setup rings */
+	inpbusaddr = dma_map_single(dev, jrp->inpring,
+				    sizeof(u32 *) * JOBR_DEPTH,
+				    DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, inpbusaddr)) {
+		dev_err(dev, "caam_jr_init(): can't map input ring\n");
+		kfree(jrp->inpring);
+		kfree(jrp->outring);
+		kfree(jrp->entinfo);
+		return -EIO;
+	}
+
+	outbusaddr = dma_map_single(dev, jrp->outring,
+				    sizeof(struct jr_outentry) * JOBR_DEPTH,
+				    DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, outbusaddr)) {
+		dev_err(dev, "caam_jr_init(): can't map output ring\n");
+			dma_unmap_single(dev, inpbusaddr,
+					 sizeof(u32 *) * JOBR_DEPTH,
+					 DMA_BIDIRECTIONAL);
+		kfree(jrp->inpring);
+		kfree(jrp->outring);
+		kfree(jrp->entinfo);
+		return -EIO;
+	}
+
+	jrp->inp_ring_write_index = 0;
+	jrp->out_ring_read_index = 0;
+	jrp->head = 0;
+	jrp->tail = 0;
+
+	wr_reg64(&jrp->rregs->inpring_base, inpbusaddr);
+	wr_reg64(&jrp->rregs->outring_base, outbusaddr);
+	wr_reg32(&jrp->rregs->inpring_size, JOBR_DEPTH);
+	wr_reg32(&jrp->rregs->outring_size, JOBR_DEPTH);
+
+	jrp->ringsize = JOBR_DEPTH;
+
+	spin_lock_init(&jrp->inplock);
+	spin_lock_init(&jrp->outlock);
+
+	/* Select interrupt coalescing parameters */
+	setbits32(&jrp->rregs->rconfig_lo, JOBR_INTC |
+		  (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
+		  (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
+
+	/* Connect job ring interrupt handler. */
+	for_each_possible_cpu(i)
+		tasklet_init(&jrp->irqtask[i], caam_jr_dequeue,
+			     (unsigned long)dev);
+
+	error = request_irq(jrp->irq, caam_jr_interrupt, 0,
+			    "caam-jobr", dev);
+	if (error) {
+		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
+			jrp->ridx, jrp->irq);
+		irq_dispose_mapping(jrp->irq);
+		jrp->irq = 0;
+		dma_unmap_single(dev, inpbusaddr, sizeof(u32 *) * JOBR_DEPTH,
+				 DMA_BIDIRECTIONAL);
+		dma_unmap_single(dev, outbusaddr, sizeof(u32 *) * JOBR_DEPTH,
+				 DMA_BIDIRECTIONAL);
+		kfree(jrp->inpring);
+		kfree(jrp->outring);
+		kfree(jrp->entinfo);
+		return -EINVAL;
+	}
+
+	jrp->assign = JOBR_UNASSIGNED;
+	return 0;
+}
+
+/*
+ * Shutdown JobR independent of platform property code
+ */
+int caam_jr_shutdown(struct device *dev)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	dma_addr_t inpbusaddr, outbusaddr;
+	int ret, i;
+
+	ret = caam_reset_hw_jr(dev);
+
+	for_each_possible_cpu(i)
+		tasklet_kill(&jrp->irqtask[i]);
+
+	/* Release interrupt */
+	free_irq(jrp->irq, dev);
+
+	/* Free rings */
+	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
+	outbusaddr = rd_reg64(&jrp->rregs->outring_base);
+	dma_unmap_single(dev, outbusaddr,
+			 sizeof(struct jr_outentry) * JOBR_DEPTH,
+			 DMA_BIDIRECTIONAL);
+	dma_unmap_single(dev, inpbusaddr, sizeof(u32 *) * JOBR_DEPTH,
+			 DMA_BIDIRECTIONAL);
+	kfree(jrp->outring);
+	kfree(jrp->inpring);
+	kfree(jrp->entinfo);
+
+	return ret;
+}
+
+/*
+ * Probe routine for each detected JobR subsystem. It assumes that
+ * property detection was picked up externally.
+ */
+int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
+		  int ring)
+{
+	struct device *ctrldev, *jrdev;
+	struct platform_device *jr_pdev;
+	struct caam_drv_private *ctrlpriv;
+	struct caam_drv_private_jr *jrpriv;
+	u32 *jroffset;
+	int error;
+
+	ctrldev = &pdev->dev;
+	ctrlpriv = dev_get_drvdata(ctrldev);
+
+	jrpriv = kmalloc(sizeof(struct caam_drv_private_jr),
+			 GFP_KERNEL);
+	if (jrpriv == NULL) {
+		dev_err(ctrldev, "can't alloc private mem for job ring %d\n",
+			ring);
+		return -ENOMEM;
+	}
+	jrpriv->parentdev = ctrldev; /* point back to parent */
+	jrpriv->ridx = ring; /* save ring identity relative to detection */
+
+	/*
+	 * Derive a pointer to the detected JobRs regs
+	 * Driver has already iomapped the entire space, we just
+	 * need to add in the offset to this JobR. Don't know if I
+	 * like this long-term, but it'll run
+	 */
+	jroffset = (u32 *)of_get_property(np, "reg", NULL);
+	jrpriv->rregs = (struct caam_job_ring __iomem *)((void *)ctrlpriv->ctrl
+							 + *jroffset);
+
+	/* Build a local dev for each detected queue */
+	jr_pdev = of_platform_device_create(np, NULL, ctrldev);
+	if (jr_pdev == NULL) {
+		kfree(jrpriv);
+		return -EINVAL;
+	}
+	jrdev = &jr_pdev->dev;
+	dev_set_drvdata(jrdev, jrpriv);
+	ctrlpriv->jrdev[ring] = jrdev;
+
+	/* Identify the interrupt */
+	jrpriv->irq = of_irq_to_resource(np, 0, NULL);
+
+	/* Now do the platform independent part */
+	error = caam_jr_init(jrdev); /* now turn on hardware */
+	if (error) {
+		kfree(jrpriv);
+		return error;
+	}
+
+	return error;
+}
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
new file mode 100644
index 0000000..c23df39
--- /dev/null
+++ b/drivers/crypto/caam/jr.h
@@ -0,0 +1,21 @@
+/*
+ * CAAM public-level include definitions for the JobR backend
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#ifndef JR_H
+#define JR_H
+
+/* Prototypes for backend-level services exposed to APIs */
+int caam_jr_register(struct device *ctrldev, struct device **rdev);
+int caam_jr_deregister(struct device *rdev);
+int caam_jr_enqueue(struct device *dev, u32 *desc,
+		    void (*cbk)(struct device *dev, u32 *desc, u32 status,
+				void *areq),
+		    void *areq);
+
+extern int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
+			 int ring);
+extern int caam_jr_shutdown(struct device *dev);
+#endif /* JR_H */
-- 
1.7.4.1

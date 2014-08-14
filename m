From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 07/12] crypto: caam - add Run Time Library (RTA) - part 3
Date: Thu, 14 Aug 2014 15:54:29 +0300
Message-ID: <1408020874-2211-8-git-send-email-horia.geanta@freescale.com>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:7099
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754381AbaHNM4E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:04 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace desc.h with a newer version from RTA.
While here, add also PROTOCOL command support
(not added in part 2 due to patch size limitations).

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Carmen Iorga <carmen.iorga@freescale.com>
---
 drivers/crypto/caam/Makefile            |    4 +-
 drivers/crypto/caam/compat.h            |    1 +
 drivers/crypto/caam/desc_constr.h       |    6 +-
 drivers/crypto/caam/error.c             |    2 +-
 drivers/crypto/caam/{ => flib}/desc.h   | 1317 ++++++++++++++++++++++++++-----
 drivers/crypto/caam/flib/desc/common.h  |  151 ++++
 drivers/crypto/caam/flib/desc/jobdesc.h |   57 ++
 drivers/crypto/caam/jr.c                |    2 +-
 8 files changed, 1340 insertions(+), 200 deletions(-)
 rename drivers/crypto/caam/{ => flib}/desc.h (54%)
 create mode 100644 drivers/crypto/caam/flib/desc/common.h
 create mode 100644 drivers/crypto/caam/flib/desc/jobdesc.h

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 550758a333e7..10a97a8a8391 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -2,9 +2,11 @@
 # Makefile for the CAAM backend and dependent components
 #
 ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
-	EXTRA_CFLAGS := -DDEBUG
+	ccflags-y := -DDEBUG
 endif
 
+ccflags-y += -I$(src)
+
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) += caam_jr.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index f227922cea38..8fe0f6993ab0 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/debugfs.h>
 #include <linux/circ_buf.h>
+#include <linux/bitops.h>
 #include <net/xfrm.h>
 
 #include <crypto/algapi.h>
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 7eec20bb3849..c344fbce1c67 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -4,13 +4,9 @@
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
-#include "desc.h"
+#include "flib/desc.h"
 
 #define IMMEDIATE (1 << 23)
-#define CAAM_CMD_SZ sizeof(u32)
-#define CAAM_PTR_SZ sizeof(dma_addr_t)
-#define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
-#define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
 
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 7d6ed4722345..5daa9cd4109a 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -7,7 +7,7 @@
 #include "compat.h"
 #include "regs.h"
 #include "intern.h"
-#include "desc.h"
+#include "flib/desc.h"
 #include "jr.h"
 #include "error.h"
 
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/flib/desc.h
similarity index 54%
rename from drivers/crypto/caam/desc.h
rename to drivers/crypto/caam/flib/desc.h
index eb8b870d03a9..9e669627af47 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/flib/desc.h
@@ -1,16 +1,26 @@
 /*
- * CAAM descriptor composition header
- * Definitions to support CAAM descriptor instruction generation
+ * SEC descriptor composition header.
+ * Definitions to support SEC descriptor instruction generation
  *
- * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ * Copyright 2008-2013 Freescale Semiconductor, Inc.
  */
 
-#ifndef DESC_H
-#define DESC_H
+#ifndef __RTA_DESC_H__
+#define __RTA_DESC_H__
 
-/* Max size of any CAAM descriptor in 32-bit words, inclusive of header */
+/* flib/compat.h is not delivered in kernel */
+#ifndef __KERNEL__
+#include "flib/compat.h"
+#endif
+
+/* Max size of any SEC descriptor in 32-bit words, inclusive of header */
 #define MAX_CAAM_DESCSIZE	64
 
+#define CAAM_CMD_SZ sizeof(uint32_t)
+#define CAAM_PTR_SZ sizeof(dma_addr_t)
+#define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
+#define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
+
 /* Block size of any entity covered/uncovered with a KEK/TKEK */
 #define KEK_BLOCKSIZE		16
 
@@ -19,7 +29,7 @@
  * inside a descriptor command word.
  */
 #define CMD_SHIFT		27
-#define CMD_MASK		0xf8000000
+#define CMD_MASK		(0x1f << CMD_SHIFT)
 
 #define CMD_KEY			(0x00 << CMD_SHIFT)
 #define CMD_SEQ_KEY		(0x01 << CMD_SHIFT)
@@ -27,20 +37,23 @@
 #define CMD_SEQ_LOAD		(0x03 << CMD_SHIFT)
 #define CMD_FIFO_LOAD		(0x04 << CMD_SHIFT)
 #define CMD_SEQ_FIFO_LOAD	(0x05 << CMD_SHIFT)
+#define CMD_MOVEDW		(0x06 << CMD_SHIFT)
+#define CMD_MOVEB		(0x07 << CMD_SHIFT)
 #define CMD_STORE		(0x0a << CMD_SHIFT)
 #define CMD_SEQ_STORE		(0x0b << CMD_SHIFT)
 #define CMD_FIFO_STORE		(0x0c << CMD_SHIFT)
 #define CMD_SEQ_FIFO_STORE	(0x0d << CMD_SHIFT)
 #define CMD_MOVE_LEN		(0x0e << CMD_SHIFT)
 #define CMD_MOVE		(0x0f << CMD_SHIFT)
-#define CMD_OPERATION		(0x10 << CMD_SHIFT)
-#define CMD_SIGNATURE		(0x12 << CMD_SHIFT)
-#define CMD_JUMP		(0x14 << CMD_SHIFT)
-#define CMD_MATH		(0x15 << CMD_SHIFT)
-#define CMD_DESC_HDR		(0x16 << CMD_SHIFT)
-#define CMD_SHARED_DESC_HDR	(0x17 << CMD_SHIFT)
-#define CMD_SEQ_IN_PTR		(0x1e << CMD_SHIFT)
-#define CMD_SEQ_OUT_PTR		(0x1f << CMD_SHIFT)
+#define CMD_OPERATION		((uint32_t)(0x10 << CMD_SHIFT))
+#define CMD_SIGNATURE		((uint32_t)(0x12 << CMD_SHIFT))
+#define CMD_JUMP		((uint32_t)(0x14 << CMD_SHIFT))
+#define CMD_MATH		((uint32_t)(0x15 << CMD_SHIFT))
+#define CMD_DESC_HDR		((uint32_t)(0x16 << CMD_SHIFT))
+#define CMD_SHARED_DESC_HDR	((uint32_t)(0x17 << CMD_SHIFT))
+#define CMD_MATHI               ((uint32_t)(0x1d << CMD_SHIFT))
+#define CMD_SEQ_IN_PTR		((uint32_t)(0x1e << CMD_SHIFT))
+#define CMD_SEQ_OUT_PTR		((uint32_t)(0x1f << CMD_SHIFT))
 
 /* General-purpose class selector for all commands */
 #define CLASS_SHIFT		25
@@ -51,23 +64,47 @@
 #define CLASS_2			(0x02 << CLASS_SHIFT)
 #define CLASS_BOTH		(0x03 << CLASS_SHIFT)
 
+/* ICV Check bits for Algo Operation command */
+#define ICV_CHECK_DISABLE	0
+#define ICV_CHECK_ENABLE	1
+
+
+/* Encap Mode check bits for Algo Operation command */
+#define DIR_ENC			1
+#define DIR_DEC			0
+
 /*
  * Descriptor header command constructs
  * Covers shared, job, and trusted descriptor headers
  */
 
 /*
- * Do Not Run - marks a descriptor inexecutable if there was
+ * Extended Job Descriptor Header
+ */
+#define HDR_EXT			BIT(24)
+
+/*
+ * Read input frame as soon as possible (SHR HDR)
+ */
+#define HDR_RIF			BIT(25)
+
+/*
+ * Require SEQ LIODN to be the Same  (JOB HDR)
+ */
+#define HDR_RSLS		BIT(25)
+
+/*
+ * Do Not Run - marks a descriptor not executable if there was
  * a preceding error somewhere
  */
-#define HDR_DNR			0x01000000
+#define HDR_DNR			BIT(24)
 
 /*
  * ONE - should always be set. Combination of ONE (always
  * set) and ZRO (always clear) forms an endianness sanity check
  */
-#define HDR_ONE			0x00800000
-#define HDR_ZRO			0x00008000
+#define HDR_ONE			BIT(23)
+#define HDR_ZRO			BIT(15)
 
 /* Start Index or SharedDesc Length */
 #define HDR_START_IDX_SHIFT	16
@@ -80,25 +117,34 @@
 #define HDR_DESCLEN_MASK	0x7f
 
 /* This is a TrustedDesc (if not SharedDesc) */
-#define HDR_TRUSTED		0x00004000
+#define HDR_TRUSTED		BIT(14)
 
 /* Make into TrustedDesc (if not SharedDesc) */
-#define HDR_MAKE_TRUSTED	0x00002000
+#define HDR_MAKE_TRUSTED	BIT(13)
+
+/* Clear Input FiFO (if SharedDesc) */
+#define HDR_CLEAR_IFIFO		BIT(13)
 
 /* Save context if self-shared (if SharedDesc) */
-#define HDR_SAVECTX		0x00001000
+#define HDR_SAVECTX		BIT(12)
 
 /* Next item points to SharedDesc */
-#define HDR_SHARED		0x00001000
+#define HDR_SHARED		BIT(12)
 
 /*
  * Reverse Execution Order - execute JobDesc first, then
  * execute SharedDesc (normally SharedDesc goes first).
  */
-#define HDR_REVERSE		0x00000800
+#define HDR_REVERSE		BIT(11)
+
+/* Propagate DNR property to SharedDesc */
+#define HDR_PROP_DNR		BIT(11)
 
-/* Propogate DNR property to SharedDesc */
-#define HDR_PROP_DNR		0x00000800
+/* DECO Select Valid */
+#define HDR_EXT_DSEL_VALID	BIT(7)
+
+/* Fake trusted descriptor */
+#define HDR_EXT_FTD		BIT(8)
 
 /* JobDesc/SharedDesc share property */
 #define HDR_SD_SHARE_SHIFT	8
@@ -121,40 +167,53 @@
  */
 
 /* Key Destination Class: 01 = Class 1, 02 - Class 2 */
-#define KEY_DEST_CLASS_SHIFT	25	/* use CLASS_1 or CLASS_2 */
+#define KEY_DEST_CLASS_SHIFT	25
 #define KEY_DEST_CLASS_MASK	(0x03 << KEY_DEST_CLASS_SHIFT)
+#define KEY_DEST_CLASS1		(1 << KEY_DEST_CLASS_SHIFT)
+#define KEY_DEST_CLASS2		(2 << KEY_DEST_CLASS_SHIFT)
 
 /* Scatter-Gather Table/Variable Length Field */
-#define KEY_SGF			0x01000000
-#define KEY_VLF			0x01000000
+#define KEY_SGF			BIT(24)
+#define KEY_VLF			BIT(24)
 
 /* Immediate - Key follows command in the descriptor */
-#define KEY_IMM			0x00800000
+#define KEY_IMM			BIT(23)
+
+/*
+ * Already in Input Data FIFO - the Input Data Sequence is not read, since it is
+ * already in the Input Data FIFO.
+ */
+#define KEY_AIDF		BIT(23)
 
 /*
  * Encrypted - Key is encrypted either with the KEK, or
- * with the TDKEK if TK is set
+ * with the TDKEK if this descriptor is trusted
  */
-#define KEY_ENC			0x00400000
+#define KEY_ENC			BIT(22)
 
 /*
  * No Write Back - Do not allow key to be FIFO STOREd
  */
-#define KEY_NWB			0x00200000
+#define KEY_NWB			BIT(21)
 
 /*
  * Enhanced Encryption of Key
  */
-#define KEY_EKT			0x00100000
+#define KEY_EKT			BIT(20)
 
 /*
  * Encrypted with Trusted Key
  */
-#define KEY_TK			0x00008000
+#define KEY_TK			BIT(15)
+
+/*
+ * Plaintext Store
+ */
+#define KEY_PTS			BIT(14)
 
 /*
  * KDEST - Key Destination: 0 - class key register,
- * 1 - PKHA 'e', 2 - AFHA Sbox, 3 - MDHA split-key
+ * 1 - PKHA 'e', 2 - AFHA Sbox, 3 - MDHA split key
  */
 #define KEY_DEST_SHIFT		16
 #define KEY_DEST_MASK		(0x03 << KEY_DEST_SHIFT)
@@ -183,13 +242,13 @@
 #define LDST_CLASS_DECO		(0x03 << LDST_CLASS_SHIFT)
 
 /* Scatter-Gather Table/Variable Length Field */
-#define LDST_SGF		0x01000000
-#define LDST_VLF		LDST_SGF
+#define LDST_SGF		BIT(24)
+#define LDST_VLF		BIT(24)
 
 /* Immediate - Key follows this command in descriptor */
 #define LDST_IMM_MASK		1
 #define LDST_IMM_SHIFT		23
-#define LDST_IMM		(LDST_IMM_MASK << LDST_IMM_SHIFT)
+#define LDST_IMM		BIT(23)
 
 /* SRC/DST - Destination for LOAD, Source for STORE */
 #define LDST_SRCDST_SHIFT	16
@@ -201,9 +260,13 @@
 #define LDST_SRCDST_BYTE_OUTFIFO	(0x7e << LDST_SRCDST_SHIFT)
 
 #define LDST_SRCDST_WORD_MODE_REG	(0x00 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_JQCTRL	(0x00 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_KEYSZ_REG	(0x01 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_JQDAR	(0x01 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DATASZ_REG	(0x02 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_STAT	(0x02 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_ICVSZ_REG	(0x03 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_PID		(0x04 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_CHACTRL	(0x06 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DECOCTRL	(0x06 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_IRQCTRL	(0x07 << LDST_SRCDST_SHIFT)
@@ -218,15 +281,26 @@
 #define LDST_SRCDST_WORD_CLASS1_IV_SZ	(0x0c << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_ALTDS_CLASS1	(0x0f << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_A_SZ	(0x10 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_GTR		(0x10 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_B_SZ	(0x11 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_N_SZ	(0x12 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_E_SZ	(0x13 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_CLASS_CTX	(0x20 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_STR		(0x20 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF	(0x40 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_JOB	(0x41 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_SHARED	(0x42 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_JOB_WE	(0x45 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_SHARED_WE (0x46 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_INFO_FIFO_SZL	(0x70 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_INFO_FIFO_SZM	(0x71 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_INFO_FIFO_L	(0x72 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_INFO_FIFO_M	(0x73 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_SZL		(0x74 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_SZM		(0x75 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_IFNSR		(0x76 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_OFNSR		(0x77 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_BYTE_ALTSOURCE	(0x78 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_INFO_FIFO	(0x7a << LDST_SRCDST_SHIFT)
 
 /* Offset in source/destination */
@@ -241,8 +315,8 @@
 #define LDOFF_CHG_SHARE_OK_PROP		(0x2 << LDOFF_CHG_SHARE_SHIFT)
 #define LDOFF_CHG_SHARE_OK_NO_PROP	(0x3 << LDOFF_CHG_SHARE_SHIFT)
 
-#define LDOFF_ENABLE_AUTO_NFIFO		(1 << 2)
-#define LDOFF_DISABLE_AUTO_NFIFO	(1 << 3)
+#define LDOFF_ENABLE_AUTO_NFIFO		BIT(2)
+#define LDOFF_DISABLE_AUTO_NFIFO	BIT(3)
 
 #define LDOFF_CHG_NONSEQLIODN_SHIFT	4
 #define LDOFF_CHG_NONSEQLIODN_MASK	(0x3 << LDOFF_CHG_NONSEQLIODN_SHIFT)
@@ -256,19 +330,94 @@
 #define LDOFF_CHG_SEQLIODN_NON_SEQ	(0x2 << LDOFF_CHG_SEQLIODN_SHIFT)
 #define LDOFF_CHG_SEQLIODN_TRUSTED	(0x3 << LDOFF_CHG_SEQLIODN_SHIFT)
 
-/* Data length in bytes	*/
+/* Data length in bytes */
 #define LDST_LEN_SHIFT		0
 #define LDST_LEN_MASK		(0xff << LDST_LEN_SHIFT)
 
 /* Special Length definitions when dst=deco-ctrl */
-#define LDLEN_ENABLE_OSL_COUNT		(1 << 7)
-#define LDLEN_RST_CHA_OFIFO_PTR		(1 << 6)
-#define LDLEN_RST_OFIFO			(1 << 5)
-#define LDLEN_SET_OFIFO_OFF_VALID	(1 << 4)
-#define LDLEN_SET_OFIFO_OFF_RSVD	(1 << 3)
+#define LDLEN_ENABLE_OSL_COUNT		BIT(7)
+#define LDLEN_RST_CHA_OFIFO_PTR		BIT(6)
+#define LDLEN_RST_OFIFO			BIT(5)
+#define LDLEN_SET_OFIFO_OFF_VALID	BIT(4)
+#define LDLEN_SET_OFIFO_OFF_RSVD	BIT(3)
 #define LDLEN_SET_OFIFO_OFFSET_SHIFT	0
 #define LDLEN_SET_OFIFO_OFFSET_MASK	(3 << LDLEN_SET_OFIFO_OFFSET_SHIFT)
 
+/* CCB Clear Written Register bits */
+#define CLRW_CLR_C1MODE              BIT(0)
+#define CLRW_CLR_C1DATAS             BIT(2)
+#define CLRW_CLR_C1ICV               BIT(3)
+#define CLRW_CLR_C1CTX               BIT(5)
+#define CLRW_CLR_C1KEY               BIT(6)
+#define CLRW_CLR_PK_A                BIT(12)
+#define CLRW_CLR_PK_B                BIT(13)
+#define CLRW_CLR_PK_N                BIT(14)
+#define CLRW_CLR_PK_E                BIT(15)
+#define CLRW_CLR_C2MODE              BIT(16)
+#define CLRW_CLR_C2KEYS              BIT(17)
+#define CLRW_CLR_C2DATAS             BIT(18)
+#define CLRW_CLR_C2CTX               BIT(21)
+#define CLRW_CLR_C2KEY               BIT(22)
+#define CLRW_RESET_CLS2_DONE         BIT(26) /* era 4 */
+#define CLRW_RESET_CLS1_DONE         BIT(27) /* era 4 */
+#define CLRW_RESET_CLS2_CHA          BIT(28) /* era 4 */
+#define CLRW_RESET_CLS1_CHA          BIT(29) /* era 4 */
+#define CLRW_RESET_OFIFO             BIT(30) /* era 3 */
+#define CLRW_RESET_IFIFO_DFIFO       BIT(31) /* era 3 */
+
+/* CHA Control Register bits */
+#define CCTRL_RESET_CHA_ALL          BIT(0)
+#define CCTRL_RESET_CHA_AESA         BIT(1)
+#define CCTRL_RESET_CHA_DESA         BIT(2)
+#define CCTRL_RESET_CHA_AFHA         BIT(3)
+#define CCTRL_RESET_CHA_KFHA         BIT(4)
+#define CCTRL_RESET_CHA_SF8A         BIT(5)
+#define CCTRL_RESET_CHA_PKHA         BIT(6)
+#define CCTRL_RESET_CHA_MDHA         BIT(7)
+#define CCTRL_RESET_CHA_CRCA         BIT(8)
+#define CCTRL_RESET_CHA_RNG          BIT(9)
+#define CCTRL_RESET_CHA_SF9A         BIT(10)
+#define CCTRL_RESET_CHA_ZUCE         BIT(11)
+#define CCTRL_RESET_CHA_ZUCA         BIT(12)
+#define CCTRL_UNLOAD_PK_A0           BIT(16)
+#define CCTRL_UNLOAD_PK_A1           BIT(17)
+#define CCTRL_UNLOAD_PK_A2           BIT(18)
+#define CCTRL_UNLOAD_PK_A3           BIT(19)
+#define CCTRL_UNLOAD_PK_B0           BIT(20)
+#define CCTRL_UNLOAD_PK_B1           BIT(21)
+#define CCTRL_UNLOAD_PK_B2           BIT(22)
+#define CCTRL_UNLOAD_PK_B3           BIT(23)
+#define CCTRL_UNLOAD_PK_N            BIT(24)
+#define CCTRL_UNLOAD_PK_A            BIT(26)
+#define CCTRL_UNLOAD_PK_B            BIT(27)
+#define CCTRL_UNLOAD_SBOX            BIT(28)
+
+/* IRQ Control Register (CxCIRQ) bits */
+#define CIRQ_ADI	BIT(1)
+#define CIRQ_DDI	BIT(2)
+#define CIRQ_RCDI	BIT(3)
+#define CIRQ_KDI	BIT(4)
+#define CIRQ_S8DI	BIT(5)
+#define CIRQ_PDI	BIT(6)
+#define CIRQ_MDI	BIT(7)
+#define CIRQ_CDI	BIT(8)
+#define CIRQ_RNDI	BIT(9)
+#define CIRQ_S9DI	BIT(10)
+#define CIRQ_ZEDI	BIT(11) /* valid for Era 5 or higher */
+#define CIRQ_ZADI	BIT(12) /* valid for Era 5 or higher */
+#define CIRQ_AEI	BIT(17)
+#define CIRQ_DEI	BIT(18)
+#define CIRQ_RCEI	BIT(19)
+#define CIRQ_KEI	BIT(20)
+#define CIRQ_S8EI	BIT(21)
+#define CIRQ_PEI	BIT(22)
+#define CIRQ_MEI	BIT(23)
+#define CIRQ_CEI	BIT(24)
+#define CIRQ_RNEI	BIT(25)
+#define CIRQ_S9EI	BIT(26)
+#define CIRQ_ZEEI	BIT(27) /* valid for Era 5 or higher */
+#define CIRQ_ZAEI	BIT(28) /* valid for Era 5 or higher */
+
 /*
  * FIFO_LOAD/FIFO_STORE/SEQ_FIFO_LOAD/SEQ_FIFO_STORE
  * Command Constructs
@@ -291,6 +440,7 @@
 #define FIFOST_CLASS_NORMAL	(0x00 << FIFOST_CLASS_SHIFT)
 #define FIFOST_CLASS_CLASS1KEY	(0x01 << FIFOST_CLASS_SHIFT)
 #define FIFOST_CLASS_CLASS2KEY	(0x02 << FIFOST_CLASS_SHIFT)
+#define FIFOST_CLASS_BOTH	(0x03 << FIFOST_CLASS_SHIFT)
 
 /*
  * Scatter-Gather Table/Variable Length Field
@@ -300,17 +450,27 @@
 #define FIFOLDST_SGF_SHIFT	24
 #define FIFOLDST_SGF_MASK	(1 << FIFOLDST_SGF_SHIFT)
 #define FIFOLDST_VLF_MASK	(1 << FIFOLDST_SGF_SHIFT)
-#define FIFOLDST_SGF		(1 << FIFOLDST_SGF_SHIFT)
-#define FIFOLDST_VLF		(1 << FIFOLDST_SGF_SHIFT)
+#define FIFOLDST_SGF		BIT(24)
+#define FIFOLDST_VLF		BIT(24)
 
-/* Immediate - Data follows command in descriptor */
+/*
+ * Immediate - Data follows command in descriptor
+ * AIDF - Already in Input Data FIFO
+ */
 #define FIFOLD_IMM_SHIFT	23
 #define FIFOLD_IMM_MASK		(1 << FIFOLD_IMM_SHIFT)
-#define FIFOLD_IMM		(1 << FIFOLD_IMM_SHIFT)
+#define FIFOLD_AIDF_MASK	(1 << FIFOLD_IMM_SHIFT)
+#define FIFOLD_IMM		BIT(23)
+#define FIFOLD_AIDF		BIT(23)
+
+#define FIFOST_IMM_SHIFT	23
+#define FIFOST_IMM_MASK		(1 << FIFOST_IMM_SHIFT)
+#define FIFOST_IMM		BIT(23)
 
 /* Continue - Not the last FIFO store to come */
 #define FIFOST_CONT_SHIFT	23
 #define FIFOST_CONT_MASK	(1 << FIFOST_CONT_SHIFT)
+#define FIFOST_CONT		BIT(23)
 
 /*
  * Extended Length - use 32-bit extended length that
@@ -318,7 +478,7 @@
  */
 #define FIFOLDST_EXT_SHIFT	22
 #define FIFOLDST_EXT_MASK	(1 << FIFOLDST_EXT_SHIFT)
-#define FIFOLDST_EXT		(1 << FIFOLDST_EXT_SHIFT)
+#define FIFOLDST_EXT		BIT(22)
 
 /* Input data type.*/
 #define FIFOLD_TYPE_SHIFT	16
@@ -360,7 +520,7 @@
 #define FIFOLD_TYPE_LAST2FLUSH1 (0x05 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LASTBOTH	(0x06 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LASTBOTHFL	(0x07 << FIFOLD_TYPE_SHIFT)
-#define FIFOLD_TYPE_NOINFOFIFO	(0x0F << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_NOINFOFIFO	(0x0f << FIFOLD_TYPE_SHIFT)
 
 #define FIFOLDST_LEN_MASK	0xffff
 #define FIFOLDST_EXT_LEN_MASK	0xffffffff
@@ -393,6 +553,7 @@
 #define FIFOST_TYPE_MESSAGE_DATA (0x30 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_RNGSTORE	 (0x34 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_RNGFIFO	 (0x35 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_METADATA	 (0x3e << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_SKIP	 (0x3f << FIFOST_TYPE_SHIFT)
 
 /*
@@ -412,7 +573,7 @@
 
 /* ProtocolID selectors - PROTID */
 #define OP_PCLID_SHIFT		16
-#define OP_PCLID_MASK		(0xff << 16)
+#define OP_PCLID_MASK		(0xff << OP_PCLID_SHIFT)
 
 /* Assuming OP_TYPE = OP_TYPE_UNI_PROTOCOL */
 #define OP_PCLID_IKEV1_PRF	(0x01 << OP_PCLID_SHIFT)
@@ -420,13 +581,14 @@
 #define OP_PCLID_SSL30_PRF	(0x08 << OP_PCLID_SHIFT)
 #define OP_PCLID_TLS10_PRF	(0x09 << OP_PCLID_SHIFT)
 #define OP_PCLID_TLS11_PRF	(0x0a << OP_PCLID_SHIFT)
+#define OP_PCLID_TLS12_PRF	(0x0b << OP_PCLID_SHIFT)
 #define OP_PCLID_DTLS10_PRF	(0x0c << OP_PCLID_SHIFT)
-#define OP_PCLID_PRF		(0x06 << OP_PCLID_SHIFT)
-#define OP_PCLID_BLOB		(0x0d << OP_PCLID_SHIFT)
-#define OP_PCLID_SECRETKEY	(0x11 << OP_PCLID_SHIFT)
 #define OP_PCLID_PUBLICKEYPAIR	(0x14 << OP_PCLID_SHIFT)
 #define OP_PCLID_DSASIGN	(0x15 << OP_PCLID_SHIFT)
 #define OP_PCLID_DSAVERIFY	(0x16 << OP_PCLID_SHIFT)
+#define OP_PCLID_DIFFIEHELLMAN	(0x17 << OP_PCLID_SHIFT)
+#define OP_PCLID_RSAENCRYPT	(0x18 << OP_PCLID_SHIFT)
+#define OP_PCLID_RSADECRYPT	(0x19 << OP_PCLID_SHIFT)
 
 /* Assuming OP_TYPE = OP_TYPE_DECAP_PROTOCOL/ENCAP_PROTOCOL */
 #define OP_PCLID_IPSEC		(0x01 << OP_PCLID_SHIFT)
@@ -438,7 +600,15 @@
 #define OP_PCLID_TLS10		(0x09 << OP_PCLID_SHIFT)
 #define OP_PCLID_TLS11		(0x0a << OP_PCLID_SHIFT)
 #define OP_PCLID_TLS12		(0x0b << OP_PCLID_SHIFT)
-#define OP_PCLID_DTLS		(0x0c << OP_PCLID_SHIFT)
+#define OP_PCLID_DTLS10		(0x0c << OP_PCLID_SHIFT)
+#define OP_PCLID_BLOB		(0x0d << OP_PCLID_SHIFT)
+#define OP_PCLID_IPSEC_NEW	(0x11 << OP_PCLID_SHIFT)
+#define OP_PCLID_3G_DCRC	(0x31 << OP_PCLID_SHIFT)
+#define OP_PCLID_3G_RLC_PDU	(0x32 << OP_PCLID_SHIFT)
+#define OP_PCLID_3G_RLC_SDU	(0x33 << OP_PCLID_SHIFT)
+#define OP_PCLID_LTE_PDCP_USER	(0x42 << OP_PCLID_SHIFT)
+#define OP_PCLID_LTE_PDCP_CTRL	(0x43 << OP_PCLID_SHIFT)
+#define OP_PCLID_LTE_PDCP_CTRL_MIXED	(0x44 << OP_PCLID_SHIFT)
 
 /*
  * ProtocolInfo selectors
@@ -452,6 +622,7 @@
 #define OP_PCL_IPSEC_DES_IV64			 0x0100
 #define OP_PCL_IPSEC_DES			 0x0200
 #define OP_PCL_IPSEC_3DES			 0x0300
+#define OP_PCL_IPSEC_NULL			 0x0B00
 #define OP_PCL_IPSEC_AES_CBC			 0x0c00
 #define OP_PCL_IPSEC_AES_CTR			 0x0d00
 #define OP_PCL_IPSEC_AES_XTS			 0x1600
@@ -461,6 +632,7 @@
 #define OP_PCL_IPSEC_AES_GCM8			 0x1200
 #define OP_PCL_IPSEC_AES_GCM12			 0x1300
 #define OP_PCL_IPSEC_AES_GCM16			 0x1400
+#define OP_PCL_IPSEC_AES_NULL_WITH_GMAC		 0x1500
 
 #define OP_PCL_IPSEC_HMAC_NULL			 0x0000
 #define OP_PCL_IPSEC_HMAC_MD5_96		 0x0001
@@ -468,6 +640,7 @@
 #define OP_PCL_IPSEC_AES_XCBC_MAC_96		 0x0005
 #define OP_PCL_IPSEC_HMAC_MD5_128		 0x0006
 #define OP_PCL_IPSEC_HMAC_SHA1_160		 0x0007
+#define OP_PCL_IPSEC_AES_CMAC_96		 0x0008
 #define OP_PCL_IPSEC_HMAC_SHA2_256_128		 0x000c
 #define OP_PCL_IPSEC_HMAC_SHA2_384_192		 0x000d
 #define OP_PCL_IPSEC_HMAC_SHA2_512_256		 0x000e
@@ -517,6 +690,32 @@
 #define OP_PCL_SSL30_AES_256_CBC_SHA_16		 0xc021
 #define OP_PCL_SSL30_AES_256_CBC_SHA_17		 0xc022
 
+#define OP_PCL_SSL30_AES_128_GCM_SHA256_1	 0x009C
+#define OP_PCL_SSL30_AES_256_GCM_SHA384_1	 0x009D
+#define OP_PCL_SSL30_AES_128_GCM_SHA256_2	 0x009E
+#define OP_PCL_SSL30_AES_256_GCM_SHA384_2	 0x009F
+#define OP_PCL_SSL30_AES_128_GCM_SHA256_3	 0x00A0
+#define OP_PCL_SSL30_AES_256_GCM_SHA384_3	 0x00A1
+#define OP_PCL_SSL30_AES_128_GCM_SHA256_4	 0x00A2
+#define OP_PCL_SSL30_AES_256_GCM_SHA384_4	 0x00A3
+#define OP_PCL_SSL30_AES_128_GCM_SHA256_5	 0x00A4
+#define OP_PCL_SSL30_AES_256_GCM_SHA384_5	 0x00A5
+#define OP_PCL_SSL30_AES_128_GCM_SHA256_6	 0x00A6
+
+#define OP_PCL_TLS_DH_ANON_AES_256_GCM_SHA384	 0x00A7
+#define OP_PCL_TLS_PSK_AES_128_GCM_SHA256	 0x00A8
+#define OP_PCL_TLS_PSK_AES_256_GCM_SHA384	 0x00A9
+#define OP_PCL_TLS_DHE_PSK_AES_128_GCM_SHA256	 0x00AA
+#define OP_PCL_TLS_DHE_PSK_AES_256_GCM_SHA384	 0x00AB
+#define OP_PCL_TLS_RSA_PSK_AES_128_GCM_SHA256	 0x00AC
+#define OP_PCL_TLS_RSA_PSK_AES_256_GCM_SHA384	 0x00AD
+#define OP_PCL_TLS_PSK_AES_128_CBC_SHA256	 0x00AE
+#define OP_PCL_TLS_PSK_AES_256_CBC_SHA384	 0x00AF
+#define OP_PCL_TLS_DHE_PSK_AES_128_CBC_SHA256	 0x00B2
+#define OP_PCL_TLS_DHE_PSK_AES_256_CBC_SHA384	 0x00B3
+#define OP_PCL_TLS_RSA_PSK_AES_128_CBC_SHA256	 0x00B6
+#define OP_PCL_TLS_RSA_PSK_AES_256_CBC_SHA384	 0x00B7
+
 #define OP_PCL_SSL30_3DES_EDE_CBC_MD5		 0x0023
 
 #define OP_PCL_SSL30_3DES_EDE_CBC_SHA		 0x001f
@@ -617,6 +816,29 @@
 #define OP_PCL_TLS10_AES_256_CBC_SHA_16		 0xc021
 #define OP_PCL_TLS10_AES_256_CBC_SHA_17		 0xc022
 
+#define OP_PCL_TLS_ECDHE_ECDSA_AES_128_CBC_SHA256  0xC023
+#define OP_PCL_TLS_ECDHE_ECDSA_AES_256_CBC_SHA384  0xC024
+#define OP_PCL_TLS_ECDH_ECDSA_AES_128_CBC_SHA256   0xC025
+#define OP_PCL_TLS_ECDH_ECDSA_AES_256_CBC_SHA384   0xC026
+#define OP_PCL_TLS_ECDHE_RSA_AES_128_CBC_SHA256	   0xC027
+#define OP_PCL_TLS_ECDHE_RSA_AES_256_CBC_SHA384	   0xC028
+#define OP_PCL_TLS_ECDH_RSA_AES_128_CBC_SHA256	   0xC029
+#define OP_PCL_TLS_ECDH_RSA_AES_256_CBC_SHA384	   0xC02A
+#define OP_PCL_TLS_ECDHE_ECDSA_AES_128_GCM_SHA256  0xC02B
+#define OP_PCL_TLS_ECDHE_ECDSA_AES_256_GCM_SHA384  0xC02C
+#define OP_PCL_TLS_ECDH_ECDSA_AES_128_GCM_SHA256   0xC02D
+#define OP_PCL_TLS_ECDH_ECDSA_AES_256_GCM_SHA384   0xC02E
+#define OP_PCL_TLS_ECDHE_RSA_AES_128_GCM_SHA256	   0xC02F
+#define OP_PCL_TLS_ECDHE_RSA_AES_256_GCM_SHA384	   0xC030
+#define OP_PCL_TLS_ECDH_RSA_AES_128_GCM_SHA256	   0xC031
+#define OP_PCL_TLS_ECDH_RSA_AES_256_GCM_SHA384	   0xC032
+#define OP_PCL_TLS_ECDHE_PSK_RC4_128_SHA	   0xC033
+#define OP_PCL_TLS_ECDHE_PSK_3DES_EDE_CBC_SHA	   0xC034
+#define OP_PCL_TLS_ECDHE_PSK_AES_128_CBC_SHA	   0xC035
+#define OP_PCL_TLS_ECDHE_PSK_AES_256_CBC_SHA	   0xC036
+#define OP_PCL_TLS_ECDHE_PSK_AES_128_CBC_SHA256	   0xC037
+#define OP_PCL_TLS_ECDHE_PSK_AES_256_CBC_SHA384	   0xC038
+
 /* #define OP_PCL_TLS10_3DES_EDE_CBC_MD5	0x0023 */
 
 #define OP_PCL_TLS10_3DES_EDE_CBC_SHA		 0x001f
@@ -702,6 +924,13 @@
 #define OP_PCL_TLS10_AES_256_CBC_SHA384		 0xff63
 #define OP_PCL_TLS10_AES_256_CBC_SHA512		 0xff65
 
+#define OP_PCL_TLS_PVT_AES_192_CBC_SHA160	 0xff90
+#define OP_PCL_TLS_PVT_AES_192_CBC_SHA384	 0xff93
+#define OP_PCL_TLS_PVT_AES_192_CBC_SHA224	 0xff94
+#define OP_PCL_TLS_PVT_AES_192_CBC_SHA512	 0xff95
+#define OP_PCL_TLS_PVT_AES_192_CBC_SHA256	 0xff96
+#define OP_PCL_TLS_PVT_MASTER_SECRET_PRF_FE	 0xfffe
+#define OP_PCL_TLS_PVT_MASTER_SECRET_PRF_FF	 0xffff
 
 
 /* For TLS 1.1 - OP_PCLID_TLS11 */
@@ -1043,7 +1272,6 @@
 #define OP_PCL_DTLS_DES_CBC_SHA_6		 0x0015
 #define OP_PCL_DTLS_DES_CBC_SHA_7		 0x001a
 
-
 #define OP_PCL_DTLS_3DES_EDE_CBC_MD5		 0xff23
 #define OP_PCL_DTLS_3DES_EDE_CBC_SHA160		 0xff30
 #define OP_PCL_DTLS_3DES_EDE_CBC_SHA224		 0xff34
@@ -1076,17 +1304,126 @@
 /* MacSec protinfos */
 #define OP_PCL_MACSEC				 0x0001
 
+/* 3G DCRC protinfos */
+#define OP_PCL_3G_DCRC_CRC7			 0x0710
+#define OP_PCL_3G_DCRC_CRC11			 0x0B10
+
+/* 3G RLC protinfos */
+#define OP_PCL_3G_RLC_NULL			 0x0000
+#define OP_PCL_3G_RLC_KASUMI			 0x0001
+#define OP_PCL_3G_RLC_SNOW			 0x0002
+
+/* LTE protinfos */
+#define OP_PCL_LTE_NULL				 0x0000
+#define OP_PCL_LTE_SNOW				 0x0001
+#define OP_PCL_LTE_AES				 0x0002
+#define OP_PCL_LTE_ZUC				 0x0003
+
+/* LTE mixed protinfos */
+#define OP_PCL_LTE_MIXED_AUTH_SHIFT	0
+#define OP_PCL_LTE_MIXED_AUTH_MASK	(3 << OP_PCL_LTE_MIXED_AUTH_SHIFT)
+#define OP_PCL_LTE_MIXED_ENC_SHIFT	8
+#define OP_PCL_LTE_MIXED_ENC_MASK	(3 < OP_PCL_LTE_MIXED_ENC_SHIFT)
+#define OP_PCL_LTE_MIXED_AUTH_NULL	(OP_PCL_LTE_NULL << \
+					 OP_PCL_LTE_MIXED_AUTH_SHIFT)
+#define OP_PCL_LTE_MIXED_AUTH_SNOW	(OP_PCL_LTE_SNOW << \
+					 OP_PCL_LTE_MIXED_AUTH_SHIFT)
+#define OP_PCL_LTE_MIXED_AUTH_AES	(OP_PCL_LTE_AES << \
+					 OP_PCL_LTE_MIXED_AUTH_SHIFT)
+#define OP_PCL_LTE_MIXED_AUTH_ZUC	(OP_PCL_LTE_ZUC << \
+					 OP_PCL_LTE_MIXED_AUTH_SHIFT)
+#define OP_PCL_LTE_MIXED_ENC_NULL	(OP_PCL_LTE_NULL << \
+					 OP_PCL_LTE_MIXED_ENC_SHIFT)
+#define OP_PCL_LTE_MIXED_ENC_SNOW	(OP_PCL_LTE_SNOW << \
+					 OP_PCL_LTE_MIXED_ENC_SHIFT)
+#define OP_PCL_LTE_MIXED_ENC_AES	(OP_PCL_LTE_AES << \
+					 OP_PCL_LTE_MIXED_ENC_SHIFT)
+#define OP_PCL_LTE_MIXED_ENC_ZUC	(OP_PCL_LTE_ZUC << \
+					 OP_PCL_LTE_MIXED_ENC_SHIFT)
+
+/* PKI unidirectional protocol protinfo bits */
+#define OP_PCL_PKPROT_DSA_MSG		BIT(10)
+#define OP_PCL_PKPROT_HASH_SHIFT	7
+#define OP_PCL_PKPROT_HASH_MASK		(7 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_HASH_MD5		(0 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_HASH_SHA1		(1 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_HASH_SHA224	(2 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_HASH_SHA256	(3 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_HASH_SHA384	(4 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_HASH_SHA512	(5 << OP_PCL_PKPROT_HASH_SHIFT)
+#define OP_PCL_PKPROT_EKT_Z		BIT(6)
+#define OP_PCL_PKPROT_DECRYPT_Z		BIT(5)
+#define OP_PCL_PKPROT_EKT_PRI		BIT(4)
+#define OP_PCL_PKPROT_TEST		BIT(3)
+#define OP_PCL_PKPROT_DECRYPT_PRI	BIT(2)
+#define OP_PCL_PKPROT_ECC		BIT(1)
+#define OP_PCL_PKPROT_F2M		BIT(0)
+
+/* Blob protinfos */
+#define OP_PCL_BLOB_TKEK_SHIFT		9
+#define OP_PCL_BLOB_TKEK		BIT(9)
+#define OP_PCL_BLOB_EKT_SHIFT		8
+#define OP_PCL_BLOB_EKT			BIT(8)
+#define OP_PCL_BLOB_REG_SHIFT		4
+#define OP_PCL_BLOB_REG_MASK		(0xF << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_REG_MEMORY		(0x0 << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_REG_KEY1		(0x1 << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_REG_KEY2		(0x3 << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_AFHA_SBOX		(0x5 << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_REG_SPLIT		(0x7 << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_REG_PKE		(0x9 << OP_PCL_BLOB_REG_SHIFT)
+#define OP_PCL_BLOB_SEC_MEM_SHIFT	3
+#define OP_PCL_BLOB_SEC_MEM		BIT(3)
+#define OP_PCL_BLOB_BLACK		BIT(2)
+#define OP_PCL_BLOB_FORMAT_SHIFT	0
+#define OP_PCL_BLOB_FORMAT_MASK		0x3
+#define OP_PCL_BLOB_FORMAT_NORMAL	0
+#define OP_PCL_BLOB_FORMAT_MASTER_VER	2
+#define OP_PCL_BLOB_FORMAT_TEST		3
+
+/* IKE / IKEv2 protinfos */
+#define OP_PCL_IKE_HMAC_MD5		0x0100
+#define OP_PCL_IKE_HMAC_SHA1		0x0200
+#define OP_PCL_IKE_HMAC_AES128_CBC	0x0400
+#define OP_PCL_IKE_HMAC_SHA256		0x0500
+#define OP_PCL_IKE_HMAC_SHA384		0x0600
+#define OP_PCL_IKE_HMAC_SHA512		0x0700
+#define OP_PCL_IKE_HMAC_AES128_CMAC	0x0800
+
 /* PKI unidirectional protocol protinfo bits */
-#define OP_PCL_PKPROT_TEST			 0x0008
-#define OP_PCL_PKPROT_DECRYPT			 0x0004
-#define OP_PCL_PKPROT_ECC			 0x0002
-#define OP_PCL_PKPROT_F2M			 0x0001
+#define OP_PCL_PKPROT_TEST		BIT(3)
+#define OP_PCL_PKPROT_DECRYPT		BIT(2)
+#define OP_PCL_PKPROT_ECC		BIT(1)
+#define OP_PCL_PKPROT_F2M		BIT(0)
+
+/* RSA Protinfo */
+#define OP_PCL_RSAPROT_OP_MASK		3
+#define OP_PCL_RSAPROT_OP_ENC_F_IN	0
+#define OP_PCL_RSAPROT_OP_ENC_F_OUT	1
+#define OP_PCL_RSAPROT_OP_DEC_ND	0
+#define OP_PCL_RSAPROT_OP_DEC_PQD	1
+#define OP_PCL_RSAPROT_OP_DEC_PQDPDQC	2
+#define OP_PCL_RSAPROT_FFF_SHIFT	4
+#define OP_PCL_RSAPROT_FFF_MASK		(7 << OP_PCL_RSAPROT_FFF_SHIFT)
+#define OP_PCL_RSAPROT_FFF_RED		(0 << OP_PCL_RSAPROT_FFF_SHIFT)
+#define OP_PCL_RSAPROT_FFF_ENC		(1 << OP_PCL_RSAPROT_FFF_SHIFT)
+#define OP_PCL_RSAPROT_FFF_TK_ENC	(5 << OP_PCL_RSAPROT_FFF_SHIFT)
+#define OP_PCL_RSAPROT_FFF_EKT		(3 << OP_PCL_RSAPROT_FFF_SHIFT)
+#define OP_PCL_RSAPROT_FFF_TK_EKT	(7 << OP_PCL_RSAPROT_FFF_SHIFT)
+#define OP_PCL_RSAPROT_PPP_SHIFT	8
+#define OP_PCL_RSAPROT_PPP_MASK		(7 << OP_PCL_RSAPROT_PPP_SHIFT)
+#define OP_PCL_RSAPROT_PPP_RED		(0 << OP_PCL_RSAPROT_PPP_SHIFT)
+#define OP_PCL_RSAPROT_PPP_ENC		(1 << OP_PCL_RSAPROT_PPP_SHIFT)
+#define OP_PCL_RSAPROT_PPP_TK_ENC	(5 << OP_PCL_RSAPROT_PPP_SHIFT)
+#define OP_PCL_RSAPROT_PPP_EKT		(3 << OP_PCL_RSAPROT_PPP_SHIFT)
+#define OP_PCL_RSAPROT_PPP_TK_EKT	(7 << OP_PCL_RSAPROT_PPP_SHIFT)
+#define OP_PCL_RSAPROT_FMT_PKCSV15	BIT(12)
 
 /* For non-protocol/alg-only op commands */
 #define OP_ALG_TYPE_SHIFT	24
 #define OP_ALG_TYPE_MASK	(0x7 << OP_ALG_TYPE_SHIFT)
-#define OP_ALG_TYPE_CLASS1	(2 << OP_ALG_TYPE_SHIFT)
-#define OP_ALG_TYPE_CLASS2	(4 << OP_ALG_TYPE_SHIFT)
+#define OP_ALG_TYPE_CLASS1	(0x2 << OP_ALG_TYPE_SHIFT)
+#define OP_ALG_TYPE_CLASS2	(0x4 << OP_ALG_TYPE_SHIFT)
 
 #define OP_ALG_ALGSEL_SHIFT	16
 #define OP_ALG_ALGSEL_MASK	(0xff << OP_ALG_ALGSEL_SHIFT)
@@ -1102,16 +1439,19 @@
 #define OP_ALG_ALGSEL_SHA384	(0x44 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_SHA512	(0x45 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_RNG	(0x50 << OP_ALG_ALGSEL_SHIFT)
-#define OP_ALG_ALGSEL_SNOW	(0x60 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_SNOW_F8	(0x60 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_KASUMI	(0x70 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_CRC	(0x90 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_SNOW_F9	(0xA0 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_ZUCE	(0xB0 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_ZUCA	(0xC0 << OP_ALG_ALGSEL_SHIFT)
 
 #define OP_ALG_AAI_SHIFT	4
-#define OP_ALG_AAI_MASK		(0x1ff << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_MASK		(0x3ff << OP_ALG_AAI_SHIFT)
 
-/* blockcipher AAI set */
+/* block cipher AAI set */
+#define OP_ALG_AESA_MODE_MASK	(0xF0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR		(0x00 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CTR_MOD128	(0x00 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CTR_MOD8	(0x01 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CTR_MOD16	(0x02 << OP_ALG_AAI_SHIFT)
@@ -1139,17 +1479,24 @@
 #define OP_ALG_AAI_GCM		(0x90 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CBC_XCBCMAC	(0xa0 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CTR_XCBCMAC	(0xb0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CBC_CMAC	(0xc0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_CMAC_LTE (0xd0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_CMAC	(0xe0 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CHECKODD	(0x80 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_DK		(0x100 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_C2K		(0x200 << OP_ALG_AAI_SHIFT)
 
 /* randomizer AAI set */
+#define OP_ALG_RNG_MODE_MASK	(0x30 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_RNG		(0x00 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_RNG_NZB	(0x10 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_RNG_OBP	(0x20 << OP_ALG_AAI_SHIFT)
 
 /* RNG4 AAI set */
-#define OP_ALG_AAI_RNG4_SH_0	(0x00 << OP_ALG_AAI_SHIFT)
-#define OP_ALG_AAI_RNG4_SH_1	(0x01 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG4_SH_SHIFT OP_ALG_AAI_SHIFT
+#define OP_ALG_AAI_RNG4_SH_MASK	(0x03 << OP_ALG_AAI_RNG4_SH_SHIFT)
+#define OP_ALG_AAI_RNG4_SH_0	(0x00 << OP_ALG_AAI_RNG4_SH_SHIFT)
+#define OP_ALG_AAI_RNG4_SH_1	(0x01 << OP_ALG_AAI_RNG4_SH_SHIFT)
 #define OP_ALG_AAI_RNG4_PS	(0x40 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_RNG4_AI	(0x80 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_RNG4_SK	(0x100 << OP_ALG_AAI_SHIFT)
@@ -1161,14 +1508,16 @@
 #define OP_ALG_AAI_HMAC_PRECOMP	(0x04 << OP_ALG_AAI_SHIFT)
 
 /* CRC AAI set*/
+#define OP_ALG_CRC_POLY_MASK	(0x07 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_802		(0x01 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_3385		(0x02 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_CUST_POLY	(0x04 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_DIS		(0x10 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_DOS		(0x20 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_DOC		(0x40 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_IVZ		(0x80 << OP_ALG_AAI_SHIFT)
 
-/* Kasumi/SNOW AAI set */
+/* Kasumi/SNOW/ZUC AAI set */
 #define OP_ALG_AAI_F8		(0xc0 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_F9		(0xc8 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_GSM		(0x10 << OP_ALG_AAI_SHIFT)
@@ -1183,123 +1532,646 @@
 
 #define OP_ALG_ICV_SHIFT	1
 #define OP_ALG_ICV_MASK		(1 << OP_ALG_ICV_SHIFT)
-#define OP_ALG_ICV_OFF		(0 << OP_ALG_ICV_SHIFT)
-#define OP_ALG_ICV_ON		(1 << OP_ALG_ICV_SHIFT)
+#define OP_ALG_ICV_OFF		0
+#define OP_ALG_ICV_ON		BIT(1)
 
 #define OP_ALG_DIR_SHIFT	0
 #define OP_ALG_DIR_MASK		1
 #define OP_ALG_DECRYPT		0
-#define OP_ALG_ENCRYPT		1
+#define OP_ALG_ENCRYPT		BIT(0)
 
 /* PKHA algorithm type set */
-#define OP_ALG_PK		0x00800000
-#define OP_ALG_PK_FUN_MASK	0x3f /* clrmem, modmath, or cpymem */
+#define OP_ALG_PK			0x00800000
+#define OP_ALG_PK_FUN_MASK		0x3f /* clrmem, modmath, or cpymem */
 
 /* PKHA mode clear memory functions */
-#define OP_ALG_PKMODE_A_RAM	0x80000
-#define OP_ALG_PKMODE_B_RAM	0x40000
-#define OP_ALG_PKMODE_E_RAM	0x20000
-#define OP_ALG_PKMODE_N_RAM	0x10000
-#define OP_ALG_PKMODE_CLEARMEM	0x00001
+#define OP_ALG_PKMODE_A_RAM		BIT(19)
+#define OP_ALG_PKMODE_B_RAM		BIT(18)
+#define OP_ALG_PKMODE_E_RAM		BIT(17)
+#define OP_ALG_PKMODE_N_RAM		BIT(16)
+#define OP_ALG_PKMODE_CLEARMEM		BIT(0)
+
+/* PKHA mode clear memory functions */
+#define OP_ALG_PKMODE_CLEARMEM_ALL	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_B_RAM | \
+					 OP_ALG_PKMODE_N_RAM | \
+					 OP_ALG_PKMODE_E_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_ABE	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_B_RAM | \
+					 OP_ALG_PKMODE_E_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_ABN	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_B_RAM | \
+					 OP_ALG_PKMODE_N_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_AB	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_B_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_AEN	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_E_RAM | \
+					 OP_ALG_PKMODE_N_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_AE	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_E_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_AN	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM | \
+					 OP_ALG_PKMODE_N_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_A	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_A_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_BEN	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_B_RAM | \
+					 OP_ALG_PKMODE_E_RAM | \
+					 OP_ALG_PKMODE_N_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_BE	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_B_RAM | \
+					 OP_ALG_PKMODE_E_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_BN	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_B_RAM | \
+					 OP_ALG_PKMODE_N_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_B	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_B_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_EN	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_E_RAM | \
+					 OP_ALG_PKMODE_N_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_E	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_E_RAM)
+#define OP_ALG_PKMODE_CLEARMEM_N	(OP_ALG_PKMODE_CLEARMEM | \
+					 OP_ALG_PKMODE_N_RAM)
 
 /* PKHA mode modular-arithmetic functions */
-#define OP_ALG_PKMODE_MOD_IN_MONTY	0x80000
-#define OP_ALG_PKMODE_MOD_OUT_MONTY	0x40000
-#define OP_ALG_PKMODE_MOD_F2M		0x20000
-#define OP_ALG_PKMODE_MOD_R2_IN		0x10000
-#define OP_ALG_PKMODE_PRJECTV		0x00800
-#define OP_ALG_PKMODE_TIME_EQ		0x400
-#define OP_ALG_PKMODE_OUT_B		0x000
-#define OP_ALG_PKMODE_OUT_A		0x100
-#define OP_ALG_PKMODE_MOD_ADD		0x002
-#define OP_ALG_PKMODE_MOD_SUB_AB	0x003
-#define OP_ALG_PKMODE_MOD_SUB_BA	0x004
-#define OP_ALG_PKMODE_MOD_MULT		0x005
-#define OP_ALG_PKMODE_MOD_EXPO		0x006
-#define OP_ALG_PKMODE_MOD_REDUCT	0x007
-#define OP_ALG_PKMODE_MOD_INV		0x008
-#define OP_ALG_PKMODE_MOD_ECC_ADD	0x009
-#define OP_ALG_PKMODE_MOD_ECC_DBL	0x00a
-#define OP_ALG_PKMODE_MOD_ECC_MULT	0x00b
-#define OP_ALG_PKMODE_MOD_MONT_CNST	0x00c
-#define OP_ALG_PKMODE_MOD_CRT_CNST	0x00d
-#define OP_ALG_PKMODE_MOD_GCD		0x00e
-#define OP_ALG_PKMODE_MOD_PRIMALITY	0x00f
+#define OP_ALG_PKMODE_MOD_IN_MONTY   BIT(19)
+#define OP_ALG_PKMODE_MOD_OUT_MONTY  BIT(18)
+#define OP_ALG_PKMODE_MOD_F2M	     BIT(17)
+#define OP_ALG_PKMODE_MOD_R2_IN	     BIT(16)
+#define OP_ALG_PKMODE_PRJECTV	     BIT(11)
+#define OP_ALG_PKMODE_TIME_EQ	     BIT(10)
+
+#define OP_ALG_PKMODE_OUT_B	     0x000
+#define OP_ALG_PKMODE_OUT_A	     0x100
+
+/*
+ * PKHA mode modular-arithmetic integer functions
+ * Can be ORed with OP_ALG_PKMODE_OUT_A to change destination from B
+ */
+#define OP_ALG_PKMODE_MOD_ADD	     0x002
+#define OP_ALG_PKMODE_MOD_SUB_AB     0x003
+#define OP_ALG_PKMODE_MOD_SUB_BA     0x004
+#define OP_ALG_PKMODE_MOD_MULT	     0x005
+#define OP_ALG_PKMODE_MOD_MULT_IM    (0x005 | OP_ALG_PKMODE_MOD_IN_MONTY)
+#define OP_ALG_PKMODE_MOD_MULT_IM_OM (0x005 | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_MOD_OUT_MONTY)
+#define OP_ALG_PKMODE_MOD_EXPO	     0x006
+#define OP_ALG_PKMODE_MOD_EXPO_TEQ   (0x006 | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_MOD_EXPO_IM    (0x006 | OP_ALG_PKMODE_MOD_IN_MONTY)
+#define OP_ALG_PKMODE_MOD_EXPO_IM_TEQ (0x006 | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_MOD_REDUCT     0x007
+#define OP_ALG_PKMODE_MOD_INV	     0x008
+#define OP_ALG_PKMODE_MOD_ECC_ADD    0x009
+#define OP_ALG_PKMODE_MOD_ECC_DBL    0x00a
+#define OP_ALG_PKMODE_MOD_ECC_MULT   0x00b
+#define OP_ALG_PKMODE_MOD_MONT_CNST  0x00c
+#define OP_ALG_PKMODE_MOD_CRT_CNST   0x00d
+#define OP_ALG_PKMODE_MOD_GCD	     0x00e
+#define OP_ALG_PKMODE_MOD_PRIMALITY  0x00f
+#define OP_ALG_PKMODE_MOD_SML_EXP    0x016
+
+/*
+ * PKHA mode modular-arithmetic F2m functions
+ * Can be ORed with OP_ALG_PKMODE_OUT_A to change destination from B
+ */
+#define OP_ALG_PKMODE_F2M_ADD	     (0x002 | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_MUL	     (0x005 | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_MUL_IM     (0x005 | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_IN_MONTY)
+#define OP_ALG_PKMODE_F2M_MUL_IM_OM  (0x005 | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_MOD_OUT_MONTY)
+#define OP_ALG_PKMODE_F2M_EXP	     (0x006 | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_EXP_TEQ    (0x006 | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_F2M_AMODN	     (0x007 | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_INV	     (0x008 | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_R2	     (0x00c | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_GCD	     (0x00e | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_F2M_SML_EXP    (0x016 | OP_ALG_PKMODE_MOD_F2M)
+
+/*
+ * PKHA mode ECC Integer arithmetic functions
+ * Can be ORed with OP_ALG_PKMODE_OUT_A to change destination from B
+ */
+#define OP_ALG_PKMODE_ECC_MOD_ADD    0x009
+#define OP_ALG_PKMODE_ECC_MOD_ADD_IM_OM_PROJ \
+				     (0x009 | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_MOD_OUT_MONTY \
+					    | OP_ALG_PKMODE_PRJECTV)
+#define OP_ALG_PKMODE_ECC_MOD_DBL    0x00a
+#define OP_ALG_PKMODE_ECC_MOD_DBL_IM_OM_PROJ \
+				     (0x00a | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_MOD_OUT_MONTY \
+					    | OP_ALG_PKMODE_PRJECTV)
+#define OP_ALG_PKMODE_ECC_MOD_MUL    0x00b
+#define OP_ALG_PKMODE_ECC_MOD_MUL_TEQ (0x00b | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_ECC_MOD_MUL_R2  (0x00b | OP_ALG_PKMODE_MOD_R2_IN)
+#define OP_ALG_PKMODE_ECC_MOD_MUL_R2_TEQ \
+				     (0x00b | OP_ALG_PKMODE_MOD_R2_IN \
+					    | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_ECC_MOD_MUL_R2_PROJ \
+				     (0x00b | OP_ALG_PKMODE_MOD_R2_IN \
+					    | OP_ALG_PKMODE_PRJECTV)
+#define OP_ALG_PKMODE_ECC_MOD_MUL_R2_PROJ_TEQ \
+				     (0x00b | OP_ALG_PKMODE_MOD_R2_IN \
+					    | OP_ALG_PKMODE_PRJECTV \
+					    | OP_ALG_PKMODE_TIME_EQ)
+
+/*
+ * PKHA mode ECC F2m arithmetic functions
+ * Can be ORed with OP_ALG_PKMODE_OUT_A to change destination from B
+ */
+#define OP_ALG_PKMODE_ECC_F2M_ADD    (0x009 | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_ECC_F2M_ADD_IM_OM_PROJ \
+				     (0x009 | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_MOD_OUT_MONTY \
+					    | OP_ALG_PKMODE_PRJECTV)
+#define OP_ALG_PKMODE_ECC_F2M_DBL    (0x00a | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_ECC_F2M_DBL_IM_OM_PROJ \
+				     (0x00a | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_IN_MONTY \
+					    | OP_ALG_PKMODE_MOD_OUT_MONTY \
+					    | OP_ALG_PKMODE_PRJECTV)
+#define OP_ALG_PKMODE_ECC_F2M_MUL    (0x00b | OP_ALG_PKMODE_MOD_F2M)
+#define OP_ALG_PKMODE_ECC_F2M_MUL_TEQ \
+				     (0x00b | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_ECC_F2M_MUL_R2 \
+				     (0x00b | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_R2_IN)
+#define OP_ALG_PKMODE_ECC_F2M_MUL_R2_TEQ \
+				     (0x00b | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_R2_IN \
+					    | OP_ALG_PKMODE_TIME_EQ)
+#define OP_ALG_PKMODE_ECC_F2M_MUL_R2_PROJ \
+				     (0x00b | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_R2_IN \
+					    | OP_ALG_PKMODE_PRJECTV)
+#define OP_ALG_PKMODE_ECC_F2M_MUL_R2_PROJ_TEQ \
+				     (0x00b | OP_ALG_PKMODE_MOD_F2M \
+					    | OP_ALG_PKMODE_MOD_R2_IN \
+					    | OP_ALG_PKMODE_PRJECTV \
+					    | OP_ALG_PKMODE_TIME_EQ)
 
 /* PKHA mode copy-memory functions */
-#define OP_ALG_PKMODE_SRC_REG_SHIFT	17
-#define OP_ALG_PKMODE_SRC_REG_MASK	(7 << OP_ALG_PKMODE_SRC_REG_SHIFT)
-#define OP_ALG_PKMODE_DST_REG_SHIFT	10
-#define OP_ALG_PKMODE_DST_REG_MASK	(7 << OP_ALG_PKMODE_DST_REG_SHIFT)
-#define OP_ALG_PKMODE_SRC_SEG_SHIFT	8
-#define OP_ALG_PKMODE_SRC_SEG_MASK	(3 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
-#define OP_ALG_PKMODE_DST_SEG_SHIFT	6
-#define OP_ALG_PKMODE_DST_SEG_MASK	(3 << OP_ALG_PKMODE_DST_SEG_SHIFT)
-
-#define OP_ALG_PKMODE_SRC_REG_A		(0 << OP_ALG_PKMODE_SRC_REG_SHIFT)
-#define OP_ALG_PKMODE_SRC_REG_B		(1 << OP_ALG_PKMODE_SRC_REG_SHIFT)
-#define OP_ALG_PKMODE_SRC_REG_N		(3 << OP_ALG_PKMODE_SRC_REG_SHIFT)
-#define OP_ALG_PKMODE_DST_REG_A		(0 << OP_ALG_PKMODE_DST_REG_SHIFT)
-#define OP_ALG_PKMODE_DST_REG_B		(1 << OP_ALG_PKMODE_DST_REG_SHIFT)
-#define OP_ALG_PKMODE_DST_REG_E		(2 << OP_ALG_PKMODE_DST_REG_SHIFT)
-#define OP_ALG_PKMODE_DST_REG_N		(3 << OP_ALG_PKMODE_DST_REG_SHIFT)
-#define OP_ALG_PKMODE_SRC_SEG_0		(0 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
-#define OP_ALG_PKMODE_SRC_SEG_1		(1 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
-#define OP_ALG_PKMODE_SRC_SEG_2		(2 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
-#define OP_ALG_PKMODE_SRC_SEG_3		(3 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
-#define OP_ALG_PKMODE_DST_SEG_0		(0 << OP_ALG_PKMODE_DST_SEG_SHIFT)
-#define OP_ALG_PKMODE_DST_SEG_1		(1 << OP_ALG_PKMODE_DST_SEG_SHIFT)
-#define OP_ALG_PKMODE_DST_SEG_2		(2 << OP_ALG_PKMODE_DST_SEG_SHIFT)
-#define OP_ALG_PKMODE_DST_SEG_3		(3 << OP_ALG_PKMODE_DST_SEG_SHIFT)
-#define OP_ALG_PKMODE_CPYMEM_N_SZ	0x80
-#define OP_ALG_PKMODE_CPYMEM_SRC_SZ	0x81
+#define OP_ALG_PKMODE_SRC_REG_SHIFT  17
+#define OP_ALG_PKMODE_SRC_REG_MASK   (7 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_SHIFT  10
+#define OP_ALG_PKMODE_DST_REG_MASK   (7 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_SHIFT  8
+#define OP_ALG_PKMODE_SRC_SEG_MASK   (3 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_SHIFT  6
+#define OP_ALG_PKMODE_DST_SEG_MASK   (3 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+
+#define OP_ALG_PKMODE_SRC_REG_A	     (0 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_REG_B	     (1 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_REG_N	     (3 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_A	     (0 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_B	     (1 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_E	     (2 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_N	     (3 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_0	     (0 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_1	     (1 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_2	     (2 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_3	     (3 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_0	     (0 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_1	     (1 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_2	     (2 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_3	     (3 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+
+/* PKHA mode copy-memory functions - amount based on N SIZE */
+#define OP_ALG_PKMODE_COPY_NSZ		0x10
+#define OP_ALG_PKMODE_COPY_NSZ_A0_B0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_NSZ_A0_B1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_A0_B2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_A0_B3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_A1_B0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_NSZ_A1_B1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_A1_B2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_A1_B3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_A2_B0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_NSZ_A2_B1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_A2_B2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_A2_B3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_A3_B0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_NSZ_A3_B1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_A3_B2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_A3_B3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_B0_A0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_NSZ_B0_A1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_B0_A2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_B0_A3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_B1_A0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_NSZ_B1_A1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_B1_A2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_B1_A3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_B2_A0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_NSZ_B2_A1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_B2_A2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_B2_A3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_B3_A0	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_NSZ_B3_A1	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_NSZ_B3_A2	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_NSZ_B3_A3	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_NSZ_A_B	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_NSZ_A_E	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_E)
+#define OP_ALG_PKMODE_COPY_NSZ_A_N	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_N)
+#define OP_ALG_PKMODE_COPY_NSZ_B_A	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_NSZ_B_E	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_E)
+#define OP_ALG_PKMODE_COPY_NSZ_B_N	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_N)
+#define OP_ALG_PKMODE_COPY_NSZ_N_A	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_N | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_NSZ_N_B	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_N | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_NSZ_N_E	(OP_ALG_PKMODE_COPY_NSZ | \
+					 OP_ALG_PKMODE_SRC_REG_N | \
+					 OP_ALG_PKMODE_DST_REG_E)
+
+/* PKHA mode copy-memory functions - amount based on SRC SIZE */
+#define OP_ALG_PKMODE_COPY_SSZ		0x11
+#define OP_ALG_PKMODE_COPY_SSZ_A0_B0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_SSZ_A0_B1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_A0_B2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_A0_B3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_A1_B0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_SSZ_A1_B1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_A1_B2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_A1_B3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_A2_B0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_SSZ_A2_B1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_A2_B2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_A2_B3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_A3_B0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_SSZ_A3_B1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_A3_B2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_A3_B3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_B | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_B0_A0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_SSZ_B0_A1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_B0_A2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_B0_A3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_B1_A0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_SSZ_B1_A1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_B1_A2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_B1_A3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_1 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_B2_A0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_SSZ_B2_A1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_B2_A2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_B2_A3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_2 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_B3_A0	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_SSZ_B3_A1	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_1)
+#define OP_ALG_PKMODE_COPY_SSZ_B3_A2	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_2)
+#define OP_ALG_PKMODE_COPY_SSZ_B3_A3	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_SRC_SEG_3 | \
+					 OP_ALG_PKMODE_DST_REG_A | \
+					 OP_ALG_PKMODE_DST_SEG_3)
+
+#define OP_ALG_PKMODE_COPY_SSZ_A_B	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_SSZ_A_E	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_E)
+#define OP_ALG_PKMODE_COPY_SSZ_A_N	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_A | \
+					 OP_ALG_PKMODE_DST_REG_N)
+#define OP_ALG_PKMODE_COPY_SSZ_B_A	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_SSZ_B_E	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_E)
+#define OP_ALG_PKMODE_COPY_SSZ_B_N	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_B | \
+					 OP_ALG_PKMODE_DST_REG_N)
+#define OP_ALG_PKMODE_COPY_SSZ_N_A	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_N | \
+					 OP_ALG_PKMODE_DST_REG_A)
+#define OP_ALG_PKMODE_COPY_SSZ_N_B	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_N | \
+					 OP_ALG_PKMODE_DST_REG_B)
+#define OP_ALG_PKMODE_COPY_SSZ_N_E	(OP_ALG_PKMODE_COPY_SSZ | \
+					 OP_ALG_PKMODE_SRC_REG_N | \
+					 OP_ALG_PKMODE_DST_REG_E)
 
 /*
  * SEQ_IN_PTR Command Constructs
  */
 
 /* Release Buffers */
-#define SQIN_RBS	0x04000000
+#define SQIN_RBS	BIT(26)
 
 /* Sequence pointer is really a descriptor */
-#define SQIN_INL	0x02000000
+#define SQIN_INL	BIT(25)
 
 /* Sequence pointer is a scatter-gather table */
-#define SQIN_SGF	0x01000000
+#define SQIN_SGF	BIT(24)
 
 /* Appends to a previous pointer */
-#define SQIN_PRE	0x00800000
+#define SQIN_PRE	BIT(23)
 
 /* Use extended length following pointer */
-#define SQIN_EXT	0x00400000
+#define SQIN_EXT	BIT(22)
 
 /* Restore sequence with pointer/length */
-#define SQIN_RTO	0x00200000
+#define SQIN_RTO	BIT(21)
 
 /* Replace job descriptor */
-#define SQIN_RJD	0x00100000
+#define SQIN_RJD	BIT(20)
 
-#define SQIN_LEN_SHIFT		 0
-#define SQIN_LEN_MASK		(0xffff << SQIN_LEN_SHIFT)
+/* Sequence Out Pointer - start a new input sequence using output sequence */
+#define SQIN_SOP	BIT(19)
+
+#define SQIN_LEN_SHIFT	0
+#define SQIN_LEN_MASK	(0xffff << SQIN_LEN_SHIFT)
 
 /*
  * SEQ_OUT_PTR Command Constructs
  */
 
 /* Sequence pointer is a scatter-gather table */
-#define SQOUT_SGF	0x01000000
+#define SQOUT_SGF	BIT(24)
 
 /* Appends to a previous pointer */
-#define SQOUT_PRE	SQIN_PRE
+#define SQOUT_PRE	BIT(23)
 
 /* Restore sequence with pointer/length */
-#define SQOUT_RTO	 SQIN_RTO
+#define SQOUT_RTO	BIT(21)
+
+/*
+ * Ignore length field, add current output frame length back to SOL register.
+ * Reset tracking length of bytes written to output frame.
+ * Must be used together with SQOUT_RTO.
+ */
+#define SQOUT_RST	BIT(20)
+
+/* Allow "write safe" transactions for this Output Sequence */
+#define SQOUT_EWS	BIT(19)
 
 /* Use extended length following pointer */
-#define SQOUT_EXT	0x00400000
+#define SQOUT_EXT	BIT(22)
 
-#define SQOUT_LEN_SHIFT		0
-#define SQOUT_LEN_MASK		(0xffff << SQOUT_LEN_SHIFT)
+#define SQOUT_LEN_SHIFT	0
+#define SQOUT_LEN_MASK	(0xffff << SQOUT_LEN_SHIFT)
 
 
 /*
@@ -1328,7 +2200,7 @@
 
 #define MOVE_WAITCOMP_SHIFT	24
 #define MOVE_WAITCOMP_MASK	(1 << MOVE_WAITCOMP_SHIFT)
-#define MOVE_WAITCOMP		(1 << MOVE_WAITCOMP_SHIFT)
+#define MOVE_WAITCOMP		BIT(24)
 
 #define MOVE_SRC_SHIFT		20
 #define MOVE_SRC_MASK		(0x0f << MOVE_SRC_SHIFT)
@@ -1342,6 +2214,7 @@
 #define MOVE_SRC_MATH3		(0x07 << MOVE_SRC_SHIFT)
 #define MOVE_SRC_INFIFO		(0x08 << MOVE_SRC_SHIFT)
 #define MOVE_SRC_INFIFO_CL	(0x09 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_INFIFO_NO_NFIFO (0x0a << MOVE_SRC_SHIFT)
 
 #define MOVE_DEST_SHIFT		16
 #define MOVE_DEST_MASK		(0x0f << MOVE_DEST_SHIFT)
@@ -1355,10 +2228,11 @@
 #define MOVE_DEST_MATH3		(0x07 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS1INFIFO	(0x08 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS2INFIFO	(0x09 << MOVE_DEST_SHIFT)
-#define MOVE_DEST_INFIFO_NOINFO (0x0a << MOVE_DEST_SHIFT)
+#define MOVE_DEST_INFIFO	(0x0a << MOVE_DEST_SHIFT)
 #define MOVE_DEST_PK_A		(0x0c << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS1KEY	(0x0d << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS2KEY	(0x0e << MOVE_DEST_SHIFT)
+#define MOVE_DEST_ALTSOURCE	(0x0f << MOVE_DEST_SHIFT)
 
 #define MOVE_OFFSET_SHIFT	8
 #define MOVE_OFFSET_MASK	(0xff << MOVE_OFFSET_SHIFT)
@@ -1368,6 +2242,16 @@
 
 #define MOVELEN_MRSEL_SHIFT	0
 #define MOVELEN_MRSEL_MASK	(0x3 << MOVE_LEN_SHIFT)
+#define MOVELEN_MRSEL_MATH0	(0 << MOVELEN_MRSEL_SHIFT)
+#define MOVELEN_MRSEL_MATH1	(1 << MOVELEN_MRSEL_SHIFT)
+#define MOVELEN_MRSEL_MATH2	(2 << MOVELEN_MRSEL_SHIFT)
+#define MOVELEN_MRSEL_MATH3	(3 << MOVELEN_MRSEL_SHIFT)
+
+#define MOVELEN_SIZE_SHIFT	6
+#define MOVELEN_SIZE_MASK	(0x3 << MOVELEN_SIZE_SHIFT)
+#define MOVELEN_SIZE_WORD	(0x01 << MOVELEN_SIZE_SHIFT)
+#define MOVELEN_SIZE_BYTE	(0x02 << MOVELEN_SIZE_SHIFT)
+#define MOVELEN_SIZE_DWORD	(0x03 << MOVELEN_SIZE_SHIFT)
 
 /*
  * MATH Command Constructs
@@ -1375,15 +2259,24 @@
 
 #define MATH_IFB_SHIFT		26
 #define MATH_IFB_MASK		(1 << MATH_IFB_SHIFT)
-#define MATH_IFB		(1 << MATH_IFB_SHIFT)
+#define MATH_IFB		BIT(26)
 
 #define MATH_NFU_SHIFT		25
 #define MATH_NFU_MASK		(1 << MATH_NFU_SHIFT)
-#define MATH_NFU		(1 << MATH_NFU_SHIFT)
+#define MATH_NFU		BIT(25)
 
+/* STL for MATH, SSEL for MATHI */
 #define MATH_STL_SHIFT		24
 #define MATH_STL_MASK		(1 << MATH_STL_SHIFT)
-#define MATH_STL		(1 << MATH_STL_SHIFT)
+#define MATH_STL		BIT(24)
+
+#define MATH_SSEL_SHIFT		24
+#define MATH_SSEL_MASK		(1 << MATH_SSEL_SHIFT)
+#define MATH_SSEL		BIT(24)
+
+#define MATH_SWP_SHIFT		0
+#define MATH_SWP_MASK		(1 << MATH_SWP_SHIFT)
+#define MATH_SWP		BIT(0)
 
 /* Function selectors */
 #define MATH_FUN_SHIFT		20
@@ -1398,7 +2291,9 @@
 #define MATH_FUN_LSHIFT		(0x07 << MATH_FUN_SHIFT)
 #define MATH_FUN_RSHIFT		(0x08 << MATH_FUN_SHIFT)
 #define MATH_FUN_SHLD		(0x09 << MATH_FUN_SHIFT)
-#define MATH_FUN_ZBYT		(0x0a << MATH_FUN_SHIFT)
+#define MATH_FUN_ZBYT		(0x0a << MATH_FUN_SHIFT) /* ZBYT is for MATH */
+#define MATH_FUN_FBYT		(0x0a << MATH_FUN_SHIFT) /* FBYT is for MATHI */
+#define MATH_FUN_BSWAP		(0x0b << MATH_FUN_SHIFT)
 
 /* Source 0 selectors */
 #define MATH_SRC0_SHIFT		16
@@ -1414,33 +2309,45 @@
 #define MATH_SRC0_VARSEQINLEN	(0x0a << MATH_SRC0_SHIFT)
 #define MATH_SRC0_VARSEQOUTLEN	(0x0b << MATH_SRC0_SHIFT)
 #define MATH_SRC0_ZERO		(0x0c << MATH_SRC0_SHIFT)
+#define MATH_SRC0_ONE		(0x0f << MATH_SRC0_SHIFT)
 
 /* Source 1 selectors */
 #define MATH_SRC1_SHIFT		12
+#define MATHI_SRC1_SHIFT	16
 #define MATH_SRC1_MASK		(0x0f << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG0		(0x00 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG1		(0x01 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG2		(0x02 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG3		(0x03 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_IMM		(0x04 << MATH_SRC1_SHIFT)
-#define MATH_SRC1_DPOVRD	(0x07 << MATH_SRC0_SHIFT)
+#define MATH_SRC1_DPOVRD	(0x07 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_VARSEQINLEN	(0x08 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_VARSEQOUTLEN	(0x09 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_INFIFO	(0x0a << MATH_SRC1_SHIFT)
 #define MATH_SRC1_OUTFIFO	(0x0b << MATH_SRC1_SHIFT)
 #define MATH_SRC1_ONE		(0x0c << MATH_SRC1_SHIFT)
+#define MATH_SRC1_JOBSOURCE	(0x0d << MATH_SRC1_SHIFT)
+#define MATH_SRC1_ZERO		(0x0f << MATH_SRC1_SHIFT)
 
 /* Destination selectors */
 #define MATH_DEST_SHIFT		8
+#define MATHI_DEST_SHIFT	12
 #define MATH_DEST_MASK		(0x0f << MATH_DEST_SHIFT)
 #define MATH_DEST_REG0		(0x00 << MATH_DEST_SHIFT)
 #define MATH_DEST_REG1		(0x01 << MATH_DEST_SHIFT)
 #define MATH_DEST_REG2		(0x02 << MATH_DEST_SHIFT)
 #define MATH_DEST_REG3		(0x03 << MATH_DEST_SHIFT)
+#define MATH_DEST_DPOVRD	(0x07 << MATH_DEST_SHIFT)
 #define MATH_DEST_SEQINLEN	(0x08 << MATH_DEST_SHIFT)
 #define MATH_DEST_SEQOUTLEN	(0x09 << MATH_DEST_SHIFT)
 #define MATH_DEST_VARSEQINLEN	(0x0a << MATH_DEST_SHIFT)
 #define MATH_DEST_VARSEQOUTLEN	(0x0b << MATH_DEST_SHIFT)
 #define MATH_DEST_NONE		(0x0f << MATH_DEST_SHIFT)
 
+/* MATHI Immediate value */
+#define MATHI_IMM_SHIFT		4
+#define MATHI_IMM_MASK		(0xff << MATHI_IMM_SHIFT)
+
 /* Length selectors */
 #define MATH_LEN_SHIFT		0
 #define MATH_LEN_MASK		(0x0f << MATH_LEN_SHIFT)
@@ -1462,14 +2369,18 @@
 
 #define JUMP_JSL_SHIFT		24
 #define JUMP_JSL_MASK		(1 << JUMP_JSL_SHIFT)
-#define JUMP_JSL		(1 << JUMP_JSL_SHIFT)
+#define JUMP_JSL		BIT(24)
 
-#define JUMP_TYPE_SHIFT		22
-#define JUMP_TYPE_MASK		(0x03 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_SHIFT		20
+#define JUMP_TYPE_MASK		(0x0f << JUMP_TYPE_SHIFT)
 #define JUMP_TYPE_LOCAL		(0x00 << JUMP_TYPE_SHIFT)
-#define JUMP_TYPE_NONLOCAL	(0x01 << JUMP_TYPE_SHIFT)
-#define JUMP_TYPE_HALT		(0x02 << JUMP_TYPE_SHIFT)
-#define JUMP_TYPE_HALT_USER	(0x03 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_LOCAL_INC	(0x01 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_GOSUB		(0x02 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_LOCAL_DEC	(0x03 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_NONLOCAL	(0x04 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_RETURN	(0x06 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_HALT		(0x08 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_HALT_USER	(0x0c << JUMP_TYPE_SHIFT)
 
 #define JUMP_TEST_SHIFT		16
 #define JUMP_TEST_MASK		(0x03 << JUMP_TEST_SHIFT)
@@ -1480,23 +2391,36 @@
 
 /* Condition codes. JSL bit is factored in */
 #define JUMP_COND_SHIFT		8
-#define JUMP_COND_MASK		(0x100ff << JUMP_COND_SHIFT)
-#define JUMP_COND_PK_0		(0x80 << JUMP_COND_SHIFT)
-#define JUMP_COND_PK_GCD_1	(0x40 << JUMP_COND_SHIFT)
-#define JUMP_COND_PK_PRIME	(0x20 << JUMP_COND_SHIFT)
-#define JUMP_COND_MATH_N	(0x08 << JUMP_COND_SHIFT)
-#define JUMP_COND_MATH_Z	(0x04 << JUMP_COND_SHIFT)
-#define JUMP_COND_MATH_C	(0x02 << JUMP_COND_SHIFT)
-#define JUMP_COND_MATH_NV	(0x01 << JUMP_COND_SHIFT)
-
-#define JUMP_COND_JRP		((0x80 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_SHRD		((0x40 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_SELF		((0x20 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_CALM		((0x10 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_NIP		((0x08 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_NIFP		((0x04 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_NOP		((0x02 << JUMP_COND_SHIFT) | JUMP_JSL)
-#define JUMP_COND_NCP		((0x01 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_MASK		((0xff << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_PK_0		BIT(15)
+#define JUMP_COND_PK_GCD_1	BIT(14)
+#define JUMP_COND_PK_PRIME	BIT(13)
+#define JUMP_COND_MATH_N	BIT(11)
+#define JUMP_COND_MATH_Z	BIT(10)
+#define JUMP_COND_MATH_C	BIT(9)
+#define JUMP_COND_MATH_NV	BIT(8)
+
+#define JUMP_COND_JQP		(BIT(15) | JUMP_JSL)
+#define JUMP_COND_SHRD		(BIT(14) | JUMP_JSL)
+#define JUMP_COND_SELF		(BIT(13) | JUMP_JSL)
+#define JUMP_COND_CALM		(BIT(12) | JUMP_JSL)
+#define JUMP_COND_NIP		(BIT(11) | JUMP_JSL)
+#define JUMP_COND_NIFP		(BIT(10) | JUMP_JSL)
+#define JUMP_COND_NOP		(BIT(9) | JUMP_JSL)
+#define JUMP_COND_NCP		(BIT(8) | JUMP_JSL)
+
+/* Source / destination selectors */
+#define JUMP_SRC_DST_SHIFT		12
+#define JUMP_SRC_DST_MASK		(0x0f << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_MATH0		(0x00 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_MATH1		(0x01 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_MATH2		(0x02 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_MATH3		(0x03 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_DPOVRD		(0x07 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_SEQINLEN		(0x08 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_SEQOUTLEN		(0x09 << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_VARSEQINLEN	(0x0a << JUMP_SRC_DST_SHIFT)
+#define JUMP_SRC_DST_VARSEQOUTLEN	(0x0b << JUMP_SRC_DST_SHIFT)
 
 #define JUMP_OFFSET_SHIFT	0
 #define JUMP_OFFSET_MASK	(0xff << JUMP_OFFSET_SHIFT)
@@ -1507,27 +2431,27 @@
  *
  */
 #define NFIFOENTRY_DEST_SHIFT	30
-#define NFIFOENTRY_DEST_MASK	(3 << NFIFOENTRY_DEST_SHIFT)
+#define NFIFOENTRY_DEST_MASK	((uint32_t)(3 << NFIFOENTRY_DEST_SHIFT))
 #define NFIFOENTRY_DEST_DECO	(0 << NFIFOENTRY_DEST_SHIFT)
 #define NFIFOENTRY_DEST_CLASS1	(1 << NFIFOENTRY_DEST_SHIFT)
-#define NFIFOENTRY_DEST_CLASS2	(2 << NFIFOENTRY_DEST_SHIFT)
-#define NFIFOENTRY_DEST_BOTH	(3 << NFIFOENTRY_DEST_SHIFT)
+#define NFIFOENTRY_DEST_CLASS2	((uint32_t)(2 << NFIFOENTRY_DEST_SHIFT))
+#define NFIFOENTRY_DEST_BOTH	((uint32_t)(3 << NFIFOENTRY_DEST_SHIFT))
 
 #define NFIFOENTRY_LC2_SHIFT	29
 #define NFIFOENTRY_LC2_MASK	(1 << NFIFOENTRY_LC2_SHIFT)
-#define NFIFOENTRY_LC2		(1 << NFIFOENTRY_LC2_SHIFT)
+#define NFIFOENTRY_LC2		BIT(29)
 
 #define NFIFOENTRY_LC1_SHIFT	28
 #define NFIFOENTRY_LC1_MASK	(1 << NFIFOENTRY_LC1_SHIFT)
-#define NFIFOENTRY_LC1		(1 << NFIFOENTRY_LC1_SHIFT)
+#define NFIFOENTRY_LC1		BIT(28)
 
 #define NFIFOENTRY_FC2_SHIFT	27
 #define NFIFOENTRY_FC2_MASK	(1 << NFIFOENTRY_FC2_SHIFT)
-#define NFIFOENTRY_FC2		(1 << NFIFOENTRY_FC2_SHIFT)
+#define NFIFOENTRY_FC2		BIT(27)
 
 #define NFIFOENTRY_FC1_SHIFT	26
 #define NFIFOENTRY_FC1_MASK	(1 << NFIFOENTRY_FC1_SHIFT)
-#define NFIFOENTRY_FC1		(1 << NFIFOENTRY_FC1_SHIFT)
+#define NFIFOENTRY_FC1		BIT(26)
 
 #define NFIFOENTRY_STYPE_SHIFT	24
 #define NFIFOENTRY_STYPE_MASK	(3 << NFIFOENTRY_STYPE_SHIFT)
@@ -1535,6 +2459,12 @@
 #define NFIFOENTRY_STYPE_OFIFO	(1 << NFIFOENTRY_STYPE_SHIFT)
 #define NFIFOENTRY_STYPE_PAD	(2 << NFIFOENTRY_STYPE_SHIFT)
 #define NFIFOENTRY_STYPE_SNOOP	(3 << NFIFOENTRY_STYPE_SHIFT)
+#define NFIFOENTRY_STYPE_ALTSOURCE ((0 << NFIFOENTRY_STYPE_SHIFT) \
+					| NFIFOENTRY_AST)
+#define NFIFOENTRY_STYPE_OFIFO_SYNC ((1 << NFIFOENTRY_STYPE_SHIFT) \
+					| NFIFOENTRY_AST)
+#define NFIFOENTRY_STYPE_SNOOP_ALT ((3 << NFIFOENTRY_STYPE_SHIFT) \
+					| NFIFOENTRY_AST)
 
 #define NFIFOENTRY_DTYPE_SHIFT	20
 #define NFIFOENTRY_DTYPE_MASK	(0xF << NFIFOENTRY_DTYPE_SHIFT)
@@ -1560,10 +2490,9 @@
 #define NFIFOENTRY_DTYPE_PK_A	(0xC << NFIFOENTRY_DTYPE_SHIFT)
 #define NFIFOENTRY_DTYPE_PK_B	(0xD << NFIFOENTRY_DTYPE_SHIFT)
 
-
 #define NFIFOENTRY_BND_SHIFT	19
 #define NFIFOENTRY_BND_MASK	(1 << NFIFOENTRY_BND_SHIFT)
-#define NFIFOENTRY_BND		(1 << NFIFOENTRY_BND_SHIFT)
+#define NFIFOENTRY_BND		BIT(19)
 
 #define NFIFOENTRY_PTYPE_SHIFT	16
 #define NFIFOENTRY_PTYPE_MASK	(0x7 << NFIFOENTRY_PTYPE_SHIFT)
@@ -1579,19 +2508,23 @@
 
 #define NFIFOENTRY_OC_SHIFT	15
 #define NFIFOENTRY_OC_MASK	(1 << NFIFOENTRY_OC_SHIFT)
-#define NFIFOENTRY_OC		(1 << NFIFOENTRY_OC_SHIFT)
+#define NFIFOENTRY_OC		BIT(15)
+
+#define NFIFOENTRY_PR_SHIFT	15
+#define NFIFOENTRY_PR_MASK	(1 << NFIFOENTRY_PR_SHIFT)
+#define NFIFOENTRY_PR		BIT(15)
 
 #define NFIFOENTRY_AST_SHIFT	14
-#define NFIFOENTRY_AST_MASK	(1 << NFIFOENTRY_OC_SHIFT)
-#define NFIFOENTRY_AST		(1 << NFIFOENTRY_OC_SHIFT)
+#define NFIFOENTRY_AST_MASK	(1 << NFIFOENTRY_AST_SHIFT)
+#define NFIFOENTRY_AST		BIT(14)
 
 #define NFIFOENTRY_BM_SHIFT	11
 #define NFIFOENTRY_BM_MASK	(1 << NFIFOENTRY_BM_SHIFT)
-#define NFIFOENTRY_BM		(1 << NFIFOENTRY_BM_SHIFT)
+#define NFIFOENTRY_BM		BIT(11)
 
 #define NFIFOENTRY_PS_SHIFT	10
 #define NFIFOENTRY_PS_MASK	(1 << NFIFOENTRY_PS_SHIFT)
-#define NFIFOENTRY_PS		(1 << NFIFOENTRY_PS_SHIFT)
+#define NFIFOENTRY_PS		BIT(10)
 
 #define NFIFOENTRY_DLEN_SHIFT	0
 #define NFIFOENTRY_DLEN_MASK	(0xFFF << NFIFOENTRY_DLEN_SHIFT)
@@ -1600,12 +2533,12 @@
 #define NFIFOENTRY_PLEN_MASK	(0xFF << NFIFOENTRY_PLEN_SHIFT)
 
 /* Append Load Immediate Command */
-#define FD_CMD_APPEND_LOAD_IMMEDIATE			0x80000000
+#define FD_CMD_APPEND_LOAD_IMMEDIATE			BIT(31)
 
 /* Set SEQ LIODN equal to the Non-SEQ LIODN for the job */
-#define FD_CMD_SET_SEQ_LIODN_EQUAL_NONSEQ_LIODN		0x40000000
+#define FD_CMD_SET_SEQ_LIODN_EQUAL_NONSEQ_LIODN		BIT(30)
 
 /* Frame Descriptor Command for Replacement Job Descriptor */
-#define FD_CMD_REPLACE_JOB_DESC				0x20000000
+#define FD_CMD_REPLACE_JOB_DESC				BIT(29)
 
-#endif /* DESC_H */
+#endif /* __RTA_DESC_H__ */
diff --git a/drivers/crypto/caam/flib/desc/common.h b/drivers/crypto/caam/flib/desc/common.h
new file mode 100644
index 000000000000..1c69cbfb6173
--- /dev/null
+++ b/drivers/crypto/caam/flib/desc/common.h
@@ -0,0 +1,151 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __DESC_COMMON_H__
+#define __DESC_COMMON_H__
+
+#include "flib/rta.h"
+
+/**
+ * DOC: Shared Descriptor Constructors - shared structures
+ *
+ * Data structures shared between algorithm, protocol implementations.
+ */
+
+/**
+ * enum rta_data_type - Indicates how is the data provided and how to include it
+ *                      in the descriptor.
+ * @RTA_DATA_PTR: Data is in memory and accessed by reference; data address is a
+ *               physical (bus) address.
+ * @RTA_DATA_IMM: Data is inlined in descriptor and accessed as immediate data;
+ *               data address is a virtual address.
+ * @RTA_DATA_IMM_DMA: (AIOP only) Data is inlined in descriptor and accessed as
+ *                   immediate data; data address is a physical (bus) address
+ *                   in external memory and CDMA is programmed to transfer the
+ *                   data into descriptor buffer being built in Workspace Area.
+ */
+enum rta_data_type {
+	RTA_DATA_PTR = 1,
+	RTA_DATA_IMM,
+	RTA_DATA_IMM_DMA
+};
+
+/**
+ * struct alginfo - Container for algorithm details
+ * @algtype: algorithm selector; for valid values, see documentation of the
+ *           functions where it is used.
+ * @keylen: length of the provided algorithm key, in bytes
+ * @key: address where algorithm key resides; virtual address if key_type is
+ *       RTA_DATA_IMM, physical (bus) address if key_type is RTA_DATA_PTR or
+ *       RTA_DATA_IMM_DMA.
+ * @key_enc_flags: key encryption flags; see encrypt_flags parameter of KEY
+ *                 command for valid values.
+ * @key_type: enum rta_data_type
+ */
+struct alginfo {
+	uint32_t algtype;
+	uint32_t keylen;
+	uint64_t key;
+	uint32_t key_enc_flags;
+	enum rta_data_type key_type;
+};
+
+static inline uint32_t inline_flags(enum rta_data_type data_type)
+{
+	switch (data_type) {
+	case RTA_DATA_PTR:
+		return 0;
+	case RTA_DATA_IMM:
+		return IMMED | COPY;
+	case RTA_DATA_IMM_DMA:
+		return IMMED | DCOPY;
+	default:
+		/* warn and default to RTA_DATA_PTR */
+		pr_warn("RTA: defaulting to RTA_DATA_PTR parameter type\n");
+		return 0;
+	}
+}
+
+#define INLINE_KEY(alginfo)	inline_flags(alginfo->key_type)
+
+/**
+ * rta_inline_query() - Provide indications on which data items can be inlined
+ *                      and which shall be referenced in a shared descriptor.
+ * @sd_base_len: Shared descriptor base length - bytes consumed by the commands,
+ *               excluding the data items to be inlined (or corresponding
+ *               pointer if an item is not inlined). Each cnstr_* function that
+ *               generates descriptors should have a define mentioning
+ *               corresponding length.
+ * @jd_len: Maximum length of the job descriptor(s) that will be used
+ *          together with the shared descriptor.
+ * @data_len: Array of lengths of the data items trying to be inlined
+ * @inl_mask: 32bit mask with bit x = 1 if data item x can be inlined, 0
+ *            otherwise.
+ * @count: Number of data items (size of @data_len array); must be <= 32
+ *
+ * Return: 0 if data can be inlined / referenced, negative value if not. If 0,
+ *         check @inl_mask for details.
+ */
+static inline int rta_inline_query(unsigned sd_base_len, unsigned jd_len,
+				   unsigned *data_len, uint32_t *inl_mask,
+				   unsigned count)
+{
+	int rem_bytes = (int)(CAAM_DESC_BYTES_MAX - sd_base_len - jd_len);
+	unsigned i;
+
+	*inl_mask = 0;
+	for (i = 0; (i < count) && (rem_bytes > 0); i++) {
+		if (rem_bytes - data_len[i] -
+		     (count - i - 1) * CAAM_PTR_SZ >= 0) {
+			rem_bytes -= data_len[i];
+			*inl_mask |= (1 << i);
+		} else {
+			rem_bytes -= CAAM_PTR_SZ;
+		}
+	}
+
+	return (rem_bytes >= 0) ? 0 : -1;
+}
+
+/**
+ * struct protcmd - Container for Protocol Operation Command fields
+ * @optype: command type
+ * @protid: protocol Identifier
+ * @protinfo: protocol Information
+ */
+struct protcmd {
+	uint32_t optype;
+	uint32_t protid;
+	uint16_t protinfo;
+};
+
+/**
+ * split_key_len - Compute MDHA split key length for a given algorithm
+ * @hash: Hashing algorithm selection, one of OP_ALG_ALGSEL_* - MD5, SHA1,
+ *        SHA224, SHA384, SHA512.
+ *
+ * Return: MDHA split key length
+ */
+static inline uint32_t split_key_len(uint32_t hash)
+{
+	/* Sizes for MDHA pads (*not* keys): MD5, SHA1, 224, 256, 384, 512 */
+	static const uint8_t mdpadlen[] = { 16, 20, 32, 32, 64, 64 };
+	uint32_t idx;
+
+	idx = (hash & OP_ALG_ALGSEL_SUBMASK) >> OP_ALG_ALGSEL_SHIFT;
+
+	return (uint32_t)(mdpadlen[idx] * 2);
+}
+
+/**
+ * split_key_pad_len - Compute MDHA split key pad length for a given algorithm
+ * @hash: Hashing algorithm selection, one of OP_ALG_ALGSEL_* - MD5, SHA1,
+ *        SHA224, SHA384, SHA512.
+ *
+ * Return: MDHA split key pad length
+ */
+static inline uint32_t split_key_pad_len(uint32_t hash)
+{
+	return ALIGN(split_key_len(hash), 16);
+}
+
+#endif /* __DESC_COMMON_H__ */
diff --git a/drivers/crypto/caam/flib/desc/jobdesc.h b/drivers/crypto/caam/flib/desc/jobdesc.h
new file mode 100644
index 000000000000..27ec739adba7
--- /dev/null
+++ b/drivers/crypto/caam/flib/desc/jobdesc.h
@@ -0,0 +1,57 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __DESC_JOBDESC_H__
+#define __DESC_JOBDESC_H__
+
+#include "flib/rta.h"
+#include "common.h"
+
+/**
+ * DOC: Job Descriptor Constructors
+ *
+ * Job descriptors for certain tasks, like generating MDHA split keys.
+ */
+
+/**
+ * cnstr_jobdesc_mdsplitkey - Generate an MDHA split key
+ * @descbuf: pointer to buffer to hold constructed descriptor
+ * @ps: if 36/40bit addressing is desired, this parameter must be true
+ * @alg_key: pointer to HMAC key to generate ipad/opad from
+ * @keylen: HMAC key length
+ * @cipher: HMAC algorithm selection, one of OP_ALG_ALGSEL_*
+ *     The algorithm determines key size (bytes):
+ *     -  OP_ALG_ALGSEL_MD5    - 16
+ *     -  OP_ALG_ALGSEL_SHA1   - 20
+ *     -  OP_ALG_ALGSEL_SHA224 - 28
+ *     -  OP_ALG_ALGSEL_SHA256 - 32
+ *     -  OP_ALG_ALGSEL_SHA384 - 48
+ *     -  OP_ALG_ALGSEL_SHA512 - 64
+ * @padbuf: pointer to buffer to store generated ipad/opad
+ *
+ * Split keys are IPAD/OPAD pairs. For details, refer to MDHA Split Keys chapter
+ * in SEC Reference Manual.
+ *
+ * Return: size of descriptor written in words
+ */
+
+static inline int cnstr_jobdesc_mdsplitkey(uint32_t *descbuf, bool ps,
+					   uint64_t alg_key, uint8_t keylen,
+					   uint32_t cipher, uint64_t padbuf)
+{
+	struct program prg;
+	struct program *p = &prg;
+
+	PROGRAM_CNTXT_INIT(p, descbuf, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	JOB_HDR(p, SHR_NEVER, 1, 0, 0);
+	KEY(p, KEY2, 0, alg_key, keylen, 0);
+	ALG_OPERATION(p, cipher, OP_ALG_AAI_HMAC, OP_ALG_AS_INIT,
+		      ICV_CHECK_DISABLE, DIR_DEC);
+	FIFOLOAD(p, MSG2, 0, 0, LAST2 | IMMED | COPY);
+	JUMP(p, 1, LOCAL_JUMP, ALL_TRUE, CLASS2);
+	FIFOSTORE(p, MDHA_SPLIT_KEY, 0, padbuf, split_key_len(cipher), 0);
+	return PROGRAM_FINALIZE(p);
+}
+
+#endif /* __DESC_JOBDESC_H__ */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index ec3652d62e93..01d434e20ca4 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -11,7 +11,7 @@
 #include "compat.h"
 #include "regs.h"
 #include "jr.h"
-#include "desc.h"
+#include "flib/desc.h"
 #include "intern.h"
 
 struct jr_driver_data {
-- 
1.8.3.1

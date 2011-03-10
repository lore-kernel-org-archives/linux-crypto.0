From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/3] crypto: add header files for the Freescale SEC4/CAAM
Date: Wed, 9 Mar 2011 18:54:47 -0600
Message-ID: <20110309185447.507f36b3.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<devicetree-discuss@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52219
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab1CJAzD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Mar 2011 19:55:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

add descriptor defines and machine register
definition header files.

Signed-off-by: Steve Cornelius <sec@pobox.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/desc.h | 1605 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/regs.h |  663 ++++++++++++++++++
 2 files changed, 2268 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/caam/desc.h
 create mode 100644 drivers/crypto/caam/regs.h

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
new file mode 100644
index 0000000..974a758
--- /dev/null
+++ b/drivers/crypto/caam/desc.h
@@ -0,0 +1,1605 @@
+/*
+ * CAAM descriptor composition header
+ * Definitions to support CAAM descriptor instruction generation
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#ifndef DESC_H
+#define DESC_H
+
+/* Max size of any CAAM descriptor in 32-bit words, inclusive of header */
+#define MAX_CAAM_DESCSIZE       64
+
+/* Block size of any entity covered/uncovered with a KEK/TKEK */
+#define KEK_BLOCKSIZE		16
+
+/*
+ * Supported descriptor command types as they show up
+ * inside a descriptor command word.
+ */
+#define CMD_SHIFT               27
+#define CMD_MASK                0xf8000000
+
+#define CMD_KEY                 (0x00 << CMD_SHIFT)
+#define CMD_SEQ_KEY             (0x01 << CMD_SHIFT)
+#define CMD_LOAD                (0x02 << CMD_SHIFT)
+#define CMD_SEQ_LOAD            (0x03 << CMD_SHIFT)
+#define CMD_FIFO_LOAD           (0x04 << CMD_SHIFT)
+#define CMD_SEQ_FIFO_LOAD       (0x05 << CMD_SHIFT)
+#define CMD_STORE               (0x0a << CMD_SHIFT)
+#define CMD_SEQ_STORE           (0x0b << CMD_SHIFT)
+#define CMD_FIFO_STORE          (0x0c << CMD_SHIFT)
+#define CMD_SEQ_FIFO_STORE      (0x0d << CMD_SHIFT)
+#define CMD_MOVE_LEN            (0x0e << CMD_SHIFT)
+#define CMD_MOVE                (0x0f << CMD_SHIFT)
+#define CMD_OPERATION           (0x10 << CMD_SHIFT)
+#define CMD_SIGNATURE           (0x12 << CMD_SHIFT)
+#define CMD_JUMP                (0x14 << CMD_SHIFT)
+#define CMD_MATH                (0x15 << CMD_SHIFT)
+#define CMD_DESC_HDR            (0x16 << CMD_SHIFT)
+#define CMD_SHARED_DESC_HDR     (0x17 << CMD_SHIFT)
+#define CMD_SEQ_IN_PTR          (0x1e << CMD_SHIFT)
+#define CMD_SEQ_OUT_PTR         (0x1f << CMD_SHIFT)
+
+/* General-purpose class selector for all commands */
+#define CLASS_SHIFT             25
+#define CLASS_MASK              (0x03 << CLASS_SHIFT)
+
+#define CLASS_NONE              (0x00 << CLASS_SHIFT)
+#define CLASS_1                 (0x01 << CLASS_SHIFT)
+#define CLASS_2                 (0x02 << CLASS_SHIFT)
+#define CLASS_BOTH              (0x03 << CLASS_SHIFT)
+
+/*
+ * Descriptor header command constructs
+ * Covers shared, job, and trusted descriptor headers
+ */
+
+/*
+ * Do Not Run - marks a descriptor inexecutable if there was
+ * a preceding error somewhere
+ */
+#define HDR_DNR                 0x01000000
+
+/*
+ * ONE - should always be set. Combination of ONE (always
+ * set) and ZRO (always clear) forms an endianness sanity check
+ */
+#define HDR_ONE                 0x00800000
+#define HDR_ZRO                 0x00008000
+
+/* Start Index or SharedDesc Length */
+#define HDR_START_IDX_MASK      0x3f
+#define HDR_START_IDX_SHIFT     16
+
+/* If shared descriptor header, 6-bit length */
+#define HDR_DESCLEN_SHR_MASK  0x3f
+
+/* If non-shared header, 7-bit length */
+#define HDR_DESCLEN_MASK      0x7f
+
+/* This is a TrustedDesc (if not SharedDesc) */
+#define HDR_TRUSTED             0x00004000
+
+/* Make into TrustedDesc (if not SharedDesc) */
+#define HDR_MAKE_TRUSTED        0x00002000
+
+/* Save context if self-shared (if SharedDesc) */
+#define HDR_SAVECTX             0x00001000
+
+/* Next item points to SharedDesc */
+#define HDR_SHARED              0x00001000
+
+/*
+ * Reverse Execution Order - execute JobDesc first, then
+ * execute SharedDesc (normally SharedDesc goes first).
+ */
+#define HDR_REVERSE             0x00000800
+
+/* Propogate DNR property to SharedDesc */
+#define HDR_PROP_DNR            0x00000800
+
+/* JobDesc/SharedDesc share property */
+#define HDR_SD_SHARE_MASK       0x03
+#define HDR_SD_SHARE_SHIFT      8
+#define HDR_JD_SHARE_MASK       0x07
+#define HDR_JD_SHARE_SHIFT      8
+
+#define HDR_SHARE_NEVER         (0x00 << HDR_SD_SHARE_SHIFT)
+#define HDR_SHARE_WAIT          (0x01 << HDR_SD_SHARE_SHIFT)
+#define HDR_SHARE_SERIAL        (0x02 << HDR_SD_SHARE_SHIFT)
+#define HDR_SHARE_ALWAYS        (0x03 << HDR_SD_SHARE_SHIFT)
+#define HDR_SHARE_DEFER         (0x04 << HDR_SD_SHARE_SHIFT)
+
+/* JobDesc/SharedDesc descriptor length */
+#define HDR_JD_LENGTH_MASK      0x7f
+#define HDR_SD_LENGTH_MASK      0x3f
+
+/*
+ * KEY/SEQ_KEY Command Constructs
+ */
+
+/* Key Destination Class: 01 = Class 1, 02 - Class 2  */
+#define KEY_DEST_CLASS_SHIFT    25  /* use CLASS_1 or CLASS_2 */
+#define KEY_DEST_CLASS_MASK     (0x03 << KEY_DEST_CLASS_SHIFT)
+
+/* Scatter-Gather Table/Variable Length Field */
+#define KEY_SGF                 0x01000000
+#define KEY_VLF                 0x01000000
+
+/* Immediate - Key follows command in the descriptor */
+#define KEY_IMM                 0x00800000
+
+/*
+ * Encrypted - Key is encrypted either with the KEK, or
+ * with the TDKEK if TK is set
+ */
+#define KEY_ENC                 0x00400000
+
+/*
+ * No Write Back - Do not allow key to be FIFO STOREd
+ */
+#define KEY_NWB			0x00200000
+
+/*
+ * Enhanced Encryption of Key
+ */
+#define KEY_EKT			0x00100000
+
+/*
+ * Encrypted with Trusted Key
+ */
+#define KEY_TK			0x00008000
+
+/*
+ * KDEST - Key Destination: 0 - class key register,
+ * 1 - PKHA 'e', 2 - AFHA Sbox, 3 - MDHA split-key
+ */
+#define KEY_DEST_SHIFT          16
+#define KEY_DEST_MASK           (0x03 << KEY_DEST_SHIFT)
+
+#define KEY_DEST_CLASS_REG      (0x00 << KEY_DEST_SHIFT)
+#define KEY_DEST_PKHA_E         (0x01 << KEY_DEST_SHIFT)
+#define KEY_DEST_AFHA_SBOX      (0x02 << KEY_DEST_SHIFT)
+#define KEY_DEST_MDHA_SPLIT     (0x03 << KEY_DEST_SHIFT)
+
+/* Length in bytes */
+#define KEY_LENGTH_MASK         0x000003ff
+
+/*
+ * LOAD/SEQ_LOAD/STORE/SEQ_STORE Command Constructs
+ */
+
+/*
+ * Load/Store Destination: 0 = class independent CCB,
+ * 1 = class 1 CCB, 2 = class 2 CCB, 3 = DECO
+ */
+#define LDST_CLASS_SHIFT        25
+#define LDST_CLASS_MASK         (0x03 << LDST_CLASS_SHIFT)
+#define LDST_CLASS_IND_CCB      (0x00 << LDST_CLASS_SHIFT)
+#define LDST_CLASS_1_CCB        (0x01 << LDST_CLASS_SHIFT)
+#define LDST_CLASS_2_CCB        (0x02 << LDST_CLASS_SHIFT)
+#define LDST_CLASS_DECO         (0x03 << LDST_CLASS_SHIFT)
+
+/* Scatter-Gather Table/Variable Length Field */
+#define LDST_SGF                0x01000000
+#define LDST_VLF		LDST_SGF
+
+/* Immediate - Key follows this command in descriptor    */
+#define LDST_IMM_MASK           1
+#define LDST_IMM_SHIFT          23
+#define LDST_IMM                (LDST_IMM_MASK << LDST_IMM_SHIFT)
+
+/* SRC/DST - Destination for LOAD, Source for STORE   */
+#define LDST_SRCDST_SHIFT       16
+#define LDST_SRCDST_MASK        (0x7f << LDST_SRCDST_SHIFT)
+
+#define LDST_SRCDST_BYTE_CONTEXT	(0x20 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_BYTE_KEY		(0x40 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_BYTE_INFIFO		(0x7c << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_BYTE_OUTFIFO	(0x7e << LDST_SRCDST_SHIFT)
+
+#define LDST_SRCDST_WORD_MODE_REG	(0x00 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_KEYSZ_REG	(0x01 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DATASZ_REG	(0x02 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_ICVSZ_REG	(0x03 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_CHACTRL	(0x06 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECOCTRL       (0x06 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_IRQCTRL	(0x07 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_PCLOVRD   (0x07 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_CLRW		(0x08 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_MATH0     (0x08 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_STAT		(0x09 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_MATH1     (0x09 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_MATH2     (0x0a << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_AAD_SZ    (0x0b << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DECO_MATH3     (0x0b << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_CLASS1_ICV_SZ  (0x0c << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_ALTDS_CLASS1   (0x0f << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_PKHA_A_SZ      (0x10 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_PKHA_B_SZ      (0x11 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_PKHA_N_SZ      (0x12 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_PKHA_E_SZ      (0x13 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DESCBUF        (0x40 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_INFO_FIFO      (0x7a << LDST_SRCDST_SHIFT)
+
+/* Offset in source/destination                        */
+#define LDST_OFFSET_SHIFT       8
+#define LDST_OFFSET_MASK        (0xff << LDST_OFFSET_SHIFT)
+
+/* LDOFF definitions used when DST = LDST_SRCDST_WORD_DECOCTRL */
+/* These could also be shifted by LDST_OFFSET_SHIFT - this reads better */
+#define LDOFF_CHG_SHARE_SHIFT        0
+#define LDOFF_CHG_SHARE_MASK         (0x3 << LDOFF_CHG_SHARE_SHIFT)
+#define LDOFF_CHG_SHARE_NEVER        (0x1 << LDOFF_CHG_SHARE_SHIFT)
+#define LDOFF_CHG_SHARE_OK_NO_PROP   (0x2 << LDOFF_CHG_SHARE_SHIFT)
+#define LDOFF_CHG_SHARE_OK_PROP      (0x3 << LDOFF_CHG_SHARE_SHIFT)
+
+#define LDOFF_ENABLE_AUTO_NFIFO         (1 << 2)
+#define LDOFF_DISABLE_AUTO_NFIFO        (1 << 3)
+
+#define LDOFF_CHG_NONSEQLIODN_SHIFT     4
+#define LDOFF_CHG_NONSEQLIODN_MASK      (0x3 << LDOFF_CHG_NONSEQLIODN_SHIFT)
+#define LDOFF_CHG_NONSEQLIODN_SEQ       (0x1 << LDOFF_CHG_NONSEQLIODN_SHIFT)
+#define LDOFF_CHG_NONSEQLIODN_NON_SEQ   (0x2 << LDOFF_CHG_NONSEQLIODN_SHIFT)
+#define LDOFF_CHG_NONSEQLIODN_TRUSTED   (0x3 << LDOFF_CHG_NONSEQLIODN_SHIFT)
+
+#define LDOFF_CHG_SEQLIODN_SHIFT     6
+#define LDOFF_CHG_SEQLIODN_MASK      (0x3 << LDOFF_CHG_SEQLIODN_SHIFT)
+#define LDOFF_CHG_SEQLIODN_SEQ       (0x1 << LDOFF_CHG_SEQLIODN_SHIFT)
+#define LDOFF_CHG_SEQLIODN_NON_SEQ   (0x2 << LDOFF_CHG_SEQLIODN_SHIFT)
+#define LDOFF_CHG_SEQLIODN_TRUSTED   (0x3 << LDOFF_CHG_SEQLIODN_SHIFT)
+
+/* Data length in bytes                                 */
+#define LDST_LEN_SHIFT          0
+#define LDST_LEN_MASK           (0xff << LDST_LEN_SHIFT)
+
+/* Special Length definitions when dst=deco-ctrl */
+#define LDLEN_ENABLE_OSL_COUNT      (1 << 7)
+#define LDLEN_RST_CHA_OFIFO_PTR     (1 << 6)
+#define LDLEN_RST_OFIFO             (1 << 5)
+#define LDLEN_SET_OFIFO_OFF_VALID   (1 << 4)
+#define LDLEN_SET_OFIFO_OFF_RSVD    (1 << 3)
+#define LDLEN_SET_OFIFO_OFFSET_SHIFT 0
+#define LDLEN_SET_OFIFO_OFFSET_MASK (3 << LDLEN_SET_OFIFO_OFFSET_SHIFT)
+
+/*
+ * FIFO_LOAD/FIFO_STORE/SEQ_FIFO_LOAD/SEQ_FIFO_STORE
+ * Command Constructs
+ */
+
+/*
+ * Load Destination: 0 = skip (SEQ_FIFO_LOAD only),
+ * 1 = Load for Class1, 2 = Load for Class2, 3 = Load both
+ * Store Source: 0 = normal, 1 = Class1key, 2 = Class2key
+ */
+#define FIFOLD_CLASS_SHIFT      25
+#define FIFOLD_CLASS_MASK       (0x03 << FIFOLD_CLASS_SHIFT)
+#define FIFOLD_CLASS_SKIP       (0x00 << FIFOLD_CLASS_SHIFT)
+#define FIFOLD_CLASS_CLASS1     (0x01 << FIFOLD_CLASS_SHIFT)
+#define FIFOLD_CLASS_CLASS2     (0x02 << FIFOLD_CLASS_SHIFT)
+#define FIFOLD_CLASS_BOTH       (0x03 << FIFOLD_CLASS_SHIFT)
+
+#define FIFOST_CLASS_SHIFT      25
+#define FIFOST_CLASS_MASK       (0x03 << FIFOST_CLASS_SHIFT)
+#define FIFOST_CLASS_NORMAL     (0x00 << FIFOST_CLASS_SHIFT)
+#define FIFOST_CLASS_CLASS1KEY  (0x01 << FIFOST_CLASS_SHIFT)
+#define FIFOST_CLASS_CLASS2KEY  (0x02 << FIFOST_CLASS_SHIFT)
+
+/*
+ * Scatter-Gather Table/Variable Length Field
+ * If set for FIFO_LOAD, refers to a SG table. Within
+ * SEQ_FIFO_LOAD, is variable input sequence
+ */
+#define FIFOLDST_SGF_SHIFT      24
+#define FIFOLDST_SGF_MASK       (1 << FIFOLDST_SGF_SHIFT)
+#define FIFOLDST_VLF_MASK       (1 << FIFOLDST_SGF_SHIFT)
+#define FIFOLDST_SGF            (1 << FIFOLDST_SGF_SHIFT)
+#define FIFOLDST_VLF            (1 << FIFOLDST_SGF_SHIFT)
+
+/* Immediate - Data follows command in descriptor */
+#define FIFOLD_IMM_SHIFT      23
+#define FIFOLD_IMM_MASK       (1 << FIFOLD_IMM_SHIFT)
+#define FIFOLD_IMM            (1 << FIFOLD_IMM_SHIFT)
+
+/* Continue - Not the last FIFO store to come */
+#define FIFOST_CONT_SHIFT     23
+#define FIFOST_CONT_MASK      (1 << FIFOST_CONT_SHIFT)
+#define FIFOST_CONT_MASK      (1 << FIFOST_CONT_SHIFT)
+
+/*
+ * Extended Length - use 32-bit extended length that
+ * follows the pointer field. Illegal with IMM set
+ */
+#define FIFOLDST_EXT_SHIFT      22
+#define FIFOLDST_EXT_MASK       (1 << FIFOLDST_EXT_SHIFT)
+#define FIFOLDST_EXT            (1 << FIFOLDST_EXT_SHIFT)
+
+/* Input data type.*/
+#define FIFOLD_TYPE_SHIFT       16
+#define FIFOLD_CONT_TYPE_SHIFT  19 /* shift past last-flush bits */
+#define FIFOLD_TYPE_MASK        (0x3f << FIFOLD_TYPE_SHIFT)
+
+/* PK types */
+#define FIFOLD_TYPE_PK          (0x00 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_MASK     (0x30 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_TYPEMASK (0x0f << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_A0       (0x00 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_A1       (0x01 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_A2       (0x02 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_A3       (0x03 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_B0       (0x04 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_B1       (0x05 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_B2       (0x06 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_B3       (0x07 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_N        (0x08 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_A        (0x0c << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_PK_B        (0x0d << FIFOLD_TYPE_SHIFT)
+
+/* Other types. Need to OR in last/flush bits as desired */
+#define FIFOLD_TYPE_MSG_MASK    (0x38 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_MSG         (0x10 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_MSG1OUT2    (0x18 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_IV          (0x20 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_BITDATA     (0x28 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_AAD         (0x30 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_ICV         (0x38 << FIFOLD_TYPE_SHIFT)
+
+/* Last/Flush bits for use with "other" types above */
+#define FIFOLD_TYPE_ACT_MASK    (0x07 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_NOACTION    (0x00 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_FLUSH1      (0x01 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_LAST1       (0x02 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_LAST2FLUSH  (0x03 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_LAST2       (0x04 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_LAST2FLUSH1 (0x05 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_LASTBOTH    (0x06 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_LASTBOTHFL  (0x07 << FIFOLD_TYPE_SHIFT)
+
+#define FIFOLDST_LEN_MASK       0xffff
+#define FIFOLDST_EXT_LEN_MASK   0xffffffff
+
+/* Output data types */
+#define FIFOST_TYPE_SHIFT       16
+#define FIFOST_TYPE_MASK        (0x3f << FIFOST_TYPE_SHIFT)
+
+#define FIFOST_TYPE_PKHA_A0      (0x00 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_A1      (0x01 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_A2      (0x02 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_A3      (0x03 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_B0      (0x04 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_B1      (0x05 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_B2      (0x06 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_B3      (0x07 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_N       (0x08 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_A       (0x0c << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_B       (0x0d << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_AF_SBOX_JKEK (0x10 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_AF_SBOX_TKEK (0x21 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_E_JKEK  (0x22 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_PKHA_E_TKEK  (0x23 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_KEY_KEK      (0x24 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_KEY_TKEK     (0x25 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_SPLIT_KEK    (0x26 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_SPLIT_TKEK   (0x27 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_OUTFIFO_KEK  (0x28 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_OUTFIFO_TKEK (0x29 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_MESSAGE_DATA (0x30 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_RNGSTORE     (0x34 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_RNGFIFO      (0x35 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_SKIP         (0x3f << FIFOST_TYPE_SHIFT)
+
+/*
+ * OPERATION Command Constructs
+ */
+
+/* Operation type selectors - OP TYPE */
+#define OP_TYPE_SHIFT           24
+#define OP_TYPE_MASK            (0x07 << OP_TYPE_SHIFT)
+
+#define OP_TYPE_UNI_PROTOCOL    (0x00 << OP_TYPE_SHIFT)
+#define OP_TYPE_PK              (0x01 << OP_TYPE_SHIFT)
+#define OP_TYPE_CLASS1_ALG      (0x02 << OP_TYPE_SHIFT)
+#define OP_TYPE_CLASS2_ALG      (0x04 << OP_TYPE_SHIFT)
+#define OP_TYPE_DECAP_PROTOCOL  (0x06 << OP_TYPE_SHIFT)
+#define OP_TYPE_ENCAP_PROTOCOL  (0x07 << OP_TYPE_SHIFT)
+
+/* ProtocolID selectors - PROTID */
+#define OP_PCLID_SHIFT          16
+#define OP_PCLID_MASK           (0xff << 16)
+
+/* Assuming OP_TYPE = OP_TYPE_UNI_PROTOCOL */
+#define OP_PCLID_IKEV1_PRF      (0x01 << OP_PCLID_SHIFT)
+#define OP_PCLID_IKEV2_PRF      (0x02 << OP_PCLID_SHIFT)
+#define OP_PCLID_SSL30_PRF      (0x08 << OP_PCLID_SHIFT)
+#define OP_PCLID_TLS10_PRF      (0x09 << OP_PCLID_SHIFT)
+#define OP_PCLID_TLS11_PRF      (0x0a << OP_PCLID_SHIFT)
+#define OP_PCLID_DTLS10_PRF     (0x0c << OP_PCLID_SHIFT)
+#define OP_PCLID_PRF            (0x06 << OP_PCLID_SHIFT)
+#define OP_PCLID_BLOB           (0x0d << OP_PCLID_SHIFT)
+#define OP_PCLID_SECRETKEY      (0x11 << OP_PCLID_SHIFT)
+#define OP_PCLID_PUBLICKEYPAIR  (0x14 << OP_PCLID_SHIFT)
+#define OP_PCLID_DSASIGN        (0x15 << OP_PCLID_SHIFT)
+#define OP_PCLID_DSAVERIFY      (0x16 << OP_PCLID_SHIFT)
+
+/* Assuming OP_TYPE = OP_TYPE_DECAP_PROTOCOL/ENCAP_PROTOCOL */
+#define OP_PCLID_IPSEC          (0x01 << OP_PCLID_SHIFT)
+#define OP_PCLID_SRTP           (0x02 << OP_PCLID_SHIFT)
+#define OP_PCLID_MACSEC         (0x03 << OP_PCLID_SHIFT)
+#define OP_PCLID_WIFI           (0x04 << OP_PCLID_SHIFT)
+#define OP_PCLID_WIMAX          (0x05 << OP_PCLID_SHIFT)
+#define OP_PCLID_SSL30          (0x08 << OP_PCLID_SHIFT)
+#define OP_PCLID_TLS10          (0x09 << OP_PCLID_SHIFT)
+#define OP_PCLID_TLS11          (0x0a << OP_PCLID_SHIFT)
+#define OP_PCLID_TLS12          (0x0b << OP_PCLID_SHIFT)
+#define OP_PCLID_DTLS           (0x0c << OP_PCLID_SHIFT)
+
+/*
+ * ProtocolInfo selectors
+ */
+#define OP_PCLINFO_MASK                          0xffff
+
+/* for OP_PCLID_IPSEC */
+#define OP_PCL_IPSEC_CIPHER_MASK                 0xff00
+#define OP_PCL_IPSEC_AUTH_MASK                   0x00ff
+
+#define OP_PCL_IPSEC_DES_IV64                    0x0100
+#define OP_PCL_IPSEC_DES                         0x0200
+#define OP_PCL_IPSEC_3DES                        0x0300
+#define OP_PCL_IPSEC_AES_CBC                     0x0c00
+#define OP_PCL_IPSEC_AES_CTR                     0x0d00
+#define OP_PCL_IPSEC_AES_XTS                     0x1600
+#define OP_PCL_IPSEC_AES_CCM8                    0x0e00
+#define OP_PCL_IPSEC_AES_CCM12                   0x0f00
+#define OP_PCL_IPSEC_AES_CCM16                   0x1000
+#define OP_PCL_IPSEC_AES_GCM8                    0x1200
+#define OP_PCL_IPSEC_AES_GCM12                   0x1300
+#define OP_PCL_IPSEC_AES_GCM16                   0x1400
+
+#define OP_PCL_IPSEC_HMAC_NULL                   0x0000
+#define OP_PCL_IPSEC_HMAC_MD5_96                 0x0001
+#define OP_PCL_IPSEC_HMAC_SHA1_96                0x0002
+#define OP_PCL_IPSEC_AES_XCBC_MAC_96             0x0005
+#define OP_PCL_IPSEC_HMAC_MD5_128                0x0006
+#define OP_PCL_IPSEC_HMAC_SHA1_160               0x0007
+#define OP_PCL_IPSEC_HMAC_SHA2_256_128           0x000c
+#define OP_PCL_IPSEC_HMAC_SHA2_384_192           0x000d
+#define OP_PCL_IPSEC_HMAC_SHA2_512_256           0x000e
+
+/* For SRTP - OP_PCLID_SRTP */
+#define OP_PCL_SRTP_CIPHER_MASK                  0xff00
+#define OP_PCL_SRTP_AUTH_MASK                    0x00ff
+
+#define OP_PCL_SRTP_AES_CTR                      0x0d00
+
+#define OP_PCL_SRTP_HMAC_SHA1_160                0x0007
+
+/* For SSL 3.0 - OP_PCLID_SSL30 */
+#define OP_PCL_SSL30_AES_128_CBC_SHA             0x002f
+#define OP_PCL_SSL30_AES_128_CBC_SHA_2           0x0030
+#define OP_PCL_SSL30_AES_128_CBC_SHA_3           0x0031
+#define OP_PCL_SSL30_AES_128_CBC_SHA_4           0x0032
+#define OP_PCL_SSL30_AES_128_CBC_SHA_5           0x0033
+#define OP_PCL_SSL30_AES_128_CBC_SHA_6           0x0034
+#define OP_PCL_SSL30_AES_128_CBC_SHA_7           0x008c
+#define OP_PCL_SSL30_AES_128_CBC_SHA_8           0x0090
+#define OP_PCL_SSL30_AES_128_CBC_SHA_9           0x0094
+#define OP_PCL_SSL30_AES_128_CBC_SHA_10          0xc004
+#define OP_PCL_SSL30_AES_128_CBC_SHA_11          0xc009
+#define OP_PCL_SSL30_AES_128_CBC_SHA_12          0xc00e
+#define OP_PCL_SSL30_AES_128_CBC_SHA_13          0xc013
+#define OP_PCL_SSL30_AES_128_CBC_SHA_14          0xc018
+#define OP_PCL_SSL30_AES_128_CBC_SHA_15          0xc01d
+#define OP_PCL_SSL30_AES_128_CBC_SHA_16          0xc01e
+#define OP_PCL_SSL30_AES_128_CBC_SHA_17          0xc01f
+
+#define OP_PCL_SSL30_AES_256_CBC_SHA             0x0035
+#define OP_PCL_SSL30_AES_256_CBC_SHA_2           0x0036
+#define OP_PCL_SSL30_AES_256_CBC_SHA_3           0x0037
+#define OP_PCL_SSL30_AES_256_CBC_SHA_4           0x0038
+#define OP_PCL_SSL30_AES_256_CBC_SHA_5           0x0039
+#define OP_PCL_SSL30_AES_256_CBC_SHA_6           0x003a
+#define OP_PCL_SSL30_AES_256_CBC_SHA_7           0x008d
+#define OP_PCL_SSL30_AES_256_CBC_SHA_8           0x0091
+#define OP_PCL_SSL30_AES_256_CBC_SHA_9           0x0095
+#define OP_PCL_SSL30_AES_256_CBC_SHA_10          0xc005
+#define OP_PCL_SSL30_AES_256_CBC_SHA_11          0xc00a
+#define OP_PCL_SSL30_AES_256_CBC_SHA_12          0xc00f
+#define OP_PCL_SSL30_AES_256_CBC_SHA_13          0xc014
+#define OP_PCL_SSL30_AES_256_CBC_SHA_14          0xc019
+#define OP_PCL_SSL30_AES_256_CBC_SHA_15          0xc020
+#define OP_PCL_SSL30_AES_256_CBC_SHA_16          0xc021
+#define OP_PCL_SSL30_AES_256_CBC_SHA_17          0xc022
+
+#define OP_PCL_SSL30_3DES_EDE_CBC_MD5            0x0023
+
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA            0x001f
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_2          0x008b
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_3          0x008f
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_4          0x0093
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_5          0x000a
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_6          0x000d
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_7          0x0010
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_8          0x0013
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_9          0x0016
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_10         0x001b
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_11         0xc003
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_12         0xc008
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_13         0xc00d
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_14         0xc012
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_15         0xc017
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_16         0xc01a
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_17         0xc01b
+#define OP_PCL_SSL30_3DES_EDE_CBC_SHA_18         0xc01c
+
+#define OP_PCL_SSL30_DES40_CBC_MD5               0x0029
+
+#define OP_PCL_SSL30_DES_CBC_MD5                 0x0022
+
+#define OP_PCL_SSL30_DES40_CBC_SHA               0x0008
+#define OP_PCL_SSL30_DES40_CBC_SHA_2             0x000b
+#define OP_PCL_SSL30_DES40_CBC_SHA_3             0x000e
+#define OP_PCL_SSL30_DES40_CBC_SHA_4             0x0011
+#define OP_PCL_SSL30_DES40_CBC_SHA_5             0x0014
+#define OP_PCL_SSL30_DES40_CBC_SHA_6             0x0019
+#define OP_PCL_SSL30_DES40_CBC_SHA_7             0x0026
+
+#define OP_PCL_SSL30_DES_CBC_SHA                 0x001e
+#define OP_PCL_SSL30_DES_CBC_SHA_2               0x0009
+#define OP_PCL_SSL30_DES_CBC_SHA_3               0x000c
+#define OP_PCL_SSL30_DES_CBC_SHA_4               0x000f
+#define OP_PCL_SSL30_DES_CBC_SHA_5               0x0012
+#define OP_PCL_SSL30_DES_CBC_SHA_6               0x0015
+#define OP_PCL_SSL30_DES_CBC_SHA_7               0x001a
+
+#define OP_PCL_SSL30_RC4_128_MD5                 0x0024
+#define OP_PCL_SSL30_RC4_128_MD5_2               0x0004
+#define OP_PCL_SSL30_RC4_128_MD5_3               0x0018
+
+#define OP_PCL_SSL30_RC4_40_MD5                  0x002b
+#define OP_PCL_SSL30_RC4_40_MD5_2                0x0003
+#define OP_PCL_SSL30_RC4_40_MD5_3                0x0017
+
+#define OP_PCL_SSL30_RC4_128_SHA                 0x0020
+#define OP_PCL_SSL30_RC4_128_SHA_2               0x008a
+#define OP_PCL_SSL30_RC4_128_SHA_3               0x008e
+#define OP_PCL_SSL30_RC4_128_SHA_4               0x0092
+#define OP_PCL_SSL30_RC4_128_SHA_5               0x0005
+#define OP_PCL_SSL30_RC4_128_SHA_6               0xc002
+#define OP_PCL_SSL30_RC4_128_SHA_7               0xc007
+#define OP_PCL_SSL30_RC4_128_SHA_8               0xc00c
+#define OP_PCL_SSL30_RC4_128_SHA_9               0xc011
+#define OP_PCL_SSL30_RC4_128_SHA_10              0xc016
+
+#define OP_PCL_SSL30_RC4_40_SHA                  0x0028
+
+
+/* For TLS 1.0 - OP_PCLID_TLS10 */
+#define OP_PCL_TLS10_AES_128_CBC_SHA             0x002f
+#define OP_PCL_TLS10_AES_128_CBC_SHA_2           0x0030
+#define OP_PCL_TLS10_AES_128_CBC_SHA_3           0x0031
+#define OP_PCL_TLS10_AES_128_CBC_SHA_4           0x0032
+#define OP_PCL_TLS10_AES_128_CBC_SHA_5           0x0033
+#define OP_PCL_TLS10_AES_128_CBC_SHA_6           0x0034
+#define OP_PCL_TLS10_AES_128_CBC_SHA_7           0x008c
+#define OP_PCL_TLS10_AES_128_CBC_SHA_8           0x0090
+#define OP_PCL_TLS10_AES_128_CBC_SHA_9           0x0094
+#define OP_PCL_TLS10_AES_128_CBC_SHA_10          0xc004
+#define OP_PCL_TLS10_AES_128_CBC_SHA_11          0xc009
+#define OP_PCL_TLS10_AES_128_CBC_SHA_12          0xc00e
+#define OP_PCL_TLS10_AES_128_CBC_SHA_13          0xc013
+#define OP_PCL_TLS10_AES_128_CBC_SHA_14          0xc018
+#define OP_PCL_TLS10_AES_128_CBC_SHA_15          0xc01d
+#define OP_PCL_TLS10_AES_128_CBC_SHA_16          0xc01e
+#define OP_PCL_TLS10_AES_128_CBC_SHA_17          0xc01f
+
+#define OP_PCL_TLS10_AES_256_CBC_SHA             0x0035
+#define OP_PCL_TLS10_AES_256_CBC_SHA_2           0x0036
+#define OP_PCL_TLS10_AES_256_CBC_SHA_3           0x0037
+#define OP_PCL_TLS10_AES_256_CBC_SHA_4           0x0038
+#define OP_PCL_TLS10_AES_256_CBC_SHA_5           0x0039
+#define OP_PCL_TLS10_AES_256_CBC_SHA_6           0x003a
+#define OP_PCL_TLS10_AES_256_CBC_SHA_7           0x008d
+#define OP_PCL_TLS10_AES_256_CBC_SHA_8           0x0091
+#define OP_PCL_TLS10_AES_256_CBC_SHA_9           0x0095
+#define OP_PCL_TLS10_AES_256_CBC_SHA_10          0xc005
+#define OP_PCL_TLS10_AES_256_CBC_SHA_11          0xc00a
+#define OP_PCL_TLS10_AES_256_CBC_SHA_12          0xc00f
+#define OP_PCL_TLS10_AES_256_CBC_SHA_13          0xc014
+#define OP_PCL_TLS10_AES_256_CBC_SHA_14          0xc019
+#define OP_PCL_TLS10_AES_256_CBC_SHA_15          0xc020
+#define OP_PCL_TLS10_AES_256_CBC_SHA_16          0xc021
+#define OP_PCL_TLS10_AES_256_CBC_SHA_17          0xc022
+
+/* #define OP_PCL_TLS10_3DES_EDE_CBC_MD5            0x0023 */
+
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA            0x001f
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_2          0x008b
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_3          0x008f
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_4          0x0093
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_5          0x000a
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_6          0x000d
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_7          0x0010
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_8          0x0013
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_9          0x0016
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_10         0x001b
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_11         0xc003
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_12         0xc008
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_13         0xc00d
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_14         0xc012
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_15         0xc017
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_16         0xc01a
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_17         0xc01b
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA_18         0xc01c
+
+#define OP_PCL_TLS10_DES40_CBC_MD5               0x0029
+
+#define OP_PCL_TLS10_DES_CBC_MD5                 0x0022
+
+#define OP_PCL_TLS10_DES40_CBC_SHA               0x0008
+#define OP_PCL_TLS10_DES40_CBC_SHA_2             0x000b
+#define OP_PCL_TLS10_DES40_CBC_SHA_3             0x000e
+#define OP_PCL_TLS10_DES40_CBC_SHA_4             0x0011
+#define OP_PCL_TLS10_DES40_CBC_SHA_5             0x0014
+#define OP_PCL_TLS10_DES40_CBC_SHA_6             0x0019
+#define OP_PCL_TLS10_DES40_CBC_SHA_7             0x0026
+
+
+#define OP_PCL_TLS10_DES_CBC_SHA                 0x001e
+#define OP_PCL_TLS10_DES_CBC_SHA_2               0x0009
+#define OP_PCL_TLS10_DES_CBC_SHA_3               0x000c
+#define OP_PCL_TLS10_DES_CBC_SHA_4               0x000f
+#define OP_PCL_TLS10_DES_CBC_SHA_5               0x0012
+#define OP_PCL_TLS10_DES_CBC_SHA_6               0x0015
+#define OP_PCL_TLS10_DES_CBC_SHA_7               0x001a
+
+#define OP_PCL_TLS10_RC4_128_MD5                 0x0024
+#define OP_PCL_TLS10_RC4_128_MD5_2               0x0004
+#define OP_PCL_TLS10_RC4_128_MD5_3               0x0018
+
+#define OP_PCL_TLS10_RC4_40_MD5                  0x002b
+#define OP_PCL_TLS10_RC4_40_MD5_2                0x0003
+#define OP_PCL_TLS10_RC4_40_MD5_3                0x0017
+
+#define OP_PCL_TLS10_RC4_128_SHA                 0x0020
+#define OP_PCL_TLS10_RC4_128_SHA_2               0x008a
+#define OP_PCL_TLS10_RC4_128_SHA_3               0x008e
+#define OP_PCL_TLS10_RC4_128_SHA_4               0x0092
+#define OP_PCL_TLS10_RC4_128_SHA_5               0x0005
+#define OP_PCL_TLS10_RC4_128_SHA_6               0xc002
+#define OP_PCL_TLS10_RC4_128_SHA_7               0xc007
+#define OP_PCL_TLS10_RC4_128_SHA_8               0xc00c
+#define OP_PCL_TLS10_RC4_128_SHA_9               0xc011
+#define OP_PCL_TLS10_RC4_128_SHA_10              0xc016
+
+#define OP_PCL_TLS10_RC4_40_SHA                  0x0028
+
+#define OP_PCL_TLS10_3DES_EDE_CBC_MD5            0xff23
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA160         0xff30
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA224         0xff34
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA256         0xff36
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA384         0xff33
+#define OP_PCL_TLS10_3DES_EDE_CBC_SHA512         0xff35
+#define OP_PCL_TLS10_AES_128_CBC_SHA160          0xff80
+#define OP_PCL_TLS10_AES_128_CBC_SHA224          0xff84
+#define OP_PCL_TLS10_AES_128_CBC_SHA256          0xff86
+#define OP_PCL_TLS10_AES_128_CBC_SHA384          0xff83
+#define OP_PCL_TLS10_AES_128_CBC_SHA512          0xff85
+#define OP_PCL_TLS10_AES_192_CBC_SHA160          0xff20
+#define OP_PCL_TLS10_AES_192_CBC_SHA224          0xff24
+#define OP_PCL_TLS10_AES_192_CBC_SHA256          0xff26
+#define OP_PCL_TLS10_AES_192_CBC_SHA384          0xff23
+#define OP_PCL_TLS10_AES_192_CBC_SHA512          0xff25
+#define OP_PCL_TLS10_AES_256_CBC_SHA160          0xff60
+#define OP_PCL_TLS10_AES_256_CBC_SHA224          0xff64
+#define OP_PCL_TLS10_AES_256_CBC_SHA256          0xff66
+#define OP_PCL_TLS10_AES_256_CBC_SHA384          0xff63
+#define OP_PCL_TLS10_AES_256_CBC_SHA512          0xff65
+
+
+
+/* For TLS 1.1 - OP_PCLID_TLS11 */
+#define OP_PCL_TLS11_AES_128_CBC_SHA             0x002f
+#define OP_PCL_TLS11_AES_128_CBC_SHA_2           0x0030
+#define OP_PCL_TLS11_AES_128_CBC_SHA_3           0x0031
+#define OP_PCL_TLS11_AES_128_CBC_SHA_4           0x0032
+#define OP_PCL_TLS11_AES_128_CBC_SHA_5           0x0033
+#define OP_PCL_TLS11_AES_128_CBC_SHA_6           0x0034
+#define OP_PCL_TLS11_AES_128_CBC_SHA_7           0x008c
+#define OP_PCL_TLS11_AES_128_CBC_SHA_8           0x0090
+#define OP_PCL_TLS11_AES_128_CBC_SHA_9           0x0094
+#define OP_PCL_TLS11_AES_128_CBC_SHA_10          0xc004
+#define OP_PCL_TLS11_AES_128_CBC_SHA_11          0xc009
+#define OP_PCL_TLS11_AES_128_CBC_SHA_12          0xc00e
+#define OP_PCL_TLS11_AES_128_CBC_SHA_13          0xc013
+#define OP_PCL_TLS11_AES_128_CBC_SHA_14          0xc018
+#define OP_PCL_TLS11_AES_128_CBC_SHA_15          0xc01d
+#define OP_PCL_TLS11_AES_128_CBC_SHA_16          0xc01e
+#define OP_PCL_TLS11_AES_128_CBC_SHA_17          0xc01f
+
+#define OP_PCL_TLS11_AES_256_CBC_SHA             0x0035
+#define OP_PCL_TLS11_AES_256_CBC_SHA_2           0x0036
+#define OP_PCL_TLS11_AES_256_CBC_SHA_3           0x0037
+#define OP_PCL_TLS11_AES_256_CBC_SHA_4           0x0038
+#define OP_PCL_TLS11_AES_256_CBC_SHA_5           0x0039
+#define OP_PCL_TLS11_AES_256_CBC_SHA_6           0x003a
+#define OP_PCL_TLS11_AES_256_CBC_SHA_7           0x008d
+#define OP_PCL_TLS11_AES_256_CBC_SHA_8           0x0091
+#define OP_PCL_TLS11_AES_256_CBC_SHA_9           0x0095
+#define OP_PCL_TLS11_AES_256_CBC_SHA_10          0xc005
+#define OP_PCL_TLS11_AES_256_CBC_SHA_11          0xc00a
+#define OP_PCL_TLS11_AES_256_CBC_SHA_12          0xc00f
+#define OP_PCL_TLS11_AES_256_CBC_SHA_13          0xc014
+#define OP_PCL_TLS11_AES_256_CBC_SHA_14          0xc019
+#define OP_PCL_TLS11_AES_256_CBC_SHA_15          0xc020
+#define OP_PCL_TLS11_AES_256_CBC_SHA_16          0xc021
+#define OP_PCL_TLS11_AES_256_CBC_SHA_17          0xc022
+
+/* #define OP_PCL_TLS11_3DES_EDE_CBC_MD5            0x0023 */
+
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA            0x001f
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_2          0x008b
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_3          0x008f
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_4          0x0093
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_5          0x000a
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_6          0x000d
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_7          0x0010
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_8          0x0013
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_9          0x0016
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_10         0x001b
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_11         0xc003
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_12         0xc008
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_13         0xc00d
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_14         0xc012
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_15         0xc017
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_16         0xc01a
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_17         0xc01b
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA_18         0xc01c
+
+#define OP_PCL_TLS11_DES40_CBC_MD5               0x0029
+
+#define OP_PCL_TLS11_DES_CBC_MD5                 0x0022
+
+#define OP_PCL_TLS11_DES40_CBC_SHA               0x0008
+#define OP_PCL_TLS11_DES40_CBC_SHA_2             0x000b
+#define OP_PCL_TLS11_DES40_CBC_SHA_3             0x000e
+#define OP_PCL_TLS11_DES40_CBC_SHA_4             0x0011
+#define OP_PCL_TLS11_DES40_CBC_SHA_5             0x0014
+#define OP_PCL_TLS11_DES40_CBC_SHA_6             0x0019
+#define OP_PCL_TLS11_DES40_CBC_SHA_7             0x0026
+
+#define OP_PCL_TLS11_DES_CBC_SHA                 0x001e
+#define OP_PCL_TLS11_DES_CBC_SHA_2               0x0009
+#define OP_PCL_TLS11_DES_CBC_SHA_3               0x000c
+#define OP_PCL_TLS11_DES_CBC_SHA_4               0x000f
+#define OP_PCL_TLS11_DES_CBC_SHA_5               0x0012
+#define OP_PCL_TLS11_DES_CBC_SHA_6               0x0015
+#define OP_PCL_TLS11_DES_CBC_SHA_7               0x001a
+
+#define OP_PCL_TLS11_RC4_128_MD5                 0x0024
+#define OP_PCL_TLS11_RC4_128_MD5_2               0x0004
+#define OP_PCL_TLS11_RC4_128_MD5_3               0x0018
+
+#define OP_PCL_TLS11_RC4_40_MD5                  0x002b
+#define OP_PCL_TLS11_RC4_40_MD5_2                0x0003
+#define OP_PCL_TLS11_RC4_40_MD5_3                0x0017
+
+#define OP_PCL_TLS11_RC4_128_SHA                 0x0020
+#define OP_PCL_TLS11_RC4_128_SHA_2               0x008a
+#define OP_PCL_TLS11_RC4_128_SHA_3               0x008e
+#define OP_PCL_TLS11_RC4_128_SHA_4               0x0092
+#define OP_PCL_TLS11_RC4_128_SHA_5               0x0005
+#define OP_PCL_TLS11_RC4_128_SHA_6               0xc002
+#define OP_PCL_TLS11_RC4_128_SHA_7               0xc007
+#define OP_PCL_TLS11_RC4_128_SHA_8               0xc00c
+#define OP_PCL_TLS11_RC4_128_SHA_9               0xc011
+#define OP_PCL_TLS11_RC4_128_SHA_10              0xc016
+
+#define OP_PCL_TLS11_RC4_40_SHA                  0x0028
+
+#define OP_PCL_TLS11_3DES_EDE_CBC_MD5            0xff23
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA160         0xff30
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA224         0xff34
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA256         0xff36
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA384         0xff33
+#define OP_PCL_TLS11_3DES_EDE_CBC_SHA512         0xff35
+#define OP_PCL_TLS11_AES_128_CBC_SHA160          0xff80
+#define OP_PCL_TLS11_AES_128_CBC_SHA224          0xff84
+#define OP_PCL_TLS11_AES_128_CBC_SHA256          0xff86
+#define OP_PCL_TLS11_AES_128_CBC_SHA384          0xff83
+#define OP_PCL_TLS11_AES_128_CBC_SHA512          0xff85
+#define OP_PCL_TLS11_AES_192_CBC_SHA160          0xff20
+#define OP_PCL_TLS11_AES_192_CBC_SHA224          0xff24
+#define OP_PCL_TLS11_AES_192_CBC_SHA256          0xff26
+#define OP_PCL_TLS11_AES_192_CBC_SHA384          0xff23
+#define OP_PCL_TLS11_AES_192_CBC_SHA512          0xff25
+#define OP_PCL_TLS11_AES_256_CBC_SHA160          0xff60
+#define OP_PCL_TLS11_AES_256_CBC_SHA224          0xff64
+#define OP_PCL_TLS11_AES_256_CBC_SHA256          0xff66
+#define OP_PCL_TLS11_AES_256_CBC_SHA384          0xff63
+#define OP_PCL_TLS11_AES_256_CBC_SHA512          0xff65
+
+
+/* For TLS 1.2 - OP_PCLID_TLS12 */
+#define OP_PCL_TLS12_AES_128_CBC_SHA             0x002f
+#define OP_PCL_TLS12_AES_128_CBC_SHA_2           0x0030
+#define OP_PCL_TLS12_AES_128_CBC_SHA_3           0x0031
+#define OP_PCL_TLS12_AES_128_CBC_SHA_4           0x0032
+#define OP_PCL_TLS12_AES_128_CBC_SHA_5           0x0033
+#define OP_PCL_TLS12_AES_128_CBC_SHA_6           0x0034
+#define OP_PCL_TLS12_AES_128_CBC_SHA_7           0x008c
+#define OP_PCL_TLS12_AES_128_CBC_SHA_8           0x0090
+#define OP_PCL_TLS12_AES_128_CBC_SHA_9           0x0094
+#define OP_PCL_TLS12_AES_128_CBC_SHA_10          0xc004
+#define OP_PCL_TLS12_AES_128_CBC_SHA_11          0xc009
+#define OP_PCL_TLS12_AES_128_CBC_SHA_12          0xc00e
+#define OP_PCL_TLS12_AES_128_CBC_SHA_13          0xc013
+#define OP_PCL_TLS12_AES_128_CBC_SHA_14          0xc018
+#define OP_PCL_TLS12_AES_128_CBC_SHA_15          0xc01d
+#define OP_PCL_TLS12_AES_128_CBC_SHA_16          0xc01e
+#define OP_PCL_TLS12_AES_128_CBC_SHA_17          0xc01f
+
+#define OP_PCL_TLS12_AES_256_CBC_SHA             0x0035
+#define OP_PCL_TLS12_AES_256_CBC_SHA_2           0x0036
+#define OP_PCL_TLS12_AES_256_CBC_SHA_3           0x0037
+#define OP_PCL_TLS12_AES_256_CBC_SHA_4           0x0038
+#define OP_PCL_TLS12_AES_256_CBC_SHA_5           0x0039
+#define OP_PCL_TLS12_AES_256_CBC_SHA_6           0x003a
+#define OP_PCL_TLS12_AES_256_CBC_SHA_7           0x008d
+#define OP_PCL_TLS12_AES_256_CBC_SHA_8           0x0091
+#define OP_PCL_TLS12_AES_256_CBC_SHA_9           0x0095
+#define OP_PCL_TLS12_AES_256_CBC_SHA_10          0xc005
+#define OP_PCL_TLS12_AES_256_CBC_SHA_11          0xc00a
+#define OP_PCL_TLS12_AES_256_CBC_SHA_12          0xc00f
+#define OP_PCL_TLS12_AES_256_CBC_SHA_13          0xc014
+#define OP_PCL_TLS12_AES_256_CBC_SHA_14          0xc019
+#define OP_PCL_TLS12_AES_256_CBC_SHA_15          0xc020
+#define OP_PCL_TLS12_AES_256_CBC_SHA_16          0xc021
+#define OP_PCL_TLS12_AES_256_CBC_SHA_17          0xc022
+
+/* #define OP_PCL_TLS12_3DES_EDE_CBC_MD5            0x0023 */
+
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA            0x001f
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_2          0x008b
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_3          0x008f
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_4          0x0093
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_5          0x000a
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_6          0x000d
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_7          0x0010
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_8          0x0013
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_9          0x0016
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_10         0x001b
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_11         0xc003
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_12         0xc008
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_13         0xc00d
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_14         0xc012
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_15         0xc017
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_16         0xc01a
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_17         0xc01b
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA_18         0xc01c
+
+#define OP_PCL_TLS12_DES40_CBC_MD5               0x0029
+
+#define OP_PCL_TLS12_DES_CBC_MD5                 0x0022
+
+#define OP_PCL_TLS12_DES40_CBC_SHA               0x0008
+#define OP_PCL_TLS12_DES40_CBC_SHA_2             0x000b
+#define OP_PCL_TLS12_DES40_CBC_SHA_3             0x000e
+#define OP_PCL_TLS12_DES40_CBC_SHA_4             0x0011
+#define OP_PCL_TLS12_DES40_CBC_SHA_5             0x0014
+#define OP_PCL_TLS12_DES40_CBC_SHA_6             0x0019
+#define OP_PCL_TLS12_DES40_CBC_SHA_7             0x0026
+
+#define OP_PCL_TLS12_DES_CBC_SHA                 0x001e
+#define OP_PCL_TLS12_DES_CBC_SHA_2               0x0009
+#define OP_PCL_TLS12_DES_CBC_SHA_3               0x000c
+#define OP_PCL_TLS12_DES_CBC_SHA_4               0x000f
+#define OP_PCL_TLS12_DES_CBC_SHA_5               0x0012
+#define OP_PCL_TLS12_DES_CBC_SHA_6               0x0015
+#define OP_PCL_TLS12_DES_CBC_SHA_7               0x001a
+
+#define OP_PCL_TLS12_RC4_128_MD5                 0x0024
+#define OP_PCL_TLS12_RC4_128_MD5_2               0x0004
+#define OP_PCL_TLS12_RC4_128_MD5_3               0x0018
+
+#define OP_PCL_TLS12_RC4_40_MD5                  0x002b
+#define OP_PCL_TLS12_RC4_40_MD5_2                0x0003
+#define OP_PCL_TLS12_RC4_40_MD5_3                0x0017
+
+#define OP_PCL_TLS12_RC4_128_SHA                 0x0020
+#define OP_PCL_TLS12_RC4_128_SHA_2               0x008a
+#define OP_PCL_TLS12_RC4_128_SHA_3               0x008e
+#define OP_PCL_TLS12_RC4_128_SHA_4               0x0092
+#define OP_PCL_TLS12_RC4_128_SHA_5               0x0005
+#define OP_PCL_TLS12_RC4_128_SHA_6               0xc002
+#define OP_PCL_TLS12_RC4_128_SHA_7               0xc007
+#define OP_PCL_TLS12_RC4_128_SHA_8               0xc00c
+#define OP_PCL_TLS12_RC4_128_SHA_9               0xc011
+#define OP_PCL_TLS12_RC4_128_SHA_10              0xc016
+
+#define OP_PCL_TLS12_RC4_40_SHA                  0x0028
+
+/* #define OP_PCL_TLS12_AES_128_CBC_SHA256          0x003c */
+#define OP_PCL_TLS12_AES_128_CBC_SHA256_2        0x003e
+#define OP_PCL_TLS12_AES_128_CBC_SHA256_3        0x003f
+#define OP_PCL_TLS12_AES_128_CBC_SHA256_4        0x0040
+#define OP_PCL_TLS12_AES_128_CBC_SHA256_5        0x0067
+#define OP_PCL_TLS12_AES_128_CBC_SHA256_6        0x006c
+
+/* #define OP_PCL_TLS12_AES_256_CBC_SHA256          0x003d */
+#define OP_PCL_TLS12_AES_256_CBC_SHA256_2        0x0068
+#define OP_PCL_TLS12_AES_256_CBC_SHA256_3        0x0069
+#define OP_PCL_TLS12_AES_256_CBC_SHA256_4        0x006a
+#define OP_PCL_TLS12_AES_256_CBC_SHA256_5        0x006b
+#define OP_PCL_TLS12_AES_256_CBC_SHA256_6        0x006d
+
+/* AEAD_AES_xxx_CCM/GCM remain to be defined... */
+
+#define OP_PCL_TLS12_3DES_EDE_CBC_MD5            0xff23
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA160         0xff30
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA224         0xff34
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA256         0xff36
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA384         0xff33
+#define OP_PCL_TLS12_3DES_EDE_CBC_SHA512         0xff35
+#define OP_PCL_TLS12_AES_128_CBC_SHA160          0xff80
+#define OP_PCL_TLS12_AES_128_CBC_SHA224          0xff84
+#define OP_PCL_TLS12_AES_128_CBC_SHA256          0xff86
+#define OP_PCL_TLS12_AES_128_CBC_SHA384          0xff83
+#define OP_PCL_TLS12_AES_128_CBC_SHA512          0xff85
+#define OP_PCL_TLS12_AES_192_CBC_SHA160          0xff20
+#define OP_PCL_TLS12_AES_192_CBC_SHA224          0xff24
+#define OP_PCL_TLS12_AES_192_CBC_SHA256          0xff26
+#define OP_PCL_TLS12_AES_192_CBC_SHA384          0xff23
+#define OP_PCL_TLS12_AES_192_CBC_SHA512          0xff25
+#define OP_PCL_TLS12_AES_256_CBC_SHA160          0xff60
+#define OP_PCL_TLS12_AES_256_CBC_SHA224          0xff64
+#define OP_PCL_TLS12_AES_256_CBC_SHA256          0xff66
+#define OP_PCL_TLS12_AES_256_CBC_SHA384          0xff63
+#define OP_PCL_TLS12_AES_256_CBC_SHA512          0xff65
+
+/* For DTLS - OP_PCLID_DTLS */
+
+#define OP_PCL_DTLS_AES_128_CBC_SHA              0x002f
+#define OP_PCL_DTLS_AES_128_CBC_SHA_2            0x0030
+#define OP_PCL_DTLS_AES_128_CBC_SHA_3            0x0031
+#define OP_PCL_DTLS_AES_128_CBC_SHA_4            0x0032
+#define OP_PCL_DTLS_AES_128_CBC_SHA_5            0x0033
+#define OP_PCL_DTLS_AES_128_CBC_SHA_6            0x0034
+#define OP_PCL_DTLS_AES_128_CBC_SHA_7            0x008c
+#define OP_PCL_DTLS_AES_128_CBC_SHA_8            0x0090
+#define OP_PCL_DTLS_AES_128_CBC_SHA_9            0x0094
+#define OP_PCL_DTLS_AES_128_CBC_SHA_10           0xc004
+#define OP_PCL_DTLS_AES_128_CBC_SHA_11           0xc009
+#define OP_PCL_DTLS_AES_128_CBC_SHA_12           0xc00e
+#define OP_PCL_DTLS_AES_128_CBC_SHA_13           0xc013
+#define OP_PCL_DTLS_AES_128_CBC_SHA_14           0xc018
+#define OP_PCL_DTLS_AES_128_CBC_SHA_15           0xc01d
+#define OP_PCL_DTLS_AES_128_CBC_SHA_16           0xc01e
+#define OP_PCL_DTLS_AES_128_CBC_SHA_17           0xc01f
+
+#define OP_PCL_DTLS_AES_256_CBC_SHA              0x0035
+#define OP_PCL_DTLS_AES_256_CBC_SHA_2            0x0036
+#define OP_PCL_DTLS_AES_256_CBC_SHA_3            0x0037
+#define OP_PCL_DTLS_AES_256_CBC_SHA_4            0x0038
+#define OP_PCL_DTLS_AES_256_CBC_SHA_5            0x0039
+#define OP_PCL_DTLS_AES_256_CBC_SHA_6            0x003a
+#define OP_PCL_DTLS_AES_256_CBC_SHA_7            0x008d
+#define OP_PCL_DTLS_AES_256_CBC_SHA_8            0x0091
+#define OP_PCL_DTLS_AES_256_CBC_SHA_9            0x0095
+#define OP_PCL_DTLS_AES_256_CBC_SHA_10           0xc005
+#define OP_PCL_DTLS_AES_256_CBC_SHA_11           0xc00a
+#define OP_PCL_DTLS_AES_256_CBC_SHA_12           0xc00f
+#define OP_PCL_DTLS_AES_256_CBC_SHA_13           0xc014
+#define OP_PCL_DTLS_AES_256_CBC_SHA_14           0xc019
+#define OP_PCL_DTLS_AES_256_CBC_SHA_15           0xc020
+#define OP_PCL_DTLS_AES_256_CBC_SHA_16           0xc021
+#define OP_PCL_DTLS_AES_256_CBC_SHA_17           0xc022
+
+/* #define OP_PCL_DTLS_3DES_EDE_CBC_MD5             0x0023 */
+
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA             0x001f
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_2           0x008b
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_3           0x008f
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_4           0x0093
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_5           0x000a
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_6           0x000d
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_7           0x0010
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_8           0x0013
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_9           0x0016
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_10          0x001b
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_11          0xc003
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_12          0xc008
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_13          0xc00d
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_14          0xc012
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_15          0xc017
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_16          0xc01a
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_17          0xc01b
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA_18          0xc01c
+
+#define OP_PCL_DTLS_DES40_CBC_MD5                0x0029
+
+#define OP_PCL_DTLS_DES_CBC_MD5                  0x0022
+
+#define OP_PCL_DTLS_DES40_CBC_SHA                0x0008
+#define OP_PCL_DTLS_DES40_CBC_SHA_2              0x000b
+#define OP_PCL_DTLS_DES40_CBC_SHA_3              0x000e
+#define OP_PCL_DTLS_DES40_CBC_SHA_4              0x0011
+#define OP_PCL_DTLS_DES40_CBC_SHA_5              0x0014
+#define OP_PCL_DTLS_DES40_CBC_SHA_6              0x0019
+#define OP_PCL_DTLS_DES40_CBC_SHA_7              0x0026
+
+
+#define OP_PCL_DTLS_DES_CBC_SHA                  0x001e
+#define OP_PCL_DTLS_DES_CBC_SHA_2                0x0009
+#define OP_PCL_DTLS_DES_CBC_SHA_3                0x000c
+#define OP_PCL_DTLS_DES_CBC_SHA_4                0x000f
+#define OP_PCL_DTLS_DES_CBC_SHA_5                0x0012
+#define OP_PCL_DTLS_DES_CBC_SHA_6                0x0015
+#define OP_PCL_DTLS_DES_CBC_SHA_7                0x001a
+
+
+#define OP_PCL_DTLS_3DES_EDE_CBC_MD5             0xff23
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA160          0xff30
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA224          0xff34
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA256          0xff36
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA384          0xff33
+#define OP_PCL_DTLS_3DES_EDE_CBC_SHA512          0xff35
+#define OP_PCL_DTLS_AES_128_CBC_SHA160           0xff80
+#define OP_PCL_DTLS_AES_128_CBC_SHA224           0xff84
+#define OP_PCL_DTLS_AES_128_CBC_SHA256           0xff86
+#define OP_PCL_DTLS_AES_128_CBC_SHA384           0xff83
+#define OP_PCL_DTLS_AES_128_CBC_SHA512           0xff85
+#define OP_PCL_DTLS_AES_192_CBC_SHA160           0xff20
+#define OP_PCL_DTLS_AES_192_CBC_SHA224           0xff24
+#define OP_PCL_DTLS_AES_192_CBC_SHA256           0xff26
+#define OP_PCL_DTLS_AES_192_CBC_SHA384           0xff23
+#define OP_PCL_DTLS_AES_192_CBC_SHA512           0xff25
+#define OP_PCL_DTLS_AES_256_CBC_SHA160           0xff60
+#define OP_PCL_DTLS_AES_256_CBC_SHA224           0xff64
+#define OP_PCL_DTLS_AES_256_CBC_SHA256           0xff66
+#define OP_PCL_DTLS_AES_256_CBC_SHA384           0xff63
+#define OP_PCL_DTLS_AES_256_CBC_SHA512           0xff65
+
+/* 802.16 WiMAX protinfos */
+#define OP_PCL_WIMAX_OFDM                        0x0201
+#define OP_PCL_WIMAX_OFDMA                       0x0231
+
+/* 802.11 WiFi protinfos */
+#define OP_PCL_WIFI                              0xac04
+
+/* MacSec protinfos */
+#define OP_PCL_MACSEC                            0x0001
+
+/* PKI unidirectional protocol protinfo bits */
+#define OP_PCL_PKPROT_TEST                       0x0008
+#define OP_PCL_PKPROT_DECRYPT                    0x0004
+#define OP_PCL_PKPROT_ECC                        0x0002
+#define OP_PCL_PKPROT_F2M                        0x0001
+
+/* For non-protocol/alg-only op commands */
+#define OP_ALG_TYPE_SHIFT	24
+#define OP_ALG_TYPE_MASK	(0x7 << OP_ALG_TYPE_SHIFT)
+#define OP_ALG_TYPE_CLASS1	2
+#define OP_ALG_TYPE_CLASS2	4
+
+#define OP_ALG_ALGSEL_SHIFT	16
+#define OP_ALG_ALGSEL_MASK	(0xff << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SUBMASK	(0x0f << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_AES	(0x10 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_DES	(0x20 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_3DES	(0x21 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_ARC4	(0x30 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_MD5	(0x40 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SHA1	(0x41 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SHA224	(0x42 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SHA256	(0x43 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SHA384	(0x44 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SHA512	(0x45 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_RNG	(0x50 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SNOW	(0x60 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SNOW_F8	(0x60 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_KASUMI	(0x70 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_CRC	(0x90 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_SNOW_F9	(0xA0 << OP_ALG_ALGSEL_SHIFT)
+
+#define OP_ALG_AAI_SHIFT	4
+#define OP_ALG_AAI_MASK		(0x1ff << OP_ALG_AAI_SHIFT)
+
+/* blockcipher AAI set */
+#define OP_ALG_AAI_CTR_MOD128	(0x00 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD8	(0x01 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD16	(0x02 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD24	(0x03 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD32	(0x04 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD40	(0x05 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD48	(0x06 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD56	(0x07 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD64	(0x08 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD72	(0x09 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD80	(0x0a << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD88	(0x0b << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD96	(0x0c << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD104	(0x0d << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD112	(0x0e << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_MOD120	(0x0f << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CBC		(0x10 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_ECB		(0x20 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CFB		(0x30 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_OFB		(0x40 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_XTS		(0x50 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CMAC		(0x60 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_XCBC_MAC	(0x70 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CCM		(0x80 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_GCM		(0x90 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CBC_XCBCMAC	(0xa0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CTR_XCBCMAC	(0xb0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CHECKODD	(0x80 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_DK		(0x100 << OP_ALG_AAI_SHIFT)
+
+/* randomizer AAI set */
+#define OP_ALG_AAI_RNG		(0x00 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG_NOZERO	(0x10 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_RNG_ODD	(0x20 << OP_ALG_AAI_SHIFT)
+
+/* hmac/smac AAI set */
+#define OP_ALG_AAI_HASH		(0x00 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_HMAC		(0x01 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_SMAC		(0x02 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_HMAC_PRECOMP	(0x04 << OP_ALG_AAI_SHIFT)
+
+/* CRC AAI set*/
+#define OP_ALG_AAI_802		(0x01 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_3385		(0x02 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_CUST_POLY	(0x04 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_DIS		(0x10 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_DOS		(0x20 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_DOC		(0x40 << OP_ALG_AAI_SHIFT)
+
+/* Kasumi/SNOW AAI set */
+#define OP_ALG_AAI_F8		(0xc0 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_F9		(0xc8 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_GSM		(0x10 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_EDGE		(0x20 << OP_ALG_AAI_SHIFT)
+
+
+#define OP_ALG_AS_SHIFT		2
+#define OP_ALG_AS_MASK		(0x3 << OP_ALG_AS_SHIFT)
+#define OP_ALG_AS_UPDATE	(0 << OP_ALG_AS_SHIFT)
+#define OP_ALG_AS_INIT		(1 << OP_ALG_AS_SHIFT)
+#define OP_ALG_AS_FINALIZE	(2 << OP_ALG_AS_SHIFT)
+#define OP_ALG_AS_INITFINAL	(3 << OP_ALG_AS_SHIFT)
+
+#define OP_ALG_ICV_SHIFT	1
+#define OP_ALG_ICV_MASK		(1 << OP_ALG_ICV_SHIFT)
+#define OP_ALG_ICV_OFF		(0 << OP_ALG_ICV_SHIFT)
+#define OP_ALG_ICV_ON		(1 << OP_ALG_ICV_SHIFT)
+
+#define OP_ALG_DIR_SHIFT	0
+#define OP_ALG_DIR_MASK		1
+#define OP_ALG_DECRYPT		0
+#define OP_ALG_ENCRYPT		1
+
+/* PKHA algorithm type set */
+#define OP_ALG_PK                    0x00800000
+#define OP_ALG_PK_FUN_MASK           0x3f /* clrmem, modmath, or cpymem */
+
+/* PKHA mode clear memory functions */
+#define OP_ALG_PKMODE_A_RAM          0x80000
+#define OP_ALG_PKMODE_B_RAM          0x40000
+#define OP_ALG_PKMODE_E_RAM          0x20000
+#define OP_ALG_PKMODE_N_RAM          0x10000
+#define OP_ALG_PKMODE_CLEARMEM       0x00001
+
+/* PKHA mode modular-arithmetic functions */
+#define OP_ALG_PKMODE_MOD_IN_MONTY   0x80000
+#define OP_ALG_PKMODE_MOD_OUT_MONTY  0x40000
+#define OP_ALG_PKMODE_MOD_F2M        0x20000
+#define OP_ALG_PKMODE_MOD_R2_IN      0x10000
+#define OP_ALG_PKMODE_PRJECTV        0x00800
+#define OP_ALG_PKMODE_TIME_EQ        0x400
+#define OP_ALG_PKMODE_OUT_B          0x000
+#define OP_ALG_PKMODE_OUT_A          0x100
+#define OP_ALG_PKMODE_MOD_ADD        0x002
+#define OP_ALG_PKMODE_MOD_SUB_AB     0x003
+#define OP_ALG_PKMODE_MOD_SUB_BA     0x004
+#define OP_ALG_PKMODE_MOD_MULT       0x005
+#define OP_ALG_PKMODE_MOD_EXPO       0x006
+#define OP_ALG_PKMODE_MOD_REDUCT     0x007
+#define OP_ALG_PKMODE_MOD_INV        0x008
+#define OP_ALG_PKMODE_MOD_ECC_ADD    0x009
+#define OP_ALG_PKMODE_MOD_ECC_DBL    0x00a
+#define OP_ALG_PKMODE_MOD_ECC_MULT   0x00b
+#define OP_ALG_PKMODE_MOD_MONT_CNST  0x00c
+#define OP_ALG_PKMODE_MOD_CRT_CNST   0x00d
+#define OP_ALG_PKMODE_MOD_GCD        0x00e
+#define OP_ALG_PKMODE_MOD_PRIMALITY  0x00f
+
+/* PKHA mode copy-memory functions */
+#define OP_ALG_PKMODE_SRC_REG_SHIFT  13
+#define OP_ALG_PKMODE_SRC_REG_MASK   (7 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_SHIFT  10
+#define OP_ALG_PKMODE_DST_REG_MASK   (7 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_SHIFT  8
+#define OP_ALG_PKMODE_SRC_SEG_MASK   (3 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_SHIFT  6
+#define OP_ALG_PKMODE_DST_SEG_MASK   (3 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+
+#define OP_ALG_PKMODE_SRC_REG_A      (0 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_REG_B      (1 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_REG_N      (3 << OP_ALG_PKMODE_SRC_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_A      (0 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_B      (1 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_E      (2 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_DST_REG_N      (3 << OP_ALG_PKMODE_DST_REG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_0      (0 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_1      (1 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_2      (2 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_SRC_SEG_3      (3 << OP_ALG_PKMODE_SRC_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_0      (0 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_1      (1 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_2      (2 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_DST_SEG_3      (3 << OP_ALG_PKMODE_DST_SEG_SHIFT)
+#define OP_ALG_PKMODE_CPYMEM_N_SZ    0x80
+#define OP_ALG_PKMODE_CPYMEM_SRC_SZ  0x81
+
+/*
+ * SEQ_IN_PTR Command Constructs
+ */
+
+/* Release Buffers */
+#define SQIN_RBS               0x04000000
+
+/* Sequence pointer is really a descriptor */
+#define SQIN_INL               0x02000000
+
+/* Sequence pointer is a scatter-gather table */
+#define SQIN_SGF               0x01000000
+
+/* Appends to a previous pointer */
+#define SQIN_PRE               0x00800000
+
+/* Use extended length following pointer */
+#define SQIN_EXT               0x00400000
+
+/* Restore sequence with pointer/length */
+#define SQIN_RTO               0x00200000
+
+/* Replace job descriptor */
+#define SQIN_RJD               0x00100000
+
+#define SQIN_LEN_SHIFT           0
+#define SQIN_LEN_MASK           (0xffff << SQIN_LEN_SHIFT)
+
+/*
+ * SEQ_OUT_PTR Command Constructs
+ */
+
+/* Sequence pointer is a scatter-gather table */
+#define SQOUT_SGF              0x01000000
+
+/* Appends to a previous pointer */
+#define SQOUT_PRE              0x00800000
+
+/* Restore sequence with pointer/length */
+#define SQOUT_RTO              0x00200000
+
+/* Use extended length following pointer */
+#define SQOUT_EXT              0x00400000
+
+#define SQOUT_LEN_SHIFT           0
+#define SQOUT_LEN_MASK           (0xffff << SQOUT_LEN_SHIFT)
+
+
+/*
+ * SIGNATURE Command Constructs
+ */
+
+/* TYPE field is all that's relevant */
+#define SIGN_TYPE_SHIFT         16
+#define SIGN_TYPE_MASK          (0x0f << SIGN_TYPE_SHIFT)
+
+#define SIGN_TYPE_FINAL         (0x00 << SIGN_TYPE_SHIFT)
+#define SIGN_TYPE_FINAL_RESTORE (0x01 << SIGN_TYPE_SHIFT)
+#define SIGN_TYPE_FINAL_NONZERO (0x02 << SIGN_TYPE_SHIFT)
+#define SIGN_TYPE_IMM_2         (0x0a << SIGN_TYPE_SHIFT)
+#define SIGN_TYPE_IMM_3         (0x0b << SIGN_TYPE_SHIFT)
+#define SIGN_TYPE_IMM_4         (0x0c << SIGN_TYPE_SHIFT)
+
+/*
+ * MOVE Command Constructs
+ */
+
+#define MOVE_AUX_SHIFT          25
+#define MOVE_AUX_MASK           (3 << MOVE_AUX_SHIFT)
+#define MOVE_AUX_MS             (2 << MOVE_AUX_SHIFT)
+#define MOVE_AUX_LS             (1 << MOVE_AUX_SHIFT)
+
+#define MOVE_WAITCOMP_SHIFT     24
+#define MOVE_WAITCOMP_MASK      (1 << MOVE_WAITCOMP_SHIFT)
+#define MOVE_WAITCOMP           (1 << MOVE_WAITCOMP_SHIFT)
+
+#define MOVE_SRC_SHIFT          20
+#define MOVE_SRC_MASK           (0x0f << MOVE_SRC_SHIFT)
+#define MOVE_SRC_CLASS1CTX      (0x00 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_CLASS2CTX      (0x01 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_OUTFIFO        (0x02 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_DESCBUF        (0x03 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_MATH0          (0x04 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_MATH1          (0x05 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_MATH2          (0x06 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_MATH3          (0x07 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_INFIFO         (0x08 << MOVE_SRC_SHIFT)
+#define MOVE_SRC_INFIFO_CL      (0x09 << MOVE_SRC_SHIFT)
+
+#define MOVE_DEST_SHIFT         16
+#define MOVE_DEST_MASK          (0x0f << MOVE_DEST_SHIFT)
+#define MOVE_DEST_CLASS1CTX     (0x00 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_CLASS2CTX     (0x01 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_OUTFIFO       (0x02 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_DESCBUF       (0x03 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_MATH0         (0x04 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_MATH1         (0x05 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_MATH2         (0x06 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_MATH3         (0x07 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_CLASS1INFIFO  (0x08 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_CLASS2INFIFO  (0x09 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_PK_A          (0x0c << MOVE_DEST_SHIFT)
+#define MOVE_DEST_CLASS1KEY     (0x0d << MOVE_DEST_SHIFT)
+#define MOVE_DEST_CLASS2KEY     (0x0e << MOVE_DEST_SHIFT)
+
+#define MOVE_OFFSET_SHIFT       8
+#define MOVE_OFFSET_MASK        (0xff << MOVE_OFFSET_SHIFT)
+
+#define MOVE_LEN_SHIFT          0
+#define MOVE_LEN_MASK           (0xff << MOVE_LEN_SHIFT)
+
+#define MOVELEN_MRSEL_SHIFT     0
+#define MOVELEN_MRSEL_MASK      (0x3 << MOVE_LEN_SHIFT)
+
+/*
+ * MATH Command Constructs
+ */
+
+#define MATH_IFB_SHIFT          26
+#define MATH_IFB_MASK           (1 << MATH_IFB_SHIFT)
+#define MATH_IFB                (1 << MATH_IFB_SHIFT)
+
+#define MATH_NFU_SHIFT          25
+#define MATH_NFU_MASK           (1 << MATH_NFU_SHIFT)
+#define MATH_NFU                (1 << MATH_NFU_SHIFT)
+
+#define MATH_STL_SHIFT          24
+#define MATH_STL_MASK           (1 << MATH_STL_SHIFT)
+#define MATH_STL                (1 << MATH_STL_SHIFT)
+
+/* Function selectors */
+#define MATH_FUN_SHIFT          20
+#define MATH_FUN_MASK           (0x0f << MATH_FUN_SHIFT)
+#define MATH_FUN_ADD            (0x00 << MATH_FUN_SHIFT)
+#define MATH_FUN_ADDC           (0x01 << MATH_FUN_SHIFT)
+#define MATH_FUN_SUB            (0x02 << MATH_FUN_SHIFT)
+#define MATH_FUN_SUBB           (0x03 << MATH_FUN_SHIFT)
+#define MATH_FUN_OR             (0x04 << MATH_FUN_SHIFT)
+#define MATH_FUN_AND            (0x05 << MATH_FUN_SHIFT)
+#define MATH_FUN_XOR            (0x06 << MATH_FUN_SHIFT)
+#define MATH_FUN_LSHIFT         (0x07 << MATH_FUN_SHIFT)
+#define MATH_FUN_RSHIFT         (0x08 << MATH_FUN_SHIFT)
+#define MATH_FUN_SHLD           (0x09 << MATH_FUN_SHIFT)
+#define MATH_FUN_ZBYT           (0x0a << MATH_FUN_SHIFT)
+
+/* Source 0 selectors */
+#define MATH_SRC0_SHIFT         16
+#define MATH_SRC0_MASK          (0x0f << MATH_SRC0_SHIFT)
+#define MATH_SRC0_REG0          (0x00 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_REG1          (0x01 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_REG2          (0x02 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_REG3          (0x03 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_IMM           (0x04 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_SEQINLEN      (0x08 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_SEQOUTLEN     (0x09 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_VARSEQINLEN   (0x0a << MATH_SRC0_SHIFT)
+#define MATH_SRC0_VARSEQOUTLEN  (0x0b << MATH_SRC0_SHIFT)
+#define MATH_SRC0_ZERO          (0x0c << MATH_SRC0_SHIFT)
+
+/* Source 1 selectors */
+#define MATH_SRC1_SHIFT         12
+#define MATH_SRC1_MASK          (0x0f << MATH_SRC1_SHIFT)
+#define MATH_SRC1_REG0          (0x00 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_REG1          (0x01 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_REG2          (0x02 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_REG3          (0x03 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_IMM           (0x04 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_INFIFO        (0x0a << MATH_SRC1_SHIFT)
+#define MATH_SRC1_OUTFIFO       (0x0b << MATH_SRC1_SHIFT)
+#define MATH_SRC1_ONE           (0x0c << MATH_SRC1_SHIFT)
+
+/* Destination selectors */
+#define MATH_DEST_SHIFT         8
+#define MATH_DEST_MASK          (0x0f << MATH_DEST_SHIFT)
+#define MATH_DEST_REG0          (0x00 << MATH_DEST_SHIFT)
+#define MATH_DEST_REG1          (0x01 << MATH_DEST_SHIFT)
+#define MATH_DEST_REG2          (0x02 << MATH_DEST_SHIFT)
+#define MATH_DEST_REG3          (0x03 << MATH_DEST_SHIFT)
+#define MATH_DEST_SEQINLEN      (0x08 << MATH_DEST_SHIFT)
+#define MATH_DEST_SEQOUTLEN     (0x09 << MATH_DEST_SHIFT)
+#define MATH_DEST_VARSEQINLEN   (0x0a << MATH_DEST_SHIFT)
+#define MATH_DEST_VARSEQOUTLEN  (0x0b << MATH_DEST_SHIFT)
+#define MATH_DEST_NONE          (0x0f << MATH_DEST_SHIFT)
+
+/* Length selectors */
+#define MATH_LEN_SHIFT          0
+#define MATH_LEN_MASK           (0x0f << MATH_LEN_SHIFT)
+#define MATH_LEN_1BYTE          0x01
+#define MATH_LEN_2BYTE          0x02
+#define MATH_LEN_4BYTE          0x04
+#define MATH_LEN_8BYTE          0x08
+
+/*
+ * JUMP Command Constructs
+ */
+
+#define JUMP_CLASS_SHIFT        25
+#define JUMP_CLASS_MASK		(3 << JUMP_CLASS_SHIFT)
+#define JUMP_CLASS_NONE		0
+#define JUMP_CLASS_CLASS1	(1 << JUMP_CLASS_SHIFT)
+#define JUMP_CLASS_CLASS2	(2 << JUMP_CLASS_SHIFT)
+#define JUMP_CLASS_BOTH		(3 << JUMP_CLASS_SHIFT)
+
+#define JUMP_JSL_SHIFT          24
+#define JUMP_JSL_MASK           (1 << JUMP_JSL_SHIFT)
+#define JUMP_JSL                (1 << JUMP_JSL_SHIFT)
+
+#define JUMP_TYPE_SHIFT         22
+#define JUMP_TYPE_MASK          (0x03 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_LOCAL         (0x00 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_NONLOCAL      (0x01 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_HALT          (0x02 << JUMP_TYPE_SHIFT)
+#define JUMP_TYPE_HALT_USER     (0x03 << JUMP_TYPE_SHIFT)
+
+#define JUMP_TEST_SHIFT         16
+#define JUMP_TEST_MASK          (0x03 << JUMP_TEST_SHIFT)
+#define JUMP_TEST_ALL           (0x00 << JUMP_TEST_SHIFT)
+#define JUMP_TEST_INVALL        (0x01 << JUMP_TEST_SHIFT)
+#define JUMP_TEST_ANY           (0x02 << JUMP_TEST_SHIFT)
+#define JUMP_TEST_INVANY        (0x03 << JUMP_TEST_SHIFT)
+
+/* Condition codes. JSL bit is factored in */
+#define JUMP_COND_SHIFT         8
+#define JUMP_COND_MASK          (0x100ff << JUMP_COND_SHIFT)
+#define JUMP_COND_PK_0          (0x80 << JUMP_COND_SHIFT)
+#define JUMP_COND_PK_GCD_1      (0x40 << JUMP_COND_SHIFT)
+#define JUMP_COND_PK_PRIME      (0x20 << JUMP_COND_SHIFT)
+#define JUMP_COND_MATH_N        (0x08 << JUMP_COND_SHIFT)
+#define JUMP_COND_MATH_Z        (0x04 << JUMP_COND_SHIFT)
+#define JUMP_COND_MATH_C        (0x02 << JUMP_COND_SHIFT)
+#define JUMP_COND_MATH_NV       (0x01 << JUMP_COND_SHIFT)
+
+#define JUMP_COND_JRP           ((0x80 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_SHRD          ((0x40 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_SELF          ((0x20 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_CALM          ((0x10 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_NIP           ((0x08 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_NIFP          ((0x04 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_NOP           ((0x02 << JUMP_COND_SHIFT) | JUMP_JSL)
+#define JUMP_COND_NCP           ((0x01 << JUMP_COND_SHIFT) | JUMP_JSL)
+
+#define JUMP_OFFSET_SHIFT       0
+#define JUMP_OFFSET_MASK        (0xff << JUMP_OFFSET_SHIFT)
+
+/*
+ * NFIFO ENTRY
+ * Data Constructs
+ *
+ */
+#define NFIFOENTRY_DEST_SHIFT	30
+#define NFIFOENTRY_DEST_MASK	(3 << NFIFOENTRY_DEST_SHIFT)
+#define NFIFOENTRY_DEST_DECO	(0 << NFIFOENTRY_DEST_SHIFT)
+#define NFIFOENTRY_DEST_CLASS1	(1 << NFIFOENTRY_DEST_SHIFT)
+#define NFIFOENTRY_DEST_CLASS2	(2 << NFIFOENTRY_DEST_SHIFT)
+#define NFIFOENTRY_DEST_BOTH	(3 << NFIFOENTRY_DEST_SHIFT)
+
+#define NFIFOENTRY_LC2_SHIFT	29
+#define NFIFOENTRY_LC2_MASK		(1 << NFIFOENTRY_LC2_SHIFT)
+#define NFIFOENTRY_LC2			(1 << NFIFOENTRY_LC2_SHIFT)
+
+#define NFIFOENTRY_LC1_SHIFT	28
+#define NFIFOENTRY_LC1_MASK		(1 << NFIFOENTRY_LC1_SHIFT)
+#define NFIFOENTRY_LC1			(1 << NFIFOENTRY_LC1_SHIFT)
+
+#define NFIFOENTRY_FC2_SHIFT	27
+#define NFIFOENTRY_FC2_MASK		(1 << NFIFOENTRY_FC2_SHIFT)
+#define NFIFOENTRY_FC2			(1 << NFIFOENTRY_FC2_SHIFT)
+
+#define NFIFOENTRY_FC1_SHIFT	26
+#define NFIFOENTRY_FC1_MASK		(1 << NFIFOENTRY_FC1_SHIFT)
+#define NFIFOENTRY_FC1			(1 << NFIFOENTRY_FC1_SHIFT)
+
+#define NFIFOENTRY_STYPE_SHIFT	24
+#define NFIFOENTRY_STYPE_MASK	(3 << NFIFOENTRY_STYPE_SHIFT)
+#define NFIFOENTRY_STYPE_DFIFO	(0 << NFIFOENTRY_STYPE_SHIFT)
+#define NFIFOENTRY_STYPE_OFIFO	(1 << NFIFOENTRY_STYPE_SHIFT)
+#define NFIFOENTRY_STYPE_PAD	(2 << NFIFOENTRY_STYPE_SHIFT)
+#define NFIFOENTRY_STYPE_SNOOP	(3 << NFIFOENTRY_STYPE_SHIFT)
+
+#define NFIFOENTRY_DTYPE_SHIFT	20
+#define NFIFOENTRY_DTYPE_MASK	(0xF << NFIFOENTRY_DTYPE_SHIFT)
+
+#define NFIFOENTRY_DTYPE_SBOX      (0x0  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_AAD       (0x1  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_IV        (0x2  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_SAD       (0x3  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_ICV       (0xA  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_SKIP      (0xE  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_MSG       (0xF  << NFIFOENTRY_DTYPE_SHIFT)
+
+#define NFIFOENTRY_DTYPE_PK_A0     (0x0  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_A1     (0x1  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_A2     (0x2  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_A3     (0x3  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_B0     (0x4  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_B1     (0x5  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_B2     (0x6  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_B3     (0x7  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_N      (0x8  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_E      (0x9  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_A      (0xC  << NFIFOENTRY_DTYPE_SHIFT)
+#define NFIFOENTRY_DTYPE_PK_B      (0xD  << NFIFOENTRY_DTYPE_SHIFT)
+
+
+#define NFIFOENTRY_BND_SHIFT	19
+#define NFIFOENTRY_BND_MASK		(1 << NFIFOENTRY_BND_SHIFT)
+#define NFIFOENTRY_BND			(1 << NFIFOENTRY_BND_SHIFT)
+
+#define NFIFOENTRY_PTYPE_SHIFT	16
+#define NFIFOENTRY_PTYPE_MASK	(0x7 << NFIFOENTRY_PTYPE_SHIFT)
+
+#define NFIFOENTRY_PTYPE_ZEROS         (0x0  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_RND_NOZEROS   (0x1  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_INCREMENT     (0x2  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_RND           (0x3  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_ZEROS_NZ      (0x4  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_RND_NZ_LZ     (0x5  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_N             (0x6  << NFIFOENTRY_PTYPE_SHIFT)
+#define NFIFOENTRY_PTYPE_RND_NZ_N      (0x7  << NFIFOENTRY_PTYPE_SHIFT)
+
+#define NFIFOENTRY_OC_SHIFT		15
+#define NFIFOENTRY_OC_MASK		(1 << NFIFOENTRY_OC_SHIFT)
+#define NFIFOENTRY_OC			(1 << NFIFOENTRY_OC_SHIFT)
+
+#define NFIFOENTRY_AST_SHIFT	14
+#define NFIFOENTRY_AST_MASK		(1 << NFIFOENTRY_OC_SHIFT)
+#define NFIFOENTRY_AST			(1 << NFIFOENTRY_OC_SHIFT)
+
+#define NFIFOENTRY_BM_SHIFT		11
+#define NFIFOENTRY_BM_MASK		(1 << NFIFOENTRY_BM_SHIFT)
+#define NFIFOENTRY_BM			(1 << NFIFOENTRY_BM_SHIFT)
+
+#define NFIFOENTRY_PS_SHIFT		10
+#define NFIFOENTRY_PS_MASK		(1 << NFIFOENTRY_PS_SHIFT)
+#define NFIFOENTRY_PS			(1 << NFIFOENTRY_PS_SHIFT)
+
+
+#define NFIFOENTRY_DLEN_SHIFT	0
+#define NFIFOENTRY_DLEN_MASK	(0xFFF << NFIFOENTRY_DLEN_SHIFT)
+
+#define NFIFOENTRY_PLEN_SHIFT	0
+#define NFIFOENTRY_PLEN_MASK	(0xFF << NFIFOENTRY_PLEN_SHIFT)
+
+/*
+ * PDB internal definitions
+ */
+
+/* IPSec ESP CBC Encap/Decap Options */
+#define PDBOPTS_ESPCBC_ARSNONE  0x00   /* no antireplay window              */
+#define PDBOPTS_ESPCBC_ARS32    0x40   /* 32-entry antireplay window        */
+#define PDBOPTS_ESPCBC_ARS64    0xc0   /* 64-entry antireplay window        */
+#define PDBOPTS_ESPCBC_IVSRC    0x20   /* IV comes from internal random gen */
+#define PDBOPTS_ESPCBC_ESN      0x10   /* extended sequence included        */
+#define PDBOPTS_ESPCBC_OUTFMT   0x08   /* output only decapsulation (decap) */
+#define PDBOPTS_ESPCBC_IPHDRSRC 0x08   /* IP header comes from PDB (encap)  */
+#define PDBOPTS_ESPCBC_INCIPHDR 0x04   /* Prepend IP header to output frame */
+#define PDBOPTS_ESPCBC_IPVSN    0x02   /* process IPv6 header               */
+#define PDBOPTS_ESPCBC_TUNNEL   0x01   /* tunnel mode next-header byte      */
+
+#endif /* DESC_H */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
new file mode 100644
index 0000000..d063a26
--- /dev/null
+++ b/drivers/crypto/caam/regs.h
@@ -0,0 +1,663 @@
+/*
+ * CAAM hardware register-level view
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ */
+
+#ifndef REGS_H
+#define REGS_H
+
+#include <linux/types.h>
+#include <linux/io.h>
+
+/*
+ * Architecture-specific register access methods
+ *
+ * CAAM's bus-addressable registers are 64 bits internally.
+ * They have been wired to be safely accessible on 32-bit
+ * architectures, however. Registers were organized such
+ * that (a) they can be contained in 32 bits, (b) if not, then they
+ * can be treated as two 32-bit entities, or finally (c) if they
+ * must be treated as a single 64-bit value, then this can safely
+ * be done with two 32-bit cycles.
+ *
+ * For 32-bit operations on 64-bit values, CAAM follows the same
+ * 64-bit register access conventions as it's predecessors, in that
+ * writes are "triggered" by a write to the register at the numerically
+ * higher address, thus, a full 64-bit write cycle requires a write
+ * to the lower address, followed by a write to the higher address,
+ * which will latch/execute the write cycle.
+ *
+ * For example, let's assume a SW reset of CAAM through the master
+ * configuration register.
+ * - SWRST is in bit 31 of MCFG.
+ * - MCFG begins at base+0x0000.
+ * - Bits 63-32 are a 32-bit word at base+0x0000 (numerically-lower)
+ * - Bits 31-0 are a 32-bit word at base+0x0004 (numerically-higher)
+ *
+ * (and on Power, the convention is 0-31, 32-63, I know...)
+ *
+ * Assuming a 64-bit write to this MCFG to perform a software reset
+ * would then require a write of 0 to base+0x0000, followed by a
+ * write of 0x80000000 to base+0x0004, which would "execute" the
+ * reset.
+ *
+ * Of course, since MCFG 63-32 is all zero, we could cheat and simply
+ * write 0x8000000 to base+0x0004, and the reset would work fine.
+ * However, since CAAM does contain some write-and-read-intended
+ * 64-bit registers, this code defines 64-bit access methods for
+ * the sake of internal consistency and simplicity, and so that a
+ * clean transition to 64-bit is possible when it becomes necessary.
+ *
+ * There are limitations to this that the developer must recognize.
+ * 32-bit architectures cannot enforce an atomic-64 operation,
+ * Therefore:
+ *
+ * - On writes, since the HW is assumed to latch the cycle on the
+ *   write of the higher-numeric-address word, then ordered
+ *   writes work OK.
+ *
+ * - For reads, where a register contains a relevant value of more
+ *   that 32 bits, the hardware employs logic to latch the other
+ *   "half" of the data until read, ensuring an accurate value.
+ *   This is of particular relevance when dealing with CAAM's
+ *   performance counters.
+ *
+ */
+
+#ifdef __BIG_ENDIAN
+#define wr_reg32(reg, data) out_be32(reg, data)
+#define rd_reg32(reg) in_be32(reg)
+#ifdef CONFIG_64BIT
+#define wr_reg64(reg, data) out_be64(reg, data)
+#define rd_reg64(reg) in_be64(reg)
+#endif
+#else
+#ifdef __LITTLE_ENDIAN
+#define wr_reg32(reg, data) __raw_writel(reg, data)
+#define rd_reg32(reg) __raw_readl(reg)
+#ifdef CONFIG_64BIT
+#define wr_reg64(reg, data) __raw_writeq(reg, data)
+#define rd_reg64(reg) __raw_readq(reg)
+#endif
+#endif
+#endif
+
+#ifndef CONFIG_64BIT
+static inline void wr_reg64(u64 __iomem *reg, u64 data)
+{
+	wr_reg32((u32 __iomem *)reg, (data & 0xffffffff00000000ull) >> 32);
+	wr_reg32((u32 __iomem *)reg + 1, data & 0x00000000ffffffffull);
+}
+
+static inline u64 rd_reg64(u64 __iomem *reg)
+{
+	return (((u64)rd_reg32((u32 __iomem *)reg)) << 32) |
+		((u64)rd_reg32((u32 __iomem *)reg + 1));
+}
+#endif
+
+/*
+ * jr_outentry
+ * Represents each entry in a JobR output ring
+ */
+struct jr_outentry {
+	dma_addr_t desc;/* Pointer to completed descriptor */
+	u32 jrstatus;	/* Status for completed descriptor */
+} __packed;
+
+/*
+ * caam_perfmon - Performance Monitor/Secure Memory Status/
+ *                CAAM Global Status/Component Version IDs
+ *
+ * Spans f00-fff wherever instantiated
+ */
+
+/* Number of DECOs */
+#define CHA_NUM_DECONUM_SHIFT	56
+#define CHA_NUM_DECONUM_MASK	(0xfull << CHA_NUM_DECONUM_SHIFT)
+
+struct caam_perfmon {
+	/* Performance Monitor Registers			f00-f9f */
+	u64 req_dequeued;	/* PC_REQ_DEQ - Dequeued Requests	     */
+	u64 ob_enc_req;	/* PC_OB_ENC_REQ - Outbound Encrypt Requests */
+	u64 ib_dec_req;	/* PC_IB_DEC_REQ - Inbound Decrypt Requests  */
+	u64 ob_enc_bytes;	/* PC_OB_ENCRYPT - Outbound Bytes Encrypted  */
+	u64 ob_prot_bytes;	/* PC_OB_PROTECT - Outbound Bytes Protected  */
+	u64 ib_dec_bytes;	/* PC_IB_DECRYPT - Inbound Bytes Decrypted   */
+	u64 ib_valid_bytes;	/* PC_IB_VALIDATED Inbound Bytes Validated   */
+	u64 rsvd[13];
+
+	/* CAAM Hardware Instantiation Parameters		fa0-fbf */
+	u64 cha_rev;		/* CRNR - CHA Revision Number		*/
+#define CTPR_QI_SHIFT		57
+#define CTPR_QI_MASK		(0x1ull << CHA_NUM_DECONUM_SHIFT)
+	u64 comp_parms;	/* CTPR - Compile Parameters Register	*/
+	u64 rsvd1[2];
+
+	/* CAAM Global Status					fc0-fdf */
+	u64 faultaddr;	/* FAR  - Fault Address		*/
+	u32 faultliodn;	/* FALR - Fault Address LIODN	*/
+	u32 faultdetail;	/* FADR - Fault Addr Detail	*/
+	u32 rsvd2;
+	u32 status;		/* CSTA - CAAM Status */
+	u64 rsvd3;
+
+	/* Component Instantiation Parameters			fe0-fff */
+	u32 rtic_id;		/* RVID - RTIC Version ID	*/
+	u32 ccb_id;		/* CCBVID - CCB Version ID	*/
+	u64 cha_id;		/* CHAVID - CHA Version ID	*/
+	u64 cha_num;		/* CHANUM - CHA Number		*/
+	u64 caam_id;		/* CAAMVID - CAAM Version ID	*/
+};
+
+/* LIODN programming for DMA configuration */
+#define MSTRID_LOCK_LIODN	0x80000000
+#define MSTRID_LOCK_MAKETRUSTED	0x00010000	/* only for JR masterid */
+
+#define MSTRID_LIODN_MASK	0x0fff
+struct masterid {
+	u32 liodn_ms;	/* lock and make-trusted control bits */
+	u32 liodn_ls;	/* LIODN for non-sequence and seq access */
+};
+
+/* Partition ID for DMA configuration */
+struct partid {
+	u32 rsvd1;
+	u32 pidr;	/* partition ID, DECO */
+};
+
+/* RNG test mode (replicated twice in some configurations) */
+/* Padded out to 0x100 */
+struct rngtst {
+	u32 mode;		/* RTSTMODEx - Test mode */
+	u32 rsvd1[3];
+	u32 reset;		/* RTSTRESETx - Test reset control */
+	u32 rsvd2[3];
+	u32 status;		/* RTSTSSTATUSx - Test status */
+	u32 rsvd3;
+	u32 errstat;		/* RTSTERRSTATx - Test error status */
+	u32 rsvd4;
+	u32 errctl;		/* RTSTERRCTLx - Test error control */
+	u32 rsvd5;
+	u32 entropy;		/* RTSTENTROPYx - Test entropy */
+	u32 rsvd6[15];
+	u32 verifctl;	/* RTSTVERIFCTLx - Test verification control */
+	u32 rsvd7;
+	u32 verifstat;	/* RTSTVERIFSTATx - Test verification status */
+	u32 rsvd8;
+	u32 verifdata;	/* RTSTVERIFDx - Test verification data */
+	u32 rsvd9;
+	u32 xkey;		/* RTSTXKEYx - Test XKEY */
+	u32 rsvd10;
+	u32 oscctctl;	/* RTSTOSCCTCTLx - Test osc. counter control */
+	u32 rsvd11;
+	u32 oscct;		/* RTSTOSCCTx - Test oscillator counter */
+	u32 rsvd12;
+	u32 oscctstat;	/* RTSTODCCTSTATx - Test osc counter status */
+	u32 rsvd13[2];
+	u32 ofifo[4];	/* RTSTOFIFOx - Test output FIFO */
+	u32 rsvd14[15];
+};
+
+/*
+ * caam_ctrl - basic core configuration
+ * starts base + 0x0000 padded out to 0x1000
+ */
+
+#define KEK_KEY_SIZE		8
+#define TKEK_KEY_SIZE		8
+#define TDSK_KEY_SIZE		8
+
+#define DECO_RESET	1	/* Use with DECO reset/availability regs */
+#define DECO_RESET_0	(DECO_RESET << 0)
+#define DECO_RESET_1	(DECO_RESET << 1)
+#define DECO_RESET_2	(DECO_RESET << 2)
+#define DECO_RESET_3	(DECO_RESET << 3)
+#define DECO_RESET_4	(DECO_RESET << 4)
+
+struct caam_ctrl {
+	/* Basic Configuration Section				000-01f */
+	/* Read/Writable					        */
+	u32 rsvd1;
+	u32 mcr;		/* MCFG      Master Config Register  */
+	u32 rsvd2[2];
+
+	/* Bus Access Configuration Section			010-11f */
+	/* Read/Writable                                                */
+	struct masterid jr_mid[4];	/* JRxLIODNR - JobR LIODN setup */
+	u32 rsvd3[12];
+	struct masterid rtic_mid[4];	/* RTICxLIODNR - RTIC LIODN setup */
+	u32 rsvd4[7];
+	u32 deco_rq;			/* DECORR - DECO Request */
+	struct partid deco_mid[5];	/* DECOxLIODNR - 1 per DECO */
+	u32 rsvd5[22];
+
+	/* DECO Availability/Reset Section			120-3ff */
+	u32 deco_avail;		/* DAR - DECO availability */
+	u32 deco_reset;		/* DRR - DECO reset */
+	u32 rsvd6[182];
+
+	/* Key Encryption/Decryption Configuration              400-5ff */
+	/* Read/Writable only while in Non-secure mode                  */
+	u32 kek[KEK_KEY_SIZE];	/* JDKEKR - Key Encryption Key */
+	u32 tkek[TKEK_KEY_SIZE];	/* TDKEKR - Trusted Desc KEK */
+	u32 tdsk[TDSK_KEY_SIZE];	/* TDSKR - Trusted Desc Signing Key */
+	u32 rsvd7[32];
+	u64 sknonce;			/* SKNR - Secure Key Nonce */
+	u32 rsvd8[70];
+
+	/* RNG Test/Verification/Debug Access                   600-7ff */
+	/* (Useful in Test/Debug modes only...)                         */
+	struct rngtst rtst[2];
+
+	u32 rsvd9[448];
+
+	/* Performance Monitor                                  f00-fff */
+	struct caam_perfmon perfmon;
+};
+
+/*
+ * Controller master config register defs
+ */
+#define MCFGR_SWRESET		0x80000000 /* software reset */
+#define MCFGR_WDENABLE		0x40000000 /* DECO watchdog enable */
+#define MCFGR_WDFAIL		0x20000000 /* DECO watchdog force-fail */
+#define MCFGR_DMA_RESET		0x10000000
+#define MCFGR_LONG_PTR		0x00010000 /* Use >32-bit desc addressing */
+
+/* AXI read cache control */
+#define MCFGR_ARCACHE_SHIFT	12
+#define MCFGR_ARCACHE_MASK	(0xf << MCFGR_ARCACHE_SHIFT)
+
+/* AXI write cache control */
+#define MCFGR_AWCACHE_SHIFT	8
+#define MCFGR_AWCACHE_MASK	(0xf << MCFGR_AWCACHE_SHIFT)
+
+/* AXI pipeline depth */
+#define MCFGR_AXIPIPE_SHIFT	4
+#define MCFGR_AXIPIPE_MASK	(0xf << MCFGR_AXIPIPE_SHIFT)
+
+#define MCFGR_AXIPRI		0x00000008 /* Assert AXI priority sideband */
+#define MCFGR_BURST_64		0x00000001 /* Max burst size */
+
+/*
+ * caam_job_ring - direct job ring setup
+ * 1-4 possible per instantiation, base + 1000/2000/3000/4000
+ * Padded out to 0x1000
+ */
+struct caam_job_ring {
+	/* Input ring */
+	u64 inpring_base;	/* IRBAx -  Input desc ring baseaddr */
+	u32 rsvd1;
+	u32 inpring_size;	/* IRSx - Input ring size */
+	u32 rsvd2;
+	u32 inpring_avail;	/* IRSAx - Input ring room remaining */
+	u32 rsvd3;
+	u32 inpring_jobadd;	/* IRJAx - Input ring jobs added */
+
+	/* Output Ring */
+	u64 outring_base;	/* ORBAx - Output status ring base addr */
+	u32 rsvd4;
+	u32 outring_size;	/* ORSx - Output ring size */
+	u32 rsvd5;
+	u32 outring_rmvd;	/* ORJRx - Output ring jobs removed */
+	u32 rsvd6;
+	u32 outring_used;	/* ORSFx - Output ring slots full */
+
+	/* Status/Configuration */
+	u32 rsvd7;
+	u32 jroutstatus;	/* JRSTAx - JobR output status */
+	u32 rsvd8;
+	u32 jrintstatus;	/* JRINTx - JobR interrupt status */
+	u32 rconfig_hi;	/* JRxCFG - Ring configuration */
+	u32 rconfig_lo;
+
+	/* Indices. CAAM maintains as "heads" of each queue */
+	u32 rsvd9;
+	u32 inp_rdidx;	/* IRRIx - Input ring read index */
+	u32 rsvd10;
+	u32 out_wtidx;	/* ORWIx - Output ring write index */
+
+	/* Command/control */
+	u32 rsvd11;
+	u32 jrcommand;	/* JRCRx - JobR command */
+
+	u32 rsvd12[932];
+
+	/* Performance Monitor                                  f00-fff */
+	struct caam_perfmon perfmon;
+};
+
+#define JR_RINGSIZE_MASK	0x03ff
+/*
+ * jrstatus - Job Ring Output Status
+ * All values in lo word
+ * Also note, same values written out as status through QI
+ * in the command/status field of a frame descriptor
+ */
+#define JRSTA_SSRC_SHIFT            28
+#define JRSTA_SSRC_MASK             0xf0000000
+
+#define JRSTA_SSRC_NONE             0x00000000
+#define JRSTA_SSRC_CCB_ERROR        0x20000000
+#define JRSTA_SSRC_JUMP_HALT_USER   0x30000000
+#define JRSTA_SSRC_DECO             0x40000000
+#define JRSTA_SSRC_JRERROR          0x60000000
+#define JRSTA_SSRC_JUMP_HALT_CC     0x70000000
+
+#define JRSTA_DECOERR_JUMP          0x08000000
+#define JRSTA_DECOERR_INDEX_SHIFT   8
+#define JRSTA_DECOERR_INDEX_MASK    0xff00
+#define JRSTA_DECOERR_ERROR_MASK    0x00ff
+
+#define JRSTA_DECOERR_NONE          0x00
+#define JRSTA_DECOERR_LINKLEN       0x01
+#define JRSTA_DECOERR_LINKPTR       0x02
+#define JRSTA_DECOERR_JRCTRL        0x03
+#define JRSTA_DECOERR_DESCCMD       0x04
+#define JRSTA_DECOERR_ORDER         0x05
+#define JRSTA_DECOERR_KEYCMD        0x06
+#define JRSTA_DECOERR_LOADCMD       0x07
+#define JRSTA_DECOERR_STORECMD      0x08
+#define JRSTA_DECOERR_OPCMD         0x09
+#define JRSTA_DECOERR_FIFOLDCMD     0x0a
+#define JRSTA_DECOERR_FIFOSTCMD     0x0b
+#define JRSTA_DECOERR_MOVECMD       0x0c
+#define JRSTA_DECOERR_JUMPCMD       0x0d
+#define JRSTA_DECOERR_MATHCMD       0x0e
+#define JRSTA_DECOERR_SHASHCMD      0x0f
+#define JRSTA_DECOERR_SEQCMD        0x10
+#define JRSTA_DECOERR_DECOINTERNAL  0x11
+#define JRSTA_DECOERR_SHDESCHDR     0x12
+#define JRSTA_DECOERR_HDRLEN        0x13
+#define JRSTA_DECOERR_BURSTER       0x14
+#define JRSTA_DECOERR_DESCSIGNATURE 0x15
+#define JRSTA_DECOERR_DMA           0x16
+#define JRSTA_DECOERR_BURSTFIFO     0x17
+#define JRSTA_DECOERR_JRRESET       0x1a
+#define JRSTA_DECOERR_JOBFAIL       0x1b
+#define JRSTA_DECOERR_DNRERR        0x80
+#define JRSTA_DECOERR_UNDEFPCL      0x81
+#define JRSTA_DECOERR_PDBERR        0x82
+#define JRSTA_DECOERR_ANRPLY_LATE   0x83
+#define JRSTA_DECOERR_ANRPLY_REPLAY 0x84
+#define JRSTA_DECOERR_SEQOVF        0x85
+#define JRSTA_DECOERR_INVSIGN       0x86
+#define JRSTA_DECOERR_DSASIGN       0x87
+
+#define JRSTA_CCBERR_JUMP           0x08000000
+#define JRSTA_CCBERR_INDEX_MASK     0xff00
+#define JRSTA_CCBERR_INDEX_SHIFT    8
+#define JRSTA_CCBERR_CHAID_MASK     0x00f0
+#define JRSTA_CCBERR_CHAID_SHIFT    4
+#define JRSTA_CCBERR_ERRID_MASK     0x000f
+
+#define JRSTA_CCBERR_CHAID_AES      (0x01 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_DES      (0x02 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_ARC4     (0x03 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_MD       (0x04 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_RNG      (0x05 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_SNOW     (0x06 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_KASUMI   (0x07 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_PK       (0x08 << JRSTA_CCBERR_CHAID_SHIFT)
+#define JRSTA_CCBERR_CHAID_CRC      (0x09 << JRSTA_CCBERR_CHAID_SHIFT)
+
+#define JRSTA_CCBERR_ERRID_NONE     0x00
+#define JRSTA_CCBERR_ERRID_MODE     0x01
+#define JRSTA_CCBERR_ERRID_DATASIZ  0x02
+#define JRSTA_CCBERR_ERRID_KEYSIZ   0x03
+#define JRSTA_CCBERR_ERRID_PKAMEMSZ 0x04
+#define JRSTA_CCBERR_ERRID_PKBMEMSZ 0x05
+#define JRSTA_CCBERR_ERRID_SEQUENCE 0x06
+#define JRSTA_CCBERR_ERRID_PKDIVZRO 0x07
+#define JRSTA_CCBERR_ERRID_PKMODEVN 0x08
+#define JRSTA_CCBERR_ERRID_KEYPARIT 0x09
+#define JRSTA_CCBERR_ERRID_ICVCHK   0x0a
+#define JRSTA_CCBERR_ERRID_HARDWARE 0x0b
+#define JRSTA_CCBERR_ERRID_CCMAAD   0x0c
+#define JRSTA_CCBERR_ERRID_INVCHA   0x0f
+
+#define JRINT_ERR_INDEX_MASK        0x3fff0000
+#define JRINT_ERR_INDEX_SHIFT       16
+#define JRINT_ERR_TYPE_MASK         0xf00
+#define JRINT_ERR_TYPE_SHIFT        8
+#define JRINT_ERR_HALT_MASK         0xc
+#define JRINT_ERR_HALT_SHIFT        2
+#define JRINT_ERR_HALT_INPROGRESS   0x4
+#define JRINT_ERR_HALT_COMPLETE     0x8
+#define JRINT_JR_ERROR              0x02
+#define JRINT_JR_INT                0x01
+
+#define JRINT_ERR_TYPE_WRITE        1
+#define JRINT_ERR_TYPE_BAD_INPADDR  3
+#define JRINT_ERR_TYPE_BAD_OUTADDR  4
+#define JRINT_ERR_TYPE_INV_INPWRT   5
+#define JRINT_ERR_TYPE_INV_OUTWRT   6
+#define JRINT_ERR_TYPE_RESET        7
+#define JRINT_ERR_TYPE_REMOVE_OFL   8
+#define JRINT_ERR_TYPE_ADD_OFL      9
+
+#define JRCFG_SOE		0x04
+#define JRCFG_ICEN		0x02
+#define JRCFG_IMSK		0x01
+#define JRCFG_ICDCT_SHIFT	8
+#define JRCFG_ICTT_SHIFT	16
+
+#define JRCR_RESET                  0x01
+
+/*
+ * caam_assurance - Assurance Controller View
+ * base + 0x6000 padded out to 0x1000
+ */
+
+struct rtic_element {
+	u64 address;
+	u32 rsvd;
+	u32 length;
+};
+
+struct rtic_block {
+	struct rtic_element element[2];
+};
+
+struct rtic_memhash {
+	u32 memhash_be[32];
+	u32 memhash_le[32];
+};
+
+struct caam_assurance {
+    /* Status/Command/Watchdog */
+	u32 rsvd1;
+	u32 status;		/* RSTA - Status */
+	u32 rsvd2;
+	u32 cmd;		/* RCMD - Command */
+	u32 rsvd3;
+	u32 ctrl;		/* RCTL - Control */
+	u32 rsvd4;
+	u32 throttle;	/* RTHR - Throttle */
+	u32 rsvd5[2];
+	u64 watchdog;	/* RWDOG - Watchdog Timer */
+	u32 rsvd6;
+	u32 rend;		/* REND - Endian corrections */
+	u32 rsvd7[50];
+
+	/* Block access/configuration @ 100/110/120/130 */
+	struct rtic_block memblk[4];	/* Memory Blocks A-D */
+	u32 rsvd8[32];
+
+	/* Block hashes @ 200/300/400/500 */
+	struct rtic_memhash hash[4];	/* Block hash values A-D */
+	u32 rsvd_3[640];
+};
+
+/*
+ * caam_queue_if - QI configuration and control
+ * starts base + 0x7000, padded out to 0x1000 long
+ */
+
+struct caam_queue_if {
+	u32 qi_control_hi;	/* QICTL  - QI Control */
+	u32 qi_control_lo;
+	u32 rsvd1;
+	u32 qi_status;	/* QISTA  - QI Status */
+	u32 qi_deq_cfg_hi;	/* QIDQC  - QI Dequeue Configuration */
+	u32 qi_deq_cfg_lo;
+	u32 qi_enq_cfg_hi;	/* QISEQC - QI Enqueue Command     */
+	u32 qi_enq_cfg_lo;
+	u32 rsvd2[1016];
+};
+
+/* QI control bits - low word */
+#define QICTL_DQEN      0x01              /* Enable frame pop          */
+#define QICTL_STOP      0x02              /* Stop dequeue/enqueue      */
+#define QICTL_SOE       0x04              /* Stop on error             */
+
+/* QI control bits - high word */
+#define QICTL_MBSI	0x01
+#define QICTL_MHWSI	0x02
+#define QICTL_MWSI	0x04
+#define QICTL_MDWSI	0x08
+#define QICTL_CBSI	0x10		/* CtrlDataByteSwapInput     */
+#define QICTL_CHWSI	0x20		/* CtrlDataHalfSwapInput     */
+#define QICTL_CWSI	0x40		/* CtrlDataWordSwapInput     */
+#define QICTL_CDWSI	0x80		/* CtrlDataDWordSwapInput    */
+#define QICTL_MBSO	0x0100
+#define QICTL_MHWSO	0x0200
+#define QICTL_MWSO	0x0400
+#define QICTL_MDWSO	0x0800
+#define QICTL_CBSO	0x1000		/* CtrlDataByteSwapOutput    */
+#define QICTL_CHWSO	0x2000		/* CtrlDataHalfSwapOutput    */
+#define QICTL_CWSO	0x4000		/* CtrlDataWordSwapOutput    */
+#define QICTL_CDWSO     0x8000		/* CtrlDataDWordSwapOutput   */
+#define QICTL_DMBS	0x010000
+#define QICTL_EPO	0x020000
+
+/* QI status bits */
+#define QISTA_PHRDERR   0x01              /* PreHeader Read Error      */
+#define QISTA_CFRDERR   0x02              /* Compound Frame Read Error */
+#define QISTA_OFWRERR   0x04              /* Output Frame Read Error   */
+#define QISTA_BPDERR    0x08              /* Buffer Pool Depleted      */
+#define QISTA_BTSERR    0x10              /* Buffer Undersize          */
+#define QISTA_CFWRERR   0x20              /* Compound Frame Write Err  */
+#define QISTA_STOPD     0x80000000        /* QI Stopped (see QICTL)    */
+
+/* deco_sg_table - DECO view of scatter/gather table */
+struct deco_sg_table {
+	u64 addr;		/* Segment Address */
+	u32 elen;		/* E, F bits + 30-bit length */
+	u32 bpid_offset;	/* Buffer Pool ID + 16-bit length */
+};
+
+/*
+ * caam_deco - descriptor controller - CHA cluster block
+ *
+ * Only accessible when direct DECO access is turned on
+ * (done in DECORR, via MID programmed in DECOxMID
+ *
+ * 5 typical, base + 0x8000/9000/a000/b000
+ * Padded out to 0x1000 long
+ */
+struct caam_deco {
+	u32 rsvd1;
+	u32 cls1_mode;	/* CxC1MR -  Class 1 Mode */
+	u32 rsvd2;
+	u32 cls1_keysize;	/* CxC1KSR - Class 1 Key Size */
+	u32 cls1_datasize_hi;	/* CxC1DSR - Class 1 Data Size */
+	u32 cls1_datasize_lo;
+	u32 rsvd3;
+	u32 cls1_icvsize;	/* CxC1ICVSR - Class 1 ICV size */
+	u32 rsvd4[5];
+	u32 cha_ctrl;	/* CCTLR - CHA control */
+	u32 rsvd5;
+	u32 irq_crtl;	/* CxCIRQ - CCB interrupt done/error/clear */
+	u32 rsvd6;
+	u32 clr_written;	/* CxCWR - Clear-Written */
+	u32 ccb_status_hi;	/* CxCSTA - CCB Status/Error */
+	u32 ccb_status_lo;
+	u32 rsvd7[3];
+	u32 aad_size;	/* CxAADSZR - Current AAD Size */
+	u32 rsvd8;
+	u32 cls1_iv_size;	/* CxC1IVSZR - Current Class 1 IV Size */
+	u32 rsvd9[7];
+	u32 pkha_a_size;	/* PKASZRx - Size of PKHA A */
+	u32 rsvd10;
+	u32 pkha_b_size;	/* PKBSZRx - Size of PKHA B */
+	u32 rsvd11;
+	u32 pkha_n_size;	/* PKNSZRx - Size of PKHA N */
+	u32 rsvd12;
+	u32 pkha_e_size;	/* PKESZRx - Size of PKHA E */
+	u32 rsvd13[24];
+	u32 cls1_ctx[16];	/* CxC1CTXR - Class 1 Context @100 */
+	u32 rsvd14[48];
+	u32 cls1_key[8];	/* CxC1KEYR - Class 1 Key @200 */
+	u32 rsvd15[121];
+	u32 cls2_mode;	/* CxC2MR - Class 2 Mode */
+	u32 rsvd16;
+	u32 cls2_keysize;	/* CxX2KSR - Class 2 Key Size */
+	u32 cls2_datasize_hi;	/* CxC2DSR - Class 2 Data Size */
+	u32 cls2_datasize_lo;
+	u32 rsvd17;
+	u32 cls2_icvsize;	/* CxC2ICVSZR - Class 2 ICV Size */
+	u32 rsvd18[56];
+	u32 cls2_ctx[18];	/* CxC2CTXR - Class 2 Context @500 */
+	u32 rsvd19[46];
+	u32 cls2_key[32];	/* CxC2KEYR - Class2 Key @600 */
+	u32 rsvd20[84];
+	u32 inp_infofifo_hi;	/* CxIFIFO - Input Info FIFO @7d0 */
+	u32 inp_infofifo_lo;
+	u32 rsvd21[2];
+	u64 inp_datafifo;	/* CxDFIFO - Input Data FIFO */
+	u32 rsvd22[2];
+	u64 out_datafifo;	/* CxOFIFO - Output Data FIFO */
+	u32 rsvd23[2];
+	u32 jr_ctl_hi;	/* CxJRR - JobR Control Register      @800 */
+	u32 jr_ctl_lo;
+	u64 jr_descaddr;	/* CxDADR - JobR Descriptor Address */
+	u32 op_status_hi;	/* DxOPSTA - DECO Operation Status */
+	u32 op_status_lo;
+	u32 rsvd24[2];
+	u32 liodn;		/* DxLSR - DECO LIODN Status - non-seq */
+	u32 td_liodn;	/* DxLSR - DECO LIODN Status - trustdesc */
+	u32 rsvd26[6];
+	u64 math[4];		/* DxMTH - Math register */
+	u32 rsvd27[8];
+	struct deco_sg_table gthr_tbl[4];	/* DxGTR - Gather Tables */
+	u32 rsvd28[16];
+	struct deco_sg_table sctr_tbl[4];	/* DxSTR - Scatter Tables */
+	u32 rsvd29[48];
+	u32 descbuf[64];	/* DxDESB - Descriptor buffer */
+	u32 rsvd30[320];
+};
+
+/*
+ * Current top-level view of memory map is:
+ *
+ * 0x0000 - 0x0fff - CAAM Top-Level Control
+ * 0x1000 - 0x1fff - Job Ring 0
+ * 0x2000 - 0x2fff - Job Ring 1
+ * 0x3000 - 0x3fff - Job Ring 2
+ * 0x4000 - 0x4fff - Job Ring 3
+ * 0x5000 - 0x5fff - (unused)
+ * 0x6000 - 0x6fff - Assurance Controller
+ * 0x7000 - 0x7fff - Queue Interface
+ * 0x8000 - 0x8fff - DECO-CCB 0
+ * 0x9000 - 0x9fff - DECO-CCB 1
+ * 0xa000 - 0xafff - DECO-CCB 2
+ * 0xb000 - 0xbfff - DECO-CCB 3
+ * 0xc000 - 0xcfff - DECO-CCB 4
+ *
+ * caam_full describes the full register view of CAAM if useful,
+ * although many configurations may choose to implement parts of
+ * the register map separately, in differing privilege regions
+ */
+struct caam_full {
+	struct caam_ctrl __iomem ctrl;
+	struct caam_job_ring jr[4];
+	u64 rsvd[512];
+	struct caam_assurance assure;
+	struct caam_queue_if qi;
+	struct caam_deco *deco;
+};
+
+#endif /* REGS_H */
-- 
1.7.4.1

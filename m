From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 4/8] crypto: caam - Add new macros for building extended SEC descriptors (> 64 words)
Date: Mon, 13 May 2013 17:52:28 +0300
Message-ID: <1368456748-1935-1-git-send-email-andrei.varvara@freescale.com>
References: <n>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:23056
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab3EMOwf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:52:35 -0400
Received: from mail186-co9 (localhost [127.0.0.1])	by
 mail186-co9-R.bigfish.com (Postfix) with ESMTP id 0131C100103	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:52:34 +0000 (UTC)
Received: from CO9EHSMHS001.bigfish.com (unknown [10.236.132.246])	by
 mail186-co9.bigfish.com (Postfix) with ESMTP id 31741840049	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:52:32 +0000 (UTC)
In-Reply-To: <n>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

added all supported math funtion on 8 byte boundary with
immediate flag bit set automatically

added MATH_SRC0_DPOVRD & MATH_SRC1_DPOVRD

The function/defines above are needed for creating descriptors
longer than 64 words

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc.h        |    4 +++
 drivers/crypto/caam/desc_constr.h |   53 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 89fa3d0..7d8b147 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -362,14 +362,15 @@ struct sec4_sg_entry {
 #define FIFOLD_TYPE_FLUSH1	(0x01 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LAST1	(0x02 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LAST2FLUSH	(0x03 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LAST2	(0x04 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LAST2FLUSH1 (0x05 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LASTBOTH	(0x06 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_LASTBOTHFL	(0x07 << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_NOINFOFIFO	(0x0F << FIFOLD_TYPE_SHIFT)
 
 #define FIFOLDST_LEN_MASK	0xffff
 #define FIFOLDST_EXT_LEN_MASK	0xffffffff
 
 /* Output data types */
 #define FIFOST_TYPE_SHIFT	16
 #define FIFOST_TYPE_MASK	(0x3f << FIFOST_TYPE_SHIFT)
@@ -1355,14 +1356,15 @@ struct sec4_sg_entry {
 #define MOVE_DEST_DESCBUF	(0x03 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_MATH0		(0x04 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_MATH1		(0x05 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_MATH2		(0x06 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_MATH3		(0x07 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS1INFIFO	(0x08 << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS2INFIFO	(0x09 << MOVE_DEST_SHIFT)
+#define MOVE_DEST_INFIFO_NOINFO (0x0a << MOVE_DEST_SHIFT)
 #define MOVE_DEST_PK_A		(0x0c << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS1KEY	(0x0d << MOVE_DEST_SHIFT)
 #define MOVE_DEST_CLASS2KEY	(0x0e << MOVE_DEST_SHIFT)
 
 #define MOVE_OFFSET_SHIFT	8
 #define MOVE_OFFSET_MASK	(0xff << MOVE_OFFSET_SHIFT)
 
@@ -1407,28 +1409,30 @@ struct sec4_sg_entry {
 #define MATH_SRC0_SHIFT		16
 #define MATH_SRC0_MASK		(0x0f << MATH_SRC0_SHIFT)
 #define MATH_SRC0_REG0		(0x00 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_REG1		(0x01 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_REG2		(0x02 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_REG3		(0x03 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_IMM		(0x04 << MATH_SRC0_SHIFT)
+#define MATH_SRC0_DPOVRD	(0x07 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_SEQINLEN	(0x08 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_SEQOUTLEN	(0x09 << MATH_SRC0_SHIFT)
 #define MATH_SRC0_VARSEQINLEN	(0x0a << MATH_SRC0_SHIFT)
 #define MATH_SRC0_VARSEQOUTLEN	(0x0b << MATH_SRC0_SHIFT)
 #define MATH_SRC0_ZERO		(0x0c << MATH_SRC0_SHIFT)
 
 /* Source 1 selectors */
 #define MATH_SRC1_SHIFT		12
 #define MATH_SRC1_MASK		(0x0f << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG0		(0x00 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG1		(0x01 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG2		(0x02 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_REG3		(0x03 << MATH_SRC1_SHIFT)
 #define MATH_SRC1_IMM		(0x04 << MATH_SRC1_SHIFT)
+#define MATH_SRC1_DPOVRD	(0x07 << MATH_SRC0_SHIFT)
 #define MATH_SRC1_INFIFO	(0x0a << MATH_SRC1_SHIFT)
 #define MATH_SRC1_OUTFIFO	(0x0b << MATH_SRC1_SHIFT)
 #define MATH_SRC1_ONE		(0x0c << MATH_SRC1_SHIFT)
 
 /* Destination selectors */
 #define MATH_DEST_SHIFT		8
 #define MATH_DEST_MASK		(0x0f << MATH_DEST_SHIFT)
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 08c95a1..fe3bfd1 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -106,14 +106,34 @@ static inline void append_cmd(u32 *desc, u32 command)
 	u32 *cmd = desc_end(desc);
 
 	*cmd = command;
 
 	(*desc)++;
 }
 
+#define append_u32 append_cmd
+
+static inline void append_u64(u32 *desc, u64 data)
+{
+	u32 *offset = desc_end(desc);
+
+	*offset = upper_32_bits(data);
+	*(++offset) = lower_32_bits(data);
+
+	(*desc) += 2;
+}
+
+/* Write command without affecting header, and return pointer to next word */
+static inline u32 *write_cmd(u32 *desc, u32 command)
+{
+	*desc = command;
+
+	return desc + 1;
+}
+
 static inline void append_cmd_ptr(u32 *desc, dma_addr_t ptr, int len,
 				  u32 command)
 {
 	append_cmd(desc, command | len);
 	append_ptr(desc, ptr);
 }
 
@@ -275,15 +295,15 @@ APPEND_CMD_RAW_IMM(load, LOAD, u32);
 
 /*
  * Append math command. Only the last part of destination and source need to
  * be specified
  */
 #define APPEND_MATH(op, desc, dest, src_0, src_1, len) \
 append_cmd(desc, CMD_MATH | MATH_FUN_##op | MATH_DEST_##dest | \
-	   MATH_SRC0_##src_0 | MATH_SRC1_##src_1 | (u32) (len & MATH_LEN_MASK));
+	MATH_SRC0_##src_0 | MATH_SRC1_##src_1 | (u32)len);
 
 #define append_math_add(desc, dest, src0, src1, len) \
 	APPEND_MATH(ADD, desc, dest, src0, src1, len)
 #define append_math_sub(desc, dest, src0, src1, len) \
 	APPEND_MATH(SUB, desc, dest, src0, src1, len)
 #define append_math_add_c(desc, dest, src0, src1, len) \
 	APPEND_MATH(ADDC, desc, dest, src0, src1, len)
@@ -323,7 +343,38 @@ do { \
 	APPEND_MATH_IMM_u32(OR, desc, dest, src0, src1, data)
 #define append_math_xor_imm_u32(desc, dest, src0, src1, data) \
 	APPEND_MATH_IMM_u32(XOR, desc, dest, src0, src1, data)
 #define append_math_lshift_imm_u32(desc, dest, src0, src1, data) \
 	APPEND_MATH_IMM_u32(LSHIFT, desc, dest, src0, src1, data)
 #define append_math_rshift_imm_u32(desc, dest, src0, src1, data) \
 	APPEND_MATH_IMM_u32(RSHIFT, desc, dest, src0, src1, data)
+
+/* Exactly one source is IMM. Data is passed in as u64 value */
+#define APPEND_MATH_IMM_u64(op, desc, dest, src_0, src_1, data) \
+do { \
+	u32 upper = (data >> 16) >> 16; \
+	APPEND_MATH(op, desc, dest, src_0, src_1, CAAM_CMD_SZ * 2 | \
+		    (upper ? 0 : MATH_IFB)); \
+	if (upper) \
+		append_u64(desc, data); \
+	else \
+		append_u32(desc, data); \
+} while (0)
+
+#define append_math_add_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(ADD, desc, dest, src0, src1, data)
+#define append_math_sub_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(SUB, desc, dest, src0, src1, data)
+#define append_math_add_c_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(ADDC, desc, dest, src0, src1, data)
+#define append_math_sub_b_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(SUBB, desc, dest, src0, src1, data)
+#define append_math_and_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(AND, desc, dest, src0, src1, data)
+#define append_math_or_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(OR, desc, dest, src0, src1, data)
+#define append_math_xor_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(XOR, desc, dest, src0, src1, data)
+#define append_math_lshift_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(LSHIFT, desc, dest, src0, src1, data)
+#define append_math_rshift_imm_u64(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u64(RSHIFT, desc, dest, src0, src1, data)
-- 
1.7.3.4

From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 05/12] crypto: caam - add Run Time Library (RTA) - part 1
Date: Thu, 14 Aug 2014 15:54:27 +0300
Message-ID: <1408020874-2211-6-git-send-email-horia.geanta@freescale.com>
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
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:26883
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754505AbaHNM4A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:00 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Run Time Library (RTA) is targeted towards building CAAM descriptors,
i.e. programs using accelerator-specific instruction set.

The main reason of replacing incumbent "inline append" is
to have a single code base both for user space and kernel space.
Library also provides for greater flexibility and is more up-to-date.

A useful feature is that the library warns when options not available
in a CAAM version ("Era") are being used.

RTA addition is split in 3 parts, to overcome patch size limitations:
-part 1 (this patch) - add all commands / opcodes (except for PROTOCOL)
-part 2 - add headers defining the API
-part 3 - replace desc.h with a newer version (from within library)

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Carmen Iorga <carmen.iorga@freescale.com>
---
 drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h | 303 ++++++++++++
 drivers/crypto/caam/flib/rta/header_cmd.h          | 209 ++++++++
 drivers/crypto/caam/flib/rta/jump_cmd.h            | 168 +++++++
 drivers/crypto/caam/flib/rta/key_cmd.h             | 183 +++++++
 drivers/crypto/caam/flib/rta/load_cmd.h            | 297 +++++++++++
 drivers/crypto/caam/flib/rta/math_cmd.h            | 362 ++++++++++++++
 drivers/crypto/caam/flib/rta/move_cmd.h            | 401 +++++++++++++++
 drivers/crypto/caam/flib/rta/nfifo_cmd.h           | 157 ++++++
 drivers/crypto/caam/flib/rta/operation_cmd.h       | 545 +++++++++++++++++++++
 drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h  | 168 +++++++
 drivers/crypto/caam/flib/rta/signature_cmd.h       |  36 ++
 drivers/crypto/caam/flib/rta/store_cmd.h           | 145 ++++++
 12 files changed, 2974 insertions(+)
 create mode 100644 drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/header_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/jump_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/key_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/load_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/math_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/move_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/nfifo_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/operation_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/signature_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/store_cmd.h

diff --git a/drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h b/drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h
new file mode 100644
index 000000000000..d1b9016125e9
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/fifo_load_store_cmd.h
@@ -0,0 +1,303 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_FIFO_LOAD_STORE_CMD_H__
+#define __RTA_FIFO_LOAD_STORE_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static const uint32_t fifo_load_table[][2] = {
+/*1*/	{ PKA0,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_A0 },
+	{ PKA1,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_A1 },
+	{ PKA2,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_A2 },
+	{ PKA3,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_A3 },
+	{ PKB0,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_B0 },
+	{ PKB1,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_B1 },
+	{ PKB2,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_B2 },
+	{ PKB3,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_B3 },
+	{ PKA,         FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_A },
+	{ PKB,         FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_B },
+	{ PKN,         FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_PK_N },
+	{ SKIP,        FIFOLD_CLASS_SKIP },
+	{ MSG1,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_MSG },
+	{ MSG2,        FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG },
+	{ MSGOUTSNOOP, FIFOLD_CLASS_BOTH | FIFOLD_TYPE_MSG1OUT2 },
+	{ MSGINSNOOP,  FIFOLD_CLASS_BOTH | FIFOLD_TYPE_MSG },
+	{ IV1,         FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_IV },
+	{ IV2,         FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_IV },
+	{ AAD1,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_AAD },
+	{ ICV1,        FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_ICV },
+	{ ICV2,        FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_ICV },
+	{ BIT_DATA,    FIFOLD_TYPE_BITDATA },
+/*23*/	{ IFIFO,       FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_NOINFOFIFO }
+};
+
+/*
+ * Allowed FIFO_LOAD input data types for each SEC Era.
+ * Values represent the number of entries from fifo_load_table[] that are
+ * supported.
+ */
+static const unsigned fifo_load_table_sz[] = {22, 22, 23, 23, 23, 23, 23, 23};
+
+static inline int rta_fifo_load(struct program *program, uint32_t src,
+				uint64_t loc, uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = 0;
+	uint32_t ext_length = 0, val = 0;
+	int ret = -EINVAL;
+	bool is_seq_cmd = false;
+	unsigned start_pc = program->current_pc;
+
+	/* write command type field */
+	if (flags & SEQ) {
+		opcode = CMD_SEQ_FIFO_LOAD;
+		is_seq_cmd = true;
+	} else {
+		opcode = CMD_FIFO_LOAD;
+	}
+
+	/* Parameters checking */
+	if (is_seq_cmd) {
+		if ((flags & IMMED) || (flags & SGF)) {
+			pr_err("SEQ FIFO LOAD: Invalid command\n");
+			goto err;
+		}
+		if ((rta_sec_era <= RTA_SEC_ERA_5) && (flags & AIDF)) {
+			pr_err("SEQ FIFO LOAD: Flag(s) not supported by SEC Era %d\n",
+			       USER_SEC_ERA(rta_sec_era));
+			goto err;
+		}
+		if ((flags & VLF) && ((flags & EXT) || (length >> 16))) {
+			pr_err("SEQ FIFO LOAD: Invalid usage of VLF\n");
+			goto err;
+		}
+	} else {
+		if (src == SKIP) {
+			pr_err("FIFO LOAD: Invalid src\n");
+			goto err;
+		}
+		if ((flags & AIDF) || (flags & VLF)) {
+			pr_err("FIFO LOAD: Invalid command\n");
+			goto err;
+		}
+		if ((flags & IMMED) && (flags & SGF)) {
+			pr_err("FIFO LOAD: Invalid usage of SGF and IMM\n");
+			goto err;
+		}
+		if ((flags & IMMED) && ((flags & EXT) || (length >> 16))) {
+			pr_err("FIFO LOAD: Invalid usage of EXT and IMM\n");
+			goto err;
+		}
+	}
+
+	/* write input data type field */
+	ret = __rta_map_opcode(src, fifo_load_table,
+			       fifo_load_table_sz[rta_sec_era], &val);
+	if (ret < 0) {
+		pr_err("FIFO LOAD: Source value is not supported. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+	opcode |= val;
+
+	if (flags & CLASS1)
+		opcode |= FIFOLD_CLASS_CLASS1;
+	if (flags & CLASS2)
+		opcode |= FIFOLD_CLASS_CLASS2;
+	if (flags & BOTH)
+		opcode |= FIFOLD_CLASS_BOTH;
+
+	/* write fields: SGF|VLF, IMM, [LC1, LC2, F1] */
+	if (flags & FLUSH1)
+		opcode |= FIFOLD_TYPE_FLUSH1;
+	if (flags & LAST1)
+		opcode |= FIFOLD_TYPE_LAST1;
+	if (flags & LAST2)
+		opcode |= FIFOLD_TYPE_LAST2;
+	if (!is_seq_cmd) {
+		if (flags & SGF)
+			opcode |= FIFOLDST_SGF;
+		if (flags & IMMED)
+			opcode |= FIFOLD_IMM;
+	} else {
+		if (flags & VLF)
+			opcode |= FIFOLDST_VLF;
+		if (flags & AIDF)
+			opcode |= FIFOLD_AIDF;
+	}
+
+	/*
+	 * Verify if extended length is required. In case of BITDATA, calculate
+	 * number of full bytes and additional valid bits.
+	 */
+	if ((flags & EXT) || (length >> 16)) {
+		opcode |= FIFOLDST_EXT;
+		if (src == BIT_DATA) {
+			ext_length = (length / 8);
+			length = (length % 8);
+		} else {
+			ext_length = length;
+			length = 0;
+		}
+	}
+	opcode |= (uint16_t) length;
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	/* write pointer or immediate data field */
+	if (flags & IMMED)
+		__rta_inline_data(program, loc, flags & __COPY_MASK, length);
+	else if (!is_seq_cmd)
+		__rta_out64(program, program->ps, loc);
+
+	/* write extended length field */
+	if (opcode & FIFOLDST_EXT)
+		__rta_out32(program, ext_length);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+static const uint32_t fifo_store_table[][2] = {
+/*1*/	{ PKA0,      FIFOST_TYPE_PKHA_A0 },
+	{ PKA1,      FIFOST_TYPE_PKHA_A1 },
+	{ PKA2,      FIFOST_TYPE_PKHA_A2 },
+	{ PKA3,      FIFOST_TYPE_PKHA_A3 },
+	{ PKB0,      FIFOST_TYPE_PKHA_B0 },
+	{ PKB1,      FIFOST_TYPE_PKHA_B1 },
+	{ PKB2,      FIFOST_TYPE_PKHA_B2 },
+	{ PKB3,      FIFOST_TYPE_PKHA_B3 },
+	{ PKA,       FIFOST_TYPE_PKHA_A },
+	{ PKB,       FIFOST_TYPE_PKHA_B },
+	{ PKN,       FIFOST_TYPE_PKHA_N },
+	{ PKE,       FIFOST_TYPE_PKHA_E_JKEK },
+	{ RNG,       FIFOST_TYPE_RNGSTORE },
+	{ RNGOFIFO,  FIFOST_TYPE_RNGFIFO },
+	{ AFHA_SBOX, FIFOST_TYPE_AF_SBOX_JKEK },
+	{ MDHA_SPLIT_KEY, FIFOST_CLASS_CLASS2KEY | FIFOST_TYPE_SPLIT_KEK },
+	{ MSG,       FIFOST_TYPE_MESSAGE_DATA },
+	{ KEY1,      FIFOST_CLASS_CLASS1KEY | FIFOST_TYPE_KEY_KEK },
+	{ KEY2,      FIFOST_CLASS_CLASS2KEY | FIFOST_TYPE_KEY_KEK },
+	{ OFIFO,     FIFOST_TYPE_OUTFIFO_KEK},
+	{ SKIP,      FIFOST_TYPE_SKIP },
+/*22*/	{ METADATA,  FIFOST_TYPE_METADATA}
+};
+
+/*
+ * Allowed FIFO_STORE output data types for each SEC Era.
+ * Values represent the number of entries from fifo_store_table[] that are
+ * supported.
+ */
+static const unsigned fifo_store_table_sz[] = {21, 21, 21, 21, 22, 22, 22, 22};
+
+static inline int rta_fifo_store(struct program *program, uint32_t src,
+				 uint32_t encrypt_flags, uint64_t dst,
+				 uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = 0;
+	uint32_t val = 0;
+	int ret = -EINVAL;
+	bool is_seq_cmd = false;
+	unsigned start_pc = program->current_pc;
+
+	/* write command type field */
+	if (flags & SEQ) {
+		opcode = CMD_SEQ_FIFO_STORE;
+		is_seq_cmd = true;
+	} else {
+		opcode = CMD_FIFO_STORE;
+	}
+
+	/* Parameter checking */
+	if (is_seq_cmd) {
+		if ((flags & VLF) && ((length >> 16) || (flags & EXT))) {
+			pr_err("SEQ FIFO STORE: Invalid usage of VLF\n");
+			goto err;
+		}
+		if (dst) {
+			pr_err("SEQ FIFO STORE: Invalid command\n");
+			goto err;
+		}
+		if ((src == METADATA) && (flags & (CONT | EXT))) {
+			pr_err("SEQ FIFO STORE: Invalid flags\n");
+			goto err;
+		}
+	} else {
+		if (((src == RNGOFIFO) && ((dst) || (flags & EXT))) ||
+		    (src == METADATA)) {
+			pr_err("FIFO STORE: Invalid destination\n");
+			goto err;
+		}
+	}
+	if ((rta_sec_era == RTA_SEC_ERA_7) && (src == AFHA_SBOX)) {
+		pr_err("FIFO STORE: AFHA S-box not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	/* write output data type field */
+	ret = __rta_map_opcode(src, fifo_store_table,
+			       fifo_store_table_sz[rta_sec_era], &val);
+	if (ret < 0) {
+		pr_err("FIFO STORE: Source type not supported. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+	opcode |= val;
+
+	if (encrypt_flags & TK)
+		opcode |= (0x1 << FIFOST_TYPE_SHIFT);
+	if (encrypt_flags & EKT) {
+		if (rta_sec_era == RTA_SEC_ERA_1) {
+			pr_err("FIFO STORE: AES-CCM source types not supported\n");
+			ret = -EINVAL;
+			goto err;
+		}
+		opcode |= (0x10 << FIFOST_TYPE_SHIFT);
+		opcode &= (uint32_t)~(0x20 << FIFOST_TYPE_SHIFT);
+	}
+
+	/* write flags fields */
+	if (flags & CONT)
+		opcode |= FIFOST_CONT;
+	if ((flags & VLF) && (is_seq_cmd))
+		opcode |= FIFOLDST_VLF;
+	if ((flags & SGF) && (!is_seq_cmd))
+		opcode |= FIFOLDST_SGF;
+	if (flags & CLASS1)
+		opcode |= FIFOST_CLASS_CLASS1KEY;
+	if (flags & CLASS2)
+		opcode |= FIFOST_CLASS_CLASS2KEY;
+	if (flags & BOTH)
+		opcode |= FIFOST_CLASS_BOTH;
+
+	/* Verify if extended length is required */
+	if ((length >> 16) || (flags & EXT))
+		opcode |= FIFOLDST_EXT;
+	else
+		opcode |= (uint16_t) length;
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	/* write pointer field */
+	if ((!is_seq_cmd) && (dst))
+		__rta_out64(program, program->ps, dst);
+
+	/* write extended length field */
+	if (opcode & FIFOLDST_EXT)
+		__rta_out32(program, length);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_FIFO_LOAD_STORE_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/header_cmd.h b/drivers/crypto/caam/flib/rta/header_cmd.h
new file mode 100644
index 000000000000..256465fed844
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/header_cmd.h
@@ -0,0 +1,209 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_HEADER_CMD_H__
+#define __RTA_HEADER_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+/* Allowed job header flags for each SEC Era. */
+static const uint32_t job_header_flags[] = {
+	DNR | TD | MTD | SHR | REO,
+	DNR | TD | MTD | SHR | REO | RSMS,
+	DNR | TD | MTD | SHR | REO | RSMS,
+	DNR | TD | MTD | SHR | REO | RSMS,
+	DNR | TD | MTD | SHR | REO | RSMS | EXT,
+	DNR | TD | MTD | SHR | REO | RSMS | EXT,
+	DNR | TD | MTD | SHR | REO | RSMS | EXT,
+	DNR | TD | MTD | SHR | REO | EXT
+};
+
+/* Allowed shared header flags for each SEC Era. */
+static const uint32_t shr_header_flags[] = {
+	DNR | SC | PD,
+	DNR | SC | PD | CIF,
+	DNR | SC | PD | CIF,
+	DNR | SC | PD | CIF | RIF,
+	DNR | SC | PD | CIF | RIF,
+	DNR | SC | PD | CIF | RIF,
+	DNR | SC | PD | CIF | RIF,
+	DNR | SC | PD | CIF | RIF
+};
+
+static inline int rta_shr_header(struct program *program,
+				 enum rta_share_type share, unsigned start_idx,
+				 uint32_t flags)
+{
+	uint32_t opcode = CMD_SHARED_DESC_HDR;
+	unsigned start_pc = program->current_pc;
+
+	if (flags & ~shr_header_flags[rta_sec_era]) {
+		pr_err("SHR_DESC: Flag(s) not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	switch (share) {
+	case SHR_ALWAYS:
+		opcode |= HDR_SHARE_ALWAYS;
+		break;
+	case SHR_SERIAL:
+		opcode |= HDR_SHARE_SERIAL;
+		break;
+	case SHR_NEVER:
+		/*
+		 * opcode |= HDR_SHARE_NEVER;
+		 * HDR_SHARE_NEVER is 0
+		 */
+		break;
+	case SHR_WAIT:
+		opcode |= HDR_SHARE_WAIT;
+		break;
+	default:
+		pr_err("SHR_DESC: SHARE VALUE is not supported. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	opcode |= HDR_ONE;
+	opcode |= (start_idx << HDR_START_IDX_SHIFT) & HDR_START_IDX_MASK;
+
+	if (flags & DNR)
+		opcode |= HDR_DNR;
+	if (flags & CIF)
+		opcode |= HDR_CLEAR_IFIFO;
+	if (flags & SC)
+		opcode |= HDR_SAVECTX;
+	if (flags & PD)
+		opcode |= HDR_PROP_DNR;
+	if (flags & RIF)
+		opcode |= HDR_RIF;
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	if (program->current_instruction == 1)
+		program->shrhdr = program->buffer;
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return -EINVAL;
+}
+
+static inline int rta_job_header(struct program *program,
+				 enum rta_share_type share, unsigned start_idx,
+				 uint64_t shr_desc, uint32_t flags,
+				 uint32_t ext_flags)
+{
+	uint32_t opcode = CMD_DESC_HDR;
+	uint32_t hdr_ext = 0;
+	unsigned start_pc = program->current_pc;
+
+	if (flags & ~job_header_flags[rta_sec_era]) {
+		pr_err("JOB_DESC: Flag(s) not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	switch (share) {
+	case SHR_ALWAYS:
+		opcode |= HDR_SHARE_ALWAYS;
+		break;
+	case SHR_SERIAL:
+		opcode |= HDR_SHARE_SERIAL;
+		break;
+	case SHR_NEVER:
+		/*
+		 * opcode |= HDR_SHARE_NEVER;
+		 * HDR_SHARE_NEVER is 0
+		 */
+		break;
+	case SHR_WAIT:
+		opcode |= HDR_SHARE_WAIT;
+		break;
+	case SHR_DEFER:
+		opcode |= HDR_SHARE_DEFER;
+		break;
+	default:
+		pr_err("JOB_DESC: SHARE VALUE is not supported. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	if ((flags & TD) && (flags & REO)) {
+		pr_err("JOB_DESC: REO flag not supported for trusted descriptors. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	if ((rta_sec_era < RTA_SEC_ERA_7) && (flags & MTD) && !(flags & TD)) {
+		pr_err("JOB_DESC: Trying to MTD a descriptor that is not a TD. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	if ((flags & EXT) && !(flags & SHR) && (start_idx < 2)) {
+		pr_err("JOB_DESC: Start index must be >= 2 in case of no SHR and EXT. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	opcode |= HDR_ONE;
+	opcode |= ((start_idx << HDR_START_IDX_SHIFT) & HDR_START_IDX_MASK);
+
+	if (flags & EXT) {
+		opcode |= HDR_EXT;
+
+		if (ext_flags & DSV) {
+			hdr_ext |= HDR_EXT_DSEL_VALID;
+			hdr_ext |= ext_flags & DSEL_MASK;
+		}
+
+		if (ext_flags & FTD) {
+			if (rta_sec_era <= RTA_SEC_ERA_5) {
+				pr_err("JOB_DESC: Fake trusted descriptor not supported by SEC Era %d\n",
+				       USER_SEC_ERA(rta_sec_era));
+				goto err;
+			}
+
+			hdr_ext |= HDR_EXT_FTD;
+		}
+	}
+	if (flags & RSMS)
+		opcode |= HDR_RSLS;
+	if (flags & DNR)
+		opcode |= HDR_DNR;
+	if (flags & TD)
+		opcode |= HDR_TRUSTED;
+	if (flags & MTD)
+		opcode |= HDR_MAKE_TRUSTED;
+	if (flags & REO)
+		opcode |= HDR_REVERSE;
+	if (flags & SHR)
+		opcode |= HDR_SHARED;
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	if (program->current_instruction == 1) {
+		program->jobhdr = program->buffer;
+
+		if (opcode & HDR_SHARED)
+			__rta_out64(program, program->ps, shr_desc);
+	}
+
+	if (flags & EXT)
+		__rta_out32(program, hdr_ext);
+
+	/* Note: descriptor length is set in program_finalize routine */
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return -EINVAL;
+}
+
+#endif /* __RTA_HEADER_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/jump_cmd.h b/drivers/crypto/caam/flib/rta/jump_cmd.h
new file mode 100644
index 000000000000..c22b83e890ea
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/jump_cmd.h
@@ -0,0 +1,168 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_JUMP_CMD_H__
+#define __RTA_JUMP_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static const uint32_t jump_test_cond[][2] = {
+	{ NIFP,     JUMP_COND_NIFP },
+	{ NIP,      JUMP_COND_NIP },
+	{ NOP,      JUMP_COND_NOP },
+	{ NCP,      JUMP_COND_NCP },
+	{ CALM,     JUMP_COND_CALM },
+	{ SELF,     JUMP_COND_SELF },
+	{ SHRD,     JUMP_COND_SHRD },
+	{ JQP,      JUMP_COND_JQP },
+	{ MATH_Z,   JUMP_COND_MATH_Z },
+	{ MATH_N,   JUMP_COND_MATH_N },
+	{ MATH_NV,  JUMP_COND_MATH_NV },
+	{ MATH_C,   JUMP_COND_MATH_C },
+	{ PK_0,     JUMP_COND_PK_0 },
+	{ PK_GCD_1, JUMP_COND_PK_GCD_1 },
+	{ PK_PRIME, JUMP_COND_PK_PRIME },
+	{ CLASS1,   JUMP_CLASS_CLASS1 },
+	{ CLASS2,   JUMP_CLASS_CLASS2 },
+	{ BOTH,     JUMP_CLASS_BOTH }
+};
+
+static const uint32_t jump_test_math_cond[][2] = {
+	{ MATH_Z,   JUMP_COND_MATH_Z },
+	{ MATH_N,   JUMP_COND_MATH_N },
+	{ MATH_NV,  JUMP_COND_MATH_NV },
+	{ MATH_C,   JUMP_COND_MATH_C }
+};
+
+static const uint32_t jump_src_dst[][2] = {
+	{ MATH0,     JUMP_SRC_DST_MATH0 },
+	{ MATH1,     JUMP_SRC_DST_MATH1 },
+	{ MATH2,     JUMP_SRC_DST_MATH2 },
+	{ MATH3,     JUMP_SRC_DST_MATH3 },
+	{ DPOVRD,    JUMP_SRC_DST_DPOVRD },
+	{ SEQINSZ,   JUMP_SRC_DST_SEQINLEN },
+	{ SEQOUTSZ,  JUMP_SRC_DST_SEQOUTLEN },
+	{ VSEQINSZ,  JUMP_SRC_DST_VARSEQINLEN },
+	{ VSEQOUTSZ, JUMP_SRC_DST_VARSEQOUTLEN }
+};
+
+static inline int rta_jump(struct program *program, uint64_t address,
+			   enum rta_jump_type jump_type,
+			   enum rta_jump_cond test_type,
+			   uint32_t test_condition, uint32_t src_dst)
+{
+	uint32_t opcode = CMD_JUMP;
+	unsigned start_pc = program->current_pc;
+	int ret = -EINVAL;
+
+	if (((jump_type == GOSUB) || (jump_type == RETURN)) &&
+	    (rta_sec_era < RTA_SEC_ERA_4)) {
+		pr_err("JUMP: Jump type not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	if (((jump_type == LOCAL_JUMP_INC) || (jump_type == LOCAL_JUMP_DEC)) &&
+	    (rta_sec_era <= RTA_SEC_ERA_5)) {
+		pr_err("JUMP_INCDEC: Jump type not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	switch (jump_type) {
+	case (LOCAL_JUMP):
+		/*
+		 * opcode |= JUMP_TYPE_LOCAL;
+		 * JUMP_TYPE_LOCAL is 0
+		 */
+		break;
+	case (HALT):
+		opcode |= JUMP_TYPE_HALT;
+		break;
+	case (HALT_STATUS):
+		opcode |= JUMP_TYPE_HALT_USER;
+		break;
+	case (FAR_JUMP):
+		opcode |= JUMP_TYPE_NONLOCAL;
+		break;
+	case (GOSUB):
+		opcode |= JUMP_TYPE_GOSUB;
+		break;
+	case (RETURN):
+		opcode |= JUMP_TYPE_RETURN;
+		break;
+	case (LOCAL_JUMP_INC):
+		opcode |= JUMP_TYPE_LOCAL_INC;
+		break;
+	case (LOCAL_JUMP_DEC):
+		opcode |= JUMP_TYPE_LOCAL_DEC;
+		break;
+	default:
+		pr_err("JUMP: Invalid jump type. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	switch (test_type) {
+	case (ALL_TRUE):
+		/*
+		 * opcode |= JUMP_TEST_ALL;
+		 * JUMP_TEST_ALL is 0
+		 */
+		break;
+	case (ALL_FALSE):
+		opcode |= JUMP_TEST_INVALL;
+		break;
+	case (ANY_TRUE):
+		opcode |= JUMP_TEST_ANY;
+		break;
+	case (ANY_FALSE):
+		opcode |= JUMP_TEST_INVANY;
+		break;
+	default:
+		pr_err("JUMP: test type not supported. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	/* write test condition field */
+	if ((jump_type != LOCAL_JUMP_INC) && (jump_type != LOCAL_JUMP_DEC)) {
+		__rta_map_flags(test_condition, jump_test_cond,
+				ARRAY_SIZE(jump_test_cond), &opcode);
+	} else {
+		uint32_t val = 0;
+
+		ret = __rta_map_opcode(src_dst, jump_src_dst,
+				       ARRAY_SIZE(jump_src_dst), &val);
+		if (ret < 0) {
+			pr_err("JUMP_INCDEC: SRC_DST not supported. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		opcode |= val;
+
+		__rta_map_flags(test_condition, jump_test_math_cond,
+				ARRAY_SIZE(jump_test_math_cond), &opcode);
+	}
+
+	/* write local offset field for local jumps and user-defined halt */
+	if ((jump_type == LOCAL_JUMP) || (jump_type == LOCAL_JUMP_INC) ||
+	    (jump_type == LOCAL_JUMP_DEC) || (jump_type == GOSUB) ||
+	    (jump_type == HALT_STATUS))
+		opcode |= (uint32_t)(address & JUMP_OFFSET_MASK);
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	if (jump_type == FAR_JUMP)
+		__rta_out64(program, program->ps, address);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_JUMP_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/key_cmd.h b/drivers/crypto/caam/flib/rta/key_cmd.h
new file mode 100644
index 000000000000..0763d78d282c
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/key_cmd.h
@@ -0,0 +1,183 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_KEY_CMD_H__
+#define __RTA_KEY_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+/* Allowed encryption flags for each SEC Era */
+static const uint32_t key_enc_flags[] = {
+	ENC,
+	ENC | NWB | EKT | TK,
+	ENC | NWB | EKT | TK,
+	ENC | NWB | EKT | TK,
+	ENC | NWB | EKT | TK,
+	ENC | NWB | EKT | TK,
+	ENC | NWB | EKT | TK | PTS,
+	ENC | NWB | EKT | TK | PTS
+};
+
+static inline int rta_key(struct program *program, uint32_t key_dst,
+			  uint32_t encrypt_flags, uint64_t src, uint32_t length,
+			  uint32_t flags)
+{
+	uint32_t opcode = 0;
+	bool is_seq_cmd = false;
+	unsigned start_pc = program->current_pc;
+
+	if (encrypt_flags & ~key_enc_flags[rta_sec_era]) {
+		pr_err("KEY: Flag(s) not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	/* write cmd type */
+	if (flags & SEQ) {
+		opcode = CMD_SEQ_KEY;
+		is_seq_cmd = true;
+	} else {
+		opcode = CMD_KEY;
+	}
+
+	/* check parameters */
+	if (is_seq_cmd) {
+		if ((flags & IMMED) || (flags & SGF)) {
+			pr_err("SEQKEY: Invalid flag. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		if ((rta_sec_era <= RTA_SEC_ERA_5) &&
+		    ((flags & VLF) || (flags & AIDF))) {
+			pr_err("SEQKEY: Flag(s) not supported by SEC Era %d\n",
+			       USER_SEC_ERA(rta_sec_era));
+			goto err;
+		}
+	} else {
+		if ((flags & AIDF) || (flags & VLF)) {
+			pr_err("KEY: Invalid flag. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		if ((flags & SGF) && (flags & IMMED)) {
+			pr_err("KEY: Invalid flag. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+	}
+
+	if ((encrypt_flags & PTS) &&
+	    ((encrypt_flags & ENC) || (encrypt_flags & NWB) ||
+	     (key_dst == PKE))) {
+		pr_err("KEY: Invalid flag / destination. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	if (key_dst == AFHA_SBOX) {
+		if (rta_sec_era == RTA_SEC_ERA_7) {
+			pr_err("KEY: AFHA S-box not supported by SEC Era %d\n",
+			       USER_SEC_ERA(rta_sec_era));
+			goto err;
+		}
+
+		if (flags & IMMED) {
+			pr_err("KEY: Invalid flag. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+
+		/*
+		 * Sbox data loaded into the ARC-4 processor must be exactly
+		 * 258 bytes long, or else a data sequence error is generated.
+		 */
+		if (length != 258) {
+			pr_err("KEY: Invalid length. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+	}
+
+	/* write key destination and class fields */
+	switch (key_dst) {
+	case (KEY1):
+		opcode |= KEY_DEST_CLASS1;
+		break;
+	case (KEY2):
+		opcode |= KEY_DEST_CLASS2;
+		break;
+	case (PKE):
+		opcode |= KEY_DEST_CLASS1 | KEY_DEST_PKHA_E;
+		break;
+	case (AFHA_SBOX):
+		opcode |= KEY_DEST_CLASS1 | KEY_DEST_AFHA_SBOX;
+		break;
+	case (MDHA_SPLIT_KEY):
+		opcode |= KEY_DEST_CLASS2 | KEY_DEST_MDHA_SPLIT;
+		break;
+	default:
+		pr_err("KEY: Invalid destination. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	/* write key length */
+	length &= KEY_LENGTH_MASK;
+	opcode |= length;
+
+	/* write key command specific flags */
+	if (encrypt_flags & ENC) {
+		/* Encrypted (black) keys must be padded to 8 bytes (CCM) or
+		   16 bytes (ECB) depending on EKT bit. AES-CCM encrypted keys
+		   (EKT = 1) have 6-byte nonce and 6-byte MAC after padding.
+		 */
+		opcode |= KEY_ENC;
+		if (encrypt_flags & EKT) {
+			opcode |= KEY_EKT;
+			length = ALIGN(length, 8);
+			length += 12;
+		} else {
+			length = ALIGN(length, 16);
+		}
+		if (encrypt_flags & TK)
+			opcode |= KEY_TK;
+	}
+	if (encrypt_flags & NWB)
+		opcode |= KEY_NWB;
+	if (encrypt_flags & PTS)
+		opcode |= KEY_PTS;
+
+	/* write general command flags */
+	if (!is_seq_cmd) {
+		if (flags & IMMED)
+			opcode |= KEY_IMM;
+		if (flags & SGF)
+			opcode |= KEY_SGF;
+	} else {
+		if (flags & AIDF)
+			opcode |= KEY_AIDF;
+		if (flags & VLF)
+			opcode |= KEY_VLF;
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	if (flags & IMMED)
+		__rta_inline_data(program, src, flags & __COPY_MASK, length);
+	else
+		__rta_out64(program, program->ps, src);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return -EINVAL;
+}
+
+#endif /* __RTA_KEY_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/load_cmd.h b/drivers/crypto/caam/flib/rta/load_cmd.h
new file mode 100644
index 000000000000..c86c527f1c37
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/load_cmd.h
@@ -0,0 +1,297 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_LOAD_CMD_H__
+#define __RTA_LOAD_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+/* Allowed length and offset masks for each SEC Era in case DST = DCTRL */
+static const uint32_t load_len_mask_allowed[] = {
+	0x000000ee,
+	0x000000fe,
+	0x000000fe,
+	0x000000fe,
+	0x000000fe,
+	0x000000fe,
+	0x000000fe,
+	0x000000fe
+};
+
+static const uint32_t load_off_mask_allowed[] = {
+	0x0000000f,
+	0x000000ff,
+	0x000000ff,
+	0x000000ff,
+	0x000000ff,
+	0x000000ff,
+	0x000000ff,
+	0x000000ff
+};
+
+#define IMM_MUST 0
+#define IMM_CAN  1
+#define IMM_NO   2
+#define IMM_DSNM 3 /* it doesn't matter the src type */
+
+enum e_lenoff {
+	LENOF_03,
+	LENOF_4,
+	LENOF_48,
+	LENOF_448,
+	LENOF_18,
+	LENOF_32,
+	LENOF_24,
+	LENOF_16,
+	LENOF_8,
+	LENOF_128,
+	LENOF_256,
+	DSNM /* it doesn't matter the length/offset values */
+};
+
+struct load_map {
+	uint32_t dst;
+	uint32_t dst_opcode;
+	enum e_lenoff len_off;
+	uint8_t imm_src;
+
+};
+
+static const struct load_map load_dst[] = {
+/*1*/	{ KEY1SZ,  LDST_CLASS_1_CCB | LDST_SRCDST_WORD_KEYSZ_REG,
+		   LENOF_4,   IMM_MUST },
+	{ KEY2SZ,  LDST_CLASS_2_CCB | LDST_SRCDST_WORD_KEYSZ_REG,
+		   LENOF_4,   IMM_MUST },
+	{ DATA1SZ, LDST_CLASS_1_CCB | LDST_SRCDST_WORD_DATASZ_REG,
+		   LENOF_448, IMM_MUST },
+	{ DATA2SZ, LDST_CLASS_2_CCB | LDST_SRCDST_WORD_DATASZ_REG,
+		   LENOF_448, IMM_MUST },
+	{ ICV1SZ,  LDST_CLASS_1_CCB | LDST_SRCDST_WORD_ICVSZ_REG,
+		   LENOF_4,   IMM_MUST },
+	{ ICV2SZ,  LDST_CLASS_2_CCB | LDST_SRCDST_WORD_ICVSZ_REG,
+		   LENOF_4,   IMM_MUST },
+	{ CCTRL,   LDST_CLASS_IND_CCB | LDST_SRCDST_WORD_CHACTRL,
+		   LENOF_4,   IMM_MUST },
+	{ DCTRL,   LDST_CLASS_DECO | LDST_IMM | LDST_SRCDST_WORD_DECOCTRL,
+		   DSNM,      IMM_DSNM },
+	{ ICTRL,   LDST_CLASS_IND_CCB | LDST_SRCDST_WORD_IRQCTRL,
+		   LENOF_4,   IMM_MUST },
+	{ DPOVRD,  LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_PCLOVRD,
+		   LENOF_4,   IMM_MUST },
+	{ CLRW,    LDST_CLASS_IND_CCB | LDST_SRCDST_WORD_CLRW,
+		   LENOF_4,   IMM_MUST },
+	{ AAD1SZ,  LDST_CLASS_1_CCB | LDST_SRCDST_WORD_DECO_AAD_SZ,
+		   LENOF_4,   IMM_MUST },
+	{ IV1SZ,   LDST_CLASS_1_CCB | LDST_SRCDST_WORD_CLASS1_IV_SZ,
+		   LENOF_4,   IMM_MUST },
+	{ ALTDS1,  LDST_CLASS_1_CCB | LDST_SRCDST_WORD_ALTDS_CLASS1,
+		   LENOF_448, IMM_MUST },
+	{ PKASZ,   LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_A_SZ,
+		   LENOF_4,   IMM_MUST, },
+	{ PKBSZ,   LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_B_SZ,
+		   LENOF_4,   IMM_MUST },
+	{ PKNSZ,   LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_N_SZ,
+		   LENOF_4,   IMM_MUST },
+	{ PKESZ,   LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_E_SZ,
+		   LENOF_4,   IMM_MUST },
+	{ NFIFO,   LDST_CLASS_IND_CCB | LDST_SRCDST_WORD_INFO_FIFO,
+		   LENOF_48,  IMM_MUST },
+	{ IFIFO,   LDST_SRCDST_BYTE_INFIFO,  LENOF_18, IMM_MUST },
+	{ OFIFO,   LDST_SRCDST_BYTE_OUTFIFO, LENOF_18, IMM_MUST },
+	{ MATH0,   LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH0,
+		   LENOF_32,  IMM_CAN },
+	{ MATH1,   LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH1,
+		   LENOF_24,  IMM_CAN },
+	{ MATH2,   LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH2,
+		   LENOF_16,  IMM_CAN },
+	{ MATH3,   LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH3,
+		   LENOF_8,   IMM_CAN },
+	{ CONTEXT1, LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT,
+		   LENOF_128, IMM_CAN },
+	{ CONTEXT2, LDST_CLASS_2_CCB | LDST_SRCDST_BYTE_CONTEXT,
+		   LENOF_128, IMM_CAN },
+	{ KEY1,    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_KEY,
+		   LENOF_32,  IMM_CAN },
+	{ KEY2,    LDST_CLASS_2_CCB | LDST_SRCDST_BYTE_KEY,
+		   LENOF_32,  IMM_CAN },
+	{ DESCBUF, LDST_CLASS_DECO | LDST_SRCDST_WORD_DESCBUF,
+		   LENOF_256,  IMM_NO },
+	{ DPID,    LDST_CLASS_DECO | LDST_SRCDST_WORD_PID,
+		   LENOF_448, IMM_MUST },
+/*32*/	{ IDFNS,   LDST_SRCDST_WORD_IFNSR, LENOF_18,  IMM_MUST },
+	{ ODFNS,   LDST_SRCDST_WORD_OFNSR, LENOF_18,  IMM_MUST },
+	{ ALTSOURCE, LDST_SRCDST_BYTE_ALTSOURCE, LENOF_18,  IMM_MUST },
+/*35*/	{ NFIFO_SZL, LDST_SRCDST_WORD_INFO_FIFO_SZL, LENOF_48, IMM_MUST },
+	{ NFIFO_SZM, LDST_SRCDST_WORD_INFO_FIFO_SZM, LENOF_03, IMM_MUST },
+	{ NFIFO_L, LDST_SRCDST_WORD_INFO_FIFO_L, LENOF_48, IMM_MUST },
+	{ NFIFO_M, LDST_SRCDST_WORD_INFO_FIFO_M, LENOF_03, IMM_MUST },
+	{ SZL,     LDST_SRCDST_WORD_SZL, LENOF_48, IMM_MUST },
+/*40*/	{ SZM,     LDST_SRCDST_WORD_SZM, LENOF_03, IMM_MUST }
+};
+
+/*
+ * Allowed LOAD destinations for each SEC Era.
+ * Values represent the number of entries from load_dst[] that are supported.
+ */
+static const unsigned load_dst_sz[] = { 31, 34, 34, 40, 40, 40, 40, 40 };
+
+static inline int load_check_len_offset(int pos, uint32_t length,
+					uint32_t offset)
+{
+	if ((load_dst[pos].dst == DCTRL) &&
+	    ((length & ~load_len_mask_allowed[rta_sec_era]) ||
+	     (offset & ~load_off_mask_allowed[rta_sec_era])))
+		goto err;
+
+	switch (load_dst[pos].len_off) {
+	case (LENOF_03):
+		if ((length > 3) || (offset))
+			goto err;
+		break;
+	case (LENOF_4):
+		if ((length != 4) || (offset != 0))
+			goto err;
+		break;
+	case (LENOF_48):
+		if (!(((length == 4) && (offset == 0)) ||
+		      ((length == 8) && (offset == 0))))
+			goto err;
+		break;
+	case (LENOF_448):
+		if (!(((length == 4) && (offset == 0)) ||
+		      ((length == 4) && (offset == 4)) ||
+		      ((length == 8) && (offset == 0))))
+			goto err;
+		break;
+	case (LENOF_18):
+		if ((length < 1) || (length > 8) || (offset != 0))
+			goto err;
+		break;
+	case (LENOF_32):
+		if ((length > 32) || (offset > 32) || ((offset + length) > 32))
+			goto err;
+		break;
+	case (LENOF_24):
+		if ((length > 24) || (offset > 24) || ((offset + length) > 24))
+			goto err;
+		break;
+	case (LENOF_16):
+		if ((length > 16) || (offset > 16) || ((offset + length) > 16))
+			goto err;
+		break;
+	case (LENOF_8):
+		if ((length > 8) || (offset > 8) || ((offset + length) > 8))
+			goto err;
+		break;
+	case (LENOF_128):
+		if ((length > 128) || (offset > 128) ||
+		    ((offset + length) > 128))
+			goto err;
+		break;
+	case (LENOF_256):
+		if ((length < 1) || (length > 256) || ((length + offset) > 256))
+			goto err;
+		break;
+	case (DSNM):
+		break;
+	default:
+		goto err;
+		break;
+	}
+
+	return 0;
+err:
+	return -EINVAL;
+}
+
+static inline int rta_load(struct program *program, uint64_t src, uint64_t dst,
+			   uint32_t offset, uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = 0;
+	int pos = -1, ret = -EINVAL;
+	unsigned start_pc = program->current_pc, i;
+
+	if (flags & SEQ)
+		opcode = CMD_SEQ_LOAD;
+	else
+		opcode = CMD_LOAD;
+
+	if ((length & 0xffffff00) || (offset & 0xffffff00)) {
+		pr_err("LOAD: Bad length/offset passed. Should be 8 bits\n");
+		goto err;
+	}
+
+	if (flags & SGF)
+		opcode |= LDST_SGF;
+	if (flags & VLF)
+		opcode |= LDST_VLF;
+
+	/* check load destination, length and offset and source type */
+	for (i = 0; i < load_dst_sz[rta_sec_era]; i++)
+		if (dst == load_dst[i].dst) {
+			pos = (int)i;
+			break;
+		}
+	if (-1 == pos) {
+		pr_err("LOAD: Invalid dst. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	if (flags & IMMED) {
+		if (load_dst[pos].imm_src == IMM_NO) {
+			pr_err("LOAD: Invalid source type. SEC Program Line: %d\n",
+			       program->current_pc);
+			goto err;
+		}
+		opcode |= LDST_IMM;
+	} else if (load_dst[pos].imm_src == IMM_MUST) {
+		pr_err("LOAD IMM: Invalid source type. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	ret = load_check_len_offset(pos, length, offset);
+	if (ret < 0) {
+		pr_err("LOAD: Invalid length/offset. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	opcode |= load_dst[pos].dst_opcode;
+
+	/* DESC BUFFER: length / offset values are specified in 4-byte words */
+	if (dst == DESCBUF) {
+		opcode |= (length >> 2);
+		opcode |= ((offset >> 2) << LDST_OFFSET_SHIFT);
+	} else {
+		opcode |= length;
+		opcode |= (offset << LDST_OFFSET_SHIFT);
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	/* DECO CONTROL: skip writing pointer of imm data */
+	if (dst == DCTRL)
+		return (int)start_pc;
+
+	/*
+	 * For data copy, 3 possible ways to specify how to copy data:
+	 *  - IMMED & !COPY: copy data directly from src( max 8 bytes)
+	 *  - IMMED & COPY: copy data imm from the location specified by user
+	 *  - !IMMED and is not SEQ cmd: copy the address
+	 */
+	if (flags & IMMED)
+		__rta_inline_data(program, src, flags & __COPY_MASK, length);
+	else if (!(flags & SEQ))
+		__rta_out64(program, program->ps, src);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_LOAD_CMD_H__*/
diff --git a/drivers/crypto/caam/flib/rta/math_cmd.h b/drivers/crypto/caam/flib/rta/math_cmd.h
new file mode 100644
index 000000000000..cc47d0843075
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/math_cmd.h
@@ -0,0 +1,362 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_MATH_CMD_H__
+#define __RTA_MATH_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static const uint32_t math_op1[][2] = {
+/*1*/	{ MATH0,     MATH_SRC0_REG0 },
+	{ MATH1,     MATH_SRC0_REG1 },
+	{ MATH2,     MATH_SRC0_REG2 },
+	{ MATH3,     MATH_SRC0_REG3 },
+	{ SEQINSZ,   MATH_SRC0_SEQINLEN },
+	{ SEQOUTSZ,  MATH_SRC0_SEQOUTLEN },
+	{ VSEQINSZ,  MATH_SRC0_VARSEQINLEN },
+	{ VSEQOUTSZ, MATH_SRC0_VARSEQOUTLEN },
+	{ ZERO,      MATH_SRC0_ZERO },
+/*10*/	{ NONE,      0 }, /* dummy value */
+	{ DPOVRD,    MATH_SRC0_DPOVRD },
+	{ ONE,       MATH_SRC0_ONE }
+};
+
+/*
+ * Allowed MATH op1 sources for each SEC Era.
+ * Values represent the number of entries from math_op1[] that are supported.
+ */
+static const unsigned math_op1_sz[] = {10, 10, 12, 12, 12, 12, 12, 12};
+
+static const uint32_t math_op2[][2] = {
+/*1*/	{ MATH0,     MATH_SRC1_REG0 },
+	{ MATH1,     MATH_SRC1_REG1 },
+	{ MATH2,     MATH_SRC1_REG2 },
+	{ MATH3,     MATH_SRC1_REG3 },
+	{ ABD,       MATH_SRC1_INFIFO },
+	{ OFIFO,     MATH_SRC1_OUTFIFO },
+	{ ONE,       MATH_SRC1_ONE },
+/*8*/	{ NONE,      0 }, /* dummy value */
+	{ JOBSRC,    MATH_SRC1_JOBSOURCE },
+	{ DPOVRD,    MATH_SRC1_DPOVRD },
+	{ VSEQINSZ,  MATH_SRC1_VARSEQINLEN },
+	{ VSEQOUTSZ, MATH_SRC1_VARSEQOUTLEN },
+/*13*/	{ ZERO,      MATH_SRC1_ZERO }
+};
+
+/*
+ * Allowed MATH op2 sources for each SEC Era.
+ * Values represent the number of entries from math_op2[] that are supported.
+ */
+static const unsigned math_op2_sz[] = {8, 9, 13, 13, 13, 13, 13, 13};
+
+static const uint32_t math_result[][2] = {
+/*1*/	{ MATH0,     MATH_DEST_REG0 },
+	{ MATH1,     MATH_DEST_REG1 },
+	{ MATH2,     MATH_DEST_REG2 },
+	{ MATH3,     MATH_DEST_REG3 },
+	{ SEQINSZ,   MATH_DEST_SEQINLEN },
+	{ SEQOUTSZ,  MATH_DEST_SEQOUTLEN },
+	{ VSEQINSZ,  MATH_DEST_VARSEQINLEN },
+	{ VSEQOUTSZ, MATH_DEST_VARSEQOUTLEN },
+/*9*/	{ NONE,      MATH_DEST_NONE },
+	{ DPOVRD,    MATH_DEST_DPOVRD }
+};
+
+/*
+ * Allowed MATH result destinations for each SEC Era.
+ * Values represent the number of entries from math_result[] that are
+ * supported.
+ */
+static const unsigned math_result_sz[] = {9, 9, 10, 10, 10, 10, 10, 10};
+
+static inline int rta_math(struct program *program, uint64_t operand1,
+			   uint32_t op, uint64_t operand2, uint32_t result,
+			   int length, uint32_t options)
+{
+	uint32_t opcode = CMD_MATH;
+	uint32_t val = 0;
+	int ret = -EINVAL;
+	unsigned start_pc = program->current_pc;
+
+	if (((op == MATH_FUN_BSWAP) && (rta_sec_era < RTA_SEC_ERA_4)) ||
+	    ((op == MATH_FUN_ZBYT) && (rta_sec_era < RTA_SEC_ERA_2))) {
+		pr_err("MATH: operation not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+		       USER_SEC_ERA(rta_sec_era), program->current_pc,
+		       program->current_instruction);
+		goto err;
+	}
+
+	if (options & SWP) {
+		if (rta_sec_era < RTA_SEC_ERA_7) {
+			pr_err("MATH: operation not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+			       USER_SEC_ERA(rta_sec_era), program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+
+		if ((options & IFB) ||
+		    (!(options & IMMED) && !(options & IMMED2)) ||
+		    ((options & IMMED) && (options & IMMED2))) {
+			pr_err("MATH: SWP - invalid configuration. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+	}
+
+	/*
+	 * SHLD operation is different from others and we
+	 * assume that we can have _NONE as first operand
+	 * or _SEQINSZ as second operand
+	 */
+	if ((op != MATH_FUN_SHLD) && ((operand1 == NONE) ||
+				      (operand2 == SEQINSZ))) {
+		pr_err("MATH: Invalid operand. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	/*
+	 * We first check if it is unary operation. In that
+	 * case second operand must be _NONE
+	 */
+	if (((op == MATH_FUN_ZBYT) || (op == MATH_FUN_BSWAP)) &&
+	    (operand2 != NONE)) {
+		pr_err("MATH: Invalid operand2. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	/* Write first operand field */
+	if (options & IMMED) {
+		opcode |= MATH_SRC0_IMM;
+	} else {
+		ret = __rta_map_opcode((uint32_t)operand1, math_op1,
+				       math_op1_sz[rta_sec_era], &val);
+		if (ret < 0) {
+			pr_err("MATH: operand1 not supported. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		opcode |= val;
+	}
+
+	/* Write second operand field */
+	if (options & IMMED2) {
+		opcode |= MATH_SRC1_IMM;
+	} else {
+		ret = __rta_map_opcode((uint32_t)operand2, math_op2,
+				       math_op2_sz[rta_sec_era], &val);
+		if (ret < 0) {
+			pr_err("MATH: operand2 not supported. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		opcode |= val;
+	}
+
+	/* Write result field */
+	ret = __rta_map_opcode(result, math_result, math_result_sz[rta_sec_era],
+			       &val);
+	if (ret < 0) {
+		pr_err("MATH: result not supported. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	opcode |= val;
+
+	/*
+	 * as we encode operations with their "real" values, we do not
+	 * to translate but we do need to validate the value
+	 */
+	switch (op) {
+	/*Binary operators */
+	case (MATH_FUN_ADD):
+	case (MATH_FUN_ADDC):
+	case (MATH_FUN_SUB):
+	case (MATH_FUN_SUBB):
+	case (MATH_FUN_OR):
+	case (MATH_FUN_AND):
+	case (MATH_FUN_XOR):
+	case (MATH_FUN_LSHIFT):
+	case (MATH_FUN_RSHIFT):
+	case (MATH_FUN_SHLD):
+	/* Unary operators */
+	case (MATH_FUN_ZBYT):
+	case (MATH_FUN_BSWAP):
+		opcode |= op;
+		break;
+	default:
+		pr_err("MATH: operator is not supported. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	opcode |= (options & ~(IMMED | IMMED2));
+
+	/* Verify length */
+	switch (length) {
+	case (1):
+		opcode |= MATH_LEN_1BYTE;
+		break;
+	case (2):
+		opcode |= MATH_LEN_2BYTE;
+		break;
+	case (4):
+		opcode |= MATH_LEN_4BYTE;
+		break;
+	case (8):
+		opcode |= MATH_LEN_8BYTE;
+		break;
+	default:
+		pr_err("MATH: length is not supported. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	/* Write immediate value */
+	if ((options & IMMED) && !(options & IMMED2)) {
+		__rta_out64(program, (length > 4) && !(options & IFB),
+			    operand1);
+	} else if ((options & IMMED2) && !(options & IMMED)) {
+		__rta_out64(program, (length > 4) && !(options & IFB),
+			    operand2);
+	} else if ((options & IMMED) && (options & IMMED2)) {
+		__rta_out32(program, lower_32_bits(operand1));
+		__rta_out32(program, lower_32_bits(operand2));
+	}
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+static inline int rta_mathi(struct program *program, uint64_t operand,
+			    uint32_t op, uint8_t imm, uint32_t result,
+			    int length, uint32_t options)
+{
+	uint32_t opcode = CMD_MATHI;
+	uint32_t val = 0;
+	int ret = -EINVAL;
+	unsigned start_pc = program->current_pc;
+
+	if (rta_sec_era < RTA_SEC_ERA_6) {
+		pr_err("MATHI: Command not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+		       USER_SEC_ERA(rta_sec_era), program->current_pc,
+		       program->current_instruction);
+		goto err;
+	}
+
+	if (((op == MATH_FUN_FBYT) && (options & SSEL))) {
+		pr_err("MATHI: Illegal combination - FBYT and SSEL. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	if ((options & SWP) && (rta_sec_era < RTA_SEC_ERA_7)) {
+		pr_err("MATHI: SWP not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+		       USER_SEC_ERA(rta_sec_era), program->current_pc,
+		       program->current_instruction);
+		goto err;
+	}
+
+	/* Write first operand field */
+	if (!(options & SSEL))
+		ret = __rta_map_opcode((uint32_t)operand, math_op1,
+				       math_op1_sz[rta_sec_era], &val);
+	else
+		ret = __rta_map_opcode((uint32_t)operand, math_op2,
+				       math_op2_sz[rta_sec_era], &val);
+	if (ret < 0) {
+		pr_err("MATHI: operand not supported. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	if (!(options & SSEL))
+		opcode |= val;
+	else
+		opcode |= (val << (MATHI_SRC1_SHIFT - MATH_SRC1_SHIFT));
+
+	/* Write second operand field */
+	opcode |= (imm << MATHI_IMM_SHIFT);
+
+	/* Write result field */
+	ret = __rta_map_opcode(result, math_result, math_result_sz[rta_sec_era],
+			       &val);
+	if (ret < 0) {
+		pr_err("MATHI: result not supported. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	opcode |= (val << (MATHI_DEST_SHIFT - MATH_DEST_SHIFT));
+
+	/*
+	 * as we encode operations with their "real" values, we do not have to
+	 * translate but we do need to validate the value
+	 */
+	switch (op) {
+	case (MATH_FUN_ADD):
+	case (MATH_FUN_ADDC):
+	case (MATH_FUN_SUB):
+	case (MATH_FUN_SUBB):
+	case (MATH_FUN_OR):
+	case (MATH_FUN_AND):
+	case (MATH_FUN_XOR):
+	case (MATH_FUN_LSHIFT):
+	case (MATH_FUN_RSHIFT):
+	case (MATH_FUN_FBYT):
+		opcode |= op;
+		break;
+	default:
+		pr_err("MATHI: operator not supported. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	opcode |= options;
+
+	/* Verify length */
+	switch (length) {
+	case (1):
+		opcode |= MATH_LEN_1BYTE;
+		break;
+	case (2):
+		opcode |= MATH_LEN_2BYTE;
+		break;
+	case (4):
+		opcode |= MATH_LEN_4BYTE;
+		break;
+	case (8):
+		opcode |= MATH_LEN_8BYTE;
+		break;
+	default:
+		pr_err("MATHI: length %d not supported. SEC PC: %d; Instr: %d\n",
+		       length, program->current_pc,
+		       program->current_instruction);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_MATH_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/move_cmd.h b/drivers/crypto/caam/flib/rta/move_cmd.h
new file mode 100644
index 000000000000..b12086ae835a
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/move_cmd.h
@@ -0,0 +1,401 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_MOVE_CMD_H__
+#define __RTA_MOVE_CMD_H__
+
+#define MOVE_SET_AUX_SRC	0x01
+#define MOVE_SET_AUX_DST	0x02
+#define MOVE_SET_AUX_LS		0x03
+#define MOVE_SET_LEN_16b	0x04
+
+#define MOVE_SET_AUX_MATH	0x10
+#define MOVE_SET_AUX_MATH_SRC	(MOVE_SET_AUX_SRC | MOVE_SET_AUX_MATH)
+#define MOVE_SET_AUX_MATH_DST	(MOVE_SET_AUX_DST | MOVE_SET_AUX_MATH)
+
+#define MASK_16b  0xFF
+
+/* MOVE command type */
+#define __MOVE		1
+#define __MOVEB		2
+#define __MOVEDW	3
+
+extern enum rta_sec_era rta_sec_era;
+
+static const uint32_t move_src_table[][2] = {
+/*1*/	{ CONTEXT1, MOVE_SRC_CLASS1CTX },
+	{ CONTEXT2, MOVE_SRC_CLASS2CTX },
+	{ OFIFO,    MOVE_SRC_OUTFIFO },
+	{ DESCBUF,  MOVE_SRC_DESCBUF },
+	{ MATH0,    MOVE_SRC_MATH0 },
+	{ MATH1,    MOVE_SRC_MATH1 },
+	{ MATH2,    MOVE_SRC_MATH2 },
+	{ MATH3,    MOVE_SRC_MATH3 },
+/*9*/	{ IFIFOABD, MOVE_SRC_INFIFO },
+	{ IFIFOAB1, MOVE_SRC_INFIFO_CL | MOVE_AUX_LS },
+	{ IFIFOAB2, MOVE_SRC_INFIFO_CL },
+/*12*/	{ ABD,      MOVE_SRC_INFIFO_NO_NFIFO },
+	{ AB1,      MOVE_SRC_INFIFO_NO_NFIFO | MOVE_AUX_LS },
+	{ AB2,      MOVE_SRC_INFIFO_NO_NFIFO | MOVE_AUX_MS }
+};
+
+/* Allowed MOVE / MOVE_LEN sources for each SEC Era.
+ * Values represent the number of entries from move_src_table[] that are
+ * supported.
+ */
+static const unsigned move_src_table_sz[] = {9, 11, 14, 14, 14, 14, 14, 14};
+
+static const uint32_t move_dst_table[][2] = {
+/*1*/	{ CONTEXT1,  MOVE_DEST_CLASS1CTX },
+	{ CONTEXT2,  MOVE_DEST_CLASS2CTX },
+	{ OFIFO,     MOVE_DEST_OUTFIFO },
+	{ DESCBUF,   MOVE_DEST_DESCBUF },
+	{ MATH0,     MOVE_DEST_MATH0 },
+	{ MATH1,     MOVE_DEST_MATH1 },
+	{ MATH2,     MOVE_DEST_MATH2 },
+	{ MATH3,     MOVE_DEST_MATH3 },
+	{ IFIFOAB1,  MOVE_DEST_CLASS1INFIFO },
+	{ IFIFOAB2,  MOVE_DEST_CLASS2INFIFO },
+	{ PKA,       MOVE_DEST_PK_A },
+	{ KEY1,      MOVE_DEST_CLASS1KEY },
+	{ KEY2,      MOVE_DEST_CLASS2KEY },
+/*14*/	{ IFIFO,     MOVE_DEST_INFIFO },
+/*15*/	{ ALTSOURCE,  MOVE_DEST_ALTSOURCE}
+};
+
+/* Allowed MOVE / MOVE_LEN destinations for each SEC Era.
+ * Values represent the number of entries from move_dst_table[] that are
+ * supported.
+ */
+static const unsigned move_dst_table_sz[] = {13, 14, 14, 15, 15, 15, 15, 15};
+
+static inline int set_move_offset(struct program *program, uint64_t src,
+				  uint16_t src_offset, uint64_t dst,
+				  uint16_t dst_offset, uint16_t *offset,
+				  uint16_t *opt);
+
+static inline int math_offset(uint16_t offset);
+
+static inline int rta_move(struct program *program, int cmd_type, uint64_t src,
+			   uint16_t src_offset, uint64_t dst,
+			   uint16_t dst_offset, uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = 0;
+	uint16_t offset = 0, opt = 0;
+	uint32_t val = 0;
+	int ret = -EINVAL;
+	bool is_move_len_cmd = false;
+	unsigned start_pc = program->current_pc;
+
+	if ((rta_sec_era < RTA_SEC_ERA_7) && (cmd_type != __MOVE)) {
+		pr_err("MOVE: MOVEB / MOVEDW not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+		       USER_SEC_ERA(rta_sec_era), program->current_pc,
+		       program->current_instruction);
+		goto err;
+	}
+
+	/* write command type */
+	if (cmd_type == __MOVEB) {
+		opcode = CMD_MOVEB;
+	} else if (cmd_type == __MOVEDW) {
+		opcode = CMD_MOVEDW;
+	} else if (!(flags & IMMED)) {
+		if (rta_sec_era < RTA_SEC_ERA_3) {
+			pr_err("MOVE: MOVE_LEN not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+			       USER_SEC_ERA(rta_sec_era), program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+
+		if ((length != MATH0) && (length != MATH1) &&
+		    (length != MATH2) && (length != MATH3)) {
+			pr_err("MOVE: MOVE_LEN length must be MATH[0-3]. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+
+		opcode = CMD_MOVE_LEN;
+		is_move_len_cmd = true;
+	} else {
+		opcode = CMD_MOVE;
+	}
+
+	/* write offset first, to check for invalid combinations or incorrect
+	 * offset values sooner; decide which offset should be here
+	 * (src or dst)
+	 */
+	ret = set_move_offset(program, src, src_offset, dst, dst_offset,
+			      &offset, &opt);
+	if (ret < 0)
+		goto err;
+
+	opcode |= (offset << MOVE_OFFSET_SHIFT) & MOVE_OFFSET_MASK;
+
+	/* set AUX field if required */
+	if (opt == MOVE_SET_AUX_SRC) {
+		opcode |= ((src_offset / 16) << MOVE_AUX_SHIFT) & MOVE_AUX_MASK;
+	} else if (opt == MOVE_SET_AUX_DST) {
+		opcode |= ((dst_offset / 16) << MOVE_AUX_SHIFT) & MOVE_AUX_MASK;
+	} else if (opt == MOVE_SET_AUX_LS) {
+		opcode |= MOVE_AUX_LS;
+	} else if (opt & MOVE_SET_AUX_MATH) {
+		if (opt & MOVE_SET_AUX_SRC)
+			offset = src_offset;
+		else
+			offset = dst_offset;
+
+		if (rta_sec_era < RTA_SEC_ERA_6) {
+			if (offset)
+				pr_debug("MOVE: Offset not supported by SEC Era %d. SEC PC: %d; Instr: %d\n",
+					 USER_SEC_ERA(rta_sec_era),
+					 program->current_pc,
+					 program->current_instruction);
+			/* nothing to do for offset = 0 */
+		} else {
+			ret = math_offset(offset);
+			if (ret < 0) {
+				pr_err("MOVE: Invalid offset in MATH register. SEC PC: %d; Instr: %d\n",
+				       program->current_pc,
+				       program->current_instruction);
+				goto err;
+			}
+
+			opcode |= (uint32_t)ret;
+		}
+	}
+
+	/* write source field */
+	ret = __rta_map_opcode((uint32_t)src, move_src_table,
+			       move_src_table_sz[rta_sec_era], &val);
+	if (ret < 0) {
+		pr_err("MOVE: Invalid SRC. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	opcode |= val;
+
+	/* write destination field */
+	ret = __rta_map_opcode((uint32_t)dst, move_dst_table,
+			       move_dst_table_sz[rta_sec_era], &val);
+	if (ret < 0) {
+		pr_err("MOVE: Invalid DST. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	opcode |= val;
+
+	/* write flags */
+	if (flags & (FLUSH1 | FLUSH2))
+		opcode |= MOVE_AUX_MS;
+	if (flags & (LAST2 | LAST1))
+		opcode |= MOVE_AUX_LS;
+	if (flags & WAITCOMP)
+		opcode |= MOVE_WAITCOMP;
+
+	if (!is_move_len_cmd) {
+		/* write length */
+		if (opt == MOVE_SET_LEN_16b)
+			opcode |= (length & (MOVE_OFFSET_MASK | MOVE_LEN_MASK));
+		else
+			opcode |= (length & MOVE_LEN_MASK);
+	} else {
+		/* write mrsel */
+		switch (length) {
+		case (MATH0):
+			/*
+			 * opcode |= MOVELEN_MRSEL_MATH0;
+			 * MOVELEN_MRSEL_MATH0 is 0
+			 */
+			break;
+		case (MATH1):
+			opcode |= MOVELEN_MRSEL_MATH1;
+			break;
+		case (MATH2):
+			opcode |= MOVELEN_MRSEL_MATH2;
+			break;
+		case (MATH3):
+			opcode |= MOVELEN_MRSEL_MATH3;
+			break;
+		}
+
+		/* write size */
+		if (rta_sec_era >= RTA_SEC_ERA_7) {
+			if (flags & SIZE_WORD)
+				opcode |= MOVELEN_SIZE_WORD;
+			else if (flags & SIZE_BYTE)
+				opcode |= MOVELEN_SIZE_BYTE;
+			else if (flags & SIZE_DWORD)
+				opcode |= MOVELEN_SIZE_DWORD;
+		}
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+static inline int set_move_offset(struct program *program, uint64_t src,
+				  uint16_t src_offset, uint64_t dst,
+				  uint16_t dst_offset, uint16_t *offset,
+				  uint16_t *opt)
+{
+	switch (src) {
+	case (CONTEXT1):
+	case (CONTEXT2):
+		if (dst == DESCBUF) {
+			*opt = MOVE_SET_AUX_SRC;
+			*offset = dst_offset;
+		} else if ((dst == KEY1) || (dst == KEY2)) {
+			if ((src_offset) && (dst_offset)) {
+				pr_err("MOVE: Bad offset. SEC PC: %d; Instr: %d\n",
+				       program->current_pc,
+				       program->current_instruction);
+				goto err;
+			}
+			if (dst_offset) {
+				*opt = MOVE_SET_AUX_LS;
+				*offset = dst_offset;
+			} else {
+				*offset = src_offset;
+			}
+		} else {
+			if ((dst == MATH0) || (dst == MATH1) ||
+			    (dst == MATH2) || (dst == MATH3)) {
+				*opt = MOVE_SET_AUX_MATH_DST;
+			} else if (((dst == OFIFO) || (dst == ALTSOURCE)) &&
+			    (src_offset % 4)) {
+				pr_err("MOVE: Bad offset alignment. SEC PC: %d; Instr: %d\n",
+				       program->current_pc,
+				       program->current_instruction);
+				goto err;
+			}
+
+			*offset = src_offset;
+		}
+		break;
+
+	case (OFIFO):
+		if (dst == OFIFO) {
+			pr_err("MOVE: Invalid DST. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		if (((dst == IFIFOAB1) || (dst == IFIFOAB2) ||
+		     (dst == IFIFO) || (dst == PKA)) &&
+		    (src_offset || dst_offset)) {
+			pr_err("MOVE: Offset should be zero. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		*offset = dst_offset;
+		break;
+
+	case (DESCBUF):
+		if ((dst == CONTEXT1) || (dst == CONTEXT2)) {
+			*opt = MOVE_SET_AUX_DST;
+		} else if ((dst == MATH0) || (dst == MATH1) ||
+			   (dst == MATH2) || (dst == MATH3)) {
+			*opt = MOVE_SET_AUX_MATH_DST;
+		} else if (dst == DESCBUF) {
+			pr_err("MOVE: Invalid DST. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		} else if (((dst == OFIFO) || (dst == ALTSOURCE)) &&
+		    (src_offset % 4)) {
+			pr_err("MOVE: Invalid offset alignment. SEC PC: %d; Instr %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+
+		*offset = src_offset;
+		break;
+
+	case (MATH0):
+	case (MATH1):
+	case (MATH2):
+	case (MATH3):
+		if ((dst == OFIFO) || (dst == ALTSOURCE)) {
+			if (src_offset % 4) {
+				pr_err("MOVE: Bad offset alignment. SEC PC: %d; Instr: %d\n",
+				       program->current_pc,
+				       program->current_instruction);
+				goto err;
+			}
+			*offset = src_offset;
+		} else if ((dst == IFIFOAB1) || (dst == IFIFOAB2) ||
+			   (dst == IFIFO) || (dst == PKA)) {
+			*offset = src_offset;
+		} else {
+			*offset = dst_offset;
+
+			/*
+			 * This condition is basically the negation of:
+			 * dst in { CONTEXT[1-2], MATH[0-3] }
+			 */
+			if ((dst != KEY1) && (dst != KEY2))
+				*opt = MOVE_SET_AUX_MATH_SRC;
+		}
+		break;
+
+	case (IFIFOABD):
+	case (IFIFOAB1):
+	case (IFIFOAB2):
+	case (ABD):
+	case (AB1):
+	case (AB2):
+		if ((dst == IFIFOAB1) || (dst == IFIFOAB2) ||
+		    (dst == IFIFO) || (dst == PKA) || (dst == ALTSOURCE)) {
+			pr_err("MOVE: Bad DST. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		} else {
+			if (dst == OFIFO) {
+				*opt = MOVE_SET_LEN_16b;
+			} else {
+				if (dst_offset % 4) {
+					pr_err("MOVE: Bad offset alignment. SEC PC: %d; Instr: %d\n",
+					       program->current_pc,
+					       program->current_instruction);
+					goto err;
+				}
+				*offset = dst_offset;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+ err:
+	return -EINVAL;
+}
+
+static inline int math_offset(uint16_t offset)
+{
+	switch (offset) {
+	case 0:
+		return 0;
+	case 4:
+		return MOVE_AUX_LS;
+	case 6:
+		return MOVE_AUX_MS;
+	case 7:
+		return MOVE_AUX_LS | MOVE_AUX_MS;
+	}
+
+	return -EINVAL;
+}
+
+#endif /* __RTA_MOVE_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/nfifo_cmd.h b/drivers/crypto/caam/flib/rta/nfifo_cmd.h
new file mode 100644
index 000000000000..899796929e1b
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/nfifo_cmd.h
@@ -0,0 +1,157 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_NFIFO_CMD_H__
+#define __RTA_NFIFO_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static const uint32_t nfifo_src[][2] = {
+/*1*/	{ IFIFO,       NFIFOENTRY_STYPE_DFIFO },
+	{ OFIFO,       NFIFOENTRY_STYPE_OFIFO },
+	{ PAD,         NFIFOENTRY_STYPE_PAD },
+/*4*/	{ MSGOUTSNOOP, NFIFOENTRY_STYPE_SNOOP | NFIFOENTRY_DEST_BOTH },
+/*5*/	{ ALTSOURCE,   NFIFOENTRY_STYPE_ALTSOURCE },
+	{ OFIFO_SYNC,  NFIFOENTRY_STYPE_OFIFO_SYNC },
+/*7*/	{ MSGOUTSNOOP_ALT, NFIFOENTRY_STYPE_SNOOP_ALT | NFIFOENTRY_DEST_BOTH }
+};
+
+/*
+ * Allowed NFIFO LOAD sources for each SEC Era.
+ * Values represent the number of entries from nfifo_src[] that are supported.
+ */
+static const unsigned nfifo_src_sz[] = {4, 5, 5, 5, 5, 5, 5, 7};
+
+static const uint32_t nfifo_data[][2] = {
+	{ MSG,   NFIFOENTRY_DTYPE_MSG },
+	{ MSG1,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_MSG },
+	{ MSG2,  NFIFOENTRY_DEST_CLASS2 | NFIFOENTRY_DTYPE_MSG },
+	{ IV1,   NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_IV },
+	{ IV2,   NFIFOENTRY_DEST_CLASS2 | NFIFOENTRY_DTYPE_IV },
+	{ ICV1,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_ICV },
+	{ ICV2,  NFIFOENTRY_DEST_CLASS2 | NFIFOENTRY_DTYPE_ICV },
+	{ SAD1,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_SAD },
+	{ AAD1,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_AAD },
+	{ AAD2,  NFIFOENTRY_DEST_CLASS2 | NFIFOENTRY_DTYPE_AAD },
+	{ AFHA_SBOX, NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_SBOX },
+	{ SKIP,  NFIFOENTRY_DTYPE_SKIP },
+	{ PKE,   NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_E },
+	{ PKN,   NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_N },
+	{ PKA,   NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_A },
+	{ PKA0,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_A0 },
+	{ PKA1,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_A1 },
+	{ PKA2,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_A2 },
+	{ PKA3,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_A3 },
+	{ PKB,   NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_B },
+	{ PKB0,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_B0 },
+	{ PKB1,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_B1 },
+	{ PKB2,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_B2 },
+	{ PKB3,  NFIFOENTRY_DEST_CLASS1 | NFIFOENTRY_DTYPE_PK_B3 },
+	{ AB1,   NFIFOENTRY_DEST_CLASS1 },
+	{ AB2,   NFIFOENTRY_DEST_CLASS2 },
+	{ ABD,   NFIFOENTRY_DEST_DECO }
+};
+
+static const uint32_t nfifo_flags[][2] = {
+/*1*/	{ LAST1,         NFIFOENTRY_LC1 },
+	{ LAST2,         NFIFOENTRY_LC2 },
+	{ FLUSH1,        NFIFOENTRY_FC1 },
+	{ BP,            NFIFOENTRY_BND },
+	{ PAD_ZERO,      NFIFOENTRY_PTYPE_ZEROS },
+	{ PAD_NONZERO,   NFIFOENTRY_PTYPE_RND_NOZEROS },
+	{ PAD_INCREMENT, NFIFOENTRY_PTYPE_INCREMENT },
+	{ PAD_RANDOM,    NFIFOENTRY_PTYPE_RND },
+	{ PAD_ZERO_N1,   NFIFOENTRY_PTYPE_ZEROS_NZ },
+	{ PAD_NONZERO_0, NFIFOENTRY_PTYPE_RND_NZ_LZ },
+	{ PAD_N1,        NFIFOENTRY_PTYPE_N },
+/*12*/	{ PAD_NONZERO_N, NFIFOENTRY_PTYPE_RND_NZ_N },
+	{ FLUSH2,        NFIFOENTRY_FC2 },
+	{ OC,            NFIFOENTRY_OC }
+};
+
+/*
+ * Allowed NFIFO LOAD flags for each SEC Era.
+ * Values represent the number of entries from nfifo_flags[] that are supported.
+ */
+static const unsigned nfifo_flags_sz[] = {12, 14, 14, 14, 14, 14, 14, 14};
+
+static const uint32_t nfifo_pad_flags[][2] = {
+	{ BM, NFIFOENTRY_BM },
+	{ PS, NFIFOENTRY_PS },
+	{ PR, NFIFOENTRY_PR }
+};
+
+/*
+ * Allowed NFIFO LOAD pad flags for each SEC Era.
+ * Values represent the number of entries from nfifo_pad_flags[] that are
+ * supported.
+ */
+static const unsigned nfifo_pad_flags_sz[] = {2, 2, 2, 2, 3, 3, 3, 3};
+
+static inline int rta_nfifo_load(struct program *program, uint32_t src,
+				 uint32_t data, uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = 0, val;
+	int ret = -EINVAL;
+	uint32_t load_cmd = CMD_LOAD | LDST_IMM | LDST_CLASS_IND_CCB |
+			    LDST_SRCDST_WORD_INFO_FIFO;
+	unsigned start_pc = program->current_pc;
+
+	if ((data == AFHA_SBOX) && (rta_sec_era == RTA_SEC_ERA_7)) {
+		pr_err("NFIFO: AFHA S-box not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+
+	/* write source field */
+	ret = __rta_map_opcode(src, nfifo_src, nfifo_src_sz[rta_sec_era], &val);
+	if (ret < 0) {
+		pr_err("NFIFO: Invalid SRC. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	opcode |= val;
+
+	/* write type field */
+	ret = __rta_map_opcode(data, nfifo_data, ARRAY_SIZE(nfifo_data), &val);
+	if (ret < 0) {
+		pr_err("NFIFO: Invalid data. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	opcode |= val;
+
+	/* write DL field */
+	if (!(flags & EXT)) {
+		opcode |= length & NFIFOENTRY_DLEN_MASK;
+		load_cmd |= 4;
+	} else {
+		load_cmd |= 8;
+	}
+
+	/* write flags */
+	__rta_map_flags(flags, nfifo_flags, nfifo_flags_sz[rta_sec_era],
+			&opcode);
+
+	/* in case of padding, check the destination */
+	if (src == PAD)
+		__rta_map_flags(flags, nfifo_pad_flags,
+				nfifo_pad_flags_sz[rta_sec_era], &opcode);
+
+	/* write LOAD command first */
+	__rta_out32(program, load_cmd);
+	__rta_out32(program, opcode);
+
+	if (flags & EXT)
+		__rta_out32(program, length & NFIFOENTRY_DLEN_MASK);
+
+	program->current_instruction++;
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_NFIFO_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/operation_cmd.h b/drivers/crypto/caam/flib/rta/operation_cmd.h
new file mode 100644
index 000000000000..bade9dfdd52e
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/operation_cmd.h
@@ -0,0 +1,545 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_OPERATION_CMD_H__
+#define __RTA_OPERATION_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static inline int __rta_alg_aai_aes(uint16_t aai)
+{
+	uint16_t aes_mode = aai & OP_ALG_AESA_MODE_MASK;
+
+	if (aai & OP_ALG_AAI_C2K) {
+		if (rta_sec_era < RTA_SEC_ERA_5)
+			return -1;
+		if ((aes_mode != OP_ALG_AAI_CCM) &&
+		    (aes_mode != OP_ALG_AAI_GCM))
+			return -EINVAL;
+	}
+
+	switch (aes_mode) {
+	case OP_ALG_AAI_CBC_CMAC:
+	case OP_ALG_AAI_CTR_CMAC_LTE:
+	case OP_ALG_AAI_CTR_CMAC:
+		if (rta_sec_era < RTA_SEC_ERA_2)
+			return -EINVAL;
+		/* no break */
+	case OP_ALG_AAI_CTR:
+	case OP_ALG_AAI_CBC:
+	case OP_ALG_AAI_ECB:
+	case OP_ALG_AAI_OFB:
+	case OP_ALG_AAI_CFB:
+	case OP_ALG_AAI_XTS:
+	case OP_ALG_AAI_CMAC:
+	case OP_ALG_AAI_XCBC_MAC:
+	case OP_ALG_AAI_CCM:
+	case OP_ALG_AAI_GCM:
+	case OP_ALG_AAI_CBC_XCBCMAC:
+	case OP_ALG_AAI_CTR_XCBCMAC:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_des(uint16_t aai)
+{
+	uint16_t aai_code = (uint16_t)(aai & ~OP_ALG_AAI_CHECKODD);
+
+	switch (aai_code) {
+	case OP_ALG_AAI_CBC:
+	case OP_ALG_AAI_ECB:
+	case OP_ALG_AAI_CFB:
+	case OP_ALG_AAI_OFB:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_md5(uint16_t aai)
+{
+	switch (aai) {
+	case OP_ALG_AAI_HMAC:
+		if (rta_sec_era < RTA_SEC_ERA_2)
+			return -EINVAL;
+		/* no break */
+	case OP_ALG_AAI_SMAC:
+	case OP_ALG_AAI_HASH:
+	case OP_ALG_AAI_HMAC_PRECOMP:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_sha(uint16_t aai)
+{
+	switch (aai) {
+	case OP_ALG_AAI_HMAC:
+		if (rta_sec_era < RTA_SEC_ERA_2)
+			return -EINVAL;
+		/* no break */
+	case OP_ALG_AAI_HASH:
+	case OP_ALG_AAI_HMAC_PRECOMP:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_rng(uint16_t aai)
+{
+	uint16_t rng_mode = aai & OP_ALG_RNG_MODE_MASK;
+	uint16_t rng_sh = aai & OP_ALG_AAI_RNG4_SH_MASK;
+
+	switch (rng_mode) {
+	case OP_ALG_AAI_RNG:
+	case OP_ALG_AAI_RNG_NZB:
+	case OP_ALG_AAI_RNG_OBP:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* State Handle bits are valid only for SEC Era >= 5 */
+	if ((rta_sec_era < RTA_SEC_ERA_5) && rng_sh)
+		return -EINVAL;
+
+	/* PS, AI, SK bits are also valid only for SEC Era >= 5 */
+	if ((rta_sec_era < RTA_SEC_ERA_5) && (aai &
+	     (OP_ALG_AAI_RNG4_PS | OP_ALG_AAI_RNG4_AI | OP_ALG_AAI_RNG4_SK)))
+		return -EINVAL;
+
+	switch (rng_sh) {
+	case OP_ALG_AAI_RNG4_SH_0:
+	case OP_ALG_AAI_RNG4_SH_1:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_crc(uint16_t aai)
+{
+	uint16_t aai_code = aai & OP_ALG_CRC_POLY_MASK;
+
+	switch (aai_code) {
+	case OP_ALG_AAI_802:
+	case OP_ALG_AAI_3385:
+	case OP_ALG_AAI_CUST_POLY:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_kasumi(uint16_t aai)
+{
+	switch (aai) {
+	case OP_ALG_AAI_GSM:
+	case OP_ALG_AAI_EDGE:
+	case OP_ALG_AAI_F8:
+	case OP_ALG_AAI_F9:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_snow_f9(uint16_t aai)
+{
+	if (aai == OP_ALG_AAI_F9)
+		return 0;
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_snow_f8(uint16_t aai)
+{
+	if (aai == OP_ALG_AAI_F8)
+		return 0;
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_zuce(uint16_t aai)
+{
+	if (aai == OP_ALG_AAI_F8)
+		return 0;
+
+	return -EINVAL;
+}
+
+static inline int __rta_alg_aai_zuca(uint16_t aai)
+{
+	if (aai == OP_ALG_AAI_F9)
+		return 0;
+
+	return -EINVAL;
+}
+
+struct alg_aai_map {
+	uint32_t chipher_algo;
+	int (*aai_func)(uint16_t);
+	uint32_t class;
+};
+
+static const struct alg_aai_map alg_table[] = {
+/*1*/	{ OP_ALG_ALGSEL_AES,      __rta_alg_aai_aes,    OP_TYPE_CLASS1_ALG },
+	{ OP_ALG_ALGSEL_DES,      __rta_alg_aai_des,    OP_TYPE_CLASS1_ALG },
+	{ OP_ALG_ALGSEL_3DES,     __rta_alg_aai_des,    OP_TYPE_CLASS1_ALG },
+	{ OP_ALG_ALGSEL_MD5,      __rta_alg_aai_md5,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_SHA1,     __rta_alg_aai_md5,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_SHA224,   __rta_alg_aai_sha,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_SHA256,   __rta_alg_aai_sha,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_SHA384,   __rta_alg_aai_sha,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_SHA512,   __rta_alg_aai_sha,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_RNG,      __rta_alg_aai_rng,    OP_TYPE_CLASS1_ALG },
+/*11*/	{ OP_ALG_ALGSEL_CRC,      __rta_alg_aai_crc,    OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_ARC4,     NULL,                 OP_TYPE_CLASS1_ALG },
+	{ OP_ALG_ALGSEL_SNOW_F8,  __rta_alg_aai_snow_f8, OP_TYPE_CLASS1_ALG },
+/*14*/	{ OP_ALG_ALGSEL_KASUMI,   __rta_alg_aai_kasumi, OP_TYPE_CLASS1_ALG },
+	{ OP_ALG_ALGSEL_SNOW_F9,  __rta_alg_aai_snow_f9, OP_TYPE_CLASS2_ALG },
+	{ OP_ALG_ALGSEL_ZUCE,     __rta_alg_aai_zuce,   OP_TYPE_CLASS1_ALG },
+/*17*/	{ OP_ALG_ALGSEL_ZUCA,     __rta_alg_aai_zuca,   OP_TYPE_CLASS2_ALG }
+};
+
+/*
+ * Allowed OPERATION algorithms for each SEC Era.
+ * Values represent the number of entries from alg_table[] that are supported.
+ */
+static const unsigned alg_table_sz[] = {14, 15, 15, 15, 17, 17, 11, 17};
+
+static inline int rta_operation(struct program *program, uint32_t cipher_algo,
+				uint16_t aai, uint8_t algo_state,
+				int icv_checking, int enc)
+{
+	uint32_t opcode = CMD_OPERATION;
+	unsigned i, found = 0;
+	unsigned start_pc = program->current_pc;
+	int ret;
+
+	for (i = 0; i < alg_table_sz[rta_sec_era]; i++) {
+		if (alg_table[i].chipher_algo == cipher_algo) {
+			opcode |= cipher_algo | alg_table[i].class;
+			/* nothing else to verify */
+			if (alg_table[i].aai_func == NULL) {
+				found = 1;
+				break;
+			}
+
+			aai &= OP_ALG_AAI_MASK;
+
+			ret = (*alg_table[i].aai_func)(aai);
+			if (ret < 0) {
+				pr_err("OPERATION: Bad AAI Type. SEC Program Line: %d\n",
+				       program->current_pc);
+				goto err;
+			}
+			opcode |= aai;
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		pr_err("OPERATION: Invalid Command. SEC Program Line: %d\n",
+		       program->current_pc);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (algo_state) {
+	case OP_ALG_AS_UPDATE:
+	case OP_ALG_AS_INIT:
+	case OP_ALG_AS_FINALIZE:
+	case OP_ALG_AS_INITFINAL:
+		opcode |= algo_state;
+		break;
+	default:
+		pr_err("Invalid Operation Command\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (icv_checking) {
+	case ICV_CHECK_DISABLE:
+		/*
+		 * opcode |= OP_ALG_ICV_OFF;
+		 * OP_ALG_ICV_OFF is 0
+		 */
+		break;
+	case ICV_CHECK_ENABLE:
+		opcode |= OP_ALG_ICV_ON;
+		break;
+	default:
+		pr_err("Invalid Operation Command\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (enc) {
+	case DIR_DEC:
+		/*
+		 * opcode |= OP_ALG_DECRYPT;
+		 * OP_ALG_DECRYPT is 0
+		 */
+		break;
+	case DIR_ENC:
+		opcode |= OP_ALG_ENCRYPT;
+		break;
+	default:
+		pr_err("Invalid Operation Command\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	return ret;
+}
+
+/*
+ * OPERATION PKHA routines
+ */
+static inline int __rta_pkha_clearmem(uint32_t pkha_op)
+{
+	switch (pkha_op) {
+	case (OP_ALG_PKMODE_CLEARMEM_ALL):
+	case (OP_ALG_PKMODE_CLEARMEM_ABE):
+	case (OP_ALG_PKMODE_CLEARMEM_ABN):
+	case (OP_ALG_PKMODE_CLEARMEM_AB):
+	case (OP_ALG_PKMODE_CLEARMEM_AEN):
+	case (OP_ALG_PKMODE_CLEARMEM_AE):
+	case (OP_ALG_PKMODE_CLEARMEM_AN):
+	case (OP_ALG_PKMODE_CLEARMEM_A):
+	case (OP_ALG_PKMODE_CLEARMEM_BEN):
+	case (OP_ALG_PKMODE_CLEARMEM_BE):
+	case (OP_ALG_PKMODE_CLEARMEM_BN):
+	case (OP_ALG_PKMODE_CLEARMEM_B):
+	case (OP_ALG_PKMODE_CLEARMEM_EN):
+	case (OP_ALG_PKMODE_CLEARMEM_N):
+	case (OP_ALG_PKMODE_CLEARMEM_E):
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_pkha_mod_arithmetic(uint32_t pkha_op)
+{
+	pkha_op &= (uint32_t)~OP_ALG_PKMODE_OUT_A;
+
+	switch (pkha_op) {
+	case (OP_ALG_PKMODE_MOD_ADD):
+	case (OP_ALG_PKMODE_MOD_SUB_AB):
+	case (OP_ALG_PKMODE_MOD_SUB_BA):
+	case (OP_ALG_PKMODE_MOD_MULT):
+	case (OP_ALG_PKMODE_MOD_MULT_IM):
+	case (OP_ALG_PKMODE_MOD_MULT_IM_OM):
+	case (OP_ALG_PKMODE_MOD_EXPO):
+	case (OP_ALG_PKMODE_MOD_EXPO_TEQ):
+	case (OP_ALG_PKMODE_MOD_EXPO_IM):
+	case (OP_ALG_PKMODE_MOD_EXPO_IM_TEQ):
+	case (OP_ALG_PKMODE_MOD_REDUCT):
+	case (OP_ALG_PKMODE_MOD_INV):
+	case (OP_ALG_PKMODE_MOD_MONT_CNST):
+	case (OP_ALG_PKMODE_MOD_CRT_CNST):
+	case (OP_ALG_PKMODE_MOD_GCD):
+	case (OP_ALG_PKMODE_MOD_PRIMALITY):
+	case (OP_ALG_PKMODE_MOD_SML_EXP):
+	case (OP_ALG_PKMODE_F2M_ADD):
+	case (OP_ALG_PKMODE_F2M_MUL):
+	case (OP_ALG_PKMODE_F2M_MUL_IM):
+	case (OP_ALG_PKMODE_F2M_MUL_IM_OM):
+	case (OP_ALG_PKMODE_F2M_EXP):
+	case (OP_ALG_PKMODE_F2M_EXP_TEQ):
+	case (OP_ALG_PKMODE_F2M_AMODN):
+	case (OP_ALG_PKMODE_F2M_INV):
+	case (OP_ALG_PKMODE_F2M_R2):
+	case (OP_ALG_PKMODE_F2M_GCD):
+	case (OP_ALG_PKMODE_F2M_SML_EXP):
+	case (OP_ALG_PKMODE_ECC_F2M_ADD):
+	case (OP_ALG_PKMODE_ECC_F2M_ADD_IM_OM_PROJ):
+	case (OP_ALG_PKMODE_ECC_F2M_DBL):
+	case (OP_ALG_PKMODE_ECC_F2M_DBL_IM_OM_PROJ):
+	case (OP_ALG_PKMODE_ECC_F2M_MUL):
+	case (OP_ALG_PKMODE_ECC_F2M_MUL_TEQ):
+	case (OP_ALG_PKMODE_ECC_F2M_MUL_R2):
+	case (OP_ALG_PKMODE_ECC_F2M_MUL_R2_TEQ):
+	case (OP_ALG_PKMODE_ECC_F2M_MUL_R2_PROJ):
+	case (OP_ALG_PKMODE_ECC_F2M_MUL_R2_PROJ_TEQ):
+	case (OP_ALG_PKMODE_ECC_MOD_ADD):
+	case (OP_ALG_PKMODE_ECC_MOD_ADD_IM_OM_PROJ):
+	case (OP_ALG_PKMODE_ECC_MOD_DBL):
+	case (OP_ALG_PKMODE_ECC_MOD_DBL_IM_OM_PROJ):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL_TEQ):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL_R2):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL_R2_TEQ):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL_R2_PROJ):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL_R2_PROJ_TEQ):
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_pkha_copymem(uint32_t pkha_op)
+{
+	switch (pkha_op) {
+	case (OP_ALG_PKMODE_COPY_NSZ_A0_B0):
+	case (OP_ALG_PKMODE_COPY_NSZ_A0_B1):
+	case (OP_ALG_PKMODE_COPY_NSZ_A0_B2):
+	case (OP_ALG_PKMODE_COPY_NSZ_A0_B3):
+	case (OP_ALG_PKMODE_COPY_NSZ_A1_B0):
+	case (OP_ALG_PKMODE_COPY_NSZ_A1_B1):
+	case (OP_ALG_PKMODE_COPY_NSZ_A1_B2):
+	case (OP_ALG_PKMODE_COPY_NSZ_A1_B3):
+	case (OP_ALG_PKMODE_COPY_NSZ_A2_B0):
+	case (OP_ALG_PKMODE_COPY_NSZ_A2_B1):
+	case (OP_ALG_PKMODE_COPY_NSZ_A2_B2):
+	case (OP_ALG_PKMODE_COPY_NSZ_A2_B3):
+	case (OP_ALG_PKMODE_COPY_NSZ_A3_B0):
+	case (OP_ALG_PKMODE_COPY_NSZ_A3_B1):
+	case (OP_ALG_PKMODE_COPY_NSZ_A3_B2):
+	case (OP_ALG_PKMODE_COPY_NSZ_A3_B3):
+	case (OP_ALG_PKMODE_COPY_NSZ_B0_A0):
+	case (OP_ALG_PKMODE_COPY_NSZ_B0_A1):
+	case (OP_ALG_PKMODE_COPY_NSZ_B0_A2):
+	case (OP_ALG_PKMODE_COPY_NSZ_B0_A3):
+	case (OP_ALG_PKMODE_COPY_NSZ_B1_A0):
+	case (OP_ALG_PKMODE_COPY_NSZ_B1_A1):
+	case (OP_ALG_PKMODE_COPY_NSZ_B1_A2):
+	case (OP_ALG_PKMODE_COPY_NSZ_B1_A3):
+	case (OP_ALG_PKMODE_COPY_NSZ_B2_A0):
+	case (OP_ALG_PKMODE_COPY_NSZ_B2_A1):
+	case (OP_ALG_PKMODE_COPY_NSZ_B2_A2):
+	case (OP_ALG_PKMODE_COPY_NSZ_B2_A3):
+	case (OP_ALG_PKMODE_COPY_NSZ_B3_A0):
+	case (OP_ALG_PKMODE_COPY_NSZ_B3_A1):
+	case (OP_ALG_PKMODE_COPY_NSZ_B3_A2):
+	case (OP_ALG_PKMODE_COPY_NSZ_B3_A3):
+	case (OP_ALG_PKMODE_COPY_NSZ_A_E):
+	case (OP_ALG_PKMODE_COPY_NSZ_A_N):
+	case (OP_ALG_PKMODE_COPY_NSZ_B_E):
+	case (OP_ALG_PKMODE_COPY_NSZ_B_N):
+	case (OP_ALG_PKMODE_COPY_NSZ_N_A):
+	case (OP_ALG_PKMODE_COPY_NSZ_N_B):
+	case (OP_ALG_PKMODE_COPY_NSZ_N_E):
+	case (OP_ALG_PKMODE_COPY_SSZ_A0_B0):
+	case (OP_ALG_PKMODE_COPY_SSZ_A0_B1):
+	case (OP_ALG_PKMODE_COPY_SSZ_A0_B2):
+	case (OP_ALG_PKMODE_COPY_SSZ_A0_B3):
+	case (OP_ALG_PKMODE_COPY_SSZ_A1_B0):
+	case (OP_ALG_PKMODE_COPY_SSZ_A1_B1):
+	case (OP_ALG_PKMODE_COPY_SSZ_A1_B2):
+	case (OP_ALG_PKMODE_COPY_SSZ_A1_B3):
+	case (OP_ALG_PKMODE_COPY_SSZ_A2_B0):
+	case (OP_ALG_PKMODE_COPY_SSZ_A2_B1):
+	case (OP_ALG_PKMODE_COPY_SSZ_A2_B2):
+	case (OP_ALG_PKMODE_COPY_SSZ_A2_B3):
+	case (OP_ALG_PKMODE_COPY_SSZ_A3_B0):
+	case (OP_ALG_PKMODE_COPY_SSZ_A3_B1):
+	case (OP_ALG_PKMODE_COPY_SSZ_A3_B2):
+	case (OP_ALG_PKMODE_COPY_SSZ_A3_B3):
+	case (OP_ALG_PKMODE_COPY_SSZ_B0_A0):
+	case (OP_ALG_PKMODE_COPY_SSZ_B0_A1):
+	case (OP_ALG_PKMODE_COPY_SSZ_B0_A2):
+	case (OP_ALG_PKMODE_COPY_SSZ_B0_A3):
+	case (OP_ALG_PKMODE_COPY_SSZ_B1_A0):
+	case (OP_ALG_PKMODE_COPY_SSZ_B1_A1):
+	case (OP_ALG_PKMODE_COPY_SSZ_B1_A2):
+	case (OP_ALG_PKMODE_COPY_SSZ_B1_A3):
+	case (OP_ALG_PKMODE_COPY_SSZ_B2_A0):
+	case (OP_ALG_PKMODE_COPY_SSZ_B2_A1):
+	case (OP_ALG_PKMODE_COPY_SSZ_B2_A2):
+	case (OP_ALG_PKMODE_COPY_SSZ_B2_A3):
+	case (OP_ALG_PKMODE_COPY_SSZ_B3_A0):
+	case (OP_ALG_PKMODE_COPY_SSZ_B3_A1):
+	case (OP_ALG_PKMODE_COPY_SSZ_B3_A2):
+	case (OP_ALG_PKMODE_COPY_SSZ_B3_A3):
+	case (OP_ALG_PKMODE_COPY_SSZ_A_E):
+	case (OP_ALG_PKMODE_COPY_SSZ_A_N):
+	case (OP_ALG_PKMODE_COPY_SSZ_B_E):
+	case (OP_ALG_PKMODE_COPY_SSZ_B_N):
+	case (OP_ALG_PKMODE_COPY_SSZ_N_A):
+	case (OP_ALG_PKMODE_COPY_SSZ_N_B):
+	case (OP_ALG_PKMODE_COPY_SSZ_N_E):
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int rta_pkha_operation(struct program *program, uint32_t op_pkha)
+{
+	uint32_t opcode = CMD_OPERATION | OP_TYPE_PK | OP_ALG_PK;
+	uint32_t pkha_func;
+	unsigned start_pc = program->current_pc;
+	int ret = -EINVAL;
+
+	pkha_func = op_pkha & OP_ALG_PK_FUN_MASK;
+
+	switch (pkha_func) {
+	case (OP_ALG_PKMODE_CLEARMEM):
+		ret = __rta_pkha_clearmem(op_pkha);
+		if (ret < 0) {
+			pr_err("OPERATION PKHA: Type not supported. SEC Program Line: %d\n",
+			       program->current_pc);
+			goto err;
+		}
+		break;
+	case (OP_ALG_PKMODE_MOD_ADD):
+	case (OP_ALG_PKMODE_MOD_SUB_AB):
+	case (OP_ALG_PKMODE_MOD_SUB_BA):
+	case (OP_ALG_PKMODE_MOD_MULT):
+	case (OP_ALG_PKMODE_MOD_EXPO):
+	case (OP_ALG_PKMODE_MOD_REDUCT):
+	case (OP_ALG_PKMODE_MOD_INV):
+	case (OP_ALG_PKMODE_MOD_MONT_CNST):
+	case (OP_ALG_PKMODE_MOD_CRT_CNST):
+	case (OP_ALG_PKMODE_MOD_GCD):
+	case (OP_ALG_PKMODE_MOD_PRIMALITY):
+	case (OP_ALG_PKMODE_MOD_SML_EXP):
+	case (OP_ALG_PKMODE_ECC_MOD_ADD):
+	case (OP_ALG_PKMODE_ECC_MOD_DBL):
+	case (OP_ALG_PKMODE_ECC_MOD_MUL):
+		ret = __rta_pkha_mod_arithmetic(op_pkha);
+		if (ret < 0) {
+			pr_err("OPERATION PKHA: Type not supported. SEC Program Line: %d\n",
+			       program->current_pc);
+			goto err;
+		}
+		break;
+	case (OP_ALG_PKMODE_COPY_NSZ):
+	case (OP_ALG_PKMODE_COPY_SSZ):
+		ret = __rta_pkha_copymem(op_pkha);
+		if (ret < 0) {
+			pr_err("OPERATION PKHA: Type not supported. SEC Program Line: %d\n",
+			       program->current_pc);
+			goto err;
+		}
+		break;
+	default:
+		pr_err("Invalid Operation Command\n");
+		goto err;
+	}
+
+	opcode |= op_pkha;
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_OPERATION_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h b/drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h
new file mode 100644
index 000000000000..ccb70a71b394
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/seq_in_out_ptr_cmd.h
@@ -0,0 +1,168 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_SEQ_IN_OUT_PTR_CMD_H__
+#define __RTA_SEQ_IN_OUT_PTR_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+/* Allowed SEQ IN PTR flags for each SEC Era. */
+static const uint32_t seq_in_ptr_flags[] = {
+	RBS | INL | SGF | PRE | EXT | RTO,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD | SOP,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD | SOP,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD | SOP,
+	RBS | INL | SGF | PRE | EXT | RTO | RJD | SOP
+};
+
+/* Allowed SEQ OUT PTR flags for each SEC Era. */
+static const uint32_t seq_out_ptr_flags[] = {
+	SGF | PRE | EXT,
+	SGF | PRE | EXT | RTO,
+	SGF | PRE | EXT | RTO,
+	SGF | PRE | EXT | RTO,
+	SGF | PRE | EXT | RTO | RST | EWS,
+	SGF | PRE | EXT | RTO | RST | EWS,
+	SGF | PRE | EXT | RTO | RST | EWS,
+	SGF | PRE | EXT | RTO | RST | EWS
+};
+
+static inline int rta_seq_in_ptr(struct program *program, uint64_t src,
+				 uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = CMD_SEQ_IN_PTR;
+	unsigned start_pc = program->current_pc;
+	int ret = -EINVAL;
+
+	/* Parameters checking */
+	if ((flags & RTO) && (flags & PRE)) {
+		pr_err("SEQ IN PTR: Invalid usage of RTO and PRE flags\n");
+		goto err;
+	}
+	if (flags & ~seq_in_ptr_flags[rta_sec_era]) {
+		pr_err("SEQ IN PTR: Flag(s) not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+	if ((flags & INL) && (flags & RJD)) {
+		pr_err("SEQ IN PTR: Invalid usage of INL and RJD flags\n");
+		goto err;
+	}
+	if ((src) && (flags & (SOP | RTO | PRE))) {
+		pr_err("SEQ IN PTR: Invalid usage of RTO or PRE flag\n");
+		goto err;
+	}
+	if ((flags & SOP) && (flags & (RBS | PRE | RTO | EXT))) {
+		pr_err("SEQ IN PTR: Invalid usage of SOP and (RBS or PRE or RTO or EXT) flags\n");
+		goto err;
+	}
+
+	/* write flag fields */
+	if (flags & RBS)
+		opcode |= SQIN_RBS;
+	if (flags & INL)
+		opcode |= SQIN_INL;
+	if (flags & SGF)
+		opcode |= SQIN_SGF;
+	if (flags & PRE)
+		opcode |= SQIN_PRE;
+	if (flags & RTO)
+		opcode |= SQIN_RTO;
+	if (flags & RJD)
+		opcode |= SQIN_RJD;
+	if (flags & SOP)
+		opcode |= SQIN_SOP;
+	if ((length >> 16) || (flags & EXT)) {
+		if (flags & SOP) {
+			pr_err("SEQ IN PTR: Invalid usage of SOP and EXT flags\n");
+			goto err;
+		}
+
+		opcode |= SQIN_EXT;
+	} else {
+		opcode |= length & SQIN_LEN_MASK;
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	/* write pointer or immediate data field */
+	if (!(opcode & (SQIN_PRE | SQIN_RTO | SQIN_SOP)))
+		__rta_out64(program, program->ps, src);
+
+	/* write extended length field */
+	if (opcode & SQIN_EXT)
+		__rta_out32(program, length);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+static inline int rta_seq_out_ptr(struct program *program, uint64_t dst,
+				  uint32_t length, uint32_t flags)
+{
+	uint32_t opcode = CMD_SEQ_OUT_PTR;
+	unsigned start_pc = program->current_pc;
+	int ret = -EINVAL;
+
+	/* Parameters checking */
+	if (flags & ~seq_out_ptr_flags[rta_sec_era]) {
+		pr_err("SEQ OUT PTR: Flag(s) not supported by SEC Era %d\n",
+		       USER_SEC_ERA(rta_sec_era));
+		goto err;
+	}
+	if ((flags & RTO) && (flags & PRE)) {
+		pr_err("SEQ OUT PTR: Invalid usage of RTO and PRE flags\n");
+		goto err;
+	}
+	if ((dst) && (flags & (RTO | PRE))) {
+		pr_err("SEQ OUT PTR: Invalid usage of RTO or PRE flag\n");
+		goto err;
+	}
+	if ((flags & RST) && !(flags & RTO)) {
+		pr_err("SEQ OUT PTR: RST flag must be used with RTO flag\n");
+		goto err;
+	}
+
+	/* write flag fields */
+	if (flags & SGF)
+		opcode |= SQOUT_SGF;
+	if (flags & PRE)
+		opcode |= SQOUT_PRE;
+	if (flags & RTO)
+		opcode |= SQOUT_RTO;
+	if (flags & RST)
+		opcode |= SQOUT_RST;
+	if (flags & EWS)
+		opcode |= SQOUT_EWS;
+	if ((length >> 16) || (flags & EXT))
+		opcode |= SQOUT_EXT;
+	else
+		opcode |= length & SQOUT_LEN_MASK;
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	/* write pointer or immediate data field */
+	if (!(opcode & (SQOUT_PRE | SQOUT_RTO)))
+		__rta_out64(program, program->ps, dst);
+
+	/* write extended length field */
+	if (opcode & SQOUT_EXT)
+		__rta_out32(program, length);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_SEQ_IN_OUT_PTR_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/signature_cmd.h b/drivers/crypto/caam/flib/rta/signature_cmd.h
new file mode 100644
index 000000000000..c6765fba8c5e
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/signature_cmd.h
@@ -0,0 +1,36 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_SIGNATURE_CMD_H__
+#define __RTA_SIGNATURE_CMD_H__
+
+static inline int rta_signature(struct program *program, uint32_t sign_type)
+{
+	uint32_t opcode = CMD_SIGNATURE;
+	unsigned start_pc = program->current_pc;
+
+	switch (sign_type) {
+	case (SIGN_TYPE_FINAL):
+	case (SIGN_TYPE_FINAL_RESTORE):
+	case (SIGN_TYPE_FINAL_NONZERO):
+	case (SIGN_TYPE_IMM_2):
+	case (SIGN_TYPE_IMM_3):
+	case (SIGN_TYPE_IMM_4):
+		opcode |= sign_type;
+		break;
+	default:
+		pr_err("SIGNATURE Command: Invalid type selection\n");
+		goto err;
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return -EINVAL;
+}
+
+#endif /* __RTA_SIGNATURE_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/store_cmd.h b/drivers/crypto/caam/flib/rta/store_cmd.h
new file mode 100644
index 000000000000..d3edf4077a53
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/store_cmd.h
@@ -0,0 +1,145 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_STORE_CMD_H__
+#define __RTA_STORE_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static const uint32_t store_src_table[][2] = {
+/*1*/	{ KEY1SZ,       LDST_CLASS_1_CCB | LDST_SRCDST_WORD_KEYSZ_REG },
+	{ KEY2SZ,       LDST_CLASS_2_CCB | LDST_SRCDST_WORD_KEYSZ_REG },
+	{ DJQDA,        LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_JQDAR },
+	{ MODE1,        LDST_CLASS_1_CCB | LDST_SRCDST_WORD_MODE_REG },
+	{ MODE2,        LDST_CLASS_2_CCB | LDST_SRCDST_WORD_MODE_REG },
+	{ DJQCTRL,      LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_JQCTRL },
+	{ DATA1SZ,      LDST_CLASS_1_CCB | LDST_SRCDST_WORD_DATASZ_REG },
+	{ DATA2SZ,      LDST_CLASS_2_CCB | LDST_SRCDST_WORD_DATASZ_REG },
+	{ DSTAT,        LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_STAT },
+	{ ICV1SZ,       LDST_CLASS_1_CCB | LDST_SRCDST_WORD_ICVSZ_REG },
+	{ ICV2SZ,       LDST_CLASS_2_CCB | LDST_SRCDST_WORD_ICVSZ_REG },
+	{ DPID,         LDST_CLASS_DECO | LDST_SRCDST_WORD_PID },
+	{ CCTRL,        LDST_SRCDST_WORD_CHACTRL },
+	{ ICTRL,        LDST_SRCDST_WORD_IRQCTRL },
+	{ CLRW,         LDST_SRCDST_WORD_CLRW },
+	{ MATH0,        LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH0 },
+	{ CSTAT,        LDST_SRCDST_WORD_STAT },
+	{ MATH1,        LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH1 },
+	{ MATH2,        LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH2 },
+	{ AAD1SZ,       LDST_CLASS_1_CCB | LDST_SRCDST_WORD_DECO_AAD_SZ },
+	{ MATH3,        LDST_CLASS_DECO | LDST_SRCDST_WORD_DECO_MATH3 },
+	{ IV1SZ,        LDST_CLASS_1_CCB | LDST_SRCDST_WORD_CLASS1_IV_SZ },
+	{ PKASZ,        LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_A_SZ },
+	{ PKBSZ,        LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_B_SZ },
+	{ PKESZ,        LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_E_SZ },
+	{ PKNSZ,        LDST_CLASS_1_CCB | LDST_SRCDST_WORD_PKHA_N_SZ },
+	{ CONTEXT1,     LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT },
+	{ CONTEXT2,     LDST_CLASS_2_CCB | LDST_SRCDST_BYTE_CONTEXT },
+	{ DESCBUF,      LDST_CLASS_DECO | LDST_SRCDST_WORD_DESCBUF },
+/*30*/	{ JOBDESCBUF,   LDST_CLASS_DECO | LDST_SRCDST_WORD_DESCBUF_JOB },
+	{ SHAREDESCBUF, LDST_CLASS_DECO | LDST_SRCDST_WORD_DESCBUF_SHARED },
+/*32*/	{ JOBDESCBUF_EFF,   LDST_CLASS_DECO |
+		LDST_SRCDST_WORD_DESCBUF_JOB_WE },
+	{ SHAREDESCBUF_EFF, LDST_CLASS_DECO |
+		LDST_SRCDST_WORD_DESCBUF_SHARED_WE },
+/*34*/	{ GTR,          LDST_CLASS_DECO | LDST_SRCDST_WORD_GTR },
+	{ STR,          LDST_CLASS_DECO | LDST_SRCDST_WORD_STR }
+};
+
+/*
+ * Allowed STORE sources for each SEC ERA.
+ * Values represent the number of entries from source_src_table[] that are
+ * supported.
+ */
+static const unsigned store_src_table_sz[] = {29, 31, 33, 33, 33, 33, 35, 35};
+
+static inline int rta_store(struct program *program, uint64_t src,
+			    uint16_t offset, uint64_t dst, uint32_t length,
+			    uint32_t flags)
+{
+	uint32_t opcode = 0, val;
+	int ret = -EINVAL;
+	unsigned start_pc = program->current_pc;
+
+	if (flags & SEQ)
+		opcode = CMD_SEQ_STORE;
+	else
+		opcode = CMD_STORE;
+
+	/* parameters check */
+	if ((flags & IMMED) && (flags & SGF)) {
+		pr_err("STORE: Invalid flag. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+	if ((flags & IMMED) && (offset != 0)) {
+		pr_err("STORE: Invalid flag. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	if ((flags & SEQ) && ((src == JOBDESCBUF) || (src == SHAREDESCBUF) ||
+			      (src == JOBDESCBUF_EFF) ||
+			      (src == SHAREDESCBUF_EFF))) {
+		pr_err("STORE: Invalid SRC type. SEC PC: %d; Instr: %d\n",
+		       program->current_pc, program->current_instruction);
+		goto err;
+	}
+
+	if (flags & IMMED)
+		opcode |= LDST_IMM;
+
+	if ((flags & SGF) || (flags & VLF))
+		opcode |= LDST_VLF;
+
+	/*
+	 * source for data to be stored can be specified as:
+	 *    - register location; set in src field[9-15];
+	 *    - if IMMED flag is set, data is set in value field [0-31];
+	 *      user can give this value as actual value or pointer to data
+	 */
+	if (!(flags & IMMED)) {
+		ret = __rta_map_opcode((uint32_t)src, store_src_table,
+				       store_src_table_sz[rta_sec_era], &val);
+		if (ret < 0) {
+			pr_err("STORE: Invalid source. SEC PC: %d; Instr: %d\n",
+			       program->current_pc,
+			       program->current_instruction);
+			goto err;
+		}
+		opcode |= val;
+	}
+
+	/* DESC BUFFER: length / offset values are specified in 4-byte words */
+	if ((src == DESCBUF) || (src == JOBDESCBUF) || (src == SHAREDESCBUF) ||
+	    (src == JOBDESCBUF_EFF) || (src == SHAREDESCBUF_EFF)) {
+		opcode |= (length >> 2);
+		opcode |= (uint32_t)((offset >> 2) << LDST_OFFSET_SHIFT);
+	} else {
+		opcode |= length;
+		opcode |= (uint32_t)(offset << LDST_OFFSET_SHIFT);
+	}
+
+	__rta_out32(program, opcode);
+	program->current_instruction++;
+
+	if ((src == JOBDESCBUF) || (src == SHAREDESCBUF) ||
+	    (src == JOBDESCBUF_EFF) || (src == SHAREDESCBUF_EFF))
+		return (int)start_pc;
+
+	/* for STORE, a pointer to where the data will be stored if needed */
+	if (!(flags & SEQ))
+		__rta_out64(program, program->ps, dst);
+
+	/* for IMMED data, place the data here */
+	if (flags & IMMED)
+		__rta_inline_data(program, src, flags & __COPY_MASK, length);
+
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_STORE_CMD_H__ */
-- 
1.8.3.1

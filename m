From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 06/12] crypto: caam - add Run Time Library (RTA) - part 2
Date: Thu, 14 Aug 2014 15:54:28 +0300
Message-ID: <1408020874-2211-7-git-send-email-horia.geanta@freescale.com>
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
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:32681
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754655AbaHNM4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:02 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add headers defining the RTA API.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Carmen Iorga <carmen.iorga@freescale.com>
---
 drivers/crypto/caam/flib/rta.h                  | 980 ++++++++++++++++++++++++
 drivers/crypto/caam/flib/rta/protocol_cmd.h     | 595 ++++++++++++++
 drivers/crypto/caam/flib/rta/sec_run_time_asm.h | 672 ++++++++++++++++
 3 files changed, 2247 insertions(+)
 create mode 100644 drivers/crypto/caam/flib/rta.h
 create mode 100644 drivers/crypto/caam/flib/rta/protocol_cmd.h
 create mode 100644 drivers/crypto/caam/flib/rta/sec_run_time_asm.h

diff --git a/drivers/crypto/caam/flib/rta.h b/drivers/crypto/caam/flib/rta.h
new file mode 100644
index 000000000000..831163fca3bd
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta.h
@@ -0,0 +1,980 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_RTA_H__
+#define __RTA_RTA_H__
+
+#include "rta/sec_run_time_asm.h"
+#include "rta/fifo_load_store_cmd.h"
+#include "rta/header_cmd.h"
+#include "rta/jump_cmd.h"
+#include "rta/key_cmd.h"
+#include "rta/load_cmd.h"
+#include "rta/math_cmd.h"
+#include "rta/move_cmd.h"
+#include "rta/nfifo_cmd.h"
+#include "rta/operation_cmd.h"
+#include "rta/protocol_cmd.h"
+#include "rta/seq_in_out_ptr_cmd.h"
+#include "rta/signature_cmd.h"
+#include "rta/store_cmd.h"
+
+/**
+ * DOC: About
+ *
+ * RTA (Runtime Assembler) Library is an easy and flexible runtime method for
+ * writing SEC descriptors. It implements a thin abstraction layer above
+ * SEC commands set; the resulting code is compact and similar to a
+ * descriptor sequence.
+ *
+ * RTA library improves comprehension of the SEC code, adds flexibility for
+ * writing complex descriptors and keeps the code lightweight. Should be used
+ * by whom needs to encode descriptors at runtime, with comprehensible flow
+ * control in descriptor.
+ */
+
+/**
+ * DOC: Usage
+ *
+ * RTA is used in kernel space by the SEC / CAAM (Cryptographic Acceleration and
+ * Assurance Module) kernel module (drivers/crypto/caam) and SEC / CAAM QI
+ * kernel module (Freescale QorIQ SDK).
+ *
+ * RTA is used in user space by USDPAA - User Space DataPath Acceleration
+ * Architecture (Freescale QorIQ SDK).
+ */
+
+/**
+ * DOC: Descriptor Buffer Management Routines
+ *
+ * Contains details of RTA descriptor buffer management and SEC Era
+ * management routines.
+ */
+
+/**
+ * PROGRAM_CNTXT_INIT - must be called before any descriptor run-time assembly
+ *                      call type field carry info i.e. whether descriptor is
+ *                      shared or job descriptor.
+ * @program: pointer to struct program
+ * @buffer: input buffer where the descriptor will be placed (uint32_t *)
+ * @offset: offset in input buffer from where the data will be written
+ *          (unsigned)
+ */
+#define PROGRAM_CNTXT_INIT(program, buffer, offset) \
+	rta_program_cntxt_init(program, buffer, offset)
+
+/**
+ * PROGRAM_FINALIZE - must be called to mark completion of RTA call.
+ * @program: pointer to struct program
+ *
+ * Return: total size of the descriptor in words (unsigned).
+ */
+#define PROGRAM_FINALIZE(program) rta_program_finalize(program)
+
+/**
+ * PROGRAM_SET_36BIT_ADDR - must be called to set pointer size to 36 bits
+ * @program: pointer to struct program
+ *
+ * Return: current size of the descriptor in words (unsigned).
+ */
+#define PROGRAM_SET_36BIT_ADDR(program) rta_program_set_36bit_addr(program)
+
+/**
+ * PROGRAM_SET_BSWAP - must be called to enable byte swapping
+ * @program: pointer to struct program
+ *
+ * Byte swapping on a 4-byte boundary will be performed at the end - when
+ * calling PROGRAM_FINALIZE().
+ *
+ * Return: current size of the descriptor in words (unsigned).
+ */
+#define PROGRAM_SET_BSWAP(program) rta_program_set_bswap(program)
+
+/**
+ * WORD - must be called to insert in descriptor buffer a 32bit value
+ * @program: pointer to struct program
+ * @val: input value to be written in descriptor buffer (uint32_t)
+ *
+ * Return: the descriptor buffer offset where this command is inserted
+ * (unsigned).
+ */
+#define WORD(program, val) rta_word(program, val)
+
+/**
+ * DWORD - must be called to insert in descriptor buffer a 64bit value
+ * @program: pointer to struct program
+ * @val: input value to be written in descriptor buffer (uint64_t)
+ *
+ * Return: the descriptor buffer offset where this command is inserted
+ * (unsigned).
+ */
+#define DWORD(program, val) rta_dword(program, val)
+
+/**
+ * COPY_DATA - must be called to insert in descriptor buffer data larger than
+ *             64bits.
+ * @program: pointer to struct program
+ * @data: input data to be written in descriptor buffer (uint8_t *)
+ * @len: length of input data (unsigned)
+ *
+ * Return: the descriptor buffer offset where this command is inserted
+ * (unsigned).
+ */
+#define COPY_DATA(program, data, len) rta_copy_data(program, (data), (len))
+
+/**
+ * DESC_LEN -  determines job / shared descriptor buffer length (in words)
+ * @buffer: descriptor buffer (uint32_t *)
+ *
+ * Return: descriptor buffer length in words (unsigned).
+ */
+#define DESC_LEN(buffer) rta_desc_len(buffer)
+
+/**
+ * DESC_BYTES - determines job / shared descriptor buffer length (in bytes)
+ * @buffer: descriptor buffer (uint32_t *)
+ *
+ * Return: descriptor buffer length in bytes (unsigned).
+ */
+#define DESC_BYTES(buffer) rta_desc_bytes(buffer)
+
+/*
+ * SEC HW block revision.
+ *
+ * This *must not be confused with SEC version*:
+ * - SEC HW block revision format is "v"
+ * - SEC revision format is "x.y"
+ */
+extern enum rta_sec_era rta_sec_era;
+
+/**
+ * rta_set_sec_era - Set SEC Era HW block revision for which the RTA library
+ *                   will generate the descriptors.
+ * @era: SEC Era (enum rta_sec_era)
+ *
+ * Return: 0 if the ERA was set successfully, -1 otherwise (int)
+ *
+ * Warning 1: Must be called *only once*, *before* using any other RTA API
+ * routine.
+ *
+ * Warning 2: *Not thread safe*.
+ */
+static inline int rta_set_sec_era(enum rta_sec_era era)
+{
+	if (era > MAX_SEC_ERA) {
+		rta_sec_era = DEFAULT_SEC_ERA;
+		pr_err("Unsupported SEC ERA. Defaulting to ERA %d\n",
+		       DEFAULT_SEC_ERA + 1);
+		return -1;
+	}
+
+	rta_sec_era = era;
+	return 0;
+}
+
+/**
+ * rta_get_sec_era - Get SEC Era HW block revision for which the RTA library
+ *                   will generate the descriptors.
+ *
+ * Return: SEC Era (unsigned).
+ */
+static inline unsigned rta_get_sec_era(void)
+{
+	 return rta_sec_era;
+}
+
+/**
+ * DOC: SEC Commands Routines
+ *
+ * Contains details of RTA wrapper routines over SEC engine commands.
+ */
+
+/**
+ * SHR_HDR - Configures Shared Descriptor HEADER command
+ * @program: pointer to struct program
+ * @share: descriptor share state (enum rta_share_type)
+ * @start_idx: index in descriptor buffer where the execution of the shared
+ *             descriptor should start (@c unsigned).
+ * @flags: operational flags: RIF, DNR, CIF, SC, PD
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SHR_HDR(program, share, start_idx, flags) \
+	rta_shr_header(program, share, start_idx, flags)
+
+/**
+ * JOB_HDR - Configures JOB Descriptor HEADER command
+ * @program: pointer to struct program
+ * @share: descriptor share state (enum rta_share_type)
+ * @start_idx: index in descriptor buffer where the execution of the job
+ *             descriptor should start (unsigned). In case SHR bit is present
+ *             in flags, this will be the shared descriptor length.
+ * @share_desc: pointer to shared descriptor, in case SHR bit is set (uint64_t)
+ * @flags: operational flags: RSMS, DNR, TD, MTD, REO, SHR
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define JOB_HDR(program, share, start_idx, share_desc, flags) \
+	rta_job_header(program, share, start_idx, share_desc, flags, 0)
+
+/**
+ * JOB_HDR_EXT - Configures JOB Descriptor HEADER command
+ * @program: pointer to struct program
+ * @share: descriptor share state (enum rta_share_type)
+ * @start_idx: index in descriptor buffer where the execution of the job
+ *             descriptor should start (unsigned). In case SHR bit is present
+ *             in flags, this will be the shared descriptor length.
+ * @share_desc: pointer to shared descriptor, in case SHR bit is set (uint64_t)
+ * @flags: operational flags: RSMS, DNR, TD, MTD, REO, SHR
+ * @ext_flags: extended header flags: DSV (DECO Select Valid), DECO Id (limited
+ *             by DSEL_MASK).
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define JOB_HDR_EXT(program, share, start_idx, share_desc, flags, ext_flags) \
+	rta_job_header(program, share, start_idx, share_desc, flags | EXT, \
+		       ext_flags)
+
+/**
+ * MOVE - Configures MOVE and MOVE_LEN commands
+ * @program: pointer to struct program
+ * @src: internal source of data that will be moved: CONTEXT1, CONTEXT2, OFIFO,
+ *       DESCBUF, MATH0-MATH3, IFIFOABD, IFIFOAB1, IFIFOAB2, AB1, AB2, ABD.
+ * @src_offset: offset in source data (uint16_t)
+ * @dst: internal destination of data that will be moved: CONTEXT1, CONTEXT2,
+ *       OFIFO, DESCBUF, MATH0-MATH3, IFIFOAB1, IFIFOAB2, IFIFO, PKA, KEY1,
+ *       KEY2, ALTSOURCE.
+ * @dst_offset: offset in destination data (uint16_t)
+ * @length: size of data to be moved: for MOVE must be specified as immediate
+ *          value and IMMED flag must be set; for MOVE_LEN must be specified
+ *          using MATH0-MATH3.
+ * @opt: operational flags: WAITCOMP, FLUSH1, FLUSH2, LAST1, LAST2, SIZE_WORD,
+ *       SIZE_BYTE, SIZE_DWORD, IMMED (not valid for MOVE_LEN).
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define MOVE(program, src, src_offset, dst, dst_offset, length, opt) \
+	rta_move(program, __MOVE, src, src_offset, dst, dst_offset, length, opt)
+
+/**
+ * MOVEB - Configures MOVEB command
+ * @program: pointer to struct program
+ * @src: internal source of data that will be moved: CONTEXT1, CONTEXT2, OFIFO,
+ *       DESCBUF, MATH0-MATH3, IFIFOABD, IFIFOAB1, IFIFOAB2, AB1, AB2, ABD.
+ * @src_offset: offset in source data (uint16_t)
+ * @dst: internal destination of data that will be moved: CONTEXT1, CONTEXT2,
+ *       OFIFO, DESCBUF, MATH0-MATH3, IFIFOAB1, IFIFOAB2, IFIFO, PKA, KEY1,
+ *       KEY2, ALTSOURCE.
+ * @dst_offset: offset in destination data (uint16_t)
+ * @length: size of data to be moved: for MOVE must be specified as immediate
+ *          value and IMMED flag must be set; for MOVE_LEN must be specified
+ *          using MATH0-MATH3.
+ * @opt: operational flags: WAITCOMP, FLUSH1, FLUSH2, LAST1, LAST2, SIZE_WORD,
+ *       SIZE_BYTE, SIZE_DWORD, IMMED (not valid for MOVE_LEN).
+ *
+ * Identical with MOVE command if byte swapping not enabled; else - when src/dst
+ * is descriptor buffer or MATH registers, data type is byte array when MOVE
+ * data type is 4-byte array and vice versa.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define MOVEB(program, src, src_offset, dst, dst_offset, length, opt) \
+	rta_move(program, __MOVEB, src, src_offset, dst, dst_offset, length, \
+		 opt)
+
+/**
+ * MOVEDW - Configures MOVEDW command
+ * @program: pointer to struct program
+ * @src: internal source of data that will be moved: CONTEXT1, CONTEXT2, OFIFO,
+ *       DESCBUF, MATH0-MATH3, IFIFOABD, IFIFOAB1, IFIFOAB2, AB1, AB2, ABD.
+ * @src_offset: offset in source data (uint16_t)
+ * @dst: internal destination of data that will be moved: CONTEXT1, CONTEXT2,
+ *       OFIFO, DESCBUF, MATH0-MATH3, IFIFOAB1, IFIFOAB2, IFIFO, PKA, KEY1,
+ *       KEY2, ALTSOURCE.
+ * @dst_offset: offset in destination data (uint16_t)
+ * @length: size of data to be moved: for MOVE must be specified as immediate
+ *          value and IMMED flag must be set; for MOVE_LEN must be specified
+ *          using MATH0-MATH3.
+ * @opt: operational flags: WAITCOMP, FLUSH1, FLUSH2, LAST1, LAST2, SIZE_WORD,
+ *       SIZE_BYTE, SIZE_DWORD, IMMED (not valid for MOVE_LEN).
+ *
+ * Identical with MOVE command, with the following differences: data type is
+ * 8-byte array; word swapping is performed when SEC is programmed in little
+ * endian mode.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define MOVEDW(program, src, src_offset, dst, dst_offset, length, opt) \
+	rta_move(program, __MOVEDW, src, src_offset, dst, dst_offset, length, \
+		 opt)
+
+/**
+ * FIFOLOAD - Configures FIFOLOAD command to load message data, PKHA data, IV,
+ *            ICV, AAD and bit length message data into Input Data FIFO.
+ * @program: pointer to struct program
+ * @data: input data type to store: PKHA registers, IFIFO, MSG1, MSG2,
+ *        MSGOUTSNOOP, MSGINSNOOP, IV1, IV2, AAD1, ICV1, ICV2, BIT_DATA, SKIP.
+ * @src: pointer or actual data in case of immediate load; IMMED, COPY and DCOPY
+ *       flags indicate action taken (inline imm data, inline ptr, inline from
+ *       ptr).
+ * @length: number of bytes to load (uint32_t)
+ * @flags: operational flags: SGF, IMMED, EXT, CLASS1, CLASS2, BOTH, FLUSH1,
+ *         LAST1, LAST2, COPY, DCOPY.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define FIFOLOAD(program, data, src, length, flags) \
+	rta_fifo_load(program, data, src, length, flags)
+
+/**
+ * SEQFIFOLOAD - Configures SEQ FIFOLOAD command to load message data, PKHA
+ *               data, IV, ICV, AAD and bit length message data into Input Data
+ *               FIFO.
+ * @program: pointer to struct program
+ * @data: input data type to store: PKHA registers, IFIFO, MSG1, MSG2,
+ *        MSGOUTSNOOP, MSGINSNOOP, IV1, IV2, AAD1, ICV1, ICV2, BIT_DATA, SKIP.
+ * @length: number of bytes to load; can be set to 0 for SEQ command w/ VLF set
+ *          (uint32_t).
+ * @flags: operational flags: VLF, CLASS1, CLASS2, BOTH, FLUSH1, LAST1, LAST2,
+ *         AIDF.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SEQFIFOLOAD(program, data, length, flags) \
+	rta_fifo_load(program, data, NONE, length, flags|SEQ)
+
+/**
+ * FIFOSTORE - Configures FIFOSTORE command, to move data from Output Data FIFO
+ *             to external memory via DMA.
+ * @program: pointer to struct program
+ * @data: output data type to store: PKHA registers, IFIFO, OFIFO, RNG,
+ *        RNGOFIFO, AFHA_SBOX, MDHA_SPLIT_KEY, MSG, KEY1, KEY2, SKIP.
+ * @encrypt_flags: store data encryption mode: EKT, TK
+ * @dst: pointer to store location (uint64_t)
+ * @length: number of bytes to load (uint32_t)
+ * @flags: operational flags: SGF, CONT, EXT, CLASS1, CLASS2, BOTH
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define FIFOSTORE(program, data, encrypt_flags, dst, length, flags) \
+	rta_fifo_store(program, data, encrypt_flags, dst, length, flags)
+
+/**
+ * SEQFIFOSTORE - Configures SEQ FIFOSTORE command, to move data from Output
+ *                Data FIFO to external memory via DMA.
+ * @program: pointer to struct program
+ * @data: output data type to store: PKHA registers, IFIFO, OFIFO, RNG,
+ *        RNGOFIFO, AFHA_SBOX, MDHA_SPLIT_KEY, MSG, KEY1, KEY2, METADATA, SKIP.
+ * @encrypt_flags: store data encryption mode: EKT, TK
+ * @length: number of bytes to load; can be set to 0 for SEQ command w/ VLF set
+ *          (uint32_t).
+ * @flags: operational flags: VLF, CONT, EXT, CLASS1, CLASS2, BOTH
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SEQFIFOSTORE(program, data, encrypt_flags, length, flags) \
+	rta_fifo_store(program, data, encrypt_flags, 0, length, flags|SEQ)
+
+/**
+ * KEY - Configures KEY and SEQ KEY commands
+ * @program: pointer to struct program
+ * @key_dst: key store location: KEY1, KEY2, PKE, AFHA_SBOX, MDHA_SPLIT_KEY
+ * @encrypt_flags: key encryption mode: ENC, EKT, TK, NWB, PTS
+ * @src: pointer or actual data in case of immediate load (uint64_t); IMMED,
+ *       COPY and DCOPY flags indicate action taken (inline imm data,
+ *       inline ptr, inline from ptr).
+ * @length: number of bytes to load; can be set to 0 for SEQ command w/ VLF set
+ *          (uint32_t).
+ * @flags: operational flags: for KEY: SGF, IMMED, COPY, DCOPY; for SEQKEY: SEQ,
+ *         VLF, AIDF.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define KEY(program, key_dst, encrypt_flags, src, length, flags) \
+	rta_key(program, key_dst, encrypt_flags, src, length, flags)
+
+/**
+ * SEQINPTR - Configures SEQ IN PTR command
+ * @program: pointer to struct program
+ * @src: starting address for Input Sequence (uint64_t)
+ * @length: number of bytes in (or to be added to) Input Sequence (uint32_t)
+ * @flags: operational flags: RBS, INL, SGF, PRE, EXT, RTO, RJD, SOP (when PRE,
+ *         RTO or SOP are set, @src parameter must be 0).
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SEQINPTR(program, src, length, flags) \
+	rta_seq_in_ptr(program, src, length, flags)
+
+/**
+ * SEQOUTPTR - Configures SEQ OUT PTR command
+ * @program: pointer to struct program
+ * @dst: starting address for Output Sequence (uint64_t)
+ * @length: number of bytes in (or to be added to) Output Sequence (uint32_t)
+ * @flags: operational flags: SGF, PRE, EXT, RTO, RST, EWS (when PRE or RTO are
+ *         set, @dst parameter must be 0).
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SEQOUTPTR(program, dst, length, flags) \
+	rta_seq_out_ptr(program, dst, length, flags)
+
+/**
+ * ALG_OPERATION - Configures ALGORITHM OPERATION command
+ * @program: pointer to struct program
+ * @cipher_alg: algorithm to be used
+ * @aai: Additional Algorithm Information; contains mode information that is
+ *       associated with the algorithm (check desc.h for specific values).
+ * @algo_state: algorithm state; defines the state of the algorithm that is
+ *              being executed (check desc.h file for specific values).
+ * @icv_check: ICV checking; selects whether the algorithm should check
+ *             calculated ICV with known ICV: ICV_CHECK_ENABLE,
+ *             ICV_CHECK_DISABLE.
+ * @enc: selects between encryption and decryption: DIR_ENC, DIR_DEC
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define ALG_OPERATION(program, cipher_alg, aai, algo_state, icv_check, enc) \
+	rta_operation(program, cipher_alg, aai, algo_state, icv_check, enc)
+
+/**
+ * PROTOCOL - Configures PROTOCOL OPERATION command
+ * @program: pointer to struct program
+ * @optype: operation type: OP_TYPE_UNI_PROTOCOL / OP_TYPE_DECAP_PROTOCOL /
+ *          OP_TYPE_ENCAP_PROTOCOL.
+ * @protid: protocol identifier value (check desc.h file for specific values)
+ * @protoinfo: protocol dependent value (check desc.h file for specific values)
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define PROTOCOL(program, optype, protid, protoinfo) \
+	rta_proto_operation(program, optype, protid, protoinfo)
+
+/**
+ * PKHA_OPERATION - Configures PKHA OPERATION command
+ * @program: pointer to struct program
+ * @op_pkha: PKHA operation; indicates the modular arithmetic function to
+ *           execute (check desc.h file for specific values).
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define PKHA_OPERATION(program, op_pkha)   rta_pkha_operation(program, op_pkha)
+
+/**
+ * JUMP - Configures JUMP command
+ * @program: pointer to struct program
+ * @addr: local offset for local jumps or address pointer for non-local jumps;
+ *        IMM or PTR macros must be used to indicate type.
+ * @jump_type: type of action taken by jump (enum rta_jump_type)
+ * @test_type: defines how jump conditions are evaluated (enum rta_jump_cond)
+ * @cond: jump conditions: operational flags - DONE1, DONE2, BOTH; various
+ *        sharing and wait conditions (JSL = 1) - NIFP, NIP, NOP, NCP, CALM,
+ *        SELF, SHARED, JQP; Math and PKHA status conditions (JSL = 0) - Z, N,
+ *        NV, C, PK0, PK1, PKP.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define JUMP(program, addr, jump_type, test_type, cond) \
+	rta_jump(program, addr, jump_type, test_type, cond, NONE)
+
+/**
+ * JUMP_INC - Configures JUMP_INC command
+ * @program: pointer to struct program
+ * @addr: local offset; IMM or PTR macros must be used to indicate type
+ * @test_type: defines how jump conditions are evaluated (enum rta_jump_cond)
+ * @cond: jump conditions: Math status conditions (JSL = 0): Z, N, NV, C
+ * @src_dst: register to increment / decrement: MATH0-MATH3, DPOVRD, SEQINSZ,
+ *           SEQOUTSZ, VSEQINSZ, VSEQOUTSZ.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define JUMP_INC(program, addr, test_type, cond, src_dst) \
+	rta_jump(program, addr, LOCAL_JUMP_INC, test_type, cond, src_dst)
+
+/**
+ * JUMP_DEC - Configures JUMP_DEC command
+ * @program: pointer to struct program
+ * @addr: local offset; IMM or PTR macros must be used to indicate type
+ * @test_type: defines how jump conditions are evaluated (enum rta_jump_cond)
+ * @cond: jump conditions: Math status conditions (JSL = 0): Z, N, NV, C
+ * @src_dst: register to increment / decrement: MATH0-MATH3, DPOVRD, SEQINSZ,
+ *           SEQOUTSZ, VSEQINSZ, VSEQOUTSZ.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define JUMP_DEC(program, addr, test_type, cond, src_dst) \
+	rta_jump(program, addr, LOCAL_JUMP_DEC, test_type, cond, src_dst)
+
+/**
+ * LOAD - Configures LOAD command to load data registers from descriptor or from
+ *        a memory location.
+ * @program: pointer to struct program
+ * @addr: immediate value or pointer to the data to be loaded; IMMED, COPY and
+ *        DCOPY flags indicate action taken (inline imm data, inline ptr, inline
+ *        from ptr).
+ * @dst: destination register (uint64_t)
+ * @offset: start point to write data in destination register (uint32_t)
+ * @length: number of bytes to load (uint32_t)
+ * @flags: operational flags: VLF, IMMED, COPY, DCOPY
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define LOAD(program, addr, dst, offset, length, flags) \
+	rta_load(program, addr, dst, offset, length, flags)
+
+/**
+ * SEQLOAD - Configures SEQ LOAD command to load data registers from descriptor
+ *           or from a memory location.
+ * @program: pointer to struct program
+ * @dst: destination register (uint64_t)
+ * @offset: start point to write data in destination register (uint32_t)
+ * @length: number of bytes to load (uint32_t)
+ * @flags: operational flags: SGF
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SEQLOAD(program, dst, offset, length, flags) \
+	rta_load(program, NONE, dst, offset, length, flags|SEQ)
+
+/**
+ * STORE - Configures STORE command to read data from registers and write them
+ *         to a memory location.
+ * @program: pointer to struct program
+ * @src: immediate value or source register for data to be stored: KEY1SZ,
+ *       KEY2SZ, DJQDA, MODE1, MODE2, DJQCTRL, DATA1SZ, DATA2SZ, DSTAT, ICV1SZ,
+ *       ICV2SZ, DPID, CCTRL, ICTRL, CLRW, CSTAT, MATH0-MATH3, PKHA registers,
+ *       CONTEXT1, CONTEXT2, DESCBUF, JOBDESCBUF, SHAREDESCBUF. In case of
+ *       immediate value, IMMED, COPY and DCOPY flags indicate action taken
+ *       (inline imm data, inline ptr, inline from ptr).
+ * @offset: start point for reading from source register (uint16_t)
+ * @dst: pointer to store location (uint64_t)
+ * @length: number of bytes to store (uint32_t)
+ * @flags: operational flags: VLF, IMMED, COPY, DCOPY
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define STORE(program, src, offset, dst, length, flags) \
+	rta_store(program, src, offset, dst, length, flags)
+
+/**
+ * SEQSTORE - Configures SEQ STORE command to read data from registers and write
+ *            them to a memory location.
+ * @program: pointer to struct program
+ * @src: immediate value or source register for data to be stored: KEY1SZ,
+ *       KEY2SZ, DJQDA, MODE1, MODE2, DJQCTRL, DATA1SZ, DATA2SZ, DSTAT, ICV1SZ,
+ *       ICV2SZ, DPID, CCTRL, ICTRL, CLRW, CSTAT, MATH0-MATH3, PKHA registers,
+ *       CONTEXT1, CONTEXT2, DESCBUF, JOBDESCBUF, SHAREDESCBUF. In case of
+ *       immediate value, IMMED, COPY and DCOPY flags indicate action taken
+ *       (inline imm data, inline ptr, inline from ptr).
+ * @offset: start point for reading from source register (uint16_t)
+ * @length: number of bytes to store (uint32_t)
+ * @flags: operational flags: SGF, IMMED, COPY, DCOPY
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SEQSTORE(program, src, offset, length, flags) \
+	rta_store(program, src, offset, NONE, length, flags|SEQ)
+
+/**
+ * MATHB - Configures MATHB command to perform binary operations
+ * @program: pointer to struct program
+ * @operand1: first operand: MATH0-MATH3, DPOVRD, SEQINSZ, SEQOUTSZ, VSEQINSZ,
+ *            VSEQOUTSZ, ZERO, ONE, NONE, Immediate value. IMMED must be used to
+ *            indicate immediate value.
+ * @operator: function to be performed: ADD, ADDC, SUB, SUBB, OR, AND, XOR,
+ *            LSHIFT, RSHIFT, SHLD.
+ * @operand2: second operand: MATH0-MATH3, DPOVRD, VSEQINSZ, VSEQOUTSZ, ABD,
+ *            OFIFO, JOBSRC, ZERO, ONE, Immediate value. IMMED2 must be used to
+ *            indicate immediate value.
+ * @result: destination for the result: MATH0-MATH3, DPOVRD, SEQINSZ, SEQOUTSZ,
+ *          NONE, VSEQINSZ, VSEQOUTSZ.
+ * @length: length in bytes of the operation and the immediate value, if there
+ *          is one (int).
+ * @opt: operational flags: IFB, NFU, STL, SWP, IMMED, IMMED2
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define MATHB(program, operand1, operator, operand2, result, length, opt) \
+	rta_math(program, operand1, MATH_FUN_##operator, operand2, result, \
+		 length, opt)
+
+/**
+ * MATHI - Configures MATHI command to perform binary operations
+ * @program: pointer to struct program
+ * @operand: if !SSEL: MATH0-MATH3, DPOVRD, SEQINSZ, SEQOUTSZ, VSEQINSZ,
+ *           VSEQOUTSZ, ZERO, ONE.
+ *           if SSEL: MATH0-MATH3, DPOVRD, VSEQINSZ, VSEQOUTSZ, ABD, OFIFO,
+ *           JOBSRC, ZERO, ONE.
+ * @operator: function to be performed: ADD, ADDC, SUB, SUBB, OR, AND, XOR,
+ *            LSHIFT, RSHIFT, FBYT (for !SSEL only).
+ * @imm: Immediate value (uint8_t). IMMED must be used to indicate immediate
+ *       value.
+ * @result: destination for the result: MATH0-MATH3, DPOVRD, SEQINSZ, SEQOUTSZ,
+ *          NONE, VSEQINSZ, VSEQOUTSZ.
+ * @length: length in bytes of the operation and the immediate value, if there
+ *          is one (int). @imm is left-extended with zeros if needed.
+ * @opt: operational flags: NFU, SSEL, SWP, IMMED
+ *
+ * If !SSEL, @operand <@operator> @imm -> @result
+ * If SSEL, @imm <@operator> @operand -> @result
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define MATHI(program, operand, operator, imm, result, length, opt) \
+	rta_mathi(program, operand, MATH_FUN_##operator, imm, result, length, \
+		  opt)
+
+/**
+ * MATHU - Configures MATHU command to perform unary operations
+ * @program: pointer to struct program
+ * @operand1: operand: MATH0-MATH3, DPOVRD, SEQINSZ, SEQOUTSZ, VSEQINSZ,
+ *            VSEQOUTSZ, ZERO, ONE, NONE, Immediate value. IMMED must be used to
+ *            indicate immediate value.
+ * @operator: function to be performed: ZBYT, BSWAP
+ * @result: destination for the result: MATH0-MATH3, DPOVRD, SEQINSZ, SEQOUTSZ,
+ *          NONE, VSEQINSZ, VSEQOUTSZ.
+ * @length: length in bytes of the operation and the immediate value, if there
+ *          is one (int).
+ * @opt: operational flags: NFU, STL, SWP, IMMED
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define MATHU(program, operand1, operator, result, length, opt) \
+	rta_math(program, operand1, MATH_FUN_##operator, NONE, result, length, \
+		 opt)
+
+/**
+ * SIGNATURE - Configures SIGNATURE command
+ * @program: pointer to struct program
+ * @sign_type: signature type: SIGN_TYPE_FINAL, SIGN_TYPE_FINAL_RESTORE,
+ *             SIGN_TYPE_FINAL_NONZERO, SIGN_TYPE_IMM_2, SIGN_TYPE_IMM_3,
+ *             SIGN_TYPE_IMM_4.
+ *
+ * After SIGNATURE command, DWORD or WORD must be used to insert signature in
+ * descriptor buffer.
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define SIGNATURE(program, sign_type)   rta_signature(program, sign_type)
+
+/**
+ * NFIFOADD - Configures NFIFO command, a shortcut of RTA Load command to write
+ *            to iNfo FIFO.
+ * @program: pointer to struct program
+ * @src: source for the input data in Alignment Block:IFIFO, OFIFO, PAD,
+ *       MSGOUTSNOOP, ALTSOURCE, OFIFO_SYNC, MSGOUTSNOOP_ALT.
+ * @data: type of data that is going through the Input Data FIFO: MSG, MSG1,
+ *        MSG2, IV1, IV2, ICV1, ICV2, SAD1, AAD1, AAD2, AFHA_SBOX, SKIP,
+ *        PKHA registers, AB1, AB2, ABD.
+ * @length: length of the data copied in FIFO registers (uint32_t)
+ * @flags: select options between:
+ *         -operational flags: LAST1, LAST2, FLUSH1, FLUSH2, OC, BP
+ *         -when PAD is selected as source: BM, PR, PS
+ *         -padding type: <em>PAD_ZERO, PAD_NONZERO, PAD_INCREMENT, PAD_RANDOM,
+ *          PAD_ZERO_N1, PAD_NONZERO_0, PAD_N1, PAD_NONZERO_N
+ *
+ * Return: On success, descriptor buffer offset where this command is inserted.
+ *         On error, a negative error code; first error program counter will
+ *         point to offset in descriptor buffer where the instruction should
+ *         have been written.
+ */
+#define NFIFOADD(program, src, data, length, flags) \
+	rta_nfifo_load(program, src, data, length, flags)
+
+/**
+ * DOC: Self Referential Code Management Routines
+ *
+ * Contains details of RTA self referential code routines.
+ */
+
+/**
+ * REFERENCE - initialize a variable used for storing an index inside a
+ *             descriptor buffer.
+ * @ref: reference to a descriptor buffer's index where an update is required
+ *       with a value that will be known latter in the program flow.
+ */
+#define REFERENCE(ref)    int ref = -1
+
+/**
+ * LABEL - initialize a variable used for storing an index inside a descriptor
+ *         buffer.
+ * @label: label stores the value with what should be updated the REFERENCE line
+ *         in the descriptor buffer.
+ */
+#define LABEL(label)      unsigned label = 0
+
+/**
+ * SET_LABEL - set a LABEL value
+ * @program: pointer to struct program
+ * @label: value that will be inserted in a line previously written in the
+ *         descriptor buffer.
+ */
+#define SET_LABEL(program, label)  label = rta_set_label(program)
+
+/**
+ * PATCH_JUMP - Auxiliary command to resolve self referential code
+ * @program: buffer to be updated (struct program *)
+ * @line: position in descriptor buffer where the update will be done; this
+ *        value is previously retained in program flow using a reference near
+ *        the sequence to be modified.
+ * @new_ref: updated value that will be inserted in descriptor buffer at the
+ *           specified line; this value is previously obtained using SET_LABEL
+ *           macro near the line that will be used as reference (unsigned). For
+ *           JUMP command, the value represents the offset field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_JUMP(program, line, new_ref) \
+	rta_patch_jmp(program, line, new_ref, false)
+
+/**
+ * PATCH_JUMP_NON_LOCAL - Auxiliary command to resolve referential code between
+ *                        two program buffers.
+ * @src_program: buffer to be updated (struct program *)
+ * @line: position in source descriptor buffer where the update will be done;
+ *        this value is previously retained in program flow using a reference
+ *        near the sequence to be modified.
+ * @new_ref: updated value that will be inserted in descriptor buffer at the
+ *           specified line; this value is previously obtained using SET_LABEL
+ *           macro near the line that will be used as reference (unsigned). For
+ *           JUMP command, the value represents the offset field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_JUMP_NON_LOCAL(src_program, line, new_ref) \
+	rta_patch_jmp(src_program, line, new_ref, true)
+
+/**
+ * PATCH_MOVE - Auxiliary command to resolve self referential code
+ * @program: buffer to be updated (struct program *)
+ * @line: position in descriptor buffer where the update will be done; this
+ *        value is previously retained in program flow using a reference near
+ *        the sequence to be modified.
+ * @new_ref: updated value that will be inserted in descriptor buffer at the
+ *           specified line; this value is previously obtained using SET_LABEL
+ *           macro near the line that will be used as reference (unsigned). For
+ *           MOVE command, the value represents the offset field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_MOVE(program, line, new_ref) \
+	rta_patch_move(program, line, new_ref, false)
+
+/**
+ * PATCH_MOVE_NON_LOCAL - Auxiliary command to resolve referential code between
+ *                        two program buffers.
+ * @src_program: buffer to be updated (struct program *)
+ * @line: position in source descriptor buffer where the update will be done;
+ *        this value is previously retained in program flow using a reference
+ *        near the sequence to be modified.
+ * @new_ref: updated value that will be inserted in source descriptor buffer at
+ *           the specified line; this value is previously obtained using
+ *           SET_LABEL macro near the line that will be used as reference
+ *           (unsigned). For MOVE command, the value represents the offset
+ *           field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_MOVE_NON_LOCAL(src_program, line, new_ref) \
+	rta_patch_move(src_program, line, new_ref, true)
+
+/**
+ * PATCH_LOAD - Auxiliary command to resolve self referential code
+ * @program: buffer to be updated (struct program *)
+ * @line: position in descriptor buffer where the update will be done; this
+ *        value is previously retained in program flow using a reference near
+ *        the sequence to be modified.
+ * @new_ref: updated value that will be inserted in descriptor buffer at the
+ *           specified line; this value is previously obtained using SET_LABEL
+ *           macro near the line that will be used as reference (unsigned). For
+ *           LOAD command, the value represents the offset field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_LOAD(program, line, new_ref) \
+	rta_patch_load(program, line, new_ref)
+
+/**
+ * PATCH_STORE - Auxiliary command to resolve self referential code
+ * @program: buffer to be updated (struct program *)
+ * @line: position in descriptor buffer where the update will be done; this
+ *        value is previously retained in program flow using a reference near
+ *        the sequence to be modified.
+ * @new_ref: updated value that will be inserted in descriptor buffer at the
+ *           specified line; this value is previously obtained using SET_LABEL
+ *           macro near the line that will be used as reference (unsigned). For
+ *           STORE command, the value represents the offset field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_STORE(program, line, new_ref) \
+	rta_patch_store(program, line, new_ref, false)
+
+/**
+ * PATCH_STORE_NON_LOCAL - Auxiliary command to resolve referential code between
+ *                         two program buffers.
+ * @src_program: buffer to be updated (struct program *)
+ * @line: position in source descriptor buffer where the update will be done;
+ *        this value is previously retained in program flow using a reference
+ *        near the sequence to be modified.
+ * @new_ref: updated value that will be inserted in source descriptor buffer at
+ *           the specified line; this value is previously obtained using
+ *           SET_LABEL macro near the line that will be used as reference
+ *           (unsigned). For STORE command, the value represents the offset
+ *           field (in words).
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_STORE_NON_LOCAL(src_program, line, new_ref) \
+	rta_patch_store(src_program, line, new_ref, true)
+
+/**
+ * PATCH_HDR - Auxiliary command to resolve self referential code
+ * @program: buffer to be updated (struct program *)
+ * @line: position in descriptor buffer where the update will be done; this
+ *        value is previously retained in program flow using a reference near
+ *        the sequence to be modified.
+ * @new_ref: updated value that will be inserted in descriptor buffer at the
+ *           specified line; this value is previously obtained using SET_LABEL
+ *           macro near the line that will be used as reference (unsigned). For
+ *           HEADER command, the value represents the start index field.
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_HDR(program, line, new_ref) \
+	rta_patch_header(program, line, new_ref, false)
+
+/**
+ * PATCH_HDR_NON_LOCAL - Auxiliary command to resolve referential code between
+ *                       two program buffers.
+ * @src_program: buffer to be updated (struct program *)
+ * @line: position in source descriptor buffer where the update will be done;
+ *        this value is previously retained in program flow using a reference
+ *        near the sequence to be modified.
+ * @new_ref: updated value that will be inserted in source descriptor buffer at
+ *           the specified line; this value is previously obtained using
+ *           SET_LABEL macro near the line that will be used as reference
+ *           (unsigned). For HEADER command, the value represents the start
+ *           index field.
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_HDR_NON_LOCAL(src_program, line, new_ref) \
+	rta_patch_header(src_program, line, new_ref, true)
+
+/**
+ * PATCH_RAW - Auxiliary command to resolve self referential code
+ * @program: buffer to be updated (struct program *)
+ * @line: position in descriptor buffer where the update will be done; this
+ *        value is previously retained in program flow using a reference near
+ *        the sequence to be modified.
+ * @mask: mask to be used for applying the new value (unsigned). The mask
+ *        selects which bits from the provided @new_val are taken into
+ *        consideration when overwriting the existing value.
+ * @new_val: updated value that will be masked using the provided mask value
+ *           and inserted in descriptor buffer at the specified line.
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_RAW(program, line, mask, new_val) \
+	rta_patch_raw(program, line, mask, new_val, false)
+
+/**
+ * PATCH_RAW_NON_LOCAL - Auxiliary command to resolve referential code between
+ *                       two program buffers.
+ * @src_program: buffer to be updated (struct program *)
+ * @line: position in source descriptor buffer where the update will be done;
+ *        this value is previously retained in program flow using a reference
+ *        near the sequence to be modified.
+ * @mask: mask to be used for applying the new value (unsigned). The mask
+ *        selects which bits from the provided @new_val are taken into
+ *        consideration when overwriting the existing value.
+ * @new_val: updated value that will be masked using the provided mask value
+ *           and inserted in descriptor buffer at the specified line.
+ *
+ * Return: 0 in case of success, a negative error code if it fails
+ */
+#define PATCH_RAW_NON_LOCAL(src_program, line, mask, new_val) \
+	rta_patch_raw(src_program, line, mask, new_val, true)
+
+#endif /* __RTA_RTA_H__ */
diff --git a/drivers/crypto/caam/flib/rta/protocol_cmd.h b/drivers/crypto/caam/flib/rta/protocol_cmd.h
new file mode 100644
index 000000000000..38f544adde74
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/protocol_cmd.h
@@ -0,0 +1,595 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_PROTOCOL_CMD_H__
+#define __RTA_PROTOCOL_CMD_H__
+
+extern enum rta_sec_era rta_sec_era;
+
+static inline int __rta_ssl_proto(uint16_t protoinfo)
+{
+	switch (protoinfo) {
+	case OP_PCL_SSL30_RC4_40_MD5_2:
+	case OP_PCL_SSL30_RC4_128_MD5_2:
+	case OP_PCL_SSL30_RC4_128_SHA_5:
+	case OP_PCL_SSL30_RC4_40_MD5_3:
+	case OP_PCL_SSL30_RC4_128_MD5_3:
+	case OP_PCL_SSL30_RC4_128_SHA:
+	case OP_PCL_SSL30_RC4_128_MD5:
+	case OP_PCL_SSL30_RC4_40_SHA:
+	case OP_PCL_SSL30_RC4_40_MD5:
+	case OP_PCL_SSL30_RC4_128_SHA_2:
+	case OP_PCL_SSL30_RC4_128_SHA_3:
+	case OP_PCL_SSL30_RC4_128_SHA_4:
+	case OP_PCL_SSL30_RC4_128_SHA_6:
+	case OP_PCL_SSL30_RC4_128_SHA_7:
+	case OP_PCL_SSL30_RC4_128_SHA_8:
+	case OP_PCL_SSL30_RC4_128_SHA_9:
+	case OP_PCL_SSL30_RC4_128_SHA_10:
+	case OP_PCL_TLS_ECDHE_PSK_RC4_128_SHA:
+		if (rta_sec_era == RTA_SEC_ERA_7)
+			return -EINVAL;
+		/* fall through if not Era 7 */
+	case OP_PCL_SSL30_DES40_CBC_SHA:
+	case OP_PCL_SSL30_DES_CBC_SHA_2:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_5:
+	case OP_PCL_SSL30_DES40_CBC_SHA_2:
+	case OP_PCL_SSL30_DES_CBC_SHA_3:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_6:
+	case OP_PCL_SSL30_DES40_CBC_SHA_3:
+	case OP_PCL_SSL30_DES_CBC_SHA_4:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_7:
+	case OP_PCL_SSL30_DES40_CBC_SHA_4:
+	case OP_PCL_SSL30_DES_CBC_SHA_5:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_8:
+	case OP_PCL_SSL30_DES40_CBC_SHA_5:
+	case OP_PCL_SSL30_DES_CBC_SHA_6:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_9:
+	case OP_PCL_SSL30_DES40_CBC_SHA_6:
+	case OP_PCL_SSL30_DES_CBC_SHA_7:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_10:
+	case OP_PCL_SSL30_DES_CBC_SHA:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA:
+	case OP_PCL_SSL30_DES_CBC_MD5:
+	case OP_PCL_SSL30_3DES_EDE_CBC_MD5:
+	case OP_PCL_SSL30_DES40_CBC_SHA_7:
+	case OP_PCL_SSL30_DES40_CBC_MD5:
+	case OP_PCL_SSL30_AES_128_CBC_SHA:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_2:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_3:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_4:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_5:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_6:
+	case OP_PCL_SSL30_AES_256_CBC_SHA:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_2:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_3:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_4:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_5:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_6:
+	case OP_PCL_TLS12_AES_128_CBC_SHA256_2:
+	case OP_PCL_TLS12_AES_128_CBC_SHA256_3:
+	case OP_PCL_TLS12_AES_128_CBC_SHA256_4:
+	case OP_PCL_TLS12_AES_128_CBC_SHA256_5:
+	case OP_PCL_TLS12_AES_256_CBC_SHA256_2:
+	case OP_PCL_TLS12_AES_256_CBC_SHA256_3:
+	case OP_PCL_TLS12_AES_256_CBC_SHA256_4:
+	case OP_PCL_TLS12_AES_256_CBC_SHA256_5:
+	case OP_PCL_TLS12_AES_128_CBC_SHA256_6:
+	case OP_PCL_TLS12_AES_256_CBC_SHA256_6:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_2:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_7:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_7:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_3:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_8:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_8:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_4:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_9:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_9:
+	case OP_PCL_SSL30_AES_128_GCM_SHA256_1:
+	case OP_PCL_SSL30_AES_256_GCM_SHA384_1:
+	case OP_PCL_SSL30_AES_128_GCM_SHA256_2:
+	case OP_PCL_SSL30_AES_256_GCM_SHA384_2:
+	case OP_PCL_SSL30_AES_128_GCM_SHA256_3:
+	case OP_PCL_SSL30_AES_256_GCM_SHA384_3:
+	case OP_PCL_SSL30_AES_128_GCM_SHA256_4:
+	case OP_PCL_SSL30_AES_256_GCM_SHA384_4:
+	case OP_PCL_SSL30_AES_128_GCM_SHA256_5:
+	case OP_PCL_SSL30_AES_256_GCM_SHA384_5:
+	case OP_PCL_SSL30_AES_128_GCM_SHA256_6:
+	case OP_PCL_TLS_DH_ANON_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_PSK_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_PSK_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_DHE_PSK_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_DHE_PSK_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_RSA_PSK_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_RSA_PSK_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_PSK_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_PSK_AES_256_CBC_SHA384:
+	case OP_PCL_TLS_DHE_PSK_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_DHE_PSK_AES_256_CBC_SHA384:
+	case OP_PCL_TLS_RSA_PSK_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_RSA_PSK_AES_256_CBC_SHA384:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_11:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_10:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_10:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_12:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_11:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_11:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_12:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_13:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_12:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_14:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_13:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_13:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_15:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_14:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_14:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_16:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_17:
+	case OP_PCL_SSL30_3DES_EDE_CBC_SHA_18:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_15:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_16:
+	case OP_PCL_SSL30_AES_128_CBC_SHA_17:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_15:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_16:
+	case OP_PCL_SSL30_AES_256_CBC_SHA_17:
+	case OP_PCL_TLS_ECDHE_ECDSA_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_ECDHE_ECDSA_AES_256_CBC_SHA384:
+	case OP_PCL_TLS_ECDH_ECDSA_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_ECDH_ECDSA_AES_256_CBC_SHA384:
+	case OP_PCL_TLS_ECDHE_RSA_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_ECDHE_RSA_AES_256_CBC_SHA384:
+	case OP_PCL_TLS_ECDH_RSA_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_ECDH_RSA_AES_256_CBC_SHA384:
+	case OP_PCL_TLS_ECDHE_ECDSA_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_ECDHE_ECDSA_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_ECDH_ECDSA_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_ECDH_ECDSA_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_ECDHE_RSA_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_ECDHE_RSA_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_ECDH_RSA_AES_128_GCM_SHA256:
+	case OP_PCL_TLS_ECDH_RSA_AES_256_GCM_SHA384:
+	case OP_PCL_TLS_ECDHE_PSK_3DES_EDE_CBC_SHA:
+	case OP_PCL_TLS_ECDHE_PSK_AES_128_CBC_SHA:
+	case OP_PCL_TLS_ECDHE_PSK_AES_256_CBC_SHA:
+	case OP_PCL_TLS_ECDHE_PSK_AES_128_CBC_SHA256:
+	case OP_PCL_TLS_ECDHE_PSK_AES_256_CBC_SHA384:
+	case OP_PCL_TLS12_3DES_EDE_CBC_MD5:
+	case OP_PCL_TLS12_3DES_EDE_CBC_SHA160:
+	case OP_PCL_TLS12_3DES_EDE_CBC_SHA224:
+	case OP_PCL_TLS12_3DES_EDE_CBC_SHA256:
+	case OP_PCL_TLS12_3DES_EDE_CBC_SHA384:
+	case OP_PCL_TLS12_3DES_EDE_CBC_SHA512:
+	case OP_PCL_TLS12_AES_128_CBC_SHA160:
+	case OP_PCL_TLS12_AES_128_CBC_SHA224:
+	case OP_PCL_TLS12_AES_128_CBC_SHA256:
+	case OP_PCL_TLS12_AES_128_CBC_SHA384:
+	case OP_PCL_TLS12_AES_128_CBC_SHA512:
+	case OP_PCL_TLS12_AES_192_CBC_SHA160:
+	case OP_PCL_TLS12_AES_192_CBC_SHA224:
+	case OP_PCL_TLS12_AES_192_CBC_SHA256:
+	case OP_PCL_TLS12_AES_192_CBC_SHA512:
+	case OP_PCL_TLS12_AES_256_CBC_SHA160:
+	case OP_PCL_TLS12_AES_256_CBC_SHA224:
+	case OP_PCL_TLS12_AES_256_CBC_SHA256:
+	case OP_PCL_TLS12_AES_256_CBC_SHA384:
+	case OP_PCL_TLS12_AES_256_CBC_SHA512:
+	case OP_PCL_TLS_PVT_AES_192_CBC_SHA160:
+	case OP_PCL_TLS_PVT_AES_192_CBC_SHA384:
+	case OP_PCL_TLS_PVT_AES_192_CBC_SHA224:
+	case OP_PCL_TLS_PVT_AES_192_CBC_SHA512:
+	case OP_PCL_TLS_PVT_AES_192_CBC_SHA256:
+	case OP_PCL_TLS_PVT_MASTER_SECRET_PRF_FE:
+	case OP_PCL_TLS_PVT_MASTER_SECRET_PRF_FF:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_ike_proto(uint16_t protoinfo)
+{
+	switch (protoinfo) {
+	case OP_PCL_IKE_HMAC_MD5:
+	case OP_PCL_IKE_HMAC_SHA1:
+	case OP_PCL_IKE_HMAC_AES128_CBC:
+	case OP_PCL_IKE_HMAC_SHA256:
+	case OP_PCL_IKE_HMAC_SHA384:
+	case OP_PCL_IKE_HMAC_SHA512:
+	case OP_PCL_IKE_HMAC_AES128_CMAC:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_ipsec_proto(uint16_t protoinfo)
+{
+	uint16_t proto_cls1 = protoinfo & OP_PCL_IPSEC_CIPHER_MASK;
+	uint16_t proto_cls2 = protoinfo & OP_PCL_IPSEC_AUTH_MASK;
+
+	switch (proto_cls1) {
+	case OP_PCL_IPSEC_NULL:
+	case OP_PCL_IPSEC_AES_NULL_WITH_GMAC:
+		if (rta_sec_era < RTA_SEC_ERA_2)
+			return -EINVAL;
+		break;
+	case OP_PCL_IPSEC_AES_CCM8:
+	case OP_PCL_IPSEC_AES_CCM12:
+	case OP_PCL_IPSEC_AES_CCM16:
+	case OP_PCL_IPSEC_AES_GCM8:
+	case OP_PCL_IPSEC_AES_GCM12:
+		if (proto_cls2 == OP_PCL_IPSEC_HMAC_NULL)
+			return 0;
+		/* no break */
+	case OP_PCL_IPSEC_DES_IV64:
+	case OP_PCL_IPSEC_DES:
+	case OP_PCL_IPSEC_3DES:
+	case OP_PCL_IPSEC_AES_CBC:
+	case OP_PCL_IPSEC_AES_CTR:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (proto_cls2) {
+	case OP_PCL_IPSEC_HMAC_MD5_96:
+	case OP_PCL_IPSEC_HMAC_SHA1_96:
+	case OP_PCL_IPSEC_AES_XCBC_MAC_96:
+	case OP_PCL_IPSEC_HMAC_MD5_128:
+	case OP_PCL_IPSEC_HMAC_SHA1_160:
+	case OP_PCL_IPSEC_AES_CMAC_96:
+	case OP_PCL_IPSEC_HMAC_SHA2_256_128:
+	case OP_PCL_IPSEC_HMAC_SHA2_384_192:
+	case OP_PCL_IPSEC_HMAC_SHA2_512_256:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_srtp_proto(uint16_t protoinfo)
+{
+	uint16_t proto_cls1 = protoinfo & OP_PCL_SRTP_CIPHER_MASK;
+	uint16_t proto_cls2 = protoinfo & OP_PCL_SRTP_AUTH_MASK;
+
+	switch (proto_cls1) {
+	case OP_PCL_SRTP_AES_CTR:
+		switch (proto_cls2) {
+		case OP_PCL_SRTP_HMAC_SHA1_160:
+			return 0;
+		}
+		/* no break */
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_macsec_proto(uint16_t protoinfo)
+{
+	switch (protoinfo) {
+	case OP_PCL_MACSEC:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_wifi_proto(uint16_t protoinfo)
+{
+	switch (protoinfo) {
+	case OP_PCL_WIFI:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_wimax_proto(uint16_t protoinfo)
+{
+	switch (protoinfo) {
+	case OP_PCL_WIMAX_OFDM:
+	case OP_PCL_WIMAX_OFDMA:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+/* Allowed blob proto flags for each SEC Era */
+static const uint32_t proto_blob_flags[] = {
+	OP_PCL_BLOB_FORMAT_MASK | OP_PCL_BLOB_BLACK,
+	OP_PCL_BLOB_FORMAT_MASK | OP_PCL_BLOB_BLACK | OP_PCL_BLOB_TKEK |
+		OP_PCL_BLOB_EKT | OP_PCL_BLOB_REG_MASK,
+	OP_PCL_BLOB_FORMAT_MASK | OP_PCL_BLOB_BLACK | OP_PCL_BLOB_TKEK |
+		OP_PCL_BLOB_EKT | OP_PCL_BLOB_REG_MASK,
+	OP_PCL_BLOB_FORMAT_MASK | OP_PCL_BLOB_BLACK | OP_PCL_BLOB_TKEK |
+		OP_PCL_BLOB_EKT | OP_PCL_BLOB_REG_MASK | OP_PCL_BLOB_SEC_MEM,
+	OP_PCL_BLOB_FORMAT_MASK | OP_PCL_BLOB_BLACK | OP_PCL_BLOB_TKEK |
+		OP_PCL_BLOB_EKT | OP_PCL_BLOB_REG_MASK | OP_PCL_BLOB_SEC_MEM
+};
+
+static inline int __rta_blob_proto(uint16_t protoinfo)
+{
+	if (protoinfo & ~proto_blob_flags[rta_sec_era])
+		return -EINVAL;
+
+	switch (protoinfo & OP_PCL_BLOB_FORMAT_MASK) {
+	case OP_PCL_BLOB_FORMAT_NORMAL:
+	case OP_PCL_BLOB_FORMAT_MASTER_VER:
+	case OP_PCL_BLOB_FORMAT_TEST:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (protoinfo & OP_PCL_BLOB_REG_MASK) {
+	case OP_PCL_BLOB_AFHA_SBOX:
+		if (rta_sec_era < RTA_SEC_ERA_3)
+			return -EINVAL;
+		/* no break */
+	case OP_PCL_BLOB_REG_MEMORY:
+	case OP_PCL_BLOB_REG_KEY1:
+	case OP_PCL_BLOB_REG_KEY2:
+	case OP_PCL_BLOB_REG_SPLIT:
+	case OP_PCL_BLOB_REG_PKE:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_dlc_proto(uint16_t protoinfo)
+{
+	if ((rta_sec_era < RTA_SEC_ERA_2) &&
+	    (protoinfo & (OP_PCL_PKPROT_DSA_MSG | OP_PCL_PKPROT_HASH_MASK |
+	     OP_PCL_PKPROT_EKT_Z | OP_PCL_PKPROT_DECRYPT_Z |
+	     OP_PCL_PKPROT_DECRYPT_PRI)))
+		return -EINVAL;
+
+	switch (protoinfo & OP_PCL_PKPROT_HASH_MASK) {
+	case OP_PCL_PKPROT_HASH_MD5:
+	case OP_PCL_PKPROT_HASH_SHA1:
+	case OP_PCL_PKPROT_HASH_SHA224:
+	case OP_PCL_PKPROT_HASH_SHA256:
+	case OP_PCL_PKPROT_HASH_SHA384:
+	case OP_PCL_PKPROT_HASH_SHA512:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline int __rta_rsa_enc_proto(uint16_t protoinfo)
+{
+	switch (protoinfo & OP_PCL_RSAPROT_OP_MASK) {
+	case OP_PCL_RSAPROT_OP_ENC_F_IN:
+		if ((protoinfo & OP_PCL_RSAPROT_FFF_MASK) !=
+		    OP_PCL_RSAPROT_FFF_RED)
+			return -EINVAL;
+		break;
+	case OP_PCL_RSAPROT_OP_ENC_F_OUT:
+		switch (protoinfo & OP_PCL_RSAPROT_FFF_MASK) {
+		case OP_PCL_RSAPROT_FFF_RED:
+		case OP_PCL_RSAPROT_FFF_ENC:
+		case OP_PCL_RSAPROT_FFF_EKT:
+		case OP_PCL_RSAPROT_FFF_TK_ENC:
+		case OP_PCL_RSAPROT_FFF_TK_EKT:
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline int __rta_rsa_dec_proto(uint16_t protoinfo)
+{
+	switch (protoinfo & OP_PCL_RSAPROT_OP_MASK) {
+	case OP_PCL_RSAPROT_OP_DEC_ND:
+	case OP_PCL_RSAPROT_OP_DEC_PQD:
+	case OP_PCL_RSAPROT_OP_DEC_PQDPDQC:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (protoinfo & OP_PCL_RSAPROT_PPP_MASK) {
+	case OP_PCL_RSAPROT_PPP_RED:
+	case OP_PCL_RSAPROT_PPP_ENC:
+	case OP_PCL_RSAPROT_PPP_EKT:
+	case OP_PCL_RSAPROT_PPP_TK_ENC:
+	case OP_PCL_RSAPROT_PPP_TK_EKT:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (protoinfo & OP_PCL_RSAPROT_FMT_PKCSV15)
+		switch (protoinfo & OP_PCL_RSAPROT_FFF_MASK) {
+		case OP_PCL_RSAPROT_FFF_RED:
+		case OP_PCL_RSAPROT_FFF_ENC:
+		case OP_PCL_RSAPROT_FFF_EKT:
+		case OP_PCL_RSAPROT_FFF_TK_ENC:
+		case OP_PCL_RSAPROT_FFF_TK_EKT:
+			break;
+		default:
+			return -EINVAL;
+		}
+
+	return 0;
+}
+
+static inline int __rta_3g_dcrc_proto(uint16_t protoinfo)
+{
+	if (rta_sec_era == RTA_SEC_ERA_7)
+		return -EINVAL;
+
+	switch (protoinfo) {
+	case OP_PCL_3G_DCRC_CRC7:
+	case OP_PCL_3G_DCRC_CRC11:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_3g_rlc_proto(uint16_t protoinfo)
+{
+	if (rta_sec_era == RTA_SEC_ERA_7)
+		return -EINVAL;
+
+	switch (protoinfo) {
+	case OP_PCL_3G_RLC_NULL:
+	case OP_PCL_3G_RLC_KASUMI:
+	case OP_PCL_3G_RLC_SNOW:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_lte_pdcp_proto(uint16_t protoinfo)
+{
+	if (rta_sec_era == RTA_SEC_ERA_7)
+		return -EINVAL;
+
+	switch (protoinfo) {
+	case OP_PCL_LTE_ZUC:
+		if (rta_sec_era < RTA_SEC_ERA_5)
+			break;
+	case OP_PCL_LTE_NULL:
+	case OP_PCL_LTE_SNOW:
+	case OP_PCL_LTE_AES:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static inline int __rta_lte_pdcp_mixed_proto(uint16_t protoinfo)
+{
+	switch (protoinfo & OP_PCL_LTE_MIXED_AUTH_MASK) {
+	case OP_PCL_LTE_MIXED_AUTH_NULL:
+	case OP_PCL_LTE_MIXED_AUTH_SNOW:
+	case OP_PCL_LTE_MIXED_AUTH_AES:
+	case OP_PCL_LTE_MIXED_AUTH_ZUC:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (protoinfo & OP_PCL_LTE_MIXED_ENC_MASK) {
+	case OP_PCL_LTE_MIXED_ENC_NULL:
+	case OP_PCL_LTE_MIXED_ENC_SNOW:
+	case OP_PCL_LTE_MIXED_ENC_AES:
+	case OP_PCL_LTE_MIXED_ENC_ZUC:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+struct proto_map {
+	uint32_t optype;
+	uint32_t protid;
+	int (*protoinfo_func)(uint16_t);
+};
+
+static const struct proto_map proto_table[] = {
+/*1*/	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_SSL30_PRF,	 __rta_ssl_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_TLS10_PRF,	 __rta_ssl_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_TLS11_PRF,	 __rta_ssl_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_TLS12_PRF,	 __rta_ssl_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_DTLS10_PRF,	 __rta_ssl_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_IKEV1_PRF,	 __rta_ike_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_IKEV2_PRF,	 __rta_ike_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_PUBLICKEYPAIR, __rta_dlc_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_DSASIGN,	 __rta_dlc_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_DSAVERIFY,	 __rta_dlc_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_IPSEC,         __rta_ipsec_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_SRTP,	         __rta_srtp_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_SSL30,	 __rta_ssl_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_TLS10,	 __rta_ssl_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_TLS11,	 __rta_ssl_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_TLS12,	 __rta_ssl_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_DTLS10,	 __rta_ssl_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_MACSEC,        __rta_macsec_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_WIFI,          __rta_wifi_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_WIMAX,         __rta_wimax_proto},
+/*21*/	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_BLOB,          __rta_blob_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_DIFFIEHELLMAN, __rta_dlc_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_RSAENCRYPT,	 __rta_rsa_enc_proto},
+	{OP_TYPE_UNI_PROTOCOL,   OP_PCLID_RSADECRYPT,	 __rta_rsa_dec_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_3G_DCRC,       __rta_3g_dcrc_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_3G_RLC_PDU,    __rta_3g_rlc_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_3G_RLC_SDU,    __rta_3g_rlc_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_LTE_PDCP_USER, __rta_lte_pdcp_proto},
+/*29*/	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_LTE_PDCP_CTRL, __rta_lte_pdcp_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_PUBLICKEYPAIR, __rta_dlc_proto},
+/*31*/	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_DSASIGN,	 __rta_dlc_proto},
+/*32*/	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_LTE_PDCP_CTRL_MIXED,
+	 __rta_lte_pdcp_mixed_proto},
+	{OP_TYPE_DECAP_PROTOCOL, OP_PCLID_IPSEC_NEW,     __rta_ipsec_proto},
+};
+
+/*
+ * Allowed OPERATION protocols for each SEC Era.
+ * Values represent the number of entries from proto_table[] that are supported.
+ */
+static const unsigned proto_table_sz[] = {21, 29, 29, 29, 29, 29, 31, 33};
+
+static inline int rta_proto_operation(struct program *program, uint32_t optype,
+				      uint32_t protid, uint16_t protoinfo)
+{
+	uint32_t opcode = CMD_OPERATION;
+	unsigned i, found = 0;
+	uint32_t optype_tmp = optype;
+	unsigned start_pc = program->current_pc;
+	int ret = -EINVAL;
+
+	for (i = 0; i < proto_table_sz[rta_sec_era]; i++) {
+		/* clear last bit in optype to match also decap proto */
+		optype_tmp &= (uint32_t)~(1 << OP_TYPE_SHIFT);
+		if (optype_tmp == proto_table[i].optype) {
+			if (proto_table[i].protid == protid) {
+				/* nothing else to verify */
+				if (proto_table[i].protoinfo_func == NULL) {
+					found = 1;
+					break;
+				}
+				/* check protoinfo */
+				ret = (*proto_table[i].protoinfo_func)
+						(protoinfo);
+				if (ret < 0) {
+					pr_err("PROTO_DESC: Bad PROTO Type. SEC Program Line: %d\n",
+					       program->current_pc);
+					goto err;
+				}
+				found = 1;
+				break;
+			}
+		}
+	}
+	if (!found) {
+		pr_err("PROTO_DESC: Operation Type Mismatch. SEC Program Line: %d\n",
+		       program->current_pc);
+		goto err;
+	}
+
+	__rta_out32(program, opcode | optype | protid | protoinfo);
+	program->current_instruction++;
+	return (int)start_pc;
+
+ err:
+	program->first_error_pc = start_pc;
+	program->current_instruction++;
+	return ret;
+}
+
+#endif /* __RTA_PROTOCOL_CMD_H__ */
diff --git a/drivers/crypto/caam/flib/rta/sec_run_time_asm.h b/drivers/crypto/caam/flib/rta/sec_run_time_asm.h
new file mode 100644
index 000000000000..d2870ddd922f
--- /dev/null
+++ b/drivers/crypto/caam/flib/rta/sec_run_time_asm.h
@@ -0,0 +1,672 @@
+/* Copyright 2008-2013 Freescale Semiconductor, Inc. */
+
+#ifndef __RTA_SEC_RUN_TIME_ASM_H__
+#define __RTA_SEC_RUN_TIME_ASM_H__
+
+#include "flib/desc.h"
+
+/* flib/compat.h is not delivered in kernel */
+#ifndef __KERNEL__
+#include "flib/compat.h"
+#endif
+
+/**
+ * enum rta_sec_era - SEC HW block revisions supported by the RTA library
+ * @RTA_SEC_ERA_1: SEC Era 1
+ * @RTA_SEC_ERA_2: SEC Era 2
+ * @RTA_SEC_ERA_3: SEC Era 3
+ * @RTA_SEC_ERA_4: SEC Era 4
+ * @RTA_SEC_ERA_5: SEC Era 5
+ * @RTA_SEC_ERA_6: SEC Era 6
+ * @RTA_SEC_ERA_7: SEC Era 7
+ * @RTA_SEC_ERA_8: SEC Era 8
+ * @MAX_SEC_ERA: maximum SEC HW block revision supported by RTA library
+ */
+enum rta_sec_era {
+	RTA_SEC_ERA_1,
+	RTA_SEC_ERA_2,
+	RTA_SEC_ERA_3,
+	RTA_SEC_ERA_4,
+	RTA_SEC_ERA_5,
+	RTA_SEC_ERA_6,
+	RTA_SEC_ERA_7,
+	RTA_SEC_ERA_8,
+	MAX_SEC_ERA = RTA_SEC_ERA_8
+};
+
+/**
+ * DEFAULT_SEC_ERA - the default value for the SEC era in case the user provides
+ * an unsupported value.
+ */
+#define DEFAULT_SEC_ERA	MAX_SEC_ERA
+
+/**
+ * USER_SEC_ERA - translates the SEC Era from internal to user representation.
+ * @sec_era: SEC Era in internal (library) representation
+ */
+#define USER_SEC_ERA(sec_era)	(sec_era + 1)
+
+/**
+ * INTL_SEC_ERA - translates the SEC Era from user representation to internal.
+ * @sec_era: SEC Era in user representation
+ */
+#define INTL_SEC_ERA(sec_era)	(sec_era - 1)
+
+/**
+ * enum rta_jump_type - Types of action taken by JUMP command
+ * @LOCAL_JUMP: conditional jump to an offset within the descriptor buffer
+ * @FAR_JUMP: conditional jump to a location outside the descriptor buffer,
+ *            indicated by the POINTER field after the JUMP command.
+ * @HALT: conditional halt - stop the execution of the current descriptor and
+ *        writes PKHA / Math condition bits as status / error code.
+ * @HALT_STATUS: conditional halt with user-specified status - stop the
+ *               execution of the current descriptor and writes the value of
+ *               "LOCAL OFFSET" JUMP field as status / error code.
+ * @GOSUB: conditional subroutine call - similar to @LOCAL_JUMP, but also saves
+ *         return address in the Return Address register; subroutine calls
+ *         cannot be nested.
+ * @RETURN: conditional subroutine return - similar to @LOCAL_JUMP, but the
+ *          offset is taken from the Return Address register.
+ * @LOCAL_JUMP_INC: similar to @LOCAL_JUMP, but increment the register specified
+ *                  in "SRC_DST" JUMP field before evaluating the jump
+ *                  condition.
+ * @LOCAL_JUMP_DEC: similar to @LOCAL_JUMP, but decrement the register specified
+ *                  in "SRC_DST" JUMP field before evaluating the jump
+ *                  condition.
+ */
+enum rta_jump_type {
+	LOCAL_JUMP,
+	FAR_JUMP,
+	HALT,
+	HALT_STATUS,
+	GOSUB,
+	RETURN,
+	LOCAL_JUMP_INC,
+	LOCAL_JUMP_DEC
+};
+
+/**
+ * enum rta_jump_cond - How test conditions are evaluated by JUMP command
+ * @ALL_TRUE: perform action if ALL selected conditions are true
+ * @ALL_FALSE: perform action if ALL selected conditions are false
+ * @ANY_TRUE: perform action if ANY of the selected conditions is true
+ * @ANY_FALSE: perform action if ANY of the selected conditions is false
+ */
+enum rta_jump_cond {
+	ALL_TRUE,
+	ALL_FALSE,
+	ANY_TRUE,
+	ANY_FALSE
+};
+
+/**
+ * enum rta_share_type - Types of sharing for JOB_HDR and SHR_HDR commands
+ * @SHR_NEVER: nothing is shared; descriptors can execute in parallel (i.e. no
+ *             dependencies are allowed between them).
+ * @SHR_WAIT: shared descriptor and keys are shared once the descriptor sets
+ *            "OK to share" in DECO Control Register (DCTRL).
+ * @SHR_SERIAL: shared descriptor and keys are shared once the descriptor has
+ *              completed.
+ * @SHR_ALWAYS: shared descriptor is shared anytime after the descriptor is
+ *              loaded.
+ * @SHR_DEFER: valid only for JOB_HDR; sharing type is the one specified
+ *             in the shared descriptor associated with the job descriptor.
+ */
+enum rta_share_type {
+	SHR_NEVER,
+	SHR_WAIT,
+	SHR_SERIAL,
+	SHR_ALWAYS,
+	SHR_DEFER
+};
+
+/* Registers definitions */
+enum rta_regs {
+	/* CCB Registers */
+	CONTEXT1 = 1,
+	CONTEXT2,
+	KEY1,
+	KEY2,
+	KEY1SZ,
+	KEY2SZ,
+	ICV1SZ,
+	ICV2SZ,
+	DATA1SZ,
+	DATA2SZ,
+	ALTDS1,
+	IV1SZ,
+	AAD1SZ,
+	MODE1,
+	MODE2,
+	CCTRL,
+	DCTRL,
+	ICTRL,
+	CLRW,
+	CSTAT,
+	IFIFO,
+	NFIFO,
+	OFIFO,
+	PKASZ,
+	PKBSZ,
+	PKNSZ,
+	PKESZ,
+	/* DECO Registers */
+	MATH0,
+	MATH1,
+	MATH2,
+	MATH3,
+	DESCBUF,
+	JOBDESCBUF,
+	SHAREDESCBUF,
+	DPOVRD,
+	DJQDA,
+	DSTAT,
+	DPID,
+	DJQCTRL,
+	ALTSOURCE,
+	SEQINSZ,
+	SEQOUTSZ,
+	VSEQINSZ,
+	VSEQOUTSZ,
+	/* PKHA Registers */
+	PKA,
+	PKN,
+	PKA0,
+	PKA1,
+	PKA2,
+	PKA3,
+	PKB,
+	PKB0,
+	PKB1,
+	PKB2,
+	PKB3,
+	PKE,
+	/* Pseudo registers */
+	AB1,
+	AB2,
+	ABD,
+	IFIFOABD,
+	IFIFOAB1,
+	IFIFOAB2,
+	AFHA_SBOX,
+	MDHA_SPLIT_KEY,
+	JOBSRC,
+	ZERO,
+	ONE,
+	AAD1,
+	IV1,
+	IV2,
+	MSG1,
+	MSG2,
+	MSG,
+	MSGOUTSNOOP,
+	MSGINSNOOP,
+	ICV1,
+	ICV2,
+	SKIP,
+	NONE,
+	RNGOFIFO,
+	RNG,
+	IDFNS,
+	ODFNS,
+	NFIFOSZ,
+	SZ,
+	PAD,
+	SAD1,
+	AAD2,
+	BIT_DATA,
+	NFIFO_SZL,
+	NFIFO_SZM,
+	NFIFO_L,
+	NFIFO_M,
+	SZL,
+	SZM,
+	JOBDESCBUF_EFF,
+	SHAREDESCBUF_EFF,
+	METADATA,
+	GTR,
+	STR,
+	OFIFO_SYNC,
+	MSGOUTSNOOP_ALT
+};
+
+/* Command flags */
+#define FLUSH1          BIT(0)
+#define LAST1           BIT(1)
+#define LAST2           BIT(2)
+#define IMMED           BIT(3)
+#define SGF             BIT(4)
+#define VLF             BIT(5)
+#define EXT             BIT(6)
+#define CONT            BIT(7)
+#define SEQ             BIT(8)
+#define AIDF		BIT(9)
+#define FLUSH2          BIT(10)
+#define CLASS1          BIT(11)
+#define CLASS2          BIT(12)
+#define BOTH            BIT(13)
+
+/**
+ * DCOPY - (AIOP only) command param is pointer to external memory
+ *
+ * CDMA must be used to transfer the key via DMA into Workspace Area.
+ * Valid only in combination with IMMED flag.
+ */
+#define DCOPY		BIT(30)
+
+#define COPY		BIT(31) /*command param is pointer (not immediate)
+				  valid only in combination when IMMED */
+
+#define __COPY_MASK	(COPY | DCOPY)
+
+/* SEQ IN/OUT PTR Command specific flags */
+#define RBS             BIT(16)
+#define INL             BIT(17)
+#define PRE             BIT(18)
+#define RTO             BIT(19)
+#define RJD             BIT(20)
+#define SOP		BIT(21)
+#define RST		BIT(22)
+#define EWS		BIT(23)
+
+#define ENC             BIT(14)	/* Encrypted Key */
+#define EKT             BIT(15)	/* AES CCM Encryption (default is
+				 * AES ECB Encryption) */
+#define TK              BIT(16)	/* Trusted Descriptor Key (default is
+				 * Job Descriptor Key) */
+#define NWB             BIT(17)	/* No Write Back Key */
+#define PTS             BIT(18)	/* Plaintext Store */
+
+/* HEADER Command specific flags */
+#define RIF             BIT(16)
+#define DNR             BIT(17)
+#define CIF             BIT(18)
+#define PD              BIT(19)
+#define RSMS            BIT(20)
+#define TD              BIT(21)
+#define MTD             BIT(22)
+#define REO             BIT(23)
+#define SHR             BIT(24)
+#define SC		BIT(25)
+/* Extended HEADER specific flags */
+#define DSV		BIT(7)
+#define DSEL_MASK	0x00000007	/* DECO Select */
+#define FTD		BIT(8)
+
+/* JUMP Command specific flags */
+#define NIFP            BIT(20)
+#define NIP             BIT(21)
+#define NOP             BIT(22)
+#define NCP             BIT(23)
+#define CALM            BIT(24)
+
+#define MATH_Z          BIT(25)
+#define MATH_N          BIT(26)
+#define MATH_NV         BIT(27)
+#define MATH_C          BIT(28)
+#define PK_0            BIT(29)
+#define PK_GCD_1        BIT(30)
+#define PK_PRIME        BIT(31)
+#define SELF            BIT(0)
+#define SHRD            BIT(1)
+#define JQP             BIT(2)
+
+/* NFIFOADD specific flags */
+#define PAD_ZERO        BIT(16)
+#define PAD_NONZERO     BIT(17)
+#define PAD_INCREMENT   BIT(18)
+#define PAD_RANDOM      BIT(19)
+#define PAD_ZERO_N1     BIT(20)
+#define PAD_NONZERO_0   BIT(21)
+#define PAD_N1          BIT(23)
+#define PAD_NONZERO_N   BIT(24)
+#define OC              BIT(25)
+#define BM              BIT(26)
+#define PR              BIT(27)
+#define PS              BIT(28)
+#define BP              BIT(29)
+
+/* MOVE Command specific flags */
+#define WAITCOMP        BIT(16)
+#define SIZE_WORD	BIT(17)
+#define SIZE_BYTE	BIT(18)
+#define SIZE_DWORD	BIT(19)
+
+/* MATH command specific flags */
+#define IFB         MATH_IFB
+#define NFU         MATH_NFU
+#define STL         MATH_STL
+#define SSEL        MATH_SSEL
+#define SWP         MATH_SWP
+#define IMMED2      BIT(31)
+
+/**
+ * struct program - descriptor buffer management structure
+ * @current_pc:	current offset in descriptor
+ * @current_instruction: current instruction in descriptor
+ * @first_error_pc: offset of the first error in descriptor
+ * @start_pc: start offset in descriptor buffer
+ * @buffer: buffer carrying descriptor
+ * @shrhdr: shared descriptor header
+ * @jobhdr: job descriptor header
+ * @ps: pointer fields size; if ps is true, pointers will be 36bits in
+ *      length; if ps is false, pointers will be 32bits in length
+ * @bswap: if true, perform byte swap on a 4-byte boundary
+ */
+struct program {
+	unsigned current_pc;
+	unsigned current_instruction;
+	unsigned first_error_pc;
+	unsigned start_pc;
+	uint32_t *buffer;
+	uint32_t *shrhdr;
+	uint32_t *jobhdr;
+	bool ps;
+	bool bswap;
+};
+
+static inline void rta_program_cntxt_init(struct program *program,
+					 uint32_t *buffer, unsigned offset)
+{
+	program->current_pc = 0;
+	program->current_instruction = 0;
+	program->first_error_pc = 0;
+	program->start_pc = offset;
+	program->buffer = buffer;
+	program->shrhdr = NULL;
+	program->jobhdr = NULL;
+	program->ps = false;
+	program->bswap = false;
+}
+
+static inline void __rta__desc_bswap(uint32_t *buff, unsigned buff_len)
+{
+	unsigned i;
+
+	for (i = 0; i < buff_len; i++)
+		buff[i] = swab32(buff[i]);
+}
+
+static inline unsigned rta_program_finalize(struct program *program)
+{
+	/* Descriptor is not allowed to go beyond 64 words size */
+	if (program->current_pc > MAX_CAAM_DESCSIZE)
+		pr_err("Descriptor Size exceeded max limit of 64 words\n");
+
+	/* Descriptor is erroneous */
+	if (program->first_error_pc)
+		pr_err("Descriptor creation error\n");
+
+	/* Update descriptor length in shared and job descriptor headers */
+	if (program->shrhdr != NULL) {
+		*program->shrhdr |= program->current_pc;
+		if (program->bswap)
+			__rta__desc_bswap(program->shrhdr, program->current_pc);
+	} else if (program->jobhdr != NULL) {
+		*program->jobhdr |= program->current_pc;
+		if (program->bswap)
+			__rta__desc_bswap(program->jobhdr, program->current_pc);
+	}
+
+	return program->current_pc;
+}
+
+static inline unsigned rta_program_set_36bit_addr(struct program *program)
+{
+	program->ps = true;
+	return program->current_pc;
+}
+
+static inline unsigned rta_program_set_bswap(struct program *program)
+{
+	program->bswap = true;
+	return program->current_pc;
+}
+
+static inline void __rta_out32(struct program *program, uint32_t val)
+{
+	program->buffer[program->current_pc] = val;
+	program->current_pc++;
+}
+
+static inline void __rta_out64(struct program *program, bool is_ext,
+			       uint64_t val)
+{
+	if (is_ext)
+		__rta_out32(program, upper_32_bits(val));
+
+	__rta_out32(program, lower_32_bits(val));
+}
+
+static inline unsigned rta_word(struct program *program, uint32_t val)
+{
+	unsigned start_pc = program->current_pc;
+
+	__rta_out32(program, val);
+
+	return start_pc;
+}
+
+static inline unsigned rta_dword(struct program *program, uint64_t val)
+{
+	unsigned start_pc = program->current_pc;
+
+	__rta_out64(program, true, val);
+
+	return start_pc;
+}
+
+static inline unsigned rta_copy_data(struct program *program, uint8_t *data,
+				     unsigned length)
+{
+	unsigned i;
+	unsigned start_pc = program->current_pc;
+	uint8_t *tmp = (uint8_t *)&program->buffer[program->current_pc];
+
+	for (i = 0; i < length; i++)
+		*tmp++ = data[i];
+	program->current_pc += (length + 3) / 4;
+
+	return start_pc;
+}
+
+#if defined(__EWL__) && defined(AIOP)
+static inline void __rta_dma_data(void *ws_dst, uint64_t ext_address,
+				  uint16_t size)
+{ cdma_read(ws_dst, ext_address, size); }
+#else
+static inline void __rta_dma_data(void *ws_dst, uint64_t ext_address,
+				  uint16_t size)
+{ pr_warn("RTA: DCOPY not supported, DMA will be skipped\n"); }
+#endif /* defined(__EWL__) && defined(AIOP) */
+
+static inline void __rta_inline_data(struct program *program, uint64_t data,
+				     uint32_t copy_data, uint32_t length)
+{
+	if (!copy_data) {
+		__rta_out64(program, length > 4, data);
+	} else if (copy_data & COPY) {
+		uint8_t *tmp = (uint8_t *)&program->buffer[program->current_pc];
+		uint32_t i;
+
+		for (i = 0; i < length; i++)
+			*tmp++ = ((uint8_t *)(uintptr_t)data)[i];
+		program->current_pc += ((length + 3) / 4);
+	} else if (copy_data & DCOPY) {
+		__rta_dma_data(&program->buffer[program->current_pc], data,
+			       (uint16_t)length);
+		program->current_pc += ((length + 3) / 4);
+	}
+}
+
+static inline unsigned rta_desc_len(uint32_t *buffer)
+{
+	if ((*buffer & CMD_MASK) == CMD_DESC_HDR)
+		return *buffer & HDR_DESCLEN_MASK;
+	else
+		return *buffer & HDR_DESCLEN_SHR_MASK;
+}
+
+static inline unsigned rta_desc_bytes(uint32_t *buffer)
+{
+	return (unsigned)(rta_desc_len(buffer) * CAAM_CMD_SZ);
+}
+
+static inline unsigned rta_set_label(struct program *program)
+{
+	return program->current_pc + program->start_pc;
+}
+
+static inline int rta_patch_move(struct program *program, int line,
+				 unsigned new_ref, bool check_swap)
+{
+	uint32_t opcode;
+	bool bswap = check_swap && program->bswap;
+
+	if (line < 0)
+		return -EINVAL;
+
+	opcode = bswap ? swab32(program->buffer[line]) : program->buffer[line];
+
+	opcode &= (uint32_t)~MOVE_OFFSET_MASK;
+	opcode |= (new_ref << (MOVE_OFFSET_SHIFT + 2)) & MOVE_OFFSET_MASK;
+	program->buffer[line] = bswap ? swab32(opcode) : opcode;
+
+	return 0;
+}
+
+static inline int rta_patch_jmp(struct program *program, int line,
+				unsigned new_ref, bool check_swap)
+{
+	uint32_t opcode;
+	bool bswap = check_swap && program->bswap;
+
+	if (line < 0)
+		return -EINVAL;
+
+	opcode = bswap ? swab32(program->buffer[line]) : program->buffer[line];
+
+	opcode &= (uint32_t)~JUMP_OFFSET_MASK;
+	opcode |= (new_ref - (line + program->start_pc)) & JUMP_OFFSET_MASK;
+	program->buffer[line] = bswap ? swab32(opcode) : opcode;
+
+	return 0;
+}
+
+static inline int rta_patch_header(struct program *program, int line,
+				   unsigned new_ref, bool check_swap)
+{
+	uint32_t opcode;
+	bool bswap = check_swap && program->bswap;
+
+	if (line < 0)
+		return -EINVAL;
+
+	opcode = bswap ? swab32(program->buffer[line]) : program->buffer[line];
+
+	opcode &= (uint32_t)~HDR_START_IDX_MASK;
+	opcode |= (new_ref << HDR_START_IDX_SHIFT) & HDR_START_IDX_MASK;
+	program->buffer[line] = bswap ? swab32(opcode) : opcode;
+
+	return 0;
+}
+
+static inline int rta_patch_load(struct program *program, int line,
+				 unsigned new_ref)
+{
+	uint32_t opcode;
+
+	if (line < 0)
+		return -EINVAL;
+
+	opcode = program->buffer[line] & (uint32_t)~LDST_OFFSET_MASK;
+
+	if (opcode & (LDST_SRCDST_WORD_DESCBUF | LDST_CLASS_DECO))
+		opcode |= (new_ref << LDST_OFFSET_SHIFT) & LDST_OFFSET_MASK;
+	else
+		opcode |= (new_ref << (LDST_OFFSET_SHIFT + 2)) &
+			  LDST_OFFSET_MASK;
+
+	program->buffer[line] = opcode;
+
+	return 0;
+}
+
+static inline int rta_patch_store(struct program *program, int line,
+				  unsigned new_ref, bool check_swap)
+{
+	uint32_t opcode;
+	bool bswap = check_swap && program->bswap;
+
+	if (line < 0)
+		return -EINVAL;
+
+	opcode = bswap ? swab32(program->buffer[line]) : program->buffer[line];
+
+	opcode &= (uint32_t)~LDST_OFFSET_MASK;
+
+	switch (opcode & LDST_SRCDST_MASK) {
+	case LDST_SRCDST_WORD_DESCBUF:
+	case LDST_SRCDST_WORD_DESCBUF_JOB:
+	case LDST_SRCDST_WORD_DESCBUF_SHARED:
+	case LDST_SRCDST_WORD_DESCBUF_JOB_WE:
+	case LDST_SRCDST_WORD_DESCBUF_SHARED_WE:
+		opcode |= ((new_ref) << LDST_OFFSET_SHIFT) & LDST_OFFSET_MASK;
+		break;
+	default:
+		opcode |= (new_ref << (LDST_OFFSET_SHIFT + 2)) &
+			  LDST_OFFSET_MASK;
+	}
+
+	program->buffer[line] = bswap ? swab32(opcode) : opcode;
+
+	return 0;
+}
+
+static inline int rta_patch_raw(struct program *program, int line,
+				unsigned mask, unsigned new_val,
+				bool check_swap)
+{
+	uint32_t opcode;
+	bool bswap = check_swap && program->bswap;
+
+	if (line < 0)
+		return -EINVAL;
+
+	opcode = bswap ? swab32(program->buffer[line]) : program->buffer[line];
+
+	opcode &= (uint32_t)~mask;
+	opcode |= new_val & mask;
+	program->buffer[line] = bswap ? swab32(opcode) : opcode;
+
+	return 0;
+}
+
+static inline int __rta_map_opcode(uint32_t name,
+				  const uint32_t (*map_table)[2],
+				  unsigned num_of_entries, uint32_t *val)
+{
+	unsigned i;
+
+	for (i = 0; i < num_of_entries; i++)
+		if (map_table[i][0] == name) {
+			*val = map_table[i][1];
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static inline void __rta_map_flags(uint32_t flags,
+				   const uint32_t (*flags_table)[2],
+				   unsigned num_of_entries, uint32_t *opcode)
+{
+	unsigned i;
+
+	for (i = 0; i < num_of_entries; i++) {
+		if (flags_table[i][0] & flags)
+			*opcode |= flags_table[i][1];
+	}
+}
+
+#endif /* __RTA_SEC_RUN_TIME_ASM_H__ */
-- 
1.8.3.1

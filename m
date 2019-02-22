Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A2BC10F0B
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA0D2075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pUY2y3JH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfBVKHa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:07:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44916 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfBVKHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 05:07:30 -0500
Received: by mail-wr1-f66.google.com with SMTP id w2so1678680wrt.11
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 02:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TglLBHJtGQaUVUXC6KSp1Yy8g5TUdPW6NThBdmM+eu8=;
        b=pUY2y3JHn//YeXbZXscqs5C5YqIZKs835uv+iepCYAzxSaWhqq41/Q7q/NZZjySX6Y
         fheYEMbSAcYWAmWI7EGK3VmzynFpiYMgwa8k7rhfo3PDb3GOAlJTSKCFuAzN1rxOk/nl
         Y6u34tn6+yyI8fulsy+4JtVcWhV/cj4vJC61GNFCXIg0NGBJ3cJDO/zoAAhbGmdEKQH4
         lmhplQ4lRaaU4vfpYm+8fYCAeOQFPjBdjWgWYo5j+wrhf0psjplR1gj50/jBXyiNup/X
         1nBkXmCc4Z7LGCBSWihn15bxyLK+pZwmj7UlkflbQfFWezlcHmYfH6sFgNeIq6YtwG/2
         hyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TglLBHJtGQaUVUXC6KSp1Yy8g5TUdPW6NThBdmM+eu8=;
        b=JPzUk3R+ImPMn587ozWCjDu/7bgJo8A2Js+zjF6zimE45GAZvUWORCpPO1XmRy7UyK
         wvlbXIeA4p16nUU4BRjA9eiZna6AVRcYAqJr2cQhGqd6cLvRJU+bRkGbjWfl69ByGQSe
         Y9BbsAwIEFELPEsPqpAjna6rikzCTzHPBLE/J4I0DWqFpMUF5zU+V4+6QbIQNgJYFWMJ
         zdImjFAMr1aGpMdrh2LrTcBQ5EYbCorFFiLVOP873S/FMNXo3+j7+RdBIS30iGIB16MD
         0X7jkT4XAToztLpV+LajBlR/3F6AzUR/KWuLC39mjt0yvgdNpav9XSj3vt7J24fCfIwv
         Jngg==
X-Gm-Message-State: AHQUAuYHsN+qw9pIcRhaERtbmN7Fl08yoiK1AeyLyVXjCpXjMRqQQEJn
        6t1n8ITNXltBZ1dhvTCgCTU=
X-Google-Smtp-Source: AHgI3IYCjUygzkRk4C58j3ybmipwHDddvs+1OWklEDbyPcKqq+nAtiK+e0B4MiDaLAvPpExs+bMdlw==
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr2249429wrw.314.1550830047658;
        Fri, 22 Feb 2019 02:07:27 -0800 (PST)
Received: from roadflow-linux-dev.dtes.tfl.gov.uk (host81-149-116-186.in-addr.btopenworld.com. [81.149.116.186])
        by smtp.gmail.com with ESMTPSA id j41sm2094240wre.9.2019.02.22.02.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 02:07:26 -0800 (PST)
From:   spencercw@gmail.com
X-Google-Original-From: christopher.spencer@sea.co.uk
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     linux-crypto@vger.kernel.org,
        Chris Spencer <christopher.spencer@sea.co.uk>
Subject: [RFC 3/4] crypto: caam - correct DMA address size for the i.MX8
Date:   Fri, 22 Feb 2019 10:06:12 +0000
Message-Id: <20190222100613.2290-4-christopher.spencer@sea.co.uk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

The i.MX8 is arm64, but its CAAM DMA address size is 32-bits.

Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>
---
 drivers/crypto/caam/ctrl.c        |  5 +++-
 drivers/crypto/caam/desc_constr.h | 27 +++++++++--------
 drivers/crypto/caam/intern.h      |  4 +--
 drivers/crypto/caam/jr.c          |  4 ++-
 drivers/crypto/caam/pdb.h         | 49 ++++++++++++++++---------------
 drivers/crypto/caam/regs.h        | 21 +++++++++++--
 6 files changed, 66 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1f841f37ce3c..36543a151e1e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -688,7 +688,10 @@ static int caam_probe(struct platform_device *pdev)
 			      JRSTART_JR1_START | JRSTART_JR2_START |
 			      JRSTART_JR3_START);
 
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	/* Set DMA masks according to platform ranging */
+	if (of_machine_is_compatible("fsl,imx8mq")) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	} else if (sizeof(dma_addr_t) == sizeof(u64)) {
 		if (caam_dpaa2)
 			ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(49));
 		else if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 2980b8ef1fb1..f33019c8aacc 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -13,7 +13,7 @@
 
 #define IMMEDIATE (1 << 23)
 #define CAAM_CMD_SZ sizeof(u32)
-#define CAAM_PTR_SZ sizeof(dma_addr_t)
+#define CAAM_PTR_SZ sizeof(caam_dma_addr_t)
 #define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
 #define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
 
@@ -90,9 +90,9 @@ static inline void init_job_desc_pdb(u32 * const desc, u32 options,
 	init_job_desc(desc, (((pdb_len + 1) << HDR_START_IDX_SHIFT)) | options);
 }
 
-static inline void append_ptr(u32 * const desc, dma_addr_t ptr)
+static inline void append_ptr(u32 * const desc, caam_dma_addr_t ptr)
 {
-	dma_addr_t *offset = (dma_addr_t *)desc_end(desc);
+	caam_dma_addr_t *offset = (caam_dma_addr_t *)desc_end(desc);
 
 	*offset = cpu_to_caam_dma(ptr);
 
@@ -100,7 +100,7 @@ static inline void append_ptr(u32 * const desc, dma_addr_t ptr)
 				CAAM_PTR_SZ / CAAM_CMD_SZ);
 }
 
-static inline void init_job_desc_shared(u32 * const desc, dma_addr_t ptr,
+static inline void init_job_desc_shared(u32 * const desc, caam_dma_addr_t ptr,
 					int len, u32 options)
 {
 	PRINT_POS;
@@ -155,15 +155,15 @@ static inline u32 *write_cmd(u32 * const desc, u32 command)
 	return desc + 1;
 }
 
-static inline void append_cmd_ptr(u32 * const desc, dma_addr_t ptr, int len,
-				  u32 command)
+static inline void append_cmd_ptr(u32 * const desc, caam_dma_addr_t ptr,
+				  int len, u32 command)
 {
 	append_cmd(desc, command | len);
 	append_ptr(desc, ptr);
 }
 
 /* Write length after pointer, rather than inside command */
-static inline void append_cmd_ptr_extlen(u32 * const desc, dma_addr_t ptr,
+static inline void append_cmd_ptr_extlen(u32 * const desc, caam_dma_addr_t ptr,
 					 unsigned int len, u32 command)
 {
 	append_cmd(desc, command);
@@ -228,7 +228,7 @@ APPEND_CMD_LEN(seq_fifo_load, SEQ_FIFO_LOAD)
 APPEND_CMD_LEN(seq_fifo_store, SEQ_FIFO_STORE)
 
 #define APPEND_CMD_PTR(cmd, op) \
-static inline void append_##cmd(u32 * const desc, dma_addr_t ptr, \
+static inline void append_##cmd(u32 * const desc, caam_dma_addr_t ptr, \
 				unsigned int len, u32 options) \
 { \
 	PRINT_POS; \
@@ -239,7 +239,7 @@ APPEND_CMD_PTR(load, LOAD)
 APPEND_CMD_PTR(fifo_load, FIFO_LOAD)
 APPEND_CMD_PTR(fifo_store, FIFO_STORE)
 
-static inline void append_store(u32 * const desc, dma_addr_t ptr,
+static inline void append_store(u32 * const desc, caam_dma_addr_t ptr,
 				unsigned int len, u32 options)
 {
 	u32 cmd_src;
@@ -258,7 +258,7 @@ static inline void append_store(u32 * const desc, dma_addr_t ptr,
 
 #define APPEND_SEQ_PTR_INTLEN(cmd, op) \
 static inline void append_seq_##cmd##_ptr_intlen(u32 * const desc, \
-						 dma_addr_t ptr, \
+						 caam_dma_addr_t ptr, \
 						 unsigned int len, \
 						 u32 options) \
 { \
@@ -282,7 +282,8 @@ APPEND_CMD_PTR_TO_IMM(load, LOAD);
 APPEND_CMD_PTR_TO_IMM(fifo_load, FIFO_LOAD);
 
 #define APPEND_CMD_PTR_EXTLEN(cmd, op) \
-static inline void append_##cmd##_extlen(u32 * const desc, dma_addr_t ptr, \
+static inline void append_##cmd##_extlen(u32 * const desc, \
+					 caam_dma_addr_t ptr, \
 					 unsigned int len, u32 options) \
 { \
 	PRINT_POS; \
@@ -296,7 +297,7 @@ APPEND_CMD_PTR_EXTLEN(seq_out_ptr, SEQ_OUT_PTR)
  * the size of its type
  */
 #define APPEND_CMD_PTR_LEN(cmd, op, type) \
-static inline void append_##cmd(u32 * const desc, dma_addr_t ptr, \
+static inline void append_##cmd(u32 * const desc, caam_dma_addr_t ptr, \
 				type len, u32 options) \
 { \
 	PRINT_POS; \
@@ -456,7 +457,7 @@ struct alginfo {
 	unsigned int keylen;
 	unsigned int keylen_pad;
 	union {
-		dma_addr_t key_dma;
+		caam_dma_addr_t key_dma;
 		const void *key_virt;
 	};
 	bool key_inline;
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index a4baa6a3d2f1..0fed4915031f 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -32,7 +32,7 @@ struct caam_jrentry_info {
 	void (*callbk)(struct device *dev, u32 *desc, u32 status, void *arg);
 	void *cbkarg;	/* Argument per ring entry */
 	u32 *desc_addr_virt;	/* Stored virt addr for postprocessing */
-	dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
+	caam_dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
 	u32 desc_size;	/* Stored size for postprocessing, header derived */
 };
 
@@ -54,7 +54,7 @@ struct caam_drv_private_jr {
 	spinlock_t inplock ____cacheline_aligned; /* Input ring index lock */
 	int inp_ring_write_index;	/* Input index "tail" */
 	int head;			/* entinfo (s/w ring) head index */
-	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
+	caam_dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
 	spinlock_t outlock ____cacheline_aligned; /* Output ring index lock */
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d50085a03597..ac5ae14be233 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -501,7 +501,9 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	jrpriv->rregs = (struct caam_job_ring __iomem __force *)ctrl;
 
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	if (of_machine_is_compatible("fsl,imx8mq")) {
+		error = dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(32));
+	} else if (sizeof(dma_addr_t) == sizeof(u64)) {
 		if (caam_dpaa2)
 			error = dma_set_mask_and_coherent(jrdev,
 							  DMA_BIT_MASK(49));
diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 810f0bef0652..128d16682feb 100644
--- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -9,6 +9,7 @@
 #ifndef CAAM_PDB_H
 #define CAAM_PDB_H
 #include "compat.h"
+#include "regs.h"
 
 /*
  * PDB- IPSec ESP Header Modification Options
@@ -507,10 +508,10 @@ struct dsa_verify_pdb {
  */
 struct rsa_pub_pdb {
 	u32		sgf;
-	dma_addr_t	f_dma;
-	dma_addr_t	g_dma;
-	dma_addr_t	n_dma;
-	dma_addr_t	e_dma;
+	caam_dma_addr_t	f_dma;
+	caam_dma_addr_t	g_dma;
+	caam_dma_addr_t	n_dma;
+	caam_dma_addr_t	e_dma;
 	u32		f_len;
 } __packed;
 
@@ -524,10 +525,10 @@ struct rsa_pub_pdb {
  */
 struct rsa_priv_f1_pdb {
 	u32		sgf;
-	dma_addr_t	g_dma;
-	dma_addr_t	f_dma;
-	dma_addr_t	n_dma;
-	dma_addr_t	d_dma;
+	caam_dma_addr_t	g_dma;
+	caam_dma_addr_t	f_dma;
+	caam_dma_addr_t	n_dma;
+	caam_dma_addr_t	d_dma;
 } __packed;
 
 /**
@@ -546,13 +547,13 @@ struct rsa_priv_f1_pdb {
  */
 struct rsa_priv_f2_pdb {
 	u32		sgf;
-	dma_addr_t	g_dma;
-	dma_addr_t	f_dma;
-	dma_addr_t	d_dma;
-	dma_addr_t	p_dma;
-	dma_addr_t	q_dma;
-	dma_addr_t	tmp1_dma;
-	dma_addr_t	tmp2_dma;
+	caam_dma_addr_t	g_dma;
+	caam_dma_addr_t	f_dma;
+	caam_dma_addr_t	d_dma;
+	caam_dma_addr_t	p_dma;
+	caam_dma_addr_t	q_dma;
+	caam_dma_addr_t	tmp1_dma;
+	caam_dma_addr_t	tmp2_dma;
 	u32		p_q_len;
 } __packed;
 
@@ -576,15 +577,15 @@ struct rsa_priv_f2_pdb {
  */
 struct rsa_priv_f3_pdb {
 	u32		sgf;
-	dma_addr_t	g_dma;
-	dma_addr_t	f_dma;
-	dma_addr_t	c_dma;
-	dma_addr_t	p_dma;
-	dma_addr_t	q_dma;
-	dma_addr_t	dp_dma;
-	dma_addr_t	dq_dma;
-	dma_addr_t	tmp1_dma;
-	dma_addr_t	tmp2_dma;
+	caam_dma_addr_t	g_dma;
+	caam_dma_addr_t	f_dma;
+	caam_dma_addr_t	c_dma;
+	caam_dma_addr_t	p_dma;
+	caam_dma_addr_t	q_dma;
+	caam_dma_addr_t	dp_dma;
+	caam_dma_addr_t	dq_dma;
+	caam_dma_addr_t	tmp1_dma;
+	caam_dma_addr_t	tmp2_dma;
 	u32		p_q_len;
 } __packed;
 
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3cd0822ea819..5c89ca0361cf 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -137,7 +137,7 @@ static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set)
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && !defined(CONFIG_ARCH_MXC)
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
 	if (caam_little_end)
@@ -195,7 +195,7 @@ static inline u64 caam_dma64_to_cpu(u64 value)
 	return caam64_to_cpu(value);
 }
 
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) && !defined(CONFIG_ARCH_MXC)
 #define cpu_to_caam_dma(value) cpu_to_caam_dma64(value)
 #define caam_dma_to_cpu(value) caam_dma64_to_cpu(value)
 #else
@@ -203,12 +203,27 @@ static inline u64 caam_dma64_to_cpu(u64 value)
 #define caam_dma_to_cpu(value) caam32_to_cpu(value)
 #endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT */
 
+/*
+ * On i.MX8 boards the arch is arm64 but the CAAM dma address size is
+ * 32 bits on 8MQ and 36 bits on 8QM and 8QXP.
+ * For 8QM and 8QXP there is a configurable field PS called pointer size
+ * in the MCFGR register to switch between 32 and 64 (default 32)
+ * But this register is only accessible by the SECO and is left to its
+ * default value.
+ * Here we set the CAAM dma address size to 32 bits for all i.MX8
+ */
+#if defined(CONFIG_ARM64) && defined(CONFIG_ARCH_MXC)
+#define caam_dma_addr_t u32
+#else
+#define caam_dma_addr_t dma_addr_t
+#endif
+
 /*
  * jr_outentry
  * Represents each entry in a JobR output ring
  */
 struct jr_outentry {
-	dma_addr_t desc;/* Pointer to completed descriptor */
+	caam_dma_addr_t desc;/* Pointer to completed descriptor */
 	u32 jrstatus;	/* Status for completed descriptor */
 } __packed;
 
-- 
2.17.1


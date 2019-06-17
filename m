Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B61FC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3DAB208E4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sRH887l0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFQQEW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:04:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32788 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfFQQEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 12:04:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id x15so5947567pfq.0;
        Mon, 17 Jun 2019 09:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=guTRsD6ZFktfifCheEZhdiL8+ijEC1xociU3D+jPwdc=;
        b=sRH887l0Pz5mEdWT5Yqev+B2X4VScz5pxCY/BSxYsVGsJ7MPjT1HDniCFRmfq2Sjt7
         gQoPO5dZj1i+lH2XL9ZhcdC9gVIEBvhby2cUR8M+tvRgcPC0tP0J9OMZD8kXsIraZ0c7
         ks5aUbNJpsljRR61D0puf5l6XrEtxtTWTS3c5PAUFe8I+T9/Rhf/YHTLfAd3LZUQA8eC
         L6Woe0wxpBfIW3/B7uUdvUyNDwxkze9xI1eeO7Gs0d23IGOkQbTZOFmPg27NMiBnM6Q5
         NjVUaEi2wzFYJ4CEdwlUYlInOIyoGOSivKdYQUenbBwORXtj8AjP5SUIUQ3vNMpERMxA
         FPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=guTRsD6ZFktfifCheEZhdiL8+ijEC1xociU3D+jPwdc=;
        b=jUlVdZ3PCeeyzYnNy3vD8lNrOqUn4OY68Wdqk5kHS86ve/DQIsjW9Wfoy2LAM0wnJt
         SPf0BNNgMcmo3Z6pDjHXW8FOMAP7II5wzkJaaF0of8TziH3YqfX4sx1Gx5vUoWuSeAc9
         R3gXKUTsm9wCB0ItA5876R1S+BJx38S3cOWaPkCis1Bh6wZSJ+/OM21xJyE68FcHPCD8
         ZT404cHIpIwkKKxH/mFqpkLEEqbTF4dKCxvnW+f+g2LTsPQXBwpalvjc+2LuNA7MXvjl
         8ENnvcjqwdplwyXDMFTvZJtGfNdxPjLtU9MguwdWTLpktyJiKdsWkGLZ2CqyrxxQTef7
         Tc4A==
X-Gm-Message-State: APjAAAWwd1t/Wnk5QM/Ot5DexfM2jlXBjDO6kT2p+Db3wfIwLqIRQQL4
        GniC3BHRp4M1wKqhoUa/sxIvu5qYz4I=
X-Google-Smtp-Source: APXvYqxusdVhd1QsDAFaWzQWJKvaPkIIuNYMqLnNhpsdbFNd6ykx8ynLcRIiZhZIseCQfQHL8JeYTQ==
X-Received: by 2002:a17:90a:db52:: with SMTP id u18mr27032101pjx.107.1560787439242;
        Mon, 17 Jun 2019 09:03:59 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id d187sm12834073pfa.38.2019.06.17.09.03.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:03:58 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] crypto: caam - correct DMA address size for the i.MX8
Date:   Mon, 17 Jun 2019 09:03:36 -0700
Message-Id: <20190617160339.29179-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617160339.29179-1-andrew.smirnov@gmail.com>
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

The i.MX8 is arm64, but its CAAM DMA address size is 32-bits.

Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/desc_constr.h | 24 +++++++--------
 drivers/crypto/caam/intern.h      |  6 ++--
 drivers/crypto/caam/pdb.h         | 49 ++++++++++++++++---------------
 drivers/crypto/caam/regs.h        | 21 +++++++++++--
 4 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 5988a26a2441..fc8042e63b18 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -14,7 +14,7 @@
 
 #define IMMEDIATE (1 << 23)
 #define CAAM_CMD_SZ sizeof(u32)
-#define CAAM_PTR_SZ sizeof(dma_addr_t)
+#define CAAM_PTR_SZ sizeof(caam_dma_addr_t)
 #define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
 #define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
 
@@ -101,9 +101,9 @@ static inline void init_job_desc_pdb(u32 * const desc, u32 options,
 	init_job_desc(desc, (((pdb_len + 1) << HDR_START_IDX_SHIFT)) | options);
 }
 
-static inline void append_ptr(u32 * const desc, dma_addr_t ptr)
+static inline void append_ptr(u32 * const desc, caam_dma_addr_t ptr)
 {
-	dma_addr_t *offset = (dma_addr_t *)desc_end(desc);
+	caam_dma_addr_t *offset = (caam_dma_addr_t *)desc_end(desc);
 
 	*offset = cpu_to_caam_dma(ptr);
 
@@ -111,7 +111,7 @@ static inline void append_ptr(u32 * const desc, dma_addr_t ptr)
 				CAAM_PTR_SZ / CAAM_CMD_SZ);
 }
 
-static inline void init_job_desc_shared(u32 * const desc, dma_addr_t ptr,
+static inline void init_job_desc_shared(u32 * const desc, caam_dma_addr_t ptr,
 					int len, u32 options)
 {
 	PRINT_POS;
@@ -166,7 +166,7 @@ static inline u32 *write_cmd(u32 * const desc, u32 command)
 	return desc + 1;
 }
 
-static inline void append_cmd_ptr(u32 * const desc, dma_addr_t ptr, int len,
+static inline void append_cmd_ptr(u32 * const desc, caam_dma_addr_t ptr, int len,
 				  u32 command)
 {
 	append_cmd(desc, command | len);
@@ -174,7 +174,7 @@ static inline void append_cmd_ptr(u32 * const desc, dma_addr_t ptr, int len,
 }
 
 /* Write length after pointer, rather than inside command */
-static inline void append_cmd_ptr_extlen(u32 * const desc, dma_addr_t ptr,
+static inline void append_cmd_ptr_extlen(u32 * const desc, caam_dma_addr_t ptr,
 					 unsigned int len, u32 command)
 {
 	append_cmd(desc, command);
@@ -239,7 +239,7 @@ APPEND_CMD_LEN(seq_fifo_load, SEQ_FIFO_LOAD)
 APPEND_CMD_LEN(seq_fifo_store, SEQ_FIFO_STORE)
 
 #define APPEND_CMD_PTR(cmd, op) \
-static inline void append_##cmd(u32 * const desc, dma_addr_t ptr, \
+static inline void append_##cmd(u32 * const desc, caam_dma_addr_t ptr, \
 				unsigned int len, u32 options) \
 { \
 	PRINT_POS; \
@@ -250,7 +250,7 @@ APPEND_CMD_PTR(load, LOAD)
 APPEND_CMD_PTR(fifo_load, FIFO_LOAD)
 APPEND_CMD_PTR(fifo_store, FIFO_STORE)
 
-static inline void append_store(u32 * const desc, dma_addr_t ptr,
+static inline void append_store(u32 * const desc, caam_dma_addr_t ptr,
 				unsigned int len, u32 options)
 {
 	u32 cmd_src;
@@ -269,7 +269,7 @@ static inline void append_store(u32 * const desc, dma_addr_t ptr,
 
 #define APPEND_SEQ_PTR_INTLEN(cmd, op) \
 static inline void append_seq_##cmd##_ptr_intlen(u32 * const desc, \
-						 dma_addr_t ptr, \
+						 caam_dma_addr_t ptr, \
 						 unsigned int len, \
 						 u32 options) \
 { \
@@ -293,7 +293,7 @@ APPEND_CMD_PTR_TO_IMM(load, LOAD);
 APPEND_CMD_PTR_TO_IMM(fifo_load, FIFO_LOAD);
 
 #define APPEND_CMD_PTR_EXTLEN(cmd, op) \
-static inline void append_##cmd##_extlen(u32 * const desc, dma_addr_t ptr, \
+static inline void append_##cmd##_extlen(u32 * const desc, caam_dma_addr_t ptr, \
 					 unsigned int len, u32 options) \
 { \
 	PRINT_POS; \
@@ -307,7 +307,7 @@ APPEND_CMD_PTR_EXTLEN(seq_out_ptr, SEQ_OUT_PTR)
  * the size of its type
  */
 #define APPEND_CMD_PTR_LEN(cmd, op, type) \
-static inline void append_##cmd(u32 * const desc, dma_addr_t ptr, \
+static inline void append_##cmd(u32 * const desc, caam_dma_addr_t ptr, \
 				type len, u32 options) \
 { \
 	PRINT_POS; \
@@ -467,7 +467,7 @@ struct alginfo {
 	unsigned int keylen;
 	unsigned int keylen_pad;
 	union {
-		dma_addr_t key_dma;
+		caam_dma_addr_t key_dma;
 		const void *key_virt;
 	};
 	bool key_inline;
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index ec25d260fa40..bf115f8ddb93 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -34,7 +34,7 @@ struct caam_jrentry_info {
 	void (*callbk)(struct device *dev, u32 *desc, u32 status, void *arg);
 	void *cbkarg;	/* Argument per ring entry */
 	u32 *desc_addr_virt;	/* Stored virt addr for postprocessing */
-	dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
+	caam_dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
 	u32 desc_size;	/* Stored size for postprocessing, header derived */
 };
 
@@ -55,7 +55,7 @@ struct caam_drv_private_jr {
 	spinlock_t inplock ____cacheline_aligned; /* Input ring index lock */
 	u32 inpring_avail;	/* Number of free entries in input ring */
 	int head;			/* entinfo (s/w ring) head index */
-	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
+	caam_dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
 	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */
@@ -221,7 +221,7 @@ static inline u64 caam_get_dma_mask(struct device *dev)
 {
 	struct device_node *nprop = dev->of_node;
 
-	if (sizeof(dma_addr_t) != sizeof(u64))
+	if (sizeof(caam_dma_addr_t) != sizeof(u64))
 		return DMA_BIT_MASK(32);
 
 	if (caam_dpaa2)
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
index 8591914d5c51..6e7f8d4f3f2b 100644
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
2.21.0


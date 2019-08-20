Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7D3C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D3C22332A
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vx6rvJwz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfHTUZa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:25:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35285 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbfHTUYh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn20so46622plb.2;
        Tue, 20 Aug 2019 13:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zcdJ2383gRWyHa3sN5KeTzgbLyuzp/o0IWO8r/fEKZM=;
        b=Vx6rvJwziy1hSqDiHqZUnBQvlWGEb4M81/8DvlohZCNIa0RrjQXtSplpWIydrCqPMc
         M8YW4WnSoFKVw+A7Qda+ZD+WBkFWlL8RdjrSLhn/yUUugtaZNX3UTyLjS/GBlT5LDLX2
         HdpH5l8XCxZQw0zo2s3S/NUTDzDe70rnmIzaxGJ/Q11+SzXSnxSt6cnpo5mJy2R+ClVu
         YwdEDChFzam2/jIaA3sorXGlzezlLfFy7PpuiUSYN04Py5U43D099f+DHKTkUaXnz0SD
         4P6NCatQRFjuNL+0vbruTQ/jVp1y40dClvZ8bKRhrPazUFhgTLFjWda7hC2hGu/7M9y+
         JPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zcdJ2383gRWyHa3sN5KeTzgbLyuzp/o0IWO8r/fEKZM=;
        b=RJ1pqlxDX4LjF02SeoeRjBavEYmNpSzUVDGoPDgMVP6vuitFnB1DSnhIfW7rOU2qfx
         Ymu+FU3iYV4gFjh6aF6vRZSA7ubeNk6Be+RHVJUHKZz/FhGWkwWlcTmStm2I7fYPYmWQ
         fARcYZwDqUxf1e+qMRv9wLip8e0sRopUaWJHP7zu6x04em5/15e9+BUSTZ/Dcy2xStQd
         6ADgGKmNonJTqMTS0Yg5A64AryvdfNvH9zTE/LO0bzjah2dWp7Z7B8vJjxTMa+dJ4ONC
         1Q40/2NbyP/ej0YSRGqg/bKWwRmoi6A7fNyKkSKrj9nFF/ljbOqErbT8T+bORLJLcfVZ
         uJ9g==
X-Gm-Message-State: APjAAAUI0zLlycrqmZ9pOsUySNTc6ZGMwKMq9oJXECUuuCDOz9tQpYh7
        VkTsGFMORgt9/CSSxKce7pbJKIwHbRU=
X-Google-Smtp-Source: APXvYqwfDRU3ijnq4R11VfDFYoN7b3goinA5Cf7yK2NH+h55Skpayjp/6PYRjUQb7e7yIoEzPpuaXw==
X-Received: by 2002:a17:902:7781:: with SMTP id o1mr29880094pll.205.1566332676423;
        Tue, 20 Aug 2019 13:24:36 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:35 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 13/16] crypto: caam - select DMA address size at runtime
Date:   Tue, 20 Aug 2019 13:23:59 -0700
Message-Id: <20190820202402.24951-14-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

i.MX8 mScale SoC still use 32-bit addresses in its CAAM implmentation,
so we can't rely on sizeof(dma_addr_t) to detemine CAAM pointer
size. Convert the code to query CTPR and MCFGR for that during driver
probing.

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
 drivers/crypto/caam/caampkc.c     |  8 +++----
 drivers/crypto/caam/ctrl.c        |  5 +++-
 drivers/crypto/caam/desc_constr.h | 10 ++++++--
 drivers/crypto/caam/intern.h      |  2 +-
 drivers/crypto/caam/pdb.h         | 16 +++++++++----
 drivers/crypto/caam/pkc_desc.c    |  8 +++----
 drivers/crypto/caam/regs.h        | 40 +++++++++++++++++++++++--------
 7 files changed, 63 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 5b12b232ee5e..83f96d4f86e0 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -17,13 +17,13 @@
 #include "sg_sw_sec4.h"
 #include "caampkc.h"
 
-#define DESC_RSA_PUB_LEN	(2 * CAAM_CMD_SZ + sizeof(struct rsa_pub_pdb))
+#define DESC_RSA_PUB_LEN	(2 * CAAM_CMD_SZ + SIZEOF_RSA_PUB_PDB)
 #define DESC_RSA_PRIV_F1_LEN	(2 * CAAM_CMD_SZ + \
-				 sizeof(struct rsa_priv_f1_pdb))
+				 SIZEOF_RSA_PRIV_F1_PDB)
 #define DESC_RSA_PRIV_F2_LEN	(2 * CAAM_CMD_SZ + \
-				 sizeof(struct rsa_priv_f2_pdb))
+				 SIZEOF_RSA_PRIV_F2_PDB)
 #define DESC_RSA_PRIV_F3_LEN	(2 * CAAM_CMD_SZ + \
-				 sizeof(struct rsa_priv_f3_pdb))
+				 SIZEOF_RSA_PRIV_F3_PDB)
 #define CAAM_RSA_MAX_INPUT_SIZE	512 /* for a 4096-bit modulus */
 
 /* buffer filled with zeros, used for padding */
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 47b92451756f..4b7f95f64e34 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -602,7 +602,10 @@ static int caam_probe(struct platform_device *pdev)
 	caam_imx = (bool)imx_soc_match;
 
 	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
-	caam_ptr_sz = sizeof(dma_addr_t);
+	if (comp_params & CTPR_MS_PS && rd_reg32(&ctrl->mcr) & MCFGR_LONG_PTR)
+		caam_ptr_sz = sizeof(u64);
+	else
+		caam_ptr_sz = sizeof(u32);
 	caam_dpaa2 = !!(comp_params & CTPR_MS_DPAA2);
 	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
 
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 89187831d74f..62ce6421bb3f 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -136,9 +136,15 @@ static inline void init_job_desc_pdb(u32 * const desc, u32 options,
 
 static inline void append_ptr(u32 * const desc, dma_addr_t ptr)
 {
-	dma_addr_t *offset = (dma_addr_t *)desc_end(desc);
+	if (caam_ptr_sz == sizeof(dma_addr_t)) {
+		dma_addr_t *offset = (dma_addr_t *)desc_end(desc);
 
-	*offset = cpu_to_caam_dma(ptr);
+		*offset = cpu_to_caam_dma(ptr);
+	} else {
+		u32 *offset = (u32 *)desc_end(desc);
+
+		*offset = cpu_to_caam_dma(ptr);
+	}
 
 	(*desc) = cpu_to_caam32(caam32_to_cpu(*desc) +
 				CAAM_PTR_SZ / CAAM_CMD_SZ);
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c00c7c84ec84..731b06becd9c 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -219,7 +219,7 @@ static inline u64 caam_get_dma_mask(struct device *dev)
 {
 	struct device_node *nprop = dev->of_node;
 
-	if (sizeof(dma_addr_t) != sizeof(u64))
+	if (caam_ptr_sz != sizeof(u64))
 		return DMA_BIT_MASK(32);
 
 	if (caam_dpaa2)
diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 810f0bef0652..68c1fd5dee5d 100644
--- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -512,7 +512,9 @@ struct rsa_pub_pdb {
 	dma_addr_t	n_dma;
 	dma_addr_t	e_dma;
 	u32		f_len;
-} __packed;
+};
+
+#define SIZEOF_RSA_PUB_PDB	(2 * sizeof(u32) + 4 * caam_ptr_sz)
 
 /**
  * RSA Decrypt PDB - Private Key Form #1
@@ -528,7 +530,9 @@ struct rsa_priv_f1_pdb {
 	dma_addr_t	f_dma;
 	dma_addr_t	n_dma;
 	dma_addr_t	d_dma;
-} __packed;
+};
+
+#define SIZEOF_RSA_PRIV_F1_PDB	(sizeof(u32) + 4 * caam_ptr_sz)
 
 /**
  * RSA Decrypt PDB - Private Key Form #2
@@ -554,7 +558,9 @@ struct rsa_priv_f2_pdb {
 	dma_addr_t	tmp1_dma;
 	dma_addr_t	tmp2_dma;
 	u32		p_q_len;
-} __packed;
+};
+
+#define SIZEOF_RSA_PRIV_F2_PDB	(2 * sizeof(u32) + 7 * caam_ptr_sz)
 
 /**
  * RSA Decrypt PDB - Private Key Form #3
@@ -586,6 +592,8 @@ struct rsa_priv_f3_pdb {
 	dma_addr_t	tmp1_dma;
 	dma_addr_t	tmp2_dma;
 	u32		p_q_len;
-} __packed;
+};
+
+#define SIZEOF_RSA_PRIV_F3_PDB	(2 * sizeof(u32) + 9 * caam_ptr_sz)
 
 #endif
diff --git a/drivers/crypto/caam/pkc_desc.c b/drivers/crypto/caam/pkc_desc.c
index 2a8d87ea94bf..0d5ee762e036 100644
--- a/drivers/crypto/caam/pkc_desc.c
+++ b/drivers/crypto/caam/pkc_desc.c
@@ -13,7 +13,7 @@
 /* Descriptor for RSA Public operation */
 void init_rsa_pub_desc(u32 *desc, struct rsa_pub_pdb *pdb)
 {
-	init_job_desc_pdb(desc, 0, sizeof(*pdb));
+	init_job_desc_pdb(desc, 0, SIZEOF_RSA_PUB_PDB);
 	append_cmd(desc, pdb->sgf);
 	append_ptr(desc, pdb->f_dma);
 	append_ptr(desc, pdb->g_dma);
@@ -26,7 +26,7 @@ void init_rsa_pub_desc(u32 *desc, struct rsa_pub_pdb *pdb)
 /* Descriptor for RSA Private operation - Private Key Form #1 */
 void init_rsa_priv_f1_desc(u32 *desc, struct rsa_priv_f1_pdb *pdb)
 {
-	init_job_desc_pdb(desc, 0, sizeof(*pdb));
+	init_job_desc_pdb(desc, 0, SIZEOF_RSA_PRIV_F1_PDB);
 	append_cmd(desc, pdb->sgf);
 	append_ptr(desc, pdb->g_dma);
 	append_ptr(desc, pdb->f_dma);
@@ -39,7 +39,7 @@ void init_rsa_priv_f1_desc(u32 *desc, struct rsa_priv_f1_pdb *pdb)
 /* Descriptor for RSA Private operation - Private Key Form #2 */
 void init_rsa_priv_f2_desc(u32 *desc, struct rsa_priv_f2_pdb *pdb)
 {
-	init_job_desc_pdb(desc, 0, sizeof(*pdb));
+	init_job_desc_pdb(desc, 0, SIZEOF_RSA_PRIV_F2_PDB);
 	append_cmd(desc, pdb->sgf);
 	append_ptr(desc, pdb->g_dma);
 	append_ptr(desc, pdb->f_dma);
@@ -56,7 +56,7 @@ void init_rsa_priv_f2_desc(u32 *desc, struct rsa_priv_f2_pdb *pdb)
 /* Descriptor for RSA Private operation - Private Key Form #3 */
 void init_rsa_priv_f3_desc(u32 *desc, struct rsa_priv_f3_pdb *pdb)
 {
-	init_job_desc_pdb(desc, 0, sizeof(*pdb));
+	init_job_desc_pdb(desc, 0, SIZEOF_RSA_PRIV_F3_PDB);
 	append_cmd(desc, pdb->sgf);
 	append_ptr(desc, pdb->g_dma);
 	append_ptr(desc, pdb->f_dma);
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 6dbb269a3e7e..05127b70527d 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -191,7 +191,8 @@ static inline u64 caam_dma64_to_cpu(u64 value)
 
 static inline u64 cpu_to_caam_dma(u64 value)
 {
-	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
+	    caam_ptr_sz == sizeof(u64))
 		return cpu_to_caam_dma64(value);
 	else
 		return cpu_to_caam32(value);
@@ -199,7 +200,8 @@ static inline u64 cpu_to_caam_dma(u64 value)
 
 static inline u64 caam_dma_to_cpu(u64 value)
 {
-	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
+	    caam_ptr_sz == sizeof(u64))
 		return caam_dma64_to_cpu(value);
 	else
 		return caam32_to_cpu(value);
@@ -213,13 +215,24 @@ static inline u64 caam_dma_to_cpu(u64 value)
 static inline void jr_outentry_get(void *outring, int hw_idx, dma_addr_t *desc,
 				   u32 *jrstatus)
 {
-	struct {
-		dma_addr_t desc;/* Pointer to completed descriptor */
-		u32 jrstatus;	/* Status for completed descriptor */
-	} __packed *outentry = outring;
 
-	*desc = outentry[hw_idx].desc;
-	*jrstatus = outentry[hw_idx].jrstatus;
+	if (caam_ptr_sz == sizeof(u32)) {
+		struct {
+			u32 desc;
+			u32 jrstatus;
+		} __packed *outentry = outring;
+
+		*desc = outentry[hw_idx].desc;
+		*jrstatus = outentry[hw_idx].jrstatus;
+	} else {
+		struct {
+			dma_addr_t desc;/* Pointer to completed descriptor */
+			u32 jrstatus;	/* Status for completed descriptor */
+		} __packed *outentry = outring;
+
+		*desc = outentry[hw_idx].desc;
+		*jrstatus = outentry[hw_idx].jrstatus;
+	}
 }
 
 #define SIZEOF_JR_OUTENTRY	(caam_ptr_sz + sizeof(u32))
@@ -246,9 +259,15 @@ static inline u32 jr_outentry_jrstatus(void *outring, int hw_idx)
 
 static inline void jr_inpentry_set(void *inpring, int hw_idx, dma_addr_t val)
 {
-	dma_addr_t *inpentry = inpring;
+	if (caam_ptr_sz == sizeof(u32)) {
+		u32 *inpentry = inpring;
 
-	inpentry[hw_idx] = val;
+		inpentry[hw_idx] = val;
+	} else {
+		dma_addr_t *inpentry = inpring;
+
+		inpentry[hw_idx] = val;
+	}
 }
 
 #define SIZEOF_JR_INPENTRY	caam_ptr_sz
@@ -380,6 +399,7 @@ struct caam_perfmon {
 	u32 cha_rev_ls;		/* CRNR - CHA Rev No. Least significant half*/
 #define CTPR_MS_QI_SHIFT	25
 #define CTPR_MS_QI_MASK		(0x1ull << CTPR_MS_QI_SHIFT)
+#define CTPR_MS_PS		BIT(17)
 #define CTPR_MS_DPAA2		BIT(13)
 #define CTPR_MS_VIRT_EN_INCL	0x00000001
 #define CTPR_MS_VIRT_EN_POR	0x00000002
-- 
2.21.0


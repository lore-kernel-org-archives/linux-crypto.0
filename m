Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2C0C7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C2D21850
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szQVdWaj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfGQPZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46771 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbfGQPZa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so12119109plz.13;
        Wed, 17 Jul 2019 08:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MezMMBs7LhmaGa1w3R9YzJfIJORJRCUWu14aVXKvQBQ=;
        b=szQVdWajcM4aXKFJUOeGTKEmiFh1x0n43Tv06rMvK5618pjwbbdxwTW9vTniD3sPwk
         23gg8D/WNQxEh+6IhJv3qTIZR7xqmZoSU4nm8oiT4Hp3cLui/gQaL1QjqZv5Ra5fClA7
         9P4+TnN8R0EyyStny+9uVoOos66xxA9xn+CS4CMChtpw/nH4ecNLMmmn5lO2Gq1zIeQa
         T3XLN7TDpKp5P6lKNRnp2Cd348K6hvSUxw0H+sJHiX+pd7HDphTL+VMF7MNpu0P2GhkO
         oW6nBfQ70IrE/mGRn9qeYOzd+vEUdYLthkW3TSeXHxG+r+nZ8SxDQLDhBS4BHZx3ZSNA
         HsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MezMMBs7LhmaGa1w3R9YzJfIJORJRCUWu14aVXKvQBQ=;
        b=Aek9WIdWDrATITlB0GvWz6MwqAae+ZbSdUZZhFN276AQS1rAXIwLrFcfMjtQk6BNpJ
         N12TLkMZTm8YSy9pFNdIzJkcpCUdqSZQ1ciB9EOdCmmmutitbdkrvXTNxj4L0jrYa7Sh
         DnuaqhNDI/SqQygnvQfM08wHlxzHVOeZRGbutjEFPyF6+dbGFocLw4NihtfD8eRV4tw6
         LSxpNXAbR5ROWotiOqvK6SNL+EeRm4iHkytXnqb5MrGhb4Bsh06ZS1kI1VrbJvkO4S4W
         UHSFfXf1ooc6y6FiI2Lcv8FE9OIPeD4VhTB+90JfaPBeK4rkrVRGsE5ByucFjRSEOMdl
         lHtg==
X-Gm-Message-State: APjAAAXgNlSpE2q5uDVICUEgKdPQqEPZPa0iUKg3ac4b7KibohE/7fUj
        cgc1p6XIy3IKM8YJXvLwpYHdCEC5
X-Google-Smtp-Source: APXvYqy07742NGjknHH/l9or1/N9hFQduo2I3d1axNXqRIaIcSG7goPyeqERW99HCjNDoph0tidu8Q==
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr44548896plb.167.1563377129565;
        Wed, 17 Jul 2019 08:25:29 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:28 -0700 (PDT)
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
Subject: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs
Date:   Wed, 17 Jul 2019 08:24:56 -0700
Message-Id: <20190717152458.22337-13-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717152458.22337-1-andrew.smirnov@gmail.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

i.MX8 SoC still use 32-bit addresses in its CAAM implmentation, so
change all of the code to be able to handle that.

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
 drivers/crypto/caam/ctrl.c        |  6 +++--
 drivers/crypto/caam/desc_constr.h | 10 ++++++--
 drivers/crypto/caam/intern.h      |  2 +-
 drivers/crypto/caam/pdb.h         | 16 +++++++++----
 drivers/crypto/caam/pkc_desc.c    |  8 +++----
 drivers/crypto/caam/regs.h        | 39 +++++++++++++++++++++++--------
 7 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 80574106af29..0e95ad555156 100644
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
index e5eaaf1efe45..b309535f3157 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -603,11 +603,13 @@ static int caam_probe(struct platform_device *pdev)
 		ret = init_clocks(dev, ctrlpriv, imx_soc_match->data);
 		if (ret)
 			return ret;
+
+		caam_ptr_sz = sizeof(u32);
+	} else {
+		caam_ptr_sz = sizeof(dma_addr_t);
 	}
 	caam_imx = (bool)imx_soc_match;
 
-	caam_ptr_sz = sizeof(dma_addr_t);
-
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 3a83a3332ba9..5602b8f192de 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -109,9 +109,15 @@ static inline void init_job_desc_pdb(u32 * const desc, u32 options,
 
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
index ec49f5ba9689..3c3ad474d08f 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -191,7 +191,8 @@ static inline u64 caam_dma64_to_cpu(u64 value)
 
 static inline u64 cpu_to_caam_dma(u64 value)
 {
-	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
+	    !caam_imx)
 		return cpu_to_caam_dma64(value);
 	else
 		return cpu_to_caam32(value);
@@ -199,7 +200,8 @@ static inline u64 cpu_to_caam_dma(u64 value)
 
 static inline u64 caam_dma_to_cpu(u64 value)
 {
-	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
+	    !caam_imx)
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
+	if (caam_imx) {
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
+	if (caam_imx) {
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
-- 
2.21.0


Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF90DC4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 07:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F3F20640
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 07:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSiCSIYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfIRHpe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 03:45:34 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33727 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfIRHpd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 03:45:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id c4so5751604edl.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 00:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LKRy397iZrfACOB4xNftZM8/86O37fSlO/gngtpJsj4=;
        b=kSiCSIYY11p2lchsY0mPVtTwIIxh5gmG9xfQnGBQ5Gw6o55SrgQMCGFrXERLyyWIsv
         pjtFUhVfgGnHIb9eRHV61e0kxJrK7D/GrAGkAZ/nnkePjZehhdr0l6AZF+ACYcADrWMF
         dPhduGzJuVpTRh8fXpQ7Cnn3snKSNi8pGzWVT2HXVLnvf2nPLzqCdswlldiaN6QEbpra
         riTdi/IwufJrwe+gM2LzE0sEtAPxxu8G1PKDcl6UM660OnRhFKdBhzmXRASV2EdrJG9P
         n/9UcrYDJWV9taf+i7WGYrT4DRLALfA0s0FTEjCHS9ZHl6QGnW/9F2QgYcOlUj/b9LDI
         vcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LKRy397iZrfACOB4xNftZM8/86O37fSlO/gngtpJsj4=;
        b=lnj8xuyJuI3pW9wMDbJjqG3iiLW7vxX0Qp1MZx1gQZkfdllGIfEjep6ijN9wm7kXK6
         XP/K0m+ZWF4a6qVF5po1ul9ejmAKu3OWWk0lLqnMWaYI8vaRp48hvLg45KCty2vHNmli
         OWogM4vldcbZc6Wl0xfcq4LD2rALX44bM/mKvVwOD9tH4brVBY8ZL0nNF+wmprg45eFl
         uxESoB6OpfXgbYKUiV0QLPLqIAdIIHVzBqegcafmkaOGNaQhKQrQ/ZUqjiNxB/hKU4ok
         ZhMP5Nogq8+WIlLdIs2HGVwHXworl4GISHVPDSryD+P1yXY2fLyICSm0qv5EkRlxqqXG
         uVzA==
X-Gm-Message-State: APjAAAUjcBPVA2z/PyOrL4+TRQYO2VTl3SXjGHTvFkCntoJRXtdpBfnQ
        Z/gydWIlYGNKf5ZEw7o50gi3jmSd
X-Google-Smtp-Source: APXvYqxD0cg8obQk6mbuPKvGcWzp1uVHslHJlL5ReG9S4lDPU39IH/PU+nrbOzete/zSXxue8lhHng==
X-Received: by 2002:aa7:d816:: with SMTP id v22mr9052621edq.28.1568792730466;
        Wed, 18 Sep 2019 00:45:30 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id hh11sm18332ejb.33.2019.09.18.00.45.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 00:45:29 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/2] crypto: inside-secure - Add support for 256 bit wide internal bus
Date:   Wed, 18 Sep 2019 08:42:39 +0200
Message-Id: <1568788960-7829-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568788960-7829-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568788960-7829-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for large EIP197's with a 256 bit wide internal
bus, which affects the format of the result descriptor due to internal
alignment requirements.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c      | 101 +++++++++++++++------------
 drivers/crypto/inside-secure/safexcel.h      |  18 +++--
 drivers/crypto/inside-secure/safexcel_ring.c |   4 +-
 3 files changed, 72 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index ed34118..0bcf36c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -492,12 +492,12 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 		writel(upper_32_bits(priv->ring[i].cdr.base_dma),
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_HI);
 
-		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.cd_offset << 16) |
+		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.cd_offset << 14) |
 		       priv->config.cd_size,
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
 		writel(((cd_fetch_cnt *
 			 (cd_size_rnd << priv->hwconfig.hwdataw)) << 16) |
-		       (cd_fetch_cnt * priv->config.cd_offset),
+		       (cd_fetch_cnt * (priv->config.cd_offset / sizeof(u32))),
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_CFG);
 
 		/* Configure DMA tx control */
@@ -540,13 +540,13 @@ static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 		writel(upper_32_bits(priv->ring[i].rdr.base_dma),
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_HI);
 
-		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.rd_offset << 16) |
+		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.rd_offset << 14) |
 		       priv->config.rd_size,
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
 
 		writel(((rd_fetch_cnt *
 			 (rd_size_rnd << priv->hwconfig.hwdataw)) << 16) |
-		       (rd_fetch_cnt * priv->config.rd_offset),
+		       (rd_fetch_cnt * (priv->config.rd_offset / sizeof(u32))),
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_CFG);
 
 		/* Configure DMA tx control */
@@ -572,7 +572,7 @@ static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 {
 	u32 val;
-	int i, ret, pe;
+	int i, ret, pe, opbuflo, opbufhi;
 
 	dev_dbg(priv->dev, "HW init: using %d pipe(s) and %d ring(s)\n",
 		priv->config.pes, priv->config.rings);
@@ -652,9 +652,16 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 			;
 
 		/* DMA transfer size to use */
+		if (priv->hwconfig.hwnumpes > 4) {
+			opbuflo = 9;
+			opbufhi = 10;
+		} else {
+			opbuflo = 7;
+			opbufhi = 8;
+		}
 		val = EIP197_HIA_DSE_CFG_DIS_DEBUG;
-		val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(7) |
-		       EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
+		val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(opbuflo) |
+		       EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(opbufhi);
 		val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
 		val |= EIP197_HIA_DSE_CFG_ALWAYS_BUFFERABLE;
 		/* FIXME: instability issues can occur for EIP97 but disabling
@@ -668,8 +675,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		writel(0, EIP197_HIA_DSE_THR(priv) + EIP197_HIA_DSE_THR_CTRL(pe));
 
 		/* Configure the procesing engine thresholds */
-		writel(EIP197_PE_OUT_DBUF_THRES_MIN(7) |
-		       EIP197_PE_OUT_DBUF_THRES_MAX(8),
+		writel(EIP197_PE_OUT_DBUF_THRES_MIN(opbuflo) |
+		       EIP197_PE_OUT_DBUF_THRES_MAX(opbufhi),
 		       EIP197_PE(priv) + EIP197_PE_OUT_DBUF_THRES(pe));
 
 		/* Processing Engine configuration */
@@ -709,7 +716,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		writel(0,
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_PROC_PNTR);
 
-		writel((EIP197_DEFAULT_RING_SIZE * priv->config.cd_offset) << 2,
+		writel((EIP197_DEFAULT_RING_SIZE * priv->config.cd_offset),
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_RING_SIZE);
 	}
 
@@ -732,7 +739,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_PROC_PNTR);
 
 		/* Ring size */
-		writel((EIP197_DEFAULT_RING_SIZE * priv->config.rd_offset) << 2,
+		writel((EIP197_DEFAULT_RING_SIZE * priv->config.rd_offset),
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_RING_SIZE);
 	}
 
@@ -852,20 +859,24 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
 	spin_unlock_bh(&priv->ring[ring].lock);
 
 	/* let the RDR know we have pending descriptors */
-	writel((rdesc * priv->config.rd_offset) << 2,
+	writel((rdesc * priv->config.rd_offset),
 	       EIP197_HIA_RDR(priv, ring) + EIP197_HIA_xDR_PREP_COUNT);
 
 	/* let the CDR know we have pending descriptors */
-	writel((cdesc * priv->config.cd_offset) << 2,
+	writel((cdesc * priv->config.cd_offset),
 	       EIP197_HIA_CDR(priv, ring) + EIP197_HIA_xDR_PREP_COUNT);
 }
 
 inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
-				       struct safexcel_result_desc *rdesc)
+				       void *rdp)
 {
-	if (likely((!rdesc->descriptor_overflow) &&
-		   (!rdesc->buffer_overflow) &&
-		   (!rdesc->result_data.error_code)))
+	struct safexcel_result_desc *rdesc = rdp;
+	struct result_data_desc *result_data = rdp + priv->config.res_offset;
+
+	if (likely((!rdesc->last_seg) || /* Rest only valid if last seg! */
+		   ((!rdesc->descriptor_overflow) &&
+		    (!rdesc->buffer_overflow) &&
+		    (!result_data->error_code))))
 		return 0;
 
 	if (rdesc->descriptor_overflow)
@@ -874,13 +885,14 @@ inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
 	if (rdesc->buffer_overflow)
 		dev_err(priv->dev, "Buffer overflow detected");
 
-	if (rdesc->result_data.error_code & 0x4066) {
+	if (result_data->error_code & 0x4066) {
 		/* Fatal error (bits 1,2,5,6 & 14) */
 		dev_err(priv->dev,
 			"result descriptor error (%x)",
-			rdesc->result_data.error_code);
+			result_data->error_code);
+
 		return -EIO;
-	} else if (rdesc->result_data.error_code &
+	} else if (result_data->error_code &
 		   (BIT(7) | BIT(4) | BIT(3) | BIT(0))) {
 		/*
 		 * Give priority over authentication fails:
@@ -888,7 +900,7 @@ inline int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
 		 * something wrong with the input!
 		 */
 		return -EINVAL;
-	} else if (rdesc->result_data.error_code & BIT(9)) {
+	} else if (result_data->error_code & BIT(9)) {
 		/* Authentication failed */
 		return -EBADMSG;
 	}
@@ -1019,7 +1031,7 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
 acknowledge:
 	if (i)
 		writel(EIP197_xDR_PROC_xD_PKT(i) |
-		       EIP197_xDR_PROC_xD_COUNT(tot_descs * priv->config.rd_offset),
+		       (tot_descs * priv->config.rd_offset),
 		       EIP197_HIA_RDR(priv, ring) + EIP197_HIA_xDR_PROC_COUNT);
 
 	/* If the number of requests overflowed the counter, try to proceed more
@@ -1292,30 +1304,25 @@ static void safexcel_unregister_algorithms(struct safexcel_crypto_priv *priv)
 
 static void safexcel_configure(struct safexcel_crypto_priv *priv)
 {
-	u32 val, mask = 0;
-
-	val = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
+	u32 mask = BIT(priv->hwconfig.hwdataw) - 1;
 
-	/* Read number of PEs from the engine */
-	if (priv->flags & SAFEXCEL_HW_EIP197)
-		/* Wider field width for all EIP197 type engines */
-		mask = EIP197_N_PES_MASK;
-	else
-		/* Narrow field width for EIP97 type engine */
-		mask = EIP97_N_PES_MASK;
-
-	priv->config.pes = (val >> EIP197_N_PES_OFFSET) & mask;
-
-	priv->config.rings = min_t(u32, val & GENMASK(3, 0), max_rings);
+	priv->config.pes = priv->hwconfig.hwnumpes;
+	priv->config.rings = min_t(u32, priv->hwconfig.hwnumrings, max_rings);
 
-	val = (val & GENMASK(27, 25)) >> 25;
-	mask = BIT(val) - 1;
-
-	priv->config.cd_size = (sizeof(struct safexcel_command_desc) / sizeof(u32));
+	priv->config.cd_size = EIP197_CD64_FETCH_SIZE;
 	priv->config.cd_offset = (priv->config.cd_size + mask) & ~mask;
 
-	priv->config.rd_size = (sizeof(struct safexcel_result_desc) / sizeof(u32));
+	/* res token is behind the descr, but ofs must be rounded to buswdth */
+	priv->config.res_offset = (EIP197_RD64_FETCH_SIZE + mask) & ~mask;
+	/* now the size of the descr is this 1st part plus the result struct */
+	priv->config.rd_size    = priv->config.res_offset +
+				  EIP197_RD64_RESULT_SIZE;
 	priv->config.rd_offset = (priv->config.rd_size + mask) & ~mask;
+
+	/* convert dwords to bytes */
+	priv->config.cd_offset *= sizeof(u32);
+	priv->config.rd_offset *= sizeof(u32);
+	priv->config.res_offset *= sizeof(u32);
 }
 
 static void safexcel_init_register_offsets(struct safexcel_crypto_priv *priv)
@@ -1457,6 +1464,10 @@ static int safexcel_probe_generic(void *pdev,
 		priv->hwconfig.hwrfsize = ((hiaopt >> EIP197_RFSIZE_OFFSET) &
 					   EIP197_RFSIZE_MASK) +
 					  EIP197_RFSIZE_ADJUST;
+		priv->hwconfig.hwnumpes	= (hiaopt >> EIP197_N_PES_OFFSET) &
+					  EIP197_N_PES_MASK;
+		priv->hwconfig.hwnumrings = (hiaopt >> EIP197_N_RINGS_OFFSET) &
+					    EIP197_N_RINGS_MASK;
 	} else {
 		/* EIP97 */
 		priv->hwconfig.hwdataw  = (hiaopt >> EIP197_HWDATAW_OFFSET) &
@@ -1465,6 +1476,9 @@ static int safexcel_probe_generic(void *pdev,
 					  EIP97_CFSIZE_MASK;
 		priv->hwconfig.hwrfsize = (hiaopt >> EIP97_RFSIZE_OFFSET) &
 					  EIP97_RFSIZE_MASK;
+		priv->hwconfig.hwnumpes	= 1; /* by definition */
+		priv->hwconfig.hwnumrings = (hiaopt >> EIP197_N_RINGS_OFFSET) &
+					    EIP197_N_RINGS_MASK;
 	}
 
 	/* Get supported algorithms from EIP96 transform engine */
@@ -1472,8 +1486,9 @@ static int safexcel_probe_generic(void *pdev,
 				    EIP197_PE_EIP96_OPTIONS(0));
 
 	/* Print single info line describing what we just detected */
-	dev_info(priv->dev, "EIP%d:%x(%d)-HIA:%x(%d,%d,%d),PE:%x,alg:%08x\n",
-		 peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hiaver,
+	dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x,alg:%08x\n",
+		 peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hwnumpes,
+		 priv->hwconfig.hwnumrings, priv->hwconfig.hiaver,
 		 priv->hwconfig.hwdataw, priv->hwconfig.hwcfsize,
 		 priv->hwconfig.hwrfsize, priv->hwconfig.pever,
 		 priv->hwconfig.algo_flags);
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 173d3c8..73d790a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -213,7 +213,6 @@
 /* EIP197_HIA_xDR_PROC_COUNT */
 #define EIP197_xDR_PROC_xD_PKT_OFFSET		24
 #define EIP197_xDR_PROC_xD_PKT_MASK		GENMASK(6, 0)
-#define EIP197_xDR_PROC_xD_COUNT(n)		((n) << 2)
 #define EIP197_xDR_PROC_xD_PKT(n)		((n) << 24)
 #define EIP197_xDR_PROC_CLR_COUNT		BIT(31)
 
@@ -228,6 +227,8 @@
 #define EIP197_HIA_RA_PE_CTRL_EN		BIT(30)
 
 /* EIP197_HIA_OPTIONS */
+#define EIP197_N_RINGS_OFFSET			0
+#define EIP197_N_RINGS_MASK			GENMASK(3, 0)
 #define EIP197_N_PES_OFFSET			4
 #define EIP197_N_PES_MASK			GENMASK(4, 0)
 #define EIP97_N_PES_MASK			GENMASK(2, 0)
@@ -486,16 +487,15 @@ struct safexcel_result_desc {
 
 	u32 data_lo;
 	u32 data_hi;
-
-	struct result_data_desc result_data;
 } __packed;
 
 /*
  * The EIP(1)97 only needs to fetch the descriptor part of
  * the result descriptor, not the result token part!
  */
-#define EIP197_RD64_FETCH_SIZE		((sizeof(struct safexcel_result_desc) -\
-					  sizeof(struct result_data_desc)) /\
+#define EIP197_RD64_FETCH_SIZE		(sizeof(struct safexcel_result_desc) /\
+					 sizeof(u32))
+#define EIP197_RD64_RESULT_SIZE		(sizeof(struct result_data_desc) /\
 					 sizeof(u32))
 
 struct safexcel_token {
@@ -582,6 +582,9 @@ struct safexcel_command_desc {
 	struct safexcel_control_data_desc control_data;
 } __packed;
 
+#define EIP197_CD64_FETCH_SIZE		(sizeof(struct safexcel_command_desc) /\
+					sizeof(u32))
+
 /*
  * Internal structures & functions
  */
@@ -625,6 +628,7 @@ struct safexcel_config {
 
 	u32 rd_size;
 	u32 rd_offset;
+	u32 res_offset;
 };
 
 struct safexcel_work_data {
@@ -734,6 +738,8 @@ struct safexcel_hwconfig {
 	int hwdataw;
 	int hwcfsize;
 	int hwrfsize;
+	int hwnumpes;
+	int hwnumrings;
 };
 
 struct safexcel_crypto_priv {
@@ -805,7 +811,7 @@ struct safexcel_inv_result {
 
 void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring);
 int safexcel_rdesc_check_errors(struct safexcel_crypto_priv *priv,
-				struct safexcel_result_desc *rdesc);
+				void *rdp);
 void safexcel_complete(struct safexcel_crypto_priv *priv, int ring);
 int safexcel_invalidate_cache(struct crypto_async_request *async,
 			      struct safexcel_crypto_priv *priv,
diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index 0f269b8..5323e91 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -14,7 +14,7 @@ int safexcel_init_ring_descriptors(struct safexcel_crypto_priv *priv,
 				   struct safexcel_desc_ring *cdr,
 				   struct safexcel_desc_ring *rdr)
 {
-	cdr->offset = sizeof(u32) * priv->config.cd_offset;
+	cdr->offset = priv->config.cd_offset;
 	cdr->base = dmam_alloc_coherent(priv->dev,
 					cdr->offset * EIP197_DEFAULT_RING_SIZE,
 					&cdr->base_dma, GFP_KERNEL);
@@ -24,7 +24,7 @@ int safexcel_init_ring_descriptors(struct safexcel_crypto_priv *priv,
 	cdr->base_end = cdr->base + cdr->offset * (EIP197_DEFAULT_RING_SIZE - 1);
 	cdr->read = cdr->base;
 
-	rdr->offset = sizeof(u32) * priv->config.rd_offset;
+	rdr->offset = priv->config.rd_offset;
 	rdr->base = dmam_alloc_coherent(priv->dev,
 					rdr->offset * EIP197_DEFAULT_RING_SIZE,
 					&rdr->base_dma, GFP_KERNEL);
-- 
1.8.3.1


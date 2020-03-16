Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224C4C2BB1D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90A52071C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzBHNPpi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbgCPPBQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:01:16 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34039 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731754AbgCPPBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 11:01:15 -0400
Received: by mail-pj1-f67.google.com with SMTP id q16so1448361pje.1;
        Mon, 16 Mar 2020 08:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rha5gMVlQHG317iP5awJ7Hq7f1cAFZp1bVkfB7HkmWU=;
        b=bzBHNPpiaBCFJ+veApwaCOnO/qWoVBohgrq1I7iBUQtq2T4j/smhvpiKBjkBSMWjn3
         hiXJZ9bmTPTNPlv2gSqrfRj/hjn0nOJkushbdlqTEXlo/xsnhw8Atk+AFr5+T6lWrgJ4
         +vN/jThRYqfeKz75q0X3hxQykjRdMbN17qbYSR7hQdFBLJ01wEKjaT5pfng/+aDD0O1p
         Trom/PBnOGUGsPg9TvvCjeH5n9teeUzByBARR16zLPyVXNGJpuLuzYACi46Z8bmmAkzE
         Ucr04NJXDLILkuICXAt70w/n8aX/egtN8cO84fmqKFpxIzC/9ceWQuxqX8bIl3bxqS7k
         sbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rha5gMVlQHG317iP5awJ7Hq7f1cAFZp1bVkfB7HkmWU=;
        b=Wfgvqa133LZhv0nHrnZYm+I9wBvr/OaVvzWVK+RZDi356AlrOpIU7MyZbU3NFoT1us
         aS+E86nrpUAz0Oh/x7Oi95djqayXFi2Hz20W0w+hPxz0L5EmfPaQpPD9lEW5l7VGK/qj
         68yCS4fj6da7QN/lgLrxAxT1mcAiT2LUXjeYHrjhy49GRC45sx6aukA2+t6EXT2O4dIz
         xZRhgzvww1bQm8ad5mpS3OcwJvJfS3Ydk26/uI1jF/gPbt8iZ1Df2/9JgZ4Gc2Oet+m2
         75LWQAqmovXnWYKLGDYlDGOJcKnFgPCLCFdciJ7e4m0TmClzBmZzPEKfTgjFEhR+JRs/
         Yh1Q==
X-Gm-Message-State: ANhLgQ2zFW9hvfBq0LkJS0lSsOsfcyLTSLsGm5mKsHaoWMl/bn0M6Rw5
        fTywIONEv4RJ2wIHDZy6g3I8KbBd
X-Google-Smtp-Source: ADFU+vtcr8dO1y+p6vMqBE3gdnZLKpmumqPi+EKlSGSQUIENR5BtvZHYkHcEO2w4uqmQkYjdOvVimw==
X-Received: by 2002:a17:90a:34e:: with SMTP id 14mr11988462pjf.32.1584370873977;
        Mon, 16 Mar 2020 08:01:13 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id o128sm256354pfg.5.2020.03.16.08.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:01:12 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v8 7/8] crypto: caam - enable prediction resistance in HRWNG
Date:   Mon, 16 Mar 2020 08:00:46 -0700
Message-Id: <20200316150047.30828-8-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200316150047.30828-1-andrew.smirnov@gmail.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instantiate CAAM RNG with prediction resistance enabled to improve its
quality (with PR on DRNG is forced to reseed from TRNG every time
random data is generated).

Management Complex firmware with version lower than 10.20.0
doesn't provide prediction resistance support. Consider this
and only instantiate rng when mc f/w version is lower.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/Kconfig   |  1 +
 drivers/crypto/caam/caamrng.c |  3 +-
 drivers/crypto/caam/ctrl.c    | 73 ++++++++++++++++++++++++++++-------
 drivers/crypto/caam/desc.h    |  2 +
 drivers/crypto/caam/regs.h    |  4 +-
 5 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 64f82263b20e..a62f228be6da 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -13,6 +13,7 @@ config CRYPTO_DEV_FSL_CAAM
 	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE
 	select SOC_BUS
 	select CRYPTO_DEV_FSL_CAAM_COMMON
+	imply FSL_MC_BUS
 	help
 	  Enables the driver module for Freescale's Cryptographic Accelerator
 	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4).
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index ffbdc912f1be..cffa6604f726 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -69,7 +69,8 @@ static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
 {
 	init_job_desc(desc, 0);	/* + 1 cmd_sz */
 	/* Generate random bytes: + 1 cmd_sz */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
+			 OP_ALG_PR_ON);
 	/* Store bytes: + 1 cmd_sz + caam_ptr_sz  */
 	append_fifo_store(desc, dst_dma, len, FIFOST_TYPE_RNGSTORE);
 
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b278471f4013..47521b6294ed 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -10,6 +10,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/sys_soc.h>
+#include <linux/fsl/mc.h>
 
 #include "compat.h"
 #include "regs.h"
@@ -36,7 +37,8 @@ static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
 	init_job_desc(desc, 0);
 
 	op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;
+			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT |
+			OP_ALG_PR_ON;
 
 	/* INIT RNG in non-test mode */
 	append_operation(desc, op_flags);
@@ -278,12 +280,25 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		return -ENOMEM;
 
 	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
+		const u32 rdsta_if = RDSTA_IF0 << sh_idx;
+		const u32 rdsta_pr = RDSTA_PR0 << sh_idx;
+		const u32 rdsta_mask = rdsta_if | rdsta_pr;
 		/*
 		 * If the corresponding bit is set, this state handle
 		 * was initialized by somebody else, so it's left alone.
 		 */
-		if ((1 << sh_idx) & state_handle_mask)
-			continue;
+		if (rdsta_if & state_handle_mask) {
+			if (rdsta_pr & state_handle_mask)
+				continue;
+
+			dev_info(ctrldev,
+				 "RNG4 SH%d was previously instantiated without prediction resistance. Tearing it down\n",
+				 sh_idx);
+
+			ret = deinstantiate_rng(ctrldev, rdsta_if);
+			if (ret)
+				break;
+		}
 
 		/* Create the descriptor for instantiating RNG State Handle */
 		build_instantiation_desc(desc, sh_idx, gen_sk);
@@ -303,9 +318,9 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		if (ret)
 			break;
 
-		rdsta_val = rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
+		rdsta_val = rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_MASK;
 		if ((status && status != JRSTA_SSRC_JUMP_HALT_CC) ||
-		    !(rdsta_val & (1 << sh_idx))) {
+		    (rdsta_val & rdsta_mask) != rdsta_mask) {
 			ret = -EAGAIN;
 			break;
 		}
@@ -564,6 +579,26 @@ static void caam_remove_debugfs(void *root)
 }
 #endif
 
+#ifdef CONFIG_FSL_MC_BUS
+static bool check_version(struct fsl_mc_version *mc_version, u32 major,
+			  u32 minor, u32 revision)
+{
+	if (mc_version->major > major)
+		return true;
+
+	if (mc_version->major == major) {
+		if (mc_version->minor > minor)
+			return true;
+
+		if (mc_version->minor == minor && mc_version->revision > 0)
+			return true;
+	}
+
+	return false;
+}
+#endif
+
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -582,6 +617,7 @@ static int caam_probe(struct platform_device *pdev)
 	u8 rng_vid;
 	int pg_size;
 	int BLOCK_OFFSET = 0;
+	bool pr_support = false;
 
 	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
 	if (!ctrlpriv)
@@ -667,6 +703,21 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* Get the IRQ of the controller (for security violations only) */
 	ctrlpriv->secvio_irq = irq_of_parse_and_map(nprop, 0);
+	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
+	ctrlpriv->mc_en = !!np;
+	of_node_put(np);
+
+#ifdef CONFIG_FSL_MC_BUS
+	if (ctrlpriv->mc_en) {
+		struct fsl_mc_version *mc_version;
+
+		mc_version = fsl_mc_get_version();
+		if (mc_version)
+			pr_support = check_version(mc_version, 10, 20, 0);
+		else
+			return -EPROBE_DEFER;
+	}
+#endif
 
 	/*
 	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
@@ -674,10 +725,6 @@ static int caam_probe(struct platform_device *pdev)
 	 * In case of SoCs with Management Complex, MC f/w performs
 	 * the configuration.
 	 */
-	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
-	ctrlpriv->mc_en = !!np;
-	of_node_put(np);
-
 	if (!ctrlpriv->mc_en)
 		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,
 			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
@@ -784,7 +831,7 @@ static int caam_probe(struct platform_device *pdev)
 	 * already instantiated, do RNG instantiation
 	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
 	 */
-	if (!ctrlpriv->mc_en && rng_vid >= 4) {
+	if (!(ctrlpriv->mc_en && pr_support) && rng_vid >= 4) {
 		ctrlpriv->rng4_sh_init =
 			rd_reg32(&ctrl->r4tst[0].rdsta);
 		/*
@@ -794,11 +841,11 @@ static int caam_probe(struct platform_device *pdev)
 		 * to regenerate these keys before the next POR.
 		 */
 		gen_sk = ctrlpriv->rng4_sh_init & RDSTA_SKVN ? 0 : 1;
-		ctrlpriv->rng4_sh_init &= RDSTA_IFMASK;
+		ctrlpriv->rng4_sh_init &= RDSTA_MASK;
 		do {
 			int inst_handles =
 				rd_reg32(&ctrl->r4tst[0].rdsta) &
-								RDSTA_IFMASK;
+								RDSTA_MASK;
 			/*
 			 * If either SH were instantiated by somebody else
 			 * (e.g. u-boot) then it is assumed that the entropy
@@ -838,7 +885,7 @@ static int caam_probe(struct platform_device *pdev)
 		 * Set handles init'ed by this module as the complement of the
 		 * already initialized ones
 		 */
-		ctrlpriv->rng4_sh_init = ~ctrlpriv->rng4_sh_init & RDSTA_IFMASK;
+		ctrlpriv->rng4_sh_init = ~ctrlpriv->rng4_sh_init & RDSTA_MASK;
 
 		/* Enable RDB bit so that RNG works faster */
 		clrsetbits_32(&ctrl->scfgr, 0, SCFGR_RDBENABLE);
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 4b6854bf896a..e796d3cb9be8 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1254,6 +1254,8 @@
 #define OP_ALG_ICV_OFF		(0 << OP_ALG_ICV_SHIFT)
 #define OP_ALG_ICV_ON		(1 << OP_ALG_ICV_SHIFT)
 
+#define OP_ALG_PR_ON		BIT(1)
+
 #define OP_ALG_DIR_SHIFT	0
 #define OP_ALG_DIR_MASK		1
 #define OP_ALG_DECRYPT		0
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index c191e8fd0fa7..0f810bc13b2b 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -524,9 +524,11 @@ struct rng4tst {
 	u32 rsvd1[40];
 #define RDSTA_SKVT 0x80000000
 #define RDSTA_SKVN 0x40000000
+#define RDSTA_PR0 BIT(4)
+#define RDSTA_PR1 BIT(5)
 #define RDSTA_IF0 0x00000001
 #define RDSTA_IF1 0x00000002
-#define RDSTA_IFMASK (RDSTA_IF1 | RDSTA_IF0)
+#define RDSTA_MASK (RDSTA_PR1 | RDSTA_PR0 | RDSTA_IF1 | RDSTA_IF0)
 	u32 rdsta;
 	u32 rsvd2[15];
 };
-- 
2.21.0


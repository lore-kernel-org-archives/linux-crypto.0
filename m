Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF7AC33CB7
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB685214AF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQoTKHE+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgA0Q5S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:18 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39174 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbgA0Q5S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:18 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so5171597pfs.6;
        Mon, 27 Jan 2020 08:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ee+nqmg0htwo6PZ0jYpSAbIlLlDY9r4xZ8HuolJ2r+s=;
        b=dQoTKHE+GGTQLkIM8Pv/2Ae9/yIeXPc1S+RtTKFHs+UVCq68oFe+00AcqVb8PrUWcU
         mgLxnhFdOHeMiWBGQ0ST5pWtK9FBrzknIF/DuEE+D8Q5YHz2wdMk3B+AL8qjFMHftFa8
         0qhDmZ4d/jTXGKTio6nJbW6m7IfO/PWEo8xHg676NX2WEq0EQMXyrKDWmwsvZiqTU0Nk
         oxkbTItyFspLgPqN4TyIJvVj9T6azS7ZulZ/lxm7+JyAvcyCikTvjq1M/Cffr1RX1AmB
         MkqnjSMGI34UFwRi4d9oG3Y65OyYYP7m12ylXXtIXRyy+3PtwKmfQ764RhySxVsCxWiG
         e1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ee+nqmg0htwo6PZ0jYpSAbIlLlDY9r4xZ8HuolJ2r+s=;
        b=gKYri7LqhLUh81f/Y1IngfE+gkuKDrykKlieo75zVlZkOstJcGmsWFk5bExnFAKSVU
         jgyAa9LPU9KK3hxVBZr3MkevPCs93xlc7J0lDLW8e7on3mrihrQHlZ8VdouZiMBeBPol
         AcrS9/lWly32M98SznKcv508nCUzaVtTpTt9tOIHNaI4Z6mlaBdvN5gk1AKWm/WnSrtu
         zGY6wjZPMugzOhW7KJqxqBe3qlMXpBUJcV8FNipn8kFrW/KFz4Jo67LSzDeYUlFOIAwJ
         Wq7euPPJKHdqRtptYI39El0W5bSC56ne1SQf6wI3GgtQhKJgntlPhe+T3YSR10ziUL4x
         MOvA==
X-Gm-Message-State: APjAAAWvczHN/DsfmC9OffNlL8/H0pGSqVxl9vkO4QFovA1awL6+AQfG
        eQ/e4vvbMEF9Arckvsw+1g7Jsthe
X-Google-Smtp-Source: APXvYqw823dE2PY2S6E+p5S4o7e7oVmzy9zVTQfV+7xmOr6TSkgFr30vZ579QFiBAV+gvBOlhIXDQQ==
X-Received: by 2002:a62:64d8:: with SMTP id y207mr9943792pfb.208.1580144236833;
        Mon, 27 Jan 2020 08:57:16 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:15 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 8/9] crypto: caam - enable prediction resistance in HRWNG
Date:   Mon, 27 Jan 2020 08:56:45 -0800
Message-Id: <20200127165646.19806-9-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200127165646.19806-1-andrew.smirnov@gmail.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
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

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c |  3 ++-
 drivers/crypto/caam/ctrl.c    | 41 +++++++++++++++++++++++++++--------
 drivers/crypto/caam/desc.h    |  2 ++
 drivers/crypto/caam/regs.h    |  4 +++-
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 790624ae83c6..62f3a69ae837 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -77,7 +77,8 @@ static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
 {
 	init_job_desc(desc, 0);	/* + 1 cmd_sz */
 	/* Generate random bytes: + 1 cmd_sz */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
+			 OP_ALG_PR_ON);
 	/* Store bytes */
 	append_fifo_store(desc, dst_dma, len, FIFOST_TYPE_RNGSTORE);
 
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bcbc832b208e..ad3f6aa921d3 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -36,7 +36,8 @@ static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
 	init_job_desc(desc, 0);
 
 	op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;
+			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT |
+			OP_ALG_PR_ON;
 
 	/* INIT RNG in non-test mode */
 	append_operation(desc, op_flags);
@@ -276,12 +277,25 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
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
@@ -301,9 +315,9 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
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
@@ -563,6 +577,15 @@ static void caam_remove_debugfs(void *root)
 }
 #endif
 
+static bool caam_mc_skip_hwrng_init(struct caam_drv_private *ctrlpriv)
+{
+	return ctrlpriv->mc_en;
+	/*
+	 * FIXME: Add check for MC firmware version that need
+	 * reinitialization due to PR bit
+	 */
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -783,7 +806,7 @@ static int caam_probe(struct platform_device *pdev)
 	 * already instantiated, do RNG instantiation
 	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
 	 */
-	if (!ctrlpriv->mc_en && rng_vid >= 4) {
+	if (!caam_mc_skip_hwrng_init(ctrlpriv) && rng_vid >= 4) {
 		ctrlpriv->rng4_sh_init =
 			rd_reg32(&ctrl->r4tst[0].rdsta);
 		/*
@@ -793,11 +816,11 @@ static int caam_probe(struct platform_device *pdev)
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
@@ -837,7 +860,7 @@ static int caam_probe(struct platform_device *pdev)
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


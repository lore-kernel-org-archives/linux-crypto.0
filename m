Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C333DCA9EB7
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DF7C2084B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Efu2Ml4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbfJVPac (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:30:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41900 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731847AbfJVPaa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:30:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id t10so8508676plr.8;
        Tue, 22 Oct 2019 08:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ms5yYseASytAjz6fyuBFRj0zh2PNWY/vP3+FE4TWBFA=;
        b=Efu2Ml4tEtH3KCvIu6URPx9Zp/jzK+3nRR5uZv1453cN8qiUNmkiqxGPMLJPsTJgNC
         3+1hB+IcqrcYuNwPpADR/TCpnj0r002hsuEK/czMWBnHZEkNwb8L8rTQ2vz3/DoKpsf5
         hddAp+2vho++n9C/PoVw4sGHOEmLX1A1LlJi3N5IgUcj0GtG8kr79vEY7VMTwbLFwyTE
         a398JpfOp6z8OjlyxfjWZfkZXaTIOmV8X58wOyYu6tTBc777HGzwDpV0MinXluMm7bPV
         YuXIL5qe+uFMUkZGO9uf89sWMlkm7Pq08n1x/zX1saCsxYnt4cXe14BvlBLOyPpJfG4j
         7duA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ms5yYseASytAjz6fyuBFRj0zh2PNWY/vP3+FE4TWBFA=;
        b=GTzmK8EB4Wz5nkffWNop/T4ZL0PFeVUppV1ig02DzbW58C0UdDluFVuI2pZ4AsIzpd
         hqo2JXg58i2b6hXjIopeZW7GfaxqYy5E80//sxE6d0IcLxlDUy9wOLzXFhSkZMU/UIxp
         bvAR/iL/SPEYK3C0f6KjJS2/+U1nJh+dS8gIkFsKSA5Ohd/dTS/7tADG9Uu4YDCdsomM
         siU81Fo0vxjGUqsTEz+ihhkxSaHsZ+BPsN1nmwAA/Pl3Hv2psHabIXVy7rvgvGcN6gY8
         byLvUSnCsSFK8717wQkT9vnEAKTjOfSiPOdoj6SXdXTvtGKoGt9z8Hr7QmkPxyusWqXU
         ZYaQ==
X-Gm-Message-State: APjAAAXnfYEzZ7gWDs4+j5v20OEOdS81m2Cz6RmOQvx7arznOD3wNWj1
        tipoN7omyRAcNRF1bhChl06IA0Hs
X-Google-Smtp-Source: APXvYqyeJZUIHz+MfQhYPiPiN9eY40k5/qc05LGDxHHd1twd5g9bP8uAd9C5WjZmh653MupLA+EXjQ==
X-Received: by 2002:a17:902:b287:: with SMTP id u7mr4325682plr.65.1571758228944;
        Tue, 22 Oct 2019 08:30:28 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id z63sm6066128pgb.75.2019.10.22.08.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:30:27 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] crypto: caam - use devres to de-initialize the RNG
Date:   Tue, 22 Oct 2019 08:30:10 -0700
Message-Id: <20191022153013.3692-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022153013.3692-1-andrew.smirnov@gmail.com>
References: <20191022153013.3692-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devres to de-initialize the RNG and drop explicit de-initialization
code in caam_remove().

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 130 ++++++++++++++++++++-----------------
 1 file changed, 70 insertions(+), 60 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 254963498abc..f8c75a999913 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -175,6 +175,73 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	return 0;
 }
 
+/*
+ * deinstantiate_rng - builds and executes a descriptor on DECO0,
+ *		       which deinitializes the RNG block.
+ * @ctrldev - pointer to device
+ * @state_handle_mask - bitmask containing the instantiation status
+ *			for the RNG4 state handles which exist in
+ *			the RNG4 block: 1 if it's been instantiated
+ *
+ * Return: - 0 if no error occurred
+ *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
+ *	   - -ENODEV if DECO0 couldn't be acquired
+ *	   - -EAGAIN if an error occurred when executing the descriptor
+ */
+static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
+{
+	u32 *desc, status;
+	int sh_idx, ret = 0;
+
+	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
+		/*
+		 * If the corresponding bit is set, then it means the state
+		 * handle was initialized by us, and thus it needs to be
+		 * deinitialized as well
+		 */
+		if ((1 << sh_idx) & state_handle_mask) {
+			/*
+			 * Create the descriptor for deinstantating this state
+			 * handle
+			 */
+			build_deinstantiation_desc(desc, sh_idx);
+
+			/* Try to run it through DECO0 */
+			ret = run_descriptor_deco0(ctrldev, desc, &status);
+
+			if (ret ||
+			    (status && status != JRSTA_SSRC_JUMP_HALT_CC)) {
+				dev_err(ctrldev,
+					"Failed to deinstantiate RNG4 SH%d\n",
+					sh_idx);
+				break;
+			}
+			dev_info(ctrldev, "Deinstantiated RNG4 SH%d\n", sh_idx);
+		}
+	}
+
+	kfree(desc);
+
+	return ret;
+}
+
+static void devm_deinstantiate_rng(void *data)
+{
+	struct device *ctrldev = data;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+
+	/*
+	 * De-initialize RNG state handles initialized by this driver.
+	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
+	 */
+	if (ctrlpriv->rng4_sh_init)
+		deinstantiate_rng(ctrldev, ctrlpriv->rng4_sh_init);
+}
+
 /*
  * instantiate_rng - builds and executes a descriptor on DECO0,
  *		     which initializes the RNG block.
@@ -247,59 +314,9 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 
 	kfree(desc);
 
-	return ret;
-}
-
-/*
- * deinstantiate_rng - builds and executes a descriptor on DECO0,
- *		       which deinitializes the RNG block.
- * @ctrldev - pointer to device
- * @state_handle_mask - bitmask containing the instantiation status
- *			for the RNG4 state handles which exist in
- *			the RNG4 block: 1 if it's been instantiated
- *
- * Return: - 0 if no error occurred
- *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
- *	   - -ENODEV if DECO0 couldn't be acquired
- *	   - -EAGAIN if an error occurred when executing the descriptor
- */
-static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
-{
-	u32 *desc, status;
-	int sh_idx, ret = 0;
-
-	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
-		/*
-		 * If the corresponding bit is set, then it means the state
-		 * handle was initialized by us, and thus it needs to be
-		 * deinitialized as well
-		 */
-		if ((1 << sh_idx) & state_handle_mask) {
-			/*
-			 * Create the descriptor for deinstantating this state
-			 * handle
-			 */
-			build_deinstantiation_desc(desc, sh_idx);
-
-			/* Try to run it through DECO0 */
-			ret = run_descriptor_deco0(ctrldev, desc, &status);
-
-			if (ret ||
-			    (status && status != JRSTA_SSRC_JUMP_HALT_CC)) {
-				dev_err(ctrldev,
-					"Failed to deinstantiate RNG4 SH%d\n",
-					sh_idx);
-				break;
-			}
-			dev_info(ctrldev, "Deinstantiated RNG4 SH%d\n", sh_idx);
-		}
-	}
-
-	kfree(desc);
+	if (!ret)
+		ret = devm_add_action_or_reset(ctrldev, devm_deinstantiate_rng,
+					       ctrldev);
 
 	return ret;
 }
@@ -320,13 +337,6 @@ static int caam_remove(struct platform_device *pdev)
 		caam_qi_shutdown(ctrldev);
 #endif
 
-	/*
-	 * De-initialize RNG state handles initialized by this driver.
-	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
-	 */
-	if (!ctrlpriv->mc_en && ctrlpriv->rng4_sh_init)
-		deinstantiate_rng(ctrldev, ctrlpriv->rng4_sh_init);
-
 	return 0;
 }
 
-- 
2.21.0


Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76F9C3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A983E22CF5
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8l0cxXV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDCgH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:36:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45163 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbfIDCfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:42 -0400
Received: by mail-pl1-f196.google.com with SMTP id x3so3708123plr.12;
        Tue, 03 Sep 2019 19:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pt/GBpcJQe6RBgeOuceiGFWi5YBQKs6SQx1eqllYD2g=;
        b=g8l0cxXVh4OEOhKG8I6tq3p4vQpg14tn8CIGz/816KbkRL5eQ1tqYFwKjEB4KWK895
         Xa6XyRi6O1pUht4dvtp0uoDpF03D9UCO1XNdmPYUif89ook1OAwh6YtcWtZSHWWR5ZQL
         XnSWL7ZJchmWD/VhCrLvhajnaig76SJcaLPzGomtqv/HgH37zmb7X8YYr2et/EIXRXpl
         nKVVn70e0IClBbKj6Oeo4jTxe8fWY9by6JZkTxt2IPqEYm4yau/Pjsy51+R5KkADGL3U
         hRm9P2wWZ6sFyHpVQamm8Lll7w7Im5wsSkdhSbZ18ZaaPyKpwzazemdL1/8Nnj5wAo1d
         O2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pt/GBpcJQe6RBgeOuceiGFWi5YBQKs6SQx1eqllYD2g=;
        b=abfk9fLDXfz6vj2NgJlWouDeZ3TZMjMgKB8sMaKhugvF/iH4gPdgZYwlm7uMTQgr6z
         XBVTBfB9Dyc5Rs20cGfsPVLtT2BWfCFEd56S9H5QUvxsJK4ikD9pM6r2QeK9NnEWyq6z
         GKGPqHYJfChIXzsFsRz9B3d5nJtUmczkEi780S7KGGrEybDM/iRI1pw3nrWrAotV2vaA
         5b7E9iAV9nQKWHTv5n05e6y4sKgQtdT4223IDdBqGXt2LzPcefkHY76C/GVzGYIB4OeV
         ap+jlLVF7CLNruedFuKQGeHvUIeSjunGc7XDQ4rp/ym7rNhFxB0KRPc0xUfCN3thmutI
         jMMA==
X-Gm-Message-State: APjAAAXSmALtkMhc+t9GDqwwPBHiKJIrw8b/+Kmd/o+8ddwgV/8KOE2P
        T0IoIHkkxFyqK7y57TY8oOk+UolN46A=
X-Google-Smtp-Source: APXvYqyLn46tC98ruFyb2a/5B7Q4zSm9ATGY1QCOLhxROkjwt/Bdtq8gz5KqrlqWlrXRbpjRrvTpNw==
X-Received: by 2002:a17:902:b190:: with SMTP id s16mr28632954plr.199.1567564540678;
        Tue, 03 Sep 2019 19:35:40 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:40 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] crypto: caam - use devres to de-initialize the RNG
Date:   Tue,  3 Sep 2019 19:35:10 -0700
Message-Id: <20190904023515.7107-8-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904023515.7107-1-andrew.smirnov@gmail.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/ctrl.c | 129 ++++++++++++++++++++-----------------
 1 file changed, 70 insertions(+), 59 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 254963498abc..25f8f76551a5 100644
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
@@ -247,60 +314,11 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 
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
+	if (!ret) {
+		ret = devm_add_action_or_reset(ctrldev, devm_deinstantiate_rng,
+					       ctrldev);
 	}
 
-	kfree(desc);
-
 	return ret;
 }
 
@@ -320,13 +338,6 @@ static int caam_remove(struct platform_device *pdev)
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


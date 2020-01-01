Return-Path: <SRS0=Hyrp=2W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E19C2D0DE
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 22:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3CC207E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 22:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iE/VxUdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgAAW1I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jan 2020 17:27:08 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36017 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbgAAW1G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jan 2020 17:27:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so4288713wma.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jan 2020 14:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jprVQvXZ+BpbUQdZ3A28S+PaCcv4bL/lHMm7bf3Dozg=;
        b=iE/VxUdzUhYcmD+7wG8899EJ3NSiQEbDt+Z2kbUNaiHxXl8EGvCrVBxVUuxfUbtc5T
         sQ0KYB+QY49poylgdtwGg7qfDhle9WmUNpO82hxBwq+7SIKPMgIN3iq5UbHCYvqEqbi2
         pBhuwOqkFntcxo5GCzwvGUned1BMT3WpAJatgWOb0y15cdRVNCpcA3/Rtz26KPep9/L5
         eEgWUqfU9jzAwSt/jZsg/BZhjqsswd5Apl0LpTXz3jNzWPlcSbDBl/LR9cgYqwmMKGp0
         5Tx+fe1NzsNMUaV2i3U+ix7u+wGaEmblCA5Pws1kkUIr9PZwM4QSY8QQ36sRqC7Aabt4
         OS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jprVQvXZ+BpbUQdZ3A28S+PaCcv4bL/lHMm7bf3Dozg=;
        b=RFDuO9exu9bwK4PZqtO8c0eDX94Bclm2i0b+UCeQ5GkgkHh6Iwe3pLvQ5pPFhKnfjA
         RwjoH+8UzUMPUuY2yOpx0wOYpeWaDC32RFMBCE5TGch74cHgDLzZb71noRmuwzuT+DNw
         vzKxdFOKw/FFL0/DhSf84tiktUtAXbT7jqwwhJ0V+sZN1fiR/+HjzY9vTEwxjJ83OVCI
         eF35zioQt5JtbidneefZwltCuMQndkdDmtvqNO6cwy/TkQnck1EmVWkPLJjE9Noyedmd
         w7rtKoB38OHwx075YA4PEBHJOYoVzANpTWdfvJo+bDw7JLV5mfXXTHzNdSPrDajrhwv3
         jL7Q==
X-Gm-Message-State: APjAAAUc9+zu39wTEGOTtVKNFTt/juexiGptAu/EVlilSnIqlWUO6Jf0
        /P/vqiwomBnfC7AzeKvDHZSccPtF
X-Google-Smtp-Source: APXvYqyQ7Zy0v5TFEi65vpIxdF2u833Cg3A1U1nVzkgMII6ACIHSsXmzUTzK0/uqsPqCr3eVbAJpLQ==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr10606383wmf.142.1577917624407;
        Wed, 01 Jan 2020 14:27:04 -0800 (PST)
Received: from debian64.daheim (pD9E29458.dip0.t-ipconnect.de. [217.226.148.88])
        by smtp.gmail.com with ESMTPSA id e18sm53718406wrr.95.2020.01.01.14.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 14:27:03 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.93)
        (envelope-from <chunkeey@gmail.com>)
        id 1immSE-002BvY-Jn; Wed, 01 Jan 2020 23:27:02 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: crypto4xx - reduce memory fragmentation
Date:   Wed,  1 Jan 2020 23:27:01 +0100
Message-Id: <3913dbe4b3256ead342572f7aba726a60ab5fd43.1577917078.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.25.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With recent kernels (>5.2), the driver fails to probe, as the
allocation of the driver's scatter buffer fails with -ENOMEM.

This happens in crypto4xx_build_sdr(). Where the driver tries
to get 512KiB (=PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD) of
continuous memory. This big chunk is by design, since the driver
uses this circumstance in the crypto4xx_copy_pkt_to_dst() to
its advantage:
"all scatter-buffers are all neatly organized in one big
continuous ringbuffer; So scatterwalk_map_and_copy() can be
instructed to copy a range of buffers in one go."

The PowerPC arch does not have support for DMA_CMA. Hence,
this patch reorganizes the order in which the memory
allocations are done. Since the driver itself is responsible
for some of the issues.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 7d6b695c4ab3..3ce5f0a24cbc 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -286,7 +286,8 @@ static u32 crypto4xx_build_gdr(struct crypto4xx_device *dev)
 
 static inline void crypto4xx_destroy_gdr(struct crypto4xx_device *dev)
 {
-	dma_free_coherent(dev->core_dev->device,
+	if (dev->gdr)
+		dma_free_coherent(dev->core_dev->device,
 			  sizeof(struct ce_gd) * PPC4XX_NUM_GD,
 			  dev->gdr, dev->gdr_pa);
 }
@@ -354,13 +355,6 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 {
 	int i;
 
-	/* alloc memory for scatter descriptor ring */
-	dev->sdr = dma_alloc_coherent(dev->core_dev->device,
-				      sizeof(struct ce_sd) * PPC4XX_NUM_SD,
-				      &dev->sdr_pa, GFP_ATOMIC);
-	if (!dev->sdr)
-		return -ENOMEM;
-
 	dev->scatter_buffer_va =
 		dma_alloc_coherent(dev->core_dev->device,
 			PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
@@ -368,6 +362,13 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 	if (!dev->scatter_buffer_va)
 		return -ENOMEM;
 
+	/* alloc memory for scatter descriptor ring */
+	dev->sdr = dma_alloc_coherent(dev->core_dev->device,
+				      sizeof(struct ce_sd) * PPC4XX_NUM_SD,
+				      &dev->sdr_pa, GFP_ATOMIC);
+	if (!dev->sdr)
+		return -ENOMEM;
+
 	for (i = 0; i < PPC4XX_NUM_SD; i++) {
 		dev->sdr[i].ptr = dev->scatter_buffer_pa +
 				  PPC4XX_SD_BUFFER_SIZE * i;
@@ -1439,15 +1440,14 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	spin_lock_init(&core_dev->lock);
 	INIT_LIST_HEAD(&core_dev->dev->alg_list);
 	ratelimit_default_init(&core_dev->dev->aead_ratelimit);
+	rc = crypto4xx_build_sdr(core_dev->dev);
+	if (rc)
+		goto err_build_sdr;
 	rc = crypto4xx_build_pdr(core_dev->dev);
 	if (rc)
-		goto err_build_pdr;
+		goto err_build_sdr;
 
 	rc = crypto4xx_build_gdr(core_dev->dev);
-	if (rc)
-		goto err_build_pdr;
-
-	rc = crypto4xx_build_sdr(core_dev->dev);
 	if (rc)
 		goto err_build_sdr;
 
@@ -1493,7 +1493,6 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 err_build_sdr:
 	crypto4xx_destroy_sdr(core_dev->dev);
 	crypto4xx_destroy_gdr(core_dev->dev);
-err_build_pdr:
 	crypto4xx_destroy_pdr(core_dev->dev);
 	kfree(core_dev->dev);
 err_alloc_dev:
-- 
2.25.0.rc0


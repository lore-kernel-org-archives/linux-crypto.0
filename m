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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7562DC32764
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 22:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FB42084D
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 22:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iVniOg00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgAAW1H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jan 2020 17:27:07 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35706 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbgAAW1G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jan 2020 17:27:06 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so37722576wro.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jan 2020 14:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V1GBEWPALyPtkudgT7c9kG+j18MpNg7++otpEJyv+Jo=;
        b=iVniOg00mjx0HNZQhza/dTTt4tpoXNH7CD/VKzEvBHudXOuV+SHLRLDYHfZ2wU+XAF
         jEGDxxyMS4cgQcTOxhGiIwhKqg4cDhIMMfd/GSSCHLHYO2v1zKYLPG9q+HHpH6+2cwQJ
         5qgjZwQOrydiY/pJfSSgCN+x2EznRpbH3+W3wRfQDSO4kkVOb/N84/+xImIhuATec+qC
         lfikg6rzS6TCEOplx25WrQybImeZFYr7Ps3eWPnGojtTY5vMNCjlybhSiK7Ea9bqpxMb
         0n7Ay8U52uapAwN49DS1X15nU6De3OAOl0LyQ4cIiEgz+TQJWt+7RzKigz0BPIVKfmSo
         t9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V1GBEWPALyPtkudgT7c9kG+j18MpNg7++otpEJyv+Jo=;
        b=rGJhVCa6G03LDDxUHPIaC1bEPPSbXvPknV0OzpN20XvLcItdHQGNEGRtfIbJT4ccuJ
         wEjOZbLfLHk1cVp5UtjVT9z3orokGr+m/mgVUJM87jyqqJ5osrrY1Gnhb0sUKaZckjOQ
         gLr152kg4Uxivq5GGkT07xtr559K5JQCH6D0zhLSsG7eo8IusOimMenvr7U0fK9CoytJ
         E6FyaoEmHK1bGS+GDIsZ+zK0LqxlN6rtmzjiBGvmKTEPc1cQrxMxZdgzmcjBSAoZnn4U
         4Rm/UF3P1l9GEwA/VAmfgSDL/ibGbRgG9sLNnFa5D1Gd3toSxb/gZhng3JttFW+1d04n
         MT4g==
X-Gm-Message-State: APjAAAXiMljdhXMXjBSo/yTK278aJHaGOPWijCV8M/pyLz0++HjccUOi
        Xpuw+lUn2degLlV68ylooAd488bK
X-Google-Smtp-Source: APXvYqyki1xVblkwyG2FZyW+JXgHxkan47vJWJ1zbILdUlxsgi2LbCMovBIKwDUFVpqxSYUUZytCug==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr79281192wrm.284.1577917624711;
        Wed, 01 Jan 2020 14:27:04 -0800 (PST)
Received: from debian64.daheim (pD9E29458.dip0.t-ipconnect.de. [217.226.148.88])
        by smtp.gmail.com with ESMTPSA id r68sm6198895wmr.43.2020.01.01.14.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 14:27:03 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.93)
        (envelope-from <chunkeey@gmail.com>)
        id 1immSE-002Bvb-KZ; Wed, 01 Jan 2020 23:27:02 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: crypto4xx - use GFP_KERNEL for big allocations
Date:   Wed,  1 Jan 2020 23:27:02 +0100
Message-Id: <5bacaaea8a228bc46f402595b1694ef9128f3599.1577917078.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.25.0.rc0
In-Reply-To: <3913dbe4b3256ead342572f7aba726a60ab5fd43.1577917078.git.chunkeey@gmail.com>
References: <3913dbe4b3256ead342572f7aba726a60ab5fd43.1577917078.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver should use GFP_KERNEL for the bigger allocation
during the driver's crypto4xx_probe() and not GFP_ATOMIC in
my opinion.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 3ce5f0a24cbc..981de43ea5e2 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -169,7 +169,7 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 	int i;
 	dev->pdr = dma_alloc_coherent(dev->core_dev->device,
 				      sizeof(struct ce_pd) * PPC4XX_NUM_PD,
-				      &dev->pdr_pa, GFP_ATOMIC);
+				      &dev->pdr_pa, GFP_KERNEL);
 	if (!dev->pdr)
 		return -ENOMEM;
 
@@ -185,13 +185,13 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 	dev->shadow_sa_pool = dma_alloc_coherent(dev->core_dev->device,
 				   sizeof(union shadow_sa_buf) * PPC4XX_NUM_PD,
 				   &dev->shadow_sa_pool_pa,
-				   GFP_ATOMIC);
+				   GFP_KERNEL);
 	if (!dev->shadow_sa_pool)
 		return -ENOMEM;
 
 	dev->shadow_sr_pool = dma_alloc_coherent(dev->core_dev->device,
 			 sizeof(struct sa_state_record) * PPC4XX_NUM_PD,
-			 &dev->shadow_sr_pool_pa, GFP_ATOMIC);
+			 &dev->shadow_sr_pool_pa, GFP_KERNEL);
 	if (!dev->shadow_sr_pool)
 		return -ENOMEM;
 	for (i = 0; i < PPC4XX_NUM_PD; i++) {
@@ -277,7 +277,7 @@ static u32 crypto4xx_build_gdr(struct crypto4xx_device *dev)
 {
 	dev->gdr = dma_alloc_coherent(dev->core_dev->device,
 				      sizeof(struct ce_gd) * PPC4XX_NUM_GD,
-				      &dev->gdr_pa, GFP_ATOMIC);
+				      &dev->gdr_pa, GFP_KERNEL);
 	if (!dev->gdr)
 		return -ENOMEM;
 
@@ -358,14 +358,14 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 	dev->scatter_buffer_va =
 		dma_alloc_coherent(dev->core_dev->device,
 			PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
-			&dev->scatter_buffer_pa, GFP_ATOMIC);
+			&dev->scatter_buffer_pa, GFP_KERNEL);
 	if (!dev->scatter_buffer_va)
 		return -ENOMEM;
 
 	/* alloc memory for scatter descriptor ring */
 	dev->sdr = dma_alloc_coherent(dev->core_dev->device,
 				      sizeof(struct ce_sd) * PPC4XX_NUM_SD,
-				      &dev->sdr_pa, GFP_ATOMIC);
+				      &dev->sdr_pa, GFP_KERNEL);
 	if (!dev->sdr)
 		return -ENOMEM;
 
-- 
2.25.0.rc0


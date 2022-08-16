Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1384C28B2B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiHPODo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbiHPOD0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:26 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDCB57896
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:21 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id l10so10618357lje.7
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=sctki4nak4ZBSfbhd2II7H8or4YuNVPYzsqrowWkZ4E=;
        b=f5JUTuZhfEMvSB6ln1mYJLWrWHK3VNXsVun6B98tIgrH2UdZzjUi+CRmw9p5jq6zc/
         mFvIn+abPhojCqvHi32zTMH0KPm3JmGkawcWmysalrSIO1hbTnhNuH/P4miE8KRVSssL
         f3hxkeqUeuWO3Z88cNwG8dNoijjoBO/1KDWuMLSQaI8rvTJMaToyJTu9i8aEXofym1CN
         eBXg3N+DocOztz6ZN0xxnRV9K2xjgeDtiVLFxUd87hiGdmjnvqfGexlZPoNWUzrMD9MO
         6apqIHn/W8HIZzZU0ta4bqMPfeRq68RJtWoniERoNtkL4ah8wO3cVGlXZyj7zn8k267P
         1g8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=sctki4nak4ZBSfbhd2II7H8or4YuNVPYzsqrowWkZ4E=;
        b=5Qbpt1arkK99Ea0mz6DfJrAns5nLw1cvFPhc3PFY3DPpC7vEm542FsiujP1cIRonXd
         7bs3vRFY3JylMwCnakBL3qmziDhvh+2BfLB0Zx9B31dncE1+AHuK47o3z9QjhdPIgt5i
         a67lGMbSPy1w+5JTr0FkY5HvVK5cchqfyklBCY17oDeku9SPFindiSKCXZi8wWv4lXrU
         x77R/mPEtB4JLiHtxNIBM97J9WbaPJciBC/PCR6IDti3nnPNdOA6YUfsIgag1n6TpFH7
         yeYnAxRPxdJPK+4x9KMQleGpihgrtSD+86ql1QOP/6nq3FDC0Nb5cQLBR6M1F5aydX+x
         u9bA==
X-Gm-Message-State: ACgBeo1H/Jhw3hCgfskv7i74cF+vDIXZbIPmyk9Qe0QzbCQGcxrK91No
        XRSQuEwl/0rLTP8CPEPIt03IXoFRXWjcVA==
X-Google-Smtp-Source: AA6agR6o6w78tVBFUXeTZtdyBttUTprdNcoKY82rKt9uZTzM29vRMHra8jrDdhOnG2W8B51RL9YmlA==
X-Received: by 2002:a2e:9147:0:b0:25e:5764:9c9f with SMTP id q7-20020a2e9147000000b0025e57649c9fmr6714667ljg.278.1660658598029;
        Tue, 16 Aug 2022 07:03:18 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:17 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 05/16] crypto: ux500/hash: Drop bit index
Date:   Tue, 16 Aug 2022 16:00:38 +0200
Message-Id: <20220816140049.102306-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is some leftover code because the field is only referenced
in a debug print and never assigned.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_alg.h  | 4 ----
 drivers/crypto/ux500/hash/hash_core.c | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 26e8b7949d7c..00730c0090ae 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -217,7 +217,6 @@ struct hash_register {
  * @buffer:	Working buffer for messages going to the hardware.
  * @length:	Length of the part of message hashed so far (floor(N/64) * 64).
  * @index:	Valid number of bytes in buffer (N % 64).
- * @bit_index:	Valid number of bits in buffer (N % 8).
  *
  * This structure is used between context switches, i.e. when ongoing jobs are
  * interupted with new jobs. When this happens we need to store intermediate
@@ -237,7 +236,6 @@ struct hash_state {
 	u32		buffer[HASH_BLOCK_SIZE / sizeof(u32)];
 	struct uint64	length;
 	u8		index;
-	u8		bit_index;
 };
 
 /**
@@ -358,7 +356,6 @@ struct hash_req_ctx {
  * @power_state_lock:	Spinlock for power_state.
  * @regulator:		Pointer to the device's power control.
  * @clk:		Pointer to the device's clock control.
- * @restore_dev_state:	TRUE = saved state, FALSE = no saved state.
  * @dma:		Structure used for dma.
  */
 struct hash_device_data {
@@ -372,7 +369,6 @@ struct hash_device_data {
 	spinlock_t		power_state_lock;
 	struct regulator	*regulator;
 	struct clk		*clk;
-	bool			restore_dev_state;
 	struct hash_state	state; /* Used for saving and resuming state */
 	struct hash_dma		dma;
 };
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index fbd6335f142b..65d328d438d2 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -991,8 +991,8 @@ int hash_hw_update(struct ahash_request *req)
 	}
 
 	req_ctx->state.index = index;
-	dev_dbg(device_data->dev, "%s: indata length=%d, bin=%d\n",
-		__func__, req_ctx->state.index, req_ctx->state.bit_index);
+	dev_dbg(device_data->dev, "%s: indata length=%d\n",
+		__func__, req_ctx->state.index);
 
 	return 0;
 }
-- 
2.37.2


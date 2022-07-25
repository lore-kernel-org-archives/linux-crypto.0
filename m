Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A05CCA48F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiGYOHc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiGYOHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:30 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50987167C2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:29 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t17so5956876lfk.0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRvI4FZyi9EAerjPaenffG/YQ8jsdNde1v0863NG528=;
        b=CX2PeM/RmnUqqvtuDcLYfqpl6eTxSkeU9motVdpORR72Hem2+0iFD/TDH+LDKEEoRz
         jwVTAEmGFzI9iyMCCjsh1Q20nBfwVOBt3m3lpplUgfICLyiHtco1W+HQFrMAubWehyTP
         zuF+t08i5dnYkBSAhAxAB6gjxqdY/weY4iOclDPiCq2S/ckHh2kNqK4n4Gs3QqfPzex+
         Wp67SbjfVeiAFtZ709ycS+uGnk/9CKQY9KjWgxRpGzrFvvMx2IyhX/lR7+8dtsJG+uD6
         uy/8jE1mAaadZtIqfpnTYaq3QA1168+/pnyGWtFkOOYnSXVOa9C11cLIH7mpnfLB2bFa
         VCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRvI4FZyi9EAerjPaenffG/YQ8jsdNde1v0863NG528=;
        b=fl57kuCt9QPifuVqj1trPDInYe1ohfXIWV9GC1SgSegOEwbacRh6P6g/Nfqs41PFxs
         kibL7/ypKOFe8luWArEu99D0KuIwwLnG/PrcUNc149Wci84RSqM1SUWvcvWUjTXnei2D
         qxu+H9EL31UIs5wpMVm4zMF8bsGQ5/QEATxnt9oxwWeLhsaoQBPt6unIG1ABQVqPlSPD
         8G38MOgX5zLjSPrZ+5q4FCeATf2HxIM3rFyGD4eDAPw+M6KLc3ic5yjayyrLM68SMQGB
         2xF0cYXYuxUrzEYmixQmbCrElIgMMS+/e74oZ4CfWKf/k1jkaai0HYtpax4N8xsAYOtE
         x8xg==
X-Gm-Message-State: AJIora9YXvU5NcrQruIjHh1k+mlVsLdeypV6D4qDN5IP2F2DsPQYkqIV
        N5nPlmzRtenrYYYUQ2yN7n61dkCqNINSfg==
X-Google-Smtp-Source: AGRyM1utbeva6CvwbChtckcmDyHUNhJJhIIziA+US8OtNy6CMqzgFQD3KHkF6PepkgcFnSvqTAkiIg==
X-Received: by 2002:ac2:5084:0:b0:48a:6e29:bf8 with SMTP id f4-20020ac25084000000b0048a6e290bf8mr4756854lfm.572.1658758047443;
        Mon, 25 Jul 2022 07:07:27 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:27 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/15 v2] crypto: ux500/hash: Drop bit index
Date:   Mon, 25 Jul 2022 16:04:54 +0200
Message-Id: <20220725140504.2398965-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is some leftover code because the field is only referenced
in a debug print and never assigned.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
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
index e6e3a91ae795..e9962c8a29bd 100644
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
2.36.1


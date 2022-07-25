Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89486CCA48F
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiGYOIF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbiGYOIA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:08:00 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BF115FEA
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:41 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id m9so13218091ljp.9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrdUO9p0SA0PsaHNzNaJfswGHU5WZE7FQ25wOEwgT+E=;
        b=r61hLiVUDqiYKvL0Rbcg5CGjg5OD61d4x2IyQT4cbcupYh+QBKe/3mDJWC6CiDX1WV
         6jVUUDt0XG4QJRWb0RFZDrJDnl5EGFS18lNwnGBOWBtKUrbrErHgHuzyzb2b3QwG6XkW
         wnbBkcQbwlm3C8OQjDtMxhUK4HQrGK8PxLZFm2copghgLhK9FXIGQKtZq9f5yb81bVqZ
         b9GtiZnAIl1wU4ofw7gA2hQdIfcfhWDqYYETXeL7JAaNrb/ugG4KTDGFPfVpk8HxyFj8
         MPSyUNW6Iw77O+E8Z1dwksg/ulzaBNEkh/6FvoDhveSqgJ6dsb0wLvfehu6vMIgleErP
         IApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrdUO9p0SA0PsaHNzNaJfswGHU5WZE7FQ25wOEwgT+E=;
        b=uv8JGhJzOlzqFfXhdgvv70vuXWZ04GeNRSJc4H+Kn0YRfIaKxuUYEjB6UVkirjYdBZ
         q4fCDi8W7xHhuYxRSKRXerT1kxPVd/Z0Le85PwMiENt0Pra8JBBkJwpSCZU7kQWF1Bq7
         /BXNKTbL1x9liEHcr23NgflyMo0kYUu2Gi1MwbGqLgqVzugpOB4OP7HqbheXA1JCHcPc
         IDjjyTRUNAQpYv/nJ82mxrl9ctIjR5g60ZA6Ehj7wRmCEey8E/rwOA+/QtnmZDSEgATO
         wEoJ7TGbpnuND6SoX9VKv5Wb0RKK8jNJU7OVDIqUrBGBeTp4UMyy2DZbOw7Tp6OMXEqx
         Mh4g==
X-Gm-Message-State: AJIora/jSRfaBY4ytVe6oXNq7kFclWpFqApZpgUESV0qwFx67LjPDbK8
        MyZkEUpWy1Fevr9O//RvdiPpi/xjPENvHg==
X-Google-Smtp-Source: AGRyM1u1CMCV1K4zo/EliOwZX9n0smF+kYBaNmbtWs//+n4miikHEfMb7d/tYjTqAu9+/kJ/vtJH4A==
X-Received: by 2002:a05:651c:1615:b0:25e:7df:f7b4 with SMTP id f21-20020a05651c161500b0025e07dff7b4mr1598516ljq.188.1658758059689;
        Mon, 25 Jul 2022 07:07:39 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:39 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 14/15 v2] crypto: ux500/hash: Use AMBA core primecell IDs
Date:   Mon, 25 Jul 2022 16:05:03 +0200
Message-Id: <20220725140504.2398965-15-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the AMBA (PrimeCell) bus core define and read 32bit
CID and PID from the peripheral, then check those.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Initialized both CID and PID to 0 appropriately.
---
 drivers/crypto/ux500/hash/hash_alg.h  | 11 ++---------
 drivers/crypto/ux500/hash/hash_core.c | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index cc44d3cb21ac..96c614444fa2 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -63,15 +63,8 @@
 #define HASH_STR_NBLW_MASK	0x0000001FUL
 #define HASH_NBLW_MAX_VAL	0x1F
 
-/* PrimeCell IDs */
-#define HASH_P_ID0		0xE0
-#define HASH_P_ID1		0x05
-#define HASH_P_ID2		0x38
-#define HASH_P_ID3		0x00
-#define HASH_CELL_ID0		0x0D
-#define HASH_CELL_ID1		0xF0
-#define HASH_CELL_ID2		0x05
-#define HASH_CELL_ID3		0xB1
+/* PrimeCell ID */
+#define UX500_HASH_PID		0x003805E0U
 
 /* Hardware access method */
 enum hash_mode {
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 914c35919570..71ed2a573714 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) "hashX hashX: " fmt
 
+#include <linux/amba/bus.h>
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
@@ -949,18 +950,28 @@ int hash_check_hw(struct hash_device_data *device_data)
 	unsigned int regs[] = { UX500_HASH_PERIPHID0, UX500_HASH_PERIPHID1,
 		UX500_HASH_PERIPHID2, UX500_HASH_PERIPHID3, UX500_HASH_CELLID0,
 		UX500_HASH_CELLID1, UX500_HASH_CELLID2, UX500_HASH_CELLID3 };
-	unsigned int expected[] = { HASH_P_ID0, HASH_P_ID1, HASH_P_ID2, HASH_P_ID3,
-		HASH_CELL_ID0, HASH_CELL_ID1, HASH_CELL_ID2, HASH_CELL_ID3 };
 	unsigned int val;
+	u32 pid = 0;
+	u32 cid = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
 		regmap_read(device_data->map, regs[i], &val);
-		if (val != expected[i]) {
-			dev_err(device_data->dev, "ID word %d was %08x expected %08x\n",
-				i, val, expected[i]);
-			return -ENODEV;
-		}
+		if (i < 4)
+			pid |= (val & 255) << (i * 8);
+		else
+			cid |= (val & 255) << ((i - 4) * 8);
+	}
+
+	if (cid != AMBA_CID) {
+		dev_err(device_data->dev, "AMBA CID was %08x expected %08x\n",
+			cid, AMBA_CID);
+		return -ENODEV;
+	}
+	if (pid != UX500_HASH_PID) {
+		dev_err(device_data->dev, "PID was %08x expected %08x\n",
+			pid, UX500_HASH_PID);
+		return -ENODEV;
 	}
 
 	return 0;
-- 
2.36.1


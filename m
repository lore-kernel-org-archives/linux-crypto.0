Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61074C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiGUNpc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiGUNoM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:44:12 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73A185D69
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:14 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z22so2851553lfu.7
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zYS++DqZZJZ4dvIqRTXxDhDnXHSI1cMkpUczRGNZhnA=;
        b=wATY/y0gsIvlvzvPsDq1n4/lpqroSymoajpW4vR+wn2co0/W8I1suw9tXibwdimcuo
         ca5z1C1DcPlusxluSCmtikMk/tSjPTICw+mJStRSqtZiszLq2jEbpD9ha/m5Q10VOrXi
         2+8IVHI0u2Ns6Iynmev1bBXBEmGha22C9CA/seWpUuV1hy4p7kbCP32FSf0OMPmMH0ku
         oVa4KdVmjzNdS4cRrIz5sfdWdXE1w9kL1XUKzbx+JeMUeIkNdJ1gXi2AtTSzPYQd+T4w
         X0Y1j6WZZNuBQP2eyEqpc4mcScpa765ys8V6msDwNy6Ut8LOUoNwYFX49jR/W0jRGVyH
         Va5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zYS++DqZZJZ4dvIqRTXxDhDnXHSI1cMkpUczRGNZhnA=;
        b=RjLDcsGt2Pp5d5CjZzfBPay/iu80BWnAsqKeNg0b+f99f5+Gmgy19swCmPNB4SaZlV
         3HVku1MjVChZmw6P9SSP9zHWlQTDkY5Ycfefx5RdqL59IRR32lmUlBJ7MrDvobftlNpG
         K+LZezhbtbatriJcN3kCIBMOVdLiX0caaSPioHcoWzknUiCUStu4ky9PnBmUgYtTwGMQ
         I+H6ht7UfE6a/lKPJN8ocwdrdvRyriq2vaEMWfw+JJ7uv24zlgiYMAYIWpfHIpngD6yf
         wSXptQ+xgBwPf1iokTNlQ9T3MDGTqMagZleR2nhg4Yftv/cPdhYWKRR0mD5zBt+TNuu5
         xezw==
X-Gm-Message-State: AJIora/6KWNINJ13pbcn58xCtW2kxBXi5vRCFJxBGw73W9cGEzmEXIMJ
        QIH5zgGUPEd5/Vewde5srwOluRy5en/Bdg==
X-Google-Smtp-Source: AGRyM1ut2DRnSzjd5OOJ/DKEf9PjPiI2zOgsiVkU+gNjEy+OfjyoBRa+Y634aqVFaQcmUrojQWDOog==
X-Received: by 2002:ac2:435a:0:b0:48a:73bf:7371 with SMTP id o26-20020ac2435a000000b0048a73bf7371mr424493lfl.96.1658410993483;
        Thu, 21 Jul 2022 06:43:13 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:13 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 13/15] crypto: ux500/hash: Use AMBA core primecell IDs
Date:   Thu, 21 Jul 2022 15:40:48 +0200
Message-Id: <20220721134050.1047866-14-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the AMBA (PrimeCell) bus core define and read 32bit
CID and PID from the peripheral, then check those.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  | 11 ++---------
 drivers/crypto/ux500/hash/hash_core.c | 27 +++++++++++++++++++--------
 2 files changed, 21 insertions(+), 17 deletions(-)

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
index 83833cbe595f..a64edfb1cd96 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) "hashX hashX: " fmt
 
+#include <linux/amba/bus.h>
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
@@ -940,18 +941,28 @@ int hash_check_hw(struct hash_device_data *device_data)
 	unsigned int regs[] = { UX500_HASH_PERIPHID0, UX500_HASH_PERIPHID1,
 		UX500_HASH_PERIPHID2, UX500_HASH_PERIPHID3, UX500_HASH_CELLID0,
 		UX500_HASH_CELLID1, UX500_HASH_CELLID2, UX500_HASH_CELLID3 };
-	unsigned int expected[] = { HASH_P_ID0, HASH_P_ID1, HASH_P_ID2, HASH_P_ID3,
-		HASH_CELL_ID0, HASH_CELL_ID1, HASH_CELL_ID2, HASH_CELL_ID3 };
 	unsigned int val;
+	u32 pid;
+	u32 cid;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+	for (pid = 0, i = 0; i < 8; i++) {
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


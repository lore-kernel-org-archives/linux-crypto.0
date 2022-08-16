Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BC3C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiHPOE0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiHPODp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:45 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA13275CC
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:31 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id s9so10622955ljs.6
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=iGU/vTvY2BX/8BFNJIo0Zi6+OPq5P/GCaKsV9MKmlIE=;
        b=JUvySrLf8AfkfDQXHferjf2b/51+EzSOdbTnPUEB5odg4h0YfoYDvpwoUGBv8hhI0C
         2H2kaUpK62JhEgD1Gr63xBymd/uLs9wD89+1AmFU9AGmJonAR6pEooAnGG3/fPXJk2qc
         W0he0f74qilfaQ3PvRZ2I0cIMfevvR67rmT+SjLVhAjoi6ZzKNJcdRf81jxECZQDvgDz
         PlUbIIQJAs+2zFyNj9XEc9s7BUQbxCsXX0w4JOIKUxk6IyDtxPqd4Z2+1DvqjWMoJde0
         bOtjad0ZfvlFdArBTeGs9aU9abuSpPHiDz2k4gAyy0DPjV4pizqc+383zwoPvLeZziwR
         cq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=iGU/vTvY2BX/8BFNJIo0Zi6+OPq5P/GCaKsV9MKmlIE=;
        b=rgIXZsVmxluqwtvaVVMwqbVGQ4SdqOTrDlTVNcp/VVLCmOrJ0cKOFM/qMtjf1fMX3e
         3jn6XvKCzwhl0Yh/VZgwsy/dxqAP3T8PjMeb2qTU0Lbbnjd1GG4BDztN7LnahlAekDPr
         0o+zliImrp/UY0eoIG/0JIg24v7LMWtXUfP4EgYUPw26vsjIGtuuV2czuD7mnnXOInnW
         EjrG3LCuerDeWKbV6aO1JkzhPWDCeur4c/BpGxNLSsh4P6StFu/EzSu5q9TFLwE6FRjS
         idNwKkygV57GxZP8QA/LBi2QTS66gtnCZRXMooFQo5Fn2NChfic+o7crRRaJaXkFa0DS
         1Ysw==
X-Gm-Message-State: ACgBeo0b86HRHjEqDK8dc/MHSvUjTlhOZmKvNZnsJWSqDGgXZxCHHWSn
        oaJhquRkj9ScZcPeCM10Fjglz3ZajyEb+A==
X-Google-Smtp-Source: AA6agR5iHJzwOOs05iNGV4oO74C0ClSsUfVFWA3J3GuRgen6PQ/F4ejV8LZ9LHj/xErIwU82K2sWVw==
X-Received: by 2002:a2e:9791:0:b0:261:6d82:7a6c with SMTP id y17-20020a2e9791000000b002616d827a6cmr6320638lji.224.1660658610158;
        Tue, 16 Aug 2022 07:03:30 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:29 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 14/16] crypto: ux500/hash: Use AMBA core primecell IDs
Date:   Tue, 16 Aug 2022 16:00:47 +0200
Message-Id: <20220816140049.102306-15-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the AMBA (PrimeCell) bus core define and read 32bit
CID and PID from the peripheral, then check those.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
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
index ed54e71efbb2..188e309406b2 100644
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
2.37.2


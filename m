Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E3C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5392F214C6
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lpsk1STX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfHLUIL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44551 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfHLUIK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id c81so1235331pfc.11;
        Mon, 12 Aug 2019 13:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=akl89jMmEGF3yE+77IIDs3S0+ezFFeZWWakji+x8GQI=;
        b=Lpsk1STXXgN22FD3TEBIC0Uc4/wLctQrp57jTap+ynMnDQbDwh0TJG/zVnnw3tAB0K
         CIb2CJohbNpFDz8rTfrKWoATPvu2S4gIeqAA8C7PQQTVlaQIJJuHJY2suW4wY922p/lW
         7SIEoHrx9XPm+kPBOELeeETcAJwhMi3Ftxp2s82v06B9S8NLb5GlL+GxYEDX8VwE3sHP
         VFENgJlPZnKm1K/ZNUgD2vxDqAp6IoHMPUMOWpkev//mifIMbaBlp9IVH5kQJ35e01QI
         aXdeZdjd6rpOEwH0opwz1qrEU/ao9QTH+eKiy1zvrfqit4YEQDm0owr9CpxV2KZZQfGC
         t5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akl89jMmEGF3yE+77IIDs3S0+ezFFeZWWakji+x8GQI=;
        b=G2/BFCjjuR1+MMcegpyaT9tHvnmUI4YEeP8NdgdoucbkYN18TTpuL2zk6I3Vi2DRL8
         +L+Vjf+yVbAJPCA3ZK2e/SpYvgkpHOJstLPxRZvUGvz6/QAs5VH1YowDR7CarFPRBJ7H
         wXJgP5x5TJSqO6KhRxDSqxprj4N9OX7uyqIKuARRiRN+gPYQDSB6X8kdRzcT2oVPsRja
         o8trR52TswdomXz4PaHCoAQm2jkpZPO9AGQXPUr7CrZYu7D1wet9GuLbdzuTA48oWW20
         /wR/AAM3PmHzSbAcM1mV0Z1iLZ2ER40FJEZ1LjFjACQ7tKW5/DBQdyGYaS0DElpzyF4L
         vQKA==
X-Gm-Message-State: APjAAAXWzL2Q4U5/4oecL1T7dg4HzcfmrcxJbtyrffqcxFkfucCbHTrp
        ytt8bxml1GS51qtcvBVsUtEwXl3M
X-Google-Smtp-Source: APXvYqzOhRxF+F9/X7gCWTy7L9DC9wTLIYbxLs4EKLMhbR7oP6GCrOM3+RdrhfCO0TMfBxxFTJEAFw==
X-Received: by 2002:a63:e10:: with SMTP id d16mr31908280pgl.444.1565640489637;
        Mon, 12 Aug 2019 13:08:09 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:09 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/15] crypto: caam - drop 64-bit only wr/rd_reg64()
Date:   Mon, 12 Aug 2019 13:07:31 -0700
Message-Id: <20190812200739.30389-8-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812200739.30389-1-andrew.smirnov@gmail.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since 32-bit of both wr_reg64 and rd_reg64 now use 64-bit IO helpers,
these functions should no longer be necessary. No functional change intended.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/regs.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index afdc0d1aa338..fb494d14f262 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -138,24 +138,6 @@ static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set)
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
-#ifdef CONFIG_64BIT
-static inline void wr_reg64(void __iomem *reg, u64 data)
-{
-	if (caam_little_end)
-		iowrite64(data, reg);
-	else
-		iowrite64be(data, reg);
-}
-
-static inline u64 rd_reg64(void __iomem *reg)
-{
-	if (caam_little_end)
-		return ioread64(reg);
-	else
-		return ioread64be(reg);
-}
-
-#else /* CONFIG_64BIT */
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
 	if (caam_little_end) {
@@ -187,7 +169,6 @@ static inline u64 rd_reg64(void __iomem *reg)
 		return ioread64be(reg);
 	}
 }
-#endif /* CONFIG_64BIT  */
 
 static inline u64 cpu_to_caam_dma64(dma_addr_t value)
 {
-- 
2.21.0


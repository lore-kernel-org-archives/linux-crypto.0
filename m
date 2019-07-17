Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC2BC7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D98232184B
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JR1jkVLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfGQPZZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38343 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfGQPZW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so2496388pgu.5;
        Wed, 17 Jul 2019 08:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HCmJmyzmQT4Pt6JaXDG9/uRNYLrXoyYw1jAGneb5HzY=;
        b=JR1jkVLso8NRJ8bE9A2ZTy9IUqFFHSy26v4xFjAWzvIaOmyfiX+BcgG3ixLWYTtCXN
         HIJccigvLi44dfux9wnlhvfBWWfoi5KTJT+cFAgErrpt2m/DaGNod+49MP2OmfzfcmXQ
         VbyTDDHQWaLVT+dnikZV7NFsi4DjM5YtUNOQ49i06sMxggLIkMYAC+n2gvZTzCmeu7FC
         ggnWwBieQ3Ru6gsRAHDL6FkagixNKZ9M01xZeLi8tJSFKoVYB+oCwLKTYzjt2fkEL+hK
         phMPBfNtSZR75zVJsOLUbybPIRaerd/1HHljKYYL8IKRDdzw81E2cDrp/IZIuOfGhr7L
         AjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HCmJmyzmQT4Pt6JaXDG9/uRNYLrXoyYw1jAGneb5HzY=;
        b=EKPnnoKb8r/0OPj00Vj/GsKPyoenyI8FjCGjEde4wE+Zy5DwfGKG7lIcDsNeO5P+hG
         I9+oEWTxXRqCHzFUvDPiGGGWn1+xvmrnzKfu5UU3ITnsAgSF9KktTVy3v6+nJoZ0oRtw
         LGPk0a6ZMtvbKITM9Ir/IrTlfsAA/WGwM7NpSWWScbc1INJ7MiaNWzHP000v5smYqSvC
         w/mDTkdqJ0kvD9zsc574xBxIjrqyW4HL25OrN/RerMBVmzXykxWJ/2NDDl+p9dgd8Cr7
         fhhushc3V4mPkx8qYXGQYClm5Pt1Z1UofawHMt3WPxaeS7tUXmzNeo/RjQy3CLbhLtbU
         cVsQ==
X-Gm-Message-State: APjAAAUu4V2pyVJz+b4R8Ke//H7JF6uW22IA0zqEsve71dxnVnZ3eMgz
        DwQTcuQgnz0E4q3BP/sgplNLUftQ
X-Google-Smtp-Source: APXvYqwVNLN0vlE0pKydwLWztsuBhjvf8umEX0kDBNRP2CNT+I0iS/ycn/xMc5jR5pvaQ+alF7gVQQ==
X-Received: by 2002:a63:4846:: with SMTP id x6mr4994974pgk.332.1563377121335;
        Wed, 17 Jul 2019 08:25:21 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:20 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/14] crypto: caam - use ioread64*_hi_lo in rd_reg64
Date:   Wed, 17 Jul 2019 08:24:50 -0700
Message-Id: <20190717152458.22337-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717152458.22337-1-andrew.smirnov@gmail.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Following the same transformation logic as outlined in previous commit
converting wr_reg64, convert rd_reg64 to use helpers from
<linux/io-64-nonatomic-hi-lo.h> first. No functional change intended.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/regs.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 6e8352ac0d92..afdc0d1aa338 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -172,12 +172,20 @@ static inline void wr_reg64(void __iomem *reg, u64 data)
 
 static inline u64 rd_reg64(void __iomem *reg)
 {
-	if (!caam_imx && caam_little_end)
-		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
-			(u64)rd_reg32((u32 __iomem *)(reg)));
+	if (caam_little_end) {
+		if (caam_imx) {
+			u32 low, high;
 
-	return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
-		(u64)rd_reg32((u32 __iomem *)(reg) + 1));
+			high = ioread32(reg);
+			low  = ioread32(reg + sizeof(u32));
+
+			return low + ((u64)high << 32);
+		} else {
+			return ioread64(reg);
+		}
+	} else {
+		return ioread64be(reg);
+	}
 }
 #endif /* CONFIG_64BIT  */
 
-- 
2.21.0


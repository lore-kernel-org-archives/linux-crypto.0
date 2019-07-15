Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2EFC7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA92F20665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8m4xEDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732501AbfGOUUq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44451 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732345AbfGOUT4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:19:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so8839337plr.11;
        Mon, 15 Jul 2019 13:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8M9KHyXwUEtFUyzJoarpboyeyNZ234MBzkiPCu7LgU=;
        b=M8m4xEDxFSk3AAVK7Tb8g7sErDBrr36LF612LBy/6zaglybPFpL+zx57YdNLqazxsr
         Odelmrk8QR/AlWkeEzkIhcnARFCv/Z3KtRFGkkfDpMYmVFdUz1l99um3FXCoJtHk5dn+
         lgLxFKiw998gc08YRXs4AcS160HUEYYF+a77D1p5bbGvem7Jm+34/WuEMflATKIzB+Zp
         rleCzLh0JQt5qS6Ijz6vDxhVDnG6Ay002+lxZ6sB8zKyO8bj92P4UVRmmLe0gU2Xa7qg
         hMDK7ULumjhd0sF1F5gV4khOtfxbjCr8Rgdpmt5CcYy2FrcXnq5wCUlxHAV7eDHxynUJ
         pRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8M9KHyXwUEtFUyzJoarpboyeyNZ234MBzkiPCu7LgU=;
        b=dpyaAFqUhL0mp1Lua0l/NX7V/ZLS7YmLrqOTtOpHxf6hp2ZzKUrDJMXe9SihEOsgSs
         BvXK1MP1yQzqsmEyeZpifEr7Kf6xfvzBbxxqkdt6zFMQi1LHeRAWNNudqilXD+r+fQUI
         XXyCrfSqkKdC5b5Xg5owhV2aq/hSb9yMPZ16LIFETHRd9H72/MS3X4yV0efBFVM/2gN2
         sTvGHxI6Otca6eQRwWddBIxrzPm7l4c56Nomb+gd2aSbUB8aQiln63Iznpxg8p1X646V
         VRuZoRJj57IDX38QCevVXsW7j2OksIIUQakRXxMWVINSbK86FWQVRA3bYGnTcSeXp9b8
         DXcg==
X-Gm-Message-State: APjAAAVpukUGBd6TLW2Y0VjqyRJSVWAzy+ee7/6kxSCZxky/W/iV6pn0
        BdycJ3UpxBHK7h5Ne977fhcRnMFI
X-Google-Smtp-Source: APXvYqxVLS8fmp4gV0hei+kLDX9RxMLr/CFRZrWvMkEIaI2ro8oJwirU2M5sBvBph8vw5eB3bHR5hA==
X-Received: by 2002:a17:902:aa41:: with SMTP id c1mr30171698plr.201.1563221995743;
        Mon, 15 Jul 2019 13:19:55 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:19:55 -0700 (PDT)
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
Subject: [PATCH v5 05/14] crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
Date:   Mon, 15 Jul 2019 13:19:33 -0700
Message-Id: <20190715201942.17309-6-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190715201942.17309-1-andrew.smirnov@gmail.com>
References: <20190715201942.17309-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to be able to unify 64 and 32 bit implementations of
wr_reg64, let's convert it to use helpers from
<linux/io-64-nonatomic-hi-lo.h> first. Here are the steps of the
transformation:

1. Inline wr_reg32 helpers:

	if (!caam_imx && caam_little_end) {
		if (caam_little_end) {
			iowrite32(data >> 32, (u32 __iomem *)(reg) + 1);
			iowrite32(data, (u32 __iomem *)(reg));
		} else {
			iowrite32be(data >> 32, (u32 __iomem *)(reg) + 1);
			iowrite32be(data, (u32 __iomem *)(reg));
		}
	} else {
		if (caam_little_end) {
			iowrite32(data >> 32, (u32 __iomem *)(reg));
			iowrite32(data, (u32 __iomem *)(reg) + 1);
		} else {
			iowrite32be(data >> 32, (u32 __iomem *)(reg));
			iowrite32be(data, (u32 __iomem *)(reg) + 1);
		}
	}

2. Transfrom the conditionals such that the check for
'caam_little_end' is at the top level:

	if (caam_little_end) {
		if (!caam_imx) {
			iowrite32(data >> 32, (u32 __iomem *)(reg) + 1);
			iowrite32(data, (u32 __iomem *)(reg));
		} else {
			iowrite32(data >> 32, (u32 __iomem *)(reg));
			iowrite32(data, (u32 __iomem *)(reg) + 1);
		}
	} else {
		iowrite32be(data >> 32, (u32 __iomem *)(reg));
		iowrite32be(data, (u32 __iomem *)(reg) + 1);
	}

3. Invert the check for !caam_imx:

	if (caam_little_end) {
		if (caam_imx) {
			iowrite32(data >> 32, (u32 __iomem *)(reg));
			iowrite32(data, (u32 __iomem *)(reg) + 1);
		} else {
			iowrite32(data >> 32, (u32 __iomem *)(reg) + 1);
			iowrite32(data, (u32 __iomem *)(reg));
		}
	} else {
		iowrite32be(data >> 32, (u32 __iomem *)(reg));
		iowrite32be(data, (u32 __iomem *)(reg) + 1);
	}

4. Make use of iowrite64* helpers from <linux/io-64-nonatomic-hi-lo.h>

	if (caam_little_end) {
		if (caam_imx) {
			iowrite32(data >> 32, (u32 __iomem *)(reg));
			iowrite32(data, (u32 __iomem *)(reg) + 1);
		} else {
			iowrite64(data, reg);
		}
	} else {
		iowrite64be(data, reg);
	}

No functional change intended.

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
 drivers/crypto/caam/regs.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 8591914d5c51..6e8352ac0d92 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 
 /*
  * Architecture-specific register access methods
@@ -157,12 +158,15 @@ static inline u64 rd_reg64(void __iomem *reg)
 #else /* CONFIG_64BIT */
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
-	if (!caam_imx && caam_little_end) {
-		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
-		wr_reg32((u32 __iomem *)(reg), data);
+	if (caam_little_end) {
+		if (caam_imx) {
+			iowrite32(data >> 32, (u32 __iomem *)(reg));
+			iowrite32(data, (u32 __iomem *)(reg) + 1);
+		} else {
+			iowrite64(data, reg);
+		}
 	} else {
-		wr_reg32((u32 __iomem *)(reg), data >> 32);
-		wr_reg32((u32 __iomem *)(reg) + 1, data);
+		iowrite64be(data, reg);
 	}
 }
 
-- 
2.21.0


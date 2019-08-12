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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B5EC32750
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8C41214C6
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZhQY1oc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfHLUIJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38981 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfHLUII (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so1471344pln.6;
        Mon, 12 Aug 2019 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5TiP43SIEA9K4dnH/+GiV+LFGwLrB0dXtWpopoBzfso=;
        b=VZhQY1ocNC7xoRev3ZKejslwAxrAD2VhrheyHT6pRcbOdlz1zwPCOPzcW6yImLg52c
         es15BnEW7Dhm1OkffAQF918ZEAGOy/39YI3PNlg7R2IQF/BS2zXh+GHUy0LjJgCaiPBJ
         lgWAvV8jNB5eBg5B79Y7JaFKJg29JwOnJouLFSxyEmhhc0gEJhpxdHCqBGPBlRn0zuFa
         2b38GdI97hsTprqLGyZF079X8r4WGUq4B6NMK+seRfAORonI0CQKJUDDGx16PDV7D1OY
         WBg+3LcbJI0oC95X8uZrbaUO8dtcraMGjhQYbmii0HHM1bc1nGJLiTpGZB3Kb3KLLmmd
         s3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5TiP43SIEA9K4dnH/+GiV+LFGwLrB0dXtWpopoBzfso=;
        b=FJEWIcUmlqTxKWBALQRjwTp8bsPTV5AnhSMad204kZfMV2ShhuNXG45xb33jPYP/U1
         TmSn9UIK+HO0O9JAW03VAwxhzcHU9Ue5iMdPDQIcN11LgnCtwJGagJ1uIJkudlcxG3Ha
         yxztYSkoYr1rHqojYe6Tbj93cg7sti0koEljdHWiAMGTTC6o04H6FlW72mjrJRp2xjPX
         +4EDpN1lmvNbNcJ/IGkIFwYxsFWntzionPIKou/r2smJ95yZRsR/+3GH7DFgnpHz3sSK
         vUQQbL7+VXE+WuPllwDJbOQsFFtfXV9UQoJQhG5fn8MI5scJw7yWS87B2wdgCABx6kEu
         eggA==
X-Gm-Message-State: APjAAAWjArz3WafCtbZ390ho6Sq+r/GPBcw+b1p5TOnI9B01p3Wet7cg
        f3Pe2YNxMty8qw4lygvE+0Tu0+5j
X-Google-Smtp-Source: APXvYqzz58GpN9GYcUZU0K5ME6MLIUqq3+SCjcwlHmwnDJXj5SL8MR5abFLgDb/TmflSZBNtQzwS0w==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr34806936plr.68.1565640487064;
        Mon, 12 Aug 2019 13:08:07 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:06 -0700 (PDT)
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
Subject: [PATCH v7 05/15] crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
Date:   Mon, 12 Aug 2019 13:07:29 -0700
Message-Id: <20190812200739.30389-6-andrew.smirnov@gmail.com>
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


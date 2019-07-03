Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56977C06511
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E7AB218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vUhrNbCD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfGCIOJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36809 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfGCIOH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so861620pfl.3;
        Wed, 03 Jul 2019 01:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8M9KHyXwUEtFUyzJoarpboyeyNZ234MBzkiPCu7LgU=;
        b=vUhrNbCDIvS67tnXwUfLw5GEGFQea54Ki+FXYGZ5Cn5018Oa/iCRe8dxG9Y5nw8JEB
         PFbSvFGj2v/FF19rfEYoaP9svsPxxXFGYNrFAR0cd0GtMBfAAYFEfxGeO3BRkyHlgsa6
         hodyY9kNf3/heyZxe+iAvJmxWn0xQGnKUkm0eZSEHO5UYgqaV26pYJcUlRxN8UQ0IHA0
         tx62sESoyhEgJfwaQ45iMLFs4PjWtWrYOaBoiIyE2jhk3Z5mrMCBdGPJ8HF+L/Jl7bWG
         czapO6Ix8xXPTDig6mD0fcRnyKURPfLRbPXIPmCrBW5QfwiEBfzBBixx4pP9ywpwESTO
         guQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8M9KHyXwUEtFUyzJoarpboyeyNZ234MBzkiPCu7LgU=;
        b=WlRK++25nGh9Eye3Tgi5kH2DwRT9+g4mXgEnn0YtRgHSHxeEPgnRLkd2T8NGhC04qE
         MWpallPuwZayUSakP/oo91kd6ZxKSsgnPjb2SV9e57TM62VUNM3nAN6D+qG7gz2uPA7u
         mQpDltMT8Fx+a1S2M3soIni9BPU98jE/XdH1dHoeD18lir045EzGSUPOPuFSJ0I0VSen
         EJYasPa/9p248nnoAwKPxgnaAB1TvvXgplHiL5q1mwN+3nUdFD3ybNJihH1Pv2Wi73ix
         6i25x0KdDZL+X/p0tj9O0VBv188aK694GsKzBOb6mKo7qxAZWKvRcJ+ncLQ6Kw91eqfu
         bPLQ==
X-Gm-Message-State: APjAAAU17PAcPkelG+qmkYMYYfmz9+7zYN+sHOkRazNuTkkowTqrHEVm
        hfmJqctwFlGJboV/Ml1Aw87yK1rbsog=
X-Google-Smtp-Source: APXvYqxoo0GbFdu6WkqUIO+eV+iQSsWyzK2BmStOWYbRyx1gYRnTxImOvn36tHGY8WJJB+wn769gug==
X-Received: by 2002:a63:d53:: with SMTP id 19mr36802567pgn.453.1562141646350;
        Wed, 03 Jul 2019 01:14:06 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:05 -0700 (PDT)
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
Subject: [PATCH v4 07/16] crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
Date:   Wed,  3 Jul 2019 01:13:18 -0700
Message-Id: <20190703081327.17505-8-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703081327.17505-1-andrew.smirnov@gmail.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
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


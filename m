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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1127C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA589218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZnIX9Ua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfGCIOJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38694 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfGCIOJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id z75so814471pgz.5;
        Wed, 03 Jul 2019 01:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HCmJmyzmQT4Pt6JaXDG9/uRNYLrXoyYw1jAGneb5HzY=;
        b=ZZnIX9UaZGyuDvO48xtLr/H1WO8/EBI2wEYk1XHvwBJVcjwsQGK5gkEmlb1eY8S82G
         14ZRWDzdxXdnu5CSjJV7Y6AZxCkSEwnYWPD8yJAiskPfr+iJvnlqRqgJJ3g9YOlgpv+w
         u11t3H2O517+696LChy64YGdWoNLI4WaTJ019UPrwqZsdpNXxP0NzOsWaaWGHKnOHiKj
         mwr3vuDC6Uzs/yr71SBCQKIGf/3WsJuc1pWOds9iQ1j+RwlEfKDCfuQpOp0kD1rFjfZo
         a+LIkkZpnLgXDNBQ406PqJPzuU8qSLLWcALZ8Y1WqGSxNaqgb6f+DIDiu/6UhVNfl/yS
         OIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HCmJmyzmQT4Pt6JaXDG9/uRNYLrXoyYw1jAGneb5HzY=;
        b=kqtfve1ou+5XtvV01XUsBKIJdVdltT8Tw4Vaz/42ASUu3X8NJWeWhIuF0mT2iUIsTL
         loPJrk1LJOQ6ff/85a0ziGz/EbVpUKBKK0PgyCNxlXMnkujJPmzdbLEz7rs31IMgX2Fr
         xO+REVwhZZ7nHHeZHKjbPRAYQ5dR7GYZQS3pkOJOfjZ+R4IypPp0XwnYPqvRdWQw6/cc
         +oytpBfoNldK3JK/fGcsEGRPb1qjbKwbOJ2h7IZj5Qs6aVw5igM1/AVXssLWCyDU6i6u
         Yoc5DAIoIhk+QxErbShG0OB7HYuWhqwEvM0/JKw5qCQpZGnIsuTlo3OgoWD+DZfv/bER
         zGHg==
X-Gm-Message-State: APjAAAUh8oymHqQybuUf4zIH7uKptSlF6Z6G0JjdD282OHL/1NjXM2gy
        MH+A5LrKyL9L2UiWITlZyqZ6zAHO+bQ=
X-Google-Smtp-Source: APXvYqzaR5M8wziwkPrxSec1KbxGfXyehUKrRQebI+8TmPvE84ahWfftCUUbP8FlaLVx6eF2DJFghg==
X-Received: by 2002:a63:62c3:: with SMTP id w186mr36989443pgb.64.1562141647547;
        Wed, 03 Jul 2019 01:14:07 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:06 -0700 (PDT)
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
Subject: [PATCH v4 08/16] crypto: caam - use ioread64*_hi_lo in rd_reg64
Date:   Wed,  3 Jul 2019 01:13:19 -0700
Message-Id: <20190703081327.17505-9-andrew.smirnov@gmail.com>
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


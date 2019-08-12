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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE52CC433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F700216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cfGR6Xxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfHLUIM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34036 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfHLUIJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so43812625pgc.1;
        Mon, 12 Aug 2019 13:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W3mqNlztumnj4XZjnpVKcSX85dy4Kmg7xsrPbi19fGU=;
        b=cfGR6XxvNHmo3XMtcjbqldZcf/+nOaYFAACqescotLy66IgUuclzE5aPlXuJX4jKSe
         s+JtLwAbDCtElO9RHrMGFgrw+uO94LvRfiOW+at0y3ZninXRF760xWwvf3WyZq28kgco
         BUv+clUT3XgejBeR0jc0VCxa+PkmgNwepX4c7JDG6jpT7UP46MQkjaorlemXXtz3nkXD
         TI/57XlvtNdWMkLbdeVxReWacDRmUdh4aokemC1T0eDXKO8Dv7SgHMvawLbTxe6JaIVH
         1qQCw4z0ADVTh6aAEtS7pG7rKRC9dELlnY20U1GRfpM2edRfE5maQXvKiGHQ3JJacQZD
         sImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W3mqNlztumnj4XZjnpVKcSX85dy4Kmg7xsrPbi19fGU=;
        b=Y4mkPrRIoi0AxPtnvBjIIThbrtZsVKOz6N6XKvJ9gMp7xMyUf15SsQpNgGKE3OsGrT
         jk4cm2nXYvY7F0ZjzG3nIsjJaF04GFzWiLx0qPTKM/TVrAgzZQTzNMUso/VH6tJ1KUO8
         88CMf4Je3NCCKJBeN9Y1cnczuCmeISq17Xml9Q5tQ4+9bmXOn5UOkBuaA7qUjBbwkXCf
         Ldn7ek1c8XPdYvYXqAjFR0P0ik9mz4IirGiDhZLXUHI6u75UoK+G8UPPTHzPgGwA30iK
         wy1J1vlCcWz3MKhvgjpm9/W0CXQLwil7aFz1WItp8BzePJ5CMg1eg+/C2Yk/bPaabtO3
         QxMA==
X-Gm-Message-State: APjAAAVNpU4iP8OgIB0jQJt3+I4LeGt80csQ/0onJ50n0kYJ1Z7s5sf1
        KsKwpObv7Do4gzrYQweIFCFKENiF
X-Google-Smtp-Source: APXvYqzozM4srkHF8bJu/MzZqJ+Apnzs8T8Au4a3m225ce5KDLYy6W6sEWP/FCJJhqcUlfWJDH7oKQ==
X-Received: by 2002:a17:90a:b394:: with SMTP id e20mr950774pjr.76.1565640488411;
        Mon, 12 Aug 2019 13:08:08 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:07 -0700 (PDT)
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
Subject: [PATCH v7 06/15] crypto: caam - use ioread64*_hi_lo in rd_reg64
Date:   Mon, 12 Aug 2019 13:07:30 -0700
Message-Id: <20190812200739.30389-7-andrew.smirnov@gmail.com>
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

Following the same transformation logic as outlined in previous commit
converting wr_reg64, convert rd_reg64 to use helpers from
<linux/io-64-nonatomic-hi-lo.h> first. No functional change intended.

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


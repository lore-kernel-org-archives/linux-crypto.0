Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF421C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F3E22DA9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AqZzDjvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbfHTUY1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34043 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730929AbfHTUY0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:26 -0400
Received: by mail-pl1-f195.google.com with SMTP id d3so48806plr.1;
        Tue, 20 Aug 2019 13:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nvcXGylpEJ03AdKQBKJNe9ip5rhRTq0M4+aMVlClgNo=;
        b=AqZzDjvUK1nexZhEW0xf4cFaGuBrB0bcL7JpjqNe52hQ85OabAapsHcukmvTkuCiQx
         h6E/x09DypawQHN4rJUMw0Z7z0aJ8JecstYB3Jq62Wc7WbHBMr7hnDChXKLan9Rx0oJT
         A3TCHpLlf9k8S9jsA5wOjma6B+E/Luq8beMWFR6nQOxP/hSeLqUBSf6mC+7lHLuIjtmY
         1FoHUwFEoPTF/C+d6kFXFsHnK772/aJx2SISR/BStjGBTFq4uEFAkSYX94dWLwt0rEBf
         iodIp5nliY0a+NGvd/xQ/FjPDLtsmZs8pGDfd9yyt9xFzFT/ZYgME6ZED+0qXt0YN0gt
         kFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nvcXGylpEJ03AdKQBKJNe9ip5rhRTq0M4+aMVlClgNo=;
        b=P0FM00dXCC61WL9HCuUszdbVip4/4WhBkc6tV4hiIJYe1D3roT/pWfLqQvnyrtaCo0
         7cvsqDPrsuE9yuvopzx2r+sFgVEBmDnUIANIkJffOy4wViAhhjeMFna3zmx8rF0KSjou
         rFb1xsMPJxRh7XLmerqdM+37G8IyOSyLjUulOeJuleUV/4mZepFiwRKswc10JL0zXmvt
         C+hgcW+eDd4CCS6fnl+hpfxTfCigryxlc+XmOqveP4J1wSdzG2zRlL6lEPEoldC+Ugx6
         u56GtexMk2CShc05DWQktBqByg4TOuuMpiiqXbQvcNYzQZkiJXwEl7vcinOcjMFHDWsP
         UHqw==
X-Gm-Message-State: APjAAAUGZT09X5Dce6M9cgOFmdz4RhDUjEf9udv9xIbkjUBtWXrt1HZA
        ONgrCqTyktaESS9oQ3aqrqF3Kakrmk8=
X-Google-Smtp-Source: APXvYqyftSXJwneehg33qFaQuEkHn/TzpKbrhQyxpMsfdLiLtRWCKifzUIIpevn9PkJosF1YeFl80w==
X-Received: by 2002:a17:902:6bc7:: with SMTP id m7mr30626039plt.60.1566332665142;
        Tue, 20 Aug 2019 13:24:25 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:24 -0700 (PDT)
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
Subject: [PATCH v8 05/16] crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
Date:   Tue, 20 Aug 2019 13:23:51 -0700
Message-Id: <20190820202402.24951-6-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
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
index 7c7ea8af6a48..6acfef30a90c 100644
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


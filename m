Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5460FC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2739E22DA9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vOzP+q0q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfHTU0A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:26:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40631 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730871AbfHTUY1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id h3so34714pls.7;
        Tue, 20 Aug 2019 13:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A6ercEpYWl8IkvOJaITxdGFgQIowCjFQxBcnpKPLscw=;
        b=vOzP+q0q+Oa6BZHJxhBaH7qaUU8zblJDo2ySy2oPY3e95wWQKZfWWhF+QMBjWlj41e
         rZmNg+sELolTQBlHws7u5zQ9XayMJNdtmAnrRzf5KvaJdz8kDMUmtvrz4//7ZZBKezPu
         W7bIFnOMLCd1YOqtjyQBfx5p+9LA0JpwIs7PN50elsXw0MYhbNR52kItaadpcLDTOziG
         hiFXips7Et1RniJ9MDPVR7D+53W6+lE5aLW17BkrFx2L0w3rW0nZ4RE/znHruRDFY+lA
         tTPC8cHPIPQbZq2+xpdMVyGdBP2XYqvoUZdAGucJlBx41FjWQfLgu9oueuR/8zq4PnB3
         B57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A6ercEpYWl8IkvOJaITxdGFgQIowCjFQxBcnpKPLscw=;
        b=ekoQPi6+tkE5C7zLJpjV+1Ya4E41CkfmUFcjpIo/eetdbX08Ox1mm12a85Z3DvfQ7b
         Lzdkcl/dos/8+kALXMPRnX6pghsQSzlmLbHmP+ae7jX/rkbKG/fEqBvZtA6eS9LoQ16l
         wqEhn/Bvzn093PAdRRtxf5w7rxIJbnyZ3LBIGsWATJEUqgVA+Olm7gyDMvmqo5TH1yWJ
         WCqL/7d6Ln+UhRbKDqtaXgsySBva6WNYOgQQYw5HZ4QJ8v3ENxDxPZLJ/yEeTCfWyhly
         lBrjCq+uTI/wUKu0FCHCcipCzt5zUf3n+zI6jk9gnyeYw4Mdsb3W5T54JzEBElLFifr+
         08jg==
X-Gm-Message-State: APjAAAUH8EuClau7Rp+E4XsD4arf+EA5l8gD9R5kGsCTIOr79/mma4rx
        aks6qQulLyyC+9h82j2quIKq9k/zaKA=
X-Google-Smtp-Source: APXvYqxv2bDHNx5ZiDMOE0rSaCv6Tpib1la424tkvTo1t1wSbfhE+ZaC4G9AAOVyOQbNin2Ykx+fUg==
X-Received: by 2002:a17:902:306:: with SMTP id 6mr30104564pld.86.1566332666385;
        Tue, 20 Aug 2019 13:24:26 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:25 -0700 (PDT)
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
Subject: [PATCH v8 06/16] crypto: caam - use ioread64*_hi_lo in rd_reg64
Date:   Tue, 20 Aug 2019 13:23:52 -0700
Message-Id: <20190820202402.24951-7-andrew.smirnov@gmail.com>
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
index 6acfef30a90c..4efc10534873 100644
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


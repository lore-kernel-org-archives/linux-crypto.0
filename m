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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E680BC76196
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA61A20C01
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ww0C+505"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbfGOUUD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:03 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39188 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732433AbfGOUUC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:20:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id f17so3958845pfn.6;
        Mon, 15 Jul 2019 13:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BNJCQUNcof8kUIy33ye35eh+3AWm1VC+G5oQzkM3XSE=;
        b=Ww0C+505X6n3XgMvUlrWf6u0PaU62GuD+U5FMuCONhBOeQAcCP9eRV3gfwVo+b6qhk
         OqVjFT2l/qgSbnt/o4MH+9MTg7TvymdF3Vj3PnF8d4wGcz3n8QNVNTMQ1z613PbyKkMz
         l3r3FWXSwEDq1FwSBa6djhcAQuaPTKjT2OQEkWVkLzVxhCCPFyeismwZVfJuQLw09CY5
         CkEHT0roLGDNfD5YCCjbjGns5RWI1D8y6zqfHBOJJhBW07cEGZrSGIK7LunHhHbgWdwA
         YPGrpbJjNXlKKCFnHinIOKTbIXLzK9FFhrfoXykGUWGBtLYothgAvfBJjHg2NovtyWVU
         gv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BNJCQUNcof8kUIy33ye35eh+3AWm1VC+G5oQzkM3XSE=;
        b=GjlNFYjwCuZQcbIplKHakkeQ/5yIjMZAVpxB5Gh2afSmyBaANSqQKR8nt2jfMZ/5Tb
         j+pBNsTuFrlurQBNacdoOzTz8ssLqgCxNhB4ZDRjZh6I2TZjHoXh5avtnbCXIpl4fKw0
         7TLZoSIwzukQ+oKYeWqvHQ/XothwgQLUqPghXcrfteGZ4rVJQtF4fgRu/9qPXtmhKyvC
         N4MtZrp2JKlCZdlJCMRASt24EgtBgr3JSw71aIItvbVzRXE204STtPfYjbkUj1DetxvR
         Re0HxBpGGnDrOZBjs1tGk1yLiZZsvUN5QzBmakTu5YyAYcJ8FpldY8p9XFGoM5o2twRz
         NtqA==
X-Gm-Message-State: APjAAAVTQNs8CIWWz0kvf5bts1wxvsDIng+t9r2oo8SkMXU6drTUW3+K
        VR/0Po6PHg3jUlaNsvwXpxhtLbBx
X-Google-Smtp-Source: APXvYqxwfZBozuoIG0wO3hu6LnBKbUBELfmsWKETncHYMl7rfVA5xkGyab1ktpvHUA+D+FbPZr1tLQ==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr29266075pgm.40.1563222001189;
        Mon, 15 Jul 2019 13:20:01 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:20:00 -0700 (PDT)
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
Subject: [PATCH v5 09/14] crypto: caam - move cpu_to_caam_dma() selection to runtime
Date:   Mon, 15 Jul 2019 13:19:37 -0700
Message-Id: <20190715201942.17309-10-andrew.smirnov@gmail.com>
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

Instead of selecting the implementation of
cpu_to_caam_dma()/caam_dma_to_cpu() at build time using the
preprocessor, convert the code to do that at run-time using IS_ENABLED
macro. This is needed to add support for i.MX8MQ. No functional change
intended.

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
 drivers/crypto/caam/regs.h | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index fb494d14f262..511e28ba740a 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -188,13 +188,21 @@ static inline u64 caam_dma64_to_cpu(u64 value)
 	return caam64_to_cpu(value);
 }
 
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-#define cpu_to_caam_dma(value) cpu_to_caam_dma64(value)
-#define caam_dma_to_cpu(value) caam_dma64_to_cpu(value)
-#else
-#define cpu_to_caam_dma(value) cpu_to_caam32(value)
-#define caam_dma_to_cpu(value) caam32_to_cpu(value)
-#endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT */
+static inline u64 cpu_to_caam_dma(u64 value)
+{
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+		return cpu_to_caam_dma64(value);
+	else
+		return cpu_to_caam32(value);
+}
+
+static inline u64 caam_dma_to_cpu(u64 value)
+{
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+		return caam_dma64_to_cpu(value);
+	else
+		return caam32_to_cpu(value);
+}
 
 /*
  * jr_outentry
-- 
2.21.0


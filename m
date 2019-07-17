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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987C5C76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73E0B2184B
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nsGDSXEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfGQPZY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36473 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbfGQPZX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so12161176plt.3;
        Wed, 17 Jul 2019 08:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMpnTuEF4VNlabdEsAMZ4XSxyFLWi8ZClVXNYx4KkpU=;
        b=nsGDSXEQJOeCJM/8pw4r9Dtb98/OyeFnPohIiaaWq1NeGtdIDWCnfgUbxLI1WbEFw8
         B++RYU+FMYARjbqfqcbeb0eqOP37BGC13dAsGuQzJeAwfeDozjmYfBQ2g/v/5MJHaY6M
         4B9vKnG5nPSeRrqq73ltlER1FHZxfMzxhtqxtt/unkGWQFo8NVXgL9N3YZUwu8XbU1mh
         f63VRD6V8woUCykfLvPaER5lofMWh4TmGxMSBRRl8z9zdiesuLAarUvH5LpbkIpF6E3n
         kUTowwYXiz51JY1lyobwySBvTPlYHcZylSfvz7LQOVR13+Gu6l/Aok3A7Amzp6xe1dIG
         vuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMpnTuEF4VNlabdEsAMZ4XSxyFLWi8ZClVXNYx4KkpU=;
        b=XrJaCZ5xAwTY7v3qon4UmpYIn4MjrNWE3WbrjNQFrfBAS3PJvrT0oCAZPf/pYWjypu
         TWTICSf6pzMuFLIHMU9lCg0RJwpKFWt/FGfhAaQcifF1fx/zeKl355hXNMZocD7LXoLK
         qNwW9WQJnLTastA4pZzb30Ul0pXET3fzOd+ucCoNxPt5wOTZaXU7PeVGCsLlc6oPdOiW
         qu6kY4bDb57dVydFui9JZkbi2IkrJz8xSXoxHMqoYUOXFuj3Cq9+Ell7zBjOYCPOQmnf
         X2bHBk5YFtQhQ+m+JMFc9I3RdYT/bleXuuykTeBmlx4BdsiEsPDh3Y9JCbtYJTPUQmQM
         Tngg==
X-Gm-Message-State: APjAAAUJApBy+Hc3T9r4xQsRB1S3V/GU791LXqjMkMQ2pNj9EMKz7C+Y
        ZHD2PSu7xCSId8ohnYUijhVvYo2e
X-Google-Smtp-Source: APXvYqwEoz0XasCQAmLnAL/BoToeZJXs8wSDhCdTyLULfJN5qT3bTFX67nT6pD9nyIsnNJchT6eNdA==
X-Received: by 2002:a17:902:112a:: with SMTP id d39mr44357906pla.254.1563377122815;
        Wed, 17 Jul 2019 08:25:22 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:22 -0700 (PDT)
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
Subject: [PATCH v6 07/14] crypto: caam - drop 64-bit only wr/rd_reg64()
Date:   Wed, 17 Jul 2019 08:24:51 -0700
Message-Id: <20190717152458.22337-8-andrew.smirnov@gmail.com>
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

Since 32-bit of both wr_reg64 and rd_reg64 now use 64-bit IO helpers,
these functions should no longer be necessary. No functional change intended.

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


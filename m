Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B54C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DEB720665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYnrXgND"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732906AbfGOUUe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44453 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732579AbfGOUT7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:19:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so8839384plr.11;
        Mon, 15 Jul 2019 13:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMpnTuEF4VNlabdEsAMZ4XSxyFLWi8ZClVXNYx4KkpU=;
        b=nYnrXgNDJRzJvvudON5spq8E5oh3ibpAXyesmbha1xhT6KkuSgFXF3/lBz3gCl9HH+
         9JOOGqMqBhSTUvfcAmkmtBHk6JAAPPxB/rLsiJi7jzBNONfBXBspe7f1l12Zpiq4f0a+
         +kxRO3qHkoTSxyQ/a0nuXrI6Z7eG5OF5vF4HoXpeeNrmIynLi11LgL3B8y/T83NrZrbU
         kZwy7ZZzRT+kDsZnyPlbCx7lD7p9/pYPgexKzgmXHPD4AjSjbVxUlpncTe09TIdRkEMN
         075reux+keO0U0IBkEU+q/X2+yvkOLvRDSpmbc7gZqls0nBIDe96edvW47jchbpT/9HZ
         Xx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMpnTuEF4VNlabdEsAMZ4XSxyFLWi8ZClVXNYx4KkpU=;
        b=M/oRe6f74vrjBC+zr80DHjTB1m1GbSe3ocZROR37K3RPVFhUzPCRB0e2CE6Lsj1Ary
         OrRO+RSVUUQJD0W61Qfbj5ef9qAfiYXDPOyxu8L/OdZZuKmyLgF1i81SqTOKNjEiaRRU
         zFPqBICVvN11JdonR97hNEqPXZ/Meit3NB397b683X+craLxQ+8hRxghR2PWLa1HckRS
         L8GiZd1S42BheLHm03/NxX4NJKCC3xWQekNTYUGvRw8iVyyGYiW+OqQymwXt33Ar/jhF
         oDN7RSHSCODEAWABNwwlLKk/y0LY+ts56whySNzQu9BNWQvKVp40TFRgIbNvCjOZSFoc
         77EA==
X-Gm-Message-State: APjAAAWd8LOsby8M1MIMb6/ikZ5KI1DmCn9ny5YD3EB0qTJwDXq+gV4y
        U2/D0WBag4VyQA4YaWnRnAAg12kT
X-Google-Smtp-Source: APXvYqypby16eKXvH/qaLMf1LUL7itrmuQKnNqxwXcPFbsdNMJa0QDpZvb3toJOTbqQuQr+tXdPhyw==
X-Received: by 2002:a17:902:4aa3:: with SMTP id x32mr29148400pld.119.1563221998397;
        Mon, 15 Jul 2019 13:19:58 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:19:57 -0700 (PDT)
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
Subject: [PATCH v5 07/14] crypto: caam - drop 64-bit only wr/rd_reg64()
Date:   Mon, 15 Jul 2019 13:19:35 -0700
Message-Id: <20190715201942.17309-8-andrew.smirnov@gmail.com>
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


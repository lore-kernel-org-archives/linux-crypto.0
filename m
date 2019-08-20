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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE8FC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A7122DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2j97Yov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfHTUYa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37498 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730945AbfHTUY2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so3854903pgp.4;
        Tue, 20 Aug 2019 13:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5lDnd8eVvfq+kCvLcv1hClJ0+Pl3iOhVfhCY8P+8Co=;
        b=b2j97YovLIHp5xxOdugL7nr3uSzmUNhxWA3K/ajdWSRMqJlOND2Hiy09Uq+IcRNrNo
         r+kA7q69WTT2p4myq66y+dBQ9/UMvnSRQ/dG3GuZUl5b0mxgVbrbB9Py9VD/PXeYIPAv
         mIMqForviqqPvQtzDBVlESERyI2H74bysVZrnzrqJdpJbQEmzR2ypKzR3VtxLhXVYDSn
         LeKDlpNqLcEzkkyE8fGodZeJUqIdFIV0dR1/DeMOKdiAOigiWKwH27VH35rUq+Chq5E/
         aQ5bV9UMw4PnYycqea+xSyd2KIu1XKm7UTwNMS2h5A+XdnUcvYsaLtgG7pQsrr9DtjU+
         rQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5lDnd8eVvfq+kCvLcv1hClJ0+Pl3iOhVfhCY8P+8Co=;
        b=jAu7IPjL3rybSQSYT+ZkeLbG5Lg7aeKZMofqLmXWEB2D0kwoigispjcs60XirvBd2z
         XFnVrXg2o92/Oi7gyCcHxr7d0p2nO0r98Pf7PIDtTKw6AfuFR578yXlBya0Ri6P6hJ1f
         DyDNFq46gma/lYZI7QtIDx/PZptfASngzqCx0i/wH78nBOlRqRJh/zX7gXVbq6Vqr4RD
         CPXiDgAsHfJULxDl/jFji2CCd0SEhju5cbqZSWBfEY05jzXOT3QJzGKq/LMB/LHssZIb
         jwKuNRrT0eZGoUIlQMgtdQUjhft23v/o2hyE3flWAN3rUpEWvjHBpQXULnkPaEOZRZ1F
         KLQQ==
X-Gm-Message-State: APjAAAX7dZS5HAJ9TC+DTDPRl3r+cr98L+MVjcrOVpwKl4iiQceiuBdI
        oJA+5rFhVJfSKueQsnDZ7cMu0HitEug=
X-Google-Smtp-Source: APXvYqyx/FGXC5cukzWgJfw79w47kkpkESOi82nAP1ZIFqMDXLcy0s/ZmGJ91Yg7dNdMzX0kl5usgA==
X-Received: by 2002:a63:e5a:: with SMTP id 26mr25375895pgo.3.1566332667476;
        Tue, 20 Aug 2019 13:24:27 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:26 -0700 (PDT)
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
Subject: [PATCH v8 07/16] crypto: caam - drop 64-bit only wr/rd_reg64()
Date:   Tue, 20 Aug 2019 13:23:53 -0700
Message-Id: <20190820202402.24951-8-andrew.smirnov@gmail.com>
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

Since 32-bit of both wr_reg64 and rd_reg64 now use 64-bit IO helpers,
these functions should no longer be necessary. No functional change intended.

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
 drivers/crypto/caam/regs.h | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 4efc10534873..489d6c1eec7d 100644
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


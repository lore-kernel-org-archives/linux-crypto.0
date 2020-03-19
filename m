Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F02FC43333
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A3782072D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3B5QqLX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgCSQNK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:13:10 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38421 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbgCSQNJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:13:09 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so1207822pje.3;
        Thu, 19 Mar 2020 09:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kfpZWrpoE5n8JP08S8IQsd4cy/AH7i9JnMmCEqutX0=;
        b=P3B5QqLXebRm6VnJ7V9T21cEDSKTnd4Jszq9baxYeUuLPwDO7totY4if9QLMcf6xx7
         w5QR0G97QALXwB8I0ua4NGukw8jYqtgZr2dZCm7K9JfA3RzY+MxpGIy3GJQqJTfQ21Vg
         FwK0z0QAPM1zhNTQgudWe2EDh0xKOPBk1wNwlsEPPxXdbDIQ0+gu85UGMEQOGit9EuZC
         kI42Ctjeef6RAl35BWy7eqLk/ZDNedpGl9chmBMa0w4eltnqze+732FtvO0Vah6tSbCJ
         py66Wm4WQ1D5IzX8H3LL4B5py+WQTx9+9661y7ReJ+hNlSRxK3ywecijZok5LXeTm2kG
         6Q/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kfpZWrpoE5n8JP08S8IQsd4cy/AH7i9JnMmCEqutX0=;
        b=eehltxPpXh9VBX0+inrDLsNCTOI71w2M6lpE2URAigb/aiQP35JiNUrWOqa7ogeTSb
         sa47302YW+wczElQQII9H5UafS8VueHi9ofk2vMUzUVcfFsH4zu4QtHO4Fm31QuDF6Zb
         Ep0ZRK+4Q+1NpywR3JVVCLoWxrn9QeuHYPLz5I4uTUUFtq9jjwu0sCCALBLAo1CPviCt
         KNnhO6oWOr7wq01llki6ATdMrSSA0Gz9vLMtjUrDQmczNnQWQHjJuldQ5v4JabQrxTFi
         jUOAQKljx1cy8GjQkHCu0viJcbnpF37LVKmrhxbYdlxPMT1s8rcpCJ1+Z5zRdiW20PQe
         383g==
X-Gm-Message-State: ANhLgQ0Y6XFGRQ8BkvKAbrCoAMUhseixh3uVriXdxhTO+Hx7UmjBSHoc
        EqsXEGP/7dy6jm2k/+3MwOwOQXSX
X-Google-Smtp-Source: ADFU+vs6We0xR4u61oB9/3aiLec1Vp14Sb8ago2i2uFdnwkXTysZJAniiv/qooKI9tvwtkbuaXZKrg==
X-Received: by 2002:a17:902:a70b:: with SMTP id w11mr4290751plq.59.1584634387494;
        Thu, 19 Mar 2020 09:13:07 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:13:06 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 6/9] crypto: caam - invalidate entropy register during RNG initialization
Date:   Thu, 19 Mar 2020 09:12:30 -0700
Message-Id: <20200319161233.8134-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200319161233.8134-1-andrew.smirnov@gmail.com>
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to make sure that we always use non-stale entropy data, change
the code to invalidate entropy register during RNG initialization.

Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
[andrew.smirnov@gmail.com ported to upstream kernel, rewrote commit msg]
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/ctrl.c | 11 ++++++++---
 drivers/crypto/caam/regs.h |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 7f7f2960b0cc..b278471f4013 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -341,8 +341,12 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
 	r4tst = &ctrl->r4tst[0];
 
-	/* put RNG4 into program mode */
-	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM);
+	/*
+	 * Setting both RTMCTL:PRGM and RTMCTL:TRNG_ACC causes TRNG to
+	 * properly invalidate the entropy in the entropy register and
+	 * force re-generation.
+	 */
+	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM | RTMCTL_ACC);
 
 	/*
 	 * Performance-wise, it does not make sense to
@@ -372,7 +376,8 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 	 * select raw sampling in both entropy shifter
 	 * and statistical checker; ; put RNG4 into run mode
 	 */
-	clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM, RTMCTL_SAMP_MODE_RAW_ES_SC);
+	clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM | RTMCTL_ACC,
+		      RTMCTL_SAMP_MODE_RAW_ES_SC);
 }
 
 static int caam_get_era_from_hw(struct caam_ctrl __iomem *ctrl)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 05127b70527d..c191e8fd0fa7 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -487,7 +487,8 @@ struct rngtst {
 
 /* RNG4 TRNG test registers */
 struct rng4tst {
-#define RTMCTL_PRGM	0x00010000	/* 1 -> program mode, 0 -> run mode */
+#define RTMCTL_ACC  BIT(5)  /* TRNG access mode */
+#define RTMCTL_PRGM BIT(16) /* 1 -> program mode, 0 -> run mode */
 #define RTMCTL_SAMP_MODE_VON_NEUMANN_ES_SC	0 /* use von Neumann data in
 						     both entropy shifter and
 						     statistical checker */
-- 
2.21.0


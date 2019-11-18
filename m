Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F714C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460F32192D
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dae4jeld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfKRPjI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:39:08 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43301 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfKRPjI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 10:39:08 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so10552586pfb.10;
        Mon, 18 Nov 2019 07:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5auEHawVnFdIZOUx2eKKQZZ0ecTFrj9LceutMYE+Ee4=;
        b=Dae4jelduY/7mwP6L9S5eC7kyvEr5yRcUEq3yVpaa0nLbbb8ucUOaKEfVIb7a6PXA8
         yY+H4e5SJBvltckLJjiBwUqNsFjPURSX74GtvH3gN5Mf2RYCHE1DK4HnszcMpG275/yC
         1J7TQBqT+ISmV9BFiXID6l7dlKot+lHWfzXTIW4fP8OzcDVrhNM4NdssWJfQTVcyfni3
         CWXqWHXWsr+I6XtE4gxNuCsZezC3UBj9mF+WRQkI02tugsoqAzAkUj639Ij/IvjS4R1c
         2aA7TeAV6nRin8hlXviXP9vOsL+2rg4kFOQDDWqlkfyjIoWTb1tZtKLSQKLtNlaGtmDm
         SpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5auEHawVnFdIZOUx2eKKQZZ0ecTFrj9LceutMYE+Ee4=;
        b=aRY8b4NBW9Fa1aahCFSn+Vh+0xeTDUpezfulqR4rj/2nA2JV0XW9oXjM9rNUjxY/mr
         UvIAdqtn1wRp+3C42pze4Hi/HaN/c0DPQf4o5d1xTT+9MjS6h9oMDeQWSm5HLuYcjHr9
         51c36tTVX9eZJZk0XkB2W2eTRuUSgOvSHTo6W+X+aKCKWxE75Nii/VFuZcO4hnwF6oup
         0d2S44WGvdtb+FwqLsDpV2Rh/LyTnHg7bgIFwTqxnVr+RVi3dn+kwj2P6x1lUXq4jjh9
         zkE+dqaord+S1oovvNSUA4imNokna/dS4aDJFCJV7JiJJjkW3bHHndYp35jtD2LVoxxT
         WJoA==
X-Gm-Message-State: APjAAAVTdNxY0EdvVRviizQxGDoAabMiRbBA+BOiEJVXo29V+Q0e4xqn
        7spH+QAQmbrh/hZh5WFSkYi3MuZs
X-Google-Smtp-Source: APXvYqyLMc9147zNSg9VNfa4KVv1O59d8dqRFpucn5Gm7q35ZdFFkmPYnt132kFIYcfq1AVfiYKuFQ==
X-Received: by 2002:a65:5c8b:: with SMTP id a11mr33789990pgt.60.1574091546704;
        Mon, 18 Nov 2019 07:39:06 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id z7sm23573732pfr.165.2019.11.18.07.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 07:39:05 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v2 1/6] crypto: caam - RNG4 TRNG errata
Date:   Mon, 18 Nov 2019 07:38:38 -0800
Message-Id: <20191118153843.28136-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118153843.28136-1-andrew.smirnov@gmail.com>
References: <20191118153843.28136-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The TRNG as used in RNG4, used in CAAM has a documentation issue. The
effect is that it is possible that the entropy used to instantiate the
DRBG may be old entropy, rather than newly generated entropy. There is
proper programming guidance, but it is not in the documentation.

Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
[andrew.smirnov@gmail.com ported to upstream kernel]
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
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
index d7c3c3805693..df4db10e9fca 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -338,8 +338,12 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
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
@@ -369,7 +373,8 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
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


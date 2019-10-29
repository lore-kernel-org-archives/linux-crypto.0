Return-Path: <SRS0=WkI6=YW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FDFCA9EAE
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 16:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 471E520874
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Oct 2019 16:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfQf5upi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbfJ2Q3p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Oct 2019 12:29:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43805 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389940AbfJ2Q3l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Oct 2019 12:29:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id 3so9934593pfb.10;
        Tue, 29 Oct 2019 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FKr4vKOhEd9l/2xWZu8GBMAETT1mfl4IFe4iSbG1JbU=;
        b=VfQf5upiIF8v62IPwJs7chboED9+F+smukuu3sgZEi888rAcTXqDSa9k4hXBwNfa4L
         wfPj7zCnn+GWZPp8FTB2Ypygj3+7hLacWDhNhItaHkkyC1IYNs7BfeRjIRZjoRMK7uSo
         ZItghijFezBszxjx/m+tij/0wTD3SUbodmOq9FWrZ/NJqi/jTgByP9stBNkoFLJAL37U
         PTXqdWfcvAbpF0v+01Cq2n1OMSSMg2clT4c9irJZMNkb33vAZAlC5j2TI6uyn5vHqzbj
         vAqxjgg6gb4f4SoaZvLGTbzFl3nxWjG+s0mOBqXIaJ4/pGup2E1xdoFvo803fjR0uvZS
         TYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FKr4vKOhEd9l/2xWZu8GBMAETT1mfl4IFe4iSbG1JbU=;
        b=cfbTy1Dpjm6a+PHUDAg5OWzofuTcxLp2u7VfC+fKog3D9I4wLuRpjuplA0a0Or/opJ
         MH1T//eTthHI7oA37a3dOTsYPRGQx9N56QRW6iMlHqymi0xqUBH+A2VZ1lw6WWuoGMPn
         EfPbuW0TCbuJE+Mn97mefbq0Vv/VsE+gmavmv2jVS3fAQ8vNpAO00d465UGB8ZHmjlAh
         f60CwGXHy58MQPj8A91PCKNCpsM8zrMCadyqr588Gtv5coRS+gEZg+eetQEWqapWfCGt
         Dno+eEt2KCAXPV2mqzEBd4Vfb5SM7mpE7lsaXCvptd092KNxY99WspPK+BoUUFl5SJdq
         iHmQ==
X-Gm-Message-State: APjAAAWdXWXu5dZ0RK4OI27cQaVZPpOlie4pnkapK0FBKxScLDvEFAIw
        aX2/Uaxbo02KvRu6LeuILT7qCjW/
X-Google-Smtp-Source: APXvYqwDuTjyXTKBXc1bvJ+pFFNzy7k1K1ngnda1M4eNxfCE5BG2MF7M0rn5GwWDr8Bb/wXA3nDaxQ==
X-Received: by 2002:a63:cf4a:: with SMTP id b10mr26880211pgj.86.1572366580610;
        Tue, 29 Oct 2019 09:29:40 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id q184sm15438830pfc.111.2019.10.29.09.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:29:39 -0700 (PDT)
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
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: caam - RNG4 TRNG errata
Date:   Tue, 29 Oct 2019 09:29:14 -0700
Message-Id: <20191029162916.26579-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029162916.26579-1-andrew.smirnov@gmail.com>
References: <20191029162916.26579-1-andrew.smirnov@gmail.com>
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


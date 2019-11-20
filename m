Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBB7C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 138212071F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="poqcC4J/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbfKTQy4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:54:56 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34555 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731995AbfKTQy4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:54:56 -0500
Received: by mail-pl1-f195.google.com with SMTP id h13so49026plr.1;
        Wed, 20 Nov 2019 08:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5auEHawVnFdIZOUx2eKKQZZ0ecTFrj9LceutMYE+Ee4=;
        b=poqcC4J/rpivSH3vU30rSgLqMY7OWmyeO12g96GrL3ytw35YI7Zj8V+m7s9on+seQx
         tEWhr8HjXrYaCFMJyiKLz8TAxfNBceFm3isAkU7P+OeZDuTgNm6F8puVpleB3qGXKks9
         0DAvLIKZEWglZbU8Mn0X6wuBBy87AbxXaosM85Z0mB24sB943bLT/yX7JmIc9uroUmXZ
         EqUCiOGbi1MT73qjInbHWlGfdljiKVbqQDcwmaDqzI6uKMGURxq5N/7q7M0zFzv+LhGV
         yhOx/U0ho6c5wMN9tUkJ592XPOczG9y3aGcmpCcdW2V5I0/Sp+CUilvV44X6u2GdSh8p
         8jEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5auEHawVnFdIZOUx2eKKQZZ0ecTFrj9LceutMYE+Ee4=;
        b=FRaXP2mh/0HaX21ZgaJ609w0s7y6Fdm73WKK2LWB9t8Pvl+fSjXT/VjZwwl+AQhNDc
         M1LoWMtlDX5hrpk9s/Jt0Yuq0n9+jQDbJZncUfKPJTfv2OUIgwjrA4BntG/HqTWi9SWe
         qmKPAEQDTQiK4R8X9ulTndhIHMqo5wYoLKLz97EaFUQrAHnxFC3nIP0xyTGK6MtLzJow
         SKARcavtG67+9yPwuAepdwZvMwV4ESsx0x1Cgl7DGAu4RR0IYfuI0MaxOvjKB+mdhkC0
         iMz8flA+QCmnMMwjjUK8lk5aMwFghHylQNXDjTjSWKQrJw/PXEc6LoxQg0o5p88Oklc4
         qdYw==
X-Gm-Message-State: APjAAAW0wWGhAbavEzG7WOByfaJ4Z7kTXHIxQsfH3ToLQd8oL6oUkaQ7
        k80IEei4jqJK3CI88WySRjtmYGmL
X-Google-Smtp-Source: APXvYqzFo53W/cng2MNrmm0ns7AwFrB8539jAQNUjJmdgLAj+ByDTJl2GTXAsfrHL7MeCCV+HV33qg==
X-Received: by 2002:a17:902:bf0c:: with SMTP id bi12mr3696587plb.98.1574268895035;
        Wed, 20 Nov 2019 08:54:55 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e11sm29841483pff.104.2019.11.20.08.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 08:54:53 -0800 (PST)
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
Subject: [PATCH v3 1/6] crypto: caam - RNG4 TRNG errata
Date:   Wed, 20 Nov 2019 08:53:36 -0800
Message-Id: <20191120165341.32669-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191120165341.32669-1-andrew.smirnov@gmail.com>
References: <20191120165341.32669-1-andrew.smirnov@gmail.com>
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


Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8443CC432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B070206EC
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 16:24:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+Fvu++w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLCQYR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:24:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44127 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLCQYR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 11:24:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id az9so1875504plb.11;
        Tue, 03 Dec 2019 08:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wle6ftF3vYNvjHLW0AC3BqyDRZsOSFp+4C26kE+oXNI=;
        b=f+Fvu++wmpRb0OtIKu4TzxwMLkmSILc1DiDSdgGDk48Ot4XGTYCXafU7MfCcH0Vy/N
         DVyj0k2o4vNaLWbWgrvAZwlZpMFNcv15ruC8dv5aKo6NTtKFSH6KXYhjPYY5Qw3CMFLh
         Uo82AJ6xqFNOQMWz5rKtKE21d6014fipPIgrBsJYik+VzKEKckAG8sKx487h2KeUphYE
         0snEjYDNK4DbCVIDjUuXKa6vyCg9XT+dgqHHWPE0nai9blD4I+7OSil5mEopoEPCDbxy
         OqXI7377J8F+Bs38y4FJ0veYcWKLCRglzfY7GHT6P1bJXCmJRHTJ9p9rQzBsW1wTrTuZ
         f/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wle6ftF3vYNvjHLW0AC3BqyDRZsOSFp+4C26kE+oXNI=;
        b=T3PemRssC3mJEvxEDWcdqucOwe1Ca0d3Dj/fDhssYuLqZEbeluAeGw8LDFGwxiakr2
         4JejplGQzIwSzgxl0SoazPkLZNgtpVNpb/LAyaHjjUcnoMPRWdgW0TcgIE28qPvTmAA+
         u4u8q3S42ua4WTNDrfSu6vO7s1IyEH3PP4Y5TZ8oYyuhXaWND9JRPH2fFfZUHm2mwb1L
         gDsCY1fwhGVmdbBCbuJkBjhVDMzvfI+ltXGozOfXmaVJbwucG6Vp82kF1BTb93ZkUDRS
         IZRdWBFJrDWhtQ3fbiYJF/R3E7nqNtDoeEg016m1hXOEWnuZey6M86jR/qq7Z3+dw+a8
         fACg==
X-Gm-Message-State: APjAAAWpE8reFqsV/pIROGo9sXTdUx2etZF9voQEM4IjEUR0X8toZld6
        oC0dpkSbl9kF5RURP/+ENlF/2ze24iU=
X-Google-Smtp-Source: APXvYqz0voxn/f3QufWYlPo5x9SpuLTf4/1zYc2Olt0wOPfvGEAJCgc4QIhTRCEqksSSsNnbXxvWEQ==
X-Received: by 2002:a17:90a:1aa3:: with SMTP id p32mr6529505pjp.8.1575390256037;
        Tue, 03 Dec 2019 08:24:16 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id g10sm4052093pgh.35.2019.12.03.08.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:24:15 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/4] crypto: caam - move RNG presence check into a shared function
Date:   Tue,  3 Dec 2019 08:23:55 -0800
Message-Id: <20191203162357.21942-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203162357.21942-1-andrew.smirnov@gmail.com>
References: <20191203162357.21942-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the code to check if RNG block is instantiated into a shared
function. This will be used by commits that follow.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Tested-by: Chris Healy <cphealy@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/caamrng.c | 10 +---------
 drivers/crypto/caam/intern.h  | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e8baacaabe07..041fbd015691 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -313,19 +313,11 @@ void caam_rng_exit(void)
 int caam_rng_init(struct device *ctrldev)
 {
 	struct device *dev;
-	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int err;
 	init_done = false;
 
-	/* Check for an instantiated RNG before registration */
-	if (priv->era < 10)
-		rng_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
-			    CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT;
-	else
-		rng_inst = rd_reg32(&priv->ctrl->vreg.rng) & CHA_VER_NUM_MASK;
-
-	if (!rng_inst)
+	if (!caam_has_rng(priv))
 		return 0;
 
 	dev = caam_jr_alloc();
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c7c10c90464b..f815e1ad4608 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -104,6 +104,20 @@ struct caam_drv_private {
 #endif
 };
 
+static inline bool caam_has_rng(struct caam_drv_private *priv)
+{
+	u32 rng_inst;
+
+	/* Check for an instantiated RNG before registration */
+	if (priv->era < 10)
+		rng_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
+			    CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT;
+	else
+		rng_inst = rd_reg32(&priv->ctrl->vreg.rng) & CHA_VER_NUM_MASK;
+
+	return rng_inst;
+}
+
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 
 int caam_algapi_init(struct device *dev);
-- 
2.21.0


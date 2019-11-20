Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B65C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9D22088F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDdUz9mT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbfKTQzG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:55:06 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:42313 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732934AbfKTQzE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:55:04 -0500
Received: by mail-pj1-f67.google.com with SMTP id y21so87137pjn.9;
        Wed, 20 Nov 2019 08:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/0qBoFw4TTKJCwj76xXQwMD3BLGcsNlmJQFR+DDRRNA=;
        b=UDdUz9mT3fh3JLfcaDHJgBUryWvkc1T7GmLM3lcuS79c99g95zOF7Rt5aloYFqlcwy
         jxYJKbCAc7BWKr1rXCvcWUmWpGqPOQ0e27+Np4efMHSZOM3EM5CROH1/A5X/f6CiSATI
         pghZUtUeevwhC474FiuXyBSICastwySUBOD83gxXm0yZcnnF9baPbwr8iRLMTNThA5WF
         zGRlkYMG62uY55cMET82WgOEpqKzziAMwnImCFFvwSSkKqIspZ4Ar/YDfRemuyxZwm/t
         cZ2Ys3tmfhAyANAcJMISn+1VvJ86lrWpSpwUbUAzd1Ew2cKD6iTUIb6lhJf1Bjfh1cjA
         qEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/0qBoFw4TTKJCwj76xXQwMD3BLGcsNlmJQFR+DDRRNA=;
        b=MpP+g8ckG4sSXIaQK0wS9ZL5sTcgTtq5kJ1Xk9LDvo+6LUqarpZjAKqH2dPJlAKGnv
         QQdBz7WhFIxUPwC6wk3pYDuMYVpJTXVyeDMZ0JUK4uk0d5IW2LfWWMStpE+h+KFpIxkk
         SPteQ3N8UNsDfstnhdr/hSwiEPd26nyF/d84hpt8SawB3qp+bWTrgWWBf2NGJ+FYEaLI
         aV+n+oLCbFD+QgJq36QcxITJbmTn+P23xFc/+pFp7XyGc08sFwtT9Y2fNdHopZ5DvK4x
         I4msCZLBjixbt62lFhze7WS4Tln1KfCRzjDoegGalOldwwd7vovAL88CeW1mam+jy85s
         O64w==
X-Gm-Message-State: APjAAAVf3X3d9lF3bdcb1x1c+wUJMFunxh5NX8GhosgN9ypdiDQyVYPC
        /eN5XWHcWBB6vqQmYm0u8Ppd5qlQ
X-Google-Smtp-Source: APXvYqyEQyQ61XNqnC5MWsblBjQ18PuXlfJua/Vc7jmvlZkn2XKR51QGQok0RezaHqfv5hzsYQwR0g==
X-Received: by 2002:a17:90b:4006:: with SMTP id ie6mr5370430pjb.50.1574268901803;
        Wed, 20 Nov 2019 08:55:01 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e11sm29841483pff.104.2019.11.20.08.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 08:55:00 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] crypto: caam - move RNG presense check into a shared function
Date:   Wed, 20 Nov 2019 08:53:39 -0800
Message-Id: <20191120165341.32669-5-andrew.smirnov@gmail.com>
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

Move the code to check if RNG block is instantitated into a shared
function. This will be used by commits that follow.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
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
index 6dde8ae3cd9b..70ddfbf90ac7 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -314,19 +314,11 @@ void caam_rng_exit(void)
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


Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81869C43215
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C6A21A45
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktx0tP9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfKRPjP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:39:15 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35385 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfKRPjO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 10:39:14 -0500
Received: by mail-pj1-f66.google.com with SMTP id s8so1596909pji.2;
        Mon, 18 Nov 2019 07:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/0qBoFw4TTKJCwj76xXQwMD3BLGcsNlmJQFR+DDRRNA=;
        b=ktx0tP9pH60eN9aPZBjnRm2UpDemGEl/URXEpga/lFst4i0KLSS/7TPUFoDhxpa26M
         tvl9REv38le+PESAVwxNvfXGJaqtQeiStSzA7v1XTFUgRRtnrwERkTYwNJGbmiyUGQSe
         zeIWod/7Wkv4XNoaFePshJ2Cpn5UE/1P3HfXTLono1SYAe8qpsFI0XrOvxPyRFTA9ax+
         plmalPas1Q7pgHQW4I4netabjdvyqICftmTeJWoz6zMUqc1mP/qkGTT98mWt0WsNfwbV
         tM8N4g1WyTwQWWQmZwtMrCHn3p9GHTppbejxOcJX/GWCJmI/dECoQKbGHKfls53qZ3CB
         zGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/0qBoFw4TTKJCwj76xXQwMD3BLGcsNlmJQFR+DDRRNA=;
        b=cu2q+zl08C9iQRc7bS/oCBdMb9UCIOTR+aqocMwbHYQUVQ5soiBCYkQGQLRY5p0r19
         YCq9rkiWVMyd1LKw4ynSDi2hc29rtoPrK2PEKheKqbQcUswnLFgGPBQ1ARgdPgkgXlmI
         jt0tUlGncohxeO5j4lctEly9qyO1hJ3tI0cWOXcVSr+myV2FnLoytDWgxcwJjEMI6WJ6
         mwWuHmvBSR+E4YSvGCn1nU3a+iJLIF2GxVMYhPSRiBhg2th3x268KqmR3mMqjDbQRhUt
         A8NJnzxpMzwotYMeF5mr8j+OGQGwAH1h7GRMc07WomcBgh6NRYKiU00YoHyFwEx96Kg8
         iM1g==
X-Gm-Message-State: APjAAAVAhV8ar9iu0vGEpWPqt5WHcRYm1e0fWmI9pq84oYyFwFsiBsAe
        mj+h9CdQordabSfmShUOKAYUJBOa
X-Google-Smtp-Source: APXvYqy0vNBUrXJkTkeo2skZSf+t1BJbD6tKO8M7yWidP8uPVQ8aZk4Ndum+nXrxEmATuvgBH7Bp5A==
X-Received: by 2002:a17:902:8506:: with SMTP id bj6mr28179377plb.342.1574091552248;
        Mon, 18 Nov 2019 07:39:12 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id z7sm23573732pfr.165.2019.11.18.07.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 07:39:11 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] crypto: caam - move RNG presense check into a shared function
Date:   Mon, 18 Nov 2019 07:38:41 -0800
Message-Id: <20191118153843.28136-5-andrew.smirnov@gmail.com>
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


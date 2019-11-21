Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3780BC432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 15:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F50B206EC
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 15:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4HMEriV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUP4P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 10:56:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33762 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfKUP4P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 10:56:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay6so1770717plb.0;
        Thu, 21 Nov 2019 07:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PeJkswsv5MdRfDD9LeN9yE41isuog5/3YvnTN+SFCZ8=;
        b=c4HMEriViCyHc70sTkP8cmdtBUf72MXwhLKPeLd9tgltjaXmKn/npYLvKYIgflbLUi
         rX3UT/JIYwmQ4CzwE9Hq7iLCiMCst7znhTigyL+W0KUmmCXpxTuLWT80hzcnXh5iWOnK
         Z+8KS6rL6C/Rd/NdWwKx8/hneAVZgOzUySLZ6AFRwYZHwRB/8MVdaarBqJ7noq7GE118
         0w2cGpHOFFHZIiZMnkgDgtHNmDrxZ/MjJLZ1RHS0eaCZeSRip2vggIqWPHH3A5TyGs/P
         GfttJNlZF2Eci3VKfxa7uhFghm6kYVk4tU0/xdmceV7TknGUJbOmZnnqPElZUCJD031b
         4ddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PeJkswsv5MdRfDD9LeN9yE41isuog5/3YvnTN+SFCZ8=;
        b=oGiODGlke2h8F7DzcdyQ3UUVDeSNv0QVVX4dETHsw8IH+9PkeCvcmeZVoswVBXmJqF
         vIe5BUdXToPEXFWdt+3bB7+lj9IyTIx2XSw4kHBBJUIYhaumh4RSWZ4YgwzUAe6g+i4k
         qfKcMS9opwwjlhc24uetDfMRK7F9r4CGP3nJ/JFnTabEXX4QB4GeLzsy52piM3t8HkAo
         /IRoVgYRHgfOLhNuwDL1wujdsptyrLA85M932m7RwtZvpYTsgS4x3v4iU0X8GAJlytO5
         N9HVGCfFB2sRzWTNtXDSDREL2toM9BCnyPZaxoM5pjF0wXdDO9+R/dh449yY1yFhykmE
         CnIA==
X-Gm-Message-State: APjAAAUNToXHxVhD0ixMFxwJCWSe9bu1ixdH8SzOetlcxb6JdVFffUiF
        UE6mjL1nozG9kRz8pFgqAwVAo4sa
X-Google-Smtp-Source: APXvYqxeEzo/0PcZlntzRi+MIYxLohlS3/IMrkchPn1MhghGzSQSh7ujIJXmX35qmej4qo/IEwe/CA==
X-Received: by 2002:a17:90a:280e:: with SMTP id e14mr12301167pjd.135.1574351773721;
        Thu, 21 Nov 2019 07:56:13 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e8sm3709212pga.17.2019.11.21.07.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 07:56:12 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] crypto: caam - move RNG presence check into a shared function
Date:   Thu, 21 Nov 2019 07:55:52 -0800
Message-Id: <20191121155554.1227-5-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191121155554.1227-1-andrew.smirnov@gmail.com>
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
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


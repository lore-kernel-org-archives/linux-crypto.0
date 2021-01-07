Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2A6C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F96B23370
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbhAGMcs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbhAGMcs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:32:48 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2CFC0612F9;
        Thu,  7 Jan 2021 04:32:08 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id n7so4752073pgg.2;
        Thu, 07 Jan 2021 04:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGU6XdrM5ip9qPogsEZz38Pcqw7Ofqtd00r2eJGcshk=;
        b=lYk3ZavHMJgM8Ipk8OB7Ok0ZGlnIVM/LIbC6sQ27jQ08uw235EsHYU3NCmQQh64oic
         LZapX+bK6uFsiDAhbqGoeYXVQj0mpyRmaSCFyzvFBZPJn8dpl6ox5aYut2p10n6K3RZf
         z83CbGkfr2xLxUXj+o4nXiEWQGyqqkkEEBxIsQweg4H2SHQuimMbEg4t0m8qNoXqB18Z
         FOYQfY4pZdrCQc5jrwNEe7+q0FUmtkhA5IeSfK2WeQWAHPiCZQ6X+8uDfdI2QMZcN2e4
         7Ae7rB46jMewbimo9JzWtX4Wc6fCsZm0gRoo/+K0pXvr48PuIasJpcErYSjrGpNmGv/o
         g00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGU6XdrM5ip9qPogsEZz38Pcqw7Ofqtd00r2eJGcshk=;
        b=OYuMJUy89DB5t9SDBQc11VV31BJ4Hdecx4iMM4uqJanPnM34dPF8AH13lCWUN7G6Cs
         Aw4PET1rvd3MXK01HEZWlbsvcVKTjLJGOKC+2bOaDnXkv5celwI16jCvM0zv9op22TGU
         OZUv7ZmAypTGRa1hvvOX+XNOd8gBjP9bBDT1tHHltrvGu0qbvHpeCt4iVy4zmYJLEPsG
         PR3qSf8rvOhQot5mNdQDMHn3qtj1A1n9sYD9ALmz8IZUoI4yofhqz3igsBp2cX1GJqY8
         z3Mwq3XKjpI5zSOweJ6YWfK7AAQZZ5dZixjHT/Lvy1zCJ5QnBJPvPKjF43px5SMrN2IJ
         SonA==
X-Gm-Message-State: AOAM533syn++mqIIUSYcxg/NtGFGVCdPnY6WImT2JHqKM/8e3EpV2V4H
        Y7v1OiDGzTbXkE9PlUqVbOE=
X-Google-Smtp-Source: ABdhPJylju+uMXysoljSokY20FN0SxpzIZsNXLjSsMk0NvlXPGCGvW2caIXxbPVqNspfC8frkKm4nw==
X-Received: by 2002:a63:f044:: with SMTP id s4mr1585524pgj.355.1610022727745;
        Thu, 07 Jan 2021 04:32:07 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:32:07 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 18/19] crypto: talitos: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:43 +0530
Message-Id: <20210107122944.16363-15-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/talitos.c | 42 ++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4fd85f31630a..be4f7dd810fd 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -403,10 +403,11 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
  * process completed requests for channels that have done status
  */
 #define DEF_TALITOS1_DONE(name, ch_done_mask)				\
-static void talitos1_done_##name(unsigned long data)			\
+static void talitos1_done_##name(struct tasklet_struct *t)		\
 {									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	struct talitos_private *priv = from_tasklet(priv, t,		\
+		done_task[0]);						\
+	struct device *dev = priv->dev;					\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 0x10000000)					\
@@ -429,11 +430,12 @@ static void talitos1_done_##name(unsigned long data)			\
 DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
 DEF_TALITOS1_DONE(ch0, TALITOS1_ISR_CH_0_DONE)
 
-#define DEF_TALITOS2_DONE(name, ch_done_mask)				\
-static void talitos2_done_##name(unsigned long data)			\
+#define DEF_TALITOS2_DONE(name, ch_done_mask, tasklet_idx)		\
+static void talitos2_done_##name(struct tasklet_struct *t)		\
 {									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
+	struct talitos_private *priv = from_tasklet(priv, t,		\
+		done_task[tasklet_idx]);				\
+	struct device *dev = priv->dev;					\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 1)						\
@@ -453,10 +455,10 @@ static void talitos2_done_##name(unsigned long data)			\
 	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
 }
 
-DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
-DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
-DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
-DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
+DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE, 0)
+DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE, 0)
+DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE, 0)
+DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE, 1)
 
 /*
  * locate current (offending) descriptor
@@ -3386,23 +3388,17 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	if (has_ftr_sec1(priv)) {
 		if (priv->num_channels == 1)
-			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos1_done_ch0);
 		else
-			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos1_done_4ch);
 	} else {
 		if (priv->irq[1]) {
-			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
-				     (unsigned long)dev);
-			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos2_done_ch0_2);
+			tasklet_setup(&priv->done_task[1], talitos2_done_ch1_3);
 		} else if (priv->num_channels == 1) {
-			tasklet_init(&priv->done_task[0], talitos2_done_ch0,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos2_done_ch0);
 		} else {
-			tasklet_init(&priv->done_task[0], talitos2_done_4ch,
-				     (unsigned long)dev);
+			tasklet_setup(&priv->done_task[0], talitos2_done_4ch);
 		}
 	}
 
-- 
2.25.1


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE7FC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AD723341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgLGJCW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgLGJCV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:02:21 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B535AC0613D3
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:44 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t37so8347527pga.7
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bcWybFW0Ro+8sR47Oi3fg+rTDgDElKicz0ep/BqaKXI=;
        b=iFLr6cVQD84XOdcT8Kh2qAJ2UxyPCdwT2MiMfkxr434r9ng7gRQnW+Gjjm+3LFQdjX
         O8jOErV8qyZ+wWGSJuWxEwm1BVNBiu8clC9dj8qheK225ngAuzYJ9mLzbc/qTzguTcg6
         wpcs8xD4Yo6S/woW19RlgENhApFdtKejdr1kOEtPuZGrU0VaAk71Z9TdGJ7weG+5dj6+
         Ww/B9mvKJV8TiJctYjwL3JMTeJHdoSBg6gpuSVJ9hKb0D575Q+kGgeLezuqZqV5x8a3I
         ojxXgQOh3jYnNrpIFh3/9ZEty+RQYDOdgwLkAahTM3VoJJnNCUw0lcMKWpf9/6ISJT3p
         q6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bcWybFW0Ro+8sR47Oi3fg+rTDgDElKicz0ep/BqaKXI=;
        b=c5Ra7/25YjWS7GSbbAkygpcmS/XubvDUJ8y5cuvvrn6nzUl4RbCpxGHShxMl0IpIpL
         keJ4VPewoWzDM8VD3Su0tZ7LZqWj+Ad8G8O/mEKByXuLHVqXLg/MTdRaZ/z3BU+fMHX6
         8oJMJtLJArn0vYdZyS2G61ztiN6yNRLWUb3MUuBa7nqWU9bnK0K6//gMQARMWvE1FB/u
         rxvi/hr6fSYwrl8bwnq3qPHeBBQziqKW9bz4uTHEnw8FOltDawfAXLXwDQzOsIvmdwf/
         0/TleJY+S/fFdGUG3tiBRdzZ7HlJT2ITMVooLz6Q7M1fL8jO09258kM4RjzxTXn0A5hw
         ww/w==
X-Gm-Message-State: AOAM531kpqn0JbFB9FZPAosACI0QZi4qgb0k1WoEibhIVh5TW0BL9UMm
        uESd8mCIRwZr+IQyitc2PT4=
X-Google-Smtp-Source: ABdhPJx+DTWuSfZMEdRqFW6QP6apGccblWe4PJLBsoGSElAl0nBpKdxuCZDqV992H721q86JMUiOVA==
X-Received: by 2002:a65:55c1:: with SMTP id k1mr11295329pgs.130.1607331704276;
        Mon, 07 Dec 2020 01:01:44 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:43 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 18/19] crypto: talitos: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:30 +0530
Message-Id: <20201207085931.661267-19-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/talitos.c | 42 ++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 66773892f665..7cc985ce0766 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -402,10 +402,11 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
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
@@ -428,11 +429,12 @@ static void talitos1_done_##name(unsigned long data)			\
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
@@ -452,10 +454,10 @@ static void talitos2_done_##name(unsigned long data)			\
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
@@ -3385,23 +3387,17 @@ static int talitos_probe(struct platform_device *ofdev)
 
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

